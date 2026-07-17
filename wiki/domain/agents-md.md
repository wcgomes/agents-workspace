# AGENTS.md — Three Locations

> Three distinct files share the name `AGENTS.md`. Confusing them causes agents to apply consumer boot policy inside this distribution repo (or the reverse).

## Locations

| Location | Role | Who uses it |
|---|---|---|
| **`templates/AGENTS.md`** | Boot-policy **template** (source of truth for consumers) | Edited in this repo; copied into projects |
| **Consumer workspace root `AGENTS.md`** | **Live** operational boot policy for that project | Agents working *in* a consumer project |
| **This repo root `AGENTS.md`** | **Meta** stub for the distribution only | Agents working *in* agents-workspace |

## Dual audience of this repository

| Audience | What they should treat as boot policy |
|---|---|
| **Explorers / agents in agents-workspace** | Root `AGENTS.md` (meta) + this wiki — *not* `templates/AGENTS.md` as live session policy |
| **Consumers (installed/copied harness)** | Their workspace-root `AGENTS.md` (copied from `templates/AGENTS.md`) + their own `wiki/` |

`templates/` is install/copy source. It becomes operational only after install (skills) or manual copy (`AGENTS.md`).

## Why consumers do not get AGENTS.md from install.sh

`install.sh` installs skills globally. `AGENTS.md` is **not** auto-installed:

- Each workspace may customize it.
- Agents need it at the workspace root for session start.
- Different projects may pin different versions.

Manual copy:

```bash
cp templates/AGENTS.md /path/to/your-project/
```

## What the consumer template defines

(`templates/AGENTS.md` / installed workspace root)

- **The One Rule** — main agent coordinates; does not execute task work.
- **Handoff marker** — `[HANDOFF FROM COORDINATOR]` → subagent executes; absent → main agent coordinates.
- **Flow** — context → orchestrate → review → learn (detail in skills).
- **Communication** — concise, no filler.
- **Instruction priority** — user > active skills > AGENTS.md.

Operational detail lives in skills (`orchestrate`, `wiki`, etc.), not in the short boot file.

## What the distribution root stub defines

(repo root `AGENTS.md` only)

- This repo is a template distribution.
- Source of truth under `templates/`; re-install / re-copy after edits.
- Do not treat `templates/AGENTS.md` as live consumer policy while developing here.
- Pointers to templates and to consumer policy.

## Instruction hierarchy (consumer workspaces)

```
1. User instructions           (highest)
2. Active skills               (when loaded)
3. AGENTS.md                   (operational mode)
```

Skills never override `AGENTS.md` — only an explicit user instruction can.

## Editing

| File | When to edit |
|---|---|
| `templates/AGENTS.md` | Changing the product boot policy for all consumers; then notify re-copy |
| Consumer workspace `AGENTS.md` | Only with explicit user request in that project |
| Repo root `AGENTS.md` | Meta guidance for this distribution only; keep short |

- **Reading**: always allowed.
- **Editing consumer or template policy**: only when the user explicitly asks (or the task is clearly about that file).
- **Do not re-install/copy automatically** — remind the user.

## Golden Rule

If unsure which `AGENTS.md` applies: distribution work → root meta + `templates/` as source; consumer project → that project's root copy. When unsure whether to edit any of them, ask the user.
