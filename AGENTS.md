# Repository guidance

This file guides work in the agents-workspace distribution repository. Treat `templates/AGENTS.md` and `templates/skills/` as product sources, not automatically active session instructions.

Read [wiki/index.md](wiki/index.md) for project context. Prefer `orchestrate` for multi-step or multi-domain work.

## Editing

- Edit skills under `templates/skills/<name>/` and consumer policy in `templates/AGENTS.md`.
- Do not edit installed copies or global instruction files.
- Never run the installer automatically. After template changes, remind the user to update installed copies. See the [README](README.md#installation-reference): the installer downloads remote `main`, not local edits; [Using local edits](README.md#using-local-edits) covers checkout changes.
