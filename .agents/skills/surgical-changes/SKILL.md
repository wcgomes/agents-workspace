---
name: surgical-changes
description: Use for all code edits. Activates when editing existing code. Changes only what's needed — no adjacent improvements, no style fixes, no drive-by refactors.
---

# Surgical Changes

Change only what's needed. Nothing adjacent. Every extra line changed is a line that can break.

## Procedure

1. Change only the code directly related to the task.
2. Match existing style — even if you'd write it differently.
3. Unrelated issues you notice → mention to user, don't fix.
4. Remove imports/variables/functions your changes made unused. Leave pre-existing dead code unless asked.
5. Always cite `file:line` when referencing code in plans, diffs, or explanations.

## Gotchas

- "While I'm here" changes are the #1 source of unintended regressions.
- Fixing style in adjacent code looks helpful but introduces noise in diffs and risk of breakage.
- `file:line` citations are not optional — without them, reviewers can't verify your reasoning.
