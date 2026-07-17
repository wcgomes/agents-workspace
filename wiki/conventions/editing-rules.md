# Editing Rules

> What to edit, what never to edit, how to keep distribution source and consumer runtime consistent.

## User intent: "Edit a skill" = edit the template

When the user asks to modify, update, fix, or create a skill, they mean the source under `templates/skills/` in this distribution repo. Never edit the installed copy in `~/.config/opencode/skills/` for a user-requested change.

- After editing a skill template, remind the user to run `./tools/install.sh` (the agent never runs it automatically).
- Installed copies are build artifacts, not editable sources.

## Editing matrix

| File/Directory | Edit? | How |
|---|---|---|
| `templates/skills/<name>/SKILL.md` | **Yes** | Source of truth; remind `install.sh` |
| `~/.config/opencode/skills/` (installed) | **Never** | Edit template + re-install |
| `templates/AGENTS.md` | **Yes, when requested** | Boot-policy template; remind re-run `install.sh` |
| Repo root `AGENTS.md` | **Yes, when requested** | Meta for this distribution only; keep short |
| Installed global boot-policy files | **Never** (managed block) | Edit template + re-install |
| Optional project-root AGENTS.md | **Yes, when requested** | Project-local layer only |
| `wiki/` (any workspace) | **Yes** | Agent-maintained knowledge |
| `.agents/skills/` (consumer) | **Yes** | Workspace-local skills |

## Detailed rules

### Installed skills — NEVER edit

```
~/.config/opencode/skills/orchestrate/SKILL.md   ← DO NOT EDIT
~/.config/opencode/skills/wiki/SKILL.md           ← DO NOT EDIT
~/.config/opencode/skills/skill-builder/SKILL.md  ← DO NOT EDIT
~/.config/opencode/skills/spec-builder/SKILL.md   ← DO NOT EDIT
```

**Why:** `install.sh` overwrites these files.

**What to do:** Edit `templates/skills/`. Remind the user to run `./tools/install.sh` manually.

### Templates — edit with care

```
templates/skills/*/SKILL.md   ← skill source of truth
templates/AGENTS.md           ← consumer boot-policy source
```

After skill edits:

```bash
./tools/install.sh
```

After `templates/AGENTS.md` edits:

```bash
./tools/install.sh
```

(Upserts the managed marker block into each tool's global instruction file.)

> The agent **never** runs `install.sh` automatically.

### AGENTS.md — template, meta, and installed

| Path | Intent |
|---|---|
| `templates/AGENTS.md` | Product boot policy source for consumers |
| Repo root `AGENTS.md` | Meta for agents working **in** agents-workspace |
| Tool global files (after install) | Live boot policy across projects |

Do not treat `templates/AGENTS.md` as the live session policy while developing this distribution. Do not edit any `AGENTS.md` unless the user asked (or the task clearly targets that file).

### Wiki — maintain automatically

```
wiki/index.md
wiki/architecture.md
wiki/domain/*.md
wiki/conventions/*.md
```

Each workspace (including this distribution repo) owns its own `wiki/`.

### Workspace-local skills

```
.agents/skills/<name>/SKILL.md
```

Consumer-only. Not managed by `install.sh`. Editable freely.

## Maintenance checklist

When changing the distribution repository:

- [ ] Template skill changed in `templates/skills/`? → Remind user to run `install.sh`
- [ ] New skill under `templates/skills/`? → Remind user `install.sh` discovers via `templates/skills/*/SKILL.md`
- [ ] `templates/AGENTS.md` changed? → Notify re-run `install.sh` (global marker-upsert)
- [ ] Root meta `AGENTS.md` changed? → Keep short; no consumer install impact
- [ ] Wiki page added/removed? → Update `wiki/index.md`
- [ ] Breaking change? → Document in README.md

## Common errors

| Error | Consequence | Fix |
|---|---|---|
| Editing installed skill | Loss on next install | Edit `templates/skills/` |
| Treating `templates/AGENTS.md` as live policy here | Wrong boot semantics in distribution work | Use root meta; edit templates only as product source |
| Editing any `AGENTS.md` without request | Workflow breakage | Ask the user |
| Not re-installing after skill template edit | Stale runtime skills | Remind user to run `install.sh` |
| Copying `wiki/` between workspaces | Wrong knowledge in target | Each workspace owns its wiki |
