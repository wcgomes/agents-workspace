# Agents Workspace

**Behavioral contract for AI coding agents.** Install once, works with Claude Code, OpenCode, Cursor, Copilot, and more.

> Integrates [agency-agents](https://github.com/msitarzewski/agency-agents) — a collection of 144+ specialized agents trusted by **86k+ developers**. Our installer adds 8 workflow orchestration skills on top.

## The problem

You ask your AI agent to fix authentication. It:
- Refactors 3 unrelated files
- Adds a dependency you didn't ask for
- Doesn't update the docs
- Next session, repeats the same mistakes

**Agents without guidance are expensive interns.** They work hard, learn nothing, and leave messes.

## What this solves

**Before:** Vague prompts → wandering agents → broken code → repeated mistakes.

**After:** Focused context → specialist delegation → minimal changes → self-learning wiki → evolving skills.

## How it works: 6 mechanisms

| Mechanism | Skill | What it does |
|---|---|---|
| **Isolated context** | `invoke-subagents` | Delegates every task to a specialist with focused context. No session bloat. |
| **Orchestrated workflow** | `workflow` + `parallel-work` | Plans tasks, coordinates execution, runs QA. No task ends without validation. |
| **Dense communication** | `brevity` | Strips filler from responses and edits. Preserves context window for reasoning. |
| **Self-learning wiki** | `wiki` | Reads workspace knowledge before coding, ingests learnings after. Memory persists. |
| **Behavioral guardrails** | `think-before-acting` + `minimal-changes` | Validates understanding before acting. Changes only what's needed. |
| **Evolving skills** | `skill-candidates` | Detects recurring patterns. After 3 encounters, proposes a new skill. Workspace grows its own rules. |

Skills load **on-demand** — the agent only activates what the current context requires.

## Who is this for

- **Solo developers** tired of cleaning up after AI agents
- **Teams** needing consistent agent behavior across multiple projects
- **Anyone using Claude Code, OpenCode, Cursor, Copilot, or similar tools**
- **Projects where context window is finite** and every token counts

## What you get

**8 workflow skills** for orchestration, quality, and memory:

- `invoke-subagents` — specialist delegation
- `workflow` — task planning and QA
- `parallel-work` — concurrent independent tasks
- `wiki` — workspace knowledge and self-learning
- `think-before-acting` — validate before coding
- `minimal-changes` — least code that solves the problem
- `brevity` — dense, filler-free communication
- `skill-candidates` — pattern detection and skill evolution

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

## Setup in 4 steps

**Step 1 — Install skills and agents globally**

One-time setup. The agent loads only what each task needs.

**Via curl:**
```bash
curl -sL https://raw.githubusercontent.com/wcgomes/agents-workspace/main/tools/install-skills.sh | bash
```

**Or clone and run locally:**
```bash
git clone https://github.com/wcgomes/agents-workspace.git
cd agents-workspace
./tools/install-skills.sh
```

> Agency-agents (144+ specialized agents) is installed by default. Use `--no-agency` to skip and install only the 8 base skills.

**Step 2 — Copy `AGENTS.md` into your workspace**

```bash
cp AGENTS.md /path/to/your-project/
```

`AGENTS.md` is the boot contract. The agent reads it on every session start. It is **not** installed globally.

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
AGENTS.md              # Boot instructions — copy to each workspace
skills/                # Loadable behavioral rules — install globally
  invoke-subagents/
  wiki/
  workflow/
  think-before-acting/
  brevity/
  minimal-changes/
  parallel-work/
  skill-candidates/

# In your workspace (created by the agent)
wiki/                  # Workspace knowledge — created on first ingest
  index.md
  skill-candidates/    # Recurring patterns tracked for promotion
.agents/skills/        # Skills created from candidates — workspace-local
  <your-custom-skill>/
```

## Start using it

1. [Install skills and agents](#setup-in-4-steps)
2. Copy `AGENTS.md` to your project
3. Tell your agent: "Set up the wiki and start working"

The agent handles the rest.

## Credits

**Thank you to the [agency-agents community](https://github.com/msitarzewski/agency-agents)** for building and maintaining an incredible collection of 144+ specialized agents across 15 divisions. Their work makes multi-domain AI delegation practical and accessible.

Workflow skills, orchestration logic, and installer from agents-workspace. Use `--no-agency` to skip agency-agents.
