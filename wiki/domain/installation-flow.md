# Installation flow

> How consumers get skills and boot policy onto their machines. Source of truth is under `templates/` in the published archive.

## Summary

This repository is a **template distribution**. The installer installs **skills** and **boot policy** whose sources of truth are `templates/skills/` and `templates/AGENTS.md` (inside the published archive). It does **not** create a consumer `wiki/`.

## Always from GitHub `main`

```text
curl/install.sh or ./tools/install.sh
        │
        ▼
  download agents-workspace main.zip
        │
        ▼
  templates/skills  ──►  global skill dirs per tool
  templates/AGENTS.md ──► global instruction files (marker-upsert)
        │
        ▼
  (optional) download agency-agents + their install
```

Even when run from a local clone, **local WIP is not installed**. For local testing, copy manually from `templates/`.

## Installer entry points

```bash
# Remote one-liner
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash

# From a clone (still installs published main, not the working tree)
./tools/install.sh
./tools/install.sh --opencode
./tools/install.sh --all --no-agency
./tools/install.sh --list
```

## What is installed

| Source | Destination | Method |
|---|---|---|
| `templates/skills/*` | Per-tool global skills dirs | Copy `SKILL.md` trees |
| `templates/AGENTS.md` | Per-tool global instruction file | Marker-upsert (or dedicated Copilot file) |
| Repo root `AGENTS.md` | — | Distribution-only meta — not for consumers |
| agency-agents (optional) | Tool agent/skill paths | Via their `install.sh` |

### Skills destinations

| Tool | Skills path |
|---|---|
| OpenCode | `~/.config/opencode/skills/` |
| Claude Code | `~/.claude/skills/` |
| Copilot | `~/.copilot/skills/` |
| Antigravity | `~/.gemini/antigravity/skills/` |

### Boot policy destinations

| Tool | Boot policy path |
|---|---|
| OpenCode | `~/.config/opencode/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Antigravity | `~/.gemini/GEMINI.md` |

Managed block markers: `<!-- agents-workspace:start -->` … `<!-- agents-workspace:end -->`.

## Re-install / upgrade

Run the installer again. Overwrites global skills from our template and upserts the managed boot-policy block.

**Preserved:** consumer `wiki/`, `.agents/skills/`, project-root instruction files, content **outside** managed markers in global instruction files.

**Overwritten:** global skills under platform paths; managed marker block; Copilot dedicated instructions file; global agents from agency-agents when installed.

## Consumer first-time checklist

1. Run `install.sh` (skills + global boot policy).
2. Optionally install agency-agents divisions.
3. Create/maintain workspace `wiki/` on first real work.
4. Work — skills load on demand from the global install; boot policy loads from the tool global file.

## Local WIP (developers of this distribution)

```bash
cp -r templates/skills/* ~/.config/opencode/skills/
# Boot policy: re-run a patched installer or manually upsert the marker block
# into the destinations above.
```

Never treat the distribution repo's root `AGENTS.md` as consumer boot policy.
