#!/usr/bin/env python3
"""
run_deployability_check.py
──────────────────────────
Standalone deployability checker for the IaC benchmark dataset.
Mirrors the IaCGen deploy → reset loop (Tianyi2/IaCGen, Code/evaluation/cloud_evaluation.py).

Supports two backends, selected via --backend:
  localstack  (default)  uses tflocal; resets via POST /_localstack/state/reset after each apply
  aws                    uses terraform directly; resets via terraform destroy after each apply

Workflow per template
─────────────────────
1. Write content to a fresh isolated temp directory
2. tf init
3. tf validate
4. tf apply -auto-approve          ← REAL deployability check (not just plan)
5. RESET environment:
     localstack → POST /_localstack/state/reset  (wipes ALL localstack state)
     aws        → terraform destroy -auto-approve
6. Wipe temp directory             ← hard filesystem reset
7. Append result row to output CSV (written after every file, crash-safe)

Usage
─────
# LocalStack (default)
docker run --rm -p 4566:4566 localstack/localstack
python run_deployability_check.py --index index.csv --output results.csv

# Real AWS
python run_deployability_check.py --index index.csv --output results.csv --backend aws

Optional flags:
  --region         AWS region (default: ap-southeast-2)
  --sample N       Stratified sample of N rows
  --workers N      Parallel workers (LocalStack only; default 1)
  --skip-destroy   Skip reset step (faster, NOT greenfield-safe)
  --tf-cache PATH  TF_PLUGIN_CACHE_DIR for faster repeated inits
  --resume         Skip rows already in output CSV
"""

import argparse
import csv
import json
import logging
import os
import shutil
import subprocess
import sys
import tempfile
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime
from pathlib import Path

import pandas as pd
import requests
from tqdm import tqdm

# ── Logging ───────────────────────────────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    handlers=[
        logging.StreamHandler(sys.stdout),
        logging.FileHandler('deployability_check.log', mode='a'),
    ]
)
log = logging.getLogger(__name__)

# ── Constants ─────────────────────────────────────────────────────────────────
TIMEOUT_INIT     = 300
TIMEOUT_VALIDATE = 60
TIMEOUT_APPLY    = 300   # real apply replaces plan; longer timeout needed
TIMEOUT_DESTROY  = 300

LOCALSTACK_ENDPOINT    = os.getenv('AWS_ENDPOINT_URL', 'http://localhost:4566')
LOCALSTACK_STATE_RESET = f"{LOCALSTACK_ENDPOINT}/_localstack/state/reset"

OUTPUT_COLS = [
    'source_slug', 'source_category', 'primary_cloud', 'licence_spdx',
    'dest_file', 'github_url', 'loc', 'tokens', 'difficulty',
    'hcl2_valid', 'tflint_pass', 'yaml_valid', 'targets_aws',
    'init_ok', 'validate_ok', 'apply_ok',
    'deploy_error', 'deploy_stage', 'reset_ok', 'backend', 'checked_at',
]


# ── Provider injection ────────────────────────────────────────────────────────
def _inject_provider(content: str, region: str) -> str:
    """Prepend a minimal AWS provider block if none exists."""
    if 'provider "aws"' not in content and "provider 'aws'" not in content:
        return f'provider "aws" {{\n  region = "{region}"\n}}\n\n' + content
    return content


# ── Reset helpers ─────────────────────────────────────────────────────────────
def _reset_localstack() -> tuple[bool, str]:
    """
    Wipe ALL LocalStack state via its HTTP reset endpoint.
    This is the cleanest greenfield reset — equivalent to IaCGen's
    unconditional delete_stack() after every template.
    """
    try:
        resp = requests.post(LOCALSTACK_STATE_RESET, timeout=30)
        if resp.status_code == 200:
            return True, 'LocalStack state reset OK'
        return False, f'LocalStack reset HTTP {resp.status_code}: {resp.text[:200]}'
    except requests.RequestException as e:
        return False, f'LocalStack reset failed: {e}'


def _destroy_terraform(tmpd: str, tf_bin: str, env: dict) -> tuple[bool, str]:
    """
    Run terraform destroy to remove real AWS resources after apply.
    Always called unconditionally, mirroring IaCGen's OnFailure='DELETE'
    + explicit delete_stack on success.
    """
    try:
        r = subprocess.run(
            [tf_bin, 'destroy', '-auto-approve', '-no-color', '-input=false'],
            cwd=tmpd, capture_output=True, text=True,
            timeout=TIMEOUT_DESTROY, env=env,
        )
        if r.returncode == 0:
            return True, 'terraform destroy OK'
        return False, (r.stderr or r.stdout)[:500]
    except subprocess.TimeoutExpired:
        return False, f'terraform destroy timed out after {TIMEOUT_DESTROY}s'
    except Exception as e:
        return False, str(e)


# ── Core deploy cycle ─────────────────────────────────────────────────────────
def run_deploy_cycle(
    content: str,
    dest_file: str,
    region: str,
    backend: str,           # 'localstack' | 'aws'
    skip_destroy: bool,
    tf_plugin_cache: str | None,
) -> dict:
    """
    Full deploy → reset cycle for a single template.

    LocalStack:  uses tflocal binary (auto-injects endpoint overrides)
    AWS:         uses terraform binary directly with real credentials

    Reset strategy (always unconditional — greenfield guarantee):
      localstack → POST /_localstack/state/reset
      aws        → terraform destroy -auto-approve
    """
    result = {
        'init_ok':     False,
        'validate_ok': None,
        'apply_ok':    None,
        'deploy_error': '',
        'deploy_stage': '',
        'reset_ok':    None,
        'backend':     backend,
        'checked_at':  datetime.utcnow().isoformat(),
    }

    # ── Pick binary ───────────────────────────────────────────────────────────
    if backend == 'localstack':
        tf_bin = shutil.which('tflocal') or 'tflocal'
    else:
        tf_bin = shutil.which('terraform') or 'terraform'

    # ── Build environment ─────────────────────────────────────────────────────
    env = os.environ.copy()
    env['TF_IN_AUTOMATION'] = '1'
    env['TF_INPUT']         = '0'
    env['AWS_DEFAULT_REGION'] = region

    if backend == 'localstack':
        env.setdefault('AWS_ACCESS_KEY_ID',     'test')
        env.setdefault('AWS_SECRET_ACCESS_KEY', 'test')
        env['AWS_ENDPOINT_URL'] = LOCALSTACK_ENDPOINT
        env.setdefault('TF_CMD', shutil.which('terraform') or 'terraform')

    if tf_plugin_cache:
        env['TF_PLUGIN_CACHE_DIR'] = tf_plugin_cache

    # ── Isolated temp directory (wipes itself on context exit) ────────────────
    with tempfile.TemporaryDirectory(prefix='iac_deploy_') as tmpd:
        tf_file = Path(tmpd) / 'main.tf'
        tf_file.write_text(_inject_provider(content, region), encoding='utf-8')

        def _run(cmd: list[str], timeout: int):
            return subprocess.run(
                cmd, cwd=tmpd,
                capture_output=True, text=True,
                timeout=timeout, env=env,
            )

        # ── STEP 1: init ──────────────────────────────────────────────────────
        try:
            r = _run(
                [tf_bin, 'init', '-input=false', '-no-color',
                 '-upgrade=false', '-backend=false'],
                TIMEOUT_INIT,
            )
        except subprocess.TimeoutExpired:
            result['deploy_error'] = 'init timed out'
            result['deploy_stage'] = 'init'
            return result

        if r.returncode != 0:
            result['deploy_error'] = (r.stderr or r.stdout)[:2000]
            result['deploy_stage'] = 'init'
            return result

        result['init_ok'] = True

        # ── STEP 2: validate ──────────────────────────────────────────────────
        try:
            r = _run([tf_bin, 'validate', '-no-color', '-json'], TIMEOUT_VALIDATE)
        except subprocess.TimeoutExpired:
            result['deploy_error'] = 'validate timed out'
            result['deploy_stage'] = 'validate'
            return result

        try:
            vj = json.loads(r.stdout or '{}')
            validate_ok = vj.get('valid', r.returncode == 0)
            val_diags   = '; '.join(
                d.get('summary', '') for d in vj.get('diagnostics', [])
                if d.get('severity') == 'error'
            )
        except (json.JSONDecodeError, KeyError):
            validate_ok = r.returncode == 0
            val_diags   = (r.stderr or r.stdout)[:300]

        result['validate_ok'] = validate_ok
        if not validate_ok:
            result['deploy_error'] = val_diags[:500]
            result['deploy_stage'] = 'validate'
            return result

        # ── STEP 3: apply (real deployability check) ──────────────────────────
        # This replaces the previous plan-only approach.
        # For LocalStack: actually provisions mock resources (free, fast).
        # For AWS:        provisions real resources (costs money, use carefully).
        try:
            r = _run(
                [tf_bin, 'apply', '-auto-approve', '-no-color',
                 '-input=false', '-compact-warnings'],
                TIMEOUT_APPLY,
            )
        except subprocess.TimeoutExpired:
            result['deploy_error'] = f'apply timed out after {TIMEOUT_APPLY}s'
            result['deploy_stage'] = 'apply'
            # Still attempt reset — partial resources may have been created
            _do_reset(backend, tmpd, tf_bin, env, skip_destroy, result)
            return result

        apply_ok = r.returncode == 0
        result['apply_ok'] = apply_ok
        if not apply_ok:
            result['deploy_error'] = (r.stderr or r.stdout)[:2000]
            result['deploy_stage'] = 'apply'

        # ── STEP 4: RESET (unconditional — greenfield guarantee) ──────────────
        # Mirrors IaCGen: stack is deleted regardless of success/failure.
        # LocalStack → HTTP state reset (wipes everything instantly).
        # AWS        → terraform destroy (removes all provisioned resources).
        if not skip_destroy:
            _do_reset(backend, tmpd, tf_bin, env, skip_destroy, result)

        # TemporaryDirectory exit = hard filesystem wipe of tmpd

    return result


def _do_reset(
    backend: str,
    tmpd: str,
    tf_bin: str,
    env: dict,
    skip_destroy: bool,
    result: dict,
) -> None:
    """
    Perform the environment reset and record outcome in result dict.
    Separated out so both the normal path and the timeout path can call it.
    """
    if backend == 'localstack':
        reset_ok, reset_msg = _reset_localstack()
    else:
        reset_ok, reset_msg = _destroy_terraform(tmpd, tf_bin, env)

    result['reset_ok'] = reset_ok
    if not reset_ok:
        log.warning('Reset failed (%s): %s', backend, reset_msg)


# ── CSV helpers ───────────────────────────────────────────────────────────────
def _append_row(output_path: Path, row: dict):
    write_header = not output_path.exists()
    with output_path.open('a', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=OUTPUT_COLS, extrasaction='ignore')
        if write_header:
            writer.writeheader()
        writer.writerow(row)


def _already_checked(output_path: Path) -> set[str]:
    if not output_path.exists():
        return set()
    try:
        return set(pd.read_csv(output_path)['dest_file'].dropna().tolist())
    except Exception:
        return set()


# ── Stratified sample ─────────────────────────────────────────────────────────
def _stratified_sample(df: pd.DataFrame, n: int, seed: int = 42) -> pd.DataFrame:
    if 'difficulty' not in df.columns:
        return df.sample(min(n, len(df)), random_state=seed)
    per_level = max(1, n // df['difficulty'].nunique())
    return (
        df.groupby('difficulty', group_keys=False)
        .apply(lambda g: g.sample(min(len(g), per_level), random_state=seed))
        .reset_index(drop=True)
    )


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    parser = argparse.ArgumentParser(description='Terraform deployability checker')
    parser.add_argument('--index',   required=True, help='Path to index.csv')
    parser.add_argument('--output',  required=True, help='Path to output CSV')
    parser.add_argument('--backend', default='localstack',
                        choices=['localstack', 'aws'],
                        help='Backend to deploy against (default: localstack)')
    parser.add_argument('--region',  default='ap-southeast-2')
    parser.add_argument('--sample',  type=int, default=None)
    parser.add_argument('--workers', type=int, default=1,
                        help='Parallel workers (LocalStack only; AWS: keep 1)')
    parser.add_argument('--skip-destroy', action='store_true',
                        help='Skip reset step — NOT greenfield-safe')
    parser.add_argument('--tf-cache', default=None,
                        help='TF_PLUGIN_CACHE_DIR path')
    parser.add_argument('--resume',  action='store_true',
                        help='Skip rows already in output CSV')
    args = parser.parse_args()

    # ── Validate LocalStack is reachable ──────────────────────────────────────
    if args.backend == 'localstack':
        try:
            r = requests.get(f"{LOCALSTACK_ENDPOINT}/_localstack/health", timeout=5)
            log.info('LocalStack healthy: %s', r.json().get('status', 'unknown'))
        except requests.RequestException as e:
            log.error('Cannot reach LocalStack at %s: %s', LOCALSTACK_ENDPOINT, e)
            log.error('Start it first: docker run --rm -p 4566:4566 localstack/localstack')
            sys.exit(1)
    else:
        log.warning('Backend: REAL AWS — this will create and destroy real resources!')
        log.warning('Ensure AWS credentials and correct region are configured.')

    # ── Load + filter index ───────────────────────────────────────────────────
    index_path  = Path(args.index)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    df = pd.read_csv(index_path)
    log.info('Loaded index: %d rows', len(df))

    if args.resume:
        done   = _already_checked(output_path)
        before = len(df)
        df     = df[~df['dest_file'].isin(done)].copy()
        log.info('Resume: skipping %d done, %d remaining', before - len(df), len(df))

    if args.sample:
        df = _stratified_sample(df, args.sample)
        log.info('Stratified sample: %d rows', len(df))

    base_dir = index_path.parent.parent  # iac_benchmark/

    log.info('─' * 60)
    log.info('Backend      : %s', args.backend.upper())
    log.info('Apply timeout: %ds', TIMEOUT_APPLY)
    log.info('Reset method : %s',
             'POST /_localstack/state/reset' if args.backend == 'localstack'
             else 'terraform destroy -auto-approve')
    log.info('Templates    : %d', len(df))
    log.info('─' * 60)

    # ── Process rows ──────────────────────────────────────────────────────────
    def process_row(row_tuple):
        idx, row = row_tuple
        dest_file_path = base_dir / row['dest_file']

        if not dest_file_path.exists():
            log.warning('File not found: %s', dest_file_path)
            result = {
                'init_ok': False, 'validate_ok': None, 'apply_ok': None,
                'deploy_error': f'file_not_found: {dest_file_path}',
                'deploy_stage': 'pre_init', 'reset_ok': True,
                'backend': args.backend,
                'checked_at': datetime.utcnow().isoformat(),
            }
        else:
            content = dest_file_path.read_text(encoding='utf-8', errors='replace')
            try:
                result = run_deploy_cycle(
                    content        = content,
                    dest_file      = row['dest_file'],
                    region         = args.region,
                    backend        = args.backend,
                    skip_destroy   = args.skip_destroy,
                    tf_plugin_cache= args.tf_cache,
                )
            except Exception as exc:
                log.error('Unexpected error on %s: %s', row['dest_file'], exc)
                result = {
                    'init_ok': False, 'validate_ok': None, 'apply_ok': None,
                    'deploy_error': str(exc)[:2000],
                    'deploy_stage': 'exception', 'reset_ok': None,
                    'backend': args.backend,
                    'checked_at': datetime.utcnow().isoformat(),
                }

        out_row = {**row.to_dict(), **result}
        _append_row(output_path, out_row)

        status = '✅' if result.get('apply_ok') else '❌'
        log.debug('%s %s  stage=%s  reset=%s',
                  status, row['dest_file'],
                  result.get('deploy_stage', '—'),
                  result.get('reset_ok', '—'))
        return result.get('apply_ok', False)

    rows   = list(df.iterrows())
    passed = 0

    if args.workers > 1 and args.backend == 'localstack':
        with ThreadPoolExecutor(max_workers=args.workers) as pool:
            futures = {pool.submit(process_row, r): r for r in rows}
            for future in tqdm(as_completed(futures), total=len(rows), desc='terraform apply'):
                if future.result():
                    passed += 1
    else:
        if args.workers > 1 and args.backend == 'aws':
            log.warning('Parallel workers disabled for AWS backend (race conditions on real infra)')
        for row_tuple in tqdm(rows, desc='terraform apply'):
            if process_row(row_tuple):
                passed += 1

    # ── Summary ───────────────────────────────────────────────────────────────
    total = len(rows)
    log.info('=' * 60)
    log.info('DEPLOYABILITY CHECK COMPLETE')
    log.info(' Templates   : %d', total)
    log.info(' apply_ok    : %d (%.1f%%)', passed, 100 * passed / total if total else 0)
    log.info(' Output CSV  : %s', output_path.resolve())
    log.info('=' * 60)


if __name__ == '__main__':
    main()
