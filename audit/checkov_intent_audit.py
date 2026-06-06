#!/usr/bin/env python3
"""
checkov_intent_audit.py
=======================
Measures **user-intent compliance** for LLM-generated IaC templates stored in
a CSV file (e.g. DeepseekV4Flash_security.csv) by running Checkov with the
custom YAML policy files defined in the IaCGen benchmark.

Methodology mirrors `process_templates` / `validate_with_checkov_package` from
Tianyi2/IaCGen/Code/user_intent.py:
  - Only rows where `user_intent_file_path` is non-empty are processed.
  - For each such row the generated template (from `final_template` column) is
    written to a temp file, then Checkov runs with all default CKV_* checks
    skipped so only the custom intent checks are evaluated.
  - Results are merged with the benchmark metadata and written to a CSV.

Usage
-----
    python checkov_intent_audit.py \\
        --input      Result/iacgod/DeepseekV4Flash_security.csv \\
        --benchmark  Data/iac_with_user_intent.csv \\
        --output-csv Result/intent/DeepseekV4Flash_checkov_intent.csv \\
        [--output-json results.json] \\
        [--limit 20] \\
        [--skip-unmatched]

The generated template can be CloudFormation (YAML/JSON) or Terraform (HCL).
Checkov auto-detects the framework from the file extension, which is set by
--type (default: cloudformation → .yaml, terraform → .tf).

Requirements
------------
    pip install checkov pandas pyyaml
"""

import argparse
import csv
import json
import os
import shutil
import sys
import tempfile
from pathlib import Path
import traceback

try:
    import pandas as pd
except ImportError:
    sys.exit("[ERROR] pandas not installed.  Run: pip install pandas")

try:
    from checkov.cloudformation.runner import Runner as CfnRunner
    from checkov.terraform.runner import Runner as TfRunner
    from checkov.runner_filter import RunnerFilter
except ImportError:
    sys.exit(
        "[ERROR] checkov not installed.  Run: pip install checkov\n"
        "        Minimum version: checkov >= 3.0"
    )


def _split_cell(value, delimiter: str = ",") -> list[str]:
    """
    Safely split a CSV cell that may be NaN (float) or an empty string.
    Normalises backslash path separators in each token as a side-effect.
    """
    if not value or (isinstance(value, float)):   # catches NaN / None / 0.0
        return []
    return [
        Path(tok.strip().replace("\\", "/")).as_posix()
        for tok in str(value).replace(";", delimiter).split(delimiter)
        if tok.strip()
    ]

# ---------------------------------------------------------------------------
# Temp-dir helper (mirrors make_temp_dir in user_intent.py)
# ---------------------------------------------------------------------------

def _make_temp_policy_dir(policy_files: list[str]) -> str | None:
    """
    Copy all valid policy files into a single freshly-created temp directory
    so that Checkov's external_checks_dir can find them together.
    Returns the temp-dir path, or None if no valid files were found.
    """
    valid = [f for f in policy_files if f and Path(f).is_file()]
    if not valid:
        return None

    temp_dir = tempfile.mkdtemp(prefix="checkov_intent_")
    for src in valid:
        dest = os.path.join(temp_dir, os.path.basename(src))
        shutil.copy2(src, dest)
    return temp_dir


# ---------------------------------------------------------------------------
# Core: validate one template string against custom intent policies
# ---------------------------------------------------------------------------
from checkov.cloudformation.runner import Runner as CfnRunner
from checkov.runner_filter import RunnerFilter

class _SafeCfnRunner(CfnRunner):
    """
    Subclass that skips get_graph_checks_report entirely.

    The upstream runner crashes with a KeyError when graph checks fire on a
    temp file whose absolute path was never indexed into self.context — this
    happens because the custom USER_INTENT category policies are loaded as
    graph checks in newer Checkov versions. Overriding the method to return
    an empty report prevents the crash while keeping all attribute-check
    results intact.
    """
    def get_graph_checks_report(self, root_folder, runner_filter):
        from checkov.common.output.report import Report
        return Report(self.check_type)

def validate_with_checkov(
    template_str: str,
    iac_type: str,
    user_intent_files: list[str],
    user_intent_ids: list[str],
) -> dict:
    """
    Validate a generated IaC template against custom Checkov YAML intent policies.

    Key fixes vs. naive runner.run():
      1. category is rewritten to "GENERAL_SECURITY" before loading so Checkov's
         YAML policy parser doesn't silently drop the check.
      2. The global cfn_registry is cleared of stale custom checks between rows
         to prevent cross-row contamination.
      3. get_graph_checks_report is no-op'd to avoid the self.context KeyError
         that fires when the temp-file path is not indexed.
      4. RunnerFilter uses check_ids (allowlist) so only the intent checks run —
         this means total_passed/total_failed count only intent checks, not all
         default CKV_* rules.
    """
    import traceback
    import re
    from checkov.cloudformation.runner import Runner as CfnRunner
    from checkov.terraform.runner import Runner as TfRunner
    from checkov.runner_filter import RunnerFilter
    from checkov.common.output.report import Report

    ext = ".tf" if iac_type == "terraform" else ".yaml"
    temp_dir_policy: str | None = None
    temp_dir_template: str | None = None

    blank: dict = {
        "pass_user_intent":    False,
        "passed_checks":       [],
        "failed_checks":       [],
        "passed_intent_ids":   [],
        "failed_intent_ids":   list(user_intent_ids),
        "total_intent_checks": len(user_intent_ids),
        "total_passed":        0,
        "total_failed":        0,
        "error":               None,
    }

    if not template_str.strip():
        blank["error"] = "empty template"
        return blank

    if not user_intent_ids:
        blank["error"] = "no user_intent_ids provided"
        return blank

    try:
        # --- 1. Write template to temp dir ---
        temp_dir_template = tempfile.mkdtemp(prefix="checkov_tmpl_")
        tmpl_path = os.path.join(temp_dir_template, f"template{ext}")
        Path(tmpl_path).write_text(template_str, encoding="utf-8")

        # --- 2. Copy policy files, rewriting category to a valid Checkov value ---
        valid_files = [f for f in user_intent_files if f and Path(f).is_file()]
        if not valid_files:
            blank["error"] = f"No policy files found on disk: {user_intent_files}"
            return blank

        temp_dir_policy = tempfile.mkdtemp(prefix="checkov_policy_")
        for src in valid_files:
            raw = Path(src).read_text(encoding="utf-8")
            # Checkov's YAML loader only registers checks whose category is a
            # recognised CheckCategories enum value.  USER_INTENT is not one of
            # them, so rewrite it to GENERAL_SECURITY before loading.
            patched = re.sub(
                r'(category\s*:\s*["\']?)USER_INTENT(["\']?)',
                r'\1GENERAL_SECURITY\2',
                raw,
                flags=re.IGNORECASE,
            )
            dest = os.path.join(temp_dir_policy, os.path.basename(src))
            Path(dest).write_text(patched, encoding="utf-8")

        # --- 3. Clear stale custom checks from the global registry ---
        # Checkov uses module-level singletons; without clearing them each new
        # Runner() in the same process inherits checks from previous calls.
        try:
            from checkov.common.checks.base_check_registry import BaseCheckRegistry
            from checkov.cloudformation.checks.resource.registry import cfn_registry
            # Remove only the UIV_CUSTOM_* checks loaded in prior iterations
            for check_id in list(cfn_registry.wildcard_checks) + [
                cid
                for checks in cfn_registry.checks.values()
                for cid in [c.id for c in checks]
            ]:
                if check_id.startswith("UIV_CUSTOM"):
                    cfn_registry.checks = {
                        rt: [c for c in checks if c.id != check_id]
                        for rt, checks in cfn_registry.checks.items()
                    }
        except Exception:
            pass  # registry cleanup is best-effort

        # --- 4. Build a runner that skips the graph phase ---
        class _SafeRunner(CfnRunner if iac_type != "terraform" else TfRunner):
            def get_graph_checks_report(self, root_folder, runner_filter):
                return Report(self.check_type)

        runner = _SafeRunner()

        # Use check_ids allowlist instead of skip_checks so ONLY the intent
        # checks are evaluated — no default CKV_* noise in the results.
        runner_filter = RunnerFilter(
            checks=user_intent_ids,        # older Checkov API uses 'checks', not 'check_ids'
            skip_checks=["CKV_*"],         # belt-and-suspenders: also skip all built-in rules
        )

        # --- 5. Run ---
        report = runner.run(
            root_folder=None,
            external_checks_dir=[temp_dir_policy],
            files=[tmpl_path],
            runner_filter=runner_filter,
        )

        passed_checks = [
            {"check_id": r.check_id, "check_name": r.check_name, "resource": r.resource}
            for r in report.passed_checks
        ]
        failed_checks = [
            {
                "check_id":   r.check_id,
                "check_name": r.check_name,
                "resource":   r.resource,
                "guideline":  getattr(r, "guideline", ""),
            }
            for r in report.failed_checks
        ]

        passed_ids    = {c["check_id"] for c in passed_checks}
        passed_intent = [cid for cid in user_intent_ids if cid in passed_ids]
        failed_intent = [cid for cid in user_intent_ids if cid not in passed_ids]

        return {
            "pass_user_intent":    len(failed_intent) == 0,
            "passed_checks":       passed_checks,
            "failed_checks":       failed_checks,
            "passed_intent_ids":   passed_intent,
            "failed_intent_ids":   failed_intent,
            "total_intent_checks": len(user_intent_ids),
            "total_passed":        len(passed_checks),
            "total_failed":        len(failed_checks),
            "error":               None,
        }

    except Exception as exc:
        blank["error"] = f"{type(exc).__name__}: {exc}\n{traceback.format_exc()}"
        return blank

    finally:
        for d in [temp_dir_policy, temp_dir_template]:
            if d and os.path.isdir(d):
                shutil.rmtree(d, ignore_errors=True)


# ---------------------------------------------------------------------------
# Aggregate helpers
# ---------------------------------------------------------------------------

def _aggregate(rows: list[dict]) -> dict:
    eligible  = [r for r in rows if r.get("has_intent_data")]
    processed = [r for r in eligible if not r.get("error")]
    passed    = [r for r in processed if r.get("pass_user_intent")]

    total_intent_checks = sum(r.get("total_intent_checks", 0) for r in processed)
    # In _aggregate(), fix the accumulator:
    total_intent_passed = sum(len(r.get("passed_intent_ids", "").split(";")) 
                         if r.get("passed_intent_ids") else 0
                         for r in processed)

    return {
        "total_input_rows":           len(rows),
        "rows_with_intent_policy":    len(eligible),
        "rows_processed":             len(processed),
        "rows_with_errors":           sum(1 for r in eligible if r.get("error")),
        "rows_passed_all_intent":     len(passed),
        "rows_failed_any_intent":     len(processed) - len(passed),
        "pass_rate_pct":              (
            round(len(passed) / len(processed) * 100, 2) if processed else None
        ),
        # Micro-averaged across all individual intent checks
        "total_intent_checks_run":    total_intent_checks,
        "total_intent_checks_passed": total_intent_passed,
        "micro_intent_pass_pct":      (
            round(total_intent_passed / total_intent_checks * 100, 2)
            if total_intent_checks else None
        ),
    }


# ---------------------------------------------------------------------------
# Main processing function
# ---------------------------------------------------------------------------

def run_checkov_intent_audit(
    input_csv: str,
    benchmark_csv: str,
    output_csv: str,
    output_json: str | None,
    iac_type: str,
    limit: int | None,
    skip_unmatched: bool,
) -> None:
    """
    Core routine — mirrors `process_templates` from IaCGen/Code/user_intent.py
    but adapted to work from `final_template` strings (not saved file paths)
    and to produce a richer flat output CSV.
    """
    # --- Load benchmark ---
    bench_path = Path(benchmark_csv)
    if not bench_path.exists():
        sys.exit(f"[ERROR] Benchmark not found: {bench_path}")

    bench_df = pd.read_csv(bench_path, dtype=str)
    bench_df["row_number"] = bench_df["row_number"].astype(str).str.strip()

    # Keep only rows that have a user_intent_file_path (mirrors the IaCGen filter)
    intent_df = bench_df[bench_df["user_intent_file_path"].notna()].copy()
    print(f"[INFO] Benchmark rows with intent policy : {len(intent_df)} / {len(bench_df)}")

    bench_index: dict[str, dict] = {
        row["row_number"]: row.to_dict()
        for _, row in intent_df.iterrows()
    }

    # --- Load input CSV ---
    input_path = Path(input_csv)
    if not input_path.exists():
        sys.exit(f"[ERROR] Input CSV not found: {input_path}")

    with input_path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames or []
        missing = [c for c in ("final_template", "row_number") if c not in fieldnames]
        if missing:
            sys.exit(
                f"[ERROR] Input CSV missing column(s): {missing}\n"
                f"        Found: {fieldnames}"
            )
        input_rows = list(reader)

    print(f"[INFO] Input CSV loaded : {input_path}  ({len(input_rows)} rows)")
    print(f"[INFO] IaC type         : {iac_type}")
    if limit:
        print(f"[INFO] Row limit        : {limit}")
    print()

    SEP = "─" * 76
    row_results: list[dict] = []

    for i, row in enumerate(input_rows):
        if limit is not None and i >= limit:
            break

        row_num  = str(row.get("row_number", "")).strip()
        template = (row.get("final_template") or "").strip()

        # Base result skeleton
        result: dict = {
            "row_index":           i,
            "row_number":          row_num,
            "has_intent_data":     False,
            "template_empty":      not bool(template),
            # Benchmark metadata
            "prompt":              None,
            "difficulty_level":    None,
            "ground_truth_path":   None,
            "user_intent_file_path": None,
            "user_intent_ids":     None,
            # Checkov outputs
            "pass_user_intent":    None,
            "total_intent_checks": 0,
            "passed_intent_ids":   "",
            "failed_intent_ids":   "",
            "total_passed":        0,
            "total_failed":        0,
            "passed_check_details": "",
            "failed_check_details": "",
            "error":               None,
        }

        bench_row = bench_index.get(row_num)
        if bench_row is None:
            label = "NO-INTENT-ROW (skipped)" if skip_unmatched else "NO-INTENT-ROW"
            print(f"  [{i:>4}] row={row_num:<6}  {label}")
            row_results.append(result)
            continue

        result["has_intent_data"]       = True
        result["prompt"]                = bench_row.get("prompt", "")
        result["difficulty_level"]      = bench_row.get("difficulty_level", "")
        result["ground_truth_path"]     = bench_row.get("ground_truth_path", "")
        result["user_intent_file_path"] = bench_row.get("user_intent_file_path", "")

        # Parse semicolon- or comma-separated policy paths and IDs
        raw_files = bench_row.get("user_intent_file_path", "") or ""
        raw_ids   = bench_row.get("user_intent_id", "") or ""

        # IaCGen uses ", " as delimiter (see process_templates)
        policy_files = _split_cell(raw_files)   # NaN-safe, also normalises \ → /
        intent_ids   = _split_cell(raw_ids)     # NaN-safe
        result["user_intent_ids"] = ";".join(intent_ids)

        if not template:
            result["pass_user_intent"]  = False
            result["error"]             = "empty template"
            result["failed_intent_ids"] = ";".join(intent_ids)
            result["total_intent_checks"] = len(intent_ids)
            print(f"  [{i:>4}] row={row_num:<6}  FAIL  (empty template)")
            row_results.append(result)
            continue

        print(f"  [{i:>4}] row={row_num:<6}  scanning {len(intent_ids)} intent check(s) ...", end=" ", flush=True)

        chk = validate_with_checkov(
            template_str=template,
            iac_type=iac_type,
            user_intent_files=policy_files,
            user_intent_ids=intent_ids,
        )

        result.update({
            "pass_user_intent":     chk["pass_user_intent"],
            "total_intent_checks":  chk["total_intent_checks"],
            "passed_intent_ids":    ";".join(chk["passed_intent_ids"]),
            "failed_intent_ids":    ";".join(chk["failed_intent_ids"]),
            "total_passed":         chk["total_passed"],
            "total_failed":         chk["total_failed"],
            "passed_check_details": json.dumps(chk["passed_checks"]),
            "failed_check_details": json.dumps(chk["failed_checks"]),
            "error":                chk["error"],
        })

        if chk["error"]:
            label = f"ERROR  ({chk['error'][:60]})"
        else:
            n_pass = len(chk["passed_intent_ids"])
            n_fail = len(chk["failed_intent_ids"])
            verdict = "PASS" if chk["pass_user_intent"] else "FAIL"
            label = (
                f"{verdict:<4}  intent {n_pass}/{chk['total_intent_checks']} passed"
                f"  [total_passed={chk['total_passed']} total_failed={chk['total_failed']}]"
            )

        print(label)
        row_results.append(result)

    # -------------------------------------------------------------------
    # Aggregate
    # -------------------------------------------------------------------
    agg = _aggregate(row_results)

    print()
    print(SEP)
    print("AGGREGATE SUMMARY — CHECKOV USER-INTENT AUDIT")
    print(SEP)
    print(f"  Total rows in input              : {agg['total_input_rows']}")
    print(f"  Rows with intent policy (scanned): {agg['rows_with_intent_policy']}")
    print(f"  Rows processed (no error)        : {agg['rows_processed']}")
    print(f"  Rows with errors                 : {agg['rows_with_errors']}")
    print()
    print(f"  Rows PASSED all intent checks    : {agg['rows_passed_all_intent']}")
    print(f"  Rows FAILED ≥1 intent check      : {agg['rows_failed_any_intent']}")
    print(f"  Row-level pass rate              : {agg['pass_rate_pct']} %")
    print()
    print(f"  Total intent checks run          : {agg['total_intent_checks_run']}")
    print(f"  Total intent checks passed       : {agg['total_intent_checks_passed']}")
    print(f"  Micro intent-check pass rate     : {agg['micro_intent_pass_pct']} %")

    # -------------------------------------------------------------------
    # Write output CSV — only rows that had intent policy data
    # -------------------------------------------------------------------
    out_rows = [r for r in row_results if r.get("has_intent_data")]
    if not out_rows:
        print("\n[WARN] No intent-policy rows found — output CSV not written.")
    else:
        out_cols = [
            "row_index", "row_number",
            "difficulty_level", "prompt",
            "ground_truth_path", "user_intent_file_path", "user_intent_ids",
            "pass_user_intent",
            "total_intent_checks", "passed_intent_ids", "failed_intent_ids",
            "total_passed", "total_failed",
            "template_empty", "error",
            "passed_check_details", "failed_check_details",
        ]
        out_path = Path(output_csv)
        out_path.parent.mkdir(parents=True, exist_ok=True)
        with out_path.open("w", newline="", encoding="utf-8") as fh:
            writer = csv.DictWriter(fh, fieldnames=out_cols, extrasaction="ignore")
            writer.writeheader()
            writer.writerows(out_rows)
        print(f"\n[INFO] Output CSV written : {out_path}  ({len(out_rows)} rows)")

    # -------------------------------------------------------------------
    # Optional JSON
    # -------------------------------------------------------------------
    if output_json:
        payload = {"aggregate": agg, "rows": row_results}
        Path(output_json).write_text(
            json.dumps(payload, indent=2), encoding="utf-8"
        )
        print(f"[INFO] JSON written       : {output_json}")


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def _build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="checkov_intent_audit.py",
        description=(
            "Run Checkov with custom user-intent YAML policies on LLM-generated "
            "IaC templates from a results CSV."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--input",       "-i", required=True, metavar="CSV",
                   help="Input CSV with `final_template` and `row_number` columns.")
    p.add_argument("--benchmark",   "-b", required=True, metavar="CSV",
                   help="Benchmark CSV (iac_with_user_intent.csv from Tianyi2/IaCGen).")
    p.add_argument("--output-csv",  "-o", required=True, metavar="CSV_OUT",
                   help="Output CSV path for per-row intent results.")
    p.add_argument("--output-json",        metavar="JSON",    default=None,
                   help="Optional: write full results (rows + aggregate) to JSON.")
    p.add_argument("--type", "-t", dest="iac_type",
                   choices=["cloudformation", "terraform"], default="cloudformation",
                   help="IaC type of the generated templates (default: cloudformation).")
    p.add_argument("--limit",       type=int, default=None, metavar="N",
                   help="Process only the first N rows of the input CSV.")
    p.add_argument("--skip-unmatched", action="store_true",
                   help="Suppress console warnings for rows absent from the benchmark.")
    return p


if __name__ == "__main__":
    args = _build_parser().parse_args()
    run_checkov_intent_audit(
        input_csv      = args.input,
        benchmark_csv  = args.benchmark,
        output_csv     = args.output_csv,
        output_json    = args.output_json,
        iac_type       = args.iac_type,
        limit          = args.limit,
        skip_unmatched = args.skip_unmatched,
    )