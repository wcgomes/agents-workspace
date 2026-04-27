# AGENTS.md

Read fully before acting — mandatory, not suggestions. Follow every task, every session.

## Skills

Skills load on demand — full instructions activate only when relevant. All are mandatory when activated.

| Skill | Activates |
|---|---|
| `wiki` | Before any exploration (query) and after every task (ingest). Never skip. Evaluate automatically. |
| `workflow` | Tasks — orchestrates the full lifecycle: plan → delegate to specialists → verify → ingest |
| `invoke-subagents` | Any implementation, investigation, or delegable work. Always delegate — you orchestrate, subagents execute. |
| `parallel-work` | 2+ independent tasks — mandatory parallelization, one specialist per domain. Each agent gets smaller context. |
| `think-before-acting` | Before implementing, refactoring, or fixing code. Validate understanding first. |
| `minimal-changes` | Any code modification. Least code that solves the problem — no drive-by changes. |
| `brevity` | Every response and file edit unless user asks for verbosity. |
| `skill-candidates` | During ingest — evaluate if procedural pattern should be tracked. Track from first encounter, propose at 3+. |
| `agents-skills` | Creating, refining, or validating Agent Skills (SKILL.md, evals, scripts). |

## Boot Sequence

1. Load `workflow` skill — orchestrates the full task lifecycle.
2. Load skills as context demands.

## <HARD-GATE> After Every Task

At the end of EVERY task, you MUST complete all three. No exceptions. No "I'll do it later."

1. **Evaluate wiki ingest** — run the auto-evaluation checklist from `wiki` skill. Do NOT ask the user "should I update the wiki?" — evaluate automatically. If any answer is YES → ingest.
2. **Evaluate skill candidates** — if this task involved a non-obvious procedural pattern, load `skill-candidates` skill and evaluate. Track from first encounter. Do NOT wait for the user to ask.
3. **Lint wiki** — check for contradictions, orphan pages, stale claims.

Skipping any of these breaks the self-learning loop. This is how the workspace learns and improves.

## Non-Negotiables

| Rule | Reason |
|---|---|
| Delegate to specialist agents — never work directly when a specialist fits | Better quality, smaller context |
| Split tasks across multiple specialists, parallel when possible | Reduces context per agent, optimizes tokens |
| Find orchestrator agent to coordinate multi-specialist work | Keeps your context focused on objectives and verification |
| Wiki first — read before exploring, ingest after completing | Prevents wasted effort |
| Before creating a file, search for existing functionality to extend | Prevents sprawl |
| Only create new files when extension is genuinely impossible — say why | Forces reuse |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` when referencing code | Traceability |

## Anti-Rationalization

You WILL be tempted to skip steps. These are the most common rationalizations — none are valid.

| Rationalization | Reality |
|---|---|
| "This is too simple for a workflow" | Simple things become complex. Follow the flow. |
| "I can do this faster myself" | Delegation takes 30 seconds. Fixing your mistakes takes 10 minutes. |
| "Let me just do this quick edit" | "Quick edits" are how bugs enter the codebase. Delegate. |
| "I'll verify at the end" | Verify after each subagent. End-of-pipeline verification catches cascading failures too late. |
| "No need to update wiki for this" | Evaluate automatically. Don't decide "not worth it" before evaluating. |
| "Nothing to ingest this time" | Run the auto-evaluation checklist. You may have learned something you didn't notice. |
| "This pattern is too specific to track" | That's for the skill-candidates skill to decide. Evaluate automatically. |
| "I'll plan while I implement" | Plan and Execute are separate phases. Do not combine them. |
