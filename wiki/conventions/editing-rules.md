# Editing Rules

> What to edit, what to never edit, how to maintain consistency.

## Editing Matrix

| File/Directory | Edit? | How |
|---|---|---|
| `skills/<name>/SKILL.md` (template) | **Yes** | Edit directly, remind the user to run `install.sh` |
| `~/.config/opencode/skills/` (installed) | **Never** | Edit the template and re-install |
| `AGENTS.md` (workspace) | **Yes, when requested** | Only with explicit user instruction |
| `wiki/` (workspace) | **Yes** | Maintained automatically by the agent |
| `.agents/skills/` (workspace) | **Yes** | Local skills created by the agent |

## Detailed Rules

### Installed Skills — NEVER edit

```
~/.config/opencode/skills/orchestrate/SKILL.md   ← DO NOT EDIT
~/.config/opencode/skills/wiki/SKILL.md           ← DO NOT EDIT
~/.config/opencode/skills/agents-skills/SKILL.md  ← DO NOT EDIT
```

**Why:** `install.sh` overwrites these files. Edits are lost.

**What to do:** Edit the corresponding template in `skills/`. The agent **never** runs `install.sh` automatically — only remind the user to run the script manually.

### Templates — Edit with care

```
skills/orchestrate/SKILL.md    ← source of truth
skills/wiki/SKILL.md           ← source of truth
skills/agents-skills/SKILL.md  ← source of truth
```

After editing, remind the user to update the installation:
```bash
./tools/install.sh
```

> **Important:** The agent **never** runs `install.sh` automatically. Only remind the user to run the script manually.

### AGENTS.md — Edit only when requested

```
AGENTS.md ← operational + template
```

**Rule:** If the user did not ask to edit, do not edit. If they asked, edit with precision.

### Wiki — Maintain automatically

```
wiki/index.md              ← update when pages change
wiki/architecture.md       ← update when structure changes
wiki/concepts/*.md         ← maintain with relevant changes
wiki/conventions/*.md      ← maintain with relevant changes
```

The agent maintains the wiki as part of the self-learning cycle.

### Workspace-Local Skills

```
.agents/skills/<name>/SKILL.md ← skills created by the agent
```

These are local to the workspace. They are not managed by `install.sh`. They can be edited freely.

## Maintenance Checklist

When changing the repository:

- [ ] Template changed in `skills/`? → Remind the user to run `install.sh`
- [ ] New skill created? → Remind the user that `install.sh` discovers automatically via `skills/*/SKILL.md` (no script edits needed)
- [ ] `AGENTS.md` changed? → Notify users to copy it again
- [ ] Wiki page added/removed? → Update `wiki/index.md`
- [ ] Breaking change? → Document in README.md

## Common Errors

| Error | Consequence | Fix |
|---|---|---|
| Editing installed skill | Loss on next installation | Edit the template |
| Editing `AGENTS.md` without request | Possible workflow breakage | Ask the user |
| Not running `install.sh` after editing template | Installed skill is outdated | Remind the user to run after editing |
| Copying `wiki/` between workspaces | Incorrect knowledge in target workspace | Each workspace creates its own |
