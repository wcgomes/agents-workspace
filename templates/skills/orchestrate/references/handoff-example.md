# Filled handoff example

Read when writing a first handoff or unsure where content belongs. Values are illustrative.

```
Session type: DELEGATED
Task: Add pagination to the GET /orders endpoint using cursor tokens.
Scope: In: src/api/orders.ts, src/api/orders.test.ts. Out: other endpoints, database schema, client code.
Done criteria: (1) Requests accept `cursor` and `limit` (default 50, max 200). (2) Responses include `nextCursor`, or null on the last page. (3) Existing tests pass; new tests cover first, middle, last, and invalid-cursor pages. (4) Lint and type check pass.
Constraints: Edit only in-scope files; match existing style; no drive-by changes. Run lint, type check, and tests; report each with its result. Read-only wiki consultation allowed; edit wiki/ only if in scope. Do not re-delegate. Return inline: status, summary ≤10 bullets, checks and results, files touched. Write no report files.
Act as: backend API engineer focused on pagination correctness.
Context: Orders sort by (created_at, id). Cursor should encode both. Related issue: duplicate rows when timestamps tie.
Contract ref: docs/api/orders.openapi.yaml
```

Note: `Act as:` appears because this example assumes an adjacent match. Omit it for an exact match.
