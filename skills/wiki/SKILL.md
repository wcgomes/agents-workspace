---
name: wiki
description: Use this skill BEFORE any codebase exploration or task execution — query wiki/index.md first to leverage existing knowledge; never explore blindly. Also use at the end of every task to ingest what was learned. Self-learning loop — never skip ingest. Activates on every task.
---

> **CRITICAL:** Never explore a codebase without first querying `wiki/index.md`. The wiki contains architecture, conventions, and decisions that prevent wasted effort. This is not optional.

# Wiki

Workspace knowledge base. Lives in `wiki/` in the **current working directory** (the workspace where `AGENTS.md` was copied). Self-learning loop — every task leaves the workspace better documented than it found it.

> **Scope:** This skill operates on the workspace being worked on, not on the global skills directory.

## Structure

One concept per page. Focused, specific pages over broad ones. Subdirectories when topic grows beyond single page. Concepts that depend on others → link them.

If `wiki/` doesn't exist, create it immediately with `wiki/index.md`.

```
wiki/
├── index.md              # Index of all pages — always up to date
├── architecture.md       # How the system is structured
├── conventions.md        # Code patterns, naming, style
├── domain.md             # Business rules and domain logic
├── decisions.md          # ADRs — why X over Y
├── skill-candidates/     # Recurring patterns tracked for skill promotion
│   ├── prisma-migrate.md
│   └── api-versioning.md
└── ...                   # Add pages and subdirectories as needed
```

## index.md

Mandatory. Update when pages added or removed. Each entry needs brief description — pages identified without opening:

```markdown
## Pages

- [architecture.md](architecture.md) — how the system is structured
- [auth/overview.md](auth/overview.md) — authentication flow and token lifecycle

## Skill Candidates

- [skill-candidates/prisma-migrate.md](skill-candidates/prisma-migrate.md) — run migrate + generate after schema changes (encounters: 1)
- [skill-candidates/api-versioning.md](skill-candidates/api-versioning.md) — version bump process for API releases (encounters: 3, status: propose)
```

Link new pages from `index.md` and from related pages.

## Three Operations

**Ingest** — end of every task, write what you learned that wasn't in wiki. Mandatory — don't wait to be asked. Update `index.md`, link from related pages.

**Query** — start by reading `wiki/index.md`. Use descriptions to identify relevant pages — load only those. Never answer from memory if wiki page exists.

**Lint** — after task, scan for contradictions, orphan pages not in `index.md`, stale claims. Fix what you find.

## Skill Candidates

When you detect a recurring procedural pattern during ingest, load the `skill-candidates` skill. Do not handle promotion logic inline — delegate to that skill.

## When to Ingest

- ✅ Architectural decision made
- ✅ New pattern or convention identified
- ✅ Domain rule clarified or corrected
- ✅ User explicitly requests update
- ❌ Routine bug fixes or minor changes with no lasting insight

## Gotchas

- Always read `wiki/index.md` first — loading all pages at once wastes context.
- After `index.md` points you to a page, use `grep` to find the section, then `read` with `offset`/`limit` to load only the slice you need. Never pull a large `.md` whole.
- If `index.md` doesn't exist yet, create it before creating any other wiki page.
- Wiki pages that aren't linked from `index.md` are effectively invisible — always update the index.
- Ingest is not optional — skipping it breaks the self-learning loop.
