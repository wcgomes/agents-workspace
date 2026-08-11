---
name: spec-builder
description: Create, evolve, and archive spec-driven workflow artifacts (proposals, outcome specs, task plans). Use when work needs a durable outcome contract before execution — new deliverables or outcome changes, API/contract changes, migrations, security/privacy-sensitive work, or any long-running task where the outcome must be agreed upfront. Do NOT use for trivial fixes, exploratory spikes, or tasks where the handoff's done criteria suffice. Produces specs/ artifacts that orchestrate consumes via Spec ref.
---

# Spec-Builder

SDD layer — durable outcome contracts. Specs describe **WHAT** outcome the work produces and **WHY**, not **HOW** it's executed. `orchestrate` consumes the artifacts via the `Spec ref` field.

## <HARD-GATE> Confirm Before Creating Specs

Never auto-create spec artifacts. When work appears to need a durable outcome contract:
1. Assess — does it match the "When to use" triggers below?
2. RECOMMEND — tell the user: why a spec fits, the proposed change id, and rigor (Lite/Full).
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
- **`[NEEDS CLARIFICATION: ...]` markers are MANDATORY** when ambiguous — never guess. Resolve before `plan` (Lite) or before execution (Full).
- **No speculative features** ("might need"). Simplicity gate.
- **Fluid, not waterfall** — see "Evolving a spec mid-work" below.
- **Wiki access is explicit:** executors do not inspect or edit the wiki unless wiki work is part of their handoff. The required `propose` query below is explicit read scope. All wiki writes route through the coordinator's mandatory post-review evaluation and, when positive, the consolidated serialized Wiki Ingestion Specialist stream.

## Structure

```
specs/
├── <domain>.md                   # realized spec: the archived/merged contract (updated only on archive; in-progress changes live in changes/<id>/)
└── changes/
    ├── <id>/
    │   ├── proposal.md           # Intent / Scope / Non-goals
    │   ├── spec.md               # DELTA: ## ADDED/MODIFIED/REMOVED Requirements + Scenarios
    │   ├── tasks.md              # derived checklist (the executable "how"), consumed by orchestrate
    │   └── design.md             # (Full mode only) technical approach
    └── archive/<YYYYMMDD>-<id>/  # archived, immutable change bundle
```

**Source spec format:** `# <Domain> Specification` / `## Purpose` / `## Requirements` / `### Requirement: <name>` / `#### Scenario: <name>` (Given/When/Then for software; one-line acceptance condition for non-software). Organized by domain (feature area, work stream, or bounded context). Prescriptive contract here; descriptive domain facts live in `wiki/domain/` — load via `propose`.

**Domain id:** flat kebab-case matching `[a-z0-9]+(?:-[a-z0-9]+)*` (for example, `order-fulfillment`). It MUST NOT contain `/` or create nested paths. `changes` is reserved and MUST NOT be used as a domain id.

**Change id:** short kebab, e.g. `add-auth-rate-limit`.

**Legacy workspace migration:** before the next spec action, migrate all legacy sources as one atomic change. First inventory every `specs/<legacy-domain>/spec.md`, choose a unique target whose id satisfies the Domain id rule, and preflight target collisions. If a target exists, compare and explicitly merge any differing content — never overwrite it. In the same change, write or move the reconciled flat files, update all references, and remove only empty legacy directories. Do not continue the spec action until no legacy source remains; never keep both paths as sources of truth.

## State lifecycle

A spec change moves through explicit states. The **active/archived** distinction is encoded by folder location (no separate status field): top-level `changes/<id>/` = active (WIP), `changes/archive/<YYYYMMDD>-<id>/` = archived/immutable. The four in-progress sub-states below (Draft / Planned / In-progress / Verified) are **procedural** — determined by which actions have run (propose→plan→execution→verify), not by folder location.

| State | Trigger | Artifacts present | Source spec `specs/<domain>.md` |
|---|---|---|---|
| Draft | `propose` done | `proposal.md` + `spec.md` (delta) | May not exist yet (created on first archive for the domain) |
| Planned | `plan` done | + `tasks.md` (+ `design.md` in Full) | Unchanged |
| In-progress | execution underway | Unchanged; `tasks.md` checklist being completed | Unchanged |
| Verified | `verify` passed | Unchanged; awaiting archive confirmation (HARD-GATE) | Unchanged |
| Archived | `archive` done | Delta merged into source spec; `changes/<id>/` moved to `changes/archive/<YYYYMMDD>-<id>/` | Updated (created if domain is new) |

**Live contract** (the prescriptive contract in force at any moment) = `specs/<domain>.md` (if it exists) **plus** every `changes/<id>/spec.md` delta where `<id>` is NOT under `changes/archive/`. To reason about the live contract during WIP, read the realized spec and all active deltas together; never assume the realized spec alone reflects in-progress work.

**File movement rules:**
- Source spec `specs/<domain>.md` is created on the first `archive` for that domain (before that, the domain's contract lives only in active deltas).
- `changes/<id>/` moves to `changes/archive/<YYYYMMDD>-<id>/` ONLY on `archive`. If a change folder sits at the top of `changes/` (not under `archive/`), it is ACTIVE — expect its delta to still be evolving.

```
[Draft] -> [Planned] -> [In-progress] -> [Verified] --HARD-GATE--> [Archived]
   |           |             |                |                        |
 propose     plan         execution        verify                   archive
                                                              (merge delta + move folder)
```

## Rigor: Lite vs Full

- **Lite (DEFAULT):** `propose` → `plan` → `verify` → `archive`. Covers most work.
- **Full:** adds `clarify` (resolve `[NEEDS CLARIFICATION]`), `design.md`, and pre-execution `analyze`. **Triggers:** cross-team, API/contract change, migration, security/privacy, ambiguity-prone work. **Software:** `design.md` covers data model and API contracts.

## Actions

For each: what it does, output, and handoff to orchestrate.

### `propose`
Prerequisite: user confirmed spec creation (see HARD-GATE). If not confirmed, RECOMMEND and wait — do not proceed.

**Before proposing a new change:** scan `specs/changes/` (top-level entries, excluding `changes/archive/`) for an ACTIVE change folder in the same domain or overlapping scope. If one exists and the new intent refines it (defect in current behavior, requirement clarification, improvement within the same scope), edit that change's `spec.md` (delta) in place per "Evolving a spec mid-work" — do NOT open a new change. Only open a new `changes/<new-id>/` when scope genuinely expands (new requirement, different bounded context, behavior outside this change).
Create `changes/<id>/proposal.md` + `spec.md` (delta). **Load the `wiki` skill and query the workspace wiki (`index.md` first, then relevant pages) for context relevant to the spec — conventions, architecture, domain rules, prior decisions (ADRs). Use findings as proactive guardrails before drafting.**
- **Output:** change folder with proposal + delta spec.
- **Handoff:** none yet — awaits `plan`.

### `clarify` (Full)
Resolve `[NEEDS CLARIFICATION]` markers; record Q&A in `proposal.md` → Clarifications.
- **Output:** proposal updated; **zero unresolved markers** before proceeding.
- **Handoff:** none — feeds `plan`.

### `plan`
Derive `tasks.md` from the spec. Dependency-ordered; mark parallelizable items `[P]`; one file path per task; checkpoint validation per phase. **Software:** order tasks test-first (write test, confirm failing, then implement).
- **THIS IS THE HANDOFF POINT:** the coordinator loads `orchestrate` and dispatches handoffs from `tasks.md`. Each handoff SHOULD include `Spec ref: specs/changes/<id>/` so review can check against the spec.
- **Output:** `tasks.md`.

### `verify`
Review execution against the **PERSISTED spec**, not just done criteria.
- **Pre-execution `analyze` (Full):** cross-artifact consistency (spec ↔ tasks ↔ design).
- **Post-execution `converge`:** drift check (work output vs spec/tasks). **Software:** confirm each spec scenario maps to a passing test.
- **Output:** conformity status + drift list.
- **Handoff:** runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — checks spec conformity in addition to done-criteria conformance.

### `archive`
Prerequisite: user confirmed archive (see HARD-GATE). If verification passed but no confirmation, ASK and wait — do not proceed.
Merge delta sections into the source spec `specs/<domain>.md`: `ADDED` appended, `MODIFIED` replaced, `REMOVED` deleted. Move `changes/<id>/` → `changes/archive/<YYYYMMDD>-<id>/`. **REPORT all added, modified, and removed domain requirements, plus significant decisions, to the coordinator; do not inspect or edit the wiki.** The coordinator always evaluates after review and routes only qualifying wiki maintenance through the consolidated serialized Wiki Ingestion Specialist stream.
- **Output:** updated `specs/<domain>.md`.

## Evolving a spec mid-work

SDD is **fluid, not waterfall** — execution, verification, and user feedback uncover changes. Specs and all related artifacts (proposal, spec, tasks, design) stay in sync at all times.

**Decision rule — update the current change vs. start a new one:**
- **Refines the current change** (defect in current behavior, requirement clarification, improvement within the same scope): edit `changes/<id>/spec.md` (delta) in place. Update `tasks.md`/`design.md` accordingly.
- **Expands scope** (new requirement, different bounded context, behavior outside this change): start a new `changes/<new-id>/`.

**Active vs. archived:** the active/archived distinction is determined solely by folder location. Top-level `changes/<id>/` = ACTIVE — its delta is mutable and part of the live contract. `changes/archive/<YYYYMMDD>-<id>/` = archived/immutable — never edit an archived delta; if a new need arises, open a new active change.

**Loop:** spec ↔ execution ↔ verify. When behavior changes, the spec changes with it — even small adjustments. Never let execution drift from the spec. `verify` (`converge`) exists to catch drift.

Flow: iterate within the change until execution matches the spec and verification passes → then request archive (see HARD-GATE below).

## <HARD-GATE> Confirm Before Archiving

Never auto-archive. After execution and verification pass:
1. Report — tell the user: execution done, verification passed, summary of what was delivered vs. spec.
2. ASK — "Execution and verification complete. Archive the spec?" (or equivalent).
3. WAIT — do not run `archive` or move `changes/<id>/` to `changes/archive/` until the user confirms.

If the user requests further changes instead, return to the fluid loop above — do not archive.

## Integration with orchestrate

- After `plan`, the coordinator loads `orchestrate` and dispatches handoffs from `tasks.md`. Each handoff SHOULD carry `Spec ref: specs/changes/<id>/` so review can check against the spec.
- `verify` runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — it checks spec conformity in addition to done-criteria conformance.
- `orchestrate` is **NOT modified** by this skill; it only consumes the `Spec ref`.

## Wiki synchronization

Specs (prescriptive, lifecycle-bound) and `wiki/domain/` (descriptive, distilled/stable) are distinct but must agree on what the system is. They are NOT redundant — see the wiki SKILL.md for the canonical distinction.

- **Read-side (`propose`):** `wiki/domain/` is the descriptive source (how the system IS); `specs/<domain>.md` (plus active deltas) is the prescriptive source (how it MUST be). Read both before drafting a delta. If they conflict, flag it as drift to resolve — never silently pick one. Resolution: if the wiki reflects shipped behavior the spec never captured, the spec delta should formalize it; if the wiki is simply stale, expose it to the mandatory evaluation and queue an update only when maintenance qualifies.
- **Write-side (`archive`):** merge the delta into `specs/<domain>.md` and report all domain-rule changes without reading or writing the wiki. The coordinator always runs the mandatory post-review evaluation, but archive completion alone never requires a wiki write. Add, revise, or remove `wiki/domain/` content only when doing so materially improves durable descriptive knowledge after accounting for compact organization and future context cost; do not add low-value, ambiguous, redundant, transient, or already-captured information. When existing wiki content becomes contradictory, stale, or noisy, the evaluation may qualify revision or removal. Route qualifying maintenance through the consolidated serialized Wiki Ingestion Specialist stream; unresolved qualifying maintenance is reported under `orchestrate`'s status protocol rather than silently dropped.
- **Boundary restatement:** specs hold the prescriptive contract and carry the lifecycle (WIP deltas, archived source). `wiki/domain/` holds only distilled, stable descriptive facts with material future value. An archive may produce a descriptive wiki add/update/remove, but evaluation may correctly produce no wiki change.

## Templates

Read `references/templates.md` **when creating any artifact** (proposal, spec-delta, tasks, design). It contains the canonical section structure for each.

## Rationalization Prevention

| Excuse | Reality |
|---|---|
| "Too small to spec" | If work needs alignment before execution, spec it. Lite mode is light. |
| "I'll fix the spec later" | Update mid-work; never let spec and execution drift. |
| "Execution detail belongs in spec" | No — outcome only. Detail goes in `tasks`/`design`. |
