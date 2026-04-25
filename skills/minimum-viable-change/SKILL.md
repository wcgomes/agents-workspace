---
name: minimum-viable-change
description: Use for all code changes — write the least code that solves the problem
---

# Minimum Viable Change

Least code that solves the problem. Nothing more.

## Rules

- Write the least code that solves the problem.
- No speculative features, unused abstractions, unrequested flexibility.
- Could be half the size → rewrite.
- Before creating a file, search for existing functionality to extend.
- Only create new files when extension is genuinely impossible — say why.

## Gotchas

- "Might need this later" → you won't. Don't add it.
- Two files doing similar things → extract shared logic, don't copy-paste.
