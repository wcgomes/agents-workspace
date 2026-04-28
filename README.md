# Agents Workspace

**AI agent workflow toolkit.** Specialist-first delegation, workspace memory, minimal changes. Works with Claude Code, OpenCode, Copilot, and more.

> Integrates [agency-agents](https://github.com/msitarzewski/agency-agents) — 144+ specialized agents trusted by **86k+ developers**. Our installer adds 5 foundational skills on top.

## Who is this for

- **Anyone** who wants an optimized, consistent, self-learning workflow with AI agents — for coding, design, marketing, research, writing, data analysis, or any other task
- **Teams** needing consistent agent behavior across multiple projects

## Why use it

| Without | With |
|---|---|
| Agent implements directly, accumulates context | Discovers and delegates to the best specialists with focused context |
| Changes broader than needed | Minimal, targeted changes |
| Skips verification, presents broken work | Two-stage review: spec compliance → code quality |
| Verbose responses waste context window | Dense, filler-free communication |
| Forgets what it learned between sessions | Self-learning wiki persists knowledge |
| Same mistakes repeated across tasks | Skill candidates detect and codify patterns |
| No workflow enforcement | Specialist-first policy + HARD-GATEs + anti-rationalization |

## How it works

- **Specialist-first workflow** — agent discovers specialists, selects the best semantic match, delegates, reviews, and validates. Generalist execution is fallback only.
- **Automatic wiki ingest** — agent evaluates after every task what it learned. No need to ask. Self-learning loop.
- **Automatic skill candidate tracking** — agent detects recurring procedural patterns. Tracks from first encounter, proposes at 3+.
- **HARD-GATEs between phases** — Plan → Execute → Verify → After Task. No skipping. No combining.
- **Anti-rationalization tables** — every skill anticipates excuses agents use to skip steps and refutes them.
- **Parallel specialist teams** — independent scopes can be dispatched to multiple specialists automatically.
- **Controlled subdelegation** — specialists may subdelegate when specialization or decomposition improves the task, while accountability stays with the delegator.

| Mechanism | Skill | What it does |
|---|---|---|
| **Delegation** | `delegate` | Discovers specialists, selects the best fit, dispatches structured handoffs, and reviews delegated work. |
| **Self-learning wiki** | `wiki` | Reads workspace knowledge before coding, ingests learnings after. Tracks skill candidates. |
| **Minimal changes** | `implement` | Validates understanding before acting. Writes the least code that solves the problem. |
| **Systematic debugging** | `debug` | Investigates errors with observe-hypothesize-verify-fix-confirm cycle. |
| **Skill authoring** | `agents-skills` | Creates, refines, and validates Agent Skills following the agentskills.io spec. |

Skills load **on-demand** — the agent only activates what the current context requires.

## 🎭 The Agency: AI Specialists Ready to Transform Your Workflow

A complete AI agency at your fingertips - From frontend wizards to Reddit community ninjas, from whimsy injectors to reality checkers. Each agent is a specialized expert with personality, processes, and proven deliverables.

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

> Installed by default. Use `--no-agency` to skip and install only the 5 base skills. The workflow is designed to discover these specialists automatically and choose the best fit for each task.

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

`AGENTS.md` is the boot contract. The agent reads it on every session start. It defines the specialist-first policy for discovery, selection, delegation, fallback, and accountability. It is **not** installed globally.

**Step 3 — Let the agent create `wiki/`**

The agent creates `wiki/` on first ingest. This is workspace-specific knowledge — do not copy from this repo.

> **Tip:** In an existing workspace, ask the agent to "set up the wiki" before starting. This primes the self-learning loop.

**Step 4 — Skills evolve locally (automatic)**

As the agent works, it detects recurring procedural patterns. After 3 encounters, it proposes a new skill. If approved, the skill is created in `.agents/skills/` within your workspace — local to that project.

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
  delegate/            # Discovery, selection, handoff, review, fallback
  wiki/                # Wiki query and self-learning loop
  implement/           # Validation and minimal changes
  debug/               # Systematic error investigation
  agents-skills/       # Skill authoring and validation

# In your workspace (created by the agent)
wiki/                  # Workspace knowledge — created on first ingest
  index.md
  architecture.md      # System structure overview
  conventions/         # One file per convention
  domain/              # One file per business rule
  decisions/           # One file per ADR
  skill-candidates/    # Recurring patterns tracked for promotion
.agents/skills/        # Skills created from candidates — workspace-local
  <your-custom-skill>/
```
