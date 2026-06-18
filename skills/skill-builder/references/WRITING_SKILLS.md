# Writing Skills — Body Structure and Patterns

## Writing the body

Keep `SKILL.md` under 500 lines / 5,000 tokens. Move reference material to separate files.

### Recommended structure

1. One-line summary of what the skill does
2. Step-by-step instructions or procedure
3. Concrete examples (inputs and outputs)
4. Common edge cases / gotchas

### Spend context wisely

Ask for each paragraph: "Would the agent get this wrong without this instruction?" If no → cut it.

- ✅ Project-specific conventions, domain procedures, non-obvious edge cases, environment-specific facts
- ❌ General concepts the agent already understands (what a PDF is, how HTTP works, what a migration does)

### Calibrate specificity

| Task type | Approach |
|---|---|
| Flexible / multiple valid approaches | Explain *why*, give freedom |
| Fragile / must follow sequence | Be prescriptive, exact commands, "do not modify" |

### Provide defaults, not menus

```markdown
# Too many options
You can use pypdf, pdfplumber, PyMuPDF, or pdf2image...

# Clear default with escape hatch
Use pdfplumber for text extraction. For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
```

### Favor procedures over declarations

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

Concise stepwise guidance with one working example > exhaustive documentation. Over-comprehensive skills trigger unproductive paths on instructions that don't apply.

---

## Effective instruction patterns

### Gotchas section — highest-value content

Environment-specific facts that defy assumptions. Not general advice — concrete corrections:

```markdown
## Gotchas

- The `users` table uses soft deletes. Queries must include
  `WHERE deleted_at IS NULL` or results include deactivated accounts.
- User ID is `user_id` in the database, `uid` in auth, `accountId` in billing.
- The `/health` endpoint returns 200 as long as the web server runs,
  even if DB is down. Use `/ready` for full service health.
```

> **Iteration tip:** when the agent makes a mistake you correct, add it to gotchas. Most direct way to improve a skill.

### Templates for output format

Concrete format example in a code block — agents pattern-match against structures better than prose descriptions. Short templates inline; long ones in `assets/`.

### Checklists for multi-step workflows

```markdown
- [ ] Step 1: Analyze the form (`scripts/analyze_form.py`)
- [ ] Step 2: Create field mapping (`fields.json`)
- [ ] Step 3: Validate (`scripts/validate_fields.py`)
- [ ] Step 4: Fill form (`scripts/fill_form.py`)
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

For destructive or batch ops. Agent creates structured plan → validates against source of truth → executes only on success.

The critical step is validation with actionable errors: "Field 'signature_date' not found — available: customer_name, order_total, signature_date_signed".
