---
name: agents-skills
description: >
  Create, refine, and validate Agent Skills following the agentskills.io
  specification and best practices. Use when the user wants to create a new
  skill, improve an existing skill, write a SKILL.md, or needs guidance on
  skill structure, naming, descriptions, evals, scripts, or validation.
---

# Agent Skills

Follow the agentskills.io standard. A skill is a directory with a `SKILL.md`
file and optional resources.

## Directory structure

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── assets/           # Optional: templates, resources
└── evals/            # Optional: test cases
```

## SKILL.md format

YAML frontmatter + Markdown body.

### Required frontmatter

| Field | Rules |
|---|---|
| `name` | 1-64 chars, lowercase a-z, 0-9, hyphens. No leading/trailing/consecutive hyphens. Must match folder name. |
| `description` | 1-1024 chars. Describe what it does AND when to use it. Include keywords for activation. |

### Optional frontmatter

| Field | Purpose |
|---|---|
| `license` | License name or bundled file reference |
| `compatibility` | 1-500 chars. Env requirements (tools, OS, products) |
| `metadata` | Arbitrary key-value map |
| `allowed-tools` | Space-separated pre-approved tools (experimental) |

Examples:

```yaml
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
---
```

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
---
```

## Writing the body

Keep `SKILL.md` under 500 lines / 5,000 tokens. Move detailed reference
material to separate files.

### Content priorities

Add what the agent lacks, omit what it knows:
- ✅ Project-specific conventions, domain procedures, non-obvious edge cases
- ❌ General concepts the agent already understands

### Calibrate specificity

| Task type | Approach |
|---|---|
| Flexible / multiple valid approaches | Explain *why*, give freedom |
| Fragile / must follow sequence | Be prescriptive, exact commands |

### Provide defaults, not menus

Pick one default tool/approach. Mention alternatives briefly.

### Favor procedures over declarations

Teach the agent *how to approach* a class of problems, not what to produce
for one instance.

## Effective instruction patterns

Use these patterns as needed:

- **Gotchas**: Environment-specific facts that defy assumptions. Highest-value
  content. Keep in `SKILL.md` where the agent reads them first.
- **Templates**: Concrete output format examples (in code blocks) for
  pattern-matching. Short ones inline; long ones in `assets/`.
- **Checklists**: Track progress in multi-step workflows with `- [ ]` items.
- **Validation loops**: Do work → run validator → fix → repeat until pass.
- **Plan-validate-execute**: For destructive/batch ops, create plan → validate
  against source of truth → execute.

## Progressive disclosure

1. **Discovery**: agent loads only `name` + `description` (~100 tokens) at startup
2. **Activation**: full `SKILL.md` loads when task matches
3. **Resources**: files in `scripts/`, `references/`, `assets/` load only when
   referenced. Tell the agent *when* to load each file.

Reference files with relative paths from skill root.

## Scripts

Bundle executable scripts in `scripts/` when the agent repeats the same logic.
Use one-off commands (`uvx`, `npx`, etc.) for simple invocations.

Design scripts for agentic use:
- Non-interactive (no TTY prompts)
- Document with `--help`
- Helpful error messages ("Received X, expected Y")
- Structured output (JSON/CSV) to stdout, diagnostics to stderr
- Idempotent where possible
- Dry-run flag for destructive ops
- Meaningful exit codes

See [references/USING_SCRIPTS.md](references/USING_SCRIPTS.md) for
language-specific examples (Python PEP 723, Deno, Bun, Ruby, etc.).

## Evaluating skills

Run each test case **with skill** vs **without skill** (or previous version).

Structure:
- `evals/evals.json`: prompts, expected outputs, optional files, assertions
- Workspace: `iteration-N/eval-name/{with_skill,without_skill}/`
- Capture `timing.json` (tokens, duration) and `grading.json` (PASS/FAIL per assertion)

Process:
1. Design 2-3 test cases varying phrasing, detail, edge cases
2. Run both configurations
3. Grade assertions with concrete evidence
4. Aggregate in `benchmark.json`
5. Human review actual outputs
6. Feed failures + current `SKILL.md` to LLM for improvements
7. Iterate in new `iteration-N+1/`

See [references/EVALUATING.md](references/EVALUATING.md) for full details.

## Optimizing descriptions

The description decides activation. Test with ~20 eval queries
(should-trigger + should-not-trigger, including near-misses).

Process:
1. Split queries: 60% train, 40% validation
2. Run each query 3x, compute trigger rate
3. Revise description based on train failures only
4. Select best iteration by validation pass rate
5. Keep under 1024 characters

Principles:
- Use imperative phrasing: "Use this skill when..."
- Focus on user intent, not implementation
- Err on the side of being pushy — list contexts explicitly
- Be specific about boundaries (what it does NOT do)

See [references/OPTIMIZING_DESCRIPTIONS.md](references/OPTIMIZING_DESCRIPTIONS.md)
for the full loop.

## Validation

Use `skills-ref validate ./my-skill` to check frontmatter and naming
conventions.

## Best practices summary

1. **Start from real expertise** — extract from actual tasks or synthesize from
   project artifacts (runbooks, schemas, code reviews)
2. **Refine with execution** — run against real tasks, read traces, feed results
   back
3. **Spend context wisely** — cut anything the agent would get right without the
   skill
4. **Scope coherently** — one skill = one unit of work. Not too narrow, not too
   broad
5. **Iterate with evals** — test systematically, not anecdotally

See [references/BEST_PRACTICES.md](references/BEST_PRACTICES.md) for the full
guide. See [references/SPECIFICATION.md](references/SPECIFICATION.md) for the
complete format specification.
