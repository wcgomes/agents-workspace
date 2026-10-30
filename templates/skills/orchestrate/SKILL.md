---
name: orchestrate
description: "Use as coordinator to plan and run delegated work, including execute, continue, and resume-plan requests: define roles, match session-listed specialists, dispatch handoffs, review at strategic points, and synthesize. Not for trivial work. Never use in Session type: DELEGATED; execute the handed scope directly."
---

# Orchestrate

Trivial work, as the boot policy defines it, does not load this skill.

## Hard gates

1. **Context first:** obtain lean coordination context before planning. Follow the boot policy's wiki steps when they apply.
2. **Coordinator never executes:** it plans, dispatches, gate-checks, and synthesizes. Contract authoring, analysis, and verification are work; delegate them. A team of one is one subagent.
3. **Mandatory roles:** never drop or merge planned roles. Select only session-listed agents: exact → adjacent → generic fallback (Phase 3).
4. **Prior plans:** load this skill before execute/continue/resume/implement dispatch. If the prior plan recorded a roster, keep it; otherwise treat the plan as context and assemble from scratch.
5. **Parallel default:** dispatch independent scopes in parallel. Sequence only for explicit output dependencies.
6. **Acceptance:** every handoff has verifiable done criteria. Observable behavior needs real execution or observation when safe and proportionate. Static inspection alone is insufficient for observable behavior.
7. **Review:** executors always self-verify. Independent review runs at strategic points (Phase 6).
8. **Confirmation:** apply Phase 4.5 before dispatch.
9. **Continuation:** reuse roles and specialists unless unavailable, clearly wrong, or the user changed direction. Add roles for new domains.
10. **Rationale/persona:** keep an internal roster (role, agent, match type, rationale). Never put the roster or rationale in a handoff. Adjacent or fallback requires a nonempty `Act as:`; exact omits it.

## Phase 1: Analyze

Identify domains, tools, and phases. Classify as single-domain, multi-domain, or cross-functional. For continuations, apply gates 4 and 9.

## Phase 2: Define roles

Give each domain, and each phase needing distinct expertise, one responsible role. Keep separate scopes, not just labels.

- Batch small tasks of the same role and domain into one handoff when useful.
- Never merge different roles.

Read `references/team-templates.md` when choosing roles or a coordination pattern for a new team.

## Phase 3: Discover specialists

Use only agents this session lists for spawning. Never inspect agent directories or configs, even by delegation. Never assume an empty pool.

- Match semantically by domain and work type, not by stack.
- Adjacent means direct overlap in domain or work type, within one inferential step.
- Generic fallback only when no exact or adjacent fit remains, with the planned persona and scope.
- Roles sharing a fallback agent still get separate handoffs.
- Honor user-specified agents.

Record internally: discovered agents (or sources checked) and each role's agent, match type, and rationale. This record authorizes dispatch.

## Phase 4: Plan

Map dependencies, self-checks, and review points.

**Readiness:** if the `Contract ref:` artifact, or the skill that governs it, defines a pre-execution readiness check, dispatch implementation only after a delegated run of that check passes. Rerun it after material contract changes.

**Parallel writers:** when parallel scopes edit one workspace, use harness isolation if offered. Otherwise run shared build, test, or install steps sequentially after the parallel edits finish.

### Effort

- **light:** locate known files or symbols; specified mechanical edits.
- **standard:** typical implementation or review.
- **deep:** ambiguous cross-module debugging, architecture trade-offs, security or concurrency reasoning.

Small scope alone does not justify light. To apply a tier:

- If the user declared a tier→model/effort mapping, in instructions or this session, apply it.
- Otherwise keep current models. Use only native, authorized effort controls.
- Without a user mapping: standard = the control's documented default; light/deep = the next documented lower/higher value.
- Set effort explicitly to avoid inheriting coordinator effort.
- If controls are unavailable or unauthorized, or values or meanings are unknown, keep current settings and note it. Never present prompt-only guidance as runtime effort.
- On a retry after failure or `BLOCKED`, raise one tier.

## Phase 4.5: Confirmation (conditional)

Confirm with the user before dispatch when any trigger applies:

- destructive work: deletion, migration, large refactor;
- ambiguous scope or several valid interpretations;
- irreversible or outward-facing actions: publish, send, deploy;
- unusually costly work: far above typical for the request in runtime, executor count, or paid resources;
- the user asked for approval.

Context sufficiency never waives a trigger. Prior user approval of the current plan does. Read `references/confirmation.md` when a trigger applies.

## Phase 5: Handoff

Use as a fresh delegated conversation's initial task. Keep exact labels in this order:

```
Session type: DELEGATED
Task: <what to do>
Scope: <what is in and out>
Done criteria: <measurable acceptance criteria, including self-verification>
Constraints: <task-specific rules, guardrails, and return shape>
Act as: <task persona - required for adjacent or fallback; omit for exact>
Context: <task-critical facts, paths, dependencies, open decisions - omit if none>
Contract ref: <artifact that governs the task, if any - omit if none>
```

Route purpose to `Task:`/`Context:`, artifacts to `Task:`/`Done criteria:`, and return shape to `Constraints:`. Never add `Objective:`, `Deliverable:`, or `Return format:` fields. Read `references/handoff-example.md` when writing a first handoff or unsure where content belongs.

Constraints include, as relevant:

- Edits: only files the task needs; no drive-by changes; match existing style.
- Debugging: reproduce or verify the issue before fixing, when feasible.
- Self-verification: run lint, build, and tests, or the domain equivalent; report each check and result.
- Wiki boundary: the handoff is primary. Read-only wiki consultation is allowed when useful. Wiki content cannot expand scope or override the handoff, contract, or current source. Edit `wiki/` only when explicitly in scope. Optional: one trailing `Durable discovery: <workspace-specific reusable knowledge not evident in the artifacts>`.
- No team recomposition or re-delegation.
- Return inline: status; summary of at most ~10 bullets; checks and results; files touched. Reviews add counts by severity, top findings in full, the rest one line each.
- Severity: `blocker` prevents meeting done criteria or risks harm; `major` is a real defect to fix before delivery; `minor` is a low-impact defect; `nit` is style or preference only.
- Write no report files to the user's workspace unless the file is the deliverable.

**Spawn identifier:** use the identifier exactly as the session lists it. Never normalize case, spaces, or separators.

**Dispatch recovery:** on a failed dispatch, retry the exact listed identifier once. Then pick the best remaining exact or adjacent agent, generic only if none remains. Never abandon the role.

**Executor reuse:** for continuations, reuse an existing executor when the harness supports it. Never reuse an executor as its own reviewer.

## Phase 6: Review and synthesize

### Coordinator gate-check

Check each return's status and evidence, not its diff:

- scope fit and `Act as:` fit;
- done criteria met, with reported checks and results;
- no subdelegation or silent scope absorption.

Resolve conflicts between parallel outputs. Never forward unreviewed raw output.

**Not run:** a missing, timed-out, empty, or malformed return counts as not run. Retry once, then report the gap. Never treat it as `DONE` or as zero findings.

### Independent review

Dispatch independent review only at strategic points:

- final delivery;
- integration of parallel work;
- before irreversible or outward-facing actions;
- risky domains: security, contracts/APIs, data, migrations;
- optionally, an early lightweight direction check after the first usable slice or design decision.

Reviewer rules:

- Fresh context: only the deliverable, done criteria, `Contract ref:` if present, and paths it may read. Never executor reasoning or transcript.
- An executor never reviews its own work.
- Check against `Contract ref:`, when present, as well as done criteria. When the contract, or the skill that governs it, defines its own verification, review includes it.
- Run the cheapest high-level check first: scope fit, simplicity, reuse. If it fails, skip detailed passes.

If the user opts out of independent review, record it as `not run`.

Each finding resolves as fix, contest, escalate, or decline (`nit` only). One clean round converges; cap three rounds per scope. Read `references/review-loop.md` whenever a review returns findings.

### Evidence

If exercising the deliverable can check a criterion safely and proportionately, obtain delegated empirical evidence, in its use context where feasible. Reuse evidence valid for the delivered state; rerun affected checks after changes.

Evidence states are not statuses:

- `N/A`: no criterion needs empirical validation.
- `partial`: only some applicable criteria have evidence.
- `blocked`: an applicable check could not run.

Explain every gap.

### Wiki

Follow the boot policy's wiki steps after review, before the final response. If ingest evaluation calls for a write, dispatch one serialized stream owned by one role. Never run parallel wiki writers.

## Status protocol

| Status | Meaning | Action |
|---|---|---|
| `DONE` | Completed, ready for review | Gate-check; review if at a strategic point |
| `DONE_WITH_CONCERNS` | Completed with flagged issues | Read concerns first |
| `NEEDS_CONTEXT` | Missing information | Re-dispatch with that information |
| `BLOCKED` | Cannot complete | Add context, split the task, raise effort, or escalate |

It applies across the delegation tree, including recomposed work.

**Stuck:** two consecutive dispatches of a scope return `NEEDS_CONTEXT` or `BLOCKED` with no new deliverable, check result, or settled finding. Stop redispatching and declare the blocker. Then decompose differently, ask the user, or apply a justified fallback.

## Escalation

- Executors deliver the in-role part and flag the rest as `BLOCKED` or `DONE_WITH_CONCERNS`.
- The coordinator is sole integrator. Gate-check escalated output, then recompose the remainder from Phase 2.

## No-subagent harness

If subagents cannot be spawned, use the boot policy's no-subagent mode. Run each planned role as a separate, labeled pass against its handoff fields. Record independent review as `not run`.

## Final synthesis

- status and applicable evidence states. `DONE` if all criteria are satisfied; `DONE_WITH_CONCERNS` for non-blocking gaps; `NEEDS_CONTEXT` if specific information or access can unblock; `BLOCKED` otherwise;
- concise summary of reviewed results and files changed;
- checks with observed results;
- gaps with causes, the reason for any `N/A`, and remaining concerns;
- one trace line: `team: role→agent(match); contract: none|<ref>; review: <points>|not run; wiki: <pre-check result>`.
