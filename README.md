# AGENTS.md

This repository hosts an example of **AGENTS.md** — a configuration file that defines how AI agents should operate in a software project.

## What is AGENTS.md?

AGENTS.md is a project-specific instruction file that tells AI agents how to behave, what to prioritize, and what constraints to follow. It sits at the root of your repository and serves as the operational manual for any AI agent working on your codebase.

Think of it as the inverse of a **README** — where a README tells humans what a project does, AGENTS.md tells agents how to work on it.

## Motivations

### 1. AI agents need guidance, not just code

Large language models are powerful but undirected. Without explicit instructions, they guess, over-engineer, or make assumptions that don't match your intent. AGENTS.md removes the guesswork by giving agents clear, project-specific rules.

### 2. Every project has unique constraints

Your architecture, coding style, review process, and domain knowledge shouldn't need to be re-explained every time. AGENTS.md encodes these once and applies them consistently across all agent interactions.

### 3. Humans should stay in control

Agents are assistants, not autonomous decision-makers. AGENTS.md enforces human approval at the right moments, preventing runaway changes and ensuring the final output matches what you expect.

### 4. Knowledge should persist

Project knowledge often lives only in the heads of maintainers. AGENTS.md's **Wiki** system creates a shared, writable memory that both humans and agents can contribute to and rely on.

## Objectives

1. **Predictable agent behavior** — Agents follow a consistent workflow (PLAN → BUILD → QA → APPROVAL → APPLY → DOCS) that mirrors how good teams operate.

2. **Minimal, surgical changes** — Agents produce the smallest diff that solves the problem, avoiding speculative features and scope creep.

3. **Explicit assumptions** — Agents state what they think before acting, giving humans a chance to correct misunderstandings early.

4. **Living documentation** — Knowledge discovered during work is immediately written to the wiki, creating institutional memory that outlives any single session.

5. **Specialized expertise on demand** — Agents delegate to domain specialists (security, databases, frontend, etc.) when appropriate, rather than pretending expertise they don't have.

## Key Principles

| Principle | What it means |
|---|---|
| **Think before acting** | State assumptions. Ask when unclear. Don't guess silently. |
| **Minimum viable change** | Write the least code that solves the problem. No unused abstractions. |
| **Surgical changes** | Fix what's asked. Don't improve adjacent code. Match existing style. |
| **Verify before finishing** | Run tests, linter, build. Fix failures before presenting. |
| **Human approval required** | Never apply changes without explicit user approval. |
| **Write to wiki** | Preserve architectural decisions, patterns, and domain knowledge. |

## The Wiki System

AGENTS.md introduces a `wiki/` directory that acts as the project's knowledge base:

- **Ingest** — When something worth preserving is learned (architectural decision, pattern, domain rule), write it to the wiki immediately.
- **Query** — Before answering a question about the project, check the wiki first.
- **Lint** — After completing a task, scan for contradictions or orphan pages.

This turns every agent session into a contribution to a shared, queryable knowledge base.

## Adopting AGENTS.md

To use AGENTS.md in your own project:

1. Copy `AGENTS.md` to your repository root
2. Customize the principles to match your workflow
3. Create the `wiki/` directory with an `index.md`
4. Commit it and let agents know to read it first

## Further Reading

- Read the full [AGENTS.md](./AGENTS.md) for the complete specification
- Explore the [wiki/](./wiki/) directory for example knowledge pages