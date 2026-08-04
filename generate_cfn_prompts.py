#!/usr/bin/env python3
"""
Generate detailed LLM synthesis prompts from pristine benchmark CloudFormation scenarios using OpenRouter.
Resumes from output CSV if available, saving the template code and skipping already-processed rows.
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
BASE_DIR = Path('./cfn_benchmark')
DATASET_DIR = BASE_DIR / 'dataset'

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
SYSTEM_PROMPT = """You are an expert Cloud Architect and DevOps Lead. 
Your task is to analyze a complete, valid AWS CloudFormation template and reverse-engineer it into a natural, realistic user requirement prompt.

The generated requirement prompt will be given to another AI assistant to write the CloudFormation code from scratch. It MUST be a single cohesive paragraph following these exact guidelines:

1. Style & Tone: Write as a practitioner requesting infrastructure. Start the paragraph exactly with: "We need a CloudFormation template that creates..." followed by the high-level objective and its purpose.
2. Essential Infrastructure: Capture all core resources, architectures, and critical dependencies (e.g., VPCs, IAM roles, dead-letter queues, conditions, outputs) without omitting anything necessary for the architecture to function.
3. Balance Specificity & Flexibility: Specify resource counts, exact metric thresholds (e.g., 80% CPU, $10 billing limit), and architectural patterns (e.g., cross-AZ). Avoid overly prescriptive implementation details (do not dictate internal YAML/JSON structures, specific DependsOn clauses, or explicit Ref/GetAtt syntax unless conceptually necessary).
4. Hardcoded Values: You MUST extract and explicitly state any specific image IDs (AMIs), URLs, email addresses, or dummy credential values present in the code that are strictly necessary to deploy the resources successfully. Include them naturally in the text (e.g., "For the endpoint URL, use 'www.testanu.com'").
5. Security & Constraints: Mention required encryption, IAM least-privilege policies, security groups, or specific networking rules (e.g., public vs private subnets).

Output Rules:
- DO NOT use bullet points, numbered lists, or markdown formatting. 
- DO NOT include raw CloudFormation code, YAML, or JSON snippets.
- Write exactly ONE well-structured paragraph that reads like a real-world Jira ticket.
"""

# ── 3. Helper Functions ───────────────────────────────────────────────────────
def read_cfn_template(dest_file_str: str) -> str:
    """Reads the canonical CloudFormation template file."""
    if not dest_file_str or pd.isna(dest_file_str):
        return ""
        
    file_path = BASE_DIR / dest_file_str
    if not file_path.exists():
        return ""
    
    return file_path.read_text(encoding="utf-8", errors="ignore").strip()

def call_openrouter(cfn_code: str, retries: int = 3) -> str:
    """Calls OpenRouter API to generate the user prompt requirement."""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/iac-benchmark", 
        "X-Title": "IaC Benchmark Prompt Generator"
    }
    
    user_content = f"Here is the reference CloudFormation template:\n\n```yaml\n{cfn_code}\n```\n\nGenerate the complete, detailed user requirement prompt."
    
    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": SYSTEM_PROMPT},
            {"role": "user", "content": user_content}
        ],
        "temperature": 0.2, 
        "max_tokens": 1000
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
    if 'cfn_code' not in df.columns:
        df['cfn_code'] = None
    if 'user_prompt' not in df.columns:
        df['user_prompt'] = None

    records = df.to_dict('records')
    new_count = 0
    
    for rec in tqdm(records, desc="Processing Scenarios"):
        # 1. Read full CloudFormation code if it hasn't been saved yet
        if pd.isna(rec.get('cfn_code')) or not str(rec.get('cfn_code')).strip():
            # Use 'dest_file' created in cell 5c of the CFN pipeline
            rec['cfn_code'] = read_cfn_template(rec.get('dest_file'))
            
        # 2. Check if we need to generate a prompt
        current_prompt = str(rec.get('user_prompt', '')).strip()
        needs_prompt = (
            current_prompt == '' or 
            current_prompt == 'nan' or 
            current_prompt == 'None' or 
            current_prompt.startswith('ERROR:')
        )
        
        if needs_prompt:
            if not rec['cfn_code']:
                rec['user_prompt'] = "ERROR: Missing or empty CloudFormation template file."
            else:
                prompt_result = call_openrouter(rec['cfn_code'])
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
