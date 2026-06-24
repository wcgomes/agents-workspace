# Spec-Builder Templates

Canonical section structures for each artifact. Copy verbatim; fill in. Use RFC 2119 keywords (`MUST`/`SHOULD`/`MAY`).

## 1. proposal.md

```markdown
# Proposal: <title>

## Intent
<Why this change — the problem or opportunity. One to three sentences.>

## Scope
<What outcome is in scope. Reference affected domains/requirements.>

## Non-goals
<Explicitly out of scope — prevents scope creep.>

## Approach
<Brief approach. Full detail goes in design.md (Full mode).>

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
<Outcome statement. RFC 2119 keywords as needed.>

#### Scenario: <name>
<!-- Software: Given/When/Then. Non-software: one-line acceptance condition (e.g., "X delivered and stakeholder Y approves"). -->
- Given <initial state>
- When <action>
- Then <observable outcome>

## MODIFIED Requirements

### Requirement: <name>
<Updated outcome statement.>

#### Scenario: <name>
<!-- Software: Given/When/Then. Non-software: one-line acceptance condition (e.g., "X delivered and stakeholder Y approves"). -->
- Given <initial state>
- When <action>
- Then <observable outcome>

## REMOVED Requirements

### Requirement: <name>
**Rationale:** <why removed>
```

## 3. tasks.md

The executable "how" — consumed by `orchestrate` via handoffs. Dependency-ordered; `[P]` marks parallelizable items; one file path per task; checkpoint validation per phase. **Software:** order tasks test-first (write test, confirm failing, then implement); checkpoint = spec scenario maps to a passing test.

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

Keep lean — only what `tasks.md` cannot carry. Omit sections that add no value. **Software:** cover data model and API contracts under Approach or Significant decisions.

```markdown
# Design: <change-id>

## Approach
<Chosen approach and rationale. Alternatives considered.>

## Significant decisions
<Decisions affecting structure, with trade-offs.>

## Flow
<Inputs → transformations → outputs. Diagram if useful.>

## Artifact changes
<Anticipated files/modules and the nature of each change.>
```
