# Agents Workspace

**A lightweight AI Agent harness to handle any kind of task!**

From software engineering to design, marketing, sales, finance, paid media, project management or whatever you need to be done.

Designed to create a professional workflow with dynamic team assembly of specialized agents tailored to each task, parallel execution, optimized context windows, and a self-learning cycle.

Just portable skills and a single `AGENTS.md` file. No hooks, plugins, or platform-specific configuration.

Under the hood, its operating model brings together memory and OKF concepts, subagent-driven development, spec-driven workflows, and agent loops grounded in empirical verification.

**This repository is a template distribution.** Installable source lives under `templates/` (`templates/skills/` for skills, `templates/AGENTS.md` for the boot-policy template). Those files become live operational contracts after you run the installer (skills + global boot policy).

## Quick Start

### Use the installer (recommended)

One-time setup. Installs **skills** and the **boot policy** globally for each selected tool. The agent loads only what each task needs.

The installer **always downloads GitHub `main.zip`** and installs from `templates/` inside that archive. It does **not** install from your local working tree — even if you run `./tools/install.sh` from a clone. For local WIP, use the manual `cp` steps below.

**Via curl:**

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Or clone and run the script** (still installs published `main`, not your tree):

```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install.sh
```

#### What gets installed

| Artifact | Source | Destinations (global) |
|---|---|---|
| Skills | `templates/skills/` | Per-tool skill dirs (see table below) |
| Boot policy | `templates/AGENTS.md` | Per-tool global instruction file (marker-upsert) |

Boot policy is written between `<!-- agents-workspace:start -->` / `<!-- agents-workspace:end -->` markers. Re-running the installer replaces only that block; content outside the markers is preserved. Copilot uses a dedicated instructions file (full replace is safe).

| Tool | Skills path | Boot policy path |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/AGENTS.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/GEMINI.md` |

#### Installer options

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

#### Using `--no-agency`

You can skip installing the agents completely using `--no-agency` if you already have your own curated team!
Only the skills and bootstrap contract will be installed.

#### Using `--division`

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

##### Available divisions

`academic`, `design`, `engineering`, `finance`, `game-development`, `gis`, `marketing`, `paid-media`, `product`, `project-management`, `sales`, `security`, `spatial-computing`, `specialized`, `support`, `testing`

See [🎭 The Agency](https://github.com/msitarzewski/agency-agents) for details on each division.

### Manual install (local WIP)

```bash
# Skills (example: OpenCode)
cp -r templates/skills/* ~/.config/opencode/skills/

# Boot policy — append/replace the managed marker block in the tool's global file
# (see destinations table above). Prefer re-running install.sh when possible.
```

**Install agents from The Agency (optional, but recommended):**

[Follow the instructions from their repository](https://github.com/msitarzewski/agency-agents)

### Supported tools

These are the installer target paths currently supported. They are not the normative discovery contract; runtime discovery should remain source-based and platform-aware.

| Tool | Skills path | Agents path | Boot policy path |
|---|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` | `~/.gemini/GEMINI.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` | `~/.config/opencode/AGENTS.md` |

## Workflow details

1. **The One Rule** — the main agent never does the work. It delegates every unit to a subagent. Before any tool call, a self-check confirms the action is allowed: read wiki, talk to user, or dispatch subagent. Everything else is delegated — no size threshold.
2. **Team-driven workflow** — main agent reads `wiki/index.md` for context, loads `orchestrate`, then composes the team: analyze domains, discover specialists, size the team, select coordination pattern, plan execution order. Generalist execution is fallback only.
3. **Spec-driven workflow (when needed)** — for work needing a durable behavior contract (new features, API/contract changes, migrations), load `spec-builder` before orchestration. Specs live in `specs/` (source spec per domain + `changes/<id>/` deltas); `orchestrate` consumes them via an optional `Spec ref` handoff field and checks conformity during review.
4. **Structured delegation** — each handoff uses a canonical shape: task, objective, scope, done criteria, constraints, deliverable, return format. Specialists execute the handed scope directly.
5. **Parallel specialist teams** — independent scopes dispatched to multiple specialists simultaneously.
6. **Automatic wiki maintenance** — main agent reads `wiki/index.md` before broad exploration, then evaluates adds, updates, removals, and linting after every task. Self-learning loop — no need to ask.
7. **Auto skill evaluation** — during wiki ingest, the agent evaluates whether content is better suited as a recurring procedural skill rather than declarative wiki knowledge. When clearly procedural and recurring, it flags the user to decide (create a skill with `skill-builder` or keep in wiki) — never auto-creates. High-confidence only; declarative knowledge stays in the wiki.
8. **Anti-rationalization tables** — every skill anticipates excuses agents use to skip steps and refutes them.
9. **Role preservation** — roles from team composition are mandatory. Adjacent match or generic agent fills gaps. Roles are never dropped or collapsed into one handoff unless there's an explicit quality reason and verification is not reduced.

| Mechanism | Skill | What it does |
|---|---|---|
| **Orchestration** | `orchestrate` | Full coordination cycle: analyze domains, discover specialists, compose team, plan execution, handoff, review and synthesize. |
| **Self-learning wiki** | `wiki` | Reads `wiki/index.md` before broad exploration, then evaluates adds, updates, removals, and linting after tasks. |
| **Skill authoring** | `skill-builder` | Creates, refines, and validates Agent Skills following the agentskills.io spec. |
| **Spec-driven workflow** | `spec-builder` | Creates, evolves, and archives durable behavior contracts (`specs/`) before implementation. `orchestrate` consumes via `Spec ref`. |

Skills load **on-demand**: `wiki` for context first, then `orchestrate` for planning or executing delegated work. When work needs a durable behavior contract, `spec-builder` loads before `orchestrate`.

## Structure

```
# This repository (template distribution)
AGENTS.md              # Meta only — guidance for working ON this distribution (not consumer boot policy)
tools/install.sh       # Downloads main.zip; installs skills + global boot policy from archive
wiki/                  # Knowledge about this product (distribution maintainers / agents here)
templates/             # SOURCE for install — not live until installed
  AGENTS.md            # Boot-policy TEMPLATE — installed globally (marker-upsert) via install.sh
  skills/              # Skill source of truth — install globally via install.sh
    orchestrate/       # Full coordination cycle: assemble, delegate, review, synthesize
    wiki/              # Wiki query and self-learning loop
    skill-builder/     # Skill authoring and validation
    spec-builder/      # Spec-driven workflow: durable behavior contracts

# After install (global, per tool)
~/.config/opencode/AGENTS.md   # OpenCode global rules (managed marker block)
~/.claude/CLAUDE.md            # Claude Code user instructions (managed marker block)
~/.gemini/GEMINI.md            # Antigravity / Gemini CLI global context (managed marker block)
~/.copilot/instructions/...    # Copilot user instructions (dedicated file)

# In your project workspace
wiki/                  # Workspace knowledge — created on setup/first ingest, then maintained automatically
  index.md
  architecture.md
  conventions/
  domain/
  decisions/
specs/                 # Durable behavior contracts — when spec-builder is used
.agents/skills/        # Workspace-local skills (explicit creation)
# Optional: project-root AGENTS.md / CLAUDE.md for project-specific rules (layers with global)
```
