# Agents Workspace

> **AI agent workflow toolkit.** Specialist-first, team-driven workflow with workspace memory. 
> **Powered by [The Agency](https://github.com/msitarzewski/agency-agents)** with more than 144+ specialized agents trusted by 86k+ developers.

**Simple by design.** Just portable skills and a single `AGENTS.md` file. No hooks, plugins, or platform-specific configuration.

**For anyone** who wants an optimized, consistent, self-learning workflow with AI agents — for coding, design, marketing, research, writing, data analysis, or any other task.

**Teams** needing consistent agent behavior across multiple projects.

## How it works 

**Describe what you want** — the main agent never executes the work itself; it assembles the right team of specialists, delegates every unit of work, reviews the results, and synthesizes them. Along the way, it builds a knowledge base in the wiki that makes future tasks faster and more accurate. You stay in control: suggest agents, adjust the team, or take over at any point.

## Why use it

| Without | With |
|---|---|
| Agent implements directly, accumulates context | Assembles specialist teams and delegates with focused context |
| Changes broader than needed | Minimal, targeted changes |
| Skips verification, presents broken work | Two-stage review: spec compliance → code quality |
| Verbose responses waste context window | Dense, filler-free communication |
| Forgets what it learned between sessions | Self-learning wiki persists knowledge |
| Same mistakes repeated across tasks | Skill candidates detect and codify patterns |
| No workflow enforcement | One Rule (main agent always delegates, never executes) + self-check + anti-rationalization |

## Workflow details

- **Team-driven workflow** — the agent reads `wiki/index.md` for workspace context, loads `orchestrate`, then composes the team for the request: analyzes domains, discovers available specialists, sizes the team (one specialist for a focused task, a full team for multi-domain work), selects a coordination pattern (parallel, sequential, or mixed), and plans execution order. Generalist execution is fallback only after exhausting adjacent specialists.
- **Structured delegation** — `orchestrate` handles each handoff with a canonical shape (task, objective, scope, done criteria, constraints, deliverable, return format). Specialists load `execute` for code work or error investigation.
- **Automatic wiki maintenance** — agent reads `wiki/index.md` before broad workspace exploration when available, then evaluates after every task what to add, update, remove, reindex, and lint to avoid orphaned or contradictory pages. No need to ask. Self-learning loop.
- **Automatic skill candidate tracking** — agent detects recurring procedural patterns. Tracks from first encounter, proposes at 3+.
- **The One Rule** — the main agent never does the work itself; it delegates every unit of work to a subagent. It coordinates: plans, delegates, reviews, synthesizes. Before any task tool call, a self-check confirms the action is allowed (read wiki, talk to user, dispatch subagent) or must be delegated. No size threshold — even a one-line change is delegated.
- **Anti-rationalization tables** — every skill anticipates excuses agents use to skip steps and refutes them.
- **Parallel specialist teams** — independent scopes can be dispatched to multiple specialists automatically.
- **Controlled subdelegation** — specialists may subdelegate when specialization or decomposition improves the task, while accountability stays with the delegator and subscopes still follow the same rules.
- **Role preservation** — roles defined during team composition are mandatory. If no specialist is found, adjacent match or generic agent acts in that role. Roles are never dropped from the plan.

| Mechanism | Skill | What it does |
|---|---|---|
| **Orchestration** | `orchestrate` | Full coordination cycle: analyze domains, discover specialists, compose team, plan execution, handoff, review and synthesize. |
| **Self-learning wiki** | `wiki` | Reads `wiki/index.md` before broad exploration, then adds, updates, removes, and lints workspace knowledge after tasks. Tracks skill candidates. |
| **Skill authoring** | `agents-skills` | Creates, refines, and validates Agent Skills following the agentskills.io spec. |

Skills load **on-demand**, in flow order: `wiki` for context first, then `orchestrate` to compose the team and delegate.

## 🎭 The Agency: AI Specialists Ready to Transform Your Workflow

A complete AI agency at your fingertips — from frontend wizards to Reddit community ninjas, from whimsy injectors to reality checkers. Each agent is a specialized expert with personality, processes, and proven deliverables.

**144+ specialized agents** from [agency-agents](https://github.com/msitarzewski/agency-agents) across 15 divisions:

- **Engineering** — Frontend, Backend, Mobile, AI Engineer, DevOps, Security, SRE, and more
- **Design** — UI Designer, UX Researcher, Brand Guardian, Visual Storyteller
- **Marketing** — Growth Hacker, Content Creator, SEO, Social Media, Podcast Strategist
- **Sales** — Outbound Strategist, Deal Strategist, Sales Engineer, Pipeline Analyst
- **Product** — Product Manager, Sprint Prioritizer, Trend Researcher
- **Project Management** — Studio Producer, Project Shepherd, Jira Workflow Steward
- **Testing** — Reality Checker, Performance Benchmarker, Accessibility Auditor
- **Support** — Support Responder, Analytics Reporter, Infrastructure Maintainer
- **Paid Media** — PPC Strategist, Ad Creative Strategist, Tracking Specialist
- **Finance** — Finance Tracker, Accounts Payable Agent
- **Strategy** — Strategic Advisor, Competitive Analyst
- **Game Development** — Game Designer, Level Architect
- **Spatial Computing** — XR Developer, VisionOS Engineer
- **Academic** — Research Assistant, Citation Manager
- **Specialized** — Legal, Healthcare, Compliance, Recruitment, Translation, and more

> Installed by default. Use `--no-agency` to skip and install only the 6 base skills. The workflow is designed to discover these specialists automatically and assemble the best team for each task.

### Credits

**Thank you to the [agency-agents community](https://github.com/msitarzewski/agency-agents)** for building and maintaining an incredible collection of 144+ specialized agents across 15 divisions. Their work makes multi-domain AI delegation practical and accessible.

## Setup in 4 steps

**Step 1 — Install skills and agents globally**

One-time setup. The agent loads only what each task needs.

**Via curl:**
```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash
```

**Or clone and run locally:**
```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install.sh
```

**Step 2 — Copy `AGENTS.md` into your workspace**

```bash
cp AGENTS.md /path/to/your-project/
```

`AGENTS.md` is the boot contract. The agent reads it on every session start. It defines the operating mode (The One Rule: the main agent never executes, it delegates every unit of work to a subagent) and the flow: read context, compose the specialist team, delegate to best semantic match, review, and synthesize. It is **not** installed globally.

**Step 3 — Let the agent create `wiki/`**

The agent may create `wiki/` when setup is explicit, or when the `wiki` skill needs to ingest, maintain, or persist new knowledge. After that, the workflow treats `wiki/index.md` as the first workspace knowledge source before broad exploration, and maintains the wiki by adding, updating, removing, reindexing, and linting entries as part of self-learning. This is workspace-specific knowledge — do not copy from this repo.

> **Tip:** In an existing workspace, ask the agent to "set up the wiki" before starting. This primes the self-learning loop.

**Step 4 — Skills evolve locally (automatic)**

As the agent works, it detects recurring procedural patterns. After 3 encounters, it proposes a new skill. If approved, the skill is created in `.agents/skills/` within your workspace — local to that project.

**Updating**

To update skills and agents to the latest version, run the install script again. Then update `AGENTS.md` in your workspace if the boot policy changed:

```bash
# Re-run the installer to update skills and agents globally
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install.sh | bash

# Update AGENTS.md in your workspace
cp AGENTS.md /path/to/your-project/
```

Wiki content and workspace-local skills are preserved — only global skills and agents are overwritten.

### Installer options

| Flag | Description |
|---|---|
| `--all` | All detected tools (default) |
| `--opencode` | OpenCode only |
| `--claude` | Claude Code only |
| `--copilot` | Copilot only |
| `--no-agency` | Skip agency-agents |
| `--list` | Show available skills |
| `--help` | Show help |

### Supported tools

These are the installer target paths currently supported. They are not the normative discovery contract; runtime discovery should remain source-based and platform-aware.

| Tool | Skills path | Agents path |
|---|---|---|
| Antigravity | `~/.gemini/antigravity/skills/` | `~/.gemini/antigravity/skills/` |
| Claude Code | `~/.claude/skills/` | `~/.claude/agents/` |
| Copilot | `~/.copilot/skills/` | `~/.copilot/agents/` |
| OpenCode | `~/.config/opencode/skills/` | `~/.config/opencode/agents/` |

## Structure

```
AGENTS.md              # Boot policy — copy to each workspace
skills/                # Loadable behavioral rules — install globally
  orchestrate/         # Full coordination cycle: analyze, compose, handoff, review
  wiki/                # Wiki query and self-learning loop
  agents-skills/       # Skill authoring and validation

# In your workspace (created by the agent)
wiki/                  # Workspace knowledge — created on setup/first ingest, then maintained automatically
  index.md
  architecture.md      # System structure overview
  conventions/         # One file per convention
  domain/              # One file per business rule
  decisions/           # One file per ADR
  skill-candidates/    # Recurring patterns tracked for promotion
.agents/skills/        # Skills created from candidates — workspace-local
  <your-custom-skill>/
```
