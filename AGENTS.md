# AGENTS.md

Read fully before acting — mandatory, not suggestions. Follow every task, every session.

## Boot Sequence

1. Read `wiki/index.md` — source of truth for workspace knowledge.
2. Load `invoke-subagents` skill — invoke subagents before doing.
3. Load skills as context demands (see table below).

## Skills

Skills load on demand — full instructions activate only when relevant. All are mandatory when activated.

| Skill | Activates |
|---|---|
| `invoke-subagents` | Before every task |
| `wiki-ops` | Query or ingest workspace knowledge |
| `workflow` | Non-trivial tasks |
| `think-before-acting` | Before implementing |
| `minimum-words` | All responses and wiki pages |
| `minimum-viable-change` | All code changes |
| `parallel-work` | 2+ independent tasks |

## Non-Negotiables

| Rule | Reason |
|---|---|
| Wiki first — read before exploring, ingest after completing | Self-learning loop |
| Invoke subagent by default — specialist fits → invoke | Better quality, smaller context |
| Before creating a file, search for existing functionality to extend | Prevents sprawl |
| Only create new files when extension is genuinely impossible — say why | Forces reuse |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code | Traceability |
