# Review loop: finding resolution and convergence

## Resolving each finding

Severity uses SKILL.md's scale: `blocker`, `major`, `minor`, `nit`.

Every finding gets exactly one resolution:

- **fix:** dispatch the fix to the owning executor, with the finding as context.
- **contest:** cite evidence the reviewer could check, such as a file, test output, or contract clause. Send a contest to the same reviewer when the harness supports reuse. Otherwise include the contest and its evidence in the next fresh round.
- **escalate to the user:** only when outside knowledge, not available to the reviewer, would refute the finding.
- **decline:** `nit` findings only. Record the reason in one line.

Rules:

- Never downgrade severity without a contest.
- Wanting to contest is not evidence. No checkable citation means fix or escalate.
- The coordinator decides the resolution. Executors do the fixing.

## Convergence

- Keep a **settled list** across rounds. A finding is settled once fixed and confirmed, contest accepted, user-decided, or declined as a `nit`. Settled items never reopen.
- A **clean round** has no unsettled `blocker` or `major` finding, and no reviewer return counted as not run.
- One clean round converges the scope.
- `minor` findings never block a clean round. Fix them or record them as accepted.
- Fixes to `minor` or `nit` findings after convergence need no new round, unless they touch a `blocker` or `major` finding's scope.
- Cap: three review rounds per scope. At the cap, stop and report unsettled findings as `DONE_WITH_CONCERNS` or `BLOCKED`.
- **Churn:** if reverting an earlier fix would resolve a new finding, stop and ask the user which outcome they want.

Re-review uses a fresh reviewer context each round: deliverable, done criteria, contract ref, settled list, and readable paths.
