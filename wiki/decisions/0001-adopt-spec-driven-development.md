# ADR 0001: Adopt Spec-Driven Development via spec-builder skill

## Status

Accepted (2026-06-18). Archive-time ingestion routing was superseded by [ADR 0004](0004-serialized-post-review-wiki-ingestion.md).

## Context

The workspace template had a wiki knowledge base + `orchestrate` skill for delegation, but no durable outcome-contract layer. Plans were ephemeral (in-context handoffs); review checked against handoff done-criteria only, with no persistent spec to detect drift. The `wiki/decisions/` ADR slot was reserved in `wiki/SKILL.md` but dormant.

## Decision

Add a `spec-builder` skill implementing spec-driven development (SDD).

- **Artifacts** live in `specs/`: each realized domain has one flat source spec at `specs/<domain>.md`, where `<domain>` is a kebab-case identifier and `changes` is reserved. Active change bundles live at `specs/changes/<id>/`; archived bundles move to `specs/changes/archive/<YYYYMMDD>-<id>/`. Bundles contain `ADDED`/`MODIFIED`/`REMOVED` deltas that merge into source specs on completion.
- **Workflow:** `propose` → (`clarify`, Full) → `plan` → `verify` → `archive`.
- **Rigor:** Lite (default) vs Full (cross-team, API/contract, migration, security/privacy, ambiguity-prone).
- **Integration:** `orchestrate` consumes artifacts via an optional `Spec ref:` handoff field; Phase 6 review checks spec conformity when a Spec ref is present.
- `AGENTS.md` Flow points to the skill; `orchestrate` itself is unchanged except for consuming the `Spec ref`.
- **HARD-GATES:** user confirms before creating specs and before archiving — no auto-create, no auto-archive.
- **Fluid, not waterfall:** specs evolve mid-work. Refine the current change in place vs. start a new change; loop spec ↔ execution ↔ verify. `verify` (`converge`) catches drift.
- **Domain-agnostic vocabulary:** outcome/execution (not behavior/implementation). Software-specific precision (Given/When/Then scenarios, TDD task ordering, scenarios→tests mapping, data model & API contracts) carried as `Software:` notes.

## Rationale

- Merges OpenSpec's delta-based change model (strongest evolution mechanism; spec-kit has no equivalent) with spec-kit's WHAT/HOW artifact split and verify richness (analyze pre-impl, converge post-impl).
- Keeps SDD logic in a **skill** (not wiki — wiki is distilled post-hoc knowledge; specs are in-flight contracts).
- `orchestrate` stays lean: SDD is optional per task.
- Templates-as-LLM-constraints pattern from spec-kit (`[NEEDS CLARIFICATION]` markers, simplicity gate).

## Alternatives Considered

- **Full OpenSpec** (YAML schemas, 25+ commands) — rejected: complexity without return for this template.
- **spec-kit constitution as a separate file** — rejected: duplicates `wiki/conventions/`. Gates inlined as skill rules instead.
- **Store specs in `wiki/`** — rejected: wiki is distilled post-hoc knowledge; specs are in-flight contracts. At adoption, `spec-builder` executors reported archive decisions without writing the wiki; the coordinator consolidated reports and delegated ingestion. [ADR 0004](0004-serialized-post-review-wiki-ingestion.md) supersedes that routing with mandatory coordinator evaluation and conditional serialized specialist ingestion.
- **Move SDD logic into `orchestrate`** — rejected: keeps `orchestrate` lean; SDD is optional per task.

## Consequences

- New `specs/` directory at workspace root when SDD is used.
- `orchestrate` handoffs gain optional `Spec ref:` field.
- `wiki/decisions/` activated (was dormant).
- Users run `./tools/install.sh` to install the new skill.
