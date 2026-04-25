# Agents Workspace

Workspace template for AI-agent-driven development. Defines behaviors, patterns, and persistent memory so agents work with quality and consistency.

## Why

AI agents without guidance repeat mistakes, bloat context, make careless changes, and don't learn from prior work. This workspace solves that with three ideas:

1. **Subagent-driven development** — every task is delegated to a specialist subagent. Isolated context per task = more focus, less noise. Independent tasks run in parallel.
2. **Self-learning wiki** — `wiki/` is the workspace's persistent memory. Consulted before each task, updated after each task. The agent learns on its own.
3. **On-demand skills** — behavioral rules live in loadable skills. The agent only loads what it needs, keeping the context window lean.

## How It Works

1. Agent reads `AGENTS.md` on boot — mandatory boot sequence.
2. Consults `wiki/index.md` — workspace source of truth.
3. Invokes specialist subagent for the task — always, no exceptions.
4. Skills load on demand — each activates in a specific context.

## Structure

```
AGENTS.md                  # Boot instructions + skill index
wiki/                      # Persistent workspace memory
  index.md                 # Entry point — always up to date
skills/                    # Loadable skills
  invoke-subagents/        # When: before every task
  wiki/                    # When: knowledge query/ingest
  workflow/                # When: non-trivial tasks
  think-before-acting/     # When: before implementing
  minimum-words/           # When: all responses
  minimum-viable-change/   # When: all code changes
  surgical-changes/        # When: all code edits
  parallel-agents/         # When: 2+ independent tasks
```

## Usage

Point your AI agent at this repo. It reads `AGENTS.md` on boot, follows the sequence, and loads skills as needed.

Works with any agent that supports `AGENTS.md` and markdown-based skills (Claude Code, OpenCode, Cursor, etc.).
