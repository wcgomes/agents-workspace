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
│      Gemini   ~/.gemini/GEMINI.md                   │
│      Claude   ~/.claude/CLAUDE.md                   │
│      Codex    ~/.codex/AGENTS.md                    │
│      Copilot  ~/.copilot/instructions/...           │
│      Grok     ~/.grok/AGENTS.md                     │
│      OpenCode ~/.config/opencode/AGENTS.md          │
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

1. **User** makes a request in a consumer workspace; the main agent is coordinator unless the initial task starts with `Session type: DELEGATED`.
2. **Coordinator** applies the boot policy's [Coordinator Flow](../templates/AGENTS.md#coordinator-flow): when the Wiki gate applies, consults `wiki-query` first (index plus planning-relevant pages), gathers lean context, and defines done criteria.
3. **Route:** trivial work takes the boot policy's Trivial fast path (one direct handoff, no `orchestrate`, separate review, or ingest evaluation); everything else loads `orchestrate`, which assembles roles, matches session-listed specialists, and dispatches handoffs (carrying `Contract ref:` when an artifact such as a spec governs the task).
4. **Executors** run the handed scope directly, self-verify, self-consult the wiki read-only when useful, and return bounded inline results; wiki edits require explicit scope.
5. **Coordinator** gate-checks returns; independent fresh-context review runs only at strategic points.
6. **Learn (pre-check):** for gated non-trivial work, five boot-policy triggers decide whether to load `wiki`; a positive ingest evaluation opens one serialized writer stream, reviewed before final synthesis.

Without subagent support, the same flow runs as labeled passes in the boot policy's No-subagent mode. Rationale: [ADR 0004](decisions/0004-serialized-post-review-wiki-ingestion.md), [ADR 0005](decisions/0005-skill-independence-and-lean-coordination.md).

## Component relationships

| Component | Location | Function | Editable? |
|---|---|---|---|
| Root `AGENTS.md` | Distribution repo root | Meta for developing the distribution | Yes — keep short |
| `templates/AGENTS.md` | Distribution `templates/` | Boot-policy template | Yes — source; remind re-install |
| Installed boot policy | Per-tool global instruction file | Live boot policy | **No** managed block — re-run `install.sh` |
| `templates/skills/` | Distribution | Versioned skill source | Yes — source of truth |
| Installed skills | `~/.config/opencode/skills/` (etc.) | Runtime artifacts | **No** — re-run `install.sh` |
| `wiki/` | Each workspace (incl. this repo) | Local knowledge | Yes — gated ingestion or explicit request |
| `.agents/skills/` | Consumer workspace | Agent-created local skills | Yes |

## Skill discovery

Skills load on demand, in three stages:

1. **Discovery** (~100 tokens) — `name` + `description` at startup
2. **Activation** (< 5000 tokens) — full `SKILL.md` when task matches
3. **Resources** (on demand) — `scripts/`, `references/`, `assets/` when referenced

## Supported platforms

| Platform | Skills Path | Agents Path |
|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` (unified) |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Codex | `~/.agents/skills/` | `~/.codex/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| Grok Build | `${GROK_HOME:-~/.grok}/skills/` | `~/.grok/agents/` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |
