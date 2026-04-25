---
name: workflow
description: Guides planning, execution, and verification of tasks. Use when starting any non-trivial task — defines success criteria, coordinates implementation, runs QA, and manages approval before applying changes.
---

# Workflow

Every task has a verifiable goal — don't stop until met.

## Plan, Execute, Verify

**Before starting:**
- Load `wiki` skill — read relevant pages before touching any code.
- Define what "done" looks like. Unclear → ask.
- Multi-step tasks: share plan and get agreement before starting.

**Before presenting results:**
- Run tests, linter, and build. Fix failures first.
- Show diff of what changed.
- Wait for explicit approval — any clear affirmative counts.

**Before applying:**
- Never apply without explicit approval.
- Never apply directly to final destination — always a safe copy.

**After task:**
- Load `wiki` skill — ingest what this task taught about the workspace.

## If stuck
Two cycles with no progress → stop, explain what's blocking, ask for direction.

## Simple tasks
One-line fixes, config changes, isolated changes → skip planning. Still run QA and wait for approval before applying.

## Gotchas
- "Looks good" counts as approval. Don't ask again after receiving it.
- QA failing is not optional — fix before presenting, not after.
- Wiki ingest at the end is not optional — do it before closing the task.