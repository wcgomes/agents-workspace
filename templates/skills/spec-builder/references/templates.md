# Spec-Builder Templates

Copy these canonical structures verbatim; fill in. Use RFC 2119 (`MUST`/`SHOULD`/`MAY`).

## 1. proposal.md

```markdown
# Proposal: <title>

## Intent
<Why this change — the problem or opportunity. One to three sentences.>

## Scope
<What outcome is in scope. Reference affected domains/requirements.>

## Non-goals
<Explicit exclusions.>

## Approach
<Approach summary; expanded non-normative detail in design.md only under the overflow rule.>

## Decision index
- **<Decision>:** <conclusion + concise rationale; link to design.md section when expanded detail is needed>

## Clarifications
<!-- Include only material Q&A resolved during clarify; omit when there was no ambiguity. -->
- **Q:** <question>
  **A:** <answer + decision>
```

## 2. spec.md (DELTA — for a change)

Include only applicable sections. Source specs use the same Requirement/Scenario format under `## Requirements`, without delta wrappers.

```markdown
# Change Spec: <change-id>

## ADDED Requirements

### Requirement: <name>
<Outcome statement. RFC 2119 keywords as needed.>

#### Scenario: <name>
<!-- Software: Given/When/Then below. Non-software: replace with one acceptance line, e.g., "X delivered and stakeholder Y approves." -->
- Given <initial state>
- When <action>
- Then <observable outcome>

## MODIFIED Requirements

### Requirement: <name>
<Updated outcome statement.>

#### Scenario: <name>
<!-- Software: Given/When/Then below. Non-software: replace with one acceptance line, e.g., "X delivered and stakeholder Y approves." -->
- Given <initial state>
- When <action>
- Then <observable outcome>

## REMOVED Requirements

### Requirement: <name>
**Rationale:** <why removed>
```

## 3. tasks.md

Executable "how" for implementation handoffs: dependency order, `[P]` for parallelizable tasks, one path per task, checkpoint per phase. **Software:** write test → confirm failure → implement; checkpoint maps spec scenario to passing test.

```markdown
# Tasks: <change-id>

Readiness: `analyze` must pass before implementation; review runs `verify` against the persisted spec.

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

Create only if a material decision cannot stay understandable/actionable as a short proposal decision + tasks without overload/substantial duplication. Evidence: needed alternatives/trade-offs, interacting multi-step flow, substantial migration/rollback/security/cross-component reasoning—not category alone. Non-normative; omit if short entries suffice. Guarantees stay in `spec.md`; omit valueless sections.

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
