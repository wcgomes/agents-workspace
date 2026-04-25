---
name: parallel-agents
description: Use when 2+ independent tasks can run simultaneously without shared state
---

# Parallel Agents

Run independent tasks concurrently. One subagent per domain — no overlap, no shared state.

## When

- 2+ tasks touching different files/subsystems
- No dependency between tasks
- No shared mutable state

**Don't when** — tasks are related, share files, or one affects the other's outcome.

## How

1. **Group by independence.** Tasks that touch different code with no overlap = separate domains.
2. **Build one prompt per domain.** Focused, self-contained:
   - Goal: what to accomplish
   - Scope: which files/subsystem
   - Context: everything needed — no session references
   - Constraints: what not to change
   - Output: what to return
3. **Launch all at once.** Each subagent runs isolated.
4. **Integrate when they return.** Read summaries, check for conflicts, run tests.

## Prompt Quality

Vague prompts → lost subagents. Be specific.

**Weak:** "Fix the auth tests"
**Sharp:** "Fix 2 failing tests in `src/auth/login.test.ts`: 'should reject expired token' and 'should refresh token'. Root cause is likely in `src/auth/token.ts`. Don't modify other files. Return: what you found and fixed."

## Review

After integration, run full test suite. Independent fixes can create unexpected interactions.

## Conflict Handling

If two subagents edited the same file → manual merge. This shouldn't happen if domains were properly separated. If it does, reassess independence for next time.
