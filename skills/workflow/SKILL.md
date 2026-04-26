---
name: workflow
description: Use this skill when starting any non-trivial task with multiple steps or unclear success criteria. Start by loading wiki skill to query existing knowledge. Delegate planning and coordination to an orchestrator agent, which dispatches specialist agents in parallel when possible. Activates when task requires planning, implementing, or verifying multi-step work.
---

> **CRITICAL:** Every non-trivial task follows this flow: wiki query → plan → delegate to specialists → verify. Never skip wiki query or attempt to do all work yourself. This is not optional.

# Workflow

Every task has a verifiable goal — don't stop until met.

## Plan

1. Load `wiki` skill — read `wiki/index.md` first, then relevant pages before touching any code.
2. Load `think-before-acting` skill — validate understanding.
3. Define what "done" looks like. Unclear → ask.
4. Multi-step tasks: share plan, get agreement before starting.
5. Load `invoke-subagents` skill — identify specialists. Find an orchestrator agent to coordinate them if available, otherwise orchestrate directly.

## Execute

1. For multi-task plans: load `parallel-work` skill — dispatch independent tasks to subagents in parallel via orchestrator agent.
2. For sequential tasks: invoke specialist subagent per task with fresh context.
3. Each subagent gets focused, self-contained prompt. Never inherits your session.
4. Final validation and verification is always your responsibility — review orchestrator/specialist output before presenting to user.

## Verify

1. Run tests, linter, build. Fix failures first.
2. Two-stage review per task: spec compliance → code quality.
3. Show diff of what changed.
4. Wait for explicit approval — any clear affirmative counts.

## After Task

1. Load `wiki` skill — ingest what this task taught about the workspace.
2. Lint wiki for contradictions or stale claims.

## If Stuck

Two cycles with no progress → stop, explain what's blocking, ask for direction.

## Simple Tasks

One-line fixes, config changes, isolated changes → skip planning. Still run QA and wait for approval before applying.

## Gotchas

- "Looks good" counts as approval — don't ask again after receiving it.
- Presenting results with failing QA is worse than not presenting at all — fix first.
- Wiki ingest at the end is not optional — it's how the workspace learns.
