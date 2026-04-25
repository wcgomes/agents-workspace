# Architecture

AI agent-driven development workspace template.

## Directory Structure

```
/repos/agents/
├── AGENTS.md              # Boot instructions + skill index (required)
├── README.md              # Workspace overview
├── wiki/                  # Persistent workspace memory
│   ├── index.md           # Entry point — always up to date
│   ├── architecture.md    # This file
│   └── conventions.md    # Patterns and conventions
└── .agents/
    └── skills/           # Loadable skills (7 skills)
        ├── invoke-subagents/
        ├── workflow/
        ├── think-before-acting/
        ├── wiki-ops/
        ├── minimum-viable-change/
        ├── brevity/
        └── parallel-work/
```

## Boot Sequence

1. Agent reads `AGENTS.md` — required
2. Queries `wiki/index.md` — source of truth
3. Loads `invoke-subagents` skill — invokes specialist subagent
4. Skills load on demand based on context

## Core Components

### AGENTS.md
Defines behaviors, patterns, and persistent memory. Contains:
- Required boot sequence
- Skills table and activation triggers
- Non-negotiable rules

### wiki/
Self-learning loop. Agent:
- Queries before each task
- Updates after each task

### skills/
Source-only behavioral rules (not loaded by tools). Each skill:
- Contains the skill definition
- Is installed globally via install-skills.sh
- Keeps tools' global space clean

## Architectural Decisions

- **Subagent-driven**: every task delegates to specialist. Isolated context = more focus.
- **Self-learning wiki**: persistent knowledge across sessions.
- **Skills on-demand**: load only what's needed, lean context.

## Relationships

- `AGENTS.md` references `wiki/index.md`
- Skills depend on `AGENTS.md` for initial context
- Wiki updates after tasks complete (wiki-ops skill)

See also: [conventions.md](conventions.md)