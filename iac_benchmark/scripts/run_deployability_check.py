#!/usr/bin/env python3
"""
run_deployability_check.py
──────────────────────────
Standalone deployability checker for the IaC benchmark dataset.
Mirrors the IaCGen deploy → reset loop (Tianyi2/IaCGen, Code/main.py).

Workflow per template
─────────────────────
1.  Write content to a fresh temp directory
2.  terraform init  (provider plugin downloaded once, then cached)
3.  terraform validate
4.  terraform plan  -refresh=false   ← dry-run, no real resources created
5.  terraform destroy -auto-approve  ← reset any state artefacts
6.  Wipe the temp directory          ← hard filesystem reset
7.  Append result row to output CSV  (written after every file, crash-safe)

Usage
─────
python scripts/run_deployability_check.py \
    --index  iac_benchmark/single_root_templates/index.csv \
    --output iac_benchmark/dataset/deployability_results.csv \
    --region ap-southeast-2 \
    [--sample N]          # optional: limit to N stratified rows
    [--workers 4]         # optional: parallel workers (default 1 = sequential)
    [--skip-destroy]      # skip terraform destroy step (faster, less clean)
    [--tf-dir PATH]       # path to cached .terraform dir (speeds up init)
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
TIMEOUT_INIT     = 300   # seconds – provider download can be slow on first run
TIMEOUT_VALIDATE = 300
TIMEOUT_PLAN     = 300
TIMEOUT_DESTROY  = 300

OUTPUT_COLS = [
    'source_slug', 'source_category', 'primary_cloud', 'licence_spdx',
    'dest_file', 'github_url', 'loc', 'tokens', 'difficulty',
    'hcl2_valid', 'tflint_pass', 'yaml_valid', 'targets_aws',
    'init_ok', 'validate_ok', 'plan_ok',
    'deploy_error', 'deploy_stage', 'checked_at',
]

# ── LocalStack bootstrap (run once) ──────────────────────────────────────────
LOCALSTACK_ENDPOINT = os.getenv('AWS_ENDPOINT_URL', 'http://localhost:4566')
LOCALSTACK_STATE_BUCKET = 'tf-benchmark-state'   # auto-created in LocalStack

def bootstrap_localstack_state_bucket():
    """
    Pre-create the S3 bucket + DynamoDB table that tflocal uses for state storage.
    tflocal auto-configures these, but they must exist before the first init.
    Safe to call repeatedly — ignores BucketAlreadyExists.
    """
    import boto3
    from botocore.exceptions import ClientError

    session = boto3.Session(
        aws_access_key_id     = os.getenv('AWS_ACCESS_KEY_ID',     'test'),
        aws_secret_access_key = os.getenv('AWS_SECRET_ACCESS_KEY', 'test'),
        region_name           = os.getenv('AWS_DEFAULT_REGION',    'ap-southeast-2'),
    )
    s3 = session.client('s3', endpoint_url=LOCALSTACK_ENDPOINT)

    try:
        s3.create_bucket(
            Bucket=LOCALSTACK_STATE_BUCKET,
            CreateBucketConfiguration={'LocationConstraint': os.getenv('AWS_DEFAULT_REGION', 'ap-southeast-2')},
        )
        log.info('LocalStack state bucket created: s3://%s', LOCALSTACK_STATE_BUCKET)
    except ClientError as e:
        if e.response['Error']['Code'] in ('BucketAlreadyExists', 'BucketAlreadyOwnedByYou'):
            log.info('LocalStack state bucket already exists: s3://%s', LOCALSTACK_STATE_BUCKET)
        else:
            raise

# ── Provider injection ────────────────────────────────────────────────────────
def _inject_provider(content: str, region: str) -> str:
    """
    If no aws provider block exists, prepend a minimal one.
    Mirrors IaCGen's provider-injection pattern.
    """
    if 'provider "aws"' not in content and "provider 'aws'" not in content:
        return f'provider "aws" {{\n  region = "{region}"\n}}\n\n' + content
    return content


# ── Single-template deploy cycle ──────────────────────────────────────────────
def run_deploy_cycle(
    content: str,
    dest_file: str,
    region: str,
    skip_destroy: bool,
    tf_plugin_cache: str | None,
) -> dict:
    """
    LocalStack-aware deploy cycle using tflocal instead of terraform directly.
    tflocal auto-injects AWS provider endpoint overrides → no manual backend config needed.

    Cycle: tflocal init → tflocal validate → tflocal plan → tflocal destroy → wipe tmpdir
    """
    result = {
        'init_ok':      False,
        'validate_ok':  None,
        'plan_ok':      None,
        'deploy_error': '',
        'deploy_stage': '',
        'checked_at':   datetime.utcnow().isoformat(),
    }

    env = os.environ.copy()
    env['TF_IN_AUTOMATION']   = '1'
    env['TF_INPUT']           = '0'
    env['AWS_DEFAULT_REGION'] = region
    env['AWS_ACCESS_KEY_ID']     = env.get('AWS_ACCESS_KEY_ID',     'test')
    env['AWS_SECRET_ACCESS_KEY'] = env.get('AWS_SECRET_ACCESS_KEY', 'test')
    env['AWS_ENDPOINT_URL']      = LOCALSTACK_ENDPOINT   # picked up by tflocal

    # tflocal respects TF_CMD to locate the underlying terraform binary
    env.setdefault('TF_CMD', 'terraform')

    # Point tflocal's auto-generated S3 backend at our pre-created bucket
    env['S3_HOSTNAME']            = LOCALSTACK_ENDPOINT.replace('http://', '').replace('https://', '')
    env['TERRAFORM_S3_BUCKET']    = LOCALSTACK_STATE_BUCKET
    env['TERRAFORM_S3_KEY']       = dest_file.replace('/', '_') + '.tfstate'

    if tf_plugin_cache:
        env['TF_PLUGIN_CACHE_DIR'] = tf_plugin_cache

    # Detect tflocal binary
    tflocal_bin = shutil.which('tflocal') or 'tflocal'

    with tempfile.TemporaryDirectory(prefix='iac_deploy_') as tmpd:
        tf_file = Path(tmpd) / 'main.tf'
        tf_file.write_text(_inject_provider(content, region), encoding='utf-8')

        def _run(cmd: list[str], timeout: int):
            return subprocess.run(
                cmd, cwd=tmpd,
                capture_output=True, text=True,
                timeout=timeout, env=env,
            )

        # ── STEP 1: tflocal init ──────────────────────────────────────────────
        # -backend=false is REMOVED here — tflocal needs to configure its own
        # LocalStack S3 backend. The backend is always local to LocalStack, not AWS.
        try:
            r = _run(
                [tflocal_bin, 'init',
                 '-input=false', '-no-color', '-upgrade=false'],
                TIMEOUT_INIT,
            )
        except subprocess.TimeoutExpired:
            result['deploy_error'] = 'tflocal init timed out'
            result['deploy_stage'] = 'init'
            return result

        if r.returncode != 0:
            result['deploy_error'] = (r.stderr or r.stdout)[:2000]
            result['deploy_stage'] = 'init'
            log.debug('init failed: %s | %s', dest_file, result['deploy_error'][:2000])
            return result

        result['init_ok'] = True

        # ── STEP 2: tflocal validate ──────────────────────────────────────────
        try:
            r = _run([tflocal_bin, 'validate', '-no-color', '-json'], TIMEOUT_VALIDATE)
        except subprocess.TimeoutExpired:
            result['deploy_error'] = 'tflocal validate timed out'
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

        # ── STEP 3: tflocal plan ──────────────────────────────────────────────
        try:
            r = _run(
                [tflocal_bin, 'plan',
                 '-refresh=false', '-input=false', '-no-color', '-json'],
                TIMEOUT_PLAN,
            )
        except subprocess.TimeoutExpired:
            result['deploy_error'] = 'tflocal plan timed out'
            result['deploy_stage'] = 'plan'
            return result

        plan_ok = r.returncode == 0
        result['plan_ok'] = plan_ok
        if not plan_ok:
            result['deploy_error'] = (r.stderr or r.stdout)[:2000]
            result['deploy_stage'] = 'plan'

        # ── STEP 4: tflocal destroy (state reset) ─────────────────────────────
        # Mirrors IaCGen's reset between templates: every deploy leaves a clean slate.
        # tflocal destroy removes resources from LocalStack and wipes the tfstate entry.
        if not skip_destroy:
            try:
                _run(
                    [tflocal_bin, 'destroy',
                     '-auto-approve', '-refresh=false', '-no-color'],
                    TIMEOUT_DESTROY,
                )
            except subprocess.TimeoutExpired:
                log.warning('tflocal destroy timed out for %s – continuing', dest_file)

        # TemporaryDirectory context exit = filesystem wipe (hard reset)

    return result



# ── CSV helpers ───────────────────────────────────────────────────────────────
def _append_row(output_path: Path, row: dict):
    """Append a single result row to CSV (creates header on first write)."""
    write_header = not output_path.exists()
    with output_path.open('a', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=OUTPUT_COLS, extrasaction='ignore')
        if write_header:
            writer.writeheader()
        writer.writerow(row)


def _already_checked(output_path: Path) -> set[str]:
    """Return set of dest_file values already in the output CSV."""
    if not output_path.exists():
        return set()
    try:
        return set(pd.read_csv(output_path)['dest_file'].dropna().tolist())
    except Exception:
        return set()


# ── Stratified sample ─────────────────────────────────────────────────────────
def _stratified_sample(df: pd.DataFrame, n: int, seed: int = 42) -> pd.DataFrame:
    """
    Return up to n rows stratified by 'difficulty' column.
    Mirrors the IaCGen batch-processing approach of processing rows sequentially.
    """
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
    parser.add_argument('--index',        required=True,  help='Path to index.csv from Cell 5b')
    parser.add_argument('--output',       required=True,  help='Path to output CSV')
    parser.add_argument('--region',       default='ap-southeast-2')
    parser.add_argument('--sample',       type=int, default=None,
                        help='Limit to N stratified rows (default: all)')
    parser.add_argument('--workers',      type=int, default=1,
                        help='Parallel workers. Keep at 1 unless using LocalStack.')
    parser.add_argument('--skip-destroy', action='store_true',
                        help='Skip terraform destroy step (faster but less clean)')
    parser.add_argument('--tf-cache',     default=None,
                        help='Path to TF_PLUGIN_CACHE_DIR (speeds up repeated init)')
    parser.add_argument('--resume',       action='store_true',
                        help='Skip rows already present in output CSV (resume after crash)')
    args = parser.parse_args()

    index_path  = Path(args.index)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # ── Load index ────────────────────────────────────────────────────────────
    df = pd.read_csv(index_path)
    log.info('Loaded index: %d rows from %s', len(df), index_path)

    # ── Resume support ────────────────────────────────────────────────────────
    if args.resume:
        done = _already_checked(output_path)
        before = len(df)
        df = df[~df['dest_file'].isin(done)].copy()
        log.info('Resume mode: skipping %d already-checked rows, %d remaining',
                 before - len(df), len(df))

    # ── Sample ────────────────────────────────────────────────────────────────
    if args.sample:
        df = _stratified_sample(df, args.sample)
        log.info('Stratified sample: %d rows', len(df))

    # ── Locate content files ──────────────────────────────────────────────────
    # index.csv stores dest_file as a relative path (e.g. single_root_templates/...)
    # We need to resolve it relative to the index file's parent dir.
    base_dir = index_path.parent.parent   # iac_benchmark/

    log.info('Starting deploy cycle on %d templates…', len(df))
    log.info('  Region       : %s', args.region)
    log.info('  Workers      : %d', args.workers)
    log.info('  Skip destroy : %s', args.skip_destroy)
    log.info('  Output CSV   : %s', output_path)

    # Bootstrap LocalStack state bucket (idempotent, safe to re-run)
    try:
        bootstrap_localstack_state_bucket()
    except Exception as e:
        log.error('Cannot reach LocalStack at %s: %s', LOCALSTACK_ENDPOINT, e)
        log.error('Ensure LocalStack is running: docker run -p 4566:4566 localstack/localstack')
        sys.exit(1)


    # ── Process rows ──────────────────────────────────────────────────────────
    def process_row(row_tuple):
        idx, row = row_tuple
        dest_file_path = base_dir / row['dest_file']

        if not dest_file_path.exists():
            log.warning('File not found: %s', dest_file_path)
            result = {
                'init_ok': False, 'validate_ok': None, 'plan_ok': None,
                'deploy_error': f'file_not_found: {dest_file_path}',
                'deploy_stage': 'pre_init',
                'checked_at':  datetime.utcnow().isoformat(),
            }
        else:
            content = dest_file_path.read_text(encoding='utf-8', errors='replace')
            try:
                result = run_deploy_cycle(
                    content       = content,
                    dest_file     = row['dest_file'],
                    region        = args.region,
                    skip_destroy  = args.skip_destroy,
                    tf_plugin_cache = args.tf_cache,
                )
            except Exception as exc:
                log.error('Unexpected error on %s: %s', row['dest_file'], exc)
                result = {
                    'init_ok': False, 'validate_ok': None, 'plan_ok': None,
                    'deploy_error': str(exc)[:2000],
                    'deploy_stage': 'exception',
                    'checked_at':  datetime.utcnow().isoformat(),
                }

        out_row = {**row.to_dict(), **result}
        _append_row(output_path, out_row)   # crash-safe: written immediately

        status = '✅' if result.get('plan_ok') else '❌'
        log.debug('%s  %s  stage=%s', status, row['dest_file'], result.get('deploy_stage', '—'))
        return result.get('plan_ok', False)

    rows = list(df.iterrows())
    passed = 0

    if args.workers > 1:
        with ThreadPoolExecutor(max_workers=args.workers) as pool:
            futures = {pool.submit(process_row, r): r for r in rows}
            for future in tqdm(as_completed(futures), total=len(rows), desc='terraform plan'):
                if future.result():
                    passed += 1
    else:
        for row_tuple in tqdm(rows, desc='terraform plan'):
            if process_row(row_tuple):
                passed += 1

    # ── Final summary ─────────────────────────────────────────────────────────
    total = len(rows)
    log.info('=' * 60)
    log.info('DEPLOYABILITY CHECK COMPLETE')
    log.info('  Templates checked : %d', total)
    log.info('  plan_ok (passed)  : %d  (%.1f%%)', passed, 100 * passed / total if total else 0)
    log.info('  Output CSV        : %s', output_path.resolve())
    log.info('=' * 60)


if __name__ == '__main__':
    main()
