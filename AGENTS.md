# AGENTS.md

This file defines how you operate in this project. Read it fully before acting. These are not suggestions — follow them in every task, every session.

The `wiki/` directory is your only persistent memory. When in doubt, read it first. When you learn something, write it back.

Before planning any task, identify whether it touches a specialist domain — if so, delegate. See Specialist Agents.

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
- For multi-step tasks, state a brief plan before proceeding — each step with its own success criterion — and confirm with the user.

---

## Non-Negotiables

| Rule | Reason |
|---|---|
| Before creating a file, search for existing functionality to extend | Prevents sprawl and duplication |
| Only create new files when extension is genuinely impossible — say why | Forces reuse analysis |
| No mock or fake data in production code (test fixtures are fine) | Data integrity |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code in plans, diffs, or explanations | Traceability |

---

## Specialist Agents

**Delegation to a specialist agent is the default.** Before handling any task directly, check your available agents. If there is a specialist for this type of work, delegate — even if you could do it yourself. Handling directly is only justified when no relevant specialist exists. When delegating, briefly tell the user which specialist(s) you chose and why.

- **Single domain**: delegate to the appropriate specialist.
- **Multiple domains**: assemble a team. Define what needs to be done, assign to specialists, synthesize their outputs. You are the default orchestrator.
- **Multi-stage execution**: you may hand orchestration to a specialist orchestrator. Give clear objectives and deliverables. Review the final result before presenting to the user.

---

## Wiki

Project knowledge base. Lives in `wiki/`. Shared between humans and agents — both read and rely on it. The wiki is a self-learning loop — every task is an opportunity to leave the project better documented than you found it.

### Structure

One concept per page. Prefer focused, specific pages over broad ones. Create subdirectories when a topic grows beyond a single page. When a concept depends on another, link to it.

If `wiki/` does not exist yet, create it when you first learn something worth preserving.

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

### index.md

`index.md` is mandatory. Always keep it updated when pages are added or removed. Each entry must include a brief description so pages can be identified without opening them:

```markdown
- [architecture.md](architecture.md) — how the system is structured
- [auth/overview.md](auth/overview.md) — authentication flow and token lifecycle
```

Always link new pages from `index.md` and from any related pages.

### Three operations

- **Ingest** — at the end of every task, write what you learned about this project that wasn't in the wiki before. Don't wait to be asked. Update `index.md` and link from related pages.
- **Query** — always start by reading `wiki/index.md`. Use the descriptions to identify relevant pages — load only those. Never answer from memory alone if a wiki page exists.
- **Lint** — after completing a task, scan for contradictions between pages, orphan pages not linked from `index.md`, and claims that are no longer true. Fix what you find.

When to ingest and when not to:
- ✅ Architectural decision made
- ✅ New pattern or convention identified
- ✅ Domain rule clarified or corrected
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
| **PLAN** | Read relevant wiki pages. State assumptions. Identify specialist agents to involve (see Specialist Agents). Propose approach with steps and success criteria. | User approves |
| **BUILD** | Implement per approved plan. Delegate to specialists and coordinate their outputs if applicable. Generate a unified diff. Do not apply yet. | Diff ready |
| **QA** | Run tests, linter, build. Report results. Fix failures before proceeding. | All checks pass |
| **APPROVAL** | Present diff and QA results for human review. Wait for explicit approval. | User approves |
| **APPLY** | Apply changes. Verify. Rollback and report if anything fails. | Success or rollback |
| **DOCS** | Update wiki with what this task taught about the project. | Done |

- **Simple tasks** (one-line fixes, config changes, clear and isolated changes): skip PLAN and DOCS. Still wait for approval before applying.
- **Approval keywords**: "approved", "looks good", "ship it", "apply it", "document it", "ok", "yes", "go ahead", "do it"
- Never apply changes without explicit approval.
- Always work on a safe copy — never directly on the final destination.
- **Stall**: if the same approach yields no progress after two cycles, stop. Report what's blocking and ask for direction. Maximum 3 BUILD→QA cycles before escalating.
