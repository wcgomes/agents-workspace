# ADR 0005: Skill independence and lean coordination

## Status

Accepted (2026-10-30). Amends [ADR 0001](0001-adopt-spec-driven-development.md) (handoff field, readiness recognition) and [ADR 0004](0004-serialized-post-review-wiki-ingestion.md) (ingest gating, confirmation exemption).

## Context

Skills named each other (`orchestrate` consumed `Spec ref:`, `spec-builder` told coordinators to load `orchestrate`, `wiki` routed setup through `orchestrate` roles), so procedures broke or drifted when one skill changed. Every task, however trivial, paid for full orchestration, review, and ingest evaluation, and confirmation used a specialist headcount trigger.

## Decision

- **Skill independence:** skills never reference other skills by name; only the [boot policy](../../templates/AGENTS.md) names skills. Cross-skill integration uses generic handoff fields, chiefly `Contract ref:` (replaces `Spec ref:`).
- **Artifact-declared checks:** a contract artifact or its governing skill declares its own readiness and verification checks; `orchestrate` recognizes them generically (Phase 4 Readiness, Phase 6 review). For specs, the `tasks.md` Readiness line declares `analyze` before implementation and `verify` in review.
- **Harness-agnostic templates:** no harness, model, or specific agent names in rules. Agent names appear only in illustrative team tables ([team-templates](../../templates/skills/orchestrate/references/team-templates.md)). Effort tiers map to models or effort values only through a user-declared mapping (instructions or session); otherwise native documented controls apply.
- **Session classification:** the main user-facing agent is coordinator even with a specialist persona; domain-specialist subagents are delegated; the `Session type: DELEGATED` control line always wins.
- **Trivial fast path:** defined once in the boot policy; skips `orchestrate`, separate review, and ingest evaluation.
- **Wiki use:** the coordinator reads the index plus only planning-relevant pages; executors self-consult. After non-trivial work, the boot policy's Learn (pre-check) with five triggers gates loading the `wiki` skill, which owns the full ingest criteria.
- **Review:** executors always self-verify; independent fresh-context review runs only at strategic points. The canonical [review-loop](../../templates/skills/orchestrate/references/review-loop.md) defines finding resolution and convergence. A missing or malformed return counts as `not run`.
- **Confirmation:** risk-based triggers only (destructive, ambiguous, irreversible/outward-facing, unusually costly, user asked); no headcount trigger.
- **Returns:** bounded inline returns; no report files in the user's workspace unless the file is the deliverable.
- **No-subagent harness:** reduced mode with separate labeled passes; independent review recorded as `not run`.

## Rationale

- Self-contained skills can be installed, renamed, or evolved independently; the boot policy is the single composition point.
- Harness-agnostic text stays valid across all installer targets and changing model lineups.
- Lean paths and strategic-only review cut coordination cost where risk is low, while bounded review loops keep quality without churn.

## Consequences

- When editing a skill template, check it names no other skill; a new integration needs a generic field or an artifact-declared check.
- Older wiki or ADR text mentioning `Spec ref:`, a three-specialist confirmation threshold, or unconditional post-review evaluation is historical.
