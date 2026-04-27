---
name: parallel-work
description: Use this skill when 2 or more tasks touch different files or subsystems with no shared state and no sequential dependencies. Always split independent work across parallel specialist agents — one per domain. Parallel execution reduces context per agent, optimizing token consumption and output quality. Do NOT use when tasks share files or one affects another's outcome.
---

> **CRITICAL:** When tasks are independent, parallelization is mandatory — not a suggestion. Sequential execution of independent tasks wastes time and increases context per agent. This is not optional.

# Parallel Work

Run independent tasks concurrently. One subagent per domain — no overlap, no shared state. Parallel = N tasks in the time of 1. Each agent gets smaller context → better results with fewer tokens.

---

## <HARD-GATE> Parallelization Mandate

If you have identified 2+ independent tasks (no shared files, no dependencies), you MUST dispatch them in parallel. Sequential execution of independent tasks is a violation of this workflow.

**Check before dispatching:**
- [ ] Tasks touch different files/subsystems
- [ ] No task depends on another's output
- [ ] No shared mutable state

All checks pass → dispatch in parallel. No exceptions.

---

## When to Use

- 2+ tasks touching different files/subsystems
- No dependency between tasks
- No shared mutable state

**Don't use when** — tasks share files or one affects the other's outcome. If you think you "need full system context," decompose the task further — there is almost always a way to isolate domains.

---

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

---

## Prompt Quality

Vague prompts → lost subagents. Be specific.

**Weak:** "Fix the auth tests"
**Sharp:** "Fix 2 failing tests in `src/auth/login.test.ts`: 'should reject expired token' and 'should refresh token'. Root cause likely in `src/auth/token.ts`. Don't modify other files. Return: what you found and fixed."

---

## After Integration

Run full test suite. Independent fixes can create unexpected interactions.

---

## Conflict Handling

If two subagents edited the same file → manual merge. This shouldn't happen if domains were properly separated. If it does, reassess independence for next time.

---

## Rationalization Prevention

These are excuses agents use to skip parallelization. None are valid.

| Excuse | Reality |
|--------|---------|
| "Sequential is simpler to manage" | Simpler ≠ better. Parallel is faster and gives each agent smaller context. |
| "Only 2 tasks, not worth parallelizing" | 2 tasks in parallel = half the time. Always worth it if independent. |
| "I'll lose track of parallel agents" | You review each result as it returns. Same as sequential, just faster. |
| "Parallel might cause conflicts" | Only if you misidentify independence. Check file overlap before dispatching. |
| "I can do them sequentially, it's fine" | "Fine" wastes time and increases context per agent. Parallel is mandatory for independent tasks. |
| "The tasks are small enough to combine" | Combining tasks increases agent context. Keep them separate. |

---

## Red Flags — Self-Check

If you catch yourself thinking any of these, STOP. You are about to skip parallelization.

- "Let me do these one at a time"
- "I'll start with the first task and then the second"
- "These are quick enough to do sequentially"
- "Managing parallel agents is overhead"
- "I'll batch these together"
- "Only two tasks, I'll just do them in order"

---

## Gotchas

- Launching parallel agents that share files guarantees conflicts — verify file independence before dispatching.
- Without specific prompts, each subagent will explore the codebase independently and waste time on context you already have.
- Sequential execution of independent tasks is not "safer" — it's slower and gives each agent more context to process.
