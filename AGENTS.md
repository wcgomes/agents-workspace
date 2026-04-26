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
| `invoke-subagents` | Before any task with implementation, investigation, or multi-step work |
| `wiki` | At task start (query) and end (ingest) |
| `workflow` | Non-trivial tasks with multiple steps or unclear success criteria |
| `think-before-acting` | Before implementing, refactoring, or fixing code |
| `brevity` | Every response and file edit unless user asks for verbosity |
| `minimal-changes` | Any code modification (write, edit, refactor, fix) |
| `parallel-work` | 2+ tasks with no shared state or file overlap |
| `skill-candidates` | During ingest when a procedural pattern repeats across 3+ tasks |

## Non-Negotiables

| Rule | Reason |
|---|---|
| Wiki first — read before exploring, ingest after completing | Self-learning loop |
| Invoke subagent by default — specialist fits → invoke | Better quality, smaller context |
| Before creating a file, search for existing functionality to extend | Prevents sprawl |
| Only create new files when extension is genuinely impossible — say why | Forces reuse |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code | Traceability |
