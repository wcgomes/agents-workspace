---
name: workflow
description: Use when starting any non-trivial task — plan, delegate, execute, verify
---

# Workflow

Every task has a verifiable goal — don't stop until met.

## Plan

1. Load `wiki` skill — read relevant pages before touching any code.
2. Load `think-before-acting` skill — validate understanding.
3. Define what "done" looks like. Unclear → ask.
4. Multi-step tasks: share plan, get agreement before starting.
5. Load `invoke-subagents` skill — identify specialists, invoke for the work.

## Execute

1. For multi-task plans: load `parallel-agents` skill — dispatch independent tasks to subagents in parallel.
2. For sequential tasks: delegate each to specialist subagent with fresh context.
3. Each subagent gets focused, self-contained prompt. Never inherits your session.

## Verify

1. Run tests, linter, build. Fix failures first.
2. Two-stage review per task: spec compliance → code quality.
3. Show diff of what changed.
4. Wait for explicit approval — any clear affirmative counts.

## Apply

1. Never apply without explicit approval.
2. Never apply directly to final destination — always a safe copy.

## After Task

1. Load `wiki` skill — ingest what this task taught about the workspace.
2. Lint wiki for contradictions or stale claims.

## If Stuck

Two cycles with no progress → stop, explain what's blocking, ask for direction.

## Simple Tasks

One-line fixes, config changes, isolated changes → skip planning. Still run QA and wait for approval before applying.

## Gotchas

- "Looks good" counts as approval. Don't ask again.
- QA failing is not optional — fix before presenting.
- Wiki ingest at the end is not optional.
