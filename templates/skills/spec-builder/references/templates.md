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
<Brief approach summary. Expanded non-normative detail goes in design.md only when the overflow rule requires it.>

## Decision index
- **<Decision>:** <conclusion + concise rationale; link to design.md section when expanded detail is needed>

## Clarifications
<!-- Include only material Q&A resolved during clarify; omit when there was no ambiguity. -->
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
<!-- Choose one form. Software: keep the Given/When/Then lines below. Non-software: replace them with one acceptance-condition line, e.g., "X delivered and stakeholder Y approves." -->
- Given <initial state>
- When <action>
- Then <observable outcome>

## MODIFIED Requirements

### Requirement: <name>
<Updated outcome statement.>

#### Scenario: <name>
<!-- Choose one form. Software: keep the Given/When/Then lines below. Non-software: replace them with one acceptance-condition line, e.g., "X delivered and stakeholder Y approves." -->
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

## 4. design.md (conditional)

Create only when a material design decision cannot remain understandable and actionable as a concise proposal decision plus task instructions without overloading either artifact or duplicating substantial context. Evidence may include meaningful alternatives and trade-offs, an interacting multi-step flow, or substantial migration, rollback, security, or cross-component reasoning; work category alone is insufficient. Keep it non-normative and omit it when concise entries suffice. Guarantees always belong in `spec.md`. Omit sections that add no value.

```markdown
# Design: <change-id>

## Approach
<Chosen approach and rationale. Alternatives considered.>

## Significant decisions
<Expanded rationale, alternatives, and trade-offs. Link each decision from proposal.md.>

## Flow
<Inputs → transformations → outputs. Diagram if useful.>

## Architectural boundaries
<Components, boundaries, and responsibilities when they need explanation. Keep actionable file/path inventory in tasks.md.>

## Migration and rollback
<Only when substantial sequencing, compatibility, or recovery reasoning needs expansion.>

## Security considerations
<Only when threat boundaries or mitigations need expanded reasoning. Normative guarantees remain in spec.md.>
```
