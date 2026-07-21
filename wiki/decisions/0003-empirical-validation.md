# ADR 0003: Keep empirical validation in orchestrate

## Status

Accepted (2026-07-20)

## Context

Static inspection can show that an artifact appears correct without proving its observable behavior. The workspace needs a proportional validation rule without expanding the lean `AGENTS.md` boot policy or duplicating orchestration mechanics.

## Decision

For outcomes with observable behavior, `orchestrate` requires delegated evidence from real execution or observation when validation is safe and proportional; static inspection alone is insufficient. Validation uses existing roles and statuses. Detailed guidance remains in the `orchestrate` workflow, while `AGENTS.md` remains a lean boot policy.

## Consequences

- Reviews distinguish structural correctness from demonstrated behavior.
- Unsafe or disproportionate validation is not required, but the limitation must remain visible through the existing workflow.
- Validation policy evolves in `orchestrate` without duplicating operational detail in `AGENTS.md`.
