---
name: workflow
description: Use when starting any non-trivial task. Activates when planning, implementing, or verifying work that has multiple steps. Defines success criteria, coordinates subagents, runs QA, and manages approval.
---

# Workflow

Every task has a verifiable goal — don't stop until met.

## Plan

1. Load `wiki-ops` skill — read relevant pages before touching any code.
2. Load `think-before-acting` skill — validate understanding.
3. Define what "done" looks like. Unclear → ask.
4. Multi-step tasks: share plan, get agreement before starting.
5. Load `invoke-subagents` skill — identify specialists, invoke for the work.

## Execute

1. For multi-task plans: load `parallel-agents` skill — dispatch independent tasks to subagents in parallel.
2. For sequential tasks: invoke specialist subagent per task with fresh context.
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

1. Load `wiki-ops` skill — ingest what this task taught about the workspace.
2. Lint wiki for contradictions or stale claims.

## If Stuck

Two cycles with no progress → stop, explain what's blocking, ask for direction.

## Simple Tasks

One-line fixes, config changes, isolated changes → skip planning. Still run QA and wait for approval before applying.

## Gotchas

- "Looks good" counts as approval — don't ask again after receiving it.
- Presenting results with failing QA is worse than not presenting at all — fix first.
- Wiki ingest at the end is not optional — it's how the workspace learns.
