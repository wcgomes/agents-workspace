# Template vs Installed

> Critical distinction: `skills/` is source code. What is installed is a copy.

## The Problem

If you edit an installed skill directly (`~/.config/opencode/skills/orchestrate/SKILL.md`), the next time you run `install.sh` it will overwrite your change. Guaranteed data loss.

## Concept

| Concept | What it is | Where it lives | Versioned? |
|---|---|---|---|
| **Template** | Skill source code | `skills/<name>/SKILL.md` | Yes (git) |
| **Installed** | Runtime copy | `~/.config/opencode/skills/<name>/SKILL.md` | No |

## Installation Flow

```
skills/ (templates)
    │
    │  install.sh
    ▼
~/.config/opencode/skills/ (installed)
    │
    │  loaded by
    ▼
Runtime agent
```

## Rules

1. **To change a skill**: edit `skills/<name>/SKILL.md` and remind the user to run `install.sh`.
2. **Never edit** files in `~/.config/opencode/skills/` directly.
3. **To verify what is installed**: read the templates in `skills/` — they are the source of truth.
4. **To add a new skill**: create `skills/<name>/SKILL.md` and remind the user to run `install.sh`.

> **Important:** The agent **never** runs `install.sh` automatically. Only remind the user to run the script manually when needed.

## Exception: Workspace-Local Skills

Skills created by the agent from skill candidates live in `.agents/skills/` within the workspace. These are local to the project and are **not** managed by `install.sh`.

## References Subdirectory

The `references/` subdirectory within a skill (e.g., `skill-builder/references/`) is **not** installed. Only `SKILL.md` is copied. If a skill needs references, they must be accessed from the source repository or included in the `SKILL.md` itself.
