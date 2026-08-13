# ADR 0004: Serialize post-review wiki ingestion

## Status

Accepted (2026-08-04); amended (2026-08-13) to permit relevant, in-scope executor consultation while preserving the original write and ingestion decisions.

## Context

Treating wiki inspection or updates as open-ended incidental executor scope duplicates research, mixes delivery with knowledge maintenance, and risks conflicting writes from parallel work. Relevant read-only consultation is different: it can supply durable workspace context without moving responsibility for task-critical handoff context away from the coordinator. Skipping wiki work entirely unless an executor reports a learning also misses durable knowledge evident only after deliverables and verification results are reviewed together. The lifecycle must apply consistently across all deliverable domains without creating unnecessary specialist dispatches.

## Decision

Task executors use handoff context as their primary context, and the coordinator remains responsible for including task-critical context in the handoff. Executors may consult relevant wiki content when it helps execute the assigned scope, but consultation cannot expand that scope or override the handoff, applicable specs, or current artifacts. They edit `wiki/` only when wiki editing is explicitly in scope. They may optionally return one trailing `Durable discovery: ...` line for workspace-specific reusable knowledge not evident in their artifacts; this signal is only a pointer, and its absence has no workflow meaning.

After domain-appropriate review and verification of every task, and before the final response, the coordinator evaluates the reviewed artifacts, outcomes, corrections, and optional signals for uncaptured durable workspace knowledge. Evaluation is mandatory for every deliverable domain; ingestion is conditional.

- A negative evaluation opens no ingestion stream.
- A positive evaluation consolidates all discoveries into one serialized stream owned by a Wiki Ingestion Specialist role filled through normal `orchestrate` discovery. That owner classifies and deduplicates knowledge, makes deliberate add/update/remove choices, edits only wiki files, maintains navigation, and checks consistency.
- The coordinator reviews the ingest. A failed dispatch, non-complete status, or failed review is retried or corrected within the same stream under the normal bounded status protocol; parallel wiki writers are never introduced.
- Spec archive outcomes receive the same mandatory evaluation. Wiki additions, revisions, or removals occur only when they would materially improve durable workspace guidance after considering uncaptured or stale knowledge, deduplication, ambiguity and noise, compactness, and future context cost; a positive result uses the same serialized stream.
- An explicit wiki task still receives the mandatory evaluation, but no redundant post-task stream is dispatched when its reviewed deliverable already captured the durable knowledge, navigation, and consistency correctly.
- The conditional post-review specialist does not count toward the orchestration confirmation threshold of three planned specialists unless wiki work is an ordinary planned scope. This narrow exemption does not waive confirmation for ambiguity, destructive work, explicit user approval requirements, or three or more other planned specialists.

## Rationale

- Review is the first point where the coordinator can assess knowledge across all outputs rather than relying on fragmented executor judgment.
- One serialized owner prevents concurrent wiki races and gives deduplication, navigation, and correction a single responsibility boundary.
- Conditional dispatch preserves the mandatory learning loop without paying coordination cost when reviewed artifacts already contain no uncaptured durable knowledge.
- Domain-neutral evaluation keeps documentation, research, design, operations, software, and other work under the same lifecycle.

## Consequences

- Handoffs remain primary, the coordinator retains responsibility for task-critical context, and relevant consultation grants neither broader scope nor wiki edit authority.
- Orchestration completes as analyze → assemble → delegate → review → evaluate/conditionally ingest → synthesize.
- Post-task ingestion remains distinct from broad wiki setup or explicit wiki delivery work.
