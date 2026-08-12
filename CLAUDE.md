# CLAUDE.md — `data_analysis/`

Guide for Claude Code (or any other coding agent) working in this folder. It covers what
the research problem is, how the pieces fit together, where the pipeline currently stands,
and the concepts/decisions an agent needs to not re-break already-fixed bugs.

## Research problem, direction, and progress

**Problem.** LLM-generated Infrastructure-as-Code (CloudFormation / Terraform) frequently
looks plausible but fails to actually deploy, or deploys something insecure. The thesis
project ("IaCGOD" — Infrastructure-as-Code Generative Orchestration & Debugging, in the
sibling repo `../IaCGOD/`) is a multi-agent LLM system (Planner → Engineer → Validator →
Retriever → Remediator, a LangGraph state machine) that iterates generate → validate →
repair until a template is statically valid, passes security scanning, and is confirmed
**deployable** (against LocalStack or live AWS), for both CloudFormation and Terraform.
IaCGOD reports >97% deployability pass rate on the DPIaC-Eval benchmark.

**This folder's job.** `data_analysis/` is the *evaluation and benchmark-construction* side
of the project — everything needed to (a) build a custom benchmark spanning both IaC
languages across five difficulty levels (L1–L5), since existing benchmarks (DPIaC-Eval,
Multi-IaC-Eval, IaC-Eval-HF) are CFN-only, Terraform-only, too small, or lack difficulty
stratification; and (b) run IaCGOD (and baseline LLMs/prompting strategies) against that
benchmark and analyze the results for the thesis/journal paper (target venue: ACM TOSEM or
a comparable conference; paper sources live in `../Papers/` — `introduction.tex`,
`background.tex`, `approach.tex`, `benchmark.tex`, `references.bib`).

**Progress as of this writing:**
- CFN benchmark (`cfn_benchmark_builder.ipynb`): fully built and frozen at **250 rows, 50
  per difficulty level**, sourced from cloned GitHub repos + Multi-IaC-Eval +
  Tianyi2/IaCGen (DPIaC-Eval ground truth), deduplicated, cfn-lint clean, Trivy/Checkov
  gated, LocalStack/AWS deploy-verified, with LLM-synthesized natural-language prompts
  (`final_benchmark_with_prompts.csv` → `cfn_eval_benchmark.csv`). See "CFN benchmark
  pipeline" below for the exact stage list and known-fixed bugs.
- Terraform benchmark (`IaCGOD_Benchmark_Terraform.ipynb`): pipeline structurally complete
  (same stage shape as CFN — clone/fetch → collect → dedup → difficulty → lint → security
  → deploy → assemble → format) but the LocalStack deployability pass over the full
  candidate pool (tens of thousands of lint-and-security-passed scenarios) has not yet been
  run to completion — this is the next big compute task before the TF track can be frozen
  the same way CFN was.
- Difficulty assignment: CFN's `calculate_difficulty_cfn()` was **rewritten to mirror**
  Terraform's `calculate_difficulty()` methodology (joint LOC + resource-count thresholds,
  same 5-band structure) but with CFN-appropriate resource-count thresholds, because CFN
  templates express the same infrastructure with more lines/fewer distinct resources than
  Terraform HCL. See "Difficulty-level methodology" below for the exact numbers.
- Multi-agent evaluation results (IaCGOD runs, ablations, baseline-model comparisons) are
  partially analyzed — see `IaC_Benchmark_Analysis.ipynb` and the `audit/` scripts — but the
  final CFN+TF frozen benchmark numbers have not yet been dropped into the paper's Table 2 /
  Figures 3–4 (`../Papers/benchmark.tex`); that requires the TF LocalStack run above.

## Key notebooks and scripts

### Benchmark construction

- **`cfn_benchmark_builder.ipynb`** — builds the CloudFormation benchmark end-to-end.
  Sections (numbered comment headers in the notebook, read them in order — this is the
  authoritative pipeline map, don't infer structure from cell position alone since cells
  have been inserted out of strict numeric order):
  1. Install deps
  2. Configuration / GitHub auth
  2.5 Discover top CFN repos on GitHub
  3. Repository registry (manual + discovered) + 3b ethical licence filter
  4. Clone repos (append-only snapshot) + disk-space cleanup utility
  4.5 Fetch Multi-IaC-Eval (HuggingFace)
  4.6 Fetch DPIaC-Eval / Tianyi2/IaCGen ground truth (raw GitHub fetch, 153 templates,
      Apache-2.0, brings pre-computed `difficulty_level` metadata but CFN's own
      `calculate_difficulty_cfn` is what's actually used downstream)
  5. Collect templates → `RAW_RECORDS` → `df_raw` — **folds in both external sources**
     (`EXTERNAL_RECORDS`) as well as cloned-repo templates; this merge was originally
     missing (external records were silently dropped) and was fixed — do not remove it.
  5c. Normalisation & consolidation (content-hash dedup, `content_norm`)
  5d. Disk cleanup (delete raw clones once templates are extracted)
  5e. **Near-duplicate detection & removal** (pre-lint) — fuzzy (`difflib`) + resource-type
      blocking-key near-dup clustering, with a **hardcoded permanent exclusion list**
      (`NEAR_DUPLICATE_DROP_HASHES`) of content hashes for clusters a human has already
      adjudicated as true duplicates. This list is the single source of truth for "drop
      this exact file" — extend it, don't build a second exclusion mechanism.
  6. Size filter & **difficulty assignment** (`calculate_difficulty_cfn`) — the single
     authoritative difficulty computation; not recomputed anywhere downstream (see below).
  7. AWS-targeting filter
  8. cfn-lint validation
  9. Security scan (Trivy + Checkov) — only for lint-passed templates
  9b. Trivy severity gate (drop CRITICAL/HIGH/MEDIUM findings pre-deploy)
  10. Deployability check (AWS or LocalStack, configurable)
  11. Aggregate & export (strict gates)
  12. Visualisation
  14. **Final benchmark assembly** — stratified sampling to 50/level, reconciled against
      the previously-frozen benchmark so already-verified rows keep their stable
      `row_number` across reruns (a rerun should not renumber or silently drop rows a human
      has already reviewed). Uses **dedup-aware sampling during the fill loop** (checks each
      new candidate against both kept rows and already-accepted new rows before accepting
      it) rather than a post-hoc "safety net" filter — a prior post-hoc version had a bug
      where it dropped one side of a fuzzy-matched pair whenever *either* side was a kept
      row, without checking the *other* side was also kept, silently deleting legitimate
      already-frozen rows and causing a difficulty-level shortfall. Do not reintroduce a
      post-hoc dedup pass after this cell; if a new near-duplicate is found, add its hash to
      the cell-5e exclusion list instead, so it's filtered at the source before difficulty
      assignment, and let the assembly cell's own reconcile/resample logic backfill it.
  15. Format final dataset for evaluation (`cfn_eval_benchmark.csv`) — this is the file the
      IaCGOD system and baselines actually get evaluated against.

  Outputs land in `cfn_benchmark/dataset/`: `df_aws_cache.csv` (post AWS-targeting-filter
  cache), `lint_cache.csv`, `security_cache.csv`, `deploy_cache_aws_stack.csv`,
  `licence_cache.csv` (per-stage resumable caches, keyed by `content_hash` — reruns should
  hit these caches rather than reprocessing), `cfn_benchmark.csv` (full deploy-passing
  candidate pool), `final_benchmark_custom.csv` (250-row frozen sample, no prompts yet),
  `final_benchmark_with_prompts.csv` (+ `user_prompt`), `cfn_eval_benchmark.csv` (final
  formatted eval file). Backups of the notebook are kept as `cfn_benchmark_builder.ipynb.bakN_<timestamp>`
  before every structural edit — if something looks broken after an edit, diff against the
  most recent `.bakN_*` before assuming the bug is pre-existing.

- **`IaCGOD_Benchmark_Terraform.ipynb`** — the Terraform equivalent. Sections: 1.
  Configuration, 2. Repository registry, 3. Ethical licence filter, 4. Fetch IaC-Eval
  dataset, 5. Clone/pull repos, 6. Collect GitHub scenarios, 7. Persist IaC-Eval as folders,
  7.5 Fetch TerraDS from Zenodo (resumable), 7.8 AWS-targeting filter (pre-AST), 8. Count /
  filter / AST-parse (with a Unix-level timeout — HCL parsing can hang on pathological
  files), 9. Load from cache & difficulty analysis, 10. **Assign difficulty and oversample
  new scenarios** (`calculate_difficulty` — see "Difficulty-level methodology"), 11. TFLint
  validation, 12. Trivy security scan + 12.5 severity filter, 12.8 inspect
  high-difficulty (L4/L5) scenarios, 13. **LocalStack deployability testing** (the
  currently-unfinished stage — tens of thousands of candidates still queued), 14. Final
  benchmark assembly & diverse visualisation (+ a utility to verify the final set is
  strictly AWS-only), 15. Format final dataset for evaluation.

  Outputs land in `iac_benchmark/dataset/`: `tflint_cache.csv` (**the absolute history of
  every scenario ever evaluated** — stage 10 uses this to exclude already-seen
  `scenario_id`s from resampling, so don't delete it between runs or previously-evaluated
  scenarios will be re-sampled and re-run), `trivy_cache.csv`, `validation_pipeline_batch.csv`
  (the active queue for whichever validation stage is currently running),
  `tf_benchmark.csv`, `final_benchmark_custom.csv`, `final_benchmark_with_prompts.csv`.

### Benchmark prompt generation

- **`generate_cfn_prompts.py`** / **`generate_llm_prompts.py`** — near-identical scripts
  (CFN and Terraform respectively) that take a frozen `final_benchmark_custom.csv` and, for
  each row, call an LLM (via OpenRouter, `OPENROUTER_API_KEY` env var required, model
  `deepseek/deepseek-v4-flash` by default) to reverse-engineer the ground-truth template
  into a natural-language "user requirement" prompt (`user_prompt` column), styled as a
  DevOps ticket ("We need a CloudFormation template that creates…"). **Both scripts resume
  from `OUTPUT_CSV`** (`final_benchmark_with_prompts.csv`) if it already exists — they key
  on which rows already have a non-empty `user_prompt` and only backfill new/changed rows,
  saving every `SAVE_EVERY=5` rows. This resume behaviour is why the benchmark-assembly
  notebook cell can safely reuse stable `row_number`s across reruns: newly sampled rows get
  new prompts generated, unchanged kept rows keep their existing prompt untouched.
  Two standing prompt-quality policies (set during benchmark review, apply on the next
  prompt-audit pass): (1) templates using `Fn::ImportValue`/cross-stack references should
  **not** be dropped from the benchmark — reword the prompt to say don't assume the
  referenced resources already exist, generate them and reference them instead; (2)
  templates with hardcoded literals (account IDs, regions/AZs, static keys, URLs, image
  IDs) should have their **prompts generalized** (not the rows dropped) while preserving
  the original intent.

### Benchmark prompt rubric (quality review)

Every `user_prompt` in the frozen CFN benchmark (`final_benchmark_with_prompts.csv` /
`cfn_eval_benchmark.csv`) was reviewed against a fixed LLM-judged rubric before freezing.
The rubric pairs the prompt with its ground-truth template and asks the reviewing LLM
(`host.reasoning_model()`, called via `host.llm()`) to return one JSON verdict per row.
This is the canonical review pass — reuse it verbatim for the Terraform track and for any
future re-audit after regenerating prompts.

**System prompt (`RUBRIC_SYSTEM`)** — judges the prompt against seven house rules:

1. **Solution leakage (bad)** — no verbatim CFN logical resource IDs, no raw intrinsic-function
   syntax (`!Ref`, `!Sub`, `!GetAtt`, `Fn::...`), no raw YAML/JSON blocks, no CFN property-key
   jargon copied from the template. A business-facing name a human would naturally pick
   (bucket name, key alias, domain) is fine even if it happens to equal the logical ID.
2. **Necessary detail (must keep)** — any parameter default, hardcoded value (CIDR, alias,
   name, non-default region), or configuration choice that's load-bearing for deployability
   or central to the template's functional objective MUST be stated. Omitting it is a real
   defect (under-specification), not a virtue.
3. **Inference space (should generalize)** — secondary/supporting details a competent
   engineer could infer (detailed IAM policy statements, SG/NACL specifics, route-table
   wiring, output blocks) should be omitted UNLESS load-bearing or the explicit point of
   the exercise.
4. **Difficulty scaling** — L1 prompts should read as 1–2 short sentences; higher levels
   track more structural detail (primary resources/subnets/CIDRs) while still generalizing
   secondary security/ACL specifics.
5. **Hygiene** — no mojibake, no markdown/bullet lists, no raw code, plain ASCII quotes only.
6. **Failure rows** — a literal `"ERROR: ..."` `user_prompt` is always a critical defect.
7. **Faithfulness** — any stated action/behavior/threshold (block vs count, allow vs deny,
   etc.) must match the ground truth's actual effect; a mismatch is a critical defect since
   it would unfairly penalize a faithful benchmarked model.

**Output schema** (strict JSON, no markdown fences, exactly these keys):

```json
{
  "leak_severity": "none | minor | major",
  "leak_reasons": ["short strings"],
  "missing_essential_info": true | false,
  "missing_reasons": ["short strings"],
  "difficulty_fit": "appropriate | too_detailed_for_level | too_sparse_for_level",
  "critical_defect": true | false,
  "notes": "one short sentence"
}
```

**Convergence history** (CFN track, 250 rows) — round 1 broad pass flagged 49/250 rows;
6 of those had truncated (`max_tokens`-cut) prompts and were regenerated; round 2 caught
17 residual flags on reverify; round 3 hand-fixed 2 fine-grained faithfulness nuances that
survived two repair passes; a final hygiene pass ASCII-normalized 4 rows (em-dash →
plain punctuation). Final state: `leak_severity=none`, `missing_essential_info=False`,
`difficulty_fit=appropriate`, `critical_defect=False` — 250/250.

**IMPORTANT — the rubric review must be re-run after every notebook rerun.** The
dynamic-sampling assembly cell resamples candidates on each run, so a rerun of
`cfn_benchmark_builder.ipynb` + `generate_cfn_prompts.py` typically swaps a small number
of `dest_file` rows in/out even with the same seed logic, and prompt text for previously
fixed rows is regenerated from scratch (fixes do NOT persist across reruns unless they're
baked into the notebook/script itself, e.g. the exclusion-hash list). Re-running the full
review after one such rerun (2026-08-10) flagged 29/250 rows on round 1 (6 critical
faithfulness mismatches — stated behavior contradicting the ground truth's actual effect,
e.g. a schedule's stated timezone-converted time being wrong, an IAM policy/trigger
wiring claim not matching the template, a WAF decode-method claim, an async-vs-sync API
integration claim, a Cognito-resource-scope claim, a precedence-value claim — plus
20 missing-essential-info/too-detailed flags). All 29 were repaired via a rubric-feedback-
driven LLM rewrite pass, re-verified against the rubric (24/29 clean immediately, 5
DNS/connector-literal rows needed one more explicit "extract exact values from the
ground truth" repair pass), with one final manual patch (inserting an exact Gremlin
query the model's repair still hadn't picked up) and one mechanical em-dash cleanup.
Final state after this cycle: 250/250 clean again. Per-row verdicts are archived in
`cfn_prompt_review_final.csv` (`dest_file`, `difficulty`, `n_resources`,
`n_parameters`, `loc`, `user_prompt`, plus the four verdict columns and `notes`).

### Evaluation & analysis

- **`IaC_Benchmark_Analysis.ipynb`** — the main results notebook. Section 1 is a utility to
  merge split/resumed benchmark runs (`.csv`/`.jsonl`) into one file before analysis;
  section 2 loads a `{model_name: result_csv_path}` mapping and computes headline metrics
  (`final_validation_passed`, `iterations_used`, tokens/duration); later sections produce
  the comparison plots that live in `iacgod/*_top_errors.png` and
  `plots/*.png` (pass rate by difficulty, cost/latency, stage pass rates, policy
  compliance, error taxonomy, model "stubbornness", etc.) — these are the source plots for
  the paper's results figures.
- **`IaC_Benchmark_Analytics_Detailed_Errors.ipynb`** — deeper per-error-code breakdown,
  feeds `error_tracking/*_error_history.csv`.
- **`Deployability and Error Taxonomy.ipynb`**, **`Error Analysis.ipynb`**,
  **`LLM IaC Generation Errors & DevOps Simulation.ipynb`** — exploratory error-taxonomy
  and failure-mode notebooks (stage-by-stage resolution rates, escalation frequency,
  cross-model comparisons) — outputs feed `plots/chart_*.png`.
- **`analyze_iac_errors_openrouter.py`** — standalone script variant of the error-taxonomy
  analysis, OpenRouter-based.
- **`cfn_graph_explore.ipynb`** — exploration of the CFN resource-type dependency graph
  (built by `rag/build_cfn_graph.py`), used to sanity-check the GraphRAG knowledge base
  IaCGOD's Retriever/Remediator agents query against (see `../IaCGOD/tools/cfn_hybrid_rag.py`).
- **`tf_benchmark_analysis.ipynb`**, **`tf_final_benchmark.ipynb`** — Terraform-side
  counterparts to the CFN analysis/final-assembly notebooks (older/parallel work; the
  canonical TF build pipeline is `IaCGOD_Benchmark_Terraform.ipynb` above).
- **`Benchmark Security Audit.ipynb`**, **`DPIaCEval Security Audit.ipynb`** — security
  scan (Trivy/Checkov) audits of the custom benchmark and of DPIaC-Eval's own ground-truth
  templates respectively, feeding `output/checkov_audit/`, `output/dpiac_security_audit/`,
  `output/trivy_audit/`.

### `audit/` — multi-agent result auditing scripts

All of these join a model's benchmark result CSV to a ground-truth reference file by
`row_number`, then score a specific dimension. Run against `result/iacgod/*.csv` style
outputs; their outputs feed the `IaCGOD_*_Audit_Result.ipynb` notebooks below.

- **`audit/coverage_audit.py`** — measures user-intent **coverage** and **resource
  accuracy**: for each generated template, checks whether the resource types the ground
  truth's user-intent required (`iac_with_user_intent.csv`'s `needed_resources` /
  `resources` / `resource_count` / `difficulty_level` columns, sourced from Tianyi2/IaCGen)
  actually appear in the generated output.
- **`audit/tf_coverage_audit.py`** — Terraform analogue of `coverage_audit.py`.
- **`audit/rego_intent_audit.py`** — OPA/Rego-policy-based intent audit (checks generated
  IaC against policy-as-code rules derived from user intent).
- **`audit/checkov_intent_audit.py`** — runs Checkov (both attribute-based `CheckResult`
  and graph-based `Record` policy types — the two have different result-object shapes,
  handled via safe `getattr` fallbacks, not `.check.name` directly) over generated
  templates and cross-references failures against intent.
- **`audit/trivy_audit.py`** — Trivy-based security audit of generated templates.

### `IaCGOD_*_Audit_Result.ipynb` — visualisation of the above

- **`IaCGOD_Coverage_Audit_Result.ipynb`**, **`IaCGOD_Intent_Audit_Result.ipynb`**,
  **`IaCGOD_TF_Coverage_Audit_Result.ipynb`**, **`IaCGOD_Trivy_Audit_Result.ipynb`** — each
  takes an `input_pairs` list of `{model_name, result_file, <coverage|intent>_file}` dicts
  (edit this list to add a new model/run), left-joins on `row_number`, and plots
  seaborn/matplotlib comparison charts (`ggplot` style, `muted` palette) across models. To
  evaluate a new model or ablation, add an entry to `input_pairs` in the relevant notebook
  rather than writing a new notebook.

### Other important files

- **`../IaCGOD/`** — the multi-agent system itself (not in this folder). `README.md` and
  `AGENTS.md` there describe the five-agent LangGraph architecture, the dual-stream hybrid
  GraphRAG design (ChromaDB semantic + Neo4j deterministic schema + a deterministic
  Trivy-finding→fix-snippet security RAG), and coding conventions (state flows through
  `state.py`'s `GraphState` TypedDict; every agent must handle both `iac_type ==
  "cloudformation"` and `"terraform"` paths).
- **`../Papers/`** — `introduction.tex`, `background.tex`, `approach.tex`, `benchmark.tex`,
  `references.bib` (114 entries) — the journal/conference paper sources. `benchmark.tex`
  describes this folder's output (Table 2, Figures 3–4 draw from the frozen CFN/TF
  benchmarks and the `IaC_Benchmark_Analysis.ipynb` plots).
- **`Data/`** — cached DPIaC-Eval (Tianyi2/IaCGen) CSVs: `iac_basic.csv`,
  `iac_with_difficulty_levels.csv` (the pre-computed `difficulty_level` column referenced
  above — informative but not what CFN's own pipeline uses for its `difficulty` column),
  `iac_with_user_intent.csv` (used by `audit/coverage_audit.py`), plus Trivy policy-mapping
  CSVs.
- **`cfn-schema/`** — a parsed CloudFormation resource-type dependency graph
  (`cfn_graph.pkl`, `cfn_spec.json`, `cfn_required_props.csv`) used both by
  `cfn_graph_explore.ipynb` and by IaCGOD's deterministic GraphRAG stream.
- **`.env`** — holds `OPENROUTER_API_KEY` (and possibly AWS creds) for the prompt-generation
  scripts and any live-AWS deployability runs — never commit this file or print its
  contents.

## Difficulty-level methodology (L1–L5)

Both tracks use a **joint LOC × resource-count** classifier: a scenario only advances to a
harder level if it clears *both* the LOC bar and the resource-count bar for that level
(checked from hardest to easiest, falling through to Level 1 by default). This joint
structure is deliberate and shared across languages — do not change one track's *shape*
(joint vs. either/or, band count) without changing the other's, since the paper presents
them as parallel methodologies. What legitimately differs between the two is the
**thresholds**, because Terraform HCL expresses the same real infrastructure with fewer,
denser resource blocks (each block often config-heavy with nested arguments/expressions)
while CloudFormation YAML is more verbose per resource — so CFN's resource-count bars are
lower than Terraform's for a nominally comparable difficulty band.

**Terraform** (`calculate_difficulty()`, `IaCGOD_Benchmark_Terraform.ipynb`, section 10) —
scenarios are pre-filtered to `loc >= 30 and n_resources >= 2` before classification:
```python
if   loc >= 400 and res >= 12: return 5
elif loc >= 250 and res >= 8:  return 4
elif loc >= 150 and res >= 4:  return 3
elif loc >= 80:                return 2
else:                          return 1
```

**CloudFormation** (`calculate_difficulty_cfn()`, `cfn_benchmark_builder.ipynb`, section 6)
— mirrors the above shape with CFN-calibrated thresholds:
```python
if   loc >= 200 and res >= 12: return 5
elif loc >= 150 and res >= 8:  return 4
elif loc >= 100 and res >= 4:  return 3
elif loc >= 50  and res >= 2:  return 2
else:                          return 1
```
(Resource-count bars for L3–L5 currently match Terraform's 1:1; only the LOC bars were
lowered, reflecting CFN's typically-longer per-resource boilerplate. If recalibrating
further, check the current LOC/resource distribution of `df_sized` in the size-filter cell
before changing thresholds — the notebook prints `df_sized['n_resources'].describe()` right
after assignment for exactly this purpose.)

**Important:** in both notebooks, difficulty is a **single authoritative computation** —
computed once in the cell named above and carried through unchanged by every downstream
cell (lint, security scan, deploy check, aggregate/export, final assembly, visualisation).
Never recompute or override the `difficulty` column anywhere else; if a threshold needs to
change, change it only in the one function and rerun from that cell forward.

## Key concepts / conventions to preserve

1. **Stable `row_number` across reruns.** The final-assembly cells reconcile a fresh
   deployable candidate pool against the previously-frozen benchmark CSV so that rows a
   human has already reviewed and accepted keep their identifier — they are never silently
   renumbered or dropped just because the pipeline reran. Only rows that actually fail a
   gate (lint/security/deploy) or get newly excluded via the near-duplicate hash list are
   dropped and replaced by resampling.
2. **Dedup is layered, not duplicated.** (a) exact-content-hash dedup happens early
   (normalisation cell); (b) fuzzy near-duplicate clustering with a human-reviewed permanent
   exclusion hash list happens once, pre-lint (cell 5e for CFN); (c) the final-assembly
   sampling loop is itself dedup-aware (checks new candidates against both kept and
   already-accepted-new rows) so it never needs a second post-hoc filter pass. If a new
   near-duplicate surfaces after assembly, add it to the (b) exclusion list and rerun from
   there — don't patch assembly-time filtering again.
3. **Two prompt-quality policies apply to prompt generation/audit, not to row filtering**:
   cross-stack `Fn::ImportValue` usage → reword prompt to require self-contained resource
   creation, don't drop the row; hardcoded literals (account IDs/regions/keys/URLs/AMI IDs)
   → generalize the prompt wording, don't drop the row. Both scripts' resume-by-existing-
   `user_prompt` behaviour means a prompt can be regenerated for a single row by clearing
   its `user_prompt` cell and rerunning the script, without touching the rest of the file.
4. **Per-stage CSV caches are keyed by `content_hash`, not row position** — lint, security,
   and deploy results are cached across reruns; only genuinely new/changed content re-runs
   the (expensive) tool. Don't delete these caches to "force a clean run" — that discards
   real deploy-verification work (LocalStack/AWS calls are the most expensive stage).
5. **Backups before structural notebook edits.** Every structural edit to either builder
   notebook should be preceded by a timestamped `.bakN_<timestamp>` copy and followed by a
   JSON-roundtrip + per-cell `ast.parse` syntax check across the *whole* notebook (not just
   the edited cell) before considering the edit complete.
