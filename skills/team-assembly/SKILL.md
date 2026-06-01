---
name: team-assembly
description: Compose the ideal specialist team for a request. Load before delegation to analyze domains, define roles, discover specialists, and plan execution order.
---

# Team Assembly

Compose the ideal specialist team for a request. Analyze domains, define roles, discover available specialists, and plan execution order.

---

## When to Activate

- Load this skill first, before wiki or any delegation decision
- Execute after wiki/index.md is read and context is gathered
- Before individual specialist selection
- Do not start planning, researching, or implementing before this skill runs

---

## Workflow

### Step 1: Analyze Request

- Identify all domains involved (engineering, design, testing, marketing, etc.)
- Identify specific platforms, tools, or channels mentioned (e.g., Twitter, WeChat, PostgreSQL, React)
- Identify workflow phases needed (planning → execution → verification)
- Classify complexity: single-domain, multi-domain, or cross-functional

### Step 2: Define Ideal Roles

- Map each domain + phase to a specialist role
- Apply templates below for common patterns
- For multi-domain work, ensure each domain has representation

### Step 3: Discover Available Specialists

- Inspect all agent sources (workspace, user, global)
- Read agent descriptions and declared specializations
- Match each ideal role to available specialists
- Semantic match: domain + work-type, NOT tech stack
- When a specific platform/channel is identified, prefer the platform-specific specialist over the generic domain specialist (e.g., Twitter Engager over generic Social Media Strategist for Twitter work)
- For multi-platform work, combine: generic domain specialist for strategy + specific specialists per platform
- Adjacent match acceptable when exact unavailable
- If user specified agents, incorporate them

### Step 4: Plan Execution Order

- Identify dependencies between scopes
- Select coordination pattern (see templates)
- Parallel groups: scopes with no integration deps
- Sequential: output of one feeds another
- Review always after parallel batches

---

## Coordination Patterns

### Pattern: Full Parallel Discovery

When: independent analyses of the same topic from different angles.
How: all specialists work simultaneously, synthesize at end.
Example: product discovery from 8 domain perspectives.

### Pattern: Parallel Kickoff → Merge → Review

When: parallel work feeds a downstream integrator.
How: parallel group → merge point → sequential review.
Example: content + design (parallel) → frontend dev (merge) → growth review.

### Pattern: Sequential with Quality Gates

When: each phase depends on prior output.
How: sequential handoffs with checkpoint reviews.
Example: research → architecture → implementation → testing.

### Pattern: Single Agent Structured

When: task fits cleanly in one domain.
How: one specialist, structured handoff.
Example: write a chapter, fix a specific bug.

---

## Team Templates

These are starting points, not prescriptions. Adapt roles, add or remove specialists, and change coordination patterns based on the actual request. A small UI fix needs one specialist; a full product launch may need 10+. Always analyze the request first (Step 1), then use templates as reference.

### Software Development

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | UX/Design | ux-researcher, ui-designer |
| Planning | Architecture | software-architect, backend-architect |
| Execution | Frontend | frontend-developer |
| Execution | Backend | backend-architect, senior-developer |
| Verification | Review | code-reviewer |
| Verification | Testing | reality-checker, api-tester |

Coordination: Parallel Kickoff → Merge → Review.

### Bug Fix / Incident

| Phase | Role | Specialist Match |
|---|---|---|
| Investigation | Debug | incident-response-commander |
| Fix | Implementation | domain-appropriate developer |
| Verification | Testing | reality-checker |

Coordination: Sequential with Quality Gates.

### Marketing Campaign

| Phase | Role | Specialist Match |
|---|---|---|
| Strategy | Planning | growth-hacker, product-manager |
| Execution | Content | content-creator, platform specialists |
| Verification | Analytics | analytics-reporter |

Coordination: Parallel Kickoff → Merge → Review.

### Product Discovery

| Phase | Role | Specialist Match |
|---|---|---|
| All parallel | Market | trend-researcher |
| All parallel | Technical | backend-architect, software-architect |
| All parallel | Brand | brand-guardian |
| All parallel | Growth | growth-hacker |
| All parallel | UX | ux-researcher |
| All parallel | Support | support-responder |
| Synthesis | Coordination | project-shepherd |

Coordination: Full Parallel Discovery.

### Content / Documentation

| Phase | Role | Specialist Match |
|---|---|---|
| Planning | Strategy | content-creator, product-manager |
| Execution | Writing | technical-writer, content-creator |
| Verification | Review | code-reviewer, reality-checker |

Coordination: Sequential with Quality Gates.

---

## Handling Missing Specialists

- Adjacent domain specialist > generalist
- Adjacent means: same broader domain or workflow phase (e.g., no dedicated test specialist → use implementation specialist for test work; no dedicated review specialist → use debugging specialist for review)
- Document which roles have no match
- State fallback justification before using generalist

### Invalid Reasons to Choose Generalist

| Excuse | Reality |
|---|---|
| "Generalist seems faster" | Specialist fit improves quality, not just speed |
| "One agent can own the whole rollout" | Mixed domains need different expertise |
| "Fewer handoffs" | Handoffs are by design, not overhead |
| "Convenience" | Convenience is never a valid selection criterion |
| "No specialist title matches exactly" | Semantic match by domain, not title keywords |
| "No specialist mentions the specific tech" | Domain specialist covers any tech in their domain |
| "Specialist name doesn't mention the task verbatim" | Match by domain + work-type, not name |

### Anti-Patterns

| Pattern | Problem |
|---|---|
| Over-narrowing by tech stack | Looking for "React Specialist" instead of "Frontend Developer" |
| Skipping discovery | Assuming no specialist exists without checking |
| Premature fallback | Choosing generalist before exhausting adjacent specialists |
| Title lexical match | Requiring exact word match between task and specialist name |

## User-Specified Agents

- If user names agents, incorporate into team
- Apply semantic matching for unspecified roles
- User preference overrides template defaults

## Return Format

After assembly, produce:

- **Team roster**: (role, specialist, scope) per member
- **Execution plan**: parallel groups + sequential order + dependencies
- **Handoff summary**: what each specialist receives
