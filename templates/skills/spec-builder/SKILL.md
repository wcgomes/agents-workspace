---
name: spec-builder
description: Use when the user wants durable upfront alignment on an outcome before execution, or works on an existing specs/changes/<id>/. Covers proposing, clarifying, planning, analyzing, verifying, evolving, and archiving specs/ proposals, outcome specs, and task plans. Typical cases are new features or outcomes, API/contract changes, migrations, security/privacy-sensitive work, and long-running work spanning multiple sessions or handoffs. Maintains spec artifacts only; does not dispatch implementation. Not for trivial fixes (as the boot policy defines them) or exploratory spikes.
---

# Spec-Builder

Durable outcome contracts: **WHAT/WHY**, not execution **HOW**.

- A change's pre-execution readiness check is `analyze`; its verification is `verify`.
- For any handoff carrying `Contract ref: specs/changes/<id>/`, the referenced change must pass `analyze` before implementation and review runs `verify`.

## Terms

- **Durable upfront alignment:** outcome agreed and recorded before execution, checkable after it.
- **Trivial fix:** as the boot policy defines it; without one, a single-file, reversible change with no behavior or contract change.
- **Spike:** exploratory work producing learning, not a deliverable.
- **Long-running:** spans multiple sessions or handoffs.
- **Material:** changes an observable outcome, guarantee, scope, or a decision other tasks depend on.

## Who runs actions

- Actions read and write artifacts under `specs/`. Whoever executes the spec work runs them; in a coordinated setup, the delegated executor.
- Gates are user decisions. Surface the recommendation or question to the user, directly or via whoever relays to them, and wait.

## <HARD-GATE> Confirm Before Creating or Migrating Specs

Never auto-create or auto-migrate specs. When work seems to need one, or legacy specs exist:
1. Assess — do the triggers or the legacy-migration rule apply?
2. RECOMMEND — tell the user why, plus the proposed change id or migration plan.
3. WAIT — do not run `propose`, migrate, or create any file under `specs/` until the user confirms.

Skip confirmation only when the user explicitly requests that spec or migration.

## When to use (triggers)

- New feature, deliverable, or outcome change needing alignment before execution
- API/contract change, migration, security/privacy-sensitive, cross-team, ambiguity-prone, or long-running work
- **NOT for:** trivial fixes or spikes

## Principles

> **Language:** English by default; another language only if requested or already used by workspace specs.

> **Prose:** Single-line paragraphs; no hard-wrapping, preambles, or filler.

- **Spec = outcome:** deliverables, acceptance conditions, constraints, scenarios. Implementation detail (names, libraries, steps) goes in `tasks.md`/`design.md`.
- **WHAT/HOW split test:** "If execution can change without changing the visible outcome, it likely does not belong in the spec."
- **Scenarios:** testable acceptance conditions for happy path and edge cases. Software: Given/When/Then. Non-software: one line (e.g., "X delivered and stakeholder Y approves").
- **RFC 2119** keywords (`MUST`/`SHOULD`/`MAY`) signal requirement strength.
- **`[NEEDS CLARIFICATION: ...]` markers are MANDATORY** when ambiguous — never guess. Resolve every marker before `plan`.
- **No speculative features** ("might need").
- **Fluid, not waterfall** — see "Evolving a spec mid-work".

## Structure

```
specs/
├── <domain>.md                   # realized spec: archived/merged contract; updated only on archive
└── changes/
    ├── <id>/
    │   ├── proposal.md           # bounded intent/alignment record + concise decision index
    │   ├── spec.md               # DELTA: ## ADDED/MODIFIED/REMOVED Requirements + Scenarios
    │   ├── tasks.md              # derived checklist (the executable "how") for implementation handoffs
    │   └── design.md             # optional expanded design; only under the overflow rule
    └── archive/<YYYYMMDD>-<id>/  # archived, immutable change bundle
```

**Source spec format:** `# <Domain> Specification` / `## Purpose` / `## Requirements` / `### Requirement: <name>` / `#### Scenario: <name>`. One file per domain (feature area, work stream, or bounded context).

**Domain id:** flat kebab-case matching `[a-z0-9]+(?:-[a-z0-9]+)*` (e.g., `order-fulfillment`). No `/` or nested paths. `changes` is reserved.

**Change id:** short kebab, e.g. `add-auth-rate-limit`.

**Required change artifacts:** `proposal.md`, `spec.md`, `tasks.md`. `design.md` is conditional.

**Routing:**
- `proposal.md`: intent, scope, non-goals, approach, clarifications, decision index (conclusion + short rationale; links to `design.md`).
- `spec.md`: normative observable requirements, guarantees, constraints, acceptance scenarios. Guarantees MUST stay here.
- `tasks.md`: dependency order, paths, implementation actions, validation checkpoints.
- `design.md`: non-normative overflow — rationale, alternatives/trade-offs, flows, substantial migration/rollback/security detail.

**Design overflow rule:**
- Create `design.md` only if a material decision cannot stay clear as a short proposal decision plus tasks without overload or duplication.
- Evidence: needed alternatives/trade-offs, interacting multi-step flow, substantial migration/rollback/security reasoning. Category alone never triggers it.
- Never move normative guarantees out of `spec.md` to justify it.

**Legacy migration:** applies when any `specs/<legacy-domain>/spec.md` exists. Requires user confirmation (HARD-GATE). Once confirmed, before the next action, migrate all sources atomically:
- Inventory sources, assign unique valid Domain ids, preflight collisions.
- Explicitly merge differences with existing targets; never overwrite.
- Write/move flat files, update references, remove only empty legacy directories.
- Resume only when no legacy source remains; never keep dual sources of truth.

## State lifecycle

- Location alone determines **active** (`changes/<id>/`) vs **archived/immutable** (`changes/archive/<YYYYMMDD>-<id>/`); no status field.
- Work-in-progress sub-states follow completed actions, not location.

| State | Trigger | Artifacts present | Source spec `specs/<domain>.md` |
|---|---|---|---|
| Draft | `propose` done; `clarify` resolves ambiguity before planning | `proposal.md` + `spec.md` (delta), plus `design.md` only when the overflow rule is met | May not exist yet (created on first archive for the domain) |
| Planned | `plan` done | + required `tasks.md`; conditional `design.md` remains in sync | Unchanged |
| Ready | `analyze` passed | Cross-artifact readiness confirmed | Unchanged |
| In-progress | execution underway | Unchanged; `tasks.md` checklist being completed | Unchanged |
| Verified | `verify` passed | Unchanged; awaiting archive confirmation (HARD-GATE) | Unchanged |
| Archived | `archive` done | Delta merged into source spec; `changes/<id>/` moved to `changes/archive/<YYYYMMDD>-<id>/` | Updated (created if domain is new) |

**Live contract** = realized `specs/<domain>.md` (if any) **plus all active** `changes/<id>/spec.md` deltas, excluding `changes/archive/`.
- Read them together; the realized spec alone never represents work in progress.
- A domain's first `archive` creates its source spec; until then, its contract exists only in active deltas.
- Move a change under `archive/` **only** on `archive`.

## Actions

### `propose`
Prerequisite: user confirmed spec creation (HARD-GATE). If not confirmed, RECOMMEND and wait.

- Scan top-level `specs/changes/` (excluding archive) for active same-domain or overlapping work.
- If found, refine it in place unless scope expands (see Evolving). Otherwise create a new change.
- Descriptive project knowledge lives outside specs. If available, compare its facts against the relevant live contract (realized source plus active same-domain or overlapping deltas).
- Flag every conflict. Never silently prefer a source, expand scope, or copy the contract into descriptive knowledge.
- Create `changes/<id>/proposal.md` + delta `spec.md`; add `design.md` only when the overflow rule is met. Keep the proposal bounded with a short decision index.
- **Output:** change folder (proposal, delta spec, conditional design).
- **Handoff:** none yet — awaits `plan`.

### `clarify`
- Review proposal, spec, live contract, and conditional design for ambiguity.
- Resolve every `[NEEDS CLARIFICATION]` with the user. Record material Q&A in proposal Clarifications; update decisions, spec, and design.
- Reapply the overflow rule when answers change complexity.
- **Output:** **zero unresolved markers** before `plan`; no synthetic Q&A.
- **Handoff:** none — feeds `plan`.

### `plan`
- Derive `tasks.md` from the clarified spec and proposal decisions, using `design.md` when present.
- Dependency-ordered; mark parallelizable items `[P]`; one file path per task; checkpoint validation per phase.
- **Software:** order tasks test-first (write test, confirm failing, then implement).
- Reapply the overflow rule; planning alone never justifies creating `design.md`.
- **Handoff preparation:** produce handoff inputs; execution waits for `analyze`. Every in-scope implementation handoff MUST include `Contract ref: specs/changes/<id>/`.
- **Output:** `tasks.md` with the template's Readiness line.

### `analyze`
Mandatory pre-execution gate. Check:
- Normative decisions/guarantees live in `spec.md` and have task coverage.
- Internal design decisions align with executable tasks (and `design.md` when present); they are not forced into normative requirements.
- Every requirement/scenario has task coverage. Tasks neither omit outcomes nor add scope.
- No contradictions, stale rationale, or clarification markers remain.
- **Output:** readiness status plus issues corrected or still blocking.
- **Handoff:** implementation may start from `tasks.md` only after a pass.

### `verify`
Review execution against the **PERSISTED spec**, not just done criteria.
- **Post-execution `converge`:** drift check of work output against proposal decisions, spec, tasks, and design when present.
- Treat the spec as authoritative when non-normative design wording conflicts.
- **Software:** confirm each spec scenario maps to a passing test.
- **Output:** conformity status + drift list.
- **Handoff:** runs when reviewing implementations carrying `Contract ref: specs/changes/<id>/`, alongside done criteria.

### `archive`
Prerequisite: user confirmed archive (HARD-GATE). If verification passed but there is no confirmation, ASK and wait.
- Merge delta sections into `specs/<domain>.md`: `ADDED` appended, `MODIFIED` replaced, `REMOVED` deleted.
- Move `changes/<id>/` → `changes/archive/<YYYYMMDD>-<id>/`.
- Report all added, modified, and removed requirements and significant decisions to the requester.
- Do not edit descriptive project knowledge or request a descriptive copy of the contract. Optionally report tacit knowledge not captured in the spec.
- **Output:** updated `specs/<domain>.md`.

## Evolving a spec mid-work

Keep proposal, spec, tasks, and conditional design synchronized as work uncovers changes.

**Decision rule — update the current change vs. start a new one:**
- **Refines the current change** (defect, clarification, or improvement within scope): edit `changes/<id>/spec.md` in place. Update the decision index and `tasks.md`. Create, update, or remove `design.md` as the overflow rule requires.
- **Expands scope** (new requirement, other bounded context, behavior outside this change): start a new `changes/<new-id>/`.

Never edit archived deltas; new needs require a new active change.

**Small follow-ups:** small follow-ups to an active change stay in it. After archive, open a new change only for work that changes realized requirements; other small work follows the normal path.

**Loop:** artifacts ↔ `analyze` ↔ execution ↔ `verify`.
- When behavior or a material decision changes, update the routed artifacts and rerun `analyze` before further implementation — even for small adjustments.
- `verify` (`converge`) catches remaining drift, including stale conditional design.
- Iterate until verification passes, then request archive (HARD-GATE below).

## <HARD-GATE> Confirm Before Archiving

Never auto-archive. After execution and verification pass:
1. Report — execution done, verification passed, delivered vs. spec.
2. ASK — "Execution and verification complete. Archive the spec?" (or equivalent).
3. WAIT — do not run `archive` or move `changes/<id>/` to `changes/archive/` until the user confirms.

If the user requests further changes instead, return to the loop above — do not archive.

## Templates

Read `references/templates.md` **when creating any artifact**.

Never defer spec updates or put execution detail in the outcome contract.
