---
name: delegate
description: Mandatory specialist-first workflow. Load first, before substantive planning, research, execution, decomposition, delegation, or fallback decisions, to discover specialists, select the best fit, delegate, and review results.
---

# Delegate

Use this skill to operationalize the specialist-first delegation policy: discover specialists, select the best fit, delegate with a structured handoff, and review delegated results.

This skill is mandatory before substantive work. If specialist eligibility has not been assessed, stop and run this workflow first.

---

## Your Tools

- Subagent invocation tool — dispatch focused work to a subagent
- Read/View tool — verify output

Everything else belongs to the delegated agent unless task constraints require otherwise.

---

## When This Skill Activates

Activate this skill by default first, before substantive planning, research, execution, decomposition, delegation, or fallback decisions.

After activation, load the `wiki` skill and read `wiki/index.md` when available before broad workspace exploration.

Before proceeding, confirm:
- specialist eligibility has been assessed
- direct execution has not started
- fallback has not been considered without discovery

If any item is false, stop and run this workflow first.

Use it:
- before deciding whether to work directly or delegate
- before planning, research, implementation, debugging, review, or other non-trivial work
- when specialist fit, task decomposition, or generalist fallback must be assessed
- when broad work may need splitting into specialist-owned scopes

Use this skill to determine whether specialist delegation is required before direct execution or fallback.
Do not skip activation because the current agent appears capable, because the task seems small, or because fallback looks convenient.

---

## Discovery Workflow

Before dispatching, inspect all agent sources exposed by the current environment.

Discovery rules:
- consider all supported sources in the current platform context
- include workspace-scoped sources when available
- include user or global sources when available
- tolerate platform differences in source discovery
- ignore invalid, incomplete, or incompatible candidates
- continue safely if some sources are unavailable
- if complete discovery is not observable, use the best supported path and state that limitation before fallback

Broad exploration means workspace-wide search, repeated file reads, or open-ended local investigation beyond minimal scoping.

Examples:
- minimal scoping: read the request, inspect already-cited paths, or read a small number of directly relevant files needed to choose a specialist or prepare a handoff
- broad exploration: workspace-wide search, reading multiple uncited files, or tracing implementation in depth before specialist selection

Collect at least:
- agent identifier
- description
- declared specialization or capability summary
- relevant scope or constraints when available

Do not hard-code one platform's paths, commands, or installation assumptions into the normative policy.

---

## Selection Workflow

Select by best semantic match.

Semantic specificity means domain and work-type granularity, not technology-stack granularity. A domain specialist (e.g., a generic backend or frontend expert) is the correct match for any task within that domain, regardless of the specific languages or frameworks mentioned. Match by the domain and role the task belongs to, not by the technology names that appear in the task description.

Anti-pattern: looking for an overly specific stack-level expert (e.g., "Language X Specialist") instead of matching a broader domain or role specialist. This over-narrowing by technology stack causes false fallbacks.

Selection rules:
- select for the immediate task, not the broadest surrounding program of work
- match by domain, role, work type, and scope — never narrow the match by requiring a specific technology stack mentioned in the task
- a specialist's declared domain (backend, frontend, devops, data, security, etc.) qualifies them for any task within that domain, regardless of specific languages or frameworks the task names
- do not require an exact title or keyword match between the task wording and the specialist name
- do not disqualify a specialist because their name or description lacks a specific technology keyword present in the task
- treat a specialist as eligible when it is a direct match or a reasonable adjacent match within the same domain, workflow phase, or work type
- prefer decomposing broad tasks into specialist-owned scopes before dispatch when doing so improves specialist fit, scope clarity, or parallelism
- do not hand a mixed multi-domain task to one agent when it can be cleanly split
- if subtasks require materially different specialist expertise and can be assigned without overlapping ownership, splitting is required
- early decomposition in this phase is structural for selection and handoff, not substantive execution or broad local research
- minimal local context gathering is allowed when needed to scope selection and handoff, but not to replace delegated work
- before considering generalist fallback, check whether any adjacent specialist can make meaningful progress on the immediate task
- prefer the most semantically specific eligible specialist
- specialists may own large scopes when their specialization matches the immediate task, including broad but coherent single-domain work
- prefer specialists over generalists whenever an eligible specialist exists
- use stable documented tie-break rules when candidates are similarly suitable
- reject "current agent can also do it" as a selection argument

Technology-stack vs domain matching — when a task names specific technologies:
- extract the domain from the task
- match specialists by domain and role, not by the individual technologies listed
- a technology keyword in the task is context for the handoff, not a filter for specialist discovery
- only narrow by technology when an agent is explicitly designed and named as a dedicated specialist for that specific technology.

Eligibility minimum:
- immediate task = the next concrete unit of work to assign, not the broader surrounding initiative
- explicit direct match, or reasonable adjacent match, to the immediate task
- adjacent match may be based on the same domain, workflow phase, or work type
- adjacent match may be based on domain compatibility even when technology keywords differ from the specialist's explicit description
- no conflict with stated constraints
- scope compatible with the immediate task
- no clearly better eligible specialist

Tie-break rules:
- first: semantic specificity (domain and work-type granularity, not technology-stack granularity)
- second: stable documented precedence in the current environment
- third: split into multiple delegations when domains or scopes are complementary

Selection priority:
1. direct task specialist
2. adjacent domain or work-type specialist
3. generalist fallback

Fallback to generalist because no specialist mentions a specific technology keyword is always invalid. A domain specialist exists for nearly every domain; the absence of a technology keyword in their description does not make them ineligible.

When many candidates exist, select the best fit, not the most convenient fit.

Invalid reasons to choose a generalist over an eligible specialist include:
- broader autonomy
- owning the whole rollout
- fewer handoffs
- convenience
- the current agent or chosen agent can probably do it
- the specialist name is not an exact lexical match for the task
- no specialist title mentions the task verbatim
- a generalist seems safer when an adjacent specialist exists
- no specialist title or description mentions a specific language, framework, or technology present in the task
- a domain specialist does not explicitly list the task's technology stack in their description

---

## Delegation Workflow

Delegation is the default path for specialist work. If an eligible specialist exists, delegation is required.

Every handoff should include:
- task
- objective
- scope
- constraints
- relevant files or context
- expected deliverable
- expected return format

Handoff rules:
- provide explicit context
- keep context isolated
- do not rely on hidden session state
- do not say "see plan above"
- provide enough information to avoid avoidable `NEEDS_CONTEXT`
- do not mix review responsibility with ambiguous execution ownership

### Canonical Handoff Shape

```text
Task: <what to do>
Objective: <why this work is needed>
Scope: <what is in and out>
Constraints: <rules, limits, expectations>
Relevant files or context: <paths, snippets, facts>
Expected deliverable: <artifact or decision>
Expected return format: <status + concise summary>
```

**Policy inheritance:** Subagents must operate under the same `AGENTS.md` policies. Include in constraints: "You must follow the specialist-first workflow. Load `delegate` before any substantive work. Do not bypass delegation."

**Return format rule:** Return concise results only — no raw logs, no full tool output. Summarize findings. The delegating agent's context must stay clean.

---

## Parallel Delegation

Use parallel delegation only when scopes are non-overlapping and integration dependencies are absent or explicitly planned.

Good candidates:
- different files or subsystems
- separate evidence gathering
- independent validation or analysis
- complementary specialists with distinct responsibilities

---

## Generalist Fallback

Generalist fallback is allowed only under the conditions below.

Fallback rules:
- no eligible specialist exists only when no discovered specialist is a defensible direct or adjacent fit, or all candidates are unsuitable
- or delegation is explicitly constrained by the user
- or delegation failed after a valid handoff, re-evaluation, and no viable specialist path remains under the current task constraints
- explain briefly why fallback applies
- keep justification factual
- identify the failed discovery, selection, or constraint condition
- under discovery limits, state why no known eligible specialist fits better under the current constraints
- before choosing a generalist, state whether adjacent specialists were considered and why they were unsuitable
- never use "good enough" as justification
- never use the absence of an exact title match as fallback justification
- never fall back because no specialist mentions a specific language, framework, or technology keyword present in the task. A domain specialist exists for nearly every domain; the absence of a technology keyword in their description does not make them ineligible.
- never fall back silently

Examples:
- adjacent-specialist preference:
  if no dedicated test specialist exists, prefer an implementation or domain specialist over a generalist when the task is to add or improve tests
  if no dedicated review specialist exists, prefer an implementation or debugging specialist depending on whether the task is critique or fault investigation
  if no dedicated debugging specialist exists, prefer an implementation specialist for code-level fault isolation before using a generalist
- valid fallback:
  no eligible specialist found in observable sources
  delegation was explicitly constrained by the user
  valid handoff failed, re-evaluation was completed, and no viable specialist path remained
- invalid fallback:
  generalist seems faster
  one agent can own the whole rollout
  delegation would add handoffs
  a specialist was not obvious immediately

Fallback mode:
- prefer delegating to a generalist agent when the environment supports it
- direct execution by the current agent is allowed only when delegation is constrained, unavailable, or already failed under the current task constraints

---

## Subdelegation Rules

Subdelegation is allowed by policy.

Use it when:
- a narrower specialist is a better fit for a subtask
- decomposition improves quality or speed
- independent subtasks benefit from further specialist separation

Subdelegation rules:
- decompose at the current level when multiple independent scopes are already visible
- apply the same discovery, selection, and fallback rules to each subdelegated scope
- the delegating agent remains accountable
- review subdelegated output before integrating it
- avoid loops and ping-pong
- avoid uncontrolled fan-out
- preserve explicit scope ownership
- do not subdelegate to avoid synthesis or review responsibility

Do not subdelegate by habit. Subdelegate because specialist fit improves.

---

## Review And Synthesis

After each delegated result returns:

### Stage 1: Conformance

Did it deliver what was requested? Nothing more, nothing less?

Did the subagent follow the specialist-first workflow? (i.e., did it load `delegate` and relevant skills, or provide evidence of delegation rather than direct execution?)

### Stage 2: Quality

Is it correct, maintainable, and usable for the current task?

If multiple delegated outputs return:
- compare them against the assigned scopes
- resolve conflicts
- synthesize a single coherent result before returning upward

Do not pass through raw delegated output without review.

---

## Status Protocol

Delegated agents report one of:

| Status | Meaning | Action |
|---|---|---|
| `DONE` | Completed, ready for review | Proceed to review |
| `DONE_WITH_CONCERNS` | Completed but flagged issues | Read concerns first |
| `NEEDS_CONTEXT` | Missing information | Re-dispatch with more context |
| `BLOCKED` | Cannot complete | Assess context, break task, or escalate |

This protocol applies across the delegation tree, including subdelegated work.
If `NEEDS_CONTEXT` or `BLOCKED` repeats without material progress, stop redispatching, declare the blocker, and choose among: provide missing context, decompose differently, escalate, or apply justified fallback.

---

## Gotchas

- skipping discovery causes premature fallback
- picking a generalist too early weakens the workflow
- handoffs without explicit structure increase `NEEDS_CONTEXT`
- delegation never removes accountability from the delegating agent
- overlapping scopes across multiple agents create integration risk
- platform-specific discovery details belong in platform adapters, not core policy
