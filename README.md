# Agents Workspace

**One request. The right specialists. A reviewed result.**

Give your AI assistant an outcome, not a roster to manage. Agents Workspace provides portable skills and a boot policy that guide your assistant to coordinate domain specialists, delegate scoped work, and review the result before handing it back to you.

It is a template distribution—not a separate agent runtime. Your AI tool supplies the models, tools, and subagent execution. The installer includes [The Agency](https://github.com/msitarzewski/agency-agents) specialist catalog by default, spanning engineering, design, marketing, sales, finance, and other domains. You can also use your own catalog.

## Quick Start

Use a tool listed in [Installer targets](#installer-targets), with Bash, `curl`, and `unzip` available.

> **Global install, remote source:** This installs skills, specialist agents, and a boot policy globally for the selected tools, affecting sessions beyond this project. The installer downloads the current GitHub `main` archives—even when you run `./tools/install.sh` from a local checkout. It does **not** install your local edits, and installed content can change as `main` changes. Review [the installer](tools/install.sh) before running it.

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

This piped command targets all detected tools. To choose a tool, limit Agency divisions, or keep your own specialists with `--no-agency`, see [Installer options](#installer-options).

Open a new session with your tool's main assistant and ask for an outcome as you normally would:

> Review our onboarding flow, fix the main usability issues, and explain what you verified.

Your main assistant acts as the **coordinator**: it selects specialists, scopes their work, and brings their results back for review. You do not need a wiki or a spec to start.

## One workflow, different domains

These are **illustrative requests, possible teams, and verification targets**, not recorded runs or guaranteed outcomes. The coordinator selects the smallest sufficient team from available specialists; a focused task can use one specialist, while dependencies may call for sequential work rather than parallel execution.

| Your request | Possible team | What a verified outcome would include |
|---|---|---|
| “Improve our onboarding flow and implement the changes.” | UX researcher, frontend developer, accessibility specialist | Updated flow, checks of the relevant interactions and accessibility behavior, and explicit coverage gaps. |
| “Prepare a launch campaign for this product.” | Marketing strategist, copywriter, designer | Campaign brief, copy, and creative assets checked against the audience, brand, channel requirements, and supplied product facts—not a promise of campaign performance. |
| “Turn these sales figures into a decision-ready report.” | Data analyst, finance specialist, data visualization specialist | Reconciled totals, traceable assumptions, and a rendered report checked for readable charts and supported conclusions. |

Roles follow the task, not a fixed team template. Review and verification can stay with an existing role when its expertise and scope fit; a separate reviewer is added when distinct expertise or independence is needed.

## How it works

**Request → context → team → scoped execution → review and verification → synthesis**

1. **Understand the outcome.** The coordinator gathers lean context and defines what “done” means.
2. **Choose the specialists.** It matches domains to available agents and delegates every unit of work. Independent scopes can run in parallel; dependent work stays ordered.
3. **Check the result.** Review covers scope, quality, and evidence. When safe and proportionate, specialists exercise the deliverable where it will be used—not just inspect its source. Valid evidence is reused; affected checks repeat after changes.
4. **Return a reviewed answer.** The coordinator sends findings back for correction when needed, then summarizes deliverables, checks, and remaining limitations. Blocked work is surfaced rather than silently treated as complete.

The skills guide this behavior; actual execution depends on your host tool, available agents, permissions, and resources. See [Workflow details](#workflow-details) for the operating rules.

## Project knowledge and durable plans

### Wiki: optional project memory

If you want durable project knowledge, ask:

> Initialize a wiki for this project using the wiki skill.

A root-level `wiki/` enables consultation before work and a post-review evaluation for tasks associated with that project. Updates happen only when they add material durable value after accounting for duplication and upkeep—not after every task. The installer never creates a project wiki, and standalone chats do not inherit this workflow just because a wiki exists in the current directory.

See the [Wiki gate](templates/AGENTS.md#coordinator-flow), [read-only consultation skill](templates/skills/wiki-query/SKILL.md), and [wiki maintenance skill](templates/skills/wiki/SKILL.md).

### Specs: when the outcome needs a contract

For work that needs an agreed, durable behavior contract—such as a new API, migration, or security-sensitive change—`spec-builder` manages proposals, outcome specs, and task plans under `specs/`, with your confirmation before creating them. Orchestration uses those artifacts for scoped execution and conformance review. Small, well-defined work can proceed from explicit done criteria without adding a spec.

See [spec-builder](templates/skills/spec-builder/SKILL.md) for when and how to use it.

## Installation reference

### What gets installed

| Artifact | Source | Installation behavior |
|---|---|---|
| Workflow skills | `templates/skills/` | Copies skills into each selected tool's global skills directory. |
| Boot policy | `templates/AGENTS.md` | Upserts the managed block in the global instruction file. |
| Specialist agents (default) | External [Agency catalog](https://github.com/msitarzewski/agency-agents) | Converts/installs agents for the selected tools; skip with `--no-agency`. |

The boot policy uses `<!-- agents-workspace:start -->` / `<!-- agents-workspace:end -->` markers. Re-running the installer replaces that block and preserves content outside it. Copilot uses a dedicated instructions file that is replaced in full. Skills and Agency agents are not protected by these boot-policy markers.

### Installer options

| Flag | Description |
|---|---|
| `--all` | Install for all detected tools; the noninteractive default. |
| `--claude` | Select Claude Code. |
| `--codex` | Select Codex. |
| `--copilot` | Select Copilot. |
| `--grok` | Select Grok Build. |
| `--opencode` | Select OpenCode. |
| `--no-agency` | Install only skills and boot policy; keep your own specialist catalog. |
| `--division <list>` | Limit Agency agents to comma-separated divisions. |
| `--list` | Download and list available workflow skills without installing. |
| `--help`, `-h` | Show help. |

For example, select OpenCode and two Agency divisions:

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --opencode --division engineering,security
```

Or keep your existing agents:

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --all --no-agency
```

Use [The Agency's current catalog](https://github.com/msitarzewski/agency-agents) for division names and specialist descriptions. Divisions include engineering, design, marketing, finance, sales, security, and testing; availability follows upstream `main`.

From a checkout, run `./tools/install.sh` with explicit tool flags or `--all` to avoid interactive selection. It still downloads remote `main`. To include Antigravity, use `--all` with Antigravity detected; there is no dedicated `--antigravity` flag.

### Installer targets

These are installer destinations, not a claim of end-to-end validation on every tool. Agent discovery at execution time follows the host platform's available sources, not this path table alone.

| Tool | Skills path | Agents path | Boot policy path |
|---|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/config/skills/` | `~/.gemini/GEMINI.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` | `~/.claude/CLAUDE.md` |
| Codex | `~/.agents/skills/` | `~/.codex/agents/` | `~/.codex/AGENTS.md` |
| Copilot | `~/.copilot/skills/` | `~/.github/agents/` and `~/.copilot/agents/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Grok Build | `~/.grok/skills/` | `~/.grok/agents/` | `~/.grok/AGENTS.md` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` | `~/.config/opencode/AGENTS.md` |

Grok paths use `$GROK_HOME` when set, otherwise `~/.grok`. The Codex boot-policy path uses `$CODEX_HOME` when set, otherwise `~/.codex`. Codex skills use the current user location, `~/.agents/skills/`. Codex specialist agents are installed by Agency's own installer (`--tool codex`) into `~/.codex/agents/`. Agency-managed destinations, including Copilot and Antigravity, depend on the upstream installer and can change.

### Manual install from a local checkout

Use this route to install your local template edits rather than remote `main`. Run from the repository root. These steps install OpenCode skills and boot policy only, not specialist agents.

```bash
mkdir -p ~/.config/opencode/skills
cp -r templates/skills/* ~/.config/opencode/skills/
```

This copies over same-named skill files. For the boot policy, if `~/.config/opencode/AGENTS.md` already exists, manually replace its managed marker block (or append the template if no block exists), preserving unrelated instructions. **Only for a new instruction file**, copy the template:

```bash
cp -n templates/AGENTS.md ~/.config/opencode/AGENTS.md
```

The no-clobber flag leaves an existing file unchanged; it does not update its policy. For other tools, use the destinations above and the host's instruction-file format. For specialists, follow [The Agency's installation instructions](https://github.com/msitarzewski/agency-agents) or use your own compatible agents.

## Workflow details

<details>
<summary>Coordination boundaries, review loop, and source references</summary>

The **coordinator does not execute task work**. It talks with you, loads skills, gathers lean context, dispatches specialists, and reviews their results. Executors stay within their assigned scope and do not assemble another team.

```text
Request → lean context (wiki-query when applicable)
        → spec-builder when a durable contract is needed
        → orchestrate: select roles, plan, and delegate
        → scoped execution (single, sequential, or parallel)
        → integrate → review / verification
                         ├─ findings → revise → review again
                         ├─ blocked → clarify, escalate, or recompose
                         └─ criteria met → wiki evaluation when applicable
                                         → conditional update → synthesis
```

Handoffs define the task, scope, done criteria, and constraints, with context and a spec reference when needed. Review checks both the deliverable and its evidence; it does not automatically rerun valid checks. The final synthesis identifies any partial, blocked, or inapplicable verification and explains gaps.

Project wiki updates use one serialized ingestion stream only when the post-review evaluation justifies a change. No useful change means no write. Recurring procedures may warrant a skill instead, but the workflow does not automatically create one.

Use the source documents for the full contract rather than treating this overview as a second policy:

- [Boot policy](templates/AGENTS.md): session boundaries, delegation, and conditional wiki workflow.
- [Orchestrate](templates/skills/orchestrate/SKILL.md): role discovery, handoffs, coordination patterns, evidence, statuses, and escalation.
- [Skill builder](templates/skills/skill-builder/SKILL.md): authoring and validating reusable skills.

</details>

## Structure

```text
AGENTS.md              # Guidance for maintaining this distribution, not consumer policy
README.md              # Adoption guide and installation reference
tools/install.sh       # Installer; downloads current GitHub main
templates/             # Source of truth; changes take effect after installation
  AGENTS.md            # Consumer boot-policy template
  skills/
    orchestrate/       # Team assembly, delegation, review, and synthesis
    wiki-query/        # Read-only project knowledge lookup
    wiki/              # Wiki setup, evaluation, and maintenance
    spec-builder/      # Durable outcome contracts and task plans
    skill-builder/     # Skill authoring and validation
wiki/                  # This distribution's own project knowledge
```

In your projects, `wiki/` is optional and explicitly initialized; `specs/` holds contracts when needed. Project-specific `AGENTS.md` / `CLAUDE.md` instructions can layer with global policy, and `.agents/skills/` can hold explicitly created workspace-local skills where your tool supports them.
