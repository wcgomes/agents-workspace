# Grounding and refinement for skill creators

## Start from real expertise

Supply domain context, not just general model knowledge: specific API patterns, edge cases, and project conventions prevent generic procedures.

### Extract from a hands-on task

Complete a real task with context, corrections, and preferences; extract reusable:

* **Steps that worked** — the sequence of actions that led to success
* **Corrections you made** — places where you steered the agent's approach
* **Input/output formats** — what the data looked like going in and coming out
* **Context you provided** — project-specific facts, conventions, or constraints the agent didn't already know

### Synthesize from existing project artifacts

Synthesize skills from:

* Internal documentation, runbooks, and style guides
* API specifications, schemas, and configuration files
* Code review comments and issue trackers (captures recurring concerns and reviewer expectations)
* Version control history, especially patches and fixes
* Real-world failure cases and their resolutions

## Refine with real execution

Run real tasks and feed **all** results back, not just failures: false positives, misses, removable instructions. Even one execute/revise pass helps; complex domains may benefit from several. Read traces, not only outputs: wasted steps often indicate vague/irrelevant instructions or options without defaults.

For each instruction, ask whether omission causes errors. Cut it if not; test if uncertain. A task already handled well without the skill may need none.

## Design coherent units

One coherent, composable unit: too narrow forces multiple loads/conflicts; too broad impairs precise activation.

### Bundling reusable scripts

Compare test traces; repeated charting/parsing/validation logic warrants a tested reusable `scripts/` helper.
