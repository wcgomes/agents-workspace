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
| `templates/AGENTS.md` | Consumer boot-policy template — manual copy to project roots |
| Root `AGENTS.md` | Meta stub for working **on** this distribution only |
| `tools/install.sh` | Always downloads `main.zip`; source path inside archive: `templates/skills` |

Local WIP skills are not installed by the script. Copy manually, e.g. `cp -r templates/skills/* ~/.config/opencode/skills/`.

## Rationale

- Clear split: distribution meta (root) vs installable product source (`templates/`).
- Single install path in the zip (`templates/skills`) for both curl and clone+run.
- Predictable installs: always published `main`, never a dirty local tree by accident.

## Alternatives Considered

- **Install from local working tree when run from a clone** — rejected: curl and local paths would diverge; harder to reason about “what got installed.”
- **Keep skills at repo root** — rejected: confuses distribution repo with consumer layout; root `AGENTS.md` would look like live consumer policy.
- **Separate installable monorepo** — rejected: extra repo for no gain at current size.

## Consequences

- Edit skills under `templates/skills/`; edit consumer policy under `templates/AGENTS.md`.
- Docs must state: `install.sh` always uses published `main`, not the local tree.
- Maintainers testing uncommitted skill changes use manual `cp`, not `./tools/install.sh`.
