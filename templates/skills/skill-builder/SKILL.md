---
name: skill-builder
description: "Use to create, refine, or validate agentskills.io skills: write SKILL.md, create skill directories, improve content/triggering, run evals, or diagnose activation failures."
---

# Skill Builder

Follow agentskills.io: a skill directory contains `SKILL.md` and optional resources.

> Add only what the agent would get wrong without instruction; cut known material.

> **Language:** English for all frontmatter, instructions, examples, and references.

> **Prose:** Single-line paragraphs, no hard-wrapping, preambles, or filler.

## Quickstart — minimal skill

Create `<name>/SKILL.md` (directory name MUST match `name`):

````markdown
---
name: roll-dice
description: Roll dice using a random number generator. Use when asked to roll a die (d6, d20, etc.), roll dice, or generate a random dice roll.
---

To roll a die, use:

```bash
echo $((RANDOM % <sides> + 1))
```

Replace `<sides>` with the number of sides (6 for standard, 20 for d20).
````

Expand only as needed.

## Directory structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: docs loaded on demand
├── assets/           # Optional: templates, static resources
└── evals/            # Optional: test cases
```

Keep file references one level deep from `SKILL.md`. Avoid deeply nested chains.

## Frontmatter

| Field | Rules |
|---|---|
| `name` (required) | 1–64 chars: `a-z`, `0-9`, hyphens; no leading/trailing/consecutive hyphens; matches folder. |
| `description` (required) | 1–1024 chars: what it does AND when to use it. |
| `license` | Optional license name/bundled file reference. |
| `compatibility` | Optional, 1–500 chars: tools/OS/product requirements; usually unnecessary. |
| `metadata` | Optional key-value map; unique keys avoid conflicts. |
| `allowed-tools` | Optional space-separated pre-approved tools; experimental, support varies. |

### Examples

With optional fields:
```yaml
---
name: data-pipeline
description: >
  Build and run data pipelines using our internal ETL framework.
  Use when the user mentions data ingestion, batch jobs, or ETL.
license: Proprietary. LICENSE.txt has complete terms
compatibility: Requires Python 3.14+ and uv
metadata:
  author: data-team
  version: "1.0"
allowed-tools: Bash(git:*) Bash(jq:*) Read
---
```

## Writing descriptions

Descriptions control activation. Use imperative "Use this skill when...", user intent rather than implementation, explicit contexts (including implicit ones), and relevant exclusion boundaries.

**Good vs poor:**

```yaml
# Poor — vague, no trigger context
description: Helps with PDFs.

# Poor — too narrow, misses common phrasings
description: Process CSV files.

# Good — specific scope, explicit triggers, broad coverage
description: >
  Analyze CSV and tabular data — summary statistics, derived columns,
  charts, and data cleaning. Use when the user has a CSV, TSV, or
  Excel file and wants to explore, transform, or visualize data,
  even if they don't explicitly mention "CSV" or "analysis."
```

Agents may skip simple one-step tasks they can handle alone; descriptions matter most for specialized/non-obvious knowledge.

## Writing the body

Keep `SKILL.md` under 500 lines / 5,000 tokens. Move reference material to separate files.

For body structure, patterns, and examples, read [references/WRITING_SKILLS.md](references/WRITING_SKILLS.md).

## Progressive disclosure

Startup loads every skill's `name` + `description` (~100 tokens); activation loads **all** `SKILL.md` (<5000 tokens); referenced `scripts/`, `references/`, `assets/` load on demand. Keep off-critical-path reference material separate. Specify loading conditions: "Read `references/api-errors.md` when the API returns non-200", not "see references/".

## Scripts

Bundle executables in `scripts/` when the agent repeats the same logic. Use one-off commands (`uvx`, `npx`) for simple invocations.

Require non-interactive operation (no TTY), `--help`, actionable errors ("Received X, expected Y"), structured JSON/CSV stdout and diagnostic stderr, meaningful exit codes, destructive-operation dry-run, and idempotency where possible.

For language setup (Python PEP 723, Deno, Bun, Ruby), read [references/USING_SCRIPTS.md](references/USING_SCRIPTS.md).

## Evaluating skills

Test each case **with skill** vs **without skill** (or previous version) to prove the skill adds value.

See [references/EVALUATING.md](references/EVALUATING.md) for full workflow.

## Optimizing descriptions (triggering)

Test triggering systematically; read [references/OPTIMIZING_DESCRIPTIONS.md](references/OPTIMIZING_DESCRIPTIONS.md) for query design and optimization. Use a validation split: description edits can regress passing queries.

## Validation

```bash
skills-ref validate ./my-skill
```

Checks frontmatter and naming conventions.

## Refinement

Ground skills in real tasks/project artifacts, not generic references. Keep one coherent scope, neither too narrow nor too broad. Iterate systematically with evals and execution traces, not only outputs; wasted steps signal vague instructions. No baseline improvement may mean no added value. Recheck description length and name/folder match after edits.

For authoring guidance read [references/BEST_PRACTICES.md](references/BEST_PRACTICES.md); for format details read [references/SPECIFICATION.md](references/SPECIFICATION.md).
