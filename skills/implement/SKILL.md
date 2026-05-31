---
name: implement
description: Use this skill before writing, editing, refactoring, or fixing code. Validates understanding and enforces minimal changes.
---

# Implement

**Prerequisite:** This skill may only be activated after `delegate` has been loaded and evaluated. Do not proceed with implementation until specialist eligibility has been assessed under the policy in `AGENTS.md`.

Validate understanding before acting. Write the least code that solves the problem. Nothing more.

---

## <HARD-GATE> Before Any Code Change

1. **Clarify** — state your understanding of the task. If unclear → stop, ask.
2. **Validate alternatives** — if a simpler approach exists → say so before proceeding.
3. **Self-review plan** — before writing, list what you're about to do and why.

---

## Clarification Questions

Before implementing, confirm:
- What exactly needs to be done?
- What's the expected output?
- What files/subsystems are in scope?
- What should NOT be changed?
- What could go wrong with this approach?

If any answer is unclear → stop and ask. Don't guess.

---

## Minimal Changes Procedure

1. Write the least code that solves the problem.
2. No speculative features, unused abstractions, unrequested flexibility.
3. If the result could be half the size → rewrite it.
4. Before creating a file, search for existing functionality to extend.
5. Only create new files when extension is genuinely impossible — state why.
6. Change only code directly related to the task — no drive-by changes.
7. Match existing style — even if you'd write it differently.
8. Always cite `file:line` when referencing code.

---

## Self-Review Before Reporting

Before reporting completion:
- [ ] Built exactly what was requested?
- [ ] No orthogonal changes?
- [ ] Unused code/imports removed?
- [ ] Existing style matched?
- [ ] No new warnings or errors introduced?

---

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "I think they mean X" | Confirm first. |
| "I'll add this since I'm here" | Drive-by changes introduce bugs. |
| "Might need this later" | You won't. |
| "This style is better" | Match existing. |

---

## Gotchas

- "I think they mean X" without confirmation = wrong implementation.
- Two files doing similar things → extract shared logic.
- Unused imports/variables → remove.
- Fixing style in adjacent code → don't.
- `file:line` citations are not optional.
