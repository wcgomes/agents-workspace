# AGENTS.md — Dual Role

> `AGENTS.md` is simultaneously an operational policy and a template copied per workspace.

## The Two Roles

| Role | Description |
|---|---|
| **Operational** | Read by the agent at the start of each session. Defines The One Rule, role discrimination, flow, and skill activation. |
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
- **If You Received a Handoff** — role discriminator via the `[HANDOFF FROM COORDINATOR]` marker: marker present → delegated subagent (execute directly); marker absent → main agent (coordinate).
- **Flow** — context → orchestrate → review → learn, with short pointers into the skills.
- **Skill Activation** — when to load each skill.
- **Communication** — concise style, no preambles.
- **Instruction Priority** — user > active skills > AGENTS.md.

Operational detail lives in the skills, not here: delegation, review, and rationalization-prevention mechanics are in the `orchestrate` skill; the context/ingest loop is in the `wiki` skill.

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
