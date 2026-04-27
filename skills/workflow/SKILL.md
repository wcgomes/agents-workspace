---
name: workflow
description: Use this skill when starting any task with multiple steps or unclear success criteria. Start by loading wiki skill to query existing knowledge. Delegate planning and coordination to an orchestrator agent, which dispatches specialist agents in parallel when possible. Activates when task requires planning, implementing, or verifying work.
---

> **CRITICAL:** Every task follows this flow: wiki query → plan → delegate to specialists → verify. Never skip wiki query or attempt to do all work yourself. This is not optional.

# Workflow

Every task has a verifiable goal — don't stop until met.

---

## <HARD-GATE> Phase Progression

You MUST complete each phase before moving to the next. Do NOT skip phases. Do NOT combine phases. If you find yourself writing code during Plan, you have violated this gate.

**Valid progression:** Plan → Execute → Verify → After Task

No exceptions. No shortcuts. No "I'll plan while I implement."

---

## Phase 1: Plan

1. Load `wiki` skill — read `wiki/index.md` first, then relevant pages before touching any code.
2. Load `think-before-acting` skill — validate understanding.
3. Define what "done" looks like. Unclear → ask.
4. Multi-step tasks: share plan, get agreement before starting.
5. Load `invoke-subagents` skill — identify specialists. Find an orchestrator agent to coordinate them if available, otherwise orchestrate directly.

<HARD-GATE> You may NOT proceed to Execute without:
- [ ] Wiki queried
- [ ] Understanding validated
- [ ] "Done" criteria defined
- [ ] Plan shared and agreed upon
- [ ] Subagent strategy identified

---

## Phase 2: Execute

1. For multi-task plans: load `parallel-work` skill — dispatch independent tasks to subagents in parallel via orchestrator agent.
2. For sequential tasks: invoke specialist subagent per task with fresh context.
3. Each subagent gets focused, self-contained prompt. Never inherits your session.
4. Final validation and verification is always your responsibility — review orchestrator/specialist output before presenting to user.

<HARD-GATE> You may NOT write implementation code directly. Every implementation task MUST be delegated to a specialist subagent. You orchestrate, review, and validate — you do not implement.

---

## Phase 3: Verify

1. Run tests, linter, build. Fix failures first.
2. Two-stage review per task: spec compliance → code quality.
3. Show diff of what changed.
4. Wait for explicit approval — any clear affirmative counts.

<HARD-GATE> You may NOT claim completion without:
- [ ] Tests/linter/build passing
- [ ] Spec compliance verified
- [ ] Code quality verified
- [ ] Diff shown to user
- [ ] Explicit approval received

---

## Phase 4: After Task

1. Load `wiki` skill — ingest what this task taught about the workspace. **Evaluate automatically** — do NOT wait for the user to ask.
2. Load `skill-candidates` skill — evaluate if this task revealed a recurring procedural pattern. **Evaluate automatically** during ingest.
3. Lint wiki for contradictions or stale claims.

<HARD-GATE> You may NOT end a task without:
- [ ] Evaluating whether wiki ingest is needed (architectural decision, new pattern, domain rule, corrected assumption)
- [ ] Evaluating whether a procedural pattern repeated that could become a skill candidate
- [ ] Linting wiki for contradictions

---

## If Stuck

<HARD-GATE> Being stuck does NOT exempt you from the workflow. Two cycles with no progress → stop, explain what's blocking, ask for direction. Do NOT use "stuck" as an excuse to skip phases, implement directly, or abandon the workflow.

---

## Rationalization Prevention

These are excuses agents use to skip parts of this workflow. None are valid.

| Excuse | Reality |
|--------|---------|
| "This is too simple for a workflow" | Simple things become complex. Follow the flow. No exceptions. |
| "I can do this faster myself" | Delegation takes 30 seconds. Fixing your own mistakes takes 10 minutes. |
| "I already know how to do this" | Knowing how ≠ doing it right. Subagent with fresh context catches what you miss. |
| "No need to update wiki for this" | Evaluate automatically. If architectural decision, new pattern, or domain rule — ingest. Don't decide it's "not worth it" before evaluating. |
| "This doesn't need a skill candidate" | Evaluate automatically during ingest. If procedural pattern repeated — track it. Don't pre-judge. |
| "I'll verify after I finish everything" | Verify after each subagent. End-of-pipeline verification catches cascading failures too late. |
| "The user is waiting, let me rush" | Presenting broken work wastes more time than verifying first. |

---

## Red Flags — Self-Check

If you catch yourself thinking any of these, STOP. You are about to violate this workflow.

- "Let me just do this quick edit myself"
- "No need to delegate this one"
- "I'll update the wiki later"
- "This pattern is too specific to track"
- "I'll verify everything at the end"
- "The plan is clear enough, no need to share it"
- "I know what the user wants, no need to ask"
- "This is just a small change, no workflow needed"
- "I can implement while planning"
- "Subagent overhead isn't worth it for this"

---

## Gotchas

- "Looks good" counts as approval — don't ask again after receiving it.
- Presenting results with failing QA is worse than not presenting at all — fix first.
- Wiki ingest at the end is not optional — it's how the workspace learns.
- Skill candidate evaluation at the end is not optional — it's how the workspace improves its processes.
