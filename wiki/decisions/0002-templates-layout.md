# ADR 0002: Installable source under templates/

## Status

Accepted (2026-07-16)

## Context

Installable artifacts mixed with distribution-maintenance files at the repo root made it easy to treat this repo’s live layout as a consumer workspace. Maintainers also assumed `./tools/install.sh` from a clone installed the local working tree; the script always downloads GitHub `main.zip`.

## Decision

Keep all **consumer-facing install/copy sources** under `templates/`:

| Path | Role |
|---|---|
| `templates/skills/` | Skill source of truth — what `install.sh` installs |
| `templates/AGENTS.md` | Boot-policy template — installed globally by `install.sh` (marker-upsert) |
| Root `AGENTS.md` | Meta stub for working **on** this distribution only |
| `tools/install.sh` | Always downloads `main.zip`; installs `templates/skills` + `templates/AGENTS.md` |

Local WIP is not installed by the script. Copy manually from `templates/`.

### Amendment (global boot policy)

Boot policy is no longer a per-project manual copy. `install.sh` upserts `templates/AGENTS.md` into each tool's global instruction file between `<!-- agents-workspace:start -->` / `<!-- agents-workspace:end -->` markers, preserving user content outside the block.

| Tool | Global path |
|---|---|
| OpenCode | `~/.config/opencode/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Antigravity | `~/.gemini/GEMINI.md` |

## Rationale

- Clear split: distribution meta (root) vs installable product source (`templates/`).
- Single install path in the zip for both curl and clone+run.
- Predictable installs: always published `main`, never a dirty local tree by accident.
- Global boot policy: one install, all projects; marker upsert keeps personal instructions.

## Alternatives Considered

- **Install from local working tree when run from a clone** — rejected: curl and local paths would diverge; harder to reason about “what got installed.”
- **Keep skills at repo root** — rejected: confuses distribution repo with consumer layout; root `AGENTS.md` would look like live consumer policy.
- **Separate installable monorepo** — rejected: extra repo for no gain at current size.
- **Manual per-project AGENTS.md copy** — superseded: friction for consumers; global install + markers is enough; project-local rules remain optional.

## Consequences

- Edit skills under `templates/skills/`; edit consumer policy under `templates/AGENTS.md`.
- Docs must state: `install.sh` always uses published `main`, not the local tree.
- Maintainers testing uncommitted changes use manual `cp`, not `./tools/install.sh`.
- After `templates/AGENTS.md` edits, remind users to re-run `install.sh` (not re-copy into projects).
