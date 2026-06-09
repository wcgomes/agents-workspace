# Agents Workspace

**AI Agent toolkit** designed to create a professional workflow with dynamic team assembly of specialized agents tailored to each task, parallel execution, optimized context windows, and a self-learning cycle to handle any kind of task.

> **Powered by [🎭 The Agency](https://github.com/msitarzewski/agency-agents)** — A complete AI agency at your fingertips. Specialized agents across 15 divisions: Engineering, Design, Marketing, Sales, Product, Project Management, Testing, Support, Paid Media, Finance, Strategy, Game Development, Spatial Computing, Academic.

## How it works 

**Describe what you want** — the main agent never executes the work itself; it assembles the right team of specialists, delegates every unit of work, reviews the results, and synthesizes them. Along the way, it builds a knowledge base in the wiki that makes future tasks faster and more accurate. You stay in control: suggest agents, adjust the team, or take over at any point.

**Your main agent context stays clean** — debug data, tool logs, and raw code live inside the subagents. The main agent keeps its context focused on your task and conversation.

## Workflow details

1. **The One Rule** — the main agent never does the work. It delegates every unit to a subagent. Before any tool call, a self-check confirms the action is allowed: read wiki, talk to user, or dispatch subagent. Everything else is delegated — no size threshold.
2. **Team-driven workflow** — main agent reads `wiki/index.md` for context, loads `orchestrate`, then composes the team: analyze domains, discover specialists, size the team, select coordination pattern, plan execution order. Generalist execution is fallback only.
3. **Structured delegation** — each handoff uses a canonical shape: task, objective, scope, done criteria, constraints, deliverable, return format. Specialists execute the handed scope directly.
4. **Parallel specialist teams** — independent scopes dispatched to multiple specialists simultaneously.
5. **Automatic wiki maintenance** — main agent reads `wiki/index.md` before broad exploration, then evaluates adds, updates, removals, and linting after every task. Self-learning loop — no need to ask.
6. **Automatic skill candidate tracking** — detects recurring procedural patterns. Tracks from first encounter, proposes at 3+.
7. **Anti-rationalization tables** — every skill anticipates excuses agents use to skip steps and refutes them.
8. **Controlled subdelegation** — specialists may subdelegate when specialization improves the task. Accountability stays with the delegator; subscopes follow the same rules.
9. **Role preservation** — roles from team composition are mandatory. Adjacent match or generic agent fills gaps. Roles are never dropped or collapsed into one handoff unless there's an explicit quality reason and verification is not reduced.

| Mechanism | Skill | What it does |
|---|---|---|
| **Orchestration** | `orchestrate` | Full coordination cycle: analyze domains, discover specialists, compose team, plan execution, handoff, review and synthesize. |
| **Self-learning wiki** | `wiki` | Reads `wiki/index.md` before broad exploration, then evaluates adds, updates, removals, and linting after tasks. Tracks skill candidates. |
| **Skill authoring** | `agents-skills` | Creates, refines, and validates Agent Skills following the agentskills.io spec. |

Skills load **on-demand**: `wiki` for context first, then `orchestrate` for planning or executing delegated work.

## Setup in 4 steps

> Just portable skills and a single `AGENTS.md` file. No hooks, plugins, or platform-specific configuration.

**Step 1 — Install skills and agents globally**

One-time setup. The agent loads only what each task needs.

**Via curl:**
```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Or clone and run locally:**
```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install.sh
```

**Step 2 — Copy `AGENTS.md` into your workspace**

```bash
cp AGENTS.md /path/to/your-project/
```

`AGENTS.md` is the boot contract. The agent reads it on every session start. It defines the operating mode (The One Rule: the main agent never executes, it delegates every unit of work to a subagent) and the flow: read context, compose the specialist team, delegate to best semantic match, review, and synthesize. It is **not** installed globally.

**Step 3 — Let the agent create `wiki/`**

The agent may create `wiki/` when setup is explicit, or when the `wiki` skill needs to ingest, maintain, or persist new knowledge. After that, the main agent treats `wiki/index.md` as the first workspace knowledge source before broad exploration, and maintains the wiki by adding, updating, removing, reindexing, and linting entries as part of self-learning. This is workspace-specific knowledge — do not copy from this repo.

> **Tip:** In an existing workspace, ask the agent to "set up the wiki" before starting. This primes the self-learning loop.

**Step 4 — Skills evolve locally (automatic)**

As the agent works, it detects recurring procedural patterns. After 3 encounters, it proposes a new skill. If approved, the skill is created in `.agents/skills/` within your workspace — local to that project.

**Updating**

To update skills and agents to the latest version, run the install script again. Then update `AGENTS.md` in your workspace if the boot policy changed:

```bash
# Re-run the installer to update skills and agents globally
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash

# Update AGENTS.md in your workspace
cp AGENTS.md /path/to/your-project/
```

Wiki content and workspace-local skills are preserved — only global skills and agents are overwritten.

### Installer options

| Flag | Description |
|---|---|
| `--all` | All detected tools (default) |
| `--opencode` | OpenCode only |
| `--claude` | Claude Code only |
| `--copilot` | Copilot only |
| `--no-agency` | Skip agency-agents |
| `--division <list>` | Install only specific divisions (comma-separated) |
| `--list` | Show available skills |
| `--help` | Show help |

### Using `--division`

Filter which agency-agents divisions to install using `--division` with a comma-separated list:

```bash
# Via curl — install only engineering and security
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --division engineering,security

# Local — install specific divisions
./tools/install.sh --division engineering,security

# Combine with --opencode
./tools/install.sh --opencode --division design,marketing

# Combine with --all
./tools/install.sh --all --division testing,support
```

### Available divisions

`academic`, `design`, `engineering`, `finance`, `game-development`, `gis`, `marketing`, `paid-media`, `product`, `project-management`, `sales`, `security`, `spatial-computing`, `specialized`, `support`, `testing`

See [🎭 The Agency](https://github.com/msitarzewski/agency-agents) for details on each division.

### Supported tools

These are the installer target paths currently supported. They are not the normative discovery contract; runtime discovery should remain source-based and platform-aware.

| Tool | Skills path | Agents path |
|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |

## Structure

```
AGENTS.md              # Boot policy — copy to each workspace
skills/                # Loadable behavioral rules — install globally
  orchestrate/         # Full coordination cycle: assemble, delegate, review, synthesize
  wiki/                # Wiki query and self-learning loop
  agents-skills/       # Skill authoring and validation

# In your workspace (created by the agent)
wiki/                  # Workspace knowledge — created on setup/first ingest, then maintained automatically
  index.md
  architecture.md      # System structure overview
  conventions/         # One file per convention
  domain/              # One file per business rule
  decisions/           # One file per ADR
  skill-candidates/    # Recurring patterns tracked for promotion
.agents/skills/        # Skills created from candidates — workspace-local
  <your-custom-skill>/
```
