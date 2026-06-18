---
name: spec-builder
description: Create, evolve, and archive spec-driven development artifacts (proposals, behavior specs, task plans). Use when work needs a durable behavior contract before implementation — new features, changes to existing behavior, API/contract changes, migrations, or cross-team work. Do NOT use for trivial fixes, exploratory spikes, or tasks where the handoff's done criteria suffice. Produces specs/ artifacts that orchestrate consumes via Spec ref.
---

# Spec-Builder

SDD layer — durable behavior contracts. Specs describe **WHAT** the system does (observable behavior), not **HOW** (implementation). `orchestrate` consumes the artifacts via the `Spec ref` field.

## <HARD-GATE> Confirm Before Creating Specs

Never auto-create spec artifacts. When work appears to need a durable behavior contract:
1. Assess — does it match the "When to use" triggers below?
2. RECOMMEND — tell the user: why a spec fits, the proposed change id, and rigor (Lite/Full).
3. WAIT — do not run `propose` or create any file under `specs/` until the user confirms.

Skip confirmation only when the user explicitly requests a spec.

## When to use (triggers)

- New feature or behavior change needing alignment before code
- API/contract change, migration, security/privacy-sensitive work
- Cross-team or ambiguity-prone work
- **NOT for:** trivial fixes, spikes, or tasks that fit in one handoff's done criteria

## Principles

- **Spec = observable behavior**: inputs, outputs, errors, constraints, scenarios. Class/function names, library choices, and step-by-step implementation go in `tasks.md`/`design.md`, never the spec.
- **What/HOW split test:** "If implementation can change without changing externally visible behavior, it likely does not belong in the spec."
- **Scenarios** use Given/When/Then, are testable, and cover happy path + edge cases.
- **RFC 2119** keywords (`MUST`/`SHOULD`/`MAY`) signal requirement strength.
- **`[NEEDS CLARIFICATION: ...]` markers are MANDATORY** when ambiguous — never guess. Resolve before `plan` (Lite) or before `implement` (Full).
- **No speculative features** ("might need"). Simplicity gate.
- **Fluid, not waterfall** — update mid-work as you learn; never let spec and code drift.
- **Wiki writes route through the coordinator:** subagents report learnings/decisions in their return summary; the coordinator consolidates parallel reports and delegates a single wiki update. Wiki reads (e.g. during `propose`) stay inline — no concurrency concern.

## Structure

```
specs/
├── <domain>/spec.md              # source of truth: current behavior
└── changes/<id>/
    ├── proposal.md               # Intent / Scope / Non-goals
    ├── spec.md                   # DELTA: ## ADDED/MODIFIED/REMOVED Requirements + Scenarios
    ├── tasks.md                  # derived checklist (the executable "how"), consumed by orchestrate
    └── design.md                 # (Full mode only) technical approach
```

**Source spec format:** `# <Domain> Specification` / `## Purpose` / `## Requirements` / `### Requirement: <name>` / `#### Scenario: <name>` (Given/When/Then). Organized by domain (feature area / bounded context).

**Change id:** short kebab, e.g. `add-auth-rate-limit`.

## Rigor: Lite vs Full

- **Lite (DEFAULT):** `propose` → `plan` → `verify` → `archive`. Covers most work.
- **Full:** adds `clarify` (resolve `[NEEDS CLARIFICATION]`), `design.md`, and pre-impl `analyze`. **Triggers:** cross-team, API/contract change, migration, security/privacy, ambiguity-prone work.

## Actions

For each: what it does, output, and handoff to orchestrate.

### `propose`
Prerequisite: user confirmed spec creation (see HARD-GATE). If not confirmed, RECOMMEND and wait — do not proceed.
Create `changes/<id>/proposal.md` + `spec.md` (delta). **Load the `wiki` skill and query the workspace wiki (`index.md` first, then relevant pages) for context relevant to the spec — conventions, architecture, domain rules, prior decisions (ADRs). Use findings as proactive guardrails before drafting.**
- **Output:** change folder with proposal + delta spec.
- **Handoff:** none yet — awaits `plan`.

### `clarify` (Full)
Resolve `[NEEDS CLARIFICATION]` markers; record Q&A in `proposal.md` → Clarifications.
- **Output:** proposal updated; **zero unresolved markers** before proceeding.
- **Handoff:** none — feeds `plan`.

### `plan`
Derive `tasks.md` from the spec. Dependency-ordered; mark parallelizable items `[P]`; one file path per task; checkpoint validation per phase.
- **THIS IS THE HANDOFF POINT:** the coordinator loads `orchestrate` and dispatches handoffs from `tasks.md`. Each handoff SHOULD include `Spec ref: specs/changes/<id>/` so review can check against the spec.
- **Output:** `tasks.md`.

### `verify`
Review implementation against the **PERSISTED spec**, not just done criteria.
- **Pre-impl `analyze` (Full):** cross-artifact consistency (spec ↔ tasks ↔ design).
- **Post-impl `converge`:** drift check (codebase vs spec/tasks).
- **Output:** conformity status + drift list.
- **Handoff:** runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — checks spec conformity in addition to done-criteria conformance.

### `archive`
Merge delta sections into the source spec: `ADDED` appended, `MODIFIED` replaced, `REMOVED` deleted. Move `changes/<id>/` → `changes/archive/<YYYYMMDD>-<id>/`. If an architectural decision was involved, **REPORT it to the coordinator** (do not write to wiki directly) — the coordinator consolidates parallel reports and delegates wiki ingest via the `wiki` skill (ADRs go to `wiki/decisions/<NNNN-name>.md`).
- **Output:** updated source spec.

## Integration with orchestrate

- After `plan`, the coordinator loads `orchestrate` and dispatches handoffs from `tasks.md`. Each handoff SHOULD carry `Spec ref: specs/changes/<id>/` so review can check against the spec.
- `verify` runs AS PART OF orchestrate's Phase 6 review (Stage 1 Conformance) when a Spec ref exists — it checks spec conformity in addition to done-criteria conformance.
- `orchestrate` is **NOT modified** by this skill; it only consumes the `Spec ref`.

## Templates

Read `references/templates.md` **when creating any artifact** (proposal, spec-delta, tasks, design). It contains the canonical section structure for each.

## Rationalization Prevention

| Excuse | Reality |
|---|---|
| "Too small to spec" | If work needs alignment before code, spec it. Lite mode is light. |
| "I'll fix the spec later" | Update mid-work; never let spec and code drift. |
| "Implementation detail belongs in spec" | No — observable behavior only. Detail goes in `tasks`/`design`. |
