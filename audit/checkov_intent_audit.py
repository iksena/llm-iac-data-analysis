#!/usr/bin/env python3
"""
checkov_intent_audit.py — v5
=================================
[FIX v5] AttributeError: 'Record' object has no attribute 'check'

  Checkov's graph-based custom policy runner (used for YAML policies like
  UIV_CUSTOM_ROW_*) returns `Record` namedtuples, not `CheckResult` objects.
  `Record` does NOT have a `.check` attribute — the check name is absent or
  accessible only via other fields.

  Fix: replace direct `c.check.name` access with safe getattr fallbacks in
  both _record_to_passed() and _record_to_failed() helpers, so both Record
  (graph checks) and CheckResult (attribute checks) are handled identically.

All fixes from v4 are preserved.
"""

import argparse
import csv
import json
import os
import re
import shutil
import tempfile
import time
import traceback
from pathlib import Path
from typing import Any

import yaml

from checkov.cloudformation.runner import Runner
from checkov.runner_filter import RunnerFilter


# ─────────────────────────────────────────────────────────────────────────────
# Registry / singleton cleanup
# ─────────────────────────────────────────────────────────────────────────────

def _purge_custom_graph_checks(runner: Runner) -> None:
    greg = runner.graph_registry
    if not hasattr(greg, "checks"):
        return
    greg.checks = [c for c in greg.checks if not c.id.startswith("UIV_CUSTOM")]


def _purge_custom_registry_checks(check_id_prefix: str = "UIV_CUSTOM") -> None:
    try:
        from checkov.cloudformation.checks.resource.registry import cfn_registry
        cfn_registry.checks = {
            rt: [c for c in ch if not c.id.startswith(check_id_prefix)]
            for rt, ch in cfn_registry.checks.items()
        }
        cfn_registry.wildcard_checks = [
            c for c in cfn_registry.wildcard_checks
            if not c.id.startswith(check_id_prefix)
        ]
    except (ImportError, AttributeError):
        pass


# ─────────────────────────────────────────────────────────────────────────────
# Temp-dir helpers
# ─────────────────────────────────────────────────────────────────────────────

def _make_realpath_tmpdir(prefix: str) -> str:
    return os.path.realpath(tempfile.mkdtemp(prefix=prefix))


def _safe_rmtree(path: str) -> None:
    for attempt in range(3):
        try:
            shutil.rmtree(path)
            return
        except OSError:
            if attempt < 2:
                time.sleep(0.1)
    shutil.rmtree(path, ignore_errors=True)


# ─────────────────────────────────────────────────────────────────────────────
# Policy YAML helpers
# ─────────────────────────────────────────────────────────────────────────────

def extract_check_id_from_policy(policy_path: str) -> str | None:
    try:
        with open(policy_path, encoding="utf-8") as fh:
            doc = yaml.safe_load(fh)
        return (doc or {}).get("metadata", {}).get("id") or None
    except Exception:
        return None


def ids_from_policy_files(policy_files: list[str]) -> list[str]:
    ids = []
    for pf in policy_files:
        cid = extract_check_id_from_policy(pf)
        if cid:
            ids.append(cid)
        else:
            print(f"\n  [WARN] Could not extract check ID from: {pf}", flush=True)
    return ids


# ─────────────────────────────────────────────────────────────────────────────
# [FIX v5] Safe result-record accessors
# ─────────────────────────────────────────────────────────────────────────────

def _result_name(c) -> str:
    """
    Return the human-readable check name from either a CheckResult or a Record.

    CheckResult (attribute/resource checks):  c.check  is a BaseCheck with .name
    Record      (graph / YAML policy checks): c.check  does NOT exist;
                                               c.check_id is the best identifier.
    """
    check_obj = getattr(c, "check", None)
    return (
        getattr(check_obj, "name", None)
        or getattr(c, "name", None)
        or getattr(c, "check_id", "")
    )


def _result_guideline(c) -> str | None:
    check_obj = getattr(c, "check", None)
    return (
        getattr(check_obj, "guideline", None)
        or getattr(c, "guideline", None)
    )


# ─────────────────────────────────────────────────────────────────────────────
# Core scan helper
# ─────────────────────────────────────────────────────────────────────────────

def validate_with_checkov(
    template: str,
    policy_files: list[str],
    check_ids: list[str],
    iac_type: str = "cloudformation",
) -> dict[str, Any]:
    filename = "template.yaml" if iac_type == "cloudformation" else "main.tf"

    blank: dict[str, Any] = dict(
        passed_check_ids=[],
        failed_check_ids=[],
        passed_check_details=[],
        failed_check_details=[],
        total_passed=0,
        total_failed=0,
        error=None,
    )

    tmpdir = _make_realpath_tmpdir("checkov_tmpl_")
    Path(tmpdir, filename).write_text(template, encoding="utf-8")

    poldir = _make_realpath_tmpdir("checkov_policy_")
    for src in policy_files:
        shutil.copy2(src, os.path.join(poldir, os.path.basename(src)))

    try:
        runner = Runner()

        if hasattr(runner, "graph_manager") and runner.graph_manager is not None:
            runner.graph_manager.graph = None
            runner.graph_manager.definitions_raw = {}

        _purge_custom_graph_checks(runner)
        _purge_custom_registry_checks()

        runner.context    = None
        runner.definitions = None
        runner.breadcrumbs = None

        runner_filter = RunnerFilter(checks=check_ids)

        report = runner.run(
            root_folder=tmpdir,
            external_checks_dir=[poldir],
            files=None,
            runner_filter=runner_filter,
        )

        _purge_custom_graph_checks(runner)
        _purge_custom_registry_checks()

        check_ids_set = set(check_ids)

        # [FIX v5] Use safe accessors — works for both CheckResult and Record
        passed_details = [
            {
                "check_id":   c.check_id,
                "check_name": _result_name(c),
                "resource":   c.resource,
            }
            for c in report.passed_checks
            if c.check_id in check_ids_set
        ]
        failed_details = [
            {
                "check_id":   c.check_id,
                "check_name": _result_name(c),
                "resource":   c.resource,
                "guideline":  _result_guideline(c),
            }
            for c in report.failed_checks
            if c.check_id in check_ids_set
        ]

        return blank | dict(
            passed_check_ids=[d["check_id"] for d in passed_details],
            failed_check_ids=[d["check_id"] for d in failed_details],
            passed_check_details=passed_details,
            failed_check_details=failed_details,
            total_passed=len(passed_details),
            total_failed=len(failed_details),
        )

    except KeyError as exc:
        return blank | {"error": f"KeyError: {exc}\n{traceback.format_exc()}"}
    except Exception as exc:
        return blank | {"error": f"{type(exc).__name__}: {exc}\n{traceback.format_exc()}"}
    finally:
        _safe_rmtree(tmpdir)
        _safe_rmtree(poldir)


# ─────────────────────────────────────────────────────────────────────────────
# ID / path parsing helpers
# ─────────────────────────────────────────────────────────────────────────────

def parse_ids(raw: str) -> list[str]:
    return [x.strip() for x in re.split(r"[;,]", raw or "") if x.strip()]


def parse_file_paths(raw: str) -> list[str]:
    return [x.strip() for x in re.split(r",\s*", raw or "") if x.strip()]


# ─────────────────────────────────────────────────────────────────────────────
# Benchmark side-input loader
# ─────────────────────────────────────────────────────────────────────────────

def load_benchmark_index(benchmark_csv: str | None) -> dict[str, dict]:
    if not benchmark_csv:
        return {}
    path = Path(benchmark_csv)
    if not path.exists():
        raise SystemExit(f"[ERROR] Benchmark CSV not found: {path}")
    index: dict[str, dict] = {}
    with path.open(encoding="utf-8", newline="") as fh:
        for row in csv.DictReader(fh):
            rn = row.get("row_number", "").strip()
            if rn:
                index[rn] = row
    print(f"[INFO] Benchmark index loaded: {len(index)} rows from {path.name}")
    return index


# ─────────────────────────────────────────────────────────────────────────────
# Policy file resolver
# ─────────────────────────────────────────────────────────────────────────────

def _resolve_policy_files(
    intent_file_raw: str,
    check_ids_hint: list[str],
    pol_dir: Path,
    row_num: str,
) -> list[str]:
    policy_files: list[str] = []

    for raw_token in parse_file_paths(intent_file_raw):
        p = raw_token.replace("\\", os.sep)
        p_path = Path(p)
        for cand in [p_path, pol_dir / p_path, pol_dir / p_path.name]:
            if cand.exists():
                policy_files.append(str(cand.resolve()))
                break
        else:
            print(f"\n  [WARN] row={row_num} policy not found: {raw_token!r}", flush=True)

    # Fallback 1: derive from check IDs in the CSV hint
    if not policy_files and check_ids_hint:
        for cid in check_ids_hint:
            m = re.search(r"ROW_(\d+[A-Za-z]*)", cid, re.I)
            if m:
                guessed = pol_dir / f"row_{m.group(1).lower()}.yaml"
                if guessed.exists():
                    policy_files.append(str(guessed.resolve()))

    # Fallback 2: derive from row_number directly
    if not policy_files:
        plain = pol_dir / f"row_{row_num}.yaml"
        if plain.exists():
            policy_files.append(str(plain.resolve()))
        else:
            for suffix in "ABCDEF":
                lettered = pol_dir / f"row_{row_num}{suffix}.yaml"
                if lettered.exists():
                    policy_files.append(str(lettered.resolve()))

    return policy_files


# ─────────────────────────────────────────────────────────────────────────────
# Main loop
# ─────────────────────────────────────────────────────────────────────────────

def run_audit(
    csv_input: str,
    policy_dir: str,
    iac_type: str,
    csv_output: str | None,
    limit: int | None,
    skip_empty: bool,
    global_check_ids: list[str] | None,
    benchmark_index: dict[str, dict],
) -> None:
    in_path = Path(csv_input)
    if not in_path.exists():
        raise SystemExit(f"[ERROR] Input CSV not found: {in_path}")

    pol_dir = Path(policy_dir)
    if not pol_dir.is_dir():
        raise SystemExit(f"[ERROR] Policy directory not found: {pol_dir}")

    out_rows: list[dict] = []

    with in_path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)

        for i, row in enumerate(reader):
            if limit is not None and i >= limit:
                break

            row_num  = str(row.get("row_number", i)).strip()
            template = (row.get("final_template") or "").strip()

            bench_row  = benchmark_index.get(row_num, {})
            merged_row = {**row, **bench_row}

            intent_file_raw = merged_row.get("user_intent_file_path", "")
            csv_ids_hint    = parse_ids(merged_row.get("user_intent_ids", ""))

            policy_files = _resolve_policy_files(
                intent_file_raw, csv_ids_hint, pol_dir, row_num
            )

            if global_check_ids:
                check_ids = global_check_ids
            else:
                check_ids = ids_from_policy_files(policy_files)
                if not check_ids:
                    check_ids = csv_ids_hint

            ids_display = ";".join(check_ids)

            print(
                f"[{i:>4}] row={row_num:<4}  "
                f"ids={ids_display:<45}  "
                f"policies={[os.path.basename(p) for p in policy_files]}",
                end=" ... ",
                flush=True,
            )

            if not template:
                msg = "SKIP (empty)" if skip_empty else "empty template"
                print(msg)
                if skip_empty:
                    continue
                out_rows.append(merged_row | {"error": "empty template", "template_empty": True})
                continue

            if not check_ids:
                print("SKIP (no check IDs — no policies found for this row)")
                out_rows.append(merged_row | {
                    "error": "no check IDs / policies found",
                    "template_empty": False,
                })
                continue

            result = validate_with_checkov(
                template=template,
                policy_files=policy_files,
                check_ids=check_ids,
                iac_type=iac_type,
            )

            n_p    = result["total_passed"]
            n_f    = result["total_failed"]
            n_t    = len(check_ids)
            status = "PASS" if not result["error"] and n_f == 0 else "FAIL"
            if result["error"]:
                status = "ERROR"

            print(
                f"{status}  intent: {n_p}/{n_t} passed"
                + (f"  ERR: {str(result['error'])[:80]}" if result["error"] else "")
            )

            out_rows.append(
                merged_row | {
                    "pass_user_intent":     n_f == 0 and not result["error"],
                    "total_intent_checks":  n_t,
                    "passed_intent_ids":    ";".join(result["passed_check_ids"]),
                    "failed_intent_ids":    ";".join(result["failed_check_ids"]),
                    "total_passed":         n_p,
                    "total_failed":         n_f,
                    "template_empty":       False,
                    "error":                result["error"] or "",
                    "passed_check_details": json.dumps(result["passed_check_details"]),
                    "failed_check_details": json.dumps(result["failed_check_details"]),
                }
            )

    if not out_rows:
        print("[WARN] No rows processed.")
        return

    total  = len(out_rows)
    errors = sum(1 for r in out_rows if r.get("error"))
    passed = sum(1 for r in out_rows if r.get("pass_user_intent") is True)
    failed = sum(
        1 for r in out_rows
        if r.get("pass_user_intent") is False and not r.get("error")
    )

    print()
    print("=" * 60)
    print(f"SUMMARY  total={total}  passed={passed}  failed={failed}  errors={errors}")
    print("=" * 60)

    if csv_output:
        all_keys = list(dict.fromkeys(k for r in out_rows for k in r))
        with open(csv_output, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=all_keys, extrasaction="ignore")
            w.writeheader()
            w.writerows(out_rows)
        print(f"[INFO] Output written: {csv_output}")


# ─────────────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────────────

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="checkov_intent_audit.py",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples
--------
  python checkov_intent_audit.py \\
      -i Intent_DSV4_CFN_Sec.csv -p Data/user_intent -o results.csv

  python checkov_intent_audit.py \\
      -i Result/iacgod/DeepseekV4Flash_security.csv \\
      -p Data/user_intent \\
      --benchmark Result/iacgod/Intent_DSV4_CFN_Sec.csv \\
      -o deepseek_intent_results.csv
""",
    )
    p.add_argument("--input",      "-i", required=True)
    p.add_argument("--policy-dir", "-p", required=True)
    p.add_argument("--benchmark",  "-b", default=None, metavar="CSV")
    p.add_argument("--type",       "-t", default="cloudformation",
                   choices=["cloudformation", "terraform"])
    p.add_argument("--output",     "-o", default=None)
    p.add_argument("--limit",      type=int, default=None)
    p.add_argument("--skip-empty", action="store_true")
    p.add_argument("--check-ids",  default=None, metavar="ID1,ID2,...")
    return p


if __name__ == "__main__":
    args   = build_parser().parse_args()
    bindex = load_benchmark_index(args.benchmark)
    run_audit(
        csv_input=args.input,
        policy_dir=args.policy_dir,
        iac_type=args.type,
        csv_output=args.output,
        limit=args.limit,
        skip_empty=args.skip_empty,
        global_check_ids=parse_ids(args.check_ids or ""),
        benchmark_index=bindex,
    )