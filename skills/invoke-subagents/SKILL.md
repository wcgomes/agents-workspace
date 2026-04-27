---
name: invoke-subagents
description: Use this skill before every task that involves implementation, investigation, or multi-step work. Always delegate to a specialist agent instead of working directly. Split complex tasks across multiple specialists to reduce context per agent and improve quality. When multiple specialists are needed, find an orchestrator agent to coordinate them. Activates on any delegable task.
---

> **CRITICAL:** Never do work directly when a specialist agent can do it better. Splitting tasks across agents reduces context per agent, optimizing token consumption and output quality. This is not optional.

# Invoke Subagents

**Always invoke a subagent.** For every task, find the best available specialist and invoke them — even if you could do it yourself. No exceptions.

Tell user which specialist(s) chosen and why.

---

## <HARD-GATE> Delegation Mandate

You are the **orchestrator**, not the implementer. Your job is to:
- Decompose tasks
- Select specialists
- Build focused prompts
- Review results
- Validate quality

You do NOT write implementation code. You do NOT investigate directly. You do NOT fix bugs yourself. You delegate, review, and validate.

---

## Procedure

1. Assess the task — what domain, what files, what outcome.
2. Pick the best specialist available for that domain.
3. Build a focused prompt — self-contained, no session references:
   - What to do (goal)
   - Where to work (scope/files)
   - What not to touch (constraints)
   - What to return (expected output)
4. Invoke. Wait for result. Review.

---

## Team Structures

When a task has multiple phases or domains, form a **team of subagents**. Do not try to handle everything yourself.

### Orchestrator + Specialists (default for complex tasks)
```
You (Orchestrator)
├── Specialist A (domain 1)
├── Specialist B (domain 2)
└── Specialist C (domain 3)
```
You coordinate. Each specialist gets isolated context and focused scope.

### Parallel Specialists + Joiner (for independent subtasks)
```
You (Orchestrator)
├── Specialist A ──┐
├── Specialist B ──┼── Joiner/Integrator (synthesizes results)
└── Specialist C ──┘
```
Dispatch all specialists in parallel (load `parallel-work`). Review each result. Synthesize.

### Sequential Specialists (for dependent subtasks)
```
You (Orchestrator) → Specialist A → Review → Specialist B → Review → Specialist C
```
Each specialist gets output from previous as input. Review between each step.

### Planning + Execution + Validation Team
```
You (Orchestrator)
├── Planner Agent (decomposes task, creates plan)
├── Executor Agent(s) (implements plan, one per domain)
└── Validator Agent (runs tests, checks spec compliance, checks code quality)
```
Separate concerns. Planner doesn't implement. Executor doesn't validate. Validator doesn't plan.

---

## Multiple Specialists

Task spans domains → invoke one per domain. Parallel if independent (load `parallel-work`). Find an orchestrator agent to coordinate specialists when available — keeps your context focused on vision and final validation. If no orchestrator available, you orchestrate.

---

## Large Tasks

Break into small tasks (2-5 min each). One subagent per task. Review after each. Never carry context between tasks — build fresh prompts each time.

---

## Review After Every Subagent

<HARD-GATE> No subagent result passes without both reviews:

1. **Spec check**: does the result match what was asked? Missing or extra?
2. **Quality check**: is the code well-built? Style, patterns, no shortcuts?

Spec must pass before quality. Issues found → subagent fixes → re-review.

---

## Context Discipline

- Subagents never inherit your session. You provide exactly what they need.
- Keeps their context small. Preserves yours for coordination.
- If a subagent asks questions → answer before they proceed.
- Delegating orchestration keeps your context compact — you focus on objectives and verification, not coordination details.

---

## Rationalization Prevention

These are excuses agents use to avoid delegation. None are valid.

| Excuse | Reality |
|--------|---------|
| "This is too simple to delegate" | Simple tasks still benefit from fresh context. Delegation takes 30 seconds. |
| "I already know how to do this" | Knowing how ≠ doing it right. Fresh eyes catch what you miss. |
| "It'll take longer to explain to a subagent" | Your focused prompt takes 1 minute. Your implementation with accumulated context takes 5 minutes and has more bugs. |
| "I can do this in one edit" | Even one edit benefits from spec review. Delegate, review, validate. |
| "No specialist fits this task" | Use `general` agent type. Every task can be delegated. |
| "The subagent won't have enough context" | That's your job — build a focused prompt with exactly the context they need. |
| "I'll just fix this quick thing myself" | "Quick things" are how bugs enter the codebase. Delegate. |
| "Setting up subagents is overhead" | It's not overhead, it's quality assurance. The review alone justifies it. |

---

## Red Flags — Self-Check

If you catch yourself thinking any of these, STOP. You are about to implement directly instead of delegating.

- "Let me just do this quick edit"
- "I know exactly what to change"
- "No need for a subagent here"
- "This is just a one-liner"
- "I'll delegate the next one, but this one I'll handle"
- "The user is waiting, let me just fix it"
- "I can see the bug right here, let me patch it"
- "Delegating this would be slower"
- "I've done this exact thing before"

---

## Gotchas

- Without a focused prompt, subagents wander — every prompt must have goal, scope, constraints, and expected output.
- Skipping review saves 2 minutes now and costs 20 minutes later when bugs surface.
- Implementing directly "just this once" creates a precedent that breaks the entire delegation discipline.
