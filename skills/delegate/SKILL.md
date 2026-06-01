---
name: delegate
description: Hand off work to specialists with structured handoffs, review results, manage status. Load after team-assembly has composed the team.
---

# Delegate

Structured handoff, review, and status management for delegated specialist work.

---

## Prerequisites

- team-assembly must be loaded first
- Specialist team and execution plan must be ready
- Each handoff targets a specific specialist from the team roster — never default to the platform's general agent

---

## Delegation Workflow

### Who to Delegate To

Use the specialists identified by team-assembly. Each role in the team roster maps to a specific specialist agent. Do not delegate to the platform's default agent, a generalist, or "the current agent" when a specialist was identified for that role.

If the platform's subagent tool requires an agent identifier, use the specialist's identifier from the team roster. If the specialist is not available as a subagent, use the closest available specialist — not the generalist.

### Main Agent Role

The main agent coordinates. It does NOT:
- write code (delegate to implementer)
- research the codebase (delegate to researcher)
- debug errors (delegate to debugger)
- design interfaces (delegate to designer)
- run tests (delegate to tester)

The main agent DOES:
- plan and assemble the team
- delegate work with structured handoffs
- review delegated results
- synthesize outputs from multiple specialists
- report final results to the user

If you catch yourself doing specialist work, stop and delegate.

### Canonical Handoff Shape

```
Task: <what to do>
Objective: <why this work is needed>
Scope: <what is in and out>
Constraints: <rules, limits, expectations>
Relevant files or context: <paths, snippets, facts>
Expected deliverable: <artifact or decision>
Expected return format: <status + concise summary>
```

### Policy Inheritance

Subagents must follow AGENTS.md policies. Include in constraints: "You must follow the specialist-first workflow. Load `delegate` before any substantive work. Do not bypass delegation."

### Specialist Skills

When handing off code work, include in constraints: "Load `implement` before writing or editing code. Load `debug` when investigating errors."

### Return Format Rule

Return concise results only — no raw logs, no full tool output. Summarize findings. The delegating agent's context must stay clean.

---

## Parallel Delegation

Use only when scopes non-overlapping and no integration deps.

Good candidates:
- different files or subsystems
- separate evidence gathering
- independent validation or analysis
- complementary specialists with distinct responsibilities

---

## Subdelegation Rules

- Allowed when specialist fit improves
- Same discovery/selection rules apply
- Delegating agent remains accountable
- Review subdelegated output before integrating
- Avoid loops and ping-pong
- Avoid uncontrolled fan-out
- Preserve explicit scope ownership
- Do not subdelegate to avoid synthesis or review responsibility

---

## Review and Synthesis

### Stage 1: Conformance

Did it deliver what was requested? Nothing more, nothing less?

Did the subagent follow the specialist-first workflow? (i.e., did it load `delegate` and relevant skills, or provide evidence of delegation rather than direct execution?)

For subdelegation: did the subagent load `team-assembly` when composing sub-teams?

### Stage 2: Quality

Is it correct, maintainable, and usable for the current task?

If multiple delegated outputs return:
- compare them against the assigned scopes
- resolve conflicts
- synthesize a single coherent result before returning upward

Do not pass through raw delegated output without review.

---

## Status Protocol

Delegated agents report one of:

| Status | Meaning | Action |
|---|---|---|
| `DONE` | Completed, ready for review | Proceed to review |
| `DONE_WITH_CONCERNS` | Completed but flagged issues | Read concerns first |
| `NEEDS_CONTEXT` | Missing information | Re-dispatch with more context |
| `BLOCKED` | Cannot complete | Assess context, break task, or escalate |

This protocol applies across the delegation tree, including subdelegated work.
If `NEEDS_CONTEXT` or `BLOCKED` repeats without material progress, stop redispatching, declare the blocker, and choose among: provide missing context, decompose differently, escalate, or apply justified fallback.

---

## Anti-Rationalization

| Excuse | Reality |
|---|---|
| "I'll just do this part myself" | You're the coordinator, not the specialist. Delegate. |
| "It's faster if I do it" | Speed without quality is waste. Specialists produce better work. |
| "The specialist might not understand" | Provide clear context in the handoff. That's your job. |
| "I already know the answer" | Knowing ≠ executing. The specialist executes. |
| "It's just a small change" | Small changes break things too. Delegate to the right specialist. |

---

## If Stuck

Two cycles with no progress:
- stop
- explain the blocker
- ask for direction if needed

Repeated delegated `NEEDS_CONTEXT` or `BLOCKED` without material progress counts as no progress.
