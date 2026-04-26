---
name: skill-candidates
description: Use this skill during wiki ingest when you notice the same procedural pattern or step sequence repeating across 3+ distinct tasks. Activates on pattern detection. Proposes skill creation to the user. Do NOT track declarative knowledge, one-off fixes, or patterns already covered by existing skills.
---

# Skill Candidates

Detect procedural patterns that repeat across tasks in the **current workspace** (where `AGENTS.md` lives). Propose skill creation when a pattern proves itself.

> **Scope:** `wiki/skill-candidates/` is local to the workspace. Skills created from candidates are also local — they live in `.agents/skills/` within the workspace. Existing skills checked for redundancy are those available to the agent (globally installed + loaded).

## When to Activate

Activate during wiki ingest when **all** are true:

1. You just completed a task that required a specific sequence of steps or a non-obvious convention
2. This is the **third or later time** you've encountered this exact pattern in distinct tasks
3. The pattern is procedural (how to do something), not declarative (what something is)
4. **No existing skill covers this pattern.** Check all available skills: globally installed (via tool's skill directory), currently loaded, and `.agents/skills/` in the current workspace before creating a candidate.

**Do NOT activate for:** one-off fixes, architectural decisions, facts about the codebase, or patterns already covered by an existing skill.

## Tracking

One candidate per file in `wiki/skill-candidates/`.

**First encounter:**

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

Add to `wiki/index.md` under `## Skill Candidates`:

```markdown
- [skill-candidates/<pattern-name>.md](skill-candidates/<pattern-name>.md) — [one-line description] (encounters: 1)
```

**Subsequent encounters:**

Read the candidate file. Increment `encounters`. Append one line to `## Trigger` with task context.

When `encounters >= 3` and `status: candidate`, set `status: propose` and ask the user:

> "Pattern '<name>' has appeared in 3+ tasks: [brief description]. Create a skill for it?"

## Promotion

If user approves, follow this exact sequence. Skipping cleanup creates stale candidates and broken index links.

1. **Check for redundancy.** Scan all available skills: globally installed (via tool's skill directory), currently loaded, and `.agents/skills/` in the current workspace. If a similar skill already exists:
   - Abort creation
   - Explain to user: "Skill 'X' already covers this pattern. Absorbing candidate into existing skill instead."
   - Update the existing skill if the candidate adds new context
   - Delete candidate file and remove from `wiki/index.md`
   - Done
2. **Create the skill locally.** Follow `agents-skills/SKILL.md` spec. Create `.agents/skills/<name>/SKILL.md` in the current workspace. Directory name must match `name:` in frontmatter.
3. **Clean up.** Delete candidate file from `wiki/skill-candidates/`. Remove entry from `wiki/index.md`.

**User says no:** set `status: rejected`. Never propose again.

## Examples

- ✅ Third time forgetting to run `prisma migrate dev` after schema edit → candidate → propose skill
- ✅ Third task requiring the same 4-step release checklist → candidate → propose skill
- ❌ Learned the API uses JWT tokens → wiki, not a candidate
- ❌ Found out the project uses pnpm instead of npm → wiki, not a candidate

## Anti-patterns

- Don't create candidates for knowledge that belongs in wiki pages
- Don't wait for 5+ encounters — 3 is enough to validate a pattern
- Don't track if the pattern is specific to a single file or component
- Don't create a candidate if an existing skill already covers the pattern — absorb the insight into the existing skill instead
