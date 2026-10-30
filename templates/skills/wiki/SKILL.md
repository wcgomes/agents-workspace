---
name: wiki
description: Use to create, set up, update, reorganize, or lint a project wiki/ ("set up a wiki", "add this to the wiki"). Also use after reviewed non-trivial work surfaced a user correction, new decision/convention/constraint/pattern, stale or contradicted wiki content, a durable discovery, or tacit knowledge after a spec archive. Automatic use requires an identified task project with root wiki/, never inferred from cwd alone in standalone chat. Not for read-only consultation.
---

# Wiki

Setup → post-review ingest evaluation → conditional ingestion → maintenance and lint. Explicit wiki requests need no gate; clarify the target if needed. Paths refer to the identified project, not an unrelated cwd. The wiki exists to eliminate exploration or narrow it to relevant context.

## Design Principle

> **Language:** English unless explicitly requested otherwise or the existing wiki uses another language.
> **Prose:** Single-line paragraphs, no hard-wrapping, preambles, or filler.

Every line costs context: short bullets, clear headings, one topic per file. Keep only precise future-useful guidance; dense patterns, conventions, and examples are welcome. `index.md` is the required routing map: it links pages and child indexes as `.md` files, never folders, under the contract below.

Do not restate trivial facts readily visible in source material. Preserve maps, rationale, and non-obvious relationships that materially reduce exploration. Link to sources rather than duplicate details.

### Index Entry Contract

An `index.md` may contain only its title, optional short group headings, and entries in this exact one-line shape:

`- [Page title](relative/path.md) — keyword-1, keyword-2 — Description of 12 words or fewer.`

Each entry: one physical bullet, exactly one `.md` link, 2–5 short retrieval keywords in an unlabeled segment, description ≤12 words; separate all three segments with em dashes. Route, never summarize: no architecture, exhaustive behavior, changelog/spec inventories, test/run instructions, rationale, examples, or linked-page duplication. Put qualifying detail on the page; otherwise omit.

**No raw data:** logs, stack traces, command output, API responses, dumps are ephemeral. Distill learning/patterns/decisions: "X error happens when Y", not its log.

**Date-bound artifacts:** retain worthwhile incidents/research/audits/meetings/reviews in `wiki/records/` with `YYYYMMDD-` filenames (e.g., `wiki/records/incidents/20260110-pg-outage.md`).

## Setup

Create `wiki/` only on an explicit setup or creation request, never during automatic consultation or evaluation. Create `wiki/index.md` and parent-linked indexes for every new content folder under Wiki Structure and the Index Entry Contract. Broad setup is multi-role coordinated work: workspace research and architecture analysis, technical writing, and review for consistency.

## <HARD-GATE> Post-Review Ingest Evaluation

This section owns the full ingest criteria. Enter it after review, before the final response, when the boot policy's Learn (pre-check) step is positive or on an explicit wiki task. Once loaded, evaluation is mandatory; writing is optional.

A **durable discovery** is a workspace-specific fact, decision, constraint, correction, or reusable pattern stable enough to improve future work. Durability alone does not qualify. It must add material net value after organization, upkeep cost, ambiguity, and duplication. Never add requested task artifacts or generic, low-value, ambiguous, redundant, transient, or already-captured information.

Evaluate reviewed artifacts and outcomes, verification evidence, user corrections, and any executor `Durable discovery:` line:

1. Would adding an uncaptured workspace-specific decision, convention, constraint, correction, or stable reusable pattern materially improve future decisions or actions?
2. Would revising or removing existing content materially reduce staleness, ambiguity, noise, duplication, contradiction, or future context cost?
3. After a spec is archived, would tacit or workspace-specific knowledge not in the spec, or a pointer to it, materially help future work? Restating or syncing the archived contract does not qualify.

Any clear YES → conditional ingestion. All NO, uncertain, or marginal → no write and no further dispatch.

**Examples:**
- Qualifies: "Run the schema migration before seeding; the seed script fails silently otherwise." The ordering constraint is not visible in either script.
- Does not qualify: "Tests run with `npm test`." It is already visible in the package manifest.

Executors write to the wiki only when the handoff scopes it; optionally return one `Durable discovery: ...` line.

Positive ingestion: consolidate all discoveries into **one serialized stream** owned by a single wiki ingestion writer role; never use parallel writers. The writer deduplicates, decides add/update/remove edits, keeps navigation compliant, and lints; it never alters original deliverables. A no-write return is valid if closer inspection finds no material net value. The coordinator reviews it before responding. On failed review or non-complete status, retry or correct within the same stream, bounded; report unresolved work, never drop it.

Skip redundant ingestion if reviewed deliverables already capture the knowledge, navigation, and consistency correctly. Ingestion never replaces multi-role **Setup**.

**Wiki vs specs:** prescriptive contracts (specs: requirements, scenarios, acceptance) live outside the wiki. The wiki owns durable descriptive knowledge; skills own procedures. Link the contract, never copy or paraphrase it. On conflict the contract wins: delete or shrink wiki restatements, never sync a mirror.

**Wiki vs skill:** the wiki is declarative: what is true or decided in the workspace. Skills are recurring multi-step procedures improved by instruction. Only for clearly procedural AND recurring content, ask: "This reads like a procedure. Turn it into a reusable skill, or keep it in the wiki?" Never create the skill; the user decides. Check existing skills first; adapt, don't duplicate. Skills may consult wiki context at runtime but keep their procedures self-contained.

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
- new-folder indexes and updated parent entries list local pages and immediate child indexes, never descendant page lists; do not migrate existing layouts automatically
- root and folder indexes contain only a title, optional short group headings, and entries that satisfy the Index Entry Contract
- pages not reachable (orphaned) from `wiki/index.md` directly or through folder indexes
- indexes past the split heuristic (~50 lines, or a group over ~10 entries) that merit splitting or reorganization, not automatic changes
- contradictory guidance across pages

Never leave the wiki internally inconsistent after edits.
