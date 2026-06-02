---
name: team-assembly
description: Use when you receive a request to coordinate and must decide who does the work — at the start of any task the main agent takes on, or when a specialist hits work outside its domain and must compose a sub-team. Not for executing a focused scope you were already handed; in that case, just do the work.
---

# Team Assembly

This is a planning step. Before any work begins, think about what a professional
team would look like to handle this request: what roles are needed, what phases
the work goes through, and who is responsible for each phase. A code change
likely needs a developer for execution and a reviewer for verification — both are
part of the plan.

Compose the team: analyze the request, define roles and phases, discover matching
specialists, and plan the execution order.

## Who Runs This

This skill is for whoever is **coordinating** a request — deciding who does the
work, not doing it.

- **Main agent** (your input has no `[HANDOFF FROM COORDINATOR]` marker): always
  runs this for every incoming request, before delegating. The main agent never
  executes the work itself — see `AGENTS.md` → "The One Rule". Being knowledgeable
  about the task is not being the specialist; compose and delegate.
- **Specialist subagent** (your input begins with `[HANDOFF FROM COORDINATOR]`):
  default is to **execute** the handed scope, not recompose a team. Run this skill
  only if the scope turns out to be genuinely multi-domain and exceeds your
  specialty — then you compose a sub-team for the parts outside your domain (see
  `delegate` → Subdelegation). A focused, single-domain task you can do yourself is
  never a reason to assemble.

Direct execution is unlocked by the `[HANDOFF FROM COORDINATOR]` marker in your
input, not by self-declaring as the specialist. No marker → you are the main
agent: compose and delegate.

Team size is a sizing decision (see `AGENTS.md` → "How to Delegate Well"):

- **Focused, single-domain task** → one specialist. Correct sizing, not a shortcut.
- **Multi-domain or cross-functional work** → a full team, one specialist per
  domain and phase.

When the main agent composes, the output is always a team to delegate to — never
a decision to execute the work itself. When a specialist composes a sub-team, the
output covers only the parts outside its own domain.

Run this after `wiki/index.md` is read, before loading `delegate`.

---

## Workflow

### Step 1: Analyze Request

Think about this like assembling a professional team for the job:

- What domains are involved (engineering, design, testing, marketing, etc.)?
- What specific platforms, tools, or channels are mentioned (e.g., Twitter, WeChat, PostgreSQL, React)?
- What phases does the work go through? (e.g., planning → implementation → code review → testing). Each phase that requires distinct expertise needs a responsible role.
- Classify complexity: single-domain, multi-domain, or cross-functional.

### Step 2: Define Ideal Roles

- Map each domain + phase to a specialist role
- Apply templates below for common patterns
- For multi-domain work, ensure each domain has representation

### Step 3: Discover and Select Specialists

Before selecting, discover what specialists exist in the current environment.
Inspect all observable sources — the dispatch tool, workspace and global
config directories, agent descriptions, and any identifiers exposed by the
platform. Do not assume the pool is empty; do not skip to whatever agent the
harness offers by default.

Then:

- Produce an explicit list of the specialists you found (name + domain). This list
  is required output (see Return Format).
- Match each ideal role to a found specialist. Semantic match: domain + work-type,
  NOT tech stack. Do not over-narrow by requiring a specific technology in the
  specialist's name — a "Frontend Developer" covers React, Vue, or any stack.
- Adjacent match acceptable when exact unavailable. Adjacent means: same broader
  domain or workflow phase (e.g., no test specialist → use an implementation
  specialist for test work; no review specialist → use a debugging specialist).
- The generic agent is a last resort, not a default. Selecting it requires that
  discovery found no specialist or adjacent fit — state that.
- If user specified agents, incorporate them and apply semantic matching for the
  remaining roles.

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

The specialist names below are examples. Match by the equivalent role/domain, not the literal name — never delegate to a name that isn't actually available (see Step 3).

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

## Return Format

After assembly, produce:

- **Discovered specialists**: the specialists found during discovery (name + domain). If none found, state what sources were checked.
- **Team roster**: (role, specialist, scope) per member
- **Execution plan**: parallel groups + sequential order + dependencies
- **Handoff summary**: what each specialist receives
