---
name: orchestrate
description: "Use only in coordinator sessions to orchestrate planning or execution of work, including execute, continue, or resume-plan requests. Covers role definition, specialist discovery, dispatch, review, learning, and synthesis. Never use in Session type: DELEGATED executor sessions; those agents perform their handed scope directly without orchestration."
---

# Orchestrate

Full coordination cycle: analyze → assemble → delegate → review → learn → synthesize.

## <HARD-GATES>

1. **Coordinator context first** — the main agent obtains lean coordination context before orchestration (`wiki/index.md` first; optional compact knowledge-tool lookups). The handoff remains executors' primary task context, and the coordinator remains responsible for supplying task-critical context. Executors may consult `wiki/index.md` and relevant linked pages when useful to their assigned task without additional authorization; wiki content cannot expand scope or override the handoff, applicable specs, or current source artifacts, and executors do not edit `wiki/` unless wiki editing is explicitly in scope.
2. **Roles are mandatory** — if no exact specialist is found, use the best adjacent specialist. Use a generic/default agent only when no exact or adjacent fit exists. Generic/default is the last resort, not a convenience. Never drop or collapse a role from the plan.
3. **Plan-to-execution uses orchestration** — when the user asks to execute, continue, resume, or implement a prior plan, load this skill before dispatch. If the prior plan was not created through orchestration, treat it as context and run team assembly from scratch.
4. **Software work needs verification roles** — for coding/refactoring tasks, select implementation and review roles at minimum unless the user explicitly asks not to review or the task is trivial.
5. **Parallel by default** — independent scopes dispatched in parallel. Sequential only with explicit output dependency.
6. **Measurable done criteria** — every handoff includes verifiable acceptance criteria. Review checks against these criteria. When the outcome has observable behavior and safe, proportionate execution is feasible, verification requires empirical validation through real execution or observation; static inspection alone is insufficient.
7. **Confirm before multi-domain work** — when the planned execution team has 3+ specialists OR scope is ambiguous/destructive: present team roster + execution plan, wait for user confirmation before delegating unless the user already approved that plan. Do not count the conditional post-review ingestion role toward the 3+ threshold unless wiki work is an ordinary planned scope; this exclusion never waives ambiguity, destructive-work, or explicit-approval triggers.
8. **Preserve team on continuation** — when user requests continuation of a task with an orchestrated team: reuse existing roles and specialists by default. Replace only when a specialist is unavailable, clearly wrong for the role, or the user changed direction.
9. **Dispatch rationale and persona required** - In the coordinator roster, record each role's selected agent, match type (exact, adjacent, or fallback), and match rationale. Keep that metadata out of the handoff. For adjacent or generic/fallback matches, include nonempty `Act as: <expected task persona>`; omit it for exact matches.
10. **Spec readiness before implementation** — applies only when a named change/spec path is in scope or an active `specs/changes/<id>/` is clearly in scope for the request; otherwise SDD is N/A and skip this gate. If in scope and `specs/changes/<id>/tasks.md` is missing, do not start implementation handoffs — load `spec-builder` and run `plan`. Once tasks exist, load `spec-builder` and run its mandatory `analyze`; do not dispatch implementation until it passes. Rerun `analyze` before further implementation dispatch whenever active proposal, spec, tasks, or design artifacts materially change. Every in-scope implementation handoff MUST include `Spec ref: specs/changes/<id>/`.
11. **Post-review wiki evaluation** — after domain-appropriate review/verification and before the final response, the coordinator loads `wiki` and evaluates every task. Evaluation is mandatory; wiki maintenance and ingestion dispatch are optional and conditional. Open one consolidated serialized ingestion stream owned by the Wiki Ingestion Specialist role only when adding, revising, or removing content would materially improve durable workspace knowledge after accounting for compact organization and future context cost. Low-value, ambiguous, redundant, transient, or already-captured information does not qualify; a completed workflow requires no wiki write.

## Phase 1: Analyze Request

Assemble a professional team for the job:

- What domains are involved (engineering, design, testing, marketing, etc.)?
- What platforms, tools, or channels are mentioned?
- What phases does the work go through (planning → implementation → review → testing)?
- Classify complexity: single-domain, multi-domain, or cross-functional.

**Continuation requests:** if a team was already composed through orchestration, preserve existing roles and specialists by default; add roles for new domains, replace a specialist only when unavailable, clearly wrong for the role, or the user changed direction. If the prior plan was not orchestrated, treat it as context and compose roles from scratch.

## Phase 2: Define Roles

Map each domain + phase to a specialist role; apply the templates below for common patterns. For multi-domain work, ensure each domain has representation; each phase needing distinct expertise needs a responsible role. For coding/refactoring, define at least an implementation role and a review role unless the user opts out of review or the task is trivial.

Role preservation means preserving separate role *scopes*, not just labels. Plan one handoff per role/scope; do not merge roles.

## Phase 3: Discover Specialists

Before selecting, discover what specialists exist in the current environment: use the dispatch interface, available agent descriptions, and platform-exposed identifiers. If config/file inspection is needed but the coordinator may not read it directly, delegate that discovery as a handoff. Do not assume the pool is empty; do not skip to a generic/default agent.

**Record coordinator-internal assembly output**: discovered specialists (name + domain, or sources checked if none), and for each role the selected agent plus exact/adjacent/fallback rationale. These records are assembly output, not handoff content.

**Matching rules:**

- **Semantic match**: domain + work-type, NOT tech stack. A "Frontend Developer" covers React, Vue, or any stack.
- **Adjacent match** acceptable when exact unavailable: the specialist directly overlaps the role in domain (e.g., backend developer for a database task) or work type/phase. A connection needing more than one inferential step is not adjacent.
- **Select the best discovered fit**: dispatch each role to the best exact or adjacent specialist found. Never use generic/default when an exact or adjacent specialist is available.
- **Generic/default fallback is last resort**: use it, acting in the planned role, only when no exact or adjacent fit exists or remains — record that rationale only on the coordinator-internal roster, not in the handoff body.
- **Generic/default still has a role**: never dispatch an unscoped generalist. Assign the generic/default agent to the defined role and scope.
- **Same generic/default, separate scopes**: if generic/default fallback covers multiple roles, dispatch separate role-scoped handoffs. Do not combine roles just because the agent type is the same.
- If the user specified agents, incorporate them and apply semantic matching for the remaining roles.

**Role preservation:** roles defined in Phase 2 are mandatory. No exact specialist → best adjacent; no adjacent → generic/default acting in that role — but the role (reviewer, tester, architect) stays in the plan and the handoff instructs the generic/default agent to act in it. "No specialist found" never justifies merging distinct domains or phases into one broad handoff.

## Phase 4: Plan Execution

- Identify dependencies between scopes
- Select coordination pattern (see below)
- Parallel groups: scopes with no integration deps
- Sequential: output of one feeds another
- Review always after parallel batches

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

**When:** task fits cleanly in one domain and a specialist or adjacent specialist is available.  
**How:** one selected specialist or adjacent specialist, structured handoff. Generic/default only under the fallback rule with justification.  
**Example:** write a chapter, fix a specific bug.

## Team Templates

Starting points, not prescriptions. Adapt roles, add or remove specialists based on the actual request — a small UI fix needs one specialist; a full product launch may need 10+. The specialist names below are examples: match by equivalent role/domain, not literal name, and never delegate to a name that isn't actually available.

### Software Development

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | UX/Design | UX Researcher, UI Designer |
| Planning | Architecture | Software Architect, Backend Architect |
| Execution | Frontend | Frontend Developer |
| Execution | Backend | Backend Architect, Senior Developer |
| Verification | Review | Code Reviewer |
| Verification | Testing | Reality Checker, API Tester |

Coordination: Parallel Kickoff → Merge → Review.

### Bug Fix / Incident

| Phase | Role | Specialist Match |
|---|---|---|
| Investigation | Debug | Incident Response Commander |
| Fix | Implementation | domain-appropriate developer |
| Verification | Review | Code Reviewer |
| Verification | Testing | Reality Checker |

Coordination: Sequential with Quality Gates.

### Marketing Campaign

| Phase | Role | Specialist Match |
|---|---|---|
| Strategy | Planning | Growth Hacker, Product Manager |
| Execution | Content | Content Creator, platform specialists |
| Verification | Analytics | Analytics Reporter |

Coordination: Parallel Kickoff → Merge → Review.

### Product Discovery

| Phase | Role | Specialist Match |
|---|---|---|
| All parallel | Market | Trend Researcher |
| All parallel | Technical | Backend Architect, Software Architect |
| All parallel | Brand | Brand Guardian |
| All parallel | Growth | Growth Hacker |
| All parallel | UX | UX Researcher |
| All parallel | Support | Support Responder |
| Synthesis | Coordination | Project Shepherd |

Coordination: Full Parallel Discovery.

### Content / Documentation

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | Strategy | Content Creator, Product Manager |
| Execution | Writing | Technical Writer, Content Creator |
| Verification | Review | Code Reviewer, Reality Checker |

Coordination: Sequential with Quality Gates.

### Wiki Setup / Creation

| Phase | Role | Specialist Match |
|---|---|---|
| Discovery | Workspace Research / Architecture Analysis | Research Assistant, Software Architect, Backend Architect |
| Execution | Technical Writing / Documentation | Technical Writer, Content Creator |
| Verification | Review / Consistency | Reality Checker, Code Reviewer |

Coordination: Sequential with Quality Gates. Review/Consistency is required when broad or persistent docs are created. If no wiki-specific specialist exists, do not collapse research and writing into one generalist; use separate fallback handoffs for each role.

## Pre-Dispatch Verification

Before composing each handoff:
- Confirm the target agent appears in Phase 3's discovered specialists list as exact or adjacent (or is justified fallback).
- Verify the roster record and conditional `Act as:` field against hard-gate 9.
- Verify the agent name matches the exact format exposed by the dispatch interface (case, separators, spelling). Discovery may surface an agent like `software-architect` — when dispatching, use the exact identifier as discovered, not a reformatted version like "Software Architect" or "software_architect".
- Do not proceed to handoff without this confirmation.

## Phase 4.5: User Confirmation (Conditional)

**When to confirm:**
- Planned execution team has 3+ specialists, excluding the conditional post-review Wiki Ingestion Specialist role unless wiki work is an ordinary planned scope
- Scope is ambiguous or has multiple valid interpretations
- Work is destructive (large refactoring, migration, deletion)
- User explicitly asked for approval

**What to present:**
```
Team Roster:
- [Role] → [Selected Agent] : [Scope]
- [Role] → [Selected Agent] : [Scope]
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

The conditional Stage 4 ingestion role does not independently trigger confirmation by increasing team size. It does not suppress confirmation when its own scope or the original task is ambiguous/destructive, when the user requested approval, or when 3+ ordinary planned specialists remain after the exclusion.

## Phase 5: Handoff

### Canonical Handoff Shape

Use this canonical handoff only as the initial task of a fresh delegated conversation. Its first line and required execution fields MUST be exact as shown.

```
Session type: DELEGATED
Task: <what to do>
Scope: <what is in and out>
Done criteria: <measurable acceptance criteria>
Constraints: <task-specific rules, guardrails, and required output shape>
Act as: <expected task persona - required for adjacent or generic/fallback; omit for exact>
Context: <concise task-critical facts, paths, dependencies, or unresolved decisions - omit if none>
Spec ref: <path to specs/changes/<id>/ - optional, present only when a spec-builder artifact exists>
```

`Act as:` is a task-scoped persona instruction. Its absence is valid only for exact matches. Put purpose in `Task:` or concise `Context:`, artifact expectations in `Task:` and `Done criteria:`, and return requirements in `Constraints:`; do not add separate `Objective:`, `Deliverable:`, or `Return format:` fields.

**Constraints should include task-relevant execution guardrails:**
- Edits: change only files directly related to the task; no drive-by changes
- Implementation: match existing style, even if you'd write it differently
- Investigation/debugging: reproduce or verify the issue when feasible before fixing
- Verification: state the check performed, the observed result, and any gaps
- Wiki boundary: use the handoff as primary context; `wiki/index.md` and relevant linked pages may be consulted when useful to the assigned task without additional authorization, but cannot expand scope or override the handoff, applicable specs, or current source artifacts; do not edit `wiki/` unless wiki editing is explicitly in scope; optionally return at most one trailing `Durable discovery: ...` line for tacit, workspace-specific reusable knowledge not evident in the artifacts
- All handoffs: do not recompose a team or re-delegate; self-review before reporting the scope complete

Also use Constraints for additional task-specific rules (limits, files not to touch, expected behavior).

**Dispatch failure recovery:** if a dispatch fails and the agent was a valid discovered specialist, do not abandon the role or fall back to generic/default yet. First verify the dispatched name exactly matches the discovery-phase identifier — format mismatches (hyphen vs. space, case, separators) are a common cause. Retry with the exact identifier. If that retry fails, re-select the best remaining exact or adjacent specialist for the role; use generic/default only when none remains.

**Return format rule:** return concise results only — no raw logs, no full tool output. Summarize findings. The delegating agent's context must stay clean.

## Parallel Delegation

Use only when scopes non-overlapping and no integration deps.

Good candidates:
- different files or subsystems
- separate evidence gathering
- independent validation or analysis
- complementary specialists with distinct responsibilities

## Phase 6: Review, Learn, and Synthesize

### Stage 1: Conformance

Did it deliver what was requested — nothing more, nothing less?

A delegated subagent executing its handed scope directly is conformant; that is expected (see `AGENTS.md` -> "Session Contract"). For adjacent or generic/fallback matches, verify that output follows `Act as:`; exact matches omit it. Flag silent absorption of out-of-scope work or uncontrolled subdelegation. Subagents escalate out-of-scope work to the coordinator for recomposition.

If `Spec ref:` is present in the handoff, verify conformity against the persisted spec (load `spec-builder` `verify`) in addition to the done criteria.

### Stage 2: Quality

Is it correct, maintainable, and usable for the current task? With multiple delegated outputs: compare against assigned scopes, resolve conflicts, and synthesize a single coherent result before returning upward. Do not pass through raw delegated output without review.

### Stage 3: Evidence

When a done criterion can be verified by exercising the deliverable or observing its effect—not merely by inspecting its content or implementation—and safe, proportionate execution is feasible, obtain delegated empirical evidence through real execution or observation; static inspection may support but does not replace it. Reuse an existing role when its scope and expertise fit. Add a separate verification role only when distinct expertise or independence is needed. `N/A`, `partial`, and `blocked` are evidence states, not statuses: `N/A` means no done criterion calls for empirical validation; `partial` means evidence was obtained for only some applicable criteria; `blocked` means an applicable check could not run. Use `DONE` when all done criteria are satisfied, `DONE_WITH_CONCERNS` for a non-blocking evidence gap, `NEEDS_CONTEXT` while specific, actionable information or access can reasonably be provided to unblock validation, and `BLOCKED` when the gap prevents completion and no actionable path to obtain context or access remains. Report `N/A`, `partial`, or `blocked` when applicable and explain every gap.

### Stage 4: Wiki Ingest Evaluation

After Stages 1–3, load `wiki` and run its mandatory ingest evaluation before final synthesis. Evaluate whether adding, revising, or removing wiki content would materially improve durable workspace knowledge after the reviewed deliverables, accounting for compact organization and future context cost. Evaluate the artifacts and outcomes even when no executor supplied a `Durable discovery:` line; that optional signal is only a pointer to tacit knowledge and its absence has no workflow meaning.

If the evaluation is positive, consolidate discoveries across all outputs into one serialized ingestion stream scoped only to the Wiki Ingestion Specialist role. This label defines a role profile, not a literal agent identifier: select the best discovered exact or adjacent specialist under Phase 3, and use generic/default fallback only when neither exists. Never dispatch parallel wiki writers. The owner classifies and deduplicates the knowledge, makes only qualifying add/update/remove edits, maintains navigation, runs consistency lint, and does not alter original deliverables; it may return without edits if closer inspection shows no material net improvement. Review the result before responding. Retry or correct a failed dispatch, non-complete status, or failed review within the same stream under the normal status protocol; the two-cycle stuck rule remains in force. Low-value, ambiguous, redundant, transient, or already-captured information must not be added. If the evaluation is negative, do not dispatch ingestion; no wiki write is required merely to complete orchestration.

Explicit wiki tasks and the multi-role **Wiki Setup / Creation** workflow still undergo evaluation, but skip a redundant post-task stream when their reviewed deliverables already captured all durable knowledge correctly. Post-task ingestion remains distinct from broad wiki construction.

## Status Protocol

Delegated agents report one of:

| Status | Meaning | Action |
|---|---|---|
| `DONE` | Completed, ready for review | Proceed to review |
| `DONE_WITH_CONCERNS` | Completed but flagged issues | Read concerns first |
| `NEEDS_CONTEXT` | Missing information | Re-dispatch with more context |
| `BLOCKED` | Cannot complete | Assess context, break task, or escalate |

This protocol applies across the delegation tree, including work the coordinator recomposed after a subagent escalated out-of-scope parts.

**If stuck** — two cycles with no progress (repeated `NEEDS_CONTEXT` or `BLOCKED` without material progress counts): stop redispatching, declare the blocker, and choose among: provide missing context, decompose differently, escalate (ask the user for direction), or apply justified fallback.

## Escalation Rules

- Subagents do not compose sub-teams or subdelegate.
- When handed scope is genuinely multi-domain and exceeds a subagent's role, the subagent escalates back to the coordinator (status `BLOCKED` or `DONE_WITH_CONCERNS`), flagging the out-of-domain part rather than executing or re-delegating it.
- The coordinator remains the sole integrator and recomposes the team from the top.
- The subagent stays accountable for delivering its in-role part; it escalates the out-of-domain part, not abandons it.
- Review escalated output before recomposing; avoid loops and ping-pong by resolving scope boundaries at the coordinator.
- Preserve explicit scope ownership: a subagent never absorbs out-of-scope work silently.
- Escalation is not a way to avoid synthesis or review responsibility — the subagent must still deliver and self-review its in-role part.

## Rationalization Prevention

| Thought | Reality |
|---|---|
| "This is too simple to delegate" / "It's faster if I just do it" | The One Rule has no size threshold. Simple work goes to one specialist. Breaking the operating mode for speed is not allowed. |
| "I already know the answer" / "I just need to peek at the code first" | Knowing ≠ executing. Lean knowledge lookups for coordination are fine; open-ended research and task execution stay with specialists. |
| "A team of one is pointless, so I'll do it" | A team of one means one delegated subagent selected through orchestration — not you. |
| "No specialist found, skip this role" | Roles are mandatory. Use the best adjacent specialist; use a generic/default agent acting in that role only when no exact or adjacent fit exists. |
| "Sequential is safer" | Parallel is default for independent work. Sequential needs explicit dependency. |
| "Context is sufficient, so skip confirmation" | Confirmation depends on triggers, not context volume. |
| "Continuation means the same team no matter what" | Preserve roles and specialists by default, but replace when unavailable, wrong, or user-directed. |
| "Generic is fine, no one will notice" | Every generic dispatch must be justified on the roster (coordinator-internal). A generic/default fallback is invalid when a discovered exact or adjacent fit for that role is available. |
| "Dispatch failed, agent must be unavailable" | First verify the agent name format matches the exact discovered identifier. Format mismatches (case, separators) are a common cause of failure — retry with the correct format before falling back. |

## Return Format

Use the format that matches the current phase:

- **Internal assembly state**: discovered specialists (name + domain or sources checked), team roster (role, selected agent, scope, exact/adjacent/fallback rationale), execution plan (parallel groups, sequence, dependencies), and handoff summary. The team roster's match-type rationale is the dispatch authorization (coordinator-internal).
- **User-facing confirmation output**: team roster, execution plan, estimated complexity, and explicit request for approval when a confirmation trigger applies.
- **Final synthesis**: status, concise summary of reviewed delegated results, files/artifacts changed when relevant, any verification evidence obtained (check and observed result), remaining verification gaps and their causes, the reason when empirical validation is `N/A`, the blocking condition for any check that could not run, and remaining concerns.
