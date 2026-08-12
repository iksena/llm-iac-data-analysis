#!/usr/bin/env python3
"""
tf_prompt_rubric_review.py
===========================
LLM-judged rubric review of the Terraform benchmark's `user_prompt` column
against the paired ground-truth `tf_code`.
"""

import argparse
import json
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
OUTPUT_CSV = Path("iac_benchmark/dataset/tf_prompt_review_final.csv")

OPENROUTER_API_KEY = os.environ.get("OPENROUTER_API_KEY", "")
OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions"
MODEL_NAME = "deepseek/deepseek-v4-flash"

SAVE_EVERY = 5
MAX_CODE_CHARS = 60000

if not OPENROUTER_API_KEY:
    raise ValueError("OPENROUTER_API_KEY environment variable is not set.")

RUBRIC_SYSTEM = """You are auditing a natural-language "user requirement" prompt that was reverse-engineered from a ground-truth Terraform template. The prompt will be handed to an independent AI coding agent, which must write its own Terraform template satisfying it, with no access to the ground truth. Judge the prompt against the ground-truth Terraform code using these rules:

1. Solution leakage (bad): the prompt must not contain verbatim Terraform resource/data/variable/output identifiers or addresses (e.g. "aws_instance.web", "module.vpc.id"), raw HCL syntax or blocks, Terraform interpolation syntax (${...}, var.x, local.x, data.x.y), or Terraform-specific argument/block jargon copied straight from the template. A business-facing name a human would naturally pick is fine even if it happens to equal a resource's local name.
2. Necessary detail (must keep): any variable default, hardcoded value (CIDR, alias, name, non-default region), or configuration choice that is load-bearing for deployability or central to the template's functional objective MUST be stated. Omitting it is a real defect (under-specification), not a virtue.
3. Inference space (should generalize): secondary/supporting details a competent engineer could infer (detailed IAM policy statements, security-group/NACL specifics, route-table wiring, output blocks, tagging schemes) should be omitted UNLESS load-bearing or the explicit point of the exercise.
4. Difficulty scaling: Level 1 prompts should read as 1-2 short sentences. Higher levels track more structural detail while still generalizing secondary security/ACL specifics.
5. Hygiene: no mojibake, no markdown/bullet lists, no raw code, plain ASCII quotes only, must end on a complete sentence.
6. Failure rows: a literal "ERROR: ..." user_prompt is always a critical defect.
7. Faithfulness: any stated action/behavior/threshold (block vs count, allow vs deny, encrypted vs not, versioned vs not, public vs private, sync vs async, etc.) must match the ground truth's actual effect.
8. Self-containment (bad if violated): the prompt must not assume any pre-existing AWS account resource, IAM role/user/policy, secret, environment variable, or other out-of-band dependency that the agent has no way to create itself. 
9. Region/AZ/image genericity: The prompt must default to the `us-east-1` region or leave the AWS region completely generic. Non-default regions MUST be flagged. Hardcoded Availability Zones (e.g., `eu-west-1a`) must NOT be present in the prompt; they must be generalized. Prefer describing an image generically (e.g. 'the latest Amazon Linux 2 AMI') over an opaque pinned AMI ID. Under NO circumstances should the prompt leak the HCL syntax to achieve this (e.g., never write `data "aws_ami"`).
10. Future durability of literal URLs/image references: any literal URL, container image reference, or AMI ID stated in the prompt should either be a value that will remain valid/resolvable for the foreseeable future, or, if it is a narrowly-pinned/ephemeral value, it should be omitted from the prompt rather than stated verbatim.

Return exactly one JSON object, no markdown fences, no extra text, with these keys:
{
  "leak_severity": "none | minor | major",
  "leak_reasons": ["short strings"],
  "missing_essential_info": true | false,
  "missing_reasons": ["short strings"],
  "difficulty_fit": "appropriate | too_detailed_for_level | too_sparse_for_level",
  "assumes_external_dependency": true | false,
  "external_dependency_reasons": ["short strings"],
  "stale_reference_risk": true | false,
  "stale_reference_reasons": ["short strings"],
  "critical_defect": true | false,
  "notes": "one short sentence"
}
critical_defect must be true whenever leak_severity is "major", missing_essential_info is true, there is a faithfulness mismatch (rule 7), the prompt is a literal ERROR string, assumes_external_dependency is true, or stale_reference_risk is true for a reference that is not central to the template's intent. Otherwise false."""


def call_reviewer(user_prompt: str, tf_code: str, difficulty, retries: int = 6) -> dict:
    headers = {
        "Authorization": f"Bearer {OPENROUTER_API_KEY}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://github.com/iac-benchmark",
        "X-Title": "TF Benchmark Prompt Rubric Review",
    }
    code = tf_code if len(tf_code) <= MAX_CODE_CHARS else tf_code[:MAX_CODE_CHARS] + "\n...[TRUNCATED]..."
    
    # Deterministic Pre-Screening for literals that violate the rules
    import re
    re_existing = re.compile(r'\b(existing|pre-existing|already exists)\b', re.IGNORECASE)
    re_ip = re.compile(r'\b(?:\d{1,3}\.){3}\d{1,3}\b')
    re_az = re.compile(r'\b[a-z]{2}-(?:east|west|central|north|south|northeast|southeast|southwest)-\d[a-z]\b', re.IGNORECASE)
    re_non_default_region = re.compile(r'\b(?!(?:us-east-1)\b)[a-z]{2}-(?:east|west|central|north|south|northeast|southeast|southwest)-\d\b', re.IGNORECASE)
    re_ami = re.compile(r'\bami-[a-f0-9]{8,17}\b', re.IGNORECASE)
    
    hard_flags = []
    if re_existing.search(user_prompt):
        hard_flags.append("The prompt explicitly uses the word 'existing' or 'pre-existing'.")
    if re_ip.search(user_prompt):
        hard_flags.append("The prompt contains a literal IP address.")
    if re_az.search(user_prompt):
        hard_flags.append("The prompt contains a hardcoded Availability Zone (e.g., us-east-1a).")
    if re_non_default_region.search(user_prompt):
        hard_flags.append("The prompt specifies a non-default AWS region (must be us-east-1 or completely generic).")
    if re_ami.search(user_prompt):
        hard_flags.append("The prompt contains a hardcoded AMI ID (ami-...).")
        
    system_instruction_addendum = ""
    if hard_flags:
        system_instruction_addendum = (
            f"\n\nWARNING: The following deterministic violations were found in the prompt: "
            f"{' '.join(hard_flags)}. You MUST flag `assumes_external_dependency` or "
            f"`stale_reference_risk` as TRUE depending on the violation, unless they refer to strictly standard AWS global endpoints."
        )

    user_content = (
        f"Difficulty level: {difficulty}\n\n"
        f"Prompt to review:\n\"\"\"\n{user_prompt}\n\"\"\"\n\n"
        f"Ground-truth Terraform code:\n```hcl\n{code}\n```\n\n"
        f"{system_instruction_addendum}\n"
        "Return only the JSON verdict object."
    )

    token_budgets = [1200, 2000, 3000, 4000]

    for attempt in range(retries):
        max_tokens = token_budgets[min(attempt, len(token_budgets) - 1)]
        try:
            response = requests.post(
                OPENROUTER_URL,
                headers=headers,
                json={
                    "model": MODEL_NAME,
                    "messages": [
                        {"role": "system", "content": RUBRIC_SYSTEM},
                        {"role": "user", "content": user_content},
                    ],
                    "temperature": 0.0,
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
                text = re.sub(r"^```(?:json)?\s*|\s*```$", "", text, flags=re.MULTILINE).strip()
                match = re.search(r"\{.*\}", text, re.DOTALL)
                if match:
                    text = match.group(0)
                try:
                    return json.loads(text)
                except json.JSONDecodeError as exc:
                    print(f"\nJSON parse failed (finish_reason={finish_reason}): {exc}; retrying with more headroom.")
                    time.sleep(2 * (attempt + 1))
                    continue
            elif response.status_code == 429:
                time.sleep(5 * (attempt + 1))
            else:
                print(f"\nAPI error ({response.status_code}): {response.text[:300]}")
                time.sleep(2 * (attempt + 1))
        except Exception as exc:
            print(f"\nRequest exception: {exc}")
            time.sleep(2 * (attempt + 1))

    return {
        "leak_severity": "unknown",
        "leak_reasons": ["review_failed"],
        "missing_essential_info": False,
        "missing_reasons": [],
        "difficulty_fit": "unknown",
        "assumes_external_dependency": False,
        "external_dependency_reasons": [],
        "stale_reference_risk": False,
        "stale_reference_reasons": [],
        "critical_defect": True,
        "notes": "Review call failed after retries.",
    }


def join_list(v):
    if isinstance(v, list):
        return "; ".join(str(x) for x in v)
    return v if v else ""


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--rerun", type=str, default="", help="Comma-separated scenario_ids to force re-review.")
    parser.add_argument("--rerun-flagged", action="store_true", help="Re-review every currently-flagged row.")
    args = parser.parse_args()

    bench = pd.read_csv(DATASET_CSV)

    if OUTPUT_CSV.exists():
        review = pd.read_csv(OUTPUT_CSV)
        # BUG FIX: Ensure the index is strictly unique before building the dictionary
        review = review.drop_duplicates(subset=["scenario_id"], keep="last")
        print(f"Loaded existing review ({len(review)} rows) from {OUTPUT_CSV}")
    else:
        review = pd.DataFrame(columns=[
            "scenario_id", "dest_file", "difficulty", "n_resources", "n_params", "loc",
            "user_prompt", "leak_severity", "leak_reasons", "missing_essential_info",
            "missing_reasons", "difficulty_fit", "assumes_external_dependency",
            "external_dependency_reasons", "stale_reference_risk", "stale_reference_reasons",
            "critical_defect", "notes",
        ])

    reviewed_ids = set(review["scenario_id"]) if not review.empty else set()

    force_ids = set(x.strip() for x in args.rerun.split(",") if x.strip())
    if args.rerun_flagged and not review.empty:
        flagged = review[
            (review["critical_defect"] == True) 
            | (review["leak_severity"] != "none")
            | (review["missing_essential_info"] == True) 
            | (review["difficulty_fit"] != "appropriate")
            | (review["assumes_external_dependency"] == True) 
            | (review["stale_reference_risk"] == True) 
        ]
        force_ids |= set(flagged["scenario_id"])

    records = review.set_index("scenario_id").to_dict("index") if not review.empty else {}

    # If the user explicitly passes specific IDs, ONLY run those IDs.
    if args.rerun:
        todo = [
            row for _, row in bench.iterrows()
            if row["scenario_id"] in force_ids
        ]
    else:
        # Otherwise, run standard resume logic (unreviewed rows + flagged rows)
        todo = [
            row for _, row in bench.iterrows()
            if row["scenario_id"] not in reviewed_ids or row["scenario_id"] in force_ids
        ]
    print(f"Reviewing {len(todo)} / {len(bench)} rows ({len(force_ids)} forced reruns)...")

    processed = 0
    for row in tqdm(todo, desc="Rubric review"):
        verdict = call_reviewer(str(row["user_prompt"]), str(row["tf_code"]), row["difficulty"])
        records[row["scenario_id"]] = {
            "scenario_id": row["scenario_id"],
            "dest_file": row["folder_path"],
            "difficulty": row["difficulty"],
            "n_resources": row["n_resources"],
            "n_params": row["n_params"],
            "loc": row["loc"],
            "user_prompt": row["user_prompt"],
            "leak_severity": verdict.get("leak_severity", "unknown"),
            "leak_reasons": join_list(verdict.get("leak_reasons")),
            "missing_essential_info": verdict.get("missing_essential_info", False),
            "missing_reasons": join_list(verdict.get("missing_reasons")),
            "difficulty_fit": verdict.get("difficulty_fit", "unknown"),
            "assumes_external_dependency": verdict.get("assumes_external_dependency", False),
            "external_dependency_reasons": join_list(verdict.get("external_dependency_reasons")),
            "stale_reference_risk": verdict.get("stale_reference_risk", False),
            "stale_reference_reasons": join_list(verdict.get("stale_reference_reasons")),
            "critical_defect": verdict.get("critical_defect", True),
            "notes": verdict.get("notes", ""),
        }
        processed += 1
        if processed % SAVE_EVERY == 0:
            pd.DataFrame(list(records.values())).to_csv(OUTPUT_CSV, index=False)

    out_df = pd.DataFrame(list(records.values()))
    out_df.to_csv(OUTPUT_CSV, index=False)

    flagged = out_df[
        (out_df["critical_defect"] == True) 
        | (out_df["leak_severity"] != "none")
        | (out_df["missing_essential_info"] == True) 
        | (out_df["difficulty_fit"] != "appropriate")
        | (out_df["assumes_external_dependency"] == True) 
        | (out_df["stale_reference_risk"] == True) 
    ]
    print(f"\nReview complete. {len(flagged)} / {len(out_df)} rows flagged.")
    print(f"Saved to {OUTPUT_CSV}")


if __name__ == "__main__":
    main()