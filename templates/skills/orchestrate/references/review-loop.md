# Review loop: finding resolution and convergence

## Resolving each finding

Severity uses SKILL.md's scale: `blocker`, `major`, `minor`, `nit`.

Every finding gets exactly one resolution:

- **fix:** dispatch the fix to the owning executor, with the finding as context.
- **contest:** cite evidence the reviewer could check, such as a file, test output, or contract clause. Send a contest to the same reviewer when the harness supports reuse. Otherwise include the contest and its evidence in the next fresh round.
- **escalate to the user:** only when outside knowledge, not available to the reviewer, would refute the finding.
- **accept:** non-blocking `minor` findings only. Record the reason; acceptance never waives done criteria, requirements, or required verification.
- **decline:** `nit` findings only. Record the reason in one line.

Rules:

- Never downgrade severity without a contest.
- A contest needs a checkable citation; wanting to contest is not evidence.
- The coordinator decides the resolution. Executors do the fixing.

## Convergence

- Keep a **settled list** across rounds. A finding is settled once fixed and confirmed, contest accepted, user-decided, accepted as a non-blocking `minor` with reason, or declined as a `nit`. Do not relitigate unchanged resolutions; reopen when later changes or new evidence invalidate them, and rerun affected checks.
- A **clean round** has no unsettled `blocker` or `major` finding, and no reviewer return counted as not run.
- One clean round converges the scope.
- Non-blocking `minor` findings do not prevent a clean round. Fix them or explicitly accept them with a reason under the rule above.
- Fixes to `minor` or `nit` findings after convergence need no new round, unless they touch a `blocker` or `major` finding's scope.
- Cap: three review rounds per scope. At the cap, stop and report unsettled findings as `DONE_WITH_CONCERNS` or `BLOCKED`.
- **Churn:** if reverting an earlier fix would resolve a new finding, stop and ask the user which outcome they want.

Re-review uses fresh context each round: deliverable, original scope, applicable constraints, approved exceptions, done criteria, contract ref, settled list, and readable paths. Never executor reasoning or transcript.
