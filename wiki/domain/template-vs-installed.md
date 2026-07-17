# Template vs Installed

> Critical distinction: `templates/` is distribution **source**. Installed/copied artifacts are runtime copies. Do not treat templates as the live contracts of a consumer workspace until install/copy.

## The Problem

If you edit an installed skill (`~/.config/opencode/skills/orchestrate/SKILL.md`), the next `install.sh` overwrites it. Guaranteed data loss.

If you treat `templates/AGENTS.md` as the live boot policy while working **in this repo**, you mix consumer product policy with distribution-maintenance work. Use the **repo root** `AGENTS.md` for meta guidance here; use `templates/AGENTS.md` only as the source you edit for consumers.

## Concept

| Concept | What it is | Where it lives | Versioned? |
|---|---|---|---|
| **Skill template** | Skill source code | `templates/skills/<name>/SKILL.md` | Yes (git) |
| **Installed skill** | Runtime copy | `~/.config/<tool>/skills/<name>/SKILL.md` | No |
| **AGENTS.md template** | Consumer boot-policy source | `templates/AGENTS.md` | Yes (git) |
| **Consumer AGENTS.md** | Live boot policy | `<project>/AGENTS.md` (manual copy) | Project-local |
| **Distribution meta AGENTS.md** | Guidance for *this* repo only | Repo root `AGENTS.md` | Yes (git) |

## Installation / copy flow

```
templates/skills/          templates/AGENTS.md
       │                          │
       │  install.sh              │  manual cp (not in install.sh)
       ▼                          ▼
 ~/.config/.../skills/     <consumer-project>/AGENTS.md
       │                          │
       └──────── loaded by consumer runtime agent ────────┘
```

Repo root `AGENTS.md` is **not** part of install/copy. It stays in the distribution repo for agents developing the harness.

## Rules

1. **Change a skill**: edit `templates/skills/<name>/SKILL.md` → remind user to run `./tools/install.sh`.
2. **Never edit** installed files under `~/.config/opencode/skills/` (or platform equivalents).
3. **Source of truth for skill content**: `templates/skills/`.
4. **Change consumer boot policy**: edit `templates/AGENTS.md` → remind user to re-copy to projects.
5. **Add a skill**: create `templates/skills/<name>/SKILL.md` → remind user to run `install.sh`.
6. **Working in agents-workspace**: follow root meta `AGENTS.md`; do not assume `templates/` is already "installed" into this session.

> **Important:** The agent **never** runs `install.sh` automatically. Only remind the user.

## Exception: Workspace-Local Skills

Skills created from skill candidates live in `.agents/skills/` in a **consumer** workspace. Not managed by `install.sh`.

## References Subdirectory

`references/` (and similar) under a skill template are **not** installed. Only `SKILL.md` is copied. Access references from the source repo or inline them in `SKILL.md`.
