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

**Query** — start by reading `wiki/index.md`. Use descriptions to identify relevant pages — load only those. Never answer from memory if wiki page exists.

**Ingest** — end of every task, evaluate what you learned that wasn't in wiki. **Automatic** — do NOT wait for the user to ask. Run the auto-evaluation checklist below. Update `index.md`, link from related pages.

**Lint** — after task, scan for contradictions, orphan pages not in `index.md`, stale claims. Fix what you find.

## Skill Candidates

When you detect a recurring procedural pattern during ingest, load the `skill-candidates` skill immediately. Do not handle promotion logic inline — delegate to that skill.

---

## <HARD-GATE> Auto-Evaluation at End of Task

At the end of EVERY task, you MUST run this checklist. Do NOT skip it. Do NOT decide "there's nothing to ingest" without evaluating.

**Ingest Evaluation — answer each question:**

1. Did this task involve an architectural decision? → Ingest to `decisions.md`
2. Did this task reveal a new code pattern or convention? → Ingest to `conventions.md`
3. Did this task clarify or correct a domain rule? → Ingest to `domain.md`
4. Did this task uncover something about the system structure? → Ingest to `architecture.md`
5. Did the user correct a misunderstanding? → Ingest wherever relevant
6. Did this task involve a non-obvious sequence of steps? → Load `skill-candidates` skill and evaluate

**If any answer is YES → ingest. If all are NO → skip ingest (but you must have evaluated each).**

You do NOT need to ask the user "should I update the wiki?" — you evaluate automatically. Only ask if the scope of the update is ambiguous, not whether to update at all.

---

## <HARD-GATE> Auto Skill-Candidate Evaluation

During ingest, if you performed a non-obvious sequence of steps that could apply to future tasks, you MUST load the `skill-candidates` skill and evaluate whether this pattern has been seen before.

**Auto-activate skill-candidates when:**
- You followed a multi-step procedure (3+ steps)
- The procedure was not obvious (required domain knowledge or convention)
- The procedure could apply to future similar tasks

**Do NOT auto-activate when:**
- The fix was a one-line change with no domain knowledge required
- The procedure is already covered by an existing skill
- The steps are standard tool operations with no domain-specific logic (e.g., "ls to list files")

---

## When to Ingest

- ✅ Architectural decision made
- ✅ New pattern or convention identified
- ✅ Domain rule clarified or corrected
- ✅ User explicitly requests update
- ✅ User corrected a misunderstanding
- ✅ Non-obvious procedure discovered (→ also evaluate skill candidate)
- ❌ Standard tool operations with no domain-specific learning (e.g., "ran ls, found file")

---

## Rationalization Prevention

These are excuses agents use to skip wiki ingest. None are valid.

| Excuse | Reality |
|--------|---------|
| "I didn't learn anything new" | Run the auto-evaluation checklist. You may have learned something you didn't notice. |
| "This is too minor to document" | Minor insights compound. If it clarified something, ingest it. |
| "Everyone knows this" | "Everyone" doesn't include the next agent session. Document it. |
| "I'll update the wiki later" | You won't. Do it now while the context is fresh. |
| "The wiki is already up to date" | Run the checklist to verify. Don't assume. |
| "This pattern is too specific to track" | That's for the skill-candidates skill to decide. Load it and evaluate. |
| "No need to ask the user, I'll just skip it" | You don't need to ask. You need to evaluate automatically. Run the checklist. |

---

## Red Flags — Self-Check

If you catch yourself thinking any of these, STOP. You are about to skip mandatory wiki operations.

- "Nothing to ingest this time"
- "I'll skip the wiki for this one"
- "This is obvious, no need to document"
- "The user didn't ask me to update the wiki"
- "I'll do the wiki stuff later"
- "No skill candidate here, it's too specific"
- "I already know what happened, no need to write it down"

---

## Gotchas

- Always read `wiki/index.md` first — loading all pages at once wastes context.
- After `index.md` points you to a page, use `grep` to find the section, then `read` with `offset`/`limit` to load only the slice you need. Never pull a large `.md` whole.
- If `index.md` doesn't exist yet, create it before creating any other wiki page.
- Wiki pages that aren't linked from `index.md` are effectively invisible — always update the index.
- Ingest is not optional — skipping it breaks the self-learning loop.
- Skill candidate evaluation is not optional — skipping it breaks the process improvement loop.
- Asking the user "should I update the wiki?" is a failure — you should evaluate automatically.
