---
name: minimal-changes
description: Use this skill when writing, editing, refactoring, or fixing code. Activates on any code modification. Ensures the least code that solves the problem — no speculative features, no unused abstractions, no drive-by changes.
---

# Minimal Changes

Least code that solves the problem. Nothing more. Nothing adjacent. Smaller diffs = fewer bugs = faster review.

## Procedure

1. Write the least code that solves the problem.
2. No speculative features, unused abstractions, unrequested flexibility.
3. If the result could be half the size → rewrite it.
4. Before creating a file, search for existing functionality to extend.
5. Only create new files when extension is genuinely impossible — state why.
6. Change only the code directly related to the task — no adjacent improvements, no style fixes, no drive-by refactors.
7. Match existing style — even if you'd write it differently.
8. Unrelated issues you notice → mention to user, don't fix.
9. Remove imports/variables/functions your changes made unused. Leave pre-existing dead code unless asked.
10. Always cite `file:line` when referencing code in plans, diffs, or explanations.

## Gotchas

- "Might need this later" → you won't. Adding it now costs review time and adds surface for bugs.
- Two files doing similar things → extract shared logic. Duplicated code doubles the maintenance burden.
- "While I'm here" changes are the #1 source of unintended regressions.
- Fixing style in adjacent code looks helpful but introduces noise in diffs and risk of breakage.
- `file:line` citations are not optional — without them, reviewers can't verify your reasoning.
