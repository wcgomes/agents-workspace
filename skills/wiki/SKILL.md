---
name: wiki
description: Use this skill when querying workspace knowledge before tasks or ingesting learnings after completing work. Self-learning loop for the workspace.
---

# Wiki

Workspace knowledge base and self-improvement loop. The coordinator queries wiki before broad exploration. Ingest learnings after every task.

The wiki exists to eliminate unnecessary codebase exploration. With the right knowledge, the agent goes straight to the relevant code. If exploration is still needed, the wiki narrows the search — focused and directed, not open-ended.

---

## <HARD-GATE> Coordinator Context Before Any Task

The main agent reads `wiki/index.md` BEFORE team composition or workspace exploration. Specialists use handoff context unless wiki lookup is explicitly needed for their scope.

This is the coordinator's first action after receiving a request. The wiki provides context that eliminates unnecessary exploration and guides team assembly.

---

## Design Principle

Wiki files are loaded into agent context. Every line costs tokens.

- **Compact** — short paragraphs, bullet points, no filler
- **Precise** — only information that matters for future tasks
- **Scannable** — clear headings, one topic per file, easy to locate
- **Lean** — if it doesn't help the agent decide or act, remove it
- **index.md is a lookup table** — file paths with descriptions and keywords for quick discovery; no instructions, no rules, no detailed content

Keep it dense. Patterns, conventions, examples — all welcome if compact and actionable. Cut ruthlessly: if a sentence doesn't help the agent decide or act, delete it.

**Never add raw data to the wiki.** Logs, stack traces, command outputs, API responses, dumps, and similar raw data are ephemeral artifacts — not knowledge. The wiki stores distilled insights: what was learned, what pattern was identified, what decision was made. If a log reveals a specific error condition worth remembering, write "X error happens when Y" — not the full log.

---

## Three Operations

**Setup** — create `wiki/` when new knowledge must be persisted and the directory doesn't exist yet. For broad wiki setup/creation, use `orchestrate` roles for Workspace Research / Architecture Analysis and Technical Writing / Documentation; add Review / Consistency when persistent docs are created.

**Query** — coordinator reads `wiki/index.md` first to find relevant pages by description and keywords. Load only those.

**Ingest** — end of every task, the coordinator evaluates automatically if anything was learned.

---

## <HARD-GATE> Auto-Evaluation at End of Task

The coordinator runs this checklist at the end of EVERY task. Do NOT skip.

1. Architectural decision made? → `wiki/decisions/<decision-name>.md`
2. New code pattern or convention? → `wiki/conventions/<pattern-name>.md`
3. Domain rule clarified or corrected? → `wiki/domain/<rule-name>.md`
4. System structure insight? → `wiki/architecture.md`
5. User corrected a misunderstanding? → ingest where relevant
6. Non-obvious multi-step procedure? → evaluate for skill candidate

Any YES → ingest. All NO → skip (but each item must have been evaluated).

If the coordinator is prohibited from editing wiki files directly, delegate the wiki edit as a handoff and review the result before final response.

Do NOT ask "should I update the wiki?" — evaluate automatically.

---

## Wiki Structure

```
wiki/
├── index.md              # Lean reference index — descriptions + keywords only
├── architecture.md       # System structure overview (single file)
├── conventions/          # One file per convention
│   └── <pattern-name>.md
├── domain/               # One file per business rule
│   └── <rule-name>.md
├── decisions/            # One file per ADR
│   └── <decision-name>.md
├── skill-candidates/     # Recurring patterns tracked for skill promotion
│   └── <pattern-name>.md
└── ...
```

This is a starting point. Create additional folders and subfolders as needed — for projects, features, work-in-progress, or any grouping that improves organization. One topic per file, one concept per folder. Keep it navigable.

---

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

---

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

---

## Wiki Maintenance

When the wiki changes, maintain it deliberately.

### Add

Create a new page when the knowledge is new, stable enough to reuse, and not already covered by an existing page.

### Update

Update an existing page when the knowledge already belongs there, a rule was clarified, or a page became incomplete or misleading.

### Remove

Remove a page or section when it is obsolete, contradicted, duplicated elsewhere, or no longer useful. When removing content, also update or remove references from `wiki/index.md` and related pages.

### Lint

When the wiki changes, check for:
- stale references
- missing `wiki/index.md` links for important pages
- contradictory guidance across pages
- orphaned pages that are no longer discoverable from `wiki/index.md`

Do not leave the wiki internally inconsistent after editing it.

---

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "I didn't learn anything new" | Run the checklist. |
| "This is too minor to document" | Minor insights compound. |
| "I'll update it later" | You won't. |
| "Too specific to track" | Track anyway. |
| "The log proves it happened" | Distill the insight, not the raw data. |

---

## Gotchas

- Pages not linked from `index.md` are invisible. Keep index.md updated when pages are added or removed — but keep it lean: descriptions and keywords only.
- Evaluate automatically — don't wait for the user to ask.
