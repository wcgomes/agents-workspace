---
name: wiki
description: Use for explicit wiki setup/maintenance (including creation), or post-review ingest evaluation and conditional ingestion for an identified task project with root wiki/. Read-only consultation uses wiki-query instead.
---

# Wiki

Setup → gated post-review evaluation → conditional ingestion → maintenance/validation. Apply the boot policy's Wiki gate before automatic loading/evaluation; explicit requests bypass it (clarify target if needed). Paths refer to that project/target, not unrelated cwd. Wiki eliminates or narrows exploration to relevant context. Read-only consultation uses `wiki-query`, not a prerequisite for evaluation.

## Design Principle

> **Language:** English unless explicitly requested otherwise or the existing wiki uses another language.
> **Prose:** Single-line paragraphs, no hard-wrapping, preambles, or filler.

Every line costs context: short paragraphs/bullets, clear headings, one topic per file. Keep only precise future-useful decision/action guidance; dense patterns, conventions, and examples are welcome. `index.md` is the required routing map: page/child-index `.md` links, never folders, under the contract below.

Do not restate trivial facts readily visible in source material. Preserve maps, rationale, and non-obvious relationships that materially reduce exploration; link to sources rather than duplicate details.

Evaluate every ingest for material net durable retrieval value after context, navigation, duplication, and upkeep cost. Evaluation is mandatory; writing is not.

### Index Entry Contract

An `index.md` may contain only its title, optional short group headings, and entries in this exact one-line shape:

`- [Page title](relative/path.md) — keyword-1, keyword-2 — Description of 12 words or fewer.`

Each entry: one physical bullet, exactly one `.md` link, 2–5 short retrieval keywords in an unlabeled segment, description ≤12 words; separate all three segments with em dashes. Route, never summarize: no architecture, exhaustive behavior, changelog/spec inventories, test/run instructions, rationale, examples, or linked-page duplication. Put qualifying detail on the page; otherwise omit.

**No raw data:** logs, stack traces, command output, API responses, dumps are ephemeral. Distill learning/patterns/decisions: "X error happens when Y", not its log.

**Date-bound artifacts:** retain worthwhile incidents/research/audits/meetings/reviews in `wiki/records/` with `YYYYMMDD-` filenames (e.g., `wiki/records/incidents/20260110-pg-outage.md`).

## Setup

Create `wiki/` only for explicitly requested setup/creation, never automatic consultation/evaluation. Create `wiki/index.md` and parent-linked indexes for every new content folder under Wiki Structure/Index Entry Contract. Broad setup uses `orchestrate` roles: Workspace Research / Architecture Analysis, Technical Writing / Documentation, plus Review / Consistency when creating persistent docs.

## <HARD-GATE> Post-Review Ingest Evaluation

When Wiki-gated, coordinator evaluates after review/verification and before final response in every domain. Otherwise skip automatic evaluation; explicit wiki tasks still evaluate below.

A **durable discovery** is a workspace-specific fact/decision/constraint/correction/reusable pattern stable enough to improve future work. Durability alone does not qualify: require material net value after compact organization, context/maintenance cost, ambiguity, and duplication. Do not add requested task artifacts or generic, low-value, ambiguous, redundant, transient, or already-captured information.

Evaluate the reviewed artifacts and outcomes, verification evidence, user corrections, and any optional executor signal against these questions:

1. Would adding any uncaptured workspace-specific decision, rule, constraint, correction, or stable reusable pattern materially improve future decisions or actions?
2. Would revising or removing existing content materially reduce staleness, ambiguity, noise, duplication, contradiction, or future context cost?
3. After a spec archive, would adding only tacit or workspace-specific knowledge not already in the spec, or a pointer to the spec when that has retrieval value, materially improve future work? Restating or syncing the archived contract does not qualify.

Any clear YES → conditional ingestion stream. All NO/uncertain/marginal → no additional dispatch. Missing executor signals never waive evaluation; completion never requires a write.

Coordinator supplies task-critical handoff context; handoff stays primary. Executors may consult wiki when useful to assigned work without further authorization, never expanding scope or overriding handoff/specs/current sources. Edits require explicit handoff scope. Optional: at most one `Durable discovery: ...` line for tacit knowledge not evident in artifacts.

Positive ingestion: consolidate all sequential/parallel discoveries into **one serialized stream** owned by the Wiki Ingestion Specialist role; never parallel writers. Owner classifies/deduplicates, decides qualifying add/update/remove edits, maintains contract-compliant navigation, and lints consistency; never alter original deliverables. No-write return is valid if closer inspection finds no material net value. Coordinator reviews before final response. Failed review/non-complete status: bounded retry/correction in the same stream under `orchestrate` status/stuck rules; report unresolved work, never drop it.

Explicit wiki tasks/broad setup still evaluate. Skip redundant ingestion if reviewed deliverables already correctly capture durable knowledge, navigation, and consistency. Ingestion never replaces multi-role **Setup**.

**Wiki vs spec:** specs own the prescriptive live contract (requirements/scenarios/acceptance); wiki owns durable descriptive knowledge, skills procedures. Link `specs/<domain>.md`/relevant change, never copy/paraphrase its contract. On conflict spec wins: delete/shrink wiki restatements, never sync a mirror.

**Wiki vs skill:** wiki is declarative (true/decided/workspace facts); skills are recurring multi-step procedures improved by instruction. Only for clearly procedural AND recurring content, ask: "this reads like a skill — create one with `skill-builder`, or keep in wiki?" Never create it; user decides. Check existing skills first; adapt, don't duplicate. Uncertainty never justifies ingestion; declarations still need durable future value. Wiki may reference skills; skills may consult runtime wiki context but must keep procedures self-contained, never depend on wiki for instructions.

Do NOT ask "should I update the wiki?" — evaluate automatically.

## Wiki Structure

```
wiki/
├── index.md              # Required routing map — compact keywords + descriptions
├── architecture.md       # System structure overview (single file)
├── conventions/          # One file per convention
│   ├── index.md          # Required for every new content folder
│   └── <pattern-name>.md
├── domain/               # One file per business rule — descriptive facts, not spec contracts
│   ├── index.md
│   └── <rule-name>.md
├── decisions/            # One file per ADR
│   ├── index.md
│   └── <NNNN-decision-name>.md
├── records/             # Date-bound artifacts
│   ├── index.md
│   └── incidents/
│       ├── index.md
│       └── YYYYMMDD-<incident-name>.md
└── ...
```

Adapt folders for projects/features/WIP/useful groupings. One topic per file, one concept per folder; stay shallow.

Every new content folder (including intermediate/`records/` folders) needs parent-linked `index.md`, never a folder link. Each index lists only local pages (not itself) and immediate child indexes, never repeated descendant inventories. Every page must be reachable from `wiki/index.md`; root pages link directly there.

Apply this structure to new content folders; do not automatically migrate or reorganize existing wiki layouts to comply.

Creation, ingestion, and maintenance must preserve the Index Entry Contract; never expand an index entry to capture page content.

Consider splitting when an index exceeds ~50 lines OR a topic group ~10 entries: move a coherent group to a subfolder; replace parent entries with its `index.md` link. Heuristics, not automatic reorganization; use judgment, stay shallow. New folders always need indexes regardless of size.

## Wiki Maintenance

- **Add:** only new, unambiguous, reusable, uncovered knowledge worth context/maintenance cost.
- **Update:** materially clarify durable knowledge, complete useful rules, reduce misleading/stale guidance.
- **Reorganize:** merge/rename/move/split oversized or mixed topics for material compactness/retrieval/context benefit; update all navigation/references.
- **Remove:** delete/consolidate pages/sections to materially reduce ambiguity/noise/context/contradiction/duplication/obsolescence; update/remove index and related-page references.

### Lint

When the wiki changes, check for:
- stale references
- index links point to `.md` files, not folders
- every new content folder, including intermediate groups and `records/` folders, has `index.md` linked from its parent index
- indexes for new content folders and their updated parent entries list local pages and immediate child indexes, without duplicating descendant page lists in ancestors; do not migrate existing layouts automatically
- root and folder indexes contain only a title, optional short group headings, and entries that satisfy the Index Entry Contract
- pages not reachable (orphaned) from `wiki/index.md` directly or through folder indexes
- indexes past the split heuristic (~50 lines, or a group over ~10 entries) that merit splitting or reorganization, not automatic changes
- contradictory guidance across pages

Do not leave the wiki internally inconsistent after editing it.

Size, specificity, or "nothing learned" never waives evaluation; only material durable value warrants writing. Distill insights, never logs.
