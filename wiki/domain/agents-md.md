# AGENTS.md — Template vs installed global boot policy

> Confusing the distribution meta file with the consumer template (or with installed global instruction files) causes wrong boot semantics.

## Locations

| Location | Role | Who uses it |
|---|---|---|
| **`templates/AGENTS.md`** | Boot-policy **template** (source of truth) | Edited in this repo; installed globally via `install.sh` |
| **Tool global instruction files** | **Live** boot policy across projects | Agents after install (see paths below) |
| **This repo root `AGENTS.md`** | **Meta** stub for the distribution only | Agents working *in* agents-workspace |
| **Optional project-root `AGENTS.md` / `CLAUDE.md`** | Project-specific rules layered with global | Consumers who want per-repo extras |

## Dual audience of this repository

| Audience | What they should treat as boot policy |
|---|---|
| **Explorers / agents in agents-workspace** | Root `AGENTS.md` (meta) + this wiki — *not* `templates/AGENTS.md` as live session policy |
| **Consumers (after install)** | Their tool's **global** instruction file (installed from `templates/AGENTS.md`) + optional project-local rules + their own `wiki/` |

`templates/` is install source. It becomes operational after `install.sh` (or careful manual copy into the global paths).

## Global install destinations

`install.sh` installs the template into each selected tool's **global** instruction file:

| Tool | Global boot policy path | Notes |
|---|---|---|
| OpenCode | `~/.config/opencode/AGENTS.md` | [OpenCode global rules](https://opencode.ai/docs/rules/) |
| Claude Code | `~/.claude/CLAUDE.md` | [Claude user instructions](https://docs.anthropic.com/en/docs/claude-code/memory) |
| Copilot | `~/.copilot/instructions/agents-workspace.instructions.md` | Dedicated `*.instructions.md` with `applyTo: "**"` |
| Antigravity | `~/.gemini/GEMINI.md` | [Gemini CLI global context](https://geminicli.com/docs/cli/gemini-md/) |

## Marker upsert (preserve user content)

Managed content is wrapped in:

```html
<!-- agents-workspace:start -->
…templates/AGENTS.md body…
<!-- agents-workspace:end -->
```

On install / re-install:

| Existing file | Behavior |
|---|---|
| Missing | Create with managed block |
| Has markers | Replace **only** the block between markers |
| No markers | Append managed block after existing content |

Copilot uses a dedicated file owned by the installer (full replace is safe).

Project-local instruction files are **not** modified by `install.sh`. Users may still add project-root rules; tools typically layer global + project context.

## What the consumer template defines

(`templates/AGENTS.md` / installed global block)

- **The One Rule** — main agent coordinates; does not execute task work.
- **Session type** — a fresh canonical handoff starts with `Session type: DELEGATED`; classification is initial-task scoped and immutable for the conversation.
- **Flow** — context → orchestrate → review → learn (detail in skills).
- **Communication** — concise, no filler.
- **Instruction priority** — user task instructions within the assigned immutable session type > active skills > boot policy.

Operational detail lives in skills (`orchestrate`, `wiki`, etc.), not in the short boot file.

## Session contract

### Session classification

The sole delegated signal is the exact first nonblank line `Session type: DELEGATED` in the initial task of a fresh conversation. A fresh ordinary request with no `Session type` control assigns coordinator. Session classification is immutable; a matching follow-up restatement is evidence only.

### Delegated execution state

Initial delegated execution requires nonempty, exact-labeled `Task:`, `Scope:`, `Done criteria:`, and `Constraints:` fields. Missing state may be supplied later in an established delegated session; execution stops with `NEEDS_CONTEXT` until complete. `Act as:` is a task-scoped persona required for adjacent or generic/fallback specialist matches and omitted for exact matches; selected-agent and match metadata remain coordinator-internal. Purpose belongs in `Task:` or concise `Context:`, artifact expectations in `Task:` and `Done criteria:`, and return requirements in `Constraints:` rather than separate `Objective:`, `Deliverable:`, or `Return format:` fields.

### Compaction capsule and recovery

The compaction capsule requires exact `Session type: DELEGATED` and nonempty, exact-labeled `Task:`, `Scope:`, `Done criteria:`, `Constraints:`, `Current status:`, and `Next step:` state. It also preserves any originally present `Act as:`, `Context:`, and `Spec ref:`; task-critical context and unresolved decisions stay concise. Incomplete recovery state stops execution with `NEEDS_CONTEXT` but does not change the assigned session type.

A coordinator continuation remains coordinator when retained context establishes it and does not require delegated execution fields. Ordinary wording such as "continue" in a fresh request is not prior-work evidence. This behavior is template-only and requires no hooks, plugins, runtime metadata, harness customization, or user configuration. Prompt-only recovery cannot detect evidence-free loss of an originally present `Act as:`, `Context:`, `Spec ref:`, or individual task-critical fact and does not guarantee complete recovery; if all prior-session evidence is erased, the remainder may be indistinguishable from a fresh request.

## What the distribution root stub defines

(repo root `AGENTS.md` only)

- This repo is a template distribution.
- Source of truth under `templates/`; re-install after edits.
- Do not treat `templates/AGENTS.md` as live consumer policy while developing here.
- Pointers to templates and to consumer policy.

## Instruction hierarchy (consumer sessions)

```
1. User task instructions within the assigned session type  (highest)
2. Active skills               (when loaded)
3. Boot policy (global + optional project)  (operational mode)
```

Later instructions cannot change the assigned session type.

## Editing

| File | When to edit |
|---|---|
| `templates/AGENTS.md` | Changing the product boot policy for all consumers; then notify re-run `./tools/install.sh` |
| Installed global files | Prefer re-install; do not hand-edit the managed marker block |
| Repo root `AGENTS.md` | Meta guidance for this distribution only; keep short |

- **Reading**: always allowed.
- **Editing template policy**: only when the user explicitly asks (or the task is clearly about that file).
- **Do not re-install automatically** — remind the user.

## Golden Rule

If unsure which file applies: distribution work → root meta + `templates/` as source; consumer session → tool global boot policy (+ optional project rules). When unsure whether to edit any of them, ask the user.
