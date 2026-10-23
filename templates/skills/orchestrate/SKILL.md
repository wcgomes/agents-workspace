---
name: orchestrate
description: "Use only as coordinator for planning/execution, including execute/continue/resume-plan requests: roles, specialist discovery, dispatch, review, learning, synthesis. Never use in Session type: DELEGATED; execute the handed scope directly."
---

# Orchestrate

Full coordination cycle: analyze → assemble → delegate → review → learn → synthesize.

## <HARD-GATES>

1. **Context first:** obtain lean coordination context before orchestration: when the boot policy's Wiki gate applies, load `wiki-query` and consult first; compact knowledge-tool lookups are optional. Coordinator supplies task-critical handoff context. Executor wiki boundaries appear under Phase 5.
2. **Mandatory roles:** never drop or merge planned roles; choose best exact → best adjacent → generic/default only if neither exists (Phase 3).
3. **Prior plans:** load this skill before execute/continue/resume/implement dispatch. Preserve an orchestrated team; otherwise treat the prior plan as context and assemble from scratch.
4. **Software verification:** coding/refactoring needs implementation and review roles unless trivial or the user explicitly opts out of review.
5. **Parallel default:** dispatch independent scopes in parallel; sequence only for explicit output dependencies.
6. **Acceptance:** every handoff needs verifiable done criteria; review against them. Observable behavior requires real execution/observation when safe and proportionate; static inspection alone is insufficient.
7. **Confirmation:** apply Phase 4.5 before dispatch; context sufficiency never waives its triggers.
8. **Continuation:** reuse roles/specialists by default; replace only if unavailable, clearly wrong for the role, or user direction changed. Add roles for new domains.
9. **Rationale/persona:** internal roster records role, selected agent, exact/adjacent/fallback match and rationale, never in the handoff. Nonempty `Act as: <expected task persona>` is required for adjacent/fallback, omitted for exact.
10. **Spec readiness:** only for an in-scope named change/spec path or clearly applicable active `specs/changes/<id>/`; otherwise SDD is N/A. Missing `tasks.md`: load `spec-builder`, run `plan`, and withhold implementation. Once tasks exist, load `spec-builder` and run mandatory `analyze`; dispatch only after it passes. Rerun before further implementation whenever active proposal/spec/tasks/design materially changes. Every in-scope implementation handoff MUST include `Spec ref: specs/changes/<id>/`.
11. **Wiki evaluation:** when boot-policy Wiki-gated or explicitly doing wiki work, after domain review/verification and before final response load `wiki` and evaluate. Stage 4 governs conditional ingestion; evaluation requires no write.

## Phase 1: Analyze Request

Identify domains, platforms/tools/channels, and phases (planning → implementation → review → testing). Classify complexity: single-domain, multi-domain, or cross-functional. For continuations apply gates 3 and 8.

## Phase 2: Define Roles

Represent each domain and each phase needing distinct expertise with a responsible role (templates below; software exception in gate 4). Preserve separate **scopes**, not just labels: one handoff per role/scope, never merged.

## Phase 3: Discover Specialists

Discover **before selection**, using only agent names/descriptions already listed in this session for spawning. Never inspect agent directories/configs, directly or by delegation; never assume an empty pool or skip discovery.

Record internally: discovered names + domains (or sources checked if none), and each role's selected agent with exact/adjacent/fallback rationale. This authorizes dispatch; it is not handoff content.

- Match semantically by domain + work type, not stack (Frontend Developer covers React/Vue/etc.).
- If no exact fit, choose the best adjacent: direct overlap in domain or work type/phase; more than one inferential step is not adjacent.
- Generic/default is last resort only when no exact/adjacent fit exists or remains. Assign the planned persona and scope; never an unscoped generalist.
- Preserve every role, even when several use the same fallback agent: separate handoffs, never merged domains/phases.
- Incorporate user-specified agents; match remaining roles semantically.

## Phase 4: Plan Execution

Identify dependencies and choose a pattern below: parallel groups have no integration dependencies; sequence when one output feeds another. Plan targeted checks, address risks early, verify integration/first usable result when relevant, and review each phase or parallel batch. Final review checks evidence/coverage, not automatic reruns (Phase 6, Stage 3).

## Coordination Patterns

| Pattern | Use / flow |
|---|---|
| Full Parallel Discovery | Independent perspectives on one topic → synthesize (e.g., 8-domain product discovery). |
| Parallel Kickoff → Merge → Review | Independent work feeds integrator → review (content + design → frontend → growth review). |
| Sequential with Quality Gates | Output dependencies; checkpoint each handoff (research → architecture → implementation → testing). |
| Single Agent Structured | One-domain task → one specialist/adjacent with structured handoff (chapter, specific bug); justified generic only under fallback rule. |

## Team Templates

Adapt these starting points to the request (small UI fix: one specialist; product launch: possibly 10+). Names are illustrative: match equivalent roles/domains and dispatch only available identifiers.

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

Before each handoff, confirm discovered exact/adjacent fit or justified fallback, gate-9 roster/persona compliance, and exact spawn identifier (case, separators, spelling: `software-architect`, not "Software Architect"/`software_architect`). Do not dispatch until confirmed.

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

The Stage 4 exclusion waives only its team-size contribution, never ambiguity/destruction (including ingestion's own scope), explicit approval, or 3+ ordinary planned specialists.

## Phase 5: Handoff

### Canonical Handoff Shape

Use only as a fresh delegated conversation's initial task. First line and required execution fields MUST be exact:

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

`Act as:` is task-scoped; omit only for exact matches. Route purpose to `Task:`/`Context:`, artifacts to `Task:`/`Done criteria:`, returns to `Constraints:`. Never add `Objective:`, `Deliverable:`, or `Return format:` fields.

**Constraints should include task-relevant execution guardrails:**
- Edits: change only files directly related to the task; no drive-by changes
- Implementation: match existing style, even if you'd write it differently
- Investigation/debugging: reproduce or verify the issue when feasible before fixing
- Verification: include planned checks and when to run them; require the executor to report checks performed, observed results, and gaps
- Wiki boundary: handoff is primary; `wiki-query` is allowed when useful to assigned work without further authorization. Wiki cannot expand scope or override handoff, applicable specs, or current source artifacts; edit `wiki/` only when explicitly in scope. Optional: at most one trailing `Durable discovery: ...` for tacit, workspace-specific reusable knowledge not evident in artifacts
- All handoffs: do not recompose a team or re-delegate; self-review before reporting the scope complete

Also use Constraints for additional task-specific rules (limits, files not to touch, expected behavior).

**Dispatch recovery:** for a failed valid specialist dispatch, verify and retry its exact discovered identifier before changing agents (case/separator errors are common). If retry fails, select the best remaining exact/adjacent; generic only if none remains. Never abandon the role.

**Returns:** summarize findings; no raw logs or full tool output in delegator context.

## Parallel Delegation

Use only when scopes non-overlapping and no integration deps.

Good candidates:
- different files or subsystems
- separate evidence gathering
- independent validation or analysis
- complementary specialists with distinct responsibilities

## Phase 6: Review, Learn, and Synthesize

### Stage 1: Conformance

Check requested scope, nothing more/less. Direct delegated execution is expected (`AGENTS.md` → Session Contract). Check adjacent/fallback output against `Act as:` (omitted for exact). Flag scope absorption/subdelegation; escalate out-of-scope work to coordinator. With `Spec ref:`, load `spec-builder` `verify` against the persisted spec **in addition** to done criteria.

### Stage 2: Quality

Check correctness, maintainability, and usability. Compare multiple outputs with assigned scopes, resolve conflicts, and synthesize before returning; never forward unreviewed raw output. Domain examples, not a universal checklist: research—source support; content—brief/audience/facts; data—reproducibility/interpretation; design—requirements/usability/visual quality/accessibility; code—conventions/maintainability/applicable lint, build, tests/performance where relevant.

### Stage 3: Evidence

If a criterion can be checked by exercising a deliverable/observing effects and execution is safe and proportionate, obtain delegated empirical evidence; inspection alone cannot replace it. Where feasible, verify in its use context (app/page flow, document render/export). Tie evidence to request/resources; report unavailable-tool limitations. Reuse a fitting role; add verification roles only for distinct expertise or independence.

Reuse evidence valid for the delivered state. Rerun affected checks after corrections, relevant changes, or failures; add evidence for gaps, uncertain impact, or justified independent confirmation—not just a changed agent/phase. Independent review need not repeat identical execution.

Evidence states are **not statuses**: `N/A` = no criterion needs empirical validation; `partial` = only some applicable criteria evidenced; `blocked` = applicable check could not run. Report applicable states and explain every gap. Status: `DONE` if all criteria satisfied; `DONE_WITH_CONCERNS` for non-blocking gaps; `NEEDS_CONTEXT` if specific actionable information/access can reasonably unblock validation; `BLOCKED` if completion is prevented and no actionable context/access path remains.

### Stage 4: Wiki Ingest Evaluation

If gate 11 is inapplicable, skip without loading `wiki`. Otherwise load it after Stages 1–3, before final synthesis. Evaluate artifacts/outcomes even without `Durable discovery:` (optional tacit-knowledge pointer, not a workflow signal): would adding/revising/removing content materially improve durable knowledge after compact organization and future context cost?

Positive: consolidate all outputs into **one serialized ingestion stream**, owned solely by the Wiki Ingestion Specialist **role**, not a literal agent name. Select under Phase 3: best exact/adjacent, generic only if neither. Never parallel wiki writers. Owner classifies/deduplicates, makes qualifying add/update/remove edits, maintains navigation, runs consistency lint, and leaves original deliverables unchanged. No edits is valid if closer inspection finds no material net improvement. Review before response; correct failed dispatch, non-complete status, or failed review in the same stream under the status protocol/two-cycle stuck rule.

Never add low-value, ambiguous, redundant, transient, or already-captured information. Negative evaluation: no ingestion dispatch; completion never requires a write. Explicit wiki tasks and multi-role **Wiki Setup / Creation** still undergo evaluation, but skip redundant ingestion if reviewed deliverables already captured durable knowledge correctly. Post-task ingestion does not replace broad construction.

## Status Protocol

Delegated agents report one of:

| Status | Meaning | Action |
|---|---|---|
| `DONE` | Completed, ready for review | Proceed to review |
| `DONE_WITH_CONCERNS` | Completed but flagged issues | Read concerns first |
| `NEEDS_CONTEXT` | Missing information | Re-dispatch with more context |
| `BLOCKED` | Cannot complete | Assess context, break task, or escalate |

This protocol applies across the delegation tree, including work the coordinator recomposed after a subagent escalated out-of-scope parts.

**Stuck:** after two cycles without material progress (including repeated `NEEDS_CONTEXT`/`BLOCKED`), stop redispatching and declare the blocker; supply context, decompose differently, ask the user, or apply justified fallback.

## Escalation Rules

- No sub-teams/subdelegation or silent scope absorption. Deliver, synthesize, and self-review the in-role part; flag excessive multi-domain scope to the coordinator as `BLOCKED`/`DONE_WITH_CONCERNS`, never execute/redelegate it.
- Coordinator is sole integrator: review escalated output before recomposing from the top; resolve ownership/boundaries to prevent loops. Escalation does not abandon the out-of-domain part or waive in-role accountability.

## Operating boundary

Size, speed, or knowing the answer never waives delegation. A team of one means one **subagent**, not the coordinator. Lean coordination lookups are allowed; open-ended research and task execution remain delegated.

## Return Format

Use the format that matches the current phase:

- **Internal assembly state**: discovered specialists (name + domain or sources checked), team roster (role, selected agent, scope, exact/adjacent/fallback rationale), execution plan (parallel groups, sequence, dependencies), and handoff summary. The team roster's match-type rationale is the dispatch authorization (coordinator-internal).
- **User-facing confirmation output**: team roster, execution plan, estimated complexity, and explicit request for approval when a confirmation trigger applies.
- **Final synthesis**: status, concise summary of reviewed delegated results, files/artifacts changed when relevant, any verification evidence obtained (check and observed result), remaining verification gaps and their causes, the reason when empirical validation is `N/A`, the blocking condition for any check that could not run, and remaining concerns.
