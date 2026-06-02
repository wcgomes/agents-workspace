---
name: agents-skills
description: Create, refine, and validate Agent Skills following the agentskills.io specification. Use when writing a SKILL.md, creating a new skill directory, improving an existing skill's triggering or content, running evals, or diagnosing why a skill isn't activating.
---

# Agent Skills

Create skills that follow the agentskills.io standard. A skill is a directory with a `SKILL.md` file and optional resources.

> **Golden rule:** Add what the agent lacks, omit what it knows. If the agent would get it right without your instruction, cut it.

---

## Quickstart — minimal skill

Create `<name>/SKILL.md` (directory name MUST match `name`):

```markdown
---
name: roll-dice
description: Roll dice using a random number generator. Use when asked to roll a die (d6, d20, etc.), roll dice, or generate a random dice roll.
---

To roll a die, use:

```bash
echo $((RANDOM % <sides> + 1))
```

Replace `<sides>` with the number of sides (6 for standard, 20 for d20).
```

That's a complete skill. Expand only as needed.

---

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

---

## Frontmatter

### Required

| Field | Rules |
|---|---|
| `name` | 1-64 chars. `a-z`, `0-9`, hyphens. No leading/trailing/consecutive hyphens. Must match folder name. |
| `description` | 1-1024 chars. What it does AND when to use it. See "Writing descriptions" below. |

### Optional

| Field | Purpose |
|---|---|
| `license` | License name or bundled file reference |
| `compatibility` | 1-500 chars. Env requirements (tools, OS, products). Most skills don't need this. |
| `metadata` | Arbitrary key-value map. Use unique keys to avoid conflicts. |
| `allowed-tools` | Space-separated pre-approved tools (experimental, support varies) |

### Examples

Minimal:
```yaml
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
---
```

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

---

## Writing descriptions

The description decides activation. Poor description → skill never triggers.

**Principles:**
- **Imperative phrasing:** "Use this skill when..." not "This skill helps..."
- **User intent, not implementation:** what the user is trying to achieve, not internal mechanics
- **Err on the pushy side:** explicitly list contexts, including implicit ones
- **Name the boundary:** what the skill does NOT do, when relevant

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

**Nuance:** agents often skip skills for simple one-step tasks they can handle alone. Descriptions matter most for specialized knowledge or non-obvious domains.

---

## Writing the body

Keep `SKILL.md` under 500 lines / 5,000 tokens. Move reference material to separate files.

Ask for each paragraph: "Would the agent get this wrong without this instruction?" If no → cut it.

See [references/WRITING_SKILLS.md](references/WRITING_SKILLS.md) for body structure, patterns, and examples.

---

## Progressive disclosure

Three load stages:

1. **Discovery** (~100 tokens) — `name` + `description` loaded at startup for all skills
2. **Activation** (< 5000 tokens) — full `SKILL.md` loaded when task matches
3. **Resources** (on demand) — files in `scripts/`, `references/`, `assets/` loaded only when referenced

Tell the agent *when* to load each file:

```markdown
# Good
Read `references/api-errors.md` when the API returns a non-200 status.

# Bad
See references/ for details.
```

---

## Scripts

Bundle executables in `scripts/` when the agent repeats the same logic. Use one-off commands (`uvx`, `npx`) for simple invocations.

**Design for agentic use:**
- Non-interactive (no TTY prompts)
- `--help` documentation
- Helpful errors ("Received X, expected Y")
- Structured output (JSON/CSV) to stdout, diagnostics to stderr
- Idempotent where possible
- Dry-run flag for destructive ops
- Meaningful exit codes

See [references/USING_SCRIPTS.md](references/USING_SCRIPTS.md) for language-specific setup (Python PEP 723, Deno, Bun, Ruby).

---

## Evaluating skills

Test each case **with skill** vs **without skill** (or previous version) to prove the skill adds value.

See [references/EVALUATING.md](references/EVALUATING.md) for full workflow.

---

## Optimizing descriptions (triggering)

A skill only helps if it activates. Test triggering systematically.

See [references/OPTIMIZING_DESCRIPTIONS.md](references/OPTIMIZING_DESCRIPTIONS.md) for eval query design and optimization loop.

---

## Validation

```bash
skills-ref validate ./my-skill
```

Checks frontmatter and naming conventions.

---

## Best practices summary

1. **Start from real expertise** — extract from actual tasks or synthesize from project artifacts. Not generic references.
2. **Refine with execution** — read agent traces, not just outputs. Wasted steps signal vague instructions.
3. **Spend context wisely** — cut anything the agent would get right without the skill.
4. **Scope coherently** — one skill = one coherent unit of work. Not too narrow, not too broad.
5. **Iterate with evals** — test systematically, not anecdotally.

---

## Gotchas

- Description under 1024 chars — they tend to grow during optimization.
- Directory name MUST match `name` in frontmatter. Mismatch breaks discovery.
- Body loads **entirely** on activation — anything not on the critical path belongs in `references/`.
- Generic references ("see references/") don't trigger loading. Specify the condition.
- Skills that don't improve vs baseline may not be adding value — test with and without.
- Description changes during optimization can regress on earlier-passing queries — validation split catches this.

See [references/BEST_PRACTICES.md](references/BEST_PRACTICES.md) and [references/SPECIFICATION.md](references/SPECIFICATION.md) for full details.
