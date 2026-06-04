# Installation Flow

> What `install.sh` does, where it installs, how to update.

> **Note about the agent:** The agent **never** runs `install.sh` automatically. When you ask to edit skill templates, the agent only reminds you to run the script manually.

## Overview

The installer does two things:

1. **Installs agents-workspace skills** — copies `SKILL.md` from each skill to the platform path.
2. **Installs agency-agents** — 144+ specialists from the [agency-agents](https://github.com/msitarzewski/agency-agents) repository.

## How to Install

**Via curl (recommended):**
```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Or clone and run locally:**
```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install.sh
```

## What the Installer Does

```
1. Download the repository (zip)
2. Extract to a temporary directory
3. For each selected platform:
   a. Create skills directory (e.g., ~/.config/opencode/skills/)
   b. Copy SKILL.md from each skill to <platform>/skills/<name>/SKILL.md
4. (Optional) Download and install agency-agents
5. Clean up temporary directory
```

## Installer Options

| Flag | Description |
|---|---|
| `--all` | All detected platforms (default) |
| `--opencode` | OpenCode only |
| `--claude` | Claude Code only |
| `--copilot` | Copilot only |
| `--no-agency` | Skip agency-agents |
| `--list` | List available skills |
| `--help` | Help |

## Installation Paths

| Platform | Skills | Agents |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` (unified directory) |

## How to Update

Run the installer again. Only global skills and agents are overwritten.

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**What is preserved:**
- `wiki/` content (workspace knowledge)
- Local skills in `.agents/skills/`

**What is overwritten:**
- Global skills in `~/.config/opencode/skills/` (and equivalents)
- Global agents

## After Installation

1. Copy `AGENTS.md` to your workspace:
   ```bash
   cp AGENTS.md /path/to/your-project/
   ```
2. Ask the agent to create the `wiki/` (or it creates it automatically on first ingestion).
3. Start working — the agent loads skills on demand.

## Agency-Agents

By default, the installer also installs 144+ specialists from [agency-agents](https://github.com/msitarzewski/agency-agents). Use `--no-agency` to skip.

The specialists are discovered automatically by `orchestrate` and assembled into teams based on the task.
