# Best practices for skill creators

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

For a more structured approach to iteration, see [EVALUATING.md](EVALUATING.md).

## Spending context wisely

Activation loads all `SKILL.md`, competing with history, system context, and other skills.

### Add what the agent lacks, omit what it knows

Keep unknown conventions, domain procedures, edge cases, tools/APIs—not PDF/HTTP/migration basics. For each instruction ask whether omission causes errors; if no, cut; if unsure, test. A task already handled well without the skill may need none.

### Design coherent units

One coherent, composable unit: too narrow forces multiple loads/conflicts; too broad impairs precise activation.

### Aim for moderate detail

Prefer stepwise guidance + working example over exhaustive documentation: irrelevant instructions trigger unproductive paths. Leave judgment-tolerant edge cases to the agent.

### Structure large skills with progressive disclosure

Keep `SKILL.md` under 500 lines/5,000 tokens with every-run instructions; move detailed references out. Specify when to load: "Read `references/api-errors.md` for non-200 responses", not "see references/".

## Calibrating control

Calibrate each part's specificity to task fragility.

### Match specificity to fragility

**Give freedom/explain why** when several approaches are valid and variation is tolerable:

```markdown
## Code review process

1. Check all database queries for SQL injection (use parameterized queries)
2. Verify authentication checks on every endpoint
3. Look for race conditions in concurrent code paths
4. Confirm error messages don't leak internal details
```

**Be prescriptive** when operations are fragile, consistency matters, or a specific sequence must be followed:

````markdown
## Database migration

Run exactly this sequence:

```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
````

Most skills have a mix. Calibrate each part independently.

### Provide defaults, not menus

When multiple tools or approaches could work, pick a default and mention alternatives briefly rather than presenting them as equal options.

### Favor procedures over declarations

A skill should teach the agent *how to approach* a class of problems, not *what to produce* for a specific instance.

## Patterns for effective instructions

### Gotchas sections

Gotchas correct predictable mistakes with environment-specific facts, not general advice:

```markdown
## Gotchas

- The `users` table uses soft deletes. Queries must include
  `WHERE deleted_at IS NULL` or results will include deactivated accounts.
- The user ID is `user_id` in the database, `uid` in the auth service,
  and `accountId` in the billing API. All three refer to the same value.
```

Keep gotchas in `SKILL.md` where the agent reads them before encountering the situation.

### Templates for output format

Use concrete format templates rather than prose: short ones inline, long ones in referenced `assets/`.

### Checklists for multi-step workflows

Use progress checklists for dependent/gated steps:

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

Before proceeding: work → validator (script/checklist/self-check) → fix → repeat until pass.

### Plan-validate-execute

Batch/destructive operations: structured intermediate plan → validate against source of truth → execute only on pass.

### Bundling reusable scripts

Compare test traces; repeated charting/parsing/validation logic warrants a tested reusable `scripts/` helper.
