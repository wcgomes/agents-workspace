---
name: invoke-subagents
description: Use before every task — identifies the best specialist and invokes a subagent for the work
---

# Invoke Subagents

**Always invoke a subagent.** For every task, find the best available specialist and invoke them — even if you could do it yourself. No exceptions.

Always tell user which specialist(s) chosen and why.

## How

1. Assess the task — what domain, what files, what outcome.
2. Pick the best specialist available for that domain.
3. Build a focused prompt — self-contained, no session references:
   - What to do (goal)
   - Where to work (scope/files)
   - What not to touch (constraints)
   - What to return (expected output)
4. Invoke. Wait for result. Review.

## Multiple Specialists

Task spans domains → invoke one per domain. Parallel if independent (load `parallel-agents`). You orchestrate, synthesize outputs.

## Large Tasks

Break into small tasks (2-5 min each). One subagent per task. Review after each. Never carry context between tasks — build fresh prompts each time.

## Review After Every Subagent

1. **Spec check**: does the result match what was asked? Missing or extra?
2. **Quality check**: is the code well-built? Style, patterns, no shortcuts?

Spec must pass before quality. Issues found → subagent fixes → re-review.

## Context Discipline

- Subagents never inherit your session. You provide exactly what they need.
- Keeps their context small. Preserves yours for coordination.
- If a subagent asks questions → answer before they proceed.
