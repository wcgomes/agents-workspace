# AGENTS.md (meta — this repository only)

> **This file is not consumer boot policy.** It guides agents working **in** the agents-workspace distribution repo. For the policy that consumers copy into their projects, see [`templates/AGENTS.md`](templates/AGENTS.md).

## What this repository is

**agents-workspace** is a **template distribution**: portable skills and a workspace boot-policy template that people install or copy into *their* projects.

| Path | Role |
|---|---|
| `templates/skills/` | Skill source of truth — install globally via `./tools/install.sh` |
| `templates/AGENTS.md` | Boot-policy **template** — manual copy to each consumer workspace root |
| This file (`./AGENTS.md`) | **Meta** guidance for developing and maintaining the distribution |

`templates/` is **not** the live operational contract of a consumer workspace until installed or copied. Do not treat `templates/AGENTS.md` as the session boot policy for someone else's project while you work here.

## Editing source of truth

- Change skills under `templates/skills/<name>/` — then remind the user to run `./tools/install.sh` (never run it automatically).
- Change consumer boot policy in `templates/AGENTS.md` — then remind the user to re-copy into their projects (`cp templates/AGENTS.md /path/to/project/`).
- Do not edit installed copies under `~/.config/opencode/skills/` (or platform equivalents).

## Working in this repo

This distribution repo maintains its own `wiki/` for knowledge about the product itself. Prefer coordination via `orchestrate` for multi-step or multi-domain work on the distribution (same convention as consumers), but **load consumer boot semantics from `templates/AGENTS.md` only when editing that template** — not as your default policy for every task here.

Full consumer operating mode (The One Rule, handoff marker, flow): [`templates/AGENTS.md`](templates/AGENTS.md).
