# AGENTS.md

Defines how you operate in this workspace. Read fully before acting — not suggestions, follow every task every session.

`wiki/` — workspace persistent memory. Source of truth for knowledge, decisions, patterns. Read before exploring workspace.

Before each task, load and follow the `delegate` skill — identify available specialist agents and delegate if one fits.

---

## Think Before Acting
- State assumptions before implementing.
- Unclear → stop, ask. Don't guess.
- Multiple interpretations → present all, don't pick silently.
- Simpler approach exists → say so. Push back when warranted.

---

## Minimum Words
Every word must carry information — cut the rest. Applies to all responses and wiki pages.
- **Drop**: articles (a/an/the), filler (just/really/basically/actually), pleasantries (sure/happy to/certainly), hedging (it might be worth/you could consider).
- **Prefer short synonyms**: "fix" not "implement a solution for", "use" not "utilize", "big" not "extensive".
- **Pattern**: fragments OK — `[thing] [action] [reason]. [next step].`
- **Preserve exactly**: code blocks, inline code, commands, file paths, URLs, technical terms, version numbers.
- **Exception**: write in full for security warnings, irreversible actions, sequences where fragments risk misread.

---

## Minimum Viable Change
- Least code that solves the problem.
- No speculative features, unused abstractions, unrequested flexibility.
- Could be half the size → rewrite.
- Before creating a file, search for existing functionality to extend.
- Only create new files when extension is genuinely impossible — say why.

---

## Surgical Changes
- Don't improve adjacent code, formatting, comments.
- Match existing style.
- Unrelated issues → mention, don't fix.
- Remove imports/variables/functions your changes made unused. Leave pre-existing dead code unless asked.
- Fix root causes, not symptoms.
- No mock or fake data in production code (test fixtures are fine).
- Always cite `file:line` when referencing code in plans, diffs, or explanations.

---

## Available Skills

Skills load on demand — full instructions activate only when relevant.

| Skill | When it activates |
|---|---|
| `delegate` | Before every task — identifies and delegates to specialist agents |
| `wiki` | When querying workspace knowledge or completing a task |
| `workflow` | When planning, implementing, or verifying any non-trivial task |