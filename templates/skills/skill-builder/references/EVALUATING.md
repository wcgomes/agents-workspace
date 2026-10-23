# Evaluating skill output quality

## Designing test cases

Cases need a realistic **prompt**, human-readable **expected output**, and optional **input files**. Store in the skill's `evals/evals.json`:

```json
{
  "skill_name": "csv-analyzer",
  "evals": [
    {
      "id": 1,
      "prompt": "I have a CSV of monthly sales data in data/sales_2025.csv. Can you find the top 3 months by revenue and make a bar chart?",
      "expected_output": "A bar chart image showing the top 3 months by revenue, with labeled axes and values.",
      "files": ["evals/files/sales_2025.csv"]
    }
  ]
}
```

Start with 2–3 cases; vary phrasing/detail/formality, include at least one boundary, and use realistic paths/columns/personal context.

## Running evals

Run each case **with skill** vs **without skill** (or previous version) as baseline.

### Workspace structure

Use a sibling workspace with a new `iteration-N/` for each full loop:

```
csv-analyzer/
├── SKILL.md
└── evals/
    └── evals.json
csv-analyzer-workspace/
└── iteration-1/
    ├── eval-top-months-chart/
    │   ├── with_skill/
    │   │   ├── outputs/       # Files produced by the run
    │   │   ├── timing.json    # Tokens and duration
    │   │   └── grading.json   # Assertion results
    │   └── without_skill/
    │       ├── outputs/
    │       ├── timing.json
    │       └── grading.json
    └── benchmark.json         # Aggregated statistics
```

### Spawning runs

Start each run in clean context with skill path (omit for no-skill baseline), prompt, input files, output directory. Baseline uses the same prompt and `without_skill/outputs/`. For existing skills, snapshot before editing (`cp -r <skill-path> <workspace>/skill-snapshot/`) and use that version as baseline.

### Capturing timing data

Record per-run tokens/duration to compare baseline cost:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332
}
```

## Writing assertions

After first outputs, add verifiable assertions: valid JSON, labeled axes, ≥3 recommendations. Avoid vague "good output" or brittle exact wording such as "Total Revenue: $X".

Add assertions to each test case in `evals/evals.json`:

```json
{
  "skill_name": "csv-analyzer",
  "evals": [
    {
      "id": 1,
      "prompt": "...",
      "expected_output": "...",
      "files": ["..."],
      "assertions": [
        "The output includes a bar chart image file",
        "The chart shows exactly 3 months",
        "Both axes are labeled",
        "The chart title or caption mentions revenue"
      ]
    }
  ]
}
```

## Grading outputs

Grade actual outputs **PASS/FAIL**, citing/quoting evidence, not opinion. An LLM can judge assertions; prefer scripts for mechanical checks (JSON, row counts, file existence).

```json
{
  "assertion_results": [
    {
      "text": "The output includes a bar chart image file",
      "passed": true,
      "evidence": "Found chart.png (45KB) in outputs directory"
    },
    {
      "text": "Both axes are labeled",
      "passed": false,
      "evidence": "Y-axis is labeled 'Revenue ($)' but X-axis has no label"
    }
  ],
  "summary": {
    "passed": 3,
    "failed": 1,
    "total": 4,
    "pass_rate": 0.75
  }
}
```

### Grading principles

Require concrete evidence for PASS, never benefit of doubt. Review assertions too: fix easy/hard/unverifiable ones next iteration. For two versions, try blind LLM comparison without version labels.

## Aggregating results

After grading all runs, save per-configuration statistics in `benchmark.json`:

```json
{
  "run_summary": {
    "with_skill": {
      "pass_rate": { "mean": 0.83, "stddev": 0.06 },
      "time_seconds": { "mean": 45.0, "stddev": 12.0 },
      "tokens": { "mean": 3800, "stddev": 400 }
    },
    "without_skill": {
      "pass_rate": { "mean": 0.33, "stddev": 0.10 },
      "time_seconds": { "mean": 32.0, "stddev": 8.0 },
      "tokens": { "mean": 2100, "stddev": 300 }
    },
    "delta": {
      "pass_rate": 0.50,
      "time_seconds": 13.0,
      "tokens": 1700
    }
  }
}
```

`delta` compares cost (time/tokens) and benefit (pass rate).

## Analyzing patterns

After benchmarks, inspect patterns hidden by aggregates:
- Always pass both: remove/replace uninformative assertions.
- Always fail both: investigate broken/wrong assertions or excessive difficulty.
- Pass only with skill: understand why it adds value.
- Inconsistent/high stddev: tighten ambiguity with examples/specific guidance.
- Time/token outliers (e.g., 3×): read traces for bottlenecks.

## Reviewing results with a human

Human review catches unasserted issues. Save specific per-case feedback in workspace `feedback.json`:

```json
{
  "eval-top-months-chart": "The chart is missing axis labels and the months are in alphabetical order instead of chronological.",
  "eval-clean-missing-emails": ""
}
```

"The chart is missing axis labels" is actionable; "looks bad" is not. Empty feedback means the output looked fine.

## Iterating on the skill

Give the LLM current `SKILL.md` plus failed assertions (specific gaps), human feedback (broader quality), and traces (causes). Request generalized fixes, not case-specific patches; fewer/better instructions; reasons, not rigid directives; repeated helpers bundled in `scripts/`.

### The loop

1. Give the eval signals and current `SKILL.md` to an LLM and ask it to propose improvements.
2. Review and apply the changes.
3. Rerun all test cases in a new `iteration-<N+1>/` directory.
4. Grade and aggregate the new results.
5. Review with a human. Repeat.

Stop at satisfactory results, consistently empty feedback, or no meaningful improvement.
