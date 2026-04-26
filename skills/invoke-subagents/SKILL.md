---
name: invoke-subagents
description: Use this skill before every task that involves implementation, investigation, or multi-step work. Always delegate to a specialist agent instead of working directly. Split complex tasks across multiple specialists to reduce context per agent and improve quality. When multiple specialists are needed, find an orchestrator agent to coordinate them. Activates on any delegable task.
---

> **CRITICAL:** Never do work directly when a specialist agent can do it better. Splitting tasks across agents reduces context per agent, optimizing token consumption and output quality. This is not optional.

# Invoke Subagents

**Always invoke a subagent.** For every task, find the best available specialist and invoke them — even if you could do it yourself. No exceptions.

Tell user which specialist(s) chosen and why.

## Procedure

1. Assess the task — what domain, what files, what outcome.
2. Pick the best specialist available for that domain.
3. Build a focused prompt — self-contained, no session references:
   - What to do (goal)
   - Where to work (scope/files)
   - What not to touch (constraints)
   - What to return (expected output)
4. Invoke. Wait for result. Review.

## Multiple Specialists

Task spans domains → invoke one per domain. Parallel if independent (load `parallel-work`). Find an orchestrator agent to coordinate specialists when available — keeps your context focused on vision and final validation. If no orchestrator available, you orchestrate.

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
- Delegating orchestration keeps your context compact — you focus on objectives and verification, not coordination details.

## Gotchas

- Without a focused prompt, subagents wander — every prompt must have goal, scope, constraints, and expected output.
- Skipping review saves 2 minutes now and costs 20 minutes later when bugs surface.
