<div align="center">

# Agents Workspace

**You ask. The right specialists deliver.**

[Quick Start](#quick-start) · [How it works](#how-it-works) · [Use cases](#one-workflow-different-domains) · [Installation](#installation-reference)

</div>

Describe the outcome. Agents Workspace guides your AI assistant to coordinate specialists across research, design, marketing, data analysis, writing, software, and engineering, then bring their work together into a clear, reviewed result.

It distributes reusable skills and instructions, not a separate runtime. Your AI tool supplies the models, tools, and subagent execution.

## Quick Start

You need a [target tool](#installer-targets), Bash, `curl`, and `unzip`.

> **Global install:** skills, specialist agents, and the shared instruction policy (boot policy) go into the selected tools' global configuration, affecting other projects too. The installer downloads current GitHub `main` archives, **even from a local checkout**; it does not install local edits. Review [the script](tools/install.sh) first; remote content can change.

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

This command targets all detected tools and includes [The Agency's specialist catalog](https://github.com/msitarzewski/agency-agents) by default. [Installer options](#installer-options) let you select tools, limit divisions, or keep your own compatible agents with `--no-agency`.

Open a new session with your tool's main assistant and ask for an outcome:

> Review our onboarding flow, fix the main usability issues, and explain what you verified.

You do not need a wiki or a spec to start.

## How it works

1. **Your main assistant coordinates.** It clarifies the outcome and chooses the smallest sufficient team from available specialists. A focused task can use one specialist.
2. **Specialists get focused assignments.** Each has a clear scope, success criteria, and constraints. Only independent work runs in parallel; dependent work stays ordered.
3. **Work is checked.** Specialists self-verify. Independent fresh-context review runs at strategic points, such as final delivery, integration, or risky work—not after every handoff.
4. **You get one answer.** The coordinator combines results and reports completed work, checks run, limitations, and blockers.

## Checks, not just claims

- **Scale checks to risk.** When safe and proportionate, specialists run or observe the deliverable in use. Writing tests is not evidence that they ran.
- **Keep the work complete.** Less work never means dropping a requirement or safety control. Missing required verification blocks the affected conclusion or action; gaps stay visible.
- **Get approval when needed.** The coordinator checks with you before destructive work, work with unclear scope, publishing, or unusually costly work.

## Context and token use

The workflow loads relevant context, keeps handoffs compact, and reuses suitable resources and still-valid evidence. Affected checks repeat after changes. The aim is the smallest complete solution, not merely a shorter answer.

Coordination and review also cost time and tokens. Total cost varies with the task, models, and host tool; savings are not guaranteed.

## One workflow, different domains

Illustrative requests, not completed case studies:

- “Draft a launch campaign from this brief, checking product claims and channel requirements.”
- “Turn these sales figures into a report, reconcile totals, and flag unsupported conclusions.”

## Optional project knowledge

- **Wiki:** preserve durable project decisions and conventions. Ask to initialize one; installation never creates it. See [wiki maintenance](templates/skills/wiki/SKILL.md) and [read-only lookup](templates/skills/wiki-query/SKILL.md).
- **Specs:** agree on outcomes and acceptance before a new API, migration, or other work needing durable alignment. [Spec builder](templates/skills/spec-builder/SKILL.md) manages those plans under `specs/`, with your confirmation before creation.

## Installation reference

Reinstalling replaces the boot-policy block between `<!-- agents-workspace:start -->` and `<!-- agents-workspace:end -->`, preserving text outside it. **Copilot's dedicated instructions file is replaced in full.** Matching skill and agent files can be overwritten; boot-policy markers do not protect them.

### Installer options

| Flag | Description |
|---|---|
| `--claude`, `--codex`, `--copilot`, `--grok`, `--opencode` | Select target tools. |
| `--all` | Select all detected tools; the noninteractive default. |
| `--no-agency` | Skip Agency; use your own specialist catalog. |
| `--division <list>` | Limit Agency to comma-separated divisions. |
| `--list` | Download and list skills without installing. |
| `--help`, `-h` | Show help without downloading archives. |

For example, select OpenCode and two divisions:

```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash -s -- --opencode --division engineering,security
```

An interactive terminal run without flags offers a selection menu; explicit tool flags or `--all` bypass it. Antigravity uses `--all` detection; there is no dedicated flag. Division names follow [Agency's current catalog](https://github.com/msitarzewski/agency-agents).

### Installer targets

These are installer destinations, not an end-to-end compatibility guarantee.

| Tool | Skills | Boot policy |
|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/GEMINI.md` |
| Claude Code | `~/.claude/skills/` | `~/.claude/CLAUDE.md` |
| Codex | `~/.agents/skills/` | `~/.codex/AGENTS.md` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/instructions/agents-workspace.instructions.md` |
| Grok Build | `~/.grok/skills/` | `~/.grok/AGENTS.md` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/AGENTS.md` |

`$GROK_HOME` overrides Grok's base directory; `$CODEX_HOME` overrides Codex's boot-policy directory, not its skills path. Agent destinations and conversions follow [this installer](tools/install.sh) and [Agency's installer](https://github.com/msitarzewski/agency-agents/blob/main/scripts/install.sh); upstream details can change.

### Using local edits

To use checkout edits instead of remote `main`, copy the [skill sources](templates/skills/) to your tool's skills directory above. Merge the managed block from [the boot-policy template](templates/AGENTS.md) into its instruction file, preserving unrelated content; append it if no block exists. Adapt to the host's file format. This does not install specialist agents.

## Further reading

- [Boot policy](templates/AGENTS.md): delegation boundaries and the short path for trivial work.
- [Orchestration](templates/skills/orchestrate/SKILL.md): coordination, approval, evidence, and model/effort controls; [review loop](templates/skills/orchestrate/references/review-loop.md): finding resolution and convergence.
- [Skill builder](templates/skills/skill-builder/SKILL.md): authoring reusable skills. [Contributor guidance](AGENTS.md): maintaining this distribution rather than installed copies.
