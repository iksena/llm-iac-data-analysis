#!/usr/bin/env python3
"""
tf_prompt_repair.py
=====================
Rewrites `user_prompt` for every row flagged by tf_prompt_rubric_review.py,
using the flagged reasons as targeted repair feedback. 
"""

import argparse
import os
import re
import time
from pathlib import Path

import pandas as pd
import requests
from dotenv import load_dotenv
from tqdm import tqdm

load_dotenv()

DATASET_CSV = Path("iac_benchmark/dataset/final_benchmark_with_prompts.csv")
REVIEW_CSV = Path("iac_benchmark/dataset/tf_prompt_review_final.csv")

OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY", "")
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-v4-flash"

SAVE_EVERY = 5

if not OPENROUTER_API_KEY:
    raise ValueError("OPENROUTER_API_KEY environment variable is not set.")

BASE_STYLE = """You are an expert Cloud Architect and DevOps Lead.
Your task is to rewrite a natural-language user requirement prompt that was reverse-engineered from a ground-truth Terraform template, fixing specific defects a rubric reviewer flagged, while preserving everything about the prompt that already works.

The rewritten prompt MUST be a single cohesive paragraph following these guidelines:
1. Style & Tone: Write as a DevOps engineer creating a task ticket. Start the paragraph exactly with: "We need a Terraform template that creates..."
2. High-Level Intent & Inference Space: emphasize the core objective; do not over-specify standard supporting resources or secondary implementation details unless load-bearing.
3. Essential Parameters & Hardcoded Values: only state parameters strictly necessary to prevent deployment failure. The AWS region MUST be generalized or explicitly set to `us-east-1`. If the feedback flags a non-default region (e.g., `eu-west-1`, `us-west-2`), you MUST change it to `us-east-1` or remove the region mention entirely.
4. Scale Detail by Difficulty: Level 1-2 stay to 1-3 short sentences; higher levels detail primary structural components while generalizing secondary security/ACL rules.
5. Faithfulness: every stated behavior/action/threshold must match the ground truth's actual effect exactly.
6. Self-containment: never phrase the prompt as if an external AWS resource, IAM role/user, secret, or account-level dependency already exists unless it is a genuinely global/public AWS-owned resource. If the feedback flags the word 'existing', you MUST rewrite the requirement to explicitly say "create a new [resource]" or "provision a [resource]".
7. Reference durability: If the ground truth hardcodes specific Availability Zones (e.g., `eu-west-1a`) or AMIs (e.g., `ami-12345`), you MUST rewrite the prompt to describe them dynamically (e.g., 'use the first available availability zone', or 'dynamically fetch the latest Ubuntu 22.04 AMI'). DO NOT leak the Terraform solution/syntax to the user (e.g., absolutely NEVER write `data "aws_ami"` or `data.aws_availability_zones` in the prompt). If the feedback flags a literal IP address (e.g., 8.8.8.8) or a specific ephemeral URL, replace it with a generic description like "standard public DNS servers" or "a sample web endpoint".
8. Never truncate. The paragraph must always end on a complete sentence with terminal punctuation.

Output Rules:
- Write exactly ONE well-structured, GRAMMATICALLY COMPLETE paragraph that ends with a period.
- DO NOT use bullet points, numbered lists, markdown formatting, or raw HCL syntax.
- Use plain standard ASCII quotes (") only.
- Output ONLY the rewritten paragraph, nothing else - no preamble, no explanation, no markdown fences.
"""


def build_feedback(row: pd.Series) -> str:
    parts = []
    if str(row.get("leak_severity", "none")) not in ("none", "nan"):
        parts.append(f"- Solution leakage ({row['leak_severity']}): {row.get('leak_reasons', '')}")
    if bool(row.get("missing_essential_info", False)):
        parts.append(f"- Missing essential info: {row.get('missing_reasons', '')}")
    if str(row.get("difficulty_fit", "appropriate")) not in ("appropriate", "nan"):
        parts.append(f"- Difficulty fit issue ({row['difficulty_fit']}): adjust level of detail to match difficulty {row.get('difficulty')}.")
    if bool(row.get("assumes_external_dependency", False)):
        parts.append(f"- Assumes external dependency (must be self-contained instead): {row.get('external_dependency_reasons', '')}")
    if bool(row.get("stale_reference_risk", False)):
        parts.append(f"- Stale/non-durable literal reference: {row.get('stale_reference_reasons', '')}")
    notes = row.get("notes", "")
    if notes and str(notes) != "nan":
        parts.append(f"- Reviewer notes: {notes}")
    if not parts:
        parts.append("- General quality pass requested; tighten wording and verify faithfulness against the ground truth.")
    return "\n".join(parts)


def call_repair(current_prompt: str, tf_code: str, difficulty, feedback: str, retries: int = 5) -> str:
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/iac-benchmark",
        "X-Title": "TF Benchmark Prompt Repair",
    }
    user_content = (
        f"Scenario Difficulty Level: {difficulty}\n\n"
        f"Current prompt:\n\"\"\"\n{current_prompt}\n\"\"\"\n\n"
        f"Flagged defects to fix:\n{feedback}\n\n"
        f"Ground-truth Terraform template:\n```hcl\n{tf_code}\n```\n\n"
        "Rewrite the prompt, fixing only the flagged defects."
    )
    token_budgets = [1000, 2000, 4000]

    for attempt in range(retries):
        max_tokens = token_budgets[min(attempt, len(token_budgets) - 1)]
        try:
            response = requests.post(
                OPENROUTER_URL,
                headers=headers,
                json={
                    "model": MODEL_NAME,
                    "messages": [
                        {"role": "system", "content": BASE_STYLE},
                        {"role": "user", "content": user_content},
                    ],
                    "temperature": 0.2,
                    "max_tokens": max_tokens,
                },
                timeout=90,
            )
            if response.status_code == 200:
                choice = response.json()["choices"][0]
                content = choice.get("message", {}).get("content")
                finish_reason = choice.get("finish_reason")
                if not content:
                    time.sleep(2 * (attempt + 1))
                    continue
                text = content.strip()
                text = re.sub(r"^```(?:text)?\s*|\s*```$", "", text, flags=re.MULTILINE).strip()
                if finish_reason == "length" or (text and text[-1] not in ".!?\"'"):
                    time.sleep(1)
                    continue
                return text
            elif response.status_code == 429:
                time.sleep(5 * (attempt + 1))
            else:
                print(f"\nAPI error ({response.status_code}): {response.text[:300]}")
                time.sleep(2 * (attempt + 1))
        except Exception as exc:
            print(f"\nRequest exception: {exc}")
            time.sleep(2 * (attempt + 1))

    return ""


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--scenario-ids", type=str, default="", help="Comma-separated scenario_ids to repair.")
    args = parser.parse_args()

    bench = pd.read_csv(DATASET_CSV)
    review = pd.read_csv(REVIEW_CSV)

    review_failed = review["notes"].astype(str).str.contains("Review call failed", na=False)

    if args.scenario_ids.strip():
        ids = set(x.strip() for x in args.scenario_ids.split(",") if x.strip())
        target = review[review["scenario_id"].isin(ids) & ~review_failed]
    else:
        flagged = (
            (review["critical_defect"] == True)  
            | (review["leak_severity"] != "none")
            | (review["missing_essential_info"] == True)  
            | (review["difficulty_fit"] != "appropriate")
            | (review["assumes_external_dependency"] == True)  
            | (review["stale_reference_risk"] == True)  
        )
        target = review[flagged & ~review_failed]

    if review_failed.any() and args.scenario_ids.strip() == "":
        print(f"Skipping {review_failed.sum()} rows that failed the review call itself (re-run the reviewer for those).")

    print(f"Repairing {len(target)} flagged rows...")

    bench = bench.set_index("scenario_id")
    updated = 0
    for _, row in tqdm(list(target.iterrows()), desc="Repairing prompts"):
        sid = row["scenario_id"]
        if sid not in bench.index:
            continue
        bench_row = bench.loc[sid]
        feedback = build_feedback(row)
        new_prompt = call_repair(bench_row["user_prompt"], bench_row["tf_code"], bench_row["difficulty"], feedback)
        if new_prompt:
            bench.at[sid, "user_prompt"] = new_prompt
            updated += 1
        if updated % SAVE_EVERY == 0 and updated > 0:
            bench.reset_index().to_csv(DATASET_CSV, index=False)

    bench.reset_index().to_csv(DATASET_CSV, index=False)
    print(f"\nRepaired {updated} / {len(target)} rows. Saved to {DATASET_CSV}")


if __name__ == "__main__":
    main()