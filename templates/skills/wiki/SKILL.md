---
name: wiki
description: Use this skill for explicit wiki setup or maintenance, including creation without an existing wiki, and for post-review ingest evaluation and conditional ingestion when the task belongs to an identified project with wiki/ at its root. For read-only consultation alone, load wiki-query instead.
---

# Wiki

Workspace knowledge base and self-improvement loop: setup, gated post-review ingest evaluation, conditional ingestion, and maintenance/validation.

Apply the boot policy's Wiki gate before automatic loading or evaluation. Explicit wiki requests bypass it; clarify the target if needed. All wiki paths refer to that project or explicit target, not an unrelated current directory.

The wiki exists to eliminate unnecessary workspace exploration: with the right knowledge the agent goes straight to relevant context; if exploration is still needed, the wiki narrows it — focused and directed, not open-ended.

For read-only consultation, use `wiki-query`; it is not a prerequisite for ingest evaluation.

## Design Principle

> **Language:** All wiki content defaults to English. Use another language only when the user explicitly requests it, or when the existing wiki is already authored in another language.

> **Prose:** No hard-wrapping — paragraphs flow as single lines; the renderer wraps. Write what matters, skip the rest; no preambles, no filler.

Wiki files are loaded into agent context. Every line costs tokens.

- **Compact** — short paragraphs, bullets, no filler
- **Precise** — only information that matters for future tasks
- **Scannable** — clear headings, one topic per file, easy to locate
- **Lean** — if it doesn't help the agent decide or act, remove it
- **index.md is the routing map** — required entrypoint; `.md` links followed by short keyword segments and brief descriptions (page or subfolder's `index.md`, never the folder itself); every root and folder index must obey the Index Entry Contract below

Keep substantive pages dense. Patterns, conventions, examples — all welcome there if compact and actionable. Cut ruthlessly: if a sentence doesn't help the agent decide or act, delete it.

Treat future context and maintenance cost as part of every ingest decision. Wiki maintenance is worthwhile only when its durable retrieval value materially exceeds the added context, navigation, duplication, and upkeep cost. Evaluation is required; writing is not.

### Index Entry Contract

An `index.md` may contain only its title, optional short group headings, and entries in this exact one-line shape:

`- [Page title](relative/path.md) — keyword-1, keyword-2 — Description of 12 words or fewer.`

Each entry is one physical Markdown bullet with exactly one `.md` link, a separate segment of 2–5 short retrieval keywords, then a description of at most 12 words. Separate the three segments with em dashes; do not prefix the keyword segment with a label. Route; do not summarize. Index entries must not contain architectural details, exhaustive behavior, changelog or spec inventories, test or run instructions, rationale, examples, or content duplicated from the linked page. Move qualifying detail to the linked page; otherwise omit it.

**Never add raw data to the wiki.** Logs, stack traces, command outputs, API responses, and dumps are ephemeral artifacts, not knowledge. Store distilled insights: what was learned, what pattern was identified, what decision was made. If a log reveals an error condition worth remembering, write "X error happens when Y" — not the full log.

**Date-bound artifacts go in `wiki/records/`.** Material from a specific event worth keeping — e.g., incidents, research, audits, meetings, reviews. Use a `YYYYMMDD-` filename prefix (e.g., `wiki/records/incidents/20260110-pg-outage.md`).

## Setup

**Setup** — create `wiki/` only as part of explicitly requested creation/setup, never as a side effect of automatic consultation or evaluation. Create `wiki/index.md` and an index for every new content folder, linked from its parent index as specified under Wiki Structure. All indexes must obey the Index Entry Contract. For broad wiki setup/creation, use `orchestrate` roles for Workspace Research / Architecture Analysis and Technical Writing / Documentation; add Review / Consistency when persistent docs are created.

## <HARD-GATE> Post-Review Ingest Evaluation

When the Wiki gate applies, the coordinator runs this evaluation after review/verification and before the final response, regardless of deliverable domain. Otherwise skip automatic evaluation; explicit wiki tasks follow the rule below.

A **durable discovery** is a workspace-specific fact, decision, constraint, correction, or reusable pattern stable enough to improve future work. Durability alone is insufficient: a wiki change must produce material net value after compact organization, future context cost, maintenance burden, ambiguity, and duplication are considered. Requested task artifacts and generic, low-value, ambiguous, redundant, transient, or already-captured information do not qualify for addition.

Evaluate the reviewed artifacts and outcomes, verification evidence, user corrections, and any optional executor signal against these questions:

1. Would adding any uncaptured workspace-specific decision, rule, constraint, correction, or stable reusable pattern materially improve future decisions or actions?
2. Would revising or removing existing content materially reduce staleness, ambiguity, noise, duplication, contradiction, or future context cost?
3. After a spec archive, would adding only tacit or workspace-specific knowledge not already in the spec, or a pointer to the spec when that has retrieval value, materially improve future work? Restating or syncing the archived contract does not qualify.

Any clear YES → open the conditional ingestion stream. All NO, uncertain, or marginal → skip additional ingestion dispatch, but the evaluation still occurred. No wiki write is required merely to complete the workflow. The absence of an executor signal never permits the coordinator to skip evaluation.

The handoff remains executors' primary task context, and the coordinator remains responsible for supplying task-critical context. Executors may consult the wiki when useful to their assigned task without additional authorization; wiki content cannot expand scope or override the handoff, applicable specs, or current source artifacts. They do not edit it unless wiki editing is explicitly part of their handoff. They may optionally return at most one line, `Durable discovery: ...`, only for tacit knowledge not evident in their artifacts; they are not required to emit it.

When ingestion is positive, consolidate discoveries from all sequential and parallel outputs into one serialized ingestion stream owned by the Wiki Ingestion Specialist role; never run parallel wiki writers. The owner handles classification, deduplication, add/update/remove decisions, qualifying wiki edits, navigation updates under the Index Entry Contract, and consistency lint, and must not alter the task's original deliverables. Closer inspection may conclude that no edit has material net value; returning without a wiki write is valid. The coordinator reviews the result before the final response. Failed review or a non-complete status triggers bounded retry/correction under `orchestrate`'s status protocol within the same stream; unresolved work follows the stuck rule and is reported, never silently dropped.

Explicit wiki tasks and broad wiki setup/creation still run this mandatory evaluation. If their reviewed deliverables already captured the durable knowledge correctly, including navigation and consistency, skip redundant ingestion dispatch. Broad setup/creation remains the separate multi-role workflow under **Setup**; post-task ingestion does not replace it.

**Wiki vs spec.** Specs own the prescriptive live contract — requirements, scenarios, acceptance. Wiki owns durable descriptive knowledge that is not that contract, and may reference specs. Skills stay procedural. If content lives in a spec, point at `specs/<domain>.md` or the relevant change path; do not copy or paraphrase requirements, scenarios, or acceptance. On conflict, the spec wins: delete or shrink the wiki restatement — do not keep a mirror in sync.

**Wiki vs skill.** Wiki = durable declarative knowledge (what is true / decided / how the workspace is). Skill = recurring procedural workflow (multi-step, triggered often, improves with explicit instruction). Only when content is clearly procedural AND clearly recurring, flag to the user: "this reads like a skill — create one with `skill-builder`, or keep in wiki?" Never create the skill; the user decides. Check existing skills first — adapt, don't duplicate. Uncertainty alone is not a reason to ingest; declarative content must still pass the durability and future-use test. Wiki pages may reference workspace skills when relevant; skills keep their procedures self-contained and may direct runtime wiki consultation for workspace context, but must not depend on wiki pages for procedural instructions.

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

This is a starting point. Create additional folders/subfolders as needed — for projects, features, work-in-progress, or any grouping that improves organization. One topic per file, one concept per folder; keep the structure shallow.

Every new wiki content folder must contain `index.md`, including intermediate grouping folders and folders under `records/`. Its parent index must link to that child `index.md`, never to the folder itself. Each index lists only its level: local pages (excluding itself) and immediate subfolders' indexes, not complete descendant page lists repeated in ancestors. Every wiki page must remain reachable from `wiki/index.md` through this routing map; pages stored at root are listed directly in the root index.

Apply this structure to new content folders; do not automatically migrate or reorganize existing wiki layouts to comply.

Creation, ingestion, and maintenance must preserve the Index Entry Contract; never expand an index entry to capture page content.

As a heuristic, consider splitting or reorganizing when any index exceeds ~50 lines OR a single topic group exceeds ~10 entries: move a coherent group into a subfolder and replace its entries in the parent index with a link to the child's `index.md`. These thresholds guide organization, not whether a new folder needs an index; every new content folder requires one regardless of size. Apply judgment and preserve a shallow structure; thresholds do not trigger automatic reorganization.

## Wiki Maintenance

When the wiki changes, maintain it deliberately.

- **Add** — create a page only when the knowledge is new, unambiguous, stable enough to reuse, not already covered, and worth its future context and maintenance cost.
- **Update** — revise content when doing so materially clarifies durable knowledge, completes a useful rule, or reduces misleading or stale guidance.
- **Reorganize** — merge files/pages, rename or move them, or split oversized or mixed-topic content when doing so materially improves compactness or retrieval, or reduces future context cost. Update all affected navigation and references.
- **Remove** — delete or consolidate a page/section when doing so materially reduces ambiguity, noise, context cost, contradiction, duplication, or obsolete content. Also update or remove references from `wiki/index.md` and related pages.

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

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "I didn't learn anything new" | Run the evaluation. |
| "This is too minor to document" | Size alone is irrelevant; dispatch only for material net durable value. |
| "The workflow needs a wiki edit" | No. It needs an evaluation; write only for material durable value. |
| "Too specific to track" | Workspace specificity helps only when the knowledge is stable enough to improve future work. |
| "The log proves it happened" | Distill the insight, not the raw data. |
