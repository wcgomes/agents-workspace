# Writing Skills — Body Structure and Patterns

## Writing the body

### Recommended structure

1. One-line summary of what the skill does
2. Step-by-step instructions or procedure
3. Concrete examples (inputs and outputs)
4. Common edge cases / gotchas

### Spend context wisely

Cut paragraphs whose omission would not cause errors.

- ✅ Project-specific conventions, domain procedures, non-obvious edge cases, environment-specific facts
- ❌ General concepts the agent already understands (what a PDF is, how HTTP works, what a migration does)

### Calibrate specificity

| Task type | Approach |
|---|---|
| Flexible / multiple valid approaches | Explain *why*, give freedom |
| Fragile / must follow sequence | Be prescriptive, exact commands, "do not modify" |

Calibrate each part independently; most skills mix both approaches.

**Flexible example:**

```markdown
## Code review process

1. Check all database queries for SQL injection (use parameterized queries)
2. Verify authentication checks on every endpoint
3. Look for race conditions in concurrent code paths
4. Confirm error messages don't leak internal details
```

**Fragile example:**

````markdown
## Database migration

Run exactly this sequence:

```bash
python scripts/migrate.py --verify --backup
```

Do not modify the command or add additional flags.
````

### Provide defaults, not menus

Pick a default; mention alternatives briefly rather than presenting equal options.

```markdown
# Too many options
You can use pypdf, pdfplumber, PyMuPDF, or pdf2image...

# Clear default with escape hatch
Use pdfplumber for text extraction. For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Favor procedures over declarations

Teach how to approach a class of problems, not just one answer.

```markdown
# Specific answer — only useful once
Join `orders` to `customers` on `customer_id`, filter `region = 'EMEA'`, sum `amount`.

# Reusable method — works for any query
1. Read schema from `references/schema.yaml` to find relevant tables
2. Join using `_id` foreign key convention
3. Apply filters from the user's request as WHERE clauses
4. Aggregate numeric columns, format as markdown table
```

### Aim for moderate detail

Prefer steps + one working example to exhaustive rules that trigger irrelevant paths. Leave judgment-tolerant edge cases to the agent.

---

## Effective instruction patterns

### Gotchas section — highest-value content

Correct false assumptions with environment-specific facts:

```markdown
## Gotchas

- The `users` table uses soft deletes. Queries must include `WHERE deleted_at IS NULL` or results include deactivated accounts.
- User ID is `user_id` in the database, `uid` in auth, `accountId` in billing.
- The `/health` endpoint returns 200 as long as the web server runs, even if DB is down. Use `/ready` for full service health.
```

Keep gotchas in `SKILL.md` so the agent reads them before the situation. Add corrected agent mistakes.

### Templates for output format

Use concrete code-block formats, not prose descriptions. Short templates inline; long ones in `assets/`.

### Checklists for multi-step workflows

Use progress checklists for dependent or gated steps.

```markdown
## Form processing workflow

Progress:
- [ ] Step 1: Analyze the form (`scripts/analyze_form.py`)
- [ ] Step 2: Create field mapping (`fields.json`)
- [ ] Step 3: Validate (`scripts/validate_fields.py`)
- [ ] Step 4: Fill form (`scripts/fill_form.py`)
- [ ] Step 5: Verify output (`scripts/verify_output.py`)
```

### Validation loops

Do work → run validator → fix → repeat until pass.

```markdown
1. Make edits
2. Run validation: `python scripts/validate.py output/`
3. Fails? Review error → fix → re-validate
4. Proceed only when validation passes
```

### Plan-validate-execute

Destructive/batch operations: structured plan → validate against source of truth → execute only on success.

Validation errors must be actionable: "Field 'signature_date' not found — available: customer_name, order_total, signature_date_signed".
