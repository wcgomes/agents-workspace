# Architecture

> Overview of the system structure and relationship between components.

## Layers

```
┌─────────────────────────────────────────────────────┐
│  User Workspace                                     │
│  ├── AGENTS.md          (boot policy)               │
│  ├── wiki/              (local knowledge)           │
│  └── .agents/skills/    (workspace-local skills)    │
└──────────────────────┬──────────────────────────────┘
                       │ loaded by
                       ▼
┌─────────────────────────────────────────────────────┐
│  Global Installation (~/.config/opencode/skills/)   │
│  ├── orchestrate/SKILL.md                           │
│  ├── wiki/SKILL.md                                  │
│  ├── agents-skills/SKILL.md                         │
│  └── ... (agency-agents: 144+ specialists)          │
└──────────────────────┬──────────────────────────────┘
                       │ copied from
                       ▼
┌─────────────────────────────────────────────────────┐
│  Source Code (agents-workspace/skills/)             │
│  ├── orchestrate/SKILL.md + (no references/)        │
│  ├── wiki/SKILL.md                                  │
│  └── agents-skills/SKILL.md + references/           │
└─────────────────────────────────────────────────────┘
```

## Data Flow

1. **User** makes a request in the workspace.
2. **Main agent** reads `AGENTS.md` → loads `wiki/index.md` → loads `orchestrate`.
3. **Orchestrate** discovers specialists, assembles a team, delegates via handoffs.
4. **Specialists** execute scope directly (marker `[HANDOFF FROM COORDINATOR]`).
5. **Main agent** reviews, synthesizes, and ingests learnings into `wiki/`.

## Component Relationships

| Component | Location | Function | Editable? |
|---|---|---|---|
| `AGENTS.md` | Workspace (root) | Boot policy, The One Rule | Yes, when requested |
| `skills/` | Repo (source code) | Versioned templates | Yes — source of truth |
| Installed skills | `~/.config/opencode/skills/` | Runtime artifacts | **No** — remind the user to run `install.sh` |
| `wiki/` | Workspace | Local knowledge | Yes — maintained by the agent |
| `.agents/skills/` | Workspace | Skills created by the agent | Yes — workspace-local skills |

## Skill Discovery

Skills are loaded on demand, in three stages:

1. **Discovery** (~100 tokens) — `name` + `description` loaded at startup for all skills
2. **Activation** (< 5000 tokens) — full `SKILL.md` loaded when task matches the trigger
3. **Resources** (on demand) — files in `scripts/`, `references/`, `assets/` loaded only when referenced

## Supported Platforms

| Platform | Skills Path | Agents Path |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` (unified directory) |
