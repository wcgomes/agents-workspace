# Architecture

> System structure: this repository is a **template distribution**. Runtime lives in consumer workspaces + global skill installs.

## Two contexts

| Context | What is "live" |
|---|---|
| **Distribution repo** (agents-workspace) | Root meta `AGENTS.md`, this `wiki/`, source under `templates/` |
| **Consumer workspace** | Copied `AGENTS.md`, local `wiki/`, skills loaded from global install |

`templates/` is source for install/copy — not the operational contract of a consumer until installed/copied.

## Layers

```
┌─────────────────────────────────────────────────────┐
│  Consumer Workspace                                 │
│  ├── AGENTS.md          (boot policy — from template)│
│  ├── wiki/              (local knowledge)           │
│  └── .agents/skills/    (workspace-local skills)    │
└──────────────────────┬──────────────────────────────┘
                       │ loads skills from
                       ▼
┌─────────────────────────────────────────────────────┐
│  Global Installation (~/.config/opencode/skills/)   │
│  ├── orchestrate/SKILL.md                           │
│  ├── wiki/SKILL.md                                  │
│  ├── skill-builder/SKILL.md                         │
│  ├── spec-builder/SKILL.md                          │
│  └── ... (agency-agents: 144+ specialists)          │
└──────────────────────┬──────────────────────────────┘
                       │ install.sh copies from
                       ▼
┌─────────────────────────────────────────────────────┐
│  Distribution repo (agents-workspace)               │
│  ├── AGENTS.md              (meta — this repo only) │
│  ├── wiki/                  (product knowledge)     │
│  ├── tools/install.sh                               │
│  └── templates/                                     │
│      ├── AGENTS.md          (consumer boot template)│
│      └── skills/            (skill source of truth) │
│          ├── orchestrate/                           │
│          ├── wiki/                                  │
│          ├── skill-builder/                         │
│          └── spec-builder/                          │
└─────────────────────────────────────────────────────┘
```

## Data flow (consumer session)

1. **User** makes a request in a consumer workspace.
2. **Main agent** reads workspace `AGENTS.md` → `wiki/index.md` → loads `orchestrate`.
3. **Orchestrate** discovers specialists, assembles a team, delegates via handoffs.
4. **Specialists** execute scope directly (marker `[HANDOFF FROM COORDINATOR]`).
5. **Main agent** reviews, synthesizes, and ingests learnings into that workspace's `wiki/`.

## Component relationships

| Component | Location | Function | Editable? |
|---|---|---|---|
| Root `AGENTS.md` | Distribution repo root | Meta for developing the distribution | Yes — keep short |
| `templates/AGENTS.md` | Distribution `templates/` | Consumer boot-policy template | Yes — source; remind re-copy |
| Consumer `AGENTS.md` | Consumer workspace root | Live boot policy | Yes, when requested |
| `templates/skills/` | Distribution | Versioned skill source | Yes — source of truth |
| Installed skills | `~/.config/opencode/skills/` (etc.) | Runtime artifacts | **No** — re-run `install.sh` |
| `wiki/` | Each workspace (incl. this repo) | Local knowledge | Yes — agent-maintained |
| `.agents/skills/` | Consumer workspace | Agent-created local skills | Yes |

## Skill discovery

Skills load on demand, in three stages:

1. **Discovery** (~100 tokens) — `name` + `description` at startup
2. **Activation** (< 5000 tokens) — full `SKILL.md` when task matches
3. **Resources** (on demand) — `scripts/`, `references/`, `assets/` when referenced

## Supported platforms

| Platform | Skills Path | Agents Path |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` (unified) |
