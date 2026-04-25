---
name: wiki
description: Manages workspace knowledge in wiki/. Use when querying anything about the workspace (architecture, conventions, domain, decisions) or at the end of any task to ingest what was learned. Activates for knowledge lookup, documentation updates, and post-task learning.
---

# Wiki

Workspace knowledge base. Lives in `wiki/`. Self-learning loop — every task should leave the workspace better documented.

## Structure

One concept per page. Focused, specific pages over broad ones. Subdirectories when topic grows beyond single page. Concepts that depend on others → link them.

If `wiki/` doesn't exist, create when first learning something worth preserving.

```
wiki/
├── index.md          # Index of all pages — always up to date
├── architecture.md   # How the system is structured
├── conventions.md    # Code patterns, naming, style
├── domain.md         # Business rules and domain logic
├── decisions.md      # ADRs — why X over Y
├── auth/             # Subdirectory for topic that grows beyond one page
│   ├── overview.md
│   └── flows.md
└── ...               # Add pages and subdirectories as needed
```

## index.md

Mandatory. Update when pages added or removed. Each entry needs brief description — pages identified without opening:

```markdown
- [architecture.md](architecture.md) — how the system is structured
- [auth/overview.md](auth/overview.md) — authentication flow and token lifecycle
```

Link new pages from `index.md` and from related pages.

## Three operations

**Ingest** — end of every task, write what you learned that wasn't in wiki. Don't wait to be asked. Update `index.md`, link from related pages.

**Query** — start by reading `wiki/index.md`. Use descriptions to identify relevant pages — load only those. Never answer from memory if wiki page exists.

**Lint** — after task, scan for contradictions, orphan pages not in `index.md`, stale claims. Fix what you find.

## When to ingest and when not to

- ✅ Architectural decision made
- ✅ New pattern or convention identified
- ✅ Domain rule clarified or corrected
- ✅ User explicitly requests update
- ❌ Routine bug fixes or minor changes with no lasting insight

## Gotchas
- Always read `wiki/index.md` first — never load all pages at once.
- If index doesn't exist yet, create it before creating any other wiki page.
- Wiki pages follow Minimum Words — dense, direct, no fluff.