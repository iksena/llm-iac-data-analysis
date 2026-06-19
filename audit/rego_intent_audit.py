#!/usr/bin/env python3
"""
rego_intent_audit.py  (v3 — LocalStack + tflocal, persistent plugin cache)
===========================================================================
For each row in a Terraform IaC-generation CSV (e.g. Terraform_DeepseekV4Flash_security.csv),
this script:

  1. Matches row_number to autoiac-project/iac-eval benchmark by 0-based index.
  2. Writes final_template to a temp dir and runs:
         tflocal init  -backend=false
         tflocal plan  -out=tfplan.binary  -refresh=false
         tflocal show  -json tfplan.binary  ->  plan.json
  3. Evaluates the benchmark's rego_intent OPA policy against plan.json:
         opa eval -d policy.rego -i plan.json "<package>.is_configuration_valid"
  4. Outputs per-row results + aggregate summary.

Usage
-----
    python rego_intent_audit.py \\
        --input  Terraform_DeepseekV4Flash_security.csv \\
        [--dataset autoiac-project/iac-eval] \\
        [--output results.json] \\
        [--output-csv results_rego.csv] \\
        [--limit 10] \\
        [--skip-empty] \\
        [--no-terraform]   # skip tf plan; feed {} as OPA input (fast smoke test)

Requirements
------------
    pip install datasets huggingface_hub terraform-local
    brew install localstack/tap/localstack-cli && localstack start -d
    brew install opa
    terraform >= 1.5  (https://developer.hashicorp.com/terraform/install)
"""

import argparse
import csv
import json
import os
import re
import subprocess
import sys
import tempfile
from pathlib import Path

try:
    from datasets import load_dataset
    HF_AVAILABLE = True
except ImportError:
    HF_AVAILABLE = False


# ---------------------------------------------------------------------------
# Persistent Terraform provider plugin cache (module-level singleton)
# ---------------------------------------------------------------------------
# Without this, every TemporaryDirectory triggers a full provider download
# (~500 MB for hashicorp/aws). With it, init completes in <5s after the
# first row.
_TF_PLUGIN_CACHE_DIR = Path(tempfile.gettempdir()) / "rego-audit-tf-plugin-cache"
_TF_PLUGIN_CACHE_DIR.mkdir(parents=True, exist_ok=True)


# ---------------------------------------------------------------------------
# Subprocess helper
# ---------------------------------------------------------------------------

def _run(
    cmd: list[str],
    cwd: str,
    timeout: int = 180,
    env: dict | None = None,
) -> tuple[int, str, str]:
    merged_env = {**os.environ, **(env or {})}
    proc = subprocess.run(
        cmd, cwd=cwd, capture_output=True, text=True,
        timeout=timeout, env=merged_env,
    )
    return proc.returncode, proc.stdout, proc.stderr


# ---------------------------------------------------------------------------
# LocalStack environment — injected for every tflocal call
# ---------------------------------------------------------------------------

def _localstack_env() -> dict[str, str]:
    """
    Minimal env vars so the AWS provider doesn't attempt real credential
    resolution. tflocal sets LOCALSTACK_HOSTNAME and TF_APPEND_USER_AGENT
    internally; we only need to supply dummy credentials.
    """
    return {
        "AWS_ACCESS_KEY_ID":      "test",
        "AWS_SECRET_ACCESS_KEY":  "test",
        "AWS_DEFAULT_REGION":     "us-east-1",
        # Point Terraform at the persistent cache so init is fast after row 0
        "TF_PLUGIN_CACHE_DIR":    str(_TF_PLUGIN_CACHE_DIR),
        # Silence upgrade-check noise
        "CHECKPOINT_DISABLE":     "1",
    }


# ---------------------------------------------------------------------------
# Terraform plan → plan.json  (via tflocal + LocalStack)
# ---------------------------------------------------------------------------

def terraform_plan_json(template: str, tmpdir: str) -> tuple[str | None, str | None]:
    """
    Write template as main.tf, run tflocal init + plan + show,
    return (path_to_plan_json, error_message).

    Uses `tflocal` (terraform-local pip package) which:
      - Auto-generates localstack_providers_override.tf matched to the
        installed hashicorp/aws provider version — no manual stub needed.
      - Routes all AWS API calls to the local LocalStack instance.

    The persistent TF_PLUGIN_CACHE_DIR means `terraform init` only downloads
    the provider binary once per process (~500 MB); subsequent rows take <5s.

    -refresh=false on plan means no real AWS state calls are made — only
    the static configuration graph is evaluated, which is exactly what
    the Rego policies inspect (input.configuration / input.planned_values).
    """
    tf_dir = Path(tmpdir)
    (tf_dir / "main.tf").write_text(template, encoding="utf-8")

    env = _localstack_env()

    # ---- init -------------------------------------------------------
    rc, _, stderr = _run(
        ["tflocal", "init", "-backend=false", "-input=false",
         "-no-color", "-upgrade=false"],
        cwd=tmpdir, timeout=300, env=env,   # 5 min — first call downloads provider
    )
    if rc != 0:
        return None, f"tflocal init failed: {stderr[:500]}"

    # ---- plan -------------------------------------------------------
    plan_file = str(tf_dir / "tfplan.binary")
    rc, _, stderr = _run(
        ["tflocal", "plan", "-input=false", "-no-color",
         "-refresh=false", f"-out={plan_file}"],
        cwd=tmpdir, timeout=120, env=env,
    )
    if rc != 0:
        return None, f"tflocal plan failed: {stderr[:500]}"

    # ---- show → JSON ------------------------------------------------
    plan_json_path = str(tf_dir / "plan.json")
    rc, stdout, stderr = _run(
        ["tflocal", "show", "-json", plan_file],
        cwd=tmpdir, timeout=60, env=env,
    )
    if rc != 0:
        return None, f"tflocal show failed: {stderr[:500]}"

    Path(plan_json_path).write_text(stdout, encoding="utf-8")
    return plan_json_path, None


# ---------------------------------------------------------------------------
# Rego helpers
# ---------------------------------------------------------------------------

def extract_rule_names(rego_text: str) -> list[str]:
    """Extract top-level rule names from a Rego policy."""
    pattern = re.compile(r"^([a-zA-Z_][a-zA-Z0-9_]*)\s*[{\[=]", re.MULTILINE)
    seen: dict[str, None] = {}
    skip = {"package", "default", "import", "not", "some", "else", "with"}
    for m in pattern.finditer(rego_text):
        name = m.group(1)
        if name not in skip:
            seen[name] = None
    return list(seen.keys())


def eval_rego_rule(
    rego_path: str,
    input_path: str,
    query: str,
    timeout: int = 60,
) -> tuple[bool | None, str | None]:
    """
    Run: opa eval -d <rego_path> -i <input_path> '<query>'
    Returns (result_bool, error_string). result_bool is None on OPA error.
    """
    try:
        rc, stdout, stderr = _run(
            ["opa", "eval", "-d", rego_path, "-i", input_path, query],
            cwd=str(Path(rego_path).parent),
            timeout=timeout,
        )
    except FileNotFoundError:
        return None, "opa not installed — run: brew install opa"
    except subprocess.TimeoutExpired:
        return None, f"opa eval timed out after {timeout}s"

    raw = stdout.strip()

    # Empty result set = rule undefined = False (not an error in Rego)
    if not raw or raw in ("{}", '{"result": []}'):
        return False, None

    try:
        data = json.loads(raw)
    except json.JSONDecodeError:
        return None, f"OPA JSON parse error: {raw[:300]}"

    results = data.get("result", [])
    if not results:
        return False, None

    try:
        value = results[0]["expressions"][0]["value"]
        return bool(value), None
    except (KeyError, IndexError, TypeError):
        return None, f"Unexpected OPA response: {raw[:300]}"


# ---------------------------------------------------------------------------
# Per-row audit
# ---------------------------------------------------------------------------

def audit_row(
    row_index: int,
    template: str,
    rego_intent: str,
    use_terraform: bool,
) -> dict:
    result = {
        "row_index":       row_index,
        "rego_passed":     False,
        "all_rule_names":  [],
        "passed_rules":    [],
        "failed_rules":    [],
        "terraform_error": None,
        "opa_error":       None,
    }

    all_rules = extract_rule_names(rego_intent)
    result["all_rule_names"] = all_rules

    package_match = re.search(r"^package\s+([\w.]+)", rego_intent, re.MULTILINE)
    pkg_prefix = f"data.{package_match.group(1)}" if package_match \
                 else "data.terraform.validation"
    main_query = f"{pkg_prefix}.is_configuration_valid"

    with tempfile.TemporaryDirectory() as tmpdir:
        rego_path = str(Path(tmpdir) / "policy.rego")
        Path(rego_path).write_text(rego_intent, encoding="utf-8")

        # Produce plan.json or empty stub
        if use_terraform:
            plan_json_path, tf_err = terraform_plan_json(template, tmpdir)
            if tf_err:
                result["terraform_error"] = tf_err
                # Fall back to empty input so Rego still runs
                plan_json_path = str(Path(tmpdir) / "empty_input.json")
                Path(plan_json_path).write_text("{}", encoding="utf-8")
        else:
            plan_json_path = str(Path(tmpdir) / "empty_input.json")
            Path(plan_json_path).write_text("{}", encoding="utf-8")

        # Main rule
        main_result, opa_err = eval_rego_rule(rego_path, plan_json_path, main_query)
        if opa_err:
            result["opa_error"] = opa_err
            return result

        result["rego_passed"] = bool(main_result)

        # Sub-rules (for detail breakdown)
        passed_rules: list[str] = []
        failed_rules: list[str] = []
        sub_errs: list[str] = []

        for rule in all_rules:
            if rule == "is_configuration_valid":
                continue
            val, err = eval_rego_rule(rego_path, plan_json_path, f"{pkg_prefix}.{rule}")
            if err:
                sub_errs.append(f"{rule}: {err}")
                failed_rules.append(rule)
            elif val:
                passed_rules.append(rule)
            else:
                failed_rules.append(rule)

        if sub_errs:
            result["opa_error"] = " | ".join(sub_errs)

        if main_result:
            passed_rules.append("is_configuration_valid")
        else:
            failed_rules.append("is_configuration_valid")

        result["passed_rules"] = passed_rules
        result["failed_rules"] = failed_rules

    return result


# ---------------------------------------------------------------------------
# Aggregate
# ---------------------------------------------------------------------------

def aggregate(rows: list[dict]) -> dict:
    all_rules: set[str] = set()
    all_passed: set[str] = set()
    all_failed: set[str] = set()

    for r in rows:
        all_rules  |= set(r["all_rule_names"])
        all_passed |= set(r["passed_rules"])
        all_failed |= set(r["failed_rules"])

    n = max(len(rows), 1)
    return {
        "rows_scanned":           len(rows),
        "rows_rego_passed":       sum(1 for r in rows if r["rego_passed"]),
        "rows_rego_failed":       sum(1 for r in rows if not r["rego_passed"]),
        "rows_terraform_errors":  sum(1 for r in rows if r.get("terraform_error")),
        "rows_opa_errors":        sum(1 for r in rows if r.get("opa_error")),
        "all_unique_rule_names":  sorted(all_rules),
        "all_passed_rule_names":  sorted(all_passed),
        "all_failed_rule_names":  sorted(all_failed),
        "pass_rate_pct":          round(
            100 * sum(1 for r in rows if r["rego_passed"]) / n, 2
        ),
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="rego_intent_audit.py",
        description=(
            "Evaluate LLM-generated Terraform templates against "
            "the autoiac-project/iac-eval Rego intent policies via LocalStack."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--input", "-i", required=True, metavar="CSV")
    p.add_argument("--dataset", "-d", default="autoiac-project/iac-eval")
    p.add_argument("--split", default="test")
    p.add_argument("--output", "-o", metavar="JSON", default=None)
    p.add_argument("--output-csv", metavar="CSV_OUT", default=None)
    p.add_argument("--limit", type=int, default=None, metavar="N")
    p.add_argument("--skip-empty", action="store_true")
    p.add_argument(
        "--no-terraform", action="store_true",
        help=(
            "Skip tflocal init/plan; feed {} as OPA input. "
            "Fast smoke-test for Rego policy syntax."
        ),
    )
    return p

def _write_csv_row(
    writer: "csv.DictWriter | None",
    fh,
    r: dict,
) -> None:
    """Write one result row to the CSV and flush immediately."""
    if writer is None:
        return
    writer.writerow({
        "row_index":       r["row_index"],
        "row_number":      r.get("row_number", ""),
        "rego_passed":     r["rego_passed"],
        "passed_rules":    ";".join(r["passed_rules"]),
        "failed_rules":    ";".join(r["failed_rules"]),
        "all_rule_names":  ";".join(r["all_rule_names"]),
        "terraform_error": r.get("terraform_error") or "",
        "opa_error":       r.get("opa_error") or "",
    })
    fh.flush()  # OS-level flush — row is on disk even if the process is killed

def main() -> None:
    args = build_parser().parse_args()

    csv_path = Path(args.input)
    if not csv_path.exists():
        raise SystemExit(f"[ERROR] Input CSV not found: {csv_path}")

    if not HF_AVAILABLE:
        raise SystemExit(
            "[ERROR] `datasets` package not found.\n"
            "        pip install datasets huggingface_hub"
        )

    print(f"[INFO] Loading benchmark : {args.dataset} (split={args.split})")
    try:
        ds = load_dataset(args.dataset, split=args.split, trust_remote_code=False)
    except Exception as e:
        raise SystemExit(f"[ERROR] Could not load dataset: {e}")

    rego_col = next(
        (c for c in ("Rego intent", "rego_intent", "rego intent") if c in ds.column_names),
        None,
    )
    if rego_col is None:
        raise SystemExit(f"[ERROR] Rego column not found. Columns: {ds.column_names}")

    print(f"[INFO] Benchmark rows    : {len(ds)}  (Rego column: '{rego_col}')")
    benchmark: dict[int, str] = {i: ds[i][rego_col] for i in range(len(ds))}

    print(f"[INFO] Input CSV         : {csv_path}")
    use_tf = not args.no_terraform
    print(f"[INFO] Terraform (tflocal): {'ENABLED (LocalStack)' if use_tf else 'DISABLED (--no-terraform)'}")
    if use_tf:
        print(f"[INFO] Plugin cache      : {_TF_PLUGIN_CACHE_DIR}")
    if args.limit:
        print(f"[INFO] Row limit         : {args.limit}")

    # ------------------------------------------------------------------
    # Open CSV output early so each row is flushed immediately.
    # This means results are safe even if the script is interrupted.
    # ------------------------------------------------------------------
    CSV_COLS = [
        "row_index", "row_number", "rego_passed",
        "passed_rules", "failed_rules", "all_rule_names",
        "terraform_error", "opa_error",
    ]

    csv_out_fh   = None
    csv_out_writer = None
    if args.output_csv:
        csv_out_path = Path(args.output_csv)
        # Check if file already has content so we can resume (skip header)
        resume = csv_out_path.exists() and csv_out_path.stat().st_size > 0
        csv_out_fh = open(csv_out_path, "a", newline="", encoding="utf-8")
        csv_out_writer = csv.DictWriter(csv_out_fh, fieldnames=CSV_COLS)
        if not resume:
            csv_out_writer.writeheader()
            csv_out_fh.flush()
        print(f"[INFO] CSV output        : {csv_out_path} ({'appending' if resume else 'new file'})")

    print()

    row_results: list[dict] = []

    try:
        with csv_path.open(encoding="utf-8", newline="") as fh:
            reader = csv.DictReader(fh)
            fieldnames = reader.fieldnames or []

            for required_col in ("final_template", "row_number"):
                if required_col not in fieldnames:
                    raise SystemExit(
                        f"[ERROR] CSV missing `{required_col}` column. Found: {fieldnames}"
                    )

            for csv_i, row in enumerate(reader):
                if args.limit is not None and csv_i >= args.limit:
                    break

                raw_rn = row.get("row_number", "").strip()
                try:
                    row_number = int(raw_rn)
                except ValueError:
                    print(f"  [{csv_i:>4}] row_number={raw_rn!r} SKIPPED (non-integer)")
                    continue

                template = (row.get("final_template") or "").strip()

                if not template:
                    if args.skip_empty:
                        print(f"  [{csv_i:>4}] row={row_number:<4} SKIPPED (empty template)")
                        continue
                    r = {
                        "row_index": csv_i, "row_number": row_number,
                        "rego_passed": False, "all_rule_names": [],
                        "passed_rules": [], "failed_rules": [],
                        "terraform_error": None, "opa_error": "empty template",
                    }
                    row_results.append(r)
                    _write_csv_row(csv_out_writer, csv_out_fh, r)
                    print(f"  [{csv_i:>4}] row={row_number:<4} FAIL  (empty template)")
                    continue

                rego_intent = benchmark.get(row_number)
                if rego_intent is None:
                    print(f"  [{csv_i:>4}] row={row_number:<4} SKIPPED (not in benchmark; max={len(ds)-1})")
                    continue

                print(f"  [{csv_i:>4}] row={row_number:<4} scanning ...", end=" ", flush=True)

                r = audit_row(
                    row_index=csv_i,
                    template=template,
                    rego_intent=rego_intent,
                    use_terraform=use_tf,
                )
                r["row_number"] = row_number
                row_results.append(r)

                # ---- Write this row to CSV immediately ---------------
                _write_csv_row(csv_out_writer, csv_out_fh, r)

                label = "PASS" if r["rego_passed"] else "FAIL"
                parts: list[str] = []
                if r["terraform_error"]:
                    parts.append(f"tf_err={r['terraform_error'][:60]!r}")
                if r["opa_error"]:
                    parts.append(f"opa_err={r['opa_error'][:60]!r}")
                parts.append(
                    f"rules={len(r['all_rule_names'])} "
                    f"passed={len(r['passed_rules'])} "
                    f"failed={len(r['failed_rules'])}"
                )
                print(f"{label:<6} {' | '.join(parts)}")

    finally:
        # Always close the CSV file handle, even on Ctrl-C or exception
        if csv_out_fh:
            csv_out_fh.close()

    if not row_results:
        print("[WARN] No rows processed.")
        return

    agg = aggregate(row_results)
    SEP = "=" * 72
    print()
    print(SEP)
    print("AGGREGATE SUMMARY — Rego Intent Evaluation")
    print(SEP)
    print(f"  Rows scanned              : {agg['rows_scanned']}")
    print(f"  Rows PASSED (rego intent) : {agg['rows_rego_passed']}")
    print(f"  Rows FAILED (rego intent) : {agg['rows_rego_failed']}")
    print(f"  Pass rate                 : {agg['pass_rate_pct']}%")
    print(f"  Rows with terraform errors: {agg['rows_terraform_errors']}")
    print(f"  Rows with OPA errors      : {agg['rows_opa_errors']}")

    passed_set = set(agg["all_passed_rule_names"])
    failed_set = set(agg["all_failed_rule_names"])

    print()
    print(f"  All unique rule names ({len(agg['all_unique_rule_names'])}):")
    for rule in agg["all_unique_rule_names"]:
        tags = []
        if rule in failed_set: tags.append("FAILED in ≥1 row")
        if rule in passed_set: tags.append("PASSED in ≥1 row")
        print(f"    {rule:<55} [{'; '.join(tags)}]")

    print()
    print(f"  Rules failed in ≥1 row ({len(failed_set)}) with row frequency:")
    for rule in sorted(failed_set):
        freq = sum(1 for r in row_results if rule in r["failed_rules"])
        print(f"    {rule:<55} {freq:>4} rows  {'#' * min(freq, 40)}")

    only_passed = sorted(passed_set - failed_set)
    print()
    print(f"  Rules that NEVER failed ({len(only_passed)}):")
    for rule in only_passed:
        print(f"    {rule}")

    if args.output:
        Path(args.output).write_text(
            json.dumps({"aggregate": agg, "rows": row_results}, indent=2),
            encoding="utf-8",
        )
        print(f"\n[INFO] JSON written  : {args.output}")

    if args.output_csv:
        print(f"[INFO] CSV finalised : {args.output_csv}")


if __name__ == "__main__":
    main()