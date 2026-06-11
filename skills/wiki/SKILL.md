---
name: wiki
description: Use this skill when querying workspace knowledge before tasks or ingesting learnings after completing work. Self-learning loop for the workspace.
---

# Wiki

Workspace knowledge base and self-improvement loop. The coordinator queries wiki before broad exploration; ingest learnings after every task.

The wiki exists to eliminate unnecessary codebase exploration: with the right knowledge the agent goes straight to relevant code; if exploration is still needed, the wiki narrows it — focused and directed, not open-ended.

## <HARD-GATE> Coordinator Context Before Any Task

The main agent reads `wiki/index.md` BEFORE team composition or workspace exploration — this is the coordinator's first action after receiving a request. Specialists use handoff context unless wiki lookup is explicitly needed for their scope.

## Design Principle

Wiki files are loaded into agent context. Every line costs tokens.

- **Compact** — short paragraphs, bullets, no filler
- **Precise** — only information that matters for future tasks
- **Scannable** — clear headings, one topic per file, easy to locate
- **Lean** — if it doesn't help the agent decide or act, remove it
- **index.md is the routing map** — required entrypoint; compact, keyword-rich links to `.md` files only (page or subfolder's `index.md`, never the folder itself); no instructions, rules, or detailed content

Keep it dense. Patterns, conventions, examples — all welcome if compact and actionable. Cut ruthlessly: if a sentence doesn't help the agent decide or act, delete it.

**Never add raw data to the wiki.** Logs, stack traces, command outputs, API responses, and dumps are ephemeral artifacts, not knowledge. Store distilled insights: what was learned, what pattern was identified, what decision was made. If a log reveals an error condition worth remembering, write "X error happens when Y" — not the full log.

**Date-bound artifacts go in `wiki/records/`.** Material from a specific event worth keeping — e.g., incidents, research, audits, meetings, reviews. Use a `YYYYMMDD-` filename prefix (e.g., `wiki/records/incidents/20260110-pg-outage.md`).

## Three Operations

**Setup** — create `wiki/` when new knowledge must be persisted and the directory doesn't exist yet. For broad wiki setup/creation, use `orchestrate` roles for Workspace Research / Architecture Analysis and Technical Writing / Documentation; add Review / Consistency when persistent docs are created.

**Query** — coordinator reads `wiki/index.md` first to route by descriptions and keywords. Choose the most relevant direct page or folder index, then load only relevant linked pages.

**Ingest** — end of every task, the coordinator evaluates automatically if anything was learned.

## <HARD-GATE> Auto-Evaluation at End of Task

The coordinator runs this checklist at the end of EVERY task. Do NOT skip.

1. Architectural decision made? → `wiki/decisions/<NNNN-decision-name>.md`
2. New code pattern or convention? → `wiki/conventions/<pattern-name>.md`
3. Domain rule clarified or corrected? → `wiki/domain/<rule-name>.md`
4. System structure insight? → `wiki/architecture.md`
5. User corrected a misunderstanding? → ingest where relevant
6. Non-obvious multi-step procedure? → evaluate for skill candidate

Any YES → ingest. All NO → skip (but each item must have been evaluated).

If the coordinator is prohibited from editing wiki files directly, delegate the wiki edit as a handoff and review the result before final response.

Do NOT ask "should I update the wiki?" — evaluate automatically.

## Wiki Structure

```
wiki/
├── index.md              # Required routing map — compact descriptions + keywords
├── architecture.md       # System structure overview (single file)
├── conventions/          # One file per convention
│   ├── index.md          # Optional folder index for larger/topic-rich wikis
│   └── <pattern-name>.md
├── domain/               # One file per business rule
│   ├── index.md
│   └── <rule-name>.md
├── decisions/            # One file per ADR
│   └── <NNNN-decision-name>.md
├── skill-candidates/     # Recurring patterns tracked for skill promotion
│   └── <pattern-name>.md
├── records/             # Date-bound artifacts
└── ...
```

This is a starting point. Create additional folders/subfolders as needed — for projects, features, work-in-progress, or any grouping that improves organization. One topic per file, one concept per folder; keep it navigable.

Every wiki page must be reachable from `wiki/index.md`, directly or through linked folder-level `index.md` files. Small wikis may link directly to all pages from root; larger or topic-rich wikis should use folder indexes so the root stays a compact routing map with enough keywords to choose the right path.

As a heuristic, split when `wiki/index.md` exceeds ~50 lines OR a single topic group exceeds ~10 entries: move that group into a folder-level `index.md` and link the folder index from root instead of the individual pages. Guidance, not law — apply judgment, but they're easy to check by counting.

### Navigation

1. Read `wiki/index.md` first.
2. Pick the most relevant direct page or folder index from the keywords.
3. If you open a folder index, read only the linked pages that match the task.
4. Don't open broad or unrelated wiki areas just because they exist.

## <HARD-GATE> Auto Skill-Candidate Evaluation

If you performed a non-obvious sequence of steps that could apply to future tasks, evaluate for skill candidate.

**Activate when ALL:**
- Multi-step procedure (3+ steps)
- Required domain knowledge or convention (not obvious)
- Could apply to future similar tasks

**Skip when:**
- One-line change with no domain knowledge
- Already covered by existing skill
- Standard tool operations with no domain-specific logic

## Skill Candidate Tracking

One candidate per file in `wiki/skill-candidates/`.

### Track (1st or 2nd encounter)

Create `wiki/skill-candidates/<pattern-name>.md`:

```markdown
---
name: <pattern-name>
encounters: 1
status: candidate
---

## Trigger
[brief: what task context activates this]

## Why a skill
[what goes wrong or gets missed without it]
```

### Propose (3rd+ encounter)

When `encounters >= 3` and `status: candidate`, set `status: propose` and ask user.

### Promotion Sequence

1. Check for redundancy (globally installed skills + workspace skills)
2. Create skill locally at `.agents/skills/<name>/SKILL.md`
3. Delete candidate file

## Wiki Maintenance

When the wiki changes, maintain it deliberately.

- **Add** — create a page when the knowledge is new, stable enough to reuse, and not already covered.
- **Update** — when the knowledge already belongs on a page, a rule was clarified, or a page became incomplete or misleading.
- **Remove** — when a page/section is obsolete, contradicted, duplicated elsewhere, or no longer useful. Also update or remove references from `wiki/index.md` and related pages.

### Lint

When the wiki changes, check for:
- stale references
- index links point to `.md` files, not folders
- pages not reachable (orphaned) from `wiki/index.md` directly or through folder indexes
- root index past the split heuristic (~50 lines, or a group over ~10 entries) that should move to a folder index
- contradictory guidance across pages

Do not leave the wiki internally inconsistent after editing it.

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "I didn't learn anything new" | Run the checklist. |
| "This is too minor to document" | Minor insights compound. |
| "I'll update it later" | You won't. |
| "Too specific to track" | Track anyway. |
| "The log proves it happened" | Distill the insight, not the raw data. |

## Gotchas

- Pages not reachable from `wiki/index.md` are invisible. Keep root and folder indexes updated when pages are added, moved, or removed — but keep them lean: descriptions and keywords only.
- Evaluate automatically — don't wait for the user to ask.
