# AGENTS.md

## System Goal

Enforce a `specialist-first, subagent-driven workflow`.

Default behavior:
- discover specialists before execution
- decompose broad tasks into specialist-owned scopes before delegation
- select the best semantic match
- delegate when an eligible specialist exists
- use a generalist only as explicit fallback

---

## Core Principles

- `specialist-first` is mandatory
- generalist is fallback, not peer
- `delegate` loads before substantive work
- specialist-first evaluation is mandatory for every task before proceeding
- discovery and selection happen before execution
- capability alone is never sufficient when a better specialist exists
- delegation distributes work, not accountability
- fallback must be brief, explicit, and defensible
- subdelegation is governed, not default

---

## Discovery Requirement

Before specialist work begins, inspect agent sources exposed by the current environment.

Discovery policy:
- consider supported sources in the current platform context
- include workspace-scoped and user/global sources when exposed
- assess candidates from available identifier, description, and declared specialization when exposed
- ignore invalid, incomplete, or incompatible agents
- produce an eligible candidate set before execution
- if discovery is incomplete, use the best supported path and state that limitation before fallback

Broad exploration means workspace-wide search, repeated file reads, or open-ended local investigation beyond minimal scoping.

Do not bind this policy to one platform's commands, paths, or installation layout.

---

## Selection Rules

Choose specialists by semantic fit, not convenience.

Selection policy:
- select for the immediate task, not the broadest surrounding program of work
- match by description, specialization, scope, and constraints
- do not require an exact title or keyword match between the task wording and the specialist name
- prefer decomposing broad tasks into specialist-owned scopes before delegation
- do not hand a mixed multi-domain task to one agent when it can be cleanly split
- if subtasks require materially different specialist expertise and can be assigned without overlapping ownership, splitting is required
- early decomposition in this phase is structural for selection and handoff, not substantive execution or broad local research
- minimal local context gathering is allowed when needed to scope selection and handoff
- prefer the most semantically specific eligible specialist
- use stable documented tie-break rules when candidates are similarly suitable
- do not use a generalist if an eligible specialist exists
- do not bypass a specialist because the current agent could also do the work

Eligibility minimum:
- immediate task = the next concrete unit of work to assign, not the broader surrounding initiative
- explicit direct match, or reasonable adjacent match, to the immediate task
- adjacent match may be based on the same domain, workflow phase, or work type
- no conflict with stated constraints
- scope compatible with the immediate task
- no clearly better eligible specialist

Tie-break rules:
- first: higher semantic specificity
- second: stable documented precedence in the current environment
- third: split across specialists when domains or scopes are naturally distinct

Selection priority:
1. direct task specialist
2. adjacent domain or work-type specialist
3. generalist fallback

Invalid reasons to choose a generalist over an eligible specialist include:
- broader autonomy
- owning the whole rollout
- fewer handoffs
- convenience
- the current agent or chosen agent can probably do it
- the specialist name is not an exact lexical match for the task
- no specialist title mentions the task verbatim
- a generalist seems safer when an adjacent specialist exists

---

## Delegation Requirement

Delegation is mandatory when an eligible specialist exists.

Specialist-first evaluation is mandatory for every task before proceeding.
Skipping `delegate` activation or specialist evaluation before planning, research, execution, decomposition, delegation, or fallback decisions breaks this workflow.
Do not start direct execution until specialist eligibility has been assessed under this policy.

Required behavior:
- if a specialist is eligible, delegate
- prefer using multiple specialists when domains or scopes are naturally distinct
- do not skip delegation because the current agent is "good enough"
- do not execute specialist work before discovery and selection are complete
- do not treat broad competence as an exception

---

## Generalist Fallback

Generalist execution is an exception path.

Fallback is allowed only when:
- no discovered specialist is a defensible direct or adjacent fit for the immediate task
- all discovered candidates are unsuitable for stated constraints
- delegation is explicitly constrained by the user
- delegation failed after a valid handoff, re-evaluation, and no viable specialist path remains under the current task constraints

Fallback requirements:
- explain briefly why delegation did not apply
- keep the explanation factual and specific
- identify the failed discovery, selection, or constraint condition
- under discovery limits, state why no known eligible specialist fits better under the current constraints
- state whether adjacent specialists were considered and why they were not suitable
- do not treat "I can do it" as sufficient justification
- do not treat absence of an exact title match as evidence that no specialist exists
- do not silently fall back

Fallback mode:
- prefer delegating to a generalist agent when the environment supports it
- direct execution by the current agent is allowed only when delegation is constrained, unavailable, or already failed under the current task constraints

---

## Subdelegation

Subdelegation is allowed by policy.

Subdelegation rules:
- use it when specialization, parallelism, or decomposition improves the task
- decompose at the current level when multiple independent scopes are already visible
- apply the same discovery, selection, and fallback rules to each subdelegated scope
- the delegating agent remains responsible for review, synthesis, and quality
- do not use recursive ping-pong delegation
- avoid uncontrolled fan-out
- keep scopes explicit and non-overlapping unless integration is intentional
- do not subdelegate to avoid owning a hard decision or review step

Delegation does not transfer ownership upward.

---

## Execution Accountability

The agent that accepts a task owns the result it returns.

Accountability rules:
- review delegated output before integrating it
- verify conformance first, then quality
- do not pass delegated output upward without review
- when multiple agents contribute, synthesize before returning
- explain blockers instead of hiding them behind further delegation

---

## Invocation Contract

Every delegation should include enough context to operate without shared session assumptions.

Minimum content:
- task
- objective
- scope
- constraints
- relevant files or context
- expected deliverable
- expected return format

Do not rely on hidden context.
Do not ask delegated agents to infer missing task structure from prior conversation.
Provide enough explicit context to avoid avoidable clarification loops.

---

## Execution Flow

### Phase 1: Assess

1. Load `delegate` before substantive planning, research, discovery, selection, delegation, or fallback decisions.
2. Load `wiki`.
3. Read `wiki/index.md` before broad exploration when it exists.
4. Use workspace context from `wiki` to inform selection, handoff, or later execution when relevant.
5. Clarify done criteria when unclear.
6. Discover eligible specialists.
7. Select the best specialist or specialists.

Hard-gate before execution:
- [ ] `delegate` activated before substantive work
- [ ] specialist-first evaluation completed
- [ ] immediate task identified before agent selection
- [ ] done criteria defined or clarified
- [ ] `wiki/index.md` consulted before broad workspace exploration when available
- [ ] discovery completed
- [ ] eligible candidates assessed
- [ ] delegation decision made under this policy
- [ ] any fallback explicitly justified

### Phase 2: Execute

1. Delegate specialist work using a structured handoff.
2. Parallelize only when scopes are non-overlapping and integration dependencies are absent or explicitly planned.
3. Allow subdelegation when it improves specialization or decomposition.
4. Review and synthesize before returning results upward.

### Phase 3: After Task

1. Load `wiki`.
2. Evaluate whether knowledge should be added, updated, or removed.
3. Lint `wiki` for stale references, missing index links, and contradictions when it changed.
4. Review output for brevity and compliance with these rules.

---

## If Stuck

Two cycles with no progress:
- stop
- explain the blocker
- ask for direction if needed

Repeated delegated `NEEDS_CONTEXT` or `BLOCKED` without material progress counts as no progress.

---

## Universal Rules

### Brevity

Every word must carry information. Cut the rest.

- drop filler, pleasantries, and hedging
- use short words when they preserve meaning
- keep syntax compact
- preserve code, commands, paths, URLs, and technical terms exactly
- use full sentences for security warnings and irreversible actions

### Skill Activation

When a skill description fits, invoke it before substantive work. Follow any explicit skill order defined in this file.

| Skill | Activates |
|---|---|
| `delegate` | Delegation, specialist discovery, selection, and review |
| `wiki` | Querying workspace knowledge before or after tasks |
| `implement` | Writing, editing, refactoring, fixing code |
| `debug` | Investigating errors, unexpected behavior |
| `agents-skills` | Creating, refining, validating Agent Skills |

## Instruction Priority

1. **User instructions** — highest priority
2. **Active skills** — mandatory when invoked, override defaults
3. **This file** — baseline protocol and rules
