# Evaluating skill output quality

> How to test whether your skill produces good outputs using eval-driven iteration.

## Designing test cases

A test case has three parts:

* **Prompt**: a realistic user message — the kind of thing someone would actually type.
* **Expected output**: a human-readable description of what success looks like.
* **Input files** (optional): files the skill needs to work with.

Store test cases in `evals/evals.json` inside your skill directory:

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

**Tips for writing good test prompts:**

* **Start with 2-3 test cases.** Don't over-invest before you've seen your first round of results.
* **Vary the prompts.** Use different phrasings, levels of detail, and formality.
* **Cover edge cases.** Include at least one prompt that tests a boundary condition.
* **Use realistic context.** Real users mention file paths, column names, and personal context.

## Running evals

The core pattern is to run each test case twice: once **with the skill** and once **without it** (or with a previous version). This gives you a baseline to compare against.

### Workspace structure

Organize eval results in a workspace directory alongside your skill directory. Each pass through the full eval loop gets its own `iteration-N/` directory:

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

Each eval run should start with a clean context — no leftover state from previous runs. Provide:

* The skill path (or no skill for the baseline)
* The test prompt
* Any input files
* The output directory

For the baseline, use the same prompt but without the skill path, saving to `without_skill/outputs/`.

When improving an existing skill, use the previous version as your baseline. Snapshot it before editing (`cp -r <skill-path> <workspace>/skill-snapshot/`).

### Capturing timing data

Timing data lets you compare how much time and tokens the skill costs relative to the baseline. Record token count and duration for each run:

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332
}
```

## Writing assertions

Assertions are verifiable statements about what the output should contain or achieve. Add them after you see your first round of outputs.

Good assertions:

* `"The output file is valid JSON"` — programmatically verifiable.
* `"The bar chart has labeled axes"` — specific and observable.
* `"The report includes at least 3 recommendations"` — countable.

Weak assertions:

* `"The output is good"` — too vague to grade.
* `"The output uses exactly the phrase 'Total Revenue: $X'"` — too brittle.

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

Grading means evaluating each assertion against the actual outputs and recording **PASS** or **FAIL** with specific evidence. The evidence should quote or reference the output, not just state an opinion.

The simplest approach is to give the outputs and assertions to an LLM and ask it to evaluate each one. For assertions that can be checked by code (valid JSON, correct row count, file exists), use a verification script — scripts are more reliable than LLM judgment for mechanical checks.

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

* **Require concrete evidence for a PASS.** Don't give the benefit of the doubt.
* **Review the assertions themselves, not just the results.** While grading, notice when assertions are too easy, too hard, or unverifiable. Fix these for the next iteration.

For comparing two skill versions, try **blind comparison**: present both outputs to an LLM judge without revealing which came from which version.

## Aggregating results

Once every run in the iteration is graded, compute summary statistics per configuration and save them to `benchmark.json`:

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

The `delta` tells you what the skill costs (more time, more tokens) and what it buys (higher pass rate).

## Analyzing patterns

Aggregate statistics can hide important patterns. After computing the benchmarks:

* **Remove or replace assertions that always pass in both configurations.** These don't tell you anything useful.
* **Investigate assertions that always fail in both configurations.** Either the assertion is broken, the test case is too hard, or the assertion is checking for the wrong thing.
* **Study assertions that pass with the skill but fail without.** This is where the skill is clearly adding value. Understand *why*.
* **Tighten instructions when results are inconsistent across runs.** High stddev may mean ambiguous instructions. Add examples or more specific guidance.
* **Check time and token outliers.** If one eval takes 3x longer, read its execution transcript to find the bottleneck.

## Reviewing results with a human

Assertion grading catches a lot, but only checks what you thought to write assertions for. A human reviewer brings a fresh perspective. Record specific feedback for each test case and save it in the workspace (e.g., `feedback.json`):

```json
{
  "eval-top-months-chart": "The chart is missing axis labels and the months are in alphabetical order instead of chronological.",
  "eval-clean-missing-emails": ""
}
```

"The chart is missing axis labels" is actionable; "looks bad" is not. Empty feedback means the output looked fine.

## Iterating on the skill

After grading and reviewing, you have three sources of signal:

* **Failed assertions** point to specific gaps.
* **Human feedback** points to broader quality issues.
* **Execution transcripts** reveal *why* things went wrong.

The most effective way to turn these signals into skill improvements is to give all three — along with the current `SKILL.md` — to an LLM and ask it to propose changes. When prompting the LLM, include these guidelines:

* **Generalize from feedback.** Fixes should address underlying issues broadly rather than adding narrow patches for specific examples.
* **Keep the skill lean.** Fewer, better instructions often outperform exhaustive rules.
* **Explain the why.** Reasoning-based instructions work better than rigid directives.
* **Bundle repeated work.** If every test run independently wrote a similar helper script, bundle it into `scripts/`.

### The loop

1. Give the eval signals and current `SKILL.md` to an LLM and ask it to propose improvements.
2. Review and apply the changes.
3. Rerun all test cases in a new `iteration-<N+1>/` directory.
4. Grade and aggregate the new results.
5. Review with a human. Repeat.

Stop when you're satisfied with the results, feedback is consistently empty, or you're no longer seeing meaningful improvement between iterations.
