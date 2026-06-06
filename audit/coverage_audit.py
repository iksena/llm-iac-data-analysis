#!/usr/bin/env python3
"""
intent_coverage_audit.py
========================
Measures **user-intent coverage** and **resource accuracy** for LLM-generated
IaC templates stored in a CSV file (e.g. DeepseekV4Flash_security.csv).

Each row in the input CSV is matched by `row_number` to the benchmark file
`iac_with_user_intent.csv` (from Tianyi2/IaCGen) which supplies:
  - ground_truth_path   : path to the reference template file
  - prompt              : original user intent prompt
  - resources           : expected resource types (comma-separated)
  - resource_count      : expected number of resources
  - needed_resources    : resources explicitly required by user intent
  - difficulty_level    : 1-5 complexity scale

For every matched row the script computes (reproducing `analyze_resource_coverage`):
  - total_required_resources  — how many resources the ground truth has
  - total_generated_resources — how many the LLM generated
  - correct_resources         — matched (min of req vs gen per type)
  - missing_resources         — present in ground truth, absent in generated
  - extra_resources           — present in generated, absent in ground truth
  - coverage_pct              — correct / required × 100  (recall)
  - accuracy_pct              — correct / generated × 100 (precision)
  - intent_coverage_pct       — correct-intent / needed_resources × 100
                                (only rows that have needed_resources set)

Usage
-----
    python intent_coverage_audit.py \\
        --input   Result/iacgod/DeepseekV4Flash_security.csv \\
        --benchmark Data/iac_with_user_intent.csv \\
        [--output  results.json] \\
        [--output-csv results_coverage.csv] \\
        [--limit 20] \\
        [--skip-unmatched]

Requirements
------------
    pip install pyyaml pandas
"""

import argparse
import csv
import json
import re
import sys
import tempfile
import io
from collections import Counter
from pathlib import Path

try:
    import yaml
except ImportError:
    sys.exit("[ERROR] PyYAML not installed. Run: pip install pyyaml")

try:
    import pandas as pd
except ImportError:
    sys.exit("[ERROR] pandas not installed. Run: pip install pandas")


# ---------------------------------------------------------------------------
# CloudFormation-aware YAML loader (mirrors IaCGen helper)
# ---------------------------------------------------------------------------

def _make_cfn_loader():
    """Return a YAML SafeLoader that tolerates CloudFormation intrinsic tags."""
    class CfnLoader(yaml.SafeLoader):
        pass

    def _construct_cfn_tag(loader, node):
        if isinstance(node, yaml.ScalarNode):
            return node.value
        elif isinstance(node, yaml.SequenceNode):
            return loader.construct_sequence(node)
        elif isinstance(node, yaml.MappingNode):
            return loader.construct_mapping(node)

    cfn_tags = [
        "!Ref", "!Sub", "!GetAtt", "!Join", "!Select", "!Split",
        "!Equals", "!If", "!FindInMap", "!GetAZs", "!Base64", "!Cidr",
        "!Transform", "!ImportValue", "!Not", "!And", "!Or",
        "!Condition", "!ForEach", "!ValueOf", "!Rain::Embed",
    ]
    for tag in cfn_tags:
        CfnLoader.add_constructor(tag, _construct_cfn_tag)

    return CfnLoader


CFN_LOADER = _make_cfn_loader()


def _make_tf_loader():
    """Minimal loader for Terraform HCL — just tries yaml.safe_load as a no-op fallback."""
    return yaml.SafeLoader  # Terraform is HCL, not YAML; see extract_tf_resources below


# ---------------------------------------------------------------------------
# Resource extraction from templates
# ---------------------------------------------------------------------------

def extract_cfn_resource_types(template_str: str) -> list[str]:
    """
    Parse a CloudFormation YAML/JSON template string and return
    the list of resource types (preserving duplicates, as IaCGen does).
    Returns [] on parse failure.
    """
    template_str = template_str.strip()
    if not template_str:
        return []
    try:
        if template_str.startswith("{"):
            doc = json.loads(template_str)
        else:
            doc = yaml.load(template_str, Loader=CFN_LOADER)
        resources = doc.get("Resources", {}) if isinstance(doc, dict) else {}
        return [v["Type"] for v in resources.values() if isinstance(v, dict) and "Type" in v]
    except Exception:
        return []


def extract_tf_resource_types(template_str: str) -> list[str]:
    """
    Parse a Terraform HCL template string and return a list of resource type
    identifiers in the form `aws_<type>` (or the raw provider type string).
    Uses regex since HCL is not YAML/JSON.
    Returns [] if nothing found.
    """
    template_str = template_str.strip()
    if not template_str:
        return []
    # Match: resource "aws_something" "name" {
    pattern = re.compile(r'^\s*resource\s+"([^"]+)"\s+"[^"]*"\s*\{', re.MULTILINE)
    return pattern.findall(template_str)


def extract_resource_types(template_str: str, iac_type: str) -> list[str]:
    if iac_type == "terraform":
        return extract_tf_resource_types(template_str)
    return extract_cfn_resource_types(template_str)


def load_ground_truth_resource_types(ground_truth_path: str) -> list[str]:
    """
    Load resource types from an on-disk ground truth template file.
    Returns [] if the file cannot be read or parsed.
    """
    p = Path(ground_truth_path)
    # Try both the path as-is and normalised (Windows → POSIX separators)
    for candidate in [p, Path(ground_truth_path.replace("\\", "/"))]:
        if candidate.exists():
            try:
                content = candidate.read_text(encoding="utf-8")
                # Ground truth is always CloudFormation YAML in this benchmark
                types = extract_cfn_resource_types(content)
                if types:
                    return types
            except Exception:
                pass
    return []


# ---------------------------------------------------------------------------
# Core metric: analyze_resource_coverage (mirrors IaCGen implementation)
# ---------------------------------------------------------------------------

def analyze_resource_coverage(
    required_resources: list[str],
    generated_resources: list[str],
) -> dict:
    """
    Reproduce `analyze_resource_coverage` from IaCGen/Code/evaluation/cloud_evaluation.py.

    Handles duplicate resource types by counting occurrences:
      - correct   = min(required_count, generated_count) per type
      - missing   = required_count - generated_count  (when req > gen)
      - extra     = generated_count - required_count  (when gen > req)
      - coverage  = correct / required  × 100   (recall)
      - accuracy  = correct / generated × 100   (precision)
    """
    required_counts  = Counter(required_resources)
    generated_counts = Counter(generated_resources)

    all_types = set(required_counts) | set(generated_counts)
    correct: list[str]  = []
    missing: list[str]  = []
    extra:   list[str]  = []

    for rtype in all_types:
        req = required_counts.get(rtype, 0)
        gen = generated_counts.get(rtype, 0)
        correct.extend([rtype] * min(req, gen))
        if req > gen:
            missing.extend([rtype] * (req - gen))
        elif gen > req:
            extra.extend([rtype] * (gen - req))

    n_req = len(required_resources)
    n_gen = len(generated_resources)
    n_cor = len(correct)

    return {
        "total_required_resources":  n_req,
        "total_generated_resources": n_gen,
        "correct_resources":         n_cor,
        "missing_resources":         len(missing),
        "extra_resources":           len(extra),
        "coverage_pct":   round(n_cor / n_req * 100, 2) if n_req else 0.0,
        "accuracy_pct":   round(n_cor / n_gen * 100, 2) if n_gen else 0.0,
        "resource_details": {
            "correct": correct,
            "missing": missing,
            "extra":   extra,
        },
    }


# ---------------------------------------------------------------------------
# User-intent coverage
# ---------------------------------------------------------------------------

def parse_resource_list(cell: str) -> list[str]:
    """
    Parse a comma-separated resource type list from a CSV cell.
    e.g. 'AWS::S3::Bucket, AWS::KMS::Key' -> ['AWS::S3::Bucket', 'AWS::KMS::Key']
    Handles empty / NaN gracefully.
    """
    if not cell or (isinstance(cell, float)):
        return []
    return [r.strip() for r in str(cell).split(",") if r.strip()]


def intent_coverage(
    needed_resources: list[str],
    generated_resources: list[str],
) -> dict:
    """
    Measure how many of the *user-intent-specific* resources were generated.
    Uses the same counting logic as analyze_resource_coverage but scoped to
    the `needed_resources` subset defined in the benchmark.
    """
    if not needed_resources:
        return {"intent_coverage_pct": None, "intent_correct": 0, "intent_needed": 0}

    needed_counts    = Counter(needed_resources)
    generated_counts = Counter(generated_resources)

    intent_correct = 0
    for rtype, req_count in needed_counts.items():
        intent_correct += min(req_count, generated_counts.get(rtype, 0))

    n_needed = len(needed_resources)
    return {
        "intent_coverage_pct": round(intent_correct / n_needed * 100, 2),
        "intent_correct":      intent_correct,
        "intent_needed":       n_needed,
    }


# ---------------------------------------------------------------------------
# Aggregate helpers
# ---------------------------------------------------------------------------

def aggregate_metrics(rows: list[dict]) -> dict:
    matched = [r for r in rows if r.get("matched")]

    def avg(key):
        vals = [r[key] for r in matched if r.get(key) is not None]
        return round(sum(vals) / len(vals), 4) if vals else None

    intent_rows = [r for r in matched if r.get("intent_coverage_pct") is not None]

    return {
        "total_rows_in_input":           len(rows),
        "rows_matched_to_benchmark":     len(matched),
        "rows_unmatched":                sum(1 for r in rows if not r.get("matched")),
        "rows_with_empty_template":      sum(1 for r in rows if r.get("template_empty")),
        "rows_with_parse_error":         sum(1 for r in rows if r.get("parse_error")),
        "rows_with_missing_gt_file":     sum(1 for r in rows if r.get("gt_missing")),
        # Coverage / accuracy (all matched rows)
        "mean_coverage_pct":             avg("coverage_pct"),
        "mean_accuracy_pct":             avg("accuracy_pct"),
        # Intent coverage (rows with needed_resources set)
        "rows_with_intent_data":         len(intent_rows),
        "mean_intent_coverage_pct":      (
            round(sum(r["intent_coverage_pct"] for r in intent_rows) / len(intent_rows), 4)
            if intent_rows else None
        ),
        # Resource totals
        "grand_total_required":          sum(r.get("total_required_resources", 0) for r in matched),
        "grand_total_generated":         sum(r.get("total_generated_resources", 0) for r in matched),
        "grand_total_correct":           sum(r.get("correct_resources", 0) for r in matched),
        "grand_total_missing":           sum(r.get("missing_resources", 0) for r in matched),
        "grand_total_extra":             sum(r.get("extra_resources", 0) for r in matched),
        # Micro-averaged (global pool)
        "micro_coverage_pct": (
            round(
                sum(r.get("correct_resources", 0) for r in matched)
                / sum(r.get("total_required_resources", 0) for r in matched)
                * 100, 4
            )
            if sum(r.get("total_required_resources", 0) for r in matched) > 0
            else None
        ),
        "micro_accuracy_pct": (
            round(
                sum(r.get("correct_resources", 0) for r in matched)
                / sum(r.get("total_generated_resources", 0) for r in matched)
                * 100, 4
            )
            if sum(r.get("total_generated_resources", 0) for r in matched) > 0
            else None
        ),
    }


# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        prog="intent_coverage_audit.py",
        description=(
            "Measure resource coverage, accuracy, and user-intent coverage of "
            "LLM-generated IaC templates against the IaCGen benchmark."
        ),
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("--input",      "-i", required=True,  metavar="CSV",
                   help="Input CSV with `final_template` and `row_number` columns.")
    p.add_argument("--benchmark",  "-b", required=True,  metavar="CSV",
                   help="Benchmark CSV (iac_with_user_intent.csv from Tianyi2/IaCGen).")
    p.add_argument("--type",       "-t", dest="iac_type",
                   choices=["cloudformation", "terraform"], default="cloudformation",
                   help="IaC type of the generated templates (default: cloudformation).")
    p.add_argument("--output",     "-o", metavar="JSON", default=None,
                   help="Write per-row + aggregate results to JSON.")
    p.add_argument("--output-csv", metavar="CSV_OUT",   default=None,
                   help="Write flat per-row summary to CSV.")
    p.add_argument("--limit",      type=int, default=None, metavar="N",
                   help="Process only the first N rows.")
    p.add_argument("--skip-unmatched", action="store_true",
                   help="Silently skip rows with no matching benchmark entry.")
    return p


def main() -> None:
    args = build_parser().parse_args()

    # --- Load benchmark index keyed by row_number ---
    bench_path = Path(args.benchmark)
    if not bench_path.exists():
        sys.exit(f"[ERROR] Benchmark file not found: {bench_path}")

    bench_df = pd.read_csv(bench_path, dtype=str)
    bench_df["row_number"] = bench_df["row_number"].astype(str).str.strip()

    # Build lookup dict: row_number_str -> benchmark row dict
    benchmark: dict[str, dict] = {
        str(row["row_number"]): row.to_dict()
        for _, row in bench_df.iterrows()
    }

    print(f"[INFO] Benchmark loaded : {bench_path}  ({len(benchmark)} entries)")

    # --- Load input CSV ---
    input_path = Path(args.input)
    if not input_path.exists():
        sys.exit(f"[ERROR] Input file not found: {input_path}")

    with input_path.open(encoding="utf-8", newline="") as fh:
        reader = csv.DictReader(fh)
        fieldnames = reader.fieldnames or []
        if "final_template" not in fieldnames:
            sys.exit(
                f"[ERROR] CSV missing `final_template` column.\n"
                f"        Found: {fieldnames}"
            )
        if "row_number" not in fieldnames:
            sys.exit(
                f"[ERROR] CSV missing `row_number` column.\n"
                f"        Found: {fieldnames}"
            )
        input_rows = list(reader)

    print(f"[INFO] Input CSV loaded : {input_path}  ({len(input_rows)} rows)")
    print(f"[INFO] IaC type         : {args.iac_type}")
    if args.limit:
        print(f"[INFO] Row limit        : {args.limit}")
    print()

    SEP = "─" * 72
    row_results: list[dict] = []

    for i, row in enumerate(input_rows):
        if args.limit is not None and i >= args.limit:
            break

        row_num   = str(row.get("row_number", "")).strip()
        template  = (row.get("final_template") or "").strip()

        result: dict = {
            "row_index":    i,
            "row_number":   row_num,
            "matched":      False,
            "template_empty": not bool(template),
            "parse_error":  False,
            "gt_missing":   False,
            # Benchmark metadata (filled when matched)
            "prompt":               None,
            "difficulty_level":     None,
            "ground_truth_path":    None,
            "expected_resource_count": None,
            # Metric fields
            "total_required_resources":  0,
            "total_generated_resources": 0,
            "correct_resources":         0,
            "missing_resources":         0,
            "extra_resources":           0,
            "coverage_pct":              None,
            "accuracy_pct":              None,
            "intent_coverage_pct":       None,
            "intent_correct":            0,
            "intent_needed":             0,
            "correct_resource_types":    [],
            "missing_resource_types":    [],
            "extra_resource_types":      [],
            "generated_resource_types":  [],
            "required_resource_types":   [],
        }

        # --- Match to benchmark ---
        bench_row = benchmark.get(row_num)
        if bench_row is None:
            msg = f"NO BENCHMARK MATCH for row_number={row_num!r}"
            if args.skip_unmatched:
                print(f"  [{i:>4}] row={row_num:<6} SKIP  ({msg})")
            else:
                print(f"  [{i:>4}] row={row_num:<6} WARN  ({msg})")
            row_results.append(result)
            continue

        result["matched"]           = True
        result["prompt"]            = bench_row.get("prompt", "")
        result["difficulty_level"]  = bench_row.get("difficulty_level", "")
        result["ground_truth_path"] = bench_row.get("ground_truth_path", "")
        result["expected_resource_count"] = bench_row.get("resource_count", "")

        # --- Handle empty template ---
        if not template:
            print(f"  [{i:>4}] row={row_num:<6} FAIL  (empty template)")
            result["coverage_pct"] = 0.0
            result["accuracy_pct"] = 0.0
            row_results.append(result)
            continue

        # --- Extract generated resource types ---
        generated_types = extract_resource_types(template, args.iac_type)
        if not generated_types:
            result["parse_error"] = True

        result["generated_resource_types"] = generated_types

        # --- Load ground truth resource types ---
        gt_path = bench_row.get("ground_truth_path", "")
        gt_types = load_ground_truth_resource_types(gt_path)

        if not gt_types:
            # Fall back to the `resources` column in the benchmark CSV
            gt_types = parse_resource_list(bench_row.get("resources", ""))

        if not gt_types:
            result["gt_missing"] = True
            print(
                f"  [{i:>4}] row={row_num:<6} WARN  "
                f"(ground truth not loadable, path={gt_path!r})"
            )
            row_results.append(result)
            continue

        result["required_resource_types"] = gt_types

        # --- Resource coverage (analyze_resource_coverage) ---
        cov = analyze_resource_coverage(gt_types, generated_types)
        result.update({
            "total_required_resources":  cov["total_required_resources"],
            "total_generated_resources": cov["total_generated_resources"],
            "correct_resources":         cov["correct_resources"],
            "missing_resources":         cov["missing_resources"],
            "extra_resources":           cov["extra_resources"],
            "coverage_pct":              cov["coverage_pct"],
            "accuracy_pct":              cov["accuracy_pct"],
            "correct_resource_types":    cov["resource_details"]["correct"],
            "missing_resource_types":    cov["resource_details"]["missing"],
            "extra_resource_types":      cov["resource_details"]["extra"],
        })

        # --- User-intent coverage ---
        needed = parse_resource_list(bench_row.get("needed_resources", ""))
        intent = intent_coverage(needed, generated_types)
        result.update(intent)

        # --- Console output ---
        intent_str = (
            f"  intent={intent['intent_coverage_pct']:>6.1f}%"
            if intent["intent_coverage_pct"] is not None
            else ""
        )
        print(
            f"  [{i:>4}] row={row_num:<6} "
            f"cov={cov['coverage_pct']:>6.1f}%  acc={cov['accuracy_pct']:>6.1f}%"
            f"{intent_str}  "
            f"[req={cov['total_required_resources']} "
            f"gen={cov['total_generated_resources']} "
            f"cor={cov['correct_resources']} "
            f"miss={cov['missing_resources']} "
            f"extra={cov['extra_resources']}]"
        )
        row_results.append(result)

    # -------------------------------------------------------------------
    # Aggregate
    # -------------------------------------------------------------------
    agg = aggregate_metrics(row_results)

    print()
    print(SEP)
    print("AGGREGATE SUMMARY")
    print(SEP)
    print(f"  Total rows in input          : {agg['total_rows_in_input']}")
    print(f"  Matched to benchmark         : {agg['rows_matched_to_benchmark']}")
    print(f"  Unmatched                    : {agg['rows_unmatched']}")
    print(f"  Empty templates              : {agg['rows_with_empty_template']}")
    print(f"  Parse errors                 : {agg['rows_with_parse_error']}")
    print(f"  Missing ground-truth files   : {agg['rows_with_missing_gt_file']}")
    print()
    print("  Resource Coverage (recall — correct / required):")
    print(f"    Mean (macro avg)           : {agg['mean_coverage_pct']}")
    print(f"    Micro avg (global pool)    : {agg['micro_coverage_pct']}")
    print()
    print("  Resource Accuracy (precision — correct / generated):")
    print(f"    Mean (macro avg)           : {agg['mean_accuracy_pct']}")
    print(f"    Micro avg (global pool)    : {agg['micro_accuracy_pct']}")
    print()
    print(f"  User-Intent Coverage (rows with intent data: {agg['rows_with_intent_data']}):")
    print(f"    Mean intent coverage       : {agg['mean_intent_coverage_pct']}")
    print()
    print(f"  Grand totals  required={agg['grand_total_required']}  "
          f"generated={agg['grand_total_generated']}  "
          f"correct={agg['grand_total_correct']}  "
          f"missing={agg['grand_total_missing']}  "
          f"extra={agg['grand_total_extra']}")

    # -------------------------------------------------------------------
    # Optional output files
    # -------------------------------------------------------------------
    if args.output:
        Path(args.output).write_text(
            json.dumps({"aggregate": agg, "rows": row_results}, indent=2),
            encoding="utf-8",
        )
        print(f"\n[INFO] JSON written      : {args.output}")

    if args.output_csv:
        flat_cols = [
            "row_index", "row_number", "matched", "difficulty_level",
            "total_required_resources", "total_generated_resources",
            "correct_resources", "missing_resources", "extra_resources",
            "coverage_pct", "accuracy_pct",
            "intent_coverage_pct", "intent_correct", "intent_needed",
            "template_empty", "parse_error", "gt_missing",
            "ground_truth_path",
            "correct_resource_types", "missing_resource_types",
            "extra_resource_types", "generated_resource_types",
            "prompt",
        ]
        with open(args.output_csv, "w", newline="", encoding="utf-8") as fh:
            writer = csv.DictWriter(fh, fieldnames=flat_cols, extrasaction="ignore")
            writer.writeheader()
            for r in row_results:
                flat = dict(r)
                # Serialise list columns to semicolon-separated strings
                for col in [
                    "correct_resource_types", "missing_resource_types",
                    "extra_resource_types", "generated_resource_types",
                    "required_resource_types",
                ]:
                    flat[col] = ";".join(flat.get(col) or [])
                writer.writerow(flat)
        print(f"[INFO] CSV written       : {args.output_csv}")


if __name__ == "__main__":
    main()