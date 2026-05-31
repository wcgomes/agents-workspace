# AGENTS.md

## System Goal

Enforce specialist-first, team-driven workflow.

- assemble specialist teams before execution
- decompose into specialist-owned scopes
- delegate to best semantic match
- generalist is fallback only

---

## Core Principles

- specialist-first evaluation mandatory before any work
- assemble specialist teams for multi-domain work, single specialist for focused tasks
- main context stays clean — research, execution, logs belong to subagents
- delegation distributes work, not accountability
- wiki read before tasks, updated after tasks
- skill `team-assembly` determines strategy; `delegate` handles tactics

---

## Execution Flow

### Phase 1: Assess

1. Load `team-assembly`
2. Load `wiki`, read `wiki/index.md`
3. Clarify done criteria
4. Assemble specialist team + execution plan

### Phase 2: Execute

1. Load `delegate` for each handoff
2. Parallelize independent scopes
3. Review and synthesize results

### Phase 3: After Task

1. Load `wiki`
2. Ingest learnings

---

## HARD-GATE

**STOP. Do not proceed until ALL confirmed:**

1. `team-assembly` loaded and team composed
2. `wiki/index.md` consulted
3. Done criteria defined
4. Execution plan with specialist assignments ready
5. `delegate` loaded and handoff structure understood
6. Delegation decision made with justification

If ANY false → go back to Phase 1.

---

## Skill Activation

| Skill | Activates |
|---|---|
| team-assembly | Team composition, domain analysis, execution strategy |
| delegate | Handoff, review, status, subdelegation |
| wiki | Workspace knowledge query/ingest |
| implement | Code writing/editing |
| debug | Error investigation |
| agents-skills | Skill authoring |

---

## Brevity

Every word carries information. Drop filler.

---

## Instruction Priority

1. **User instructions** — highest priority
2. **Active skills** — mandatory when invoked, override defaults
3. **This file** — baseline protocol and rules
