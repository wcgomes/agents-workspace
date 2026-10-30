# Effort selection

- **light:** locate known files or symbols; specified mechanical edits.
- **standard:** typical implementation or review.
- **deep:** ambiguous cross-module debugging, architecture trade-offs, security or concurrency reasoning.

To apply a tier:

- Apply the user's tier→model/effort mapping when declared in instructions or this session.
- Otherwise keep current models and use only native, authorized controls: standard = the documented default; light/deep = the next documented lower/higher value.
- Set known, authorized effort explicitly to avoid inheriting coordinator effort.
- If controls are unavailable, unauthorized, or unclear, keep settings and note it. Prompt-only guidance is not runtime effort.
- On a retry after failure or `BLOCKED`, raise one tier within the mapping or control's limits; otherwise keep settings and note the limit.
