---
name: delegate
description: Use when handing work to subagents, reviewing what they return, or managing delegated and parallel work. Load right after the team is composed and before any handoff.
---

# Delegate

Structured handoff, review, and status management for delegated specialist work.

---

## Prerequisites

- team-assembly must be loaded first
- Specialist team and execution plan must be ready

---

## Delegation Workflow

### Who to Delegate To

Use the specialists identified by team-assembly. Each role in the team roster maps to a specific specialist agent. Do not delegate to the platform's default agent, a generalist, or "the current agent" when a specialist was identified for that role.

If the platform's subagent tool requires an agent identifier, use the specialist's identifier from the team roster. If the specialist is not available as a subagent, use the closest available specialist — not the generalist.

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

## If Stuck

Two cycles with no progress:
- stop
- explain the blocker
- ask for direction if needed

Repeated delegated `NEEDS_CONTEXT` or `BLOCKED` without material progress counts as no progress.
