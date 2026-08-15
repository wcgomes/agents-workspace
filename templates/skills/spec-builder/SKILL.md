---
name: spec-builder
description: Create, evolve, and archive spec-driven workflow artifacts (proposals, outcome specs, task plans). Use when work needs a durable outcome contract before execution — new deliverables or outcome changes, API/contract changes, migrations, security/privacy-sensitive work, or any long-running task where the outcome must be agreed upfront. Do NOT use for trivial fixes, exploratory spikes, or tasks where the handoff's done criteria suffice. Produces specs/ artifacts that orchestrate consumes via Spec ref.
---

# Spec-Builder

SDD layer — durable outcome contracts. Specs describe **WHAT** outcome the work produces and **WHY**, not **HOW** it's executed. `orchestrate` consumes the artifacts via the `Spec ref` field.

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

> **Language:** Spec artifacts (proposals, spec deltas, task plans, design docs) default to English. Use another language only when the user explicitly requests it, or when existing specs in the workspace are already authored in that language.

> **Prose:** No hard-wrapping — paragraphs flow as single lines; the renderer wraps. Write what matters, skip the rest; no preambles, no filler.

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

**Artifact routing:**
- `proposal.md` is the bounded alignment record: intent, scope, non-goals, approach summary, clarifications, and a concise index of decisions. Keep each decision to its conclusion and short rationale; link to `design.md` when expansion is needed.
- `spec.md` is the normative observable contract: requirements, guarantees, constraints, and acceptance scenarios. Guarantees MUST live here, even when `design.md` discusses how to achieve them.
- `tasks.md` is executable work: dependency order, paths, implementation actions, and validation checkpoints.
- `design.md`, when present, is non-normative overflow for expanded rationale, alternatives and trade-offs, diagrams or flows, and substantial migration, rollback, security, or cross-component design detail.

**Design overflow rule:** create `design.md` only when a material design decision cannot remain understandable and actionable as a concise proposal decision plus task instructions without overloading either artifact or duplicating substantial context. Typical evidence is a real need to compare alternatives and trade-offs, explain an interacting multi-step flow, or preserve substantial migration/rollback/security reasoning. A work category (including API, migration, cross-team, or security work) never triggers it by itself. Omit it when concise entries suffice; do not move normative guarantees out of `spec.md` to justify it.

**Legacy workspace migration:** before the next spec action, migrate all legacy sources as one atomic change. First inventory every `specs/<legacy-domain>/spec.md`, choose a unique target whose id satisfies the Domain id rule, and preflight target collisions. If a target exists, compare and explicitly merge any differing content — never overwrite it. In the same change, write or move the reconciled flat files, update all references, and remove only empty legacy directories. Do not continue the spec action until no legacy source remains; never keep both paths as sources of truth.

## State lifecycle

A spec change follows one lifecycle. The **active/archived** distinction is encoded by folder location (no separate status field): top-level `changes/<id>/` = active (WIP), `changes/archive/<YYYYMMDD>-<id>/` = archived/immutable. The in-progress sub-states below are **procedural** — determined by completed actions (`propose` → `clarify` → `plan` → `analyze` → execution → `verify`), not by folder location.

| State | Trigger | Artifacts present | Source spec `specs/<domain>.md` |
|---|---|---|---|
| Draft | `propose` done; `clarify` resolves ambiguity before planning | `proposal.md` + `spec.md` (delta), plus `design.md` only when the overflow rule is met | May not exist yet (created on first archive for the domain) |
| Planned | `plan` done | + required `tasks.md`; conditional `design.md` remains in sync | Unchanged |
| Ready | `analyze` passed | Cross-artifact readiness confirmed | Unchanged |
| In-progress | execution underway | Unchanged; `tasks.md` checklist being completed | Unchanged |
| Verified | `verify` passed | Unchanged; awaiting archive confirmation (HARD-GATE) | Unchanged |
| Archived | `archive` done | Delta merged into source spec; `changes/<id>/` moved to `changes/archive/<YYYYMMDD>-<id>/` | Updated (created if domain is new) |

**Live contract** (the prescriptive contract in force at any moment) = `specs/<domain>.md` (if it exists) **plus** every `changes/<id>/spec.md` delta where `<id>` is NOT under `changes/archive/`. To reason about the live contract during WIP, read the realized spec and all active deltas together; never assume the realized spec alone reflects in-progress work.

**File movement rules:**
- Source spec `specs/<domain>.md` is created on the first `archive` for that domain (before that, the domain's contract lives only in active deltas).
- `changes/<id>/` moves to `changes/archive/<YYYYMMDD>-<id>/` ONLY on `archive`. If a change folder sits at the top of `changes/` (not under `archive/`), it is ACTIVE — expect its delta to still be evolving.

```
[Draft] ------> [Planned] -----> [Ready] ----> [In-progress] -> [Verified] --HARD-GATE--> [Archived]
   |               |               |                |                |                        |
propose+clarify   plan           analyze         execution        verify                   archive
                                                                                (merge delta + move folder)
```

## Actions

For each: what it does, output, and handoff to orchestrate.

### `propose`
Prerequisite: user confirmed spec creation (see HARD-GATE). If not confirmed, RECOMMEND and wait — do not proceed.

**Before proposing a new change:** scan `specs/changes/` (top-level entries, excluding `changes/archive/`) for an ACTIVE change folder in the same domain or overlapping scope. If one exists and the new intent refines it (defect in current behavior, requirement clarification, improvement within the same scope), edit that change's `spec.md` (delta) in place per "Evolving a spec mid-work" — do NOT open a new change. Only open a new `changes/<new-id>/` when scope genuinely expands (new requirement, different bounded context, behavior outside this change).
Create `changes/<id>/proposal.md` + `spec.md` (delta), and create `design.md` only if the design overflow rule is already met. Keep the proposal bounded and record decisions in its concise decision index. Before drafting, load the `wiki` skill, start from `wiki/index.md`, and consult relevant descriptive knowledge. Compare relevant descriptive facts with the realized source spec (if any) and every active delta in the same domain or overlapping scope; these form the relevant prescriptive live contract. Flag every conflict; never silently choose a source, expand scope, or dump the live contract into the wiki.
- **Output:** change folder with proposal + delta spec, plus design only when the overflow rule is met.
- **Handoff:** none yet — awaits `plan`.

### `clarify`
Before planning, review the proposal, spec, relevant live contract, and conditional design for ambiguity. Resolve every `[NEEDS CLARIFICATION]` marker with the user; record material Q&A in `proposal.md` → Clarifications and update the decision index, spec, and design as applicable. Reapply the design overflow rule when answers add or remove complexity.
- **Output:** aligned artifacts with **zero unresolved markers** before `plan`. If no ambiguity exists, record no synthetic Q&A and proceed.
- **Handoff:** none — feeds `plan`.

### `plan`
Derive `tasks.md` from the clarified spec and proposal decisions, using `design.md` when present. Dependency-ordered; mark parallelizable items `[P]`; one file path per task; checkpoint validation per phase. **Software:** order tasks test-first (write test, confirm failing, then implement). Reapply the design overflow rule rather than treating planning as an automatic reason to create `design.md`.
- **Handoff preparation:** produce the handoff inputs, but do not begin execution until `analyze` passes. Every in-scope implementation handoff MUST include `Spec ref: specs/changes/<id>/` so review can check against the spec.
- **Output:** `tasks.md`.

### `analyze`
Mandatory pre-execution readiness gate. Validate routing and consistency: normative decisions and guarantees map to `spec.md` and have task coverage; internal design decisions map consistently to executable tasks and, when expanded detail is needed, `design.md`; every spec requirement and scenario has task coverage; and tasks neither omit required outcomes nor introduce scope. Do not require internal design decisions to become normative requirements. Resolve all contradictions, missing coverage, stale rationale, and unresolved clarification markers before execution.
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

SDD is **fluid, not waterfall** — execution, verification, and user feedback uncover changes. The proposal, spec, tasks, and conditional design stay in sync at all times.

**Decision rule — update the current change vs. start a new one:**
- **Refines the current change** (defect in current behavior, requirement clarification, improvement within the same scope): edit `changes/<id>/spec.md` (delta) in place. Update the proposal decision index and `tasks.md`; create, update, or remove `design.md` as the overflow rule requires.
- **Expands scope** (new requirement, different bounded context, behavior outside this change): start a new `changes/<new-id>/`.

**Active vs. archived:** the active/archived distinction is determined solely by folder location. Top-level `changes/<id>/` = ACTIVE — its delta is mutable and part of the live contract. `changes/archive/<YYYYMMDD>-<id>/` = archived/immutable — never edit an archived delta; if a new need arises, open a new active change.

**Loop:** artifacts ↔ `analyze` ↔ execution ↔ `verify`. When behavior or a material decision changes, update the routed artifacts, rerun `analyze`, and keep execution aligned — even for small adjustments. `verify` (`converge`) catches remaining drift, including stale conditional design.

Flow: iterate within the change until execution matches the spec and verification passes → then request archive (see HARD-GATE below).

## <HARD-GATE> Confirm Before Archiving

Never auto-archive. After execution and verification pass:
1. Report — tell the user: execution done, verification passed, summary of what was delivered vs. spec.
2. ASK — "Execution and verification complete. Archive the spec?" (or equivalent).
3. WAIT — do not run `archive` or move `changes/<id>/` to `changes/archive/` until the user confirms.

If the user requests further changes instead, return to the fluid loop above — do not archive.

## Integration with orchestrate

- After `plan`, mandatory `analyze` must pass; then the coordinator loads `orchestrate` and dispatches from `tasks.md`. Every in-scope implementation handoff MUST carry `Spec ref: specs/changes/<id>/` so review can check against the spec. Rerun `analyze` before further implementation dispatch whenever active proposal, spec, tasks, or design artifacts materially change.
- `verify` runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — it checks spec conformity in addition to done-criteria conformance.
- `orchestrate` enforces this readiness gate and consumes the `Spec ref`.

## Templates

Read `references/templates.md` **when creating any artifact** (proposal, spec-delta, tasks, design). It contains the canonical section structure for each.

## Rationalization Prevention

| Excuse | Reality |
|---|---|
| "Too small to spec" | If work needs durable alignment before execution, use the same workflow and keep each artifact proportional. |
| "I'll fix the spec later" | Update mid-work; never let spec and execution drift. |
| "Execution detail belongs in spec" | No — outcome only. Detail goes in `tasks`/`design`. |
