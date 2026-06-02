---
name: orchestrate
description: Use when planning or executing delegated work, including "execute the plan" continuations. Covers the full coordination cycle: analyze request, define roles, discover specialists, plan execution, handoff, review and synthesize.
---

# Orchestrate

Full coordination cycle: analyze → assemble → delegate → review → synthesize.

---

## <HARD-GATES>

1. **Coordinator context first** — the main agent reads `wiki/index.md` before orchestration. Specialists use handoff context unless wiki lookup is explicitly needed.
2. **Roles are mandatory** — if specialist not found, use adjacent match or generic agent acting in that role. Never drop a role from the plan.
3. **Plan-to-execution uses orchestration** — when the user asks to execute, continue, resume, or implement a prior plan, load this skill before dispatch. If the prior plan was not created through orchestration, treat it as context and run team assembly from scratch.
4. **Software work needs verification roles** — for coding/refactoring tasks, select implementation and review roles at minimum unless the user explicitly asks not to review or the task is trivial.
5. **Parallel by default** — independent scopes dispatched in parallel. Sequential only with explicit output dependency.
6. **Measurable done criteria** — every handoff includes verifiable acceptance criteria. Review checks against these criteria.
7. **Confirm before multi-domain work** — when team has 3+ specialists OR scope is ambiguous/destructive: present team roster + execution plan, wait for user confirmation before delegating unless the user already approved that plan.
8. **Preserve team on continuation** — when user requests continuation of a task with an orchestrated team: reuse existing roles and specialists by default. Replace only when a specialist is unavailable, clearly wrong for the role, or the user changed direction.

---

## Phase 1: Analyze Request

Think about this like assembling a professional team for the job:

- What domains are involved (engineering, design, testing, marketing, etc.)?
- What specific platforms, tools, or channels are mentioned?
- What phases does the work go through? (planning → implementation → review → testing)
- Classify complexity: single-domain, multi-domain, or cross-functional.

**For continuation requests:** Check if a team was already composed through orchestration. If yes, preserve existing roles and specialists by default. Add roles for new domains, or replace a specialist only when unavailable, clearly wrong for the role, or the user changed direction. If the prior plan was not orchestrated, treat it as context and compose roles from scratch.

---

## Phase 2: Define Roles

Map each domain + phase to a specialist role. Apply templates below for common patterns.

For multi-domain work, ensure each domain has representation. Each phase that requires distinct expertise needs a responsible role.

For coding or refactoring work, define at least an implementation role and a review role unless the user explicitly opts out of review or the task is trivial.

---

## Phase 3: Discover Specialists

Before selecting, discover what specialists exist in the current environment. Use the dispatch interface, available agent descriptions, and platform-exposed identifiers. If config/file inspection is needed but the coordinator is prohibited from reading it directly, delegate that discovery as a handoff. Do not assume the pool is empty; do not skip to whatever agent the harness offers by default.

**Produce an explicit list** of the specialists you found (name + domain). This list is required output.

**Matching rules:**

- **Semantic match**: domain + work-type, NOT tech stack. A "Frontend Developer" covers React, Vue, or any stack.
- **Adjacent match** acceptable when exact unavailable. Adjacent means: same broader domain or workflow phase (e.g., no test specialist → use implementation specialist for test work).
- **Generic agent is last resort**, not a default. Selecting it requires that discovery found no specialist or adjacent fit — state that explicitly.
- **Generic still has a role**: never dispatch an unscoped generalist. If fallback is required, assign the generic agent to the defined role and scope.
- If user specified agents, incorporate them and apply semantic matching for the remaining roles.

**Role preservation:** The roles defined in Phase 2 are mandatory. If the exact specialist is not found, use adjacent match. If no adjacent exists, use the generic agent — but the role (e.g., reviewer, tester, architect) stays in the plan and the handoff must instruct the generic agent to act in that role.

---

## Phase 4: Plan Execution

- Identify dependencies between scopes
- Select coordination pattern (see below)
- Parallel groups: scopes with no integration deps
- Sequential: output of one feeds another
- Review always after parallel batches

---

## Coordination Patterns

### Full Parallel Discovery

**When:** independent analyses of the same topic from different angles.  
**How:** all specialists work simultaneously, synthesize at end.  
**Example:** product discovery from 8 domain perspectives.

### Parallel Kickoff → Merge → Review

**When:** parallel work feeds a downstream integrator.  
**How:** parallel group → merge point → sequential review.  
**Example:** content + design (parallel) → frontend dev (merge) → growth review.

### Sequential with Quality Gates

**When:** each phase depends on prior output.  
**How:** sequential handoffs with checkpoint reviews.  
**Example:** research → architecture → implementation → testing.

### Single Agent Structured

**When:** task fits cleanly in one domain.  
**How:** one specialist, structured handoff.  
**Example:** write a chapter, fix a specific bug.

---

## Team Templates

These are starting points, not prescriptions. Adapt roles, add or remove specialists based on the actual request. A small UI fix needs one specialist; a full product launch may need 10+.

The specialist names below are examples. Match by equivalent role/domain, not literal name — never delegate to a name that isn't actually available.

### Software Development

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | UX/Design | ux-researcher, ui-designer |
| Planning | Architecture | software-architect, backend-architect |
| Execution | Frontend | frontend-developer |
| Execution | Backend | backend-architect, senior-developer |
| Verification | Review | code-reviewer |
| Verification | Testing | reality-checker, api-tester |

Coordination: Parallel Kickoff → Merge → Review.

### Bug Fix / Incident

| Phase | Role | Specialist Match |
|---|---|---|
| Investigation | Debug | incident-response-commander |
| Fix | Implementation | domain-appropriate developer |
| Verification | Review | code-reviewer |
| Verification | Testing | reality-checker |

Coordination: Sequential with Quality Gates.

### Marketing Campaign

| Phase | Role | Specialist Match |
|---|---|---|
| Strategy | Planning | growth-hacker, product-manager |
| Execution | Content | content-creator, platform specialists |
| Verification | Analytics | analytics-reporter |

Coordination: Parallel Kickoff → Merge → Review.

### Product Discovery

| Phase | Role | Specialist Match |
|---|---|---|
| All parallel | Market | trend-researcher |
| All parallel | Technical | backend-architect, software-architect |
| All parallel | Brand | brand-guardian |
| All parallel | Growth | growth-hacker |
| All parallel | UX | ux-researcher |
| All parallel | Support | support-responder |
| Synthesis | Coordination | project-shepherd |

Coordination: Full Parallel Discovery.

### Content / Documentation

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | Strategy | content-creator, product-manager |
| Execution | Writing | technical-writer, content-creator |
| Verification | Review | code-reviewer, reality-checker |

Coordination: Sequential with Quality Gates.

---

## Phase 4.5: User Confirmation (Conditional)

**When to confirm:**
- Team has 3+ specialists
- Scope is ambiguous or has multiple valid interpretations
- Work is destructive (large refactoring, migration, deletion)
- User explicitly asked for approval

**What to present:**
```
Team Roster:
- [Role] → [Specialist] : [Scope]
- [Role] → [Specialist] : [Scope]
...

Execution Plan:
- Parallel: [scopes with no dependencies]
- Sequential: [dependency chain]
- Review: after each phase

Estimated complexity: [single/multi-domain, coordination pattern]
```

**Wait for user confirmation** before proceeding to handoff. User may adjust team, scope, or execution order.

**Skip confirmation only when:**
- No confirmation trigger applies
- User already approved the current team and execution plan

---

## Phase 5: Handoff

### Canonical Handoff Shape

Every handoff MUST start with the coordinator marker on its own first line. This marker is the portable signal that tells the receiving agent it is a specialist subagent acting on a delegated scope — not the main agent talking to the user.

```
[HANDOFF FROM COORDINATOR]
Task: <what to do>
Objective: <why this work is needed>
Scope: <what is in and out>
Done criteria: <measurable acceptance criteria>
Constraints: <task-specific rules + execution guardrails>
Context: <paths, snippets, facts>
Deliverable: <artifact or decision>
Return format: <status + concise summary>
```

**Policy inheritance:** The `[HANDOFF FROM COORDINATOR]` marker authorizes the subagent to execute directly under `AGENTS.md` → "If You Received a Handoff"; never omit it.

**Constraints should include task-relevant execution guardrails:**
- For edits: change only files directly related to the task; no drive-by changes
- For implementation: match existing style, even if you'd write it differently
- For investigation/debugging: reproduce or verify the issue when feasible before fixing
- For verification: test or inspect the requested behavior and note any gaps
- For all handoffs: self-review before reporting that the requested scope is complete

Use Constraints for additional task-specific rules (limits, files not to touch, expected behavior).

**Return format rule:** Return concise results only — no raw logs, no full tool output. Summarize findings. The delegating agent's context must stay clean.

---

## Parallel Delegation

Use only when scopes non-overlapping and no integration deps.

Good candidates:
- different files or subsystems
- separate evidence gathering
- independent validation or analysis
- complementary specialists with distinct responsibilities

---

## Phase 6: Review and Synthesize

### Stage 1: Conformance

Did it deliver what was requested? Nothing more, nothing less?

A specialist executing its handed scope directly is conformant — that is the expected behavior (see `AGENTS.md` → "If You Received a Handoff"). Flag a problem only if the scope was genuinely multi-domain and the specialist neither subdelegated the out-of-domain parts nor flagged them.

For subdelegation: when a specialist did compose a sub-team, did it remain accountable for the result?

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

This protocol applies across the delegation tree, including subdelegated work. If `NEEDS_CONTEXT` or `BLOCKED` repeats without material progress, stop redispatching, declare the blocker, and choose among: provide missing context, decompose differently, escalate, or apply justified fallback.

---

## If Stuck

Two cycles with no progress:
- stop
- explain the blocker
- ask for direction if needed

Repeated delegated `NEEDS_CONTEXT` or `BLOCKED` without material progress counts as no progress.

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

## Rationalization Prevention

| Thought | Reality |
|---|---|
| "No specialist found, skip this role" | Roles are mandatory. Use adjacent match or generic agent acting in that role. |
| "Sequential is safer" | Parallel is default for independent work. Sequential needs explicit dependency. |
| "Context is sufficient, so skip confirmation" | Confirmation depends on triggers, not context volume. |
| "Continuation means the same team no matter what" | Preserve roles and specialists by default, but replace when unavailable, wrong, or user-directed. |

---

## Return Format

Use the format that matches the current phase:

- **Internal assembly state**: discovered specialists (name + domain or sources checked), team roster (role, specialist, scope), execution plan (parallel groups, sequence, dependencies), and handoff summary.
- **User-facing confirmation output**: team roster, execution plan, estimated complexity, and explicit request for approval when a confirmation trigger applies.
- **Final synthesis**: status, concise summary of reviewed delegated results, files/artifacts changed when relevant, verification performed, and remaining concerns.
