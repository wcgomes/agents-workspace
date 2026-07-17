# Wiki Index

Quick-reference index. Find files by keyword.

## architecture
- [architecture.md](architecture.md) — directory structure, data flow, component relationships

## domain
- [template-vs-installed.md](domain/template-vs-installed.md) — templates/ source vs installed skills vs copied AGENTS.md; distribution meta vs consumer live contracts
- [agents-md.md](domain/agents-md.md) — three AGENTS.md locations: templates/ (consumer template), consumer root (live), repo root (meta stub)
- [skill-system.md](domain/skill-system.md) — skill discovery, progressive loading, lifecycle
- [installation-flow.md](domain/installation-flow.md) — install.sh always downloads main.zip (templates/skills); AGENTS.md manual copy; local WIP via cp

## conventions
- [editing-rules.md](conventions/editing-rules.md) — edit templates/ not installed copies; which AGENTS.md to touch
- [language.md](conventions/language.md) — language convention for files and communication

## decisions
- [0001-adopt-spec-driven-development.md](decisions/0001-adopt-spec-driven-development.md) — adopt spec-builder skill for spec-driven development; specs/ + Spec ref handoff field
- [0002-templates-layout.md](decisions/0002-templates-layout.md) — installable source under templates/; root AGENTS.md meta; install.sh always zip-from-main

> Pages not listed here are invisible to the agent. Update this index when adding wiki pages.
