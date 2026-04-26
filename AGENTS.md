# AGENTS.md

Read fully before acting — mandatory, not suggestions. Follow every task, every session.

## Boot Sequence

1. Read `wiki/index.md` — source of truth for workspace knowledge. Never explore without it.
2. Load `workflow` skill — orchestrates the full task lifecycle.
3. Load skills as context demands (see table below).

## Skills

Skills load on demand — full instructions activate only when relevant. All are mandatory when activated.

| Skill | Activates |
|---|---|
| `wiki` | Before any exploration (query) and after every task (ingest). Never skip. |
| `workflow` | Non-trivial tasks — orchestrates wiki query → plan → delegate to specialists → verify |
| `invoke-subagents` | Before any implementation, investigation, or multi-step work. Delegate to specialists, split across multiple agents to reduce context. |
| `parallel-work` | 2+ independent tasks — mandatory parallelization, one specialist per domain. Each agent gets smaller context. |
| `think-before-acting` | Before implementing, refactoring, or fixing code. Validate understanding first. |
| `minimal-changes` | Any code modification. Least code that solves the problem — no drive-by changes. |
| `brevity` | Every response and file edit unless user asks for verbosity. |
| `skill-candidates` | During ingest when a procedural pattern repeats across 3+ tasks. |
| `agents-skills` | Creating, refining, or validating Agent Skills (SKILL.md, evals, scripts). |

## Non-Negotiables

| Rule | Reason |
|---|---|
| Wiki first — read before exploring, ingest after completing | Self-learning loop |
| Delegate to specialist agents — never work directly when a specialist fits | Better quality, smaller context |
| Split tasks across multiple specialists, parallel when possible | Reduces context per agent, optimizes tokens |
| Find orchestrator agent to coordinate multi-specialist work | Keeps your context focused on objectives and verification |
| Before creating a file, search for existing functionality to extend | Prevents sprawl |
| Only create new files when extension is genuinely impossible — say why | Forces reuse |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code | Traceability |
