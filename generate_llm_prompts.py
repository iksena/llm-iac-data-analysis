#!/usr/bin/env python3
"""
generate_llm_prompts.py
========================
Generate detailed LLM synthesis prompts from benchmark Terraform scenarios using OpenRouter.
Operates directly on `final_benchmark_with_prompts.csv`, backfilling only rows where
`user_prompt` is missing, empty, or flagged with an ERROR string.
"""

import os
import json
import time
import requests
import pandas as pd
import numpy as np
from pathlib import Path
from tqdm import tqdm
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file if present

# ── 1. Configuration ──────────────────────────────────────────────────────────
DATASET_DIR = Path('./iac_benchmark/dataset')
PROMPTS_CSV = DATASET_DIR / 'final_benchmark_with_prompts.csv'
CUSTOM_FALLBACK_CSV = DATASET_DIR / 'final_benchmark_custom.csv'

# OpenRouter Configuration
OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY", "")
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"

MODEL_NAME = "deepseek/deepseek-v4-flash"  
SAVE_EVERY = 5 

if not OPENROUTER_API_KEY:
    raise ValueError("⚠️ OPENROUTER_API_KEY environment variable is not set. Please run: export OPENROUTER_API_KEY='your-key'")

# ── 2. System Instructions for Prompt Generation (Unified Rubric) ─────────────
SYSTEM_PROMPT = """You are an expert Cloud Architect and DevOps Lead. 
Your task is to analyze a complete, valid Terraform template and reverse-engineer it into a natural, realistic user requirement prompt that tests an AI assistant's ability to infer IaC requirements.

The generated requirement prompt MUST be a single cohesive paragraph following these guidelines:

1. Style & Tone: Write as a DevOps engineer creating a task ticket. Start the paragraph exactly with: "We need a Terraform template that creates..."
2. High-Level Intent & Inference Space:
   - Emphasize the core objective and high-level purpose (e.g., "for testing purposes", "to host a static website").
   - DO NOT over-specify standard supporting resources or secondary implementation details (e.g., IAM admin policies, detailed security group rules, CloudFront origin settings, route tables, or output blocks). Allow the AI assistant space to infer these best practices on its own.
3. Essential Parameters & Region/AZ/Image Genericity:
   - Only explicitly state parameters strictly necessary to prevent deployment failure (e.g., required default variable values, key aliases, specific VPC CIDRs/subnet allocations).
   - The AWS region MUST default to `us-east-1` or remain completely generic. Omit or generalize non-standard regions (e.g., `eu-west-1`, `ap-southeast-2`).
   - Describe Availability Zones generically (e.g., "the first available availability zone in the region") rather than hardcoding specific AZ strings (e.g., `us-east-1a`).
   - Describe Machine Images generically (e.g., "the latest Amazon Linux 2 AMI", "the latest Ubuntu 22.04 AMI") rather than stating pinned AMI IDs (e.g., `ami-0123456789abcdef0`).
   - DO NOT leak Terraform solution or HCL data-source syntax in the prompt (e.g., NEVER write `data "aws_ami"` or `data.aws_availability_zones`).
4. Self-Containment & External Dependencies:
   - Never phrase the prompt as if an external AWS account resource, IAM role/user, secret, or VPC already exists. Always instruct the agent to create all required dependencies as part of a self-contained stack.
5. Reference Durability & Literal Values:
   - Replace literal IP addresses (e.g., `8.8.8.8`) or ephemeral URLs with generic descriptions (e.g., "standard public DNS servers", "a sample web endpoint").
6. Scale Detail by Complexity:
   - Simple/Single-Resource (Easy, Level 1-2): Keep the prompt to 1-2 short sentences covering the main goal and any required key names/aliases.
   - Multi-Resource/VPCs (Complex, Level 3-5): Detail primary structural components (subnets, CIDRs, module composition) while generalizing secondary security/ACL rules.
7. Faithfulness & Truncation:
   - Every stated behavior, action, or threshold (e.g., "block" vs "count", "allow" vs "deny") MUST match the ground-truth template's actual effect exactly.
   - Never truncate. The paragraph must always end on a complete sentence with terminal punctuation.

Output Rules:
- Write exactly ONE well-structured, GRAMMATICALLY COMPLETE paragraph that ends with a period.
- DO NOT use bullet points, numbered lists, markdown formatting, or raw HCL syntax.
- Use plain standard ASCII quotes (") only—avoid smart/curly quotes to prevent encoding issues.
- Output ONLY the requirement paragraph, nothing else.
"""

# ── 3. Helper Functions ───────────────────────────────────────────────────────
def assemble_terraform_code(folder_path_str: str) -> str:
    """Reads and concatenates all .tf files in the scenario directory."""
    if not folder_path_str or pd.isna(folder_path_str):
        return ""

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

def call_openrouter(tf_code: str, difficulty: str, retries: int = 3) -> str:
    """Calls OpenRouter API to generate the user prompt requirement."""
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/iac-benchmark", 
        "X-Title": "IaC Benchmark Prompt Generator"
    }
    
    user_content = f"Scenario Difficulty Level: {difficulty}\n\nHere is the reference Terraform template:\n\n```hcl\n{tf_code}\n```\n\nGenerate the complete, detailed user requirement prompt."
    token_budgets = [1000, 2000, 4000]

    for attempt in range(retries):
        max_tokens = token_budgets[min(attempt, len(token_budgets) - 1)]
        payload = {
            "model": MODEL_NAME,
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": user_content}
            ],
            "temperature": 0.2,
            "max_tokens": max_tokens
        }
        try:
            response = requests.post(OPENROUTER_URL, headers=headers, json=payload, timeout=60)
            if response.status_code == 200:
                data = response.json()
                choice = data["choices"][0]
                text = choice["message"]["content"].strip()
                finish_reason = choice.get("finish_reason")
                
                # Reject truncated output outright
                if finish_reason == "length" or (text and text[-1] not in ".!?\"'"):
                    print(f"\n Truncated output (finish_reason={finish_reason}, max_tokens={max_tokens}); retrying with more headroom.")
                    continue
                return text
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
    # Load strictly from final_benchmark_with_prompts.csv
    if PROMPTS_CSV.exists():
        df = pd.read_csv(PROMPTS_CSV)
        print(f"✅ Loaded benchmark dataset directly from {PROMPTS_CSV} ({len(df)} scenarios).")
    elif CUSTOM_FALLBACK_CSV.exists():
        df = pd.read_csv(CUSTOM_FALLBACK_CSV)
        print(f"⚠️ {PROMPTS_CSV.name} not found. Fallback: starting fresh from {CUSTOM_FALLBACK_CSV} ({len(df)} scenarios).")
    else:
        raise FileNotFoundError(f"⚠️ Neither {PROMPTS_CSV} nor {CUSTOM_FALLBACK_CSV} were found.")

    # Ensure required columns exist
    if 'tf_code' not in df.columns:
        df['tf_code'] = None
    if 'user_prompt' not in df.columns:
        df['user_prompt'] = None

    # Check for scenarios flagged for forced regeneration
    force_regen_folders = set()
    force_regen_path = DATASET_DIR / 'rows_to_regenerate.csv'
    if force_regen_path.exists():
        force_regen_df = pd.read_csv(force_regen_path)
        folder_col = 'folder_path' if 'folder_path' in force_regen_df.columns else 'ground_truth_path'
        if folder_col in force_regen_df.columns:
            force_regen_folders = set(force_regen_df[folder_col])
            print(f"⚠️  {len(force_regen_folders)} rows flagged for forced regeneration from {force_regen_path.name}")

    records = df.to_dict('records')
    new_count = 0
    
    for rec in tqdm(records, desc="Processing Scenarios"):
        # 1. Assemble full Terraform code if missing
        if pd.isna(rec.get('tf_code')) or not str(rec.get('tf_code')).strip():
            rec['tf_code'] = assemble_terraform_code(rec.get('folder_path'))
            
        # 2. Check if prompt is missing or requires regeneration
        current_prompt = str(rec.get('user_prompt', '')).strip()
        needs_prompt = (
            current_prompt == '' or 
            current_prompt == 'nan' or 
            current_prompt == 'None' or 
            current_prompt.startswith('ERROR:') or
            rec.get('folder_path') in force_regen_folders
        )
        
        if needs_prompt:
            if not rec['tf_code']:
                rec['user_prompt'] = "ERROR: Missing or empty Terraform source files."
            else:
                diff_level = str(rec.get('difficulty', 'Unspecified'))
                prompt_result = call_openrouter(rec['tf_code'], diff_level)
                rec['user_prompt'] = prompt_result if prompt_result else "ERROR: LLM generation failed."

            new_count += 1
            
            # Periodically flush progress in-place
            if new_count % SAVE_EVERY == 0:
                pd.DataFrame(records).to_csv(PROMPTS_CSV, index=False)

    # Final save in-place to final_benchmark_with_prompts.csv
    pd.DataFrame(records).to_csv(PROMPTS_CSV, index=False)
    
    if new_count > 0:
        print(f"\n🎉 Generated/repaired {new_count} scenario prompts! Output saved to: {PROMPTS_CSV}")
    else:
        print(f"\n✅ All scenarios already have generated prompts. Output is up to date at: {PROMPTS_CSV}")

if __name__ == "__main__":
    main()