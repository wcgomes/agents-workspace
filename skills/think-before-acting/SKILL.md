---
name: think-before-acting
description: Use this skill before implementing, refactoring, or fixing code. Validate your understanding before taking action — state assumptions, ask if unclear, present alternatives if multiple interpretations exist. Stop and ask if requirements are ambiguous or if a simpler approach exists. This is not optional.
---

# Think Before Acting

Before writing code, validate your understanding. Prevents rework from acting on wrong assumptions.

## Procedure

1. State your assumptions about what needs to be done.
2. If unclear what the user wants → stop, ask. Don't guess.
3. If multiple interpretations exist → present all, let user pick.
4. If a simpler approach exists → say so before proceeding with a complex one.
5. If stuck two cycles with no progress → stop, explain blocker, ask for direction.

## <HARD-GATE> Delegation Check

Before implementing anything, ask yourself:

> "Am I about to write implementation code directly, or am I delegating to a subagent specialist?"

If you are about to write code directly → STOP. Load `invoke-subagents` skill and delegate. You are the orchestrator, not the implementer.

## Gotchas

- "I think they mean X" without confirmation = you will implement the wrong thing.
- Asking first always takes less time than reimplementing later.
- Implementing directly "just this once" breaks the delegation discipline for the entire session.
