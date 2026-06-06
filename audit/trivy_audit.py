#!/usr/bin/env python3
"""
trivy_csv_audit.py
==================
Reads a CSV file (like DeepseekV4Flash_security.csv) and runs a fresh Trivy
misconfiguration scan on each row's `final_template` column.

For each row, the script collects:
  - All check IDs encountered (PASS + FAIL)
  - Counts per severity (CRITICAL, HIGH, MEDIUM, LOW, UNKNOWN)
  - Lists of passed check IDs
  - Lists of failed check IDs
  - Grand totals across all rows

Usage
-----
    python trivy_csv_audit.py \
        --input  DeepseekV4Flash_security.csv \
        --type   cloudformation \
        [--output results.json] \
        [--output-csv results.csv] \
        [--limit 10] \
        [--skip-empty]

Supported --type values: cloudformation | terraform

Requirements
------------
    trivy >= 0.50  (https://aquasecurity.github.io/trivy/latest/getting-started/installation/)
    (No extra Python packages required — stdlib only)
"""

import argparse
import csv
import json
import subprocess
import tempfile
from pathlib import Path

SEVERITIES = ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]


# ---------------------------------------------------------------------------
# Core: run trivy on one template string
# ---------------------------------------------------------------------------

def run_trivy(template: str, iac_type: str) -> dict:
    """
    Write *template* to a temp file/dir and run:

        trivy config --format json --exit-code 0 <tmpdir>

    File naming follows the IaC type:
        terraform      -> main.tf
        cloudformation -> template.yaml

    Trivy emits individual Misconfigurations with a Status field:
        "PASS" -> check passed on this template
        "FAIL" / "WARN" -> check failed; Severity is recorded

    When trivy does not emit individual PASS objects it still reports them
    as MisconfSummary.Successes; we fall back to that count.

    Returns a dict:
        trivy_passed, all_check_ids, passed_check_ids, failed_check_ids,
        severity_counts, total_checks, total_passed, total_failed, error
    """
    filename = "main.tf" if iac_type == "terraform" else "template.yaml"

    blank: dict = {
        "trivy_passed":     False,
        "all_check_ids":    [],
        "passed_check_ids": [],
        "failed_check_ids": [],
        "severity_counts":  {s: 0 for s in SEVERITIES},
        "total_checks":     0,
        "total_passed":     0,
        "total_failed":     0,
        "error":            None,
    }

    with tempfile.TemporaryDirectory() as tmpdir:
        (Path(tmpdir) / filename).write_text(template, encoding="utf-8")

        try:
            proc = subprocess.run(
                [
                    "trivy", "config",
                    "--format", "json",
                    "--exit-code", "0",
                    "--include-non-failures",
                    tmpdir,
                ],
                capture_output=True, text=True, timeout=120,
            )
        except FileNotFoundError:
            blank["error"] = (
                "trivy not installed. "
                "See: https://aquasecurity.github.io/trivy/latest/getting-started/installation/"
            )
            return blank
        except subprocess.TimeoutExpired:
            blank["error"] = "trivy timed out after 120 s"
            return blank

        raw = proc.stdout or proc.stderr
        try:
            data = json.loads(raw)
        except json.JSONDecodeError:
            blank["error"] = f"trivy JSON parse failed: {raw[:300]}"
            return blank

        passed_ids: list[str] = []
        failed_ids: list[str] = []
        sev_counts = {s: 0 for s in SEVERITIES}
        summary_successes = 0

        for res in data.get("Results", []):
            summary = res.get("MisconfSummary") or {}
            summary_successes += int(summary.get("Successes", 0) or 0)

            for m in res.get("Misconfigurations", []):
                cid      = m.get("ID") or "UNKNOWN"
                status   = (m.get("Status") or "FAIL").upper()
                severity = (m.get("Severity") or "UNKNOWN").upper()
                if severity not in SEVERITIES:
                    severity = "UNKNOWN"

                if status == "PASS":
                    passed_ids.append(cid)
                else:
                    failed_ids.append(cid)
                    sev_counts[severity] += 1

        # Fallback: use summary count when no individual PASS items are emitted
        if not passed_ids and summary_successes:
            passed_ids = [f"PASS_SUMMARY#{i}" for i in range(summary_successes)]

        all_ids = list(dict.fromkeys(passed_ids + failed_ids))
        total_p = len(passed_ids)
        total_f = len(failed_ids)

        return {
            "trivy_passed":     total_f == 0,
            "all_check_ids":    all_ids,
            "passed_check_ids": list(dict.fromkeys(passed_ids)),
            "failed_check_ids": list(dict.fromkeys(failed_ids)),
            "severity_counts":  sev_counts,
            "total_checks":     total_p + total_f,
            "total_passed":     total_p,
            "total_failed":     total_f,
            "error":            None,
        }


# ---------------------------------------------------------------------------
# Aggregate all rows
# ---------------------------------------------------------------------------

def aggregate(rows: list[dict]) -> dict:
    all_ids = set(); all_passed = set(); all_failed = set()
    sev_totals = {s: 0 for s in SEVERITIES}
    g_checks = g_passed = g_failed = 0

    for r in rows:
        all_ids    |= set(r["all_check_ids"])
        all_passed |= set(r["passed_check_ids"])
        all_failed |= set(r["failed_check_ids"])
        for s, c in r["severity_counts"].items():
            sev_totals[s] += c
        g_checks += r["total_checks"]
        g_passed += r["total_passed"]
        g_failed += r["total_failed"]

    return {
        "rows_scanned":          len(rows),
        "rows_trivy_passed":     sum(1 for r in rows if r["trivy_passed"]),
        "rows_trivy_failed":     sum(1 for r in rows if not r["trivy_passed"]),
        "rows_with_errors":      sum(1 for r in rows if r.get("error")),
        "all_unique_check_ids":  sorted(all_ids),
        "all_passed_check_ids":  sorted(all_passed),
        "all_failed_check_ids":  sorted(all_failed),
        "total_severity_counts": sev_totals,
        "grand_total_checks":    g_checks,
        "grand_total_passed":    g_passed,
        "grand_total_failed":    g_failed,
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="trivy_csv_audit.py",
        description="Run Trivy misconfiguration scans on every row of a CSV file.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--input",  "-i", required=True, metavar="CSV",
                   help="Input CSV path (must have a `final_template` column).")
    p.add_argument("--type",   "-t", dest="iac_type",
                   choices=["cloudformation", "terraform"], default="cloudformation",
                   help="IaC type: cloudformation (default) or terraform.")
    p.add_argument("--output", "-o", metavar="JSON", default=None,
                   help="Write full results (per-row + aggregate) to this JSON file.")
    p.add_argument("--output-csv", metavar="CSV_OUT", default=None,
                   help="Write flat per-row summary to this CSV file.")
    p.add_argument("--limit", type=int, default=None, metavar="N",
                   help="Process only the first N rows.")
    p.add_argument("--skip-empty", action="store_true",
                   help="Skip rows with an empty `final_template`.")
    return p


def main() -> None:
    args = build_parser().parse_args()

    csv_path = Path(args.input)
    if not csv_path.exists():
        raise SystemExit(f"[ERROR] Input file not found: {csv_path}")

    print(f"[INFO] Input   : {csv_path}")
    print(f"[INFO] IaC type: {args.iac_type}")
    if args.limit:
        print(f"[INFO] Row limit: {args.limit}")
    print()

    row_results: list[dict] = []

    with csv_path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        if "final_template" not in (reader.fieldnames or []):
            raise SystemExit(
                "[ERROR] CSV missing `final_template` column.\n"
                f"        Found: {reader.fieldnames}"
            )

        for i, row in enumerate(reader):
            if args.limit is not None and i >= args.limit:
                break

            template = (row.get("final_template") or "").strip()
            run_id   = row.get("run_id") or row.get("row_number") or str(i)

            if not template:
                if args.skip_empty:
                    print(f"  [{i:>4}] {run_id:<32} SKIPPED (empty)")
                    continue
                r = {
                    "row_index": i, "run_id": run_id,
                    "trivy_passed": False, "all_check_ids": [],
                    "passed_check_ids": [], "failed_check_ids": [],
                    "severity_counts": {s: 0 for s in SEVERITIES},
                    "total_checks": 0, "total_passed": 0, "total_failed": 0,
                    "error": "empty template",
                }
                row_results.append(r)
                print(f"  [{i:>4}] {run_id:<32} FAIL  (empty template)")
                continue

            print(f"  [{i:>4}] {run_id:<32} scanning ...", end=" ", flush=True)
            r = run_trivy(template, args.iac_type)
            r["row_index"] = i
            r["run_id"]    = run_id
            row_results.append(r)

            if r["error"]:
                label = f"ERROR ({r['error'][:60]})"
            else:
                label = "PASS" if r["trivy_passed"] else "FAIL"

            sev_parts = [
                f"{s}={r['severity_counts'][s]}"
                for s in SEVERITIES if r["severity_counts"][s]
            ]
            print(
                f"{label:<8} total={r['total_checks']:>3} "
                f"passed={r['total_passed']:>3} failed={r['total_failed']:>3}"
                + (f"  [{' '.join(sev_parts)}]" if sev_parts else "")
            )

    if not row_results:
        print("[WARN] No rows processed.")
        return

    agg = aggregate(row_results)
    SEP = "=" * 70

    print()
    print(SEP)
    print("AGGREGATE SUMMARY")
    print(SEP)
    print(f"  Rows scanned          : {agg['rows_scanned']}")
    print(f"  Rows PASSED (trivy)   : {agg['rows_trivy_passed']}")
    print(f"  Rows FAILED (trivy)   : {agg['rows_trivy_failed']}")
    print(f"  Rows with errors      : {agg['rows_with_errors']}")
    print()
    print(f"  Grand total checks    : {agg['grand_total_checks']}")
    print(f"  Grand total passed    : {agg['grand_total_passed']}")
    print(f"  Grand total failed    : {agg['grand_total_failed']}")
    print()
    print("  Severity breakdown (failed checks):")
    for s in SEVERITIES:
        c = agg["total_severity_counts"][s]
        print(f"    {s:<10} {c:>6}  {'#' * min(c, 50)}")

    passed_set = set(agg["all_passed_check_ids"])
    failed_set = set(agg["all_failed_check_ids"])
    n_uniq = len(agg["all_unique_check_ids"])

    print()
    print(f"  All unique check IDs ({n_uniq}):")
    for cid in agg["all_unique_check_ids"]:
        tags = []
        if cid in failed_set: tags.append("FAILED")
        if cid in passed_set: tags.append("PASSED")
        print(f"    {cid:<42} [{'/'.join(tags)}]")

    print()
    print(f"  Failed check IDs ({len(failed_set)}) with row frequency:")
    for cid in sorted(failed_set):
        freq = sum(1 for r in row_results if cid in r["failed_check_ids"])
        print(f"    {cid:<42} {freq} rows")

    print()
    passed_only = sorted(passed_set - failed_set)
    print(f"  Passed-only check IDs ({len(passed_only)}) — never failed:")
    for cid in passed_only:
        print(f"    {cid}")

    # --- JSON output ---
    if args.output:
        Path(args.output).write_text(
            json.dumps({"aggregate": agg, "rows": row_results}, indent=2),
            encoding="utf-8",
        )
        print(f"\n[INFO] JSON written  : {args.output}")

    # --- CSV output ---
    if args.output_csv:
        cols = (
            ["row_index", "run_id", "trivy_passed",
             "total_checks", "total_passed", "total_failed"]
            + [f"severity_{s.lower()}" for s in SEVERITIES]
            + ["passed_check_ids", "failed_check_ids", "all_check_ids", "error"]
        )
        with open(args.output_csv, "w", newline="", encoding="utf-8") as fh:
            w = csv.DictWriter(fh, fieldnames=cols)
            w.writeheader()
            for r in row_results:
                w.writerow({
                    "row_index":        r["row_index"],
                    "run_id":           r["run_id"],
                    "trivy_passed":     r["trivy_passed"],
                    "total_checks":     r["total_checks"],
                    "total_passed":     r["total_passed"],
                    "total_failed":     r["total_failed"],
                    **{f"severity_{s.lower()}": r["severity_counts"][s] for s in SEVERITIES},
                    "passed_check_ids": ";".join(r["passed_check_ids"]),
                    "failed_check_ids": ";".join(r["failed_check_ids"]),
                    "all_check_ids":    ";".join(r["all_check_ids"]),
                    "error":            r.get("error") or "",
                })
        print(f"[INFO] CSV written   : {args.output_csv}")


if __name__ == "__main__":
    main()