# Architecture

> System structure: this repository is a **template distribution**. Runtime lives in consumer workspaces + global skill installs.

## Two contexts

| Context | What is "live" |
|---|---|
| **Distribution repo** (agents-workspace) | Root meta `AGENTS.md`, this `wiki/`, source under `templates/` |
| **Consumer session** | Tool global boot policy (from install), local `wiki/`, skills from global install |

`templates/` is source for install — not the operational contract until installed.

## Layers

```
┌─────────────────────────────────────────────────────┐
│  Consumer Workspace                                 │
│  ├── wiki/              (local knowledge)           │
│  ├── .agents/skills/    (workspace-local skills)    │
│  └── (optional project AGENTS.md / CLAUDE.md)       │
└──────────────────────┬──────────────────────────────┘
                       │ loads skills + boot policy from
                       ▼
┌─────────────────────────────────────────────────────┐
│  Global Installation                                │
│  ├── skills/ (per tool)                             │
│  │   ├── orchestrate/, wiki/, skill-builder/, ...   │
│  └── boot policy (per tool, marker-upsert)          │
│      OpenCode ~/.config/opencode/AGENTS.md          │
│      Claude   ~/.claude/CLAUDE.md                   │
│      Copilot  ~/.copilot/instructions/...           │
│      Gemini   ~/.gemini/GEMINI.md                   │
└──────────────────────┬──────────────────────────────┘
                       │ install.sh copies from
                       ▼
┌─────────────────────────────────────────────────────┐
│  Distribution repo (agents-workspace)               │
│  ├── AGENTS.md              (meta — this repo only) │
│  ├── wiki/                  (product knowledge)     │
│  ├── tools/install.sh                               │
│  └── templates/                                     │
│      ├── AGENTS.md          (boot-policy template)  │
│      └── skills/            (skill source of truth) │
└─────────────────────────────────────────────────────┘
```

## Data flow (consumer session)

1. **User** makes a request in a consumer workspace.
2. **Main agent** follows global boot policy → reads `wiki/index.md` → loads `orchestrate`.
3. **Orchestrate** discovers specialists, assembles a team, and delegates via handoffs.
4. **Specialists** execute scope directly under immutable `Session type: DELEGATED` classification, using handoffs as primary context and consulting relevant wiki content only within scope; wiki editing must be explicitly in scope.
5. **Main agent** applies domain-appropriate review and verification, then evaluates every task for uncaptured durable workspace knowledge.
6. A positive evaluation opens one serialized ingestion stream owned by a wiki-ingestion role; a negative evaluation opens none. The main agent reviews any ingest before final synthesis.

## Component relationships

| Component | Location | Function | Editable? |
|---|---|---|---|
| Root `AGENTS.md` | Distribution repo root | Meta for developing the distribution | Yes — keep short |
| `templates/AGENTS.md` | Distribution `templates/` | Boot-policy template | Yes — source; remind re-install |
| Installed boot policy | Per-tool global instruction file | Live boot policy | **No** managed block — re-run `install.sh` |
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
