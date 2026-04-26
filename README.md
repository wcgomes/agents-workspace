# Agents Workspace

Template for AI-agent-driven development. Not a project — a behavioral contract. Install 8 workflow skills + **144+ specialized agents** globally once, then drop `AGENTS.md` into any workspace. The agent gains consistency, quality, and self-learning.

## Problem

Agents without guidance:
- Repeat mistakes across sessions
- Bloat context with noise
- Make careless adjacent changes
- Don't learn from prior work

## Solution: 6 mechanisms

1. **Isolated context per subagent** — `invoke-subagents` delegates every task to a specialist. Each subagent receives only the context it needs. No session inheritance, no bloat. The coordinator orchestrates; specialists execute.
2. **Orchestrated workflow** — `workflow` + `parallel-work` coordinate planning, delegation, and execution. No task starts without a goal; no task ends without QA.
3. **Dense communication** — `brevity` strips filler from every response and file edit. Finite context windows are preserved for actual reasoning, not pleasantries.
4. **Self-learning wiki** — `wiki` instructs the agent to read `wiki/index.md` before touching code and ingest learnings after. Knowledge persists across sessions.
5. **Behavioral guardrails** — `think-before-acting` and `minimal-changes` constrain how the agent plans and edits. Ask before assuming; change only what is needed.
6. **Evolving skills** — `skill-candidates` detects recurring procedural patterns during ingest. After 3 encounters, proposes a new skill to the user. The workspace grows its own behavioral rules over time.

## How skills work together

| Moment | Skills active | What happens |
|---|---|---|
| Task received | `invoke-subagents` | Assess → pick specialist → delegate. No direct work. |
| Before coding | `wiki`, `think-before-acting` | Read wiki, validate understanding, define "done". |
| During coding | `minimal-changes`, `brevity` | Least code, dense communication, no drive-by fixes. |
| Parallel work | `parallel-work` | Independent tasks dispatched concurrently. |
| After task | `wiki`, `skill-candidates` | Ingest learnings. If a pattern repeats 3×, propose a skill. |

Skills are **on-demand** — the agent loads only what the current context requires. Each is a focused behavioral rule, not a library.

## Using this template

**Step 1 — Install skills and agents globally**

The installer deploys 8 workflow skills plus **144+ specialized agents** from [agency-agents](https://github.com/msitarzewski/agency-agents). This is a one-time setup — the agent loads only what each task needs.

The agency covers **15 divisions**: Engineering, Design, Marketing, Sales, Product, Project Management, Testing, Support, Paid Media, Finance, Strategy, Game Development, Spatial Computing, Academic, and Specialized domains (legal, healthcare, compliance, recruitment, and more).

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

> Agency-agents is installed by default. Use `--no-agency` to skip the 144+ agents and install only the 8 base skills.

**Step 2 — Copy `AGENTS.md` into your workspace**

```bash
cp AGENTS.md /path/to/your-project/
```

`AGENTS.md` is the boot contract. It is **not** installed globally and **not** copied by the skills installer. The agent reads it on every session start.

**Step 3 — Let the agent create `wiki/`**

The `wiki/` directory is workspace-specific knowledge. The agent creates it on first ingest.

> **Tip:** If working in an existing workspace, ask the agent to "set up the wiki" before starting tasks. This triggers the initial `index.md` creation and primes the self-learning loop.

**Step 4 — Skills evolve locally (automatic)**

As the agent works, the `skill-candidates` skill detects recurring procedural patterns. After 3 encounters in distinct tasks, it proposes a new skill to you. If approved, the skill is created in `.agents/skills/` within your workspace — local to that project, not installed globally.

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

## Credits

All credits for the specialized agents (agency-agents) go to the [agency-agents community](https://github.com/msitarzewski/agency-agents). The installer optionally integrates them. Use `--no-agency` to skip.
