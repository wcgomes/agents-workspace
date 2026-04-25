---
name: minimum-viable-change
description: Use for all code changes. Activates when writing or modifying code. Ensures least code that solves the problem — no speculative features, no unused abstractions.
---

# Minimum Viable Change

Least code that solves the problem. Nothing more. Smaller diffs = fewer bugs = faster review.

## Procedure

1. Write the least code that solves the problem.
2. No speculative features, unused abstractions, unrequested flexibility.
3. If the result could be half the size → rewrite it.
4. Before creating a file, search for existing functionality to extend.
5. Only create new files when extension is genuinely impossible — state why.

## Gotchas

- "Might need this later" → you won't. Adding it now costs review time and adds surface for bugs.
- Two files doing similar things → extract shared logic. Duplicated code doubles the maintenance burden.
