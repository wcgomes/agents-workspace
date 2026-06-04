# AGENTS.md — Dual Role

> `AGENTS.md` is simultaneously an operational policy and a template copied per workspace.

## The Two Roles

| Role | Description |
|---|---|
| **Operational** | Read by the agent at the start of each session. Defines The One Rule, flow, self-check, anti-rationalization. |
| **Template** | Copied to each workspace (`cp AGENTS.md /path/to/project/`). Not installed globally. |

## Why Not Install Globally?

`AGENTS.md` lives at the workspace root because:

- Each workspace can have customizations (project-specific instructions).
- The agent needs it at the start of each session — local reading is faster.
- Different workspaces can have different versions.

## Instruction Hierarchy

```
1. User instructions           (highest)
2. Active skills               (when loaded)
3. AGENTS.md                   (operational mode)
```

Skills never override `AGENTS.md` — only an explicit user instruction can.

## What AGENTS.md Defines

- **The One Rule** — the main agent never executes; it delegates everything.
- **Flow** — context → orchestrate → review → learn.
- **Self-Check** — checks before each action.
- **Anti-Rationalization** — table of common rationalizations and their rebuttals.
- **Skill Activation** — when to load each skill.
- **Communication** — concise style, no preambles.

## Editing

- **Reading**: always allowed (the agent reads it at the start of each session).
- **Editing**: only when the user explicitly asks.
- **Updating**: when the template changes in the repository, copy it again:
  ```bash
  cp AGENTS.md /path/to/your-project/
  ```
- **Do not re-install automatically** — workspace content is local.

## Golden Rule

If you are not sure whether to edit `AGENTS.md`, don't. Ask the user.
