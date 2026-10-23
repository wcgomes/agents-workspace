---
name: spec-builder
description: Use to create/evolve/archive specs/ proposals, outcome specs, and task plans when durable upfront alignment is needed for new deliverables/outcomes, API/contracts, migrations, security/privacy, or long-running work. Not for trivial fixes, exploratory spikes, or sufficient handoff done criteria. orchestrate consumes artifacts via Spec ref.
---

# Spec-Builder

Durable outcome contracts: **WHAT/WHY**, not execution **HOW**. `orchestrate` consumes `Spec ref`.

## <HARD-GATE> Confirm Before Creating Specs

Never auto-create spec artifacts. When work appears to need a durable outcome contract:
1. Assess — does it match the "When to use" triggers below?
2. RECOMMEND — tell the user why a spec fits and the proposed change id.
3. WAIT — do not run `propose` or create any file under `specs/` until the user confirms.

Skip confirmation only when the user explicitly requests a spec.

## When to use (triggers)

- New deliverable or outcome change needing alignment before execution
- API/contract change, migration, security/privacy-sensitive work, or any long-running task where the outcome must be agreed upfront
- Cross-team or ambiguity-prone work
- **NOT for:** trivial fixes, spikes, or tasks that fit in one handoff's done criteria

## Principles

> **Language:** All spec artifacts default to English; another language only if explicitly requested or already used by workspace specs.

> **Prose:** Single-line paragraphs; no hard-wrapping, preambles, or filler.

- **Spec = outcome**: deliverables, acceptance conditions, constraints, scenarios. Implementation detail (class/function names, library choices, step-by-step execution) goes in `tasks.md`/`design.md`, never the spec.
- **What/HOW split test:** "If execution can change without changing the visible outcome, it likely does not belong in the spec."
- **Scenarios** are testable acceptance conditions covering happy path + edge cases. **Software:** use Given/When/Then. **Non-software:** use a one-line acceptance condition (e.g., "X delivered and stakeholder Y approves").
- **RFC 2119** keywords (`MUST`/`SHOULD`/`MAY`) signal requirement strength.
- **`[NEEDS CLARIFICATION: ...]` markers are MANDATORY** when ambiguous — never guess. Resolve every marker before `plan`.
- **No speculative features** ("might need"). Simplicity gate.
- **Fluid, not waterfall** — see "Evolving a spec mid-work" below.

## Structure

```
specs/
├── <domain>.md                   # realized spec: the archived/merged contract (updated only on archive; in-progress changes live in changes/<id>/)
└── changes/
    ├── <id>/
    │   ├── proposal.md           # bounded intent/alignment record + concise decision index
    │   ├── spec.md               # DELTA: ## ADDED/MODIFIED/REMOVED Requirements + Scenarios
    │   ├── tasks.md              # derived checklist (the executable "how"), consumed by orchestrate
    │   └── design.md             # optional expanded design; created only by the overflow rule below
    └── archive/<YYYYMMDD>-<id>/  # archived, immutable change bundle
```

**Source spec format:** `# <Domain> Specification` / `## Purpose` / `## Requirements` / `### Requirement: <name>` / `#### Scenario: <name>` (Given/When/Then for software; one-line acceptance condition for non-software). Organized by domain (feature area, work stream, or bounded context).

**Domain id:** flat kebab-case matching `[a-z0-9]+(?:-[a-z0-9]+)*` (for example, `order-fulfillment`). It MUST NOT contain `/` or create nested paths. `changes` is reserved and MUST NOT be used as a domain id.

**Change id:** short kebab, e.g. `add-auth-rate-limit`.

**Required change artifacts:** `proposal.md`, `spec.md`, and `tasks.md`. `design.md` is conditional, not a workflow mode or category requirement.

**Routing:**
- `proposal.md`: bounded intent, scope, non-goals, approach, clarifications, decision index (conclusion + short rationale; link expanded decisions to `design.md`).
- `spec.md`: normative observable requirements, guarantees, constraints, acceptance scenarios. Guarantees MUST stay here even if design explains implementation.
- `tasks.md`: dependency order, paths, implementation actions, validation checkpoints.
- `design.md`: non-normative overflow—expanded rationale, alternatives/trade-offs, diagrams/flows, substantial migration/rollback/security/cross-component detail.

**Design overflow rule:** create `design.md` only if a material decision cannot stay understandable/actionable as a short proposal decision + task instructions without overload or substantial duplication. Evidence: needed alternatives/trade-offs, interacting multi-step flow, substantial migration/rollback/security reasoning. Category alone (API, migration, cross-team, security) never triggers it. Omit when short entries suffice; never move normative guarantees out of `spec.md` to justify it.

**Legacy migration before the next action:** atomically migrate all `specs/<legacy-domain>/spec.md`. Inventory all sources, assign unique valid Domain ids, preflight collisions. Compare existing targets and explicitly merge differences; never overwrite. Write/move reconciled flat files, update all references, remove only empty legacy directories. Resume only when no legacy source remains; never retain dual sources of truth.

## State lifecycle

One lifecycle: location alone determines **active** (`changes/<id>/`) vs **archived/immutable** (`changes/archive/<YYYYMMDD>-<id>/`), with no status field. WIP sub-states are procedural, determined by completed actions, not location.

| State | Trigger | Artifacts present | Source spec `specs/<domain>.md` |
|---|---|---|---|
| Draft | `propose` done; `clarify` resolves ambiguity before planning | `proposal.md` + `spec.md` (delta), plus `design.md` only when the overflow rule is met | May not exist yet (created on first archive for the domain) |
| Planned | `plan` done | + required `tasks.md`; conditional `design.md` remains in sync | Unchanged |
| Ready | `analyze` passed | Cross-artifact readiness confirmed | Unchanged |
| In-progress | execution underway | Unchanged; `tasks.md` checklist being completed | Unchanged |
| Verified | `verify` passed | Unchanged; awaiting archive confirmation (HARD-GATE) | Unchanged |
| Archived | `archive` done | Delta merged into source spec; `changes/<id>/` moved to `changes/archive/<YYYYMMDD>-<id>/` | Updated (created if domain is new) |

**Live contract** = realized `specs/<domain>.md` (if any) **plus all active** `changes/<id>/spec.md` deltas, excluding `changes/archive/`. Read them together; realized alone never represents WIP. First `archive` creates the domain source; until then its contract exists only in active deltas. Move a change under `archive/` **only** on `archive`; top-level changes remain active/mutable.

## Actions

### `propose`
Prerequisite: user confirmed spec creation (see HARD-GATE). If not confirmed, RECOMMEND and wait — do not proceed.

Before proposing, scan top-level `specs/changes/` (exclude archive) for active same-domain/overlapping work. If found, refine it in place unless scope genuinely expands (see Evolving); otherwise create a new change.

Before drafting, when boot-policy Wiki-gated, load `wiki-query` and consult. Compare descriptive facts against realized source (if any) + every active same-domain/overlapping delta: the relevant prescriptive live contract. Flag every conflict; never silently prefer a source, expand scope, or dump the contract into wiki.

Create `changes/<id>/proposal.md` + delta `spec.md`; `design.md` only when overflow already warrants it. Keep proposal bounded with short decision index.
- **Output:** change folder with proposal + delta spec, plus design only when the overflow rule is met.
- **Handoff:** none yet — awaits `plan`.

### `clarify`
Before planning, review proposal/spec/live contract/conditional design for ambiguity. Resolve every `[NEEDS CLARIFICATION]` with the user; record material Q&A in proposal Clarifications and update decisions/spec/design as applicable. Reapply overflow when answers change complexity.
- **Output:** aligned artifacts with **zero unresolved markers** before `plan`. If no ambiguity exists, record no synthetic Q&A and proceed.
- **Handoff:** none — feeds `plan`.

### `plan`
Derive `tasks.md` from the clarified spec and proposal decisions, using `design.md` when present. Dependency-ordered; mark parallelizable items `[P]`; one file path per task; checkpoint validation per phase. **Software:** order tasks test-first (write test, confirm failing, then implement). Reapply the design overflow rule rather than treating planning as an automatic reason to create `design.md`.
- **Handoff preparation:** produce the handoff inputs, but do not begin execution until `analyze` passes. Every in-scope implementation handoff MUST include `Spec ref: specs/changes/<id>/` so review can check against the spec.
- **Output:** `tasks.md`.

### `analyze`
Mandatory pre-execution gate: normative decisions/guarantees belong in `spec.md` with task coverage; internal design decisions align with executable tasks and expanded `design.md` when needed, not forced into normative requirements. Every requirement/scenario needs task coverage; tasks must neither omit outcomes nor add scope. Resolve contradictions, missing coverage, stale rationale, and clarification markers before execution.
- **Output:** readiness status plus issues corrected or still blocking.
- **Handoff:** only after a pass does the coordinator load `orchestrate` and dispatch from `tasks.md`.

### `verify`
Review execution against the **PERSISTED spec**, not just done criteria.
- **Post-execution `converge`:** drift check (work output vs proposal decisions, spec, and tasks, plus design when present). Treat the spec as authoritative if non-normative design wording conflicts. **Software:** confirm each spec scenario maps to a passing test.
- **Output:** conformity status + drift list.
- **Handoff:** runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — checks spec conformity in addition to done-criteria conformance.

### `archive`
Prerequisite: user confirmed archive (see HARD-GATE). If verification passed but no confirmation, ASK and wait — do not proceed.
Merge delta sections into the source spec `specs/<domain>.md`: `ADDED` appended, `MODIFIED` replaced, `REMOVED` deleted. Move `changes/<id>/` → `changes/archive/<YYYYMMDD>-<id>/`. Report all added, modified, and removed requirements and significant decisions to the coordinator; do not edit the wiki as part of `archive`, and do not ask the coordinator to ingest a descriptive counterpart of the archived contract. Optional tacit `Durable discovery` or a report of knowledge not already in the spec remains ok.
- **Output:** updated `specs/<domain>.md`.

## Evolving a spec mid-work

Keep proposal/spec/tasks/conditional design synchronized as execution, verification, and feedback uncover changes.

**Decision rule — update the current change vs. start a new one:**
- **Refines the current change** (defect in current behavior, requirement clarification, improvement within the same scope): edit `changes/<id>/spec.md` (delta) in place. Update the proposal decision index and `tasks.md`; create, update, or remove `design.md` as the overflow rule requires.
- **Expands scope** (new requirement, different bounded context, behavior outside this change): start a new `changes/<new-id>/`.

Never edit archived deltas; new needs require a new active change. Active deltas remain mutable parts of the live contract.

**Loop:** artifacts ↔ `analyze` ↔ execution ↔ `verify`. When behavior or a material decision changes, update the routed artifacts, rerun `analyze`, and keep execution aligned — even for small adjustments. `verify` (`converge`) catches remaining drift, including stale conditional design.

Flow: iterate within the change until execution matches the spec and verification passes → then request archive (see HARD-GATE below).

## <HARD-GATE> Confirm Before Archiving

Never auto-archive. After execution and verification pass:
1. Report — tell the user: execution done, verification passed, summary of what was delivered vs. spec.
2. ASK — "Execution and verification complete. Archive the spec?" (or equivalent).
3. WAIT — do not run `archive` or move `changes/<id>/` to `changes/archive/` until the user confirms.

If the user requests further changes instead, return to the fluid loop above — do not archive.

## Integration with orchestrate

`orchestrate` enforces readiness, consumes `Spec ref`, and runs `verify` in Phase 6 Stage 1. After any material active proposal/spec/tasks/design change, rerun `analyze` before further implementation dispatch.

## Templates

Read `references/templates.md` **when creating any artifact** (proposal, spec-delta, tasks, design). It contains the canonical section structure for each.

Use this same workflow proportionally even for small work needing durable alignment. Never defer spec updates or put execution detail in the outcome contract.
