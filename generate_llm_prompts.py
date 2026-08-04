#!/usr/bin/env python3
"""
Generate detailed LLM synthesis prompts from pristine benchmark Terraform scenarios using OpenRouter.
Resumes from output CSV if available, saving the assembled code and skipping already-processed rows.
"""

import os
import json
import time
import requests
import pandas as pd
import numpy as np
from pathlib import Path
from tqdm import tqdm

# ── 1. Configuration ──────────────────────────────────────────────────────────
DATASET_DIR = Path('./iac_benchmark/dataset')
INPUT_CSV = DATASET_DIR / 'final_benchmark_custom.csv'  
OUTPUT_CSV = DATASET_DIR / 'final_benchmark_with_prompts.csv'

# OpenRouter Configuration
OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY", "")
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

MODEL_NAME = "deepseek/deepseek-v4-flash"  

SAVE_EVERY = 5 

if not OPENROUTER_API_KEY:
    raise ValueError("⚠️ OPENROUTER_API_KEY environment variable is not set. Please run: export OPENROUTER_API_KEY='your-key'")

# ── 2. System Instructions for Prompt Generation ─────────────────────────────
# SYSTEM_PROMPT = """You are an expert Infrastructure-as-Code (IaC) prompt engineer.
# Your task is to analyze a complete, valid Terraform template and reverse-engineer it into a comprehensive user requirement prompt.

# The generated requirement prompt will be given to another LLM to write Terraform code from scratch. Therefore, your generated requirement prompt MUST be precise and include:
# 1. High-Level Objective: What infrastructure is being provisioned?
# 2. Detailed Architectural Specifications: List all specific resources, services, and configurations required.
# 3. Inputs & Parameters: Specify necessary variables, default values, and types.
# 4. Security & Compliance Constraints: Explicitly mention required encryption, IAM roles/policies, security group rules, or access restrictions present in the code.
# 5. Deployability Constraints: Specify any LocalStack/provider constraints (e.g., specific region defaults, fake credential handling, or endpoint requirements).

# Rules:
# - DO NOT include raw Terraform code or syntax snippets in the generated user requirement prompt.
# - Write in natural language as if an enterprise architect is giving functional specs to a DevOps engineer.
# - Be precise so that the generating LLM can accurately recreate the template without missing critical resources or security rules.
# """

SYSTEM_PROMPT = """You are an expert Cloud Architect and DevOps Lead. 
Your task is to analyze a complete, valid Terraform template and reverse-engineer it into a natural, realistic user requirement prompt.

The generated requirement prompt will be given to another AI assistant to write the Terraform code from scratch. It MUST be a single cohesive paragraph following these exact guidelines:

1. Style & Tone: Write as a practitioner requesting infrastructure. Start the paragraph exactly with: "We need a Terraform template that creates..." followed by the high-level objective and its purpose.
2. Essential Infrastructure: Capture all core resources, architectures, and critical dependencies (e.g., VPCs, IAM roles, dead-letter queues) without omitting anything necessary for the architecture to function.
3. Balance Specificity & Flexibility: Specify resource counts, exact metric thresholds (e.g., 80% CPU, $10 billing limit), and architectural patterns (e.g., cross-AZ). Avoid overly prescriptive implementation details (do not dictate internal Terraform module structures or specific HCL syntax).
4. Hardcoded Values: You MUST extract and explicitly state any specific image IDs (AMIs), URLs, email addresses, or dummy credential values present in the code that are strictly necessary to deploy the resources successfully. Include them naturally in the text (e.g., "For the endpoint URL, use 'www.testanu.com'").
5. Security & Constraints: Mention required encryption, IAM least-privilege policies, security groups, or specific networking rules (e.g., public vs private subnets).

Output Rules:
- DO NOT use bullet points, numbered lists, or markdown formatting. 
- DO NOT include raw Terraform code or syntax.
- Write exactly ONE well-structured paragraph that reads like a real-world Jira ticket.
"""

# ── 3. Helper Functions ───────────────────────────────────────────────────────
def assemble_terraform_code(folder_path_str: str) -> str:
    """Reads and concatenates all .tf files in the scenario directory."""
    folder = Path(folder_path_str)
    if not folder.exists():
        return ""
    
    tf_files = sorted(folder.glob("*.tf"))
    if not tf_files:
        return ""
    
    combined = []
    for tf in tf_files:
        content = tf.read_text(encoding="utf-8", errors="ignore").strip()
        if content:
            combined.append(f"// File: {tf.name}\n{content}")
            
    return "\n\n".join(combined)

def call_openrouter(tf_code: str, retries: int = 3) -> str:
    """Calls OpenRouter API to generate the user prompt requirement."""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/iac-benchmark", 
        "X-Title": "IaC Benchmark Prompt Generator"
    }
    
    user_content = f"Here is the reference Terraform template:\n\n```hcl\n{tf_code}\n```\n\nGenerate the complete, detailed user requirement prompt."
    
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_content}
        ],
        "temperature": 0.2, 
        "max_tokens": 1500
    }
    
    for attempt in range(retries):
        try:
            response = requests.post(OPENROUTER_URL, headers=headers, json=payload, timeout=60)
            if response.status_code == 200:
                data = response.json()
                return data["choices"][0]["message"]["content"].strip()
            elif response.status_code == 429:
                time.sleep(5 * (attempt + 1))
            else:
                print(f"\n API Error ({response.status_code}): {response.text}")
                time.sleep(2)
        except Exception as e:
            print(f"\n Request exception: {e}")
            time.sleep(2)
            
    return ""

# ── 4. Main Processing Loop ───────────────────────────────────────────────────
def main():
    # Load from output CSV if it exists to resume, otherwise load the clean benchmark
    if OUTPUT_CSV.exists():
        df = pd.read_csv(OUTPUT_CSV)
        print(f"✅ Loaded existing progress from {OUTPUT_CSV} ({len(df)} scenarios).")
    elif INPUT_CSV.exists():
        df = pd.read_csv(INPUT_CSV)
        print(f"✅ Starting fresh from {INPUT_CSV} ({len(df)} scenarios).")
    else:
        raise FileNotFoundError(f"⚠️ Neither {OUTPUT_CSV} nor {INPUT_CSV} were found.")

    # Ensure required columns exist
    if 'tf_code' not in df.columns:
        df['tf_code'] = None
    if 'user_prompt' not in df.columns:
        df['user_prompt'] = None

    records = df.to_dict('records')
    new_count = 0
    
    for rec in tqdm(records, desc="Processing Scenarios"):
        # 1. Assemble full Terraform code if it hasn't been saved yet
        if pd.isna(rec.get('tf_code')) or not str(rec.get('tf_code')).strip():
            rec['tf_code'] = assemble_terraform_code(rec['folder_path'])
            
        # 2. Check if we need to generate a prompt
        current_prompt = str(rec.get('user_prompt', '')).strip()
        needs_prompt = (
            current_prompt == '' or 
            current_prompt == 'nan' or 
            current_prompt == 'None' or 
            current_prompt.startswith('ERROR:')
        )
        
        if needs_prompt:
            if not rec['tf_code']:
                rec['user_prompt'] = "ERROR: Missing or empty Terraform source files."
            else:
                prompt_result = call_openrouter(rec['tf_code'])
                rec['user_prompt'] = prompt_result if prompt_result else "ERROR: LLM generation failed."

            new_count += 1
            
            # Periodically flush to disk
            if new_count % SAVE_EVERY == 0:
                pd.DataFrame(records).to_csv(OUTPUT_CSV, index=False)

    # Final save
    pd.DataFrame(records).to_csv(OUTPUT_CSV, index=False)
    
    if new_count > 0:
        print(f"\n🎉 Processed {new_count} scenarios! Output saved to: {OUTPUT_CSV}")
    else:
        print(f"\n✅ All scenarios already have generated prompts. Output is up to date at: {OUTPUT_CSV}")

if __name__ == "__main__":
    main()