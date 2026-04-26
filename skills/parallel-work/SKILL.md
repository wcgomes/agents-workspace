---
name: parallel-work
description: Use this skill when 2 or more tasks touch different files or subsystems with no shared state and no sequential dependencies. Activates when work can be parallelized. Do NOT use when tasks share files, one affects another's outcome, or the task requires full system context.
---

# Parallel Work

Run independent tasks concurrently. One subagent per domain — no overlap, no shared state. Parallel = N tasks in the time of 1.

## When to Use

- 2+ tasks touching different files/subsystems
- No dependency between tasks
- No shared mutable state

**Don't use when** — tasks share files, one affects the other's outcome, or you need full system context.

## Procedure

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
**Sharp:** "Fix 2 failing tests in `src/auth/login.test.ts`: 'should reject expired token' and 'should refresh token'. Root cause likely in `src/auth/token.ts`. Don't modify other files. Return: what you found and fixed."

## After Integration

Run full test suite. Independent fixes can create unexpected interactions.

## Conflict Handling

If two subagents edited the same file → manual merge. This shouldn't happen if domains were properly separated. If it does, reassess independence for next time.

## Gotchas

- Launching parallel agents that share files guarantees conflicts — verify file independence before dispatching.
- Without specific prompts, each subagent will explore the codebase independently and waste time on context you already have.
