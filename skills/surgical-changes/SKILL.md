---
name: surgical-changes
description: Use for all code edits — change only what's needed, nothing adjacent
---

# Surgical Changes

Change only what's needed. Nothing adjacent.

## Rules

- Don't improve adjacent code, formatting, comments.
- Match existing style.
- Unrelated issues → mention, don't fix.
- Remove imports/variables/functions your changes made unused. Leave pre-existing dead code unless asked.
- Fix root causes, not symptoms.
- No mock or fake data in production code (test fixtures are fine).
- Always cite `file:line` when referencing code in plans, diffs, or explanations.

## Gotchas

- "While I'm here" is the enemy of surgical changes.
- Style inconsistencies in adjacent code → note them, don't fix them.
