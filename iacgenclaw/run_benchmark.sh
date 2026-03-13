#!/usr/bin/env bash
set -euo pipefail
BASE_CSV=~/Documents/research/iacgenclaw/iac_basic.csv
OUTDIR=~/iac-benchmark/outputs
REPORT=~/iac-benchmark/report.md
mkdir -p "$OUTDIR"
# header for results CSV
RESULTS_CSV="$OUTDIR/results_summary.csv"
echo "row,ground_truth_path,prompt_preview,overall_status,yaml_gate,cfn_lint_gate,deploy_gate,error_summary" > "$RESULTS_CSV"
row=0
# read CSV, expecting header with ground_truth_path and prompt columns
# Use awk to handle quoted fields safely by reading with python
python3 - <<'PY'
import csv,sys,os
csvfile=os.path.expanduser('~/Documents/research/iacgenclaw/iac_basic.csv')
outdir=os.path.expanduser('~/iac-benchmark/outputs')
results=open(os.path.join(outdir,'results_summary.csv'),'a')
with open(csvfile, newline='') as f:
    reader=csv.DictReader(f)
    for i,row in enumerate(reader):
        prompt=row.get('prompt') or row.get(' Prompt') or row.get('prompt ')
        gpath=row.get('ground_truth_path') or row.get('ground_truth') or ''
        # preserve prompt exactly when invoking generate_cfn via shell
        out_yaml=os.path.join(outdir,f'row_{i}.yaml')
        val_log=os.path.join(outdir,f'row_{i}_validation.log')
        # attempt up to 5 iterations: regenerate template if validation fails
        import subprocess,shlex
        max_iters=5
        success=False
        print('===ROW',i,'GEN_START===')
        for it in range(1, max_iters+1):
            out_yaml_it=os.path.join(outdir,f'row_{i}_iter_{it}.yaml')
            val_log_it=os.path.join(outdir,f'row_{i}_iter_{it}_validation.log')
            gen_cmd = f"generate_cfn --prompt-file - --output '{out_yaml_it}' --skip_deploy true --iteration {it}"
            try:
                p=subprocess.run(shlex.split(gen_cmd), input=prompt.encode('utf-8'), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300)
                # check if file created
                if not os.path.exists(out_yaml_it) or os.path.getsize(out_yaml_it)==0:
                    with open(val_log_it,'w') as vl:
                        vl.write('generation failed\n')
                    print(f'===ROW {i} ITER {it} GEN_FAIL===')
                    continue
            except Exception as e:
                with open(val_log_it,'w') as vl:
                    vl.write('generation failed: '+str(e)+"\n")
                print(f'===ROW {i} ITER {it} GEN_EXCEPTION===')
                continue
            # validate this iteration
            val_cmd = f"validate_cfn --template '{out_yaml_it}' --skip_deploy true"
            try:
                v=subprocess.run(shlex.split(val_cmd), stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=300)
                with open(val_log_it,'wb') as vl:
                    vl.write(v.stdout)
            except Exception as e:
                with open(val_log_it,'w') as vl:
                    vl.write('validation command failed: '+str(e)+"\n")
            # parse validation to see if passed
            yaml_pass='❌'
            lint_pass='❌'
            err_summary=''
            with open(val_log_it,'r',errors='ignore') as vl:
                txt=vl.read()
                if 'YAML' in txt or 'yaml' in txt:
                    if 'error' not in txt.lower():
                        yaml_pass='✅'
                    else:
                        yaml_pass='❌'
                else:
                    yaml_pass='✅'
                if 'cfn-lint' in txt or 'W' in txt or 'E' in txt:
                    if 'FAILED' in txt or 'Error' in txt or 'error' in txt.lower():
                        lint_pass='❌'
                        for line in txt.splitlines():
                            if 'W' in line or 'E' in line or 'error' in line.lower():
                                err_summary=line.strip(); break
                    else:
                        lint_pass='✅'
                else:
                    lint_pass='✅'
            if yaml_pass=='✅' and lint_pass=='✅':
                # success — record using iteration-specific filenames
                success=True
                out_yaml=out_yaml_it
                val_log=val_log_it
                yaml_pass_final=yaml_pass
                lint_pass_final=lint_pass
                err_summary_final=err_summary
                print(f'===ROW {i} ITER {it} PASSED===')
                break
            else:
                print(f'===ROW {i} ITER {it} VALIDATION_FAILED: {yaml_pass} {lint_pass}===')
                # continue to next iteration
                yaml_pass_final=yaml_pass
                lint_pass_final=lint_pass
                err_summary_final=err_summary
        # end iterations
        if not success:
            # use last iteration files if exist
            out_yaml = out_yaml_it if os.path.exists(out_yaml_it) else out_yaml
            val_log = val_log_it if os.path.exists(val_log_it) else val_log
            yaml_pass=yaml_pass_final
            lint_pass=lint_pass_final
            err_summary=err_summary_final
        else:
            yaml_pass=yaml_pass_final
            lint_pass=lint_pass_final
            err_summary=err_summary_final
        # simple parsing: check for YAML error or cfn-lint        # simple parsing: check for YAML error or cfn-lint
        yaml_pass='❌'
        lint_pass='❌'
        err_summary=''
        with open(val_log,'r',errors='ignore') as vl:
            txt=vl.read()
            if 'YAML' in txt or 'yaml' in txt:
                # look for yaml error lines
                if 'error' not in txt.lower():
                    yaml_pass='✅'
                else:
                    yaml_pass='❌'
            else:
                yaml_pass='✅'
            # cfn-lint detection
            if 'cfn-lint' in txt or 'W' in txt or 'E' in txt:
                # crude: if 'FAILED' or 'ERROR' present, mark fail
                if 'FAILED' in txt or 'Error' in txt or 'error' in txt:
                    lint_pass='❌'
                    # extract first error line
                    for line in txt.splitlines():
                        if 'W' in line or 'E' in line or 'error' in line.lower():
                            err_summary=line.strip()
                            break
                else:
                    lint_pass='✅'
            else:
                lint_pass='✅'
        overall='✅ PASSED' if yaml_pass=='✅' and lint_pass=='✅' else '❌ FAILED'
        deploy='⏭️'
        results.write(f"{i},{gpath},"+prompt[:80].replace('\n',' ') +f",{overall},{yaml_pass},{lint_pass},{deploy},{err_summary}\n")
        print('===ROW',i,'DONE===')
results.close()
print('ALL DONE')
PY

echo "Benchmark driver finished. Results CSV at $RESULTS_CSV"
