# Agents Workspace

**A lightweight agents and skills set to handle any kind of task!**

Designed to create a professional workflow with dynamic team assembly of specialized agents tailored to each task, parallel execution, optimized context windows, and a self-learning cycle.

Under the hood, its operating model brings together memory, subagent-driven development, spec-driven workflows, and agent loops grounded in empirical verification.

> Installs [The Agency](https://github.com/msitarzewski/agency-agents), a complete AI-agent package covering software engineering, design, marketing, sales, finance, paid media, project management, and other task domains.

## Harness Flow

The user-facing main agent is the **coordinator**, not the executor. It gathers lean workspace context, assembles the right team, delegates scoped work, reviews the results, and synthesizes the final response. The parallel branches below illustrate the default pattern for independent scopes; orchestration can use a single-agent or sequential pattern when the task or its dependencies call for it.

Review and verification are coordinator-controlled quality gates: when findings show that the done criteria are not met, the coordinator re-dispatches the affected subagent(s) with the findings, integrates the adjustments, and sends the result through review again. The cycle repeats under the normal status and escalation rules until the criteria pass; blocked or stuck work is stopped, escalated, or recomposed rather than retried without bound.

```text
User request
     |
     v
+--------------------------------------+
| Main agent (coordinator)             |
| Read wiki/index.md for context       |
| Optional: use available knowledge    |
| tools (e.g. code/symbol/dependency   |
| graphs).                             |
+--------------------------------------+
     |
     +--> [when a durable behavior contract is needed]
     |       Load spec-builder; confirm spec workflow
     |
     v
+--------------------------------------+
| Load orchestrate; assemble and plan  |
| Optional: delegate spec drafting and |
| planning -> specs/... -> Spec ref    |
| Delegate execution using Spec ref    |
| when present                         |
+--------------------------------------+
     |
     |  Illustrative/default pattern for independent scopes:
     |  orchestration may use one agent or sequential handoffs instead.
     |
     +----------------+----------------+----------------+
     v                v                v
+------------+   +------------+   +------------+
| Specialist |   | Specialist |   | Specialist |
| scoped work|   | scoped work|   | scoped work|
+------------+   +------------+   +------------+
     \                |                /
      \               |               /
       +--------------+--------------+
                      v
             +----------------------+
             | Merge deliverables   |
             +----------------------+
                      |
                      v
              +----------------------+
              | Review / verification|
              +----------------------+
                       |
              +--------+--------+
              |                 |
              | done criteria   | changes needed?
              | met             |
              v                 v
              |        +----------------------+
              |        | Coordinator sends    |
              |        | findings to affected |
              |        | specialist(s)        |
              |        +----------------------+
              |                 |
              |                 v
              |        +----------------------+
              |        | Re-dispatch / revise |
              |        +----------------------+
              |                 |
              |                 v
              |        +----------------------+
              |        | Integrate adjustments|
              |        +----------------------+
              |                 |
              |                 +--> Review / verification again
              v
              +----------------------+
              | wiki: post-review    |
              | learning evaluation  |
              +----------------------+
                         |
                         v
              +----------------------+
              | Uncaptured durable   |
              | workspace knowledge  |
              | remains?             |
              +----------------------+
                         |
                +--------+------------+
                |                     |
                | no                  | yes
                v                     v
       +----------------+  +----------------------+
       | No ingestion   |  | One consolidated     |
       | dispatch       |  | serialized ingestion |
       |                |  | stream               |
       +----------------+  +----------------------+
                |                     |
                |          +----------------------+
                |          | Coordinator reviews  |
                |          | ingestion result     |
                |          +----------------------+
                |                     |
                +----------+----------+
                           v
             +----------------------+
             | Synthesis            |
             | -> final response    |
             +----------------------+
```

### Workflow details

- **The One Rule:** The coordinator delegates every unit to a subagent with no size threshold. Before tool calls, it self-checks that the action is allowed; direct actions are limited to user conversation, skill loading, dispatch/review, and lean context lookup.
- **Team assembly:** Read `wiki/index.md` first, then load `orchestrate` to analyze domains, discover specialists, match exact/adjacent/fallback fits, and compose the team. Preserve separate roles and scopes; generic/default is the last resort, and no role is silently dropped or merged.
- **Structured handoffs:** Every initial delegated handoff starts with `Session type: DELEGATED` and requires `Task`, `Scope`, `Done criteria`, and `Constraints`. Adjacent or generic/fallback matches also require `Act as`; exact matches omit it. Concise `Context` and `Spec ref` are conditional. Purpose, artifact, and return requirements live in the core fields; selected agent, match type, and rationale stay coordinator-internal. The compaction capsule requires preserving the session type, core contract, conditional fields, current status, next step, unresolved decisions, and task-critical facts.
- **Specs:** When work needs a durable behavior contract, load `spec-builder` before `orchestrate`; after user confirmation, orchestration delegates creation or evolution of `specs/` artifacts, then uses the optional `Spec ref` for scoped execution and conformity review.
- **Executor boundary:** Executors use handoff context and do not inspect or edit `wiki/` unless wiki work is explicitly scoped.
- **Learning:** After review/verification and before the final response, `wiki` evaluates every task for uncaptured durable workspace knowledge. Positive findings enter one consolidated serialized ingestion stream owned by the Wiki Ingestion Specialist; negative findings open no additional stream. The coordinator reviews ingestion, and explicit wiki tasks skip only redundant post-task ingestion when reviewed deliverables already capture the knowledge correctly.
- **Wiki versus skill:** If a discovery is clearly procedural and recurring, flag the user to choose `skill-builder` or wiki; never auto-create a skill.
- **Guardrails:** The workflow/coordination skills use anti-rationalization guidance/tables. Statuses are `DONE` (ready for review), `DONE_WITH_CONCERNS` (read concerns), `NEEDS_CONTEXT` (re-dispatch with context), and `BLOCKED` (assess, break, or escalate); after two cycles without progress for repeated `NEEDS_CONTEXT`/`BLOCKED`, stop redispatching and escalate, recompose, or apply a justified fallback.
- **On-demand loading:** `wiki` loads first for coordinator context and again for post-review evaluation; `orchestrate` handles planning and execution; `spec-builder` loads conditionally before `orchestrate` when a durable contract is needed.

Skill roles: `orchestrate` assembles, delegates, reviews, and synthesizes; `wiki` routes context and evaluates/ingests knowledge; `spec-builder` manages durable contracts; `skill-builder` creates, refines, and validates Agent Skills.

## Quick Start

### Use the installer (recommended)

One-time setup. Installs **skills** and the **boot policy** globally for each selected tool. The agent loads only what each task needs.

**Via curl:**

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

*The current installer downloads the repository's GitHub `main` archive and installs from `templates/` inside it; it does not install from the local working tree. Because `main` is mutable, installed content can change over time. For a local checkout, use the manual skills steps below.*

#### What gets installed

| Artifact | Source | Destinations (global) |
|---|---|---|
| Skills | `templates/skills/` | Per-tool skill dirs (see table below) |
| Boot policy | `templates/AGENTS.md` | Per-tool global instruction file (marker-upsert) |
| The Agency agents (default) | [The Agency](https://github.com/msitarzewski/agency-agents) | Per-tool agent dirs; Agency-managed destinations (see Supported tools) |

Boot policy is written between `<!-- agents-workspace:start -->` / `<!-- agents-workspace:end -->` markers. Re-running the installer replaces only that block; content outside the markers is preserved. Copilot uses a dedicated instructions file (full replace is safe).

| Tool | Skills path | Boot policy path |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/AGENTS.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/GEMINI.md` |

#### Installer options

| Flag | Description |
|---|---|
| `--all` | All detected tools (default) |
| `--opencode` | OpenCode only |
| `--claude` | Claude Code only |
| `--copilot` | Copilot only |
| `--no-agency` | Skip agency-agents |
| `--division <list>` | Install only specific divisions (comma-separated) |
| `--list` | Show available skills |
| `--help` | Show help |

#### Using `--no-agency`

You can skip installing The Agency agents with `--no-agency` if you already have a curated team or want to install The Agency agents yourself.
Only the skills and boot policy will be installed.

#### Using `--division`

Filter which agency-agents divisions to install using `--division` with a comma-separated list:

```bash
# Via curl — install only engineering and security
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --division engineering,security

# Combine with --opencode
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --opencode --division design,marketing

# Combine with --all
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --all --division testing,support
```

##### Available divisions

`academic`, `design`, `engineering`, `finance`, `game-development`, `gis`, `healthcare`, `marketing`, `paid-media`, `product`, `project-management`, `sales`, `security`, `spatial-computing`, `specialized`, `support`, `testing`

See [🎭 The Agency](https://github.com/msitarzewski/agency-agents) for the current division catalog and details.

### Manual skills install (local checkout)

```bash
# Skills (example: OpenCode)
mkdir -p ~/.config/opencode/skills
cp -r templates/skills/* ~/.config/opencode/skills/

# Boot policy (OpenCode)
# Use this cp for a clean/local WIP only. If the file already exists,
# prefer install.sh to preserve content outside the managed markers.
cp templates/AGENTS.md ~/.config/opencode/AGENTS.md

# These local steps install skills and boot policy for OpenCode.
# For a complete installation, use the recommended installer, which downloads
# the current GitHub main archive instead of using this local checkout.
```

For agents, follow [The Agency's installation instructions](https://github.com/msitarzewski/agency-agents) or copy the files to your tool's agents directory, such as `~/.config/opencode/agents/`.

### Supported tools

These are the installer target paths currently supported. They are not the normative discovery contract; runtime discovery should remain source-based and platform-aware.

For Antigravity and Copilot, the Agency agent paths below reflect the current upstream `main` installer and may change when the upstream repository changes.

| Tool | Skills path | Agents path | Boot policy path |
|---|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/config/skills/` | `~/.gemini/GEMINI.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` | `~/.claude/CLAUDE.md` |
| Copilot | `~/.copilot/skills/` | `~/.github/agents/` and `~/.copilot/agents/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` | `~/.config/opencode/AGENTS.md` |

## Structure

```
# This repository (template distribution)
AGENTS.md              # Meta only — guidance for working ON this distribution (not consumer boot policy)
tools/install.sh       # Installs skills + global boot policy from the current GitHub main archive
wiki/                  # Knowledge about this product (distribution maintainers / agents here)
templates/             # SOURCE for install — not live until installed
  AGENTS.md            # Boot-policy TEMPLATE — installed globally (marker-upsert) via install.sh
  skills/              # Skill source of truth — install globally via install.sh
    orchestrate/       # Full coordination cycle: assemble, delegate, review, learn, synthesize
    wiki/              # Wiki query and self-learning loop
    skill-builder/     # Skill authoring and validation
    spec-builder/      # Spec-driven workflow: durable behavior contracts

# After install (global, per tool)
~/.config/opencode/AGENTS.md   # OpenCode global rules (managed marker block)
~/.claude/CLAUDE.md            # Claude Code user instructions (managed marker block)
~/.gemini/GEMINI.md            # Antigravity / Gemini CLI global context (managed marker block)
~/.copilot/instructions/...    # Copilot user instructions (dedicated file)

# In your project workspace
wiki/                  # Workspace knowledge — not created by the installer; created on setup/first ingest, then maintained automatically
  index.md
  architecture.md
  conventions/
  domain/
  decisions/
specs/                 # Durable behavior contracts — when spec-builder is used
.agents/skills/        # Workspace-local skills (explicit creation)
# Optional: project-root AGENTS.md / CLAUDE.md for project-specific rules (layers with global)
```
