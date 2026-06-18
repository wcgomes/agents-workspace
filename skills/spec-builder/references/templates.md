# Spec-Builder Templates

Canonical section structures for each artifact. Copy verbatim; fill in. Use RFC 2119 keywords (`MUST`/`SHOULD`/`MAY`).

## 1. proposal.md

```markdown
# Proposal: <title>

## Intent
<Why this change — the problem or opportunity. One to three sentences.>

## Scope
<What behavior is in scope. Reference affected domains/requirements.>

## Non-goals
<Explicitly out of scope — prevents scope creep.>

## Approach
<Brief technical direction. Full technical detail goes in design.md (Full mode).>

## Clarifications
<!-- Full mode only — Q&A resolved during clarify. Remove section in Lite. -->
- **Q:** <question>
  **A:** <answer + decision>
```

## 2. spec.md (DELTA — for a change)

Only include sections that apply to this change. Source spec uses the same Requirement/Scenario format but under `## Requirements` (no ADDED/MODIFIED/REMOVED wrappers).

```markdown
# Change Spec: <change-id>

## ADDED Requirements

### Requirement: <name>
<Observable behavior statement. RFC 2119 keywords as needed.>

#### Scenario: <name>
- Given <initial state>
- When <action>
- Then <observable outcome>

## MODIFIED Requirements

### Requirement: <name>
<Updated behavior statement.>

#### Scenario: <name>
- Given <initial state>
- When <action>
- Then <observable outcome>

## REMOVED Requirements

### Requirement: <name>
**Rationale:** <why removed>
```

## 3. tasks.md

The executable "how" — consumed by `orchestrate` via handoffs. Dependency-ordered; `[P]` marks parallelizable items; one file path per task; checkpoint validation per phase.

```markdown
# Tasks: <change-id>

## 1. <phase>
- [ ] 1.1 <task> [P] (path: file.ext)
- [ ] 1.2 <task> (path: file.ext)

## Checkpoint
- [ ] verify <scenario from spec.md>

## 2. <phase>
- [ ] 2.1 <task> (path: file.ext)

## Checkpoint
- [ ] verify <scenario from spec.md>
```

## 4. design.md (Full mode only)

Keep lean — only what `tasks.md` cannot carry. Omit sections that add no value.

```markdown
# Design: <change-id>

## Technical approach
<Chosen approach and rationale. Alternatives considered.>

## Architecture decisions
<Decisions affecting structure, with trade-offs.>

## Data flow
<Inputs → transformations → outputs. Diagram if useful.>

## File changes
<Anticipated files/modules and the nature of each change.>
```
