# AGENTS.md

This file defines how you operate in this project. Read it fully before acting. These are not suggestions — follow them in every task, every session.

The `wiki/` directory is your only persistent memory. When in doubt, read it first. When you learn something, write it back.

---

## Core Behavior

### Think Before Acting
- State assumptions explicitly before implementing.
- If something is unclear, stop and ask — don't guess silently.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.

### Minimum Viable Change
- Write the least code that solves the problem.
- No speculative features, unused abstractions, or flexibility that wasn't requested.
- If the result could be half the size, rewrite it.

### Surgical Changes
- Don't improve adjacent code, formatting, or comments.
- Match existing style, even if you'd do it differently.
- If you notice unrelated issues, mention them — don't fix them.
- Remove imports/variables/functions that your changes made unused. Leave pre-existing dead code alone unless asked.

### Verify Before Finishing
- Transform tasks into testable goals before starting.
- For multi-step tasks, state a brief plan and confirm with the user before proceeding:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
```

---

## Wiki

Project knowledge base. Lives in `wiki/`. Shared between humans and agents — both read and rely on it.

If `wiki/` does not exist yet, create it when you first learn something worth preserving. One concept per page. `index.md` is mandatory — always keep it updated when pages are added or removed, and always link new pages from there and from related pages.

```
wiki/
├── index.md          # Index of all pages — always up to date
├── architecture.md   # How the system is structured
├── conventions.md    # Code patterns, naming, style
├── domain.md         # Business rules and domain logic
├── decisions.md      # ADRs — why X over Y
├── auth/             # Subdirectory for a topic that grows beyond one page
│   ├── overview.md
│   └── flows.md
└── ...               # Add pages and subdirectories as needed
```

Prefer focused, specific pages over broad ones. Create subdirectories when a topic grows beyond a single page. When a concept depends on another, link to it — pages should reference each other where relevant.

**Three operations**:

- **Ingest** — when something worth preserving is learned, write it into the appropriate wiki page immediately. Don't defer. Link the new content from `index.md` and from any related pages.
- **Query** — before answering any question about the project, check the relevant wiki page first. Never answer from memory alone if a wiki page exists.
- **Lint** — after completing a task, scan for contradictions between pages, orphan pages not linked from `index.md`, and claims that are no longer true. Fix what you find.

When to ingest and when not to:
- ✅ Architectural decision made
- ✅ New pattern or convention identified
- ✅ Domain rule clarified or corrected
- ✅ Something discovered mid-task that would otherwise be lost
- ✅ User explicitly requests an update
- ❌ Routine bug fixes or minor changes with no lasting insight

---

## Context Management

| Strategy | Application |
|---|---|
| Load surgically | Only wiki pages relevant to the current task — not the entire wiki |
| Wiki before source | Check `wiki/` before searching source files for domain knowledge |
| Prefer grep/search | Over loading full files when you need a single reference |
| Rotate at transitions | Drop what the previous state needed. Keep only the task goal and what the next state requires |

---

## Workflow

For non-trivial tasks, follow this sequence:

**PLAN → BUILD → QA → APPROVAL → APPLY → DOCS**

| State | What happens | Exit |
|---|---|---|
| **PLAN** | Read relevant wiki pages. State assumptions. Identify specialist agents to involve if needed (see Specialist Agents). Propose approach with steps and success criteria. | User approves |
| **BUILD** | Implement per approved plan. Delegate to specialists and coordinate their outputs if applicable. Generate a unified diff. Do not apply yet. | Diff ready |
| **QA** | Run tests, linter, build. Report results. Fix failures before proceeding. | All checks pass |
| **APPROVAL** | Present diff and QA results for human review. Wait for explicit approval. | User approves |
| **APPLY** | Apply changes. Verify. Rollback and report if anything fails. | Success or rollback |
| **DOCS** | Update wiki if the task produced something worth preserving. | Done |

- **Simple tasks** (one-line fixes, config changes, clear and isolated changes): skip PLAN and DOCS. Still wait for approval before applying.
- **Approval keywords**: "approved", "looks good", "ship it", "apply it", "document it", "ok", "yes", "go ahead", "do it"
- Never apply changes without explicit approval.
- Always work on a safe copy — never directly on the final destination.
- **Stall**: if the same approach yields no progress after two cycles, stop. Report what's blocking and ask for direction. Maximum 3 BUILD→QA cycles before escalating.

---

## Specialist Agents

If specialist agents are available in your environment, use them. When delegating, briefly tell the user which specialist(s) you chose and why.

- **Single domain** (security, SEO, databases, DevOps, SRE, infrastructure, design, legal, data science, ML): delegate to the appropriate specialist. Do not answer yourself.
- **Multiple domains**: assemble a team. Define what needs to be done, assign to specialists, synthesize their outputs. You are the default orchestrator.
- **Multi-stage execution**: you may hand orchestration to a specialist orchestrator. Give clear objectives and deliverables. Review the final result before presenting to the user.

---

## Non-Negotiables

| Rule | Reason |
|---|---|
| Before creating a file, search for existing functionality to extend | Prevents sprawl and duplication |
| Only create new files when extension is genuinely impossible — say why | Forces reuse analysis |
| No mock or fake data in production code (test fixtures are fine) | Data integrity |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code in plans, diffs, or explanations | Traceability |