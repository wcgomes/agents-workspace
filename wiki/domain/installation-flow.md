# Installation Flow

> What `install.sh` does, what it does **not** install, where artifacts land, how to update.

> **Agent rule:** Never run `install.sh` automatically. After template skill edits, only remind the user to run it manually.

## Overview

This repository is a **template distribution**. The installer installs **skills** whose source of truth is `templates/skills/` (inside the published archive). It does **not** install `AGENTS.md` or create a consumer `wiki/`.

1. **Installs agents-workspace skills** — `SKILL.md` from each entry under `templates/skills/` in **GitHub `main`**.
2. **Optionally installs agency-agents** — specialists from [agency-agents](https://github.com/msitarzewski/agency-agents).

> **Always zip-from-main:** `install.sh` always downloads `main.zip` from GitHub. Running `./tools/install.sh` from a local clone does **not** install the working tree. Uncommitted / branch WIP: copy manually (see [Local WIP](#local-wip)).

## How to install

**Via curl (recommended):**

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Or clone and run the script** (still installs published `main`, not your tree):

```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install.sh
```

## What the installer does

```
1. Download agents-workspace main.zip from GitHub (always — even from a clone)
2. Extract; use path templates/skills inside the archive
3. For each selected platform:
   a. Create skills directory (e.g. ~/.config/opencode/skills/)
   b. Copy each templates/skills/<name>/SKILL.md → <platform>/skills/<name>/SKILL.md
4. (Optional) Download and install agency-agents (also via zip)
5. Clean up temporary directory
```

Archive path used by the script: `templates/skills` (not repo-root `skills/`).

## Local WIP

To try skills from your working tree before they are on `main`:

```bash
cp -r templates/skills/* ~/.config/opencode/skills/
# or the target platform path — only SKILL.md is required per skill
```

Do not expect `./tools/install.sh` to pick up local edits.

## What is NOT installed

| Artifact | How consumers get it |
|---|---|
| `templates/AGENTS.md` | Manual copy to project root |
| Repo root `AGENTS.md` | Distribution-only meta — not for consumers |
| `wiki/` | Created per workspace (setup / first ingest) |
| Skill `references/`, `scripts/`, etc. | Not copied — only `SKILL.md` |

## Installer options

| Flag | Description |
|---|---|
| `--all` | All detected platforms (default) |
| `--opencode` | OpenCode only |
| `--claude` | Claude Code only |
| `--copilot` | Copilot only |
| `--no-agency` | Skip agency-agents |
| `--division <list>` | Agency divisions (comma-separated) |
| `--list` | List available skills |
| `--help` | Help |

## Installation paths

| Platform | Skills | Agents |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` (unified) |

## How to update

Run the installer again. Only global skills/agents are overwritten.

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Preserved:** consumer `wiki/`, `.agents/skills/`, workspace `AGENTS.md` (never touched by install).

**Overwritten:** global skills under platform paths; global agents from agency-agents when installed.

## After installation

1. Copy the boot-policy template into each project:

   ```bash
   cp templates/AGENTS.md /path/to/your-project/
   ```

   (From a clone; or download that file from the repo.)

2. Create or let the agent create `wiki/` on first ingest.
3. Work — skills load on demand from the global install.

## Agency-Agents

By default the installer also pulls specialists from [agency-agents](https://github.com/msitarzewski/agency-agents). Use `--no-agency` to skip. `orchestrate` discovers them for team assembly.
