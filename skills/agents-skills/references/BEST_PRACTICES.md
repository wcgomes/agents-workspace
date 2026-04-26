# Best practices for skill creators

> How to write skills that are well-scoped and calibrated to the task.

## Start from real expertise

A common pitfall in skill creation is asking an LLM to generate a skill without providing domain-specific context — relying solely on the LLM's general training knowledge. The result is vague, generic procedures rather than the specific API patterns, edge cases, and project conventions that make a skill valuable.

### Extract from a hands-on task

Complete a real task in conversation with an agent, providing context, corrections, and preferences along the way. Then extract the reusable pattern into a skill. Pay attention to:

* **Steps that worked** — the sequence of actions that led to success
* **Corrections you made** — places where you steered the agent's approach
* **Input/output formats** — what the data looked like going in and coming out
* **Context you provided** — project-specific facts, conventions, or constraints the agent didn't already know

### Synthesize from existing project artifacts

When you have a body of existing knowledge, you can feed it into an LLM and ask it to synthesize a skill. Good source material includes:

* Internal documentation, runbooks, and style guides
* API specifications, schemas, and configuration files
* Code review comments and issue trackers (captures recurring concerns and reviewer expectations)
* Version control history, especially patches and fixes
* Real-world failure cases and their resolutions

## Refine with real execution

The first draft of a skill usually needs refinement. Run the skill against real tasks, then feed the results — all of them, not just failures — back into the creation process. Ask: what triggered false positives? What was missed? What could be cut?

Even a single pass of execute-then-revise noticeably improves quality, and complex domains often benefit from several.

Read agent execution traces, not just final outputs. If the agent wastes time on unproductive steps, common causes include instructions that are too vague, instructions that don't apply to the current task, or too many options presented without a clear default.

For a more structured approach to iteration, see [EVALUATING.md](EVALUATING.md).

## Spending context wisely

Once a skill activates, its full `SKILL.md` body loads into the agent's context window alongside conversation history, system context, and other active skills. Every token in your skill competes for the agent's attention with everything else in that window.

### Add what the agent lacks, omit what it knows

Focus on what the agent *wouldn't* know without your skill: project-specific conventions, domain-specific procedures, non-obvious edge cases, and the particular tools or APIs to use. You don't need to explain what a PDF is, how HTTP works, or what a database migration does.

Ask yourself about each piece of content: "Would the agent get this wrong without this instruction?" If the answer is no, cut it. If you're unsure, test it. And if the agent already handles the entire task well without the skill, the skill may not be adding value.

### Design coherent units

Deciding what a skill should cover is like deciding what a function should do: you want it to encapsulate a coherent unit of work that composes well with other skills. Skills scoped too narrowly force multiple skills to load for a single task, risking overhead and conflicting instructions. Skills scoped too broadly become hard to activate precisely.

### Aim for moderate detail

Overly comprehensive skills can hurt more than they help — the agent struggles to extract what's relevant and may pursue unproductive paths triggered by instructions that don't apply to the current task. Concise, stepwise guidance with a working example tends to outperform exhaustive documentation. When you find yourself covering every edge case, consider whether most are better handled by the agent's own judgment.

### Structure large skills with progressive disclosure

Keep `SKILL.md` under 500 lines and 5,000 tokens — just the core instructions the agent needs on every run. When a skill legitimately needs more content, move detailed reference material to separate files in `references/` or similar directories.

The key is telling the agent *when* to load each file. "Read `references/api-errors.md` if the API returns a non-200 status code" is more useful than a generic "see references/ for details."

## Calibrating control

Not every part of a skill needs the same level of prescriptiveness. Match the specificity of your instructions to the fragility of the task.

### Match specificity to fragility

**Give the agent freedom** when multiple approaches are valid and the task tolerates variation. For flexible instructions, explaining *why* can be more effective than rigid directives:

```markdown
## Code review process

1. Check all database queries for SQL injection (use parameterized queries)
2. Verify authentication checks on every endpoint
3. Look for race conditions in concurrent code paths
4. Confirm error messages don't leak internal details
```

**Be prescriptive** when operations are fragile, consistency matters, or a specific sequence must be followed:

```markdown
## Database migration

Run exactly this sequence:

```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
```

Most skills have a mix. Calibrate each part independently.

### Provide defaults, not menus

When multiple tools or approaches could work, pick a default and mention alternatives briefly rather than presenting them as equal options.

### Favor procedures over declarations

A skill should teach the agent *how to approach* a class of problems, not *what to produce* for a specific instance.

## Patterns for effective instructions

### Gotchas sections

The highest-value content in many skills is a list of gotchas — environment-specific facts that defy reasonable assumptions. These aren't general advice but concrete corrections to mistakes the agent will make without being told otherwise:

```markdown
## Gotchas

- The `users` table uses soft deletes. Queries must include
  `WHERE deleted_at IS NULL` or results will include deactivated accounts.
- The user ID is `user_id` in the database, `uid` in the auth service,
  and `accountId` in the billing API. All three refer to the same value.
```

Keep gotchas in `SKILL.md` where the agent reads them before encountering the situation.

### Templates for output format

When you need the agent to produce output in a specific format, provide a template. This is more reliable than describing the format in prose, because agents pattern-match well against concrete structures. Short templates can live inline in `SKILL.md`; for longer templates, store them in `assets/` and reference them from `SKILL.md`.

### Checklists for multi-step workflows

An explicit checklist helps the agent track progress and avoid skipping steps, especially when steps have dependencies or validation gates.

```markdown
## Form processing workflow

Progress:
- [ ] Step 1: Analyze the form (run `scripts/analyze_form.py`)
- [ ] Step 2: Create field mapping (edit `fields.json`)
- [ ] Step 3: Validate mapping (run `scripts/validate_fields.py`)
- [ ] Step 4: Fill the form (run `scripts/fill_form.py`)
- [ ] Step 5: Verify output (run `scripts/verify_output.py`)
```

### Validation loops

Instruct the agent to validate its own work before moving on. The pattern is: do the work, run a validator (a script, a reference checklist, or a self-check), fix any issues, and repeat until validation passes.

### Plan-validate-execute

For batch or destructive operations, have the agent create an intermediate plan in a structured format, validate it against a source of truth, and only then execute.

### Bundling reusable scripts

When iterating on a skill, compare the agent's execution traces across test cases. If you notice the agent independently reinventing the same logic each run — building charts, parsing a specific format, validating output — that's a signal to write a tested script once and bundle it in `scripts/`.
