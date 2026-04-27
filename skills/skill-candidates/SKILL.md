---
name: skill-candidates
description: Use this skill during wiki ingest when you detect a procedural pattern that could apply to future tasks. Track from first encounter, propose skill creation at 3+ encounters. Activates on every ingest evaluation. Do NOT track declarative knowledge, one-off fixes, or patterns already covered by existing skills.
---

# Skill Candidates

Detect procedural patterns that repeat across tasks in the **current workspace** (where `AGENTS.md` lives). Propose skill creation when a pattern proves itself.

> **Scope:** `wiki/skill-candidates/` is local to the workspace. Skills created from candidates are also local — they live in `.agents/skills/` within the workspace. Existing skills checked for redundancy are those available to the agent (globally installed + loaded).

---

## <HARD-GATE> Auto-Activation During Ingest

When running wiki ingest (via `wiki` skill), you MUST evaluate whether this task involved a procedural pattern worth tracking. Do NOT wait passively for patterns to "appear" — actively assess after every task.

**Auto-activate when ALL are true:**

1. You just completed a task that required a specific sequence of steps or a non-obvious convention
2. The procedure could apply to future similar tasks
3. The pattern is procedural (how to do something), not declarative (what something is)
4. No existing skill covers this pattern

**Do NOT activate for:** one-off fixes, architectural decisions, facts about the codebase, standard tool operations with no domain-specific logic, or patterns already covered by an existing skill.

---

## When to Track vs Propose

Auto-activation always triggers evaluation. The question is what to DO:

- **First or second encounter** → create/update candidate file, increment encounters. Track it.
- **Third or later encounter** → set `status: propose`, ask user if they want to create a skill.

Do NOT skip tracking because "it's only the first time." Do NOT wait until the third encounter to start tracking. Track immediately, propose at 3+.

---

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

---

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

---

## Examples

- ✅ Third time forgetting to run `prisma migrate dev` after schema edit → candidate → propose skill
- ✅ Third task requiring the same 4-step release checklist → candidate → propose skill
- ✅ First time encountering a non-obvious multi-step deploy procedure → track as candidate (encounters: 1)
- ❌ Learned the API uses JWT tokens → wiki, not a candidate
- ❌ Found out the project uses pnpm instead of npm → wiki, not a candidate

---

## Rationalization Prevention

These are excuses agents use to skip skill candidate evaluation. None are valid.

| Excuse | Reality |
|--------|---------|
| "This pattern is too specific" | Track it anyway. If it doesn't repeat, it stays at encounters: 1. No harm done. |
| "I only saw this once" | First encounter = track. You can't know if it'll repeat until you track it. |
| "This is obvious, no skill needed" | Obvious to you ≠ obvious to the next agent session. Track it. |
| "An existing skill probably covers this" | Check. Don't assume. If it does, absorb. If it doesn't, track. |
| "I'll remember this pattern" | You won't. That's what the tracking system is for. |
| "Not worth creating a skill for" | That's for the user to decide at encounters: 3. Track it now. |

---

## Red Flags — Self-Check

If you catch yourself thinking any of these, STOP. You are about to skip skill candidate evaluation.

- "No skill candidate here"
- "This is too specific to track"
- "I'll skip the candidate evaluation"
- "This pattern won't repeat"
- "No need to create a candidate file"
- "This is just a one-off" (before evaluating if it could repeat)

---

## Anti-patterns

- Don't create candidates for knowledge that belongs in wiki pages
- Don't wait for 5+ encounters — 3 is enough to validate a pattern
- Don't track if the pattern is specific to a single file or component
- Don't create a candidate if an existing skill already covers the pattern — absorb the insight into the existing skill instead
- Don't skip evaluation — run the auto-activation checklist even if you think there's nothing to track
