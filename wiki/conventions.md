# Conventions

Workspace patterns, naming, and style.

## Non-Negotiable Rules

| Rule | Reason |
|---|---|
| Wiki first | Self-learning loop |
| Invoke subagent by default | Better quality, smaller context |
| Search before creating | Prevents sprawl |
| Only create when genuinely impossible | Forces reuse |
| Fix root causes, not symptoms | Code quality |
| Always cite `file:line` | Traceability |

## Task Patterns

### invoke-subagents
- Every task delegates to specialist subagent
- Focused prompt: goal, scope, constraints, expected output
- No session inheritance — isolated context
- Review after each subagent: spec → quality

### workflow
- Non-trivial tasks: define "done" first
- Multiple steps: shared plan before starting
- Parallel-work for independent tasks
- QA runs before approval
- Wiki ingest after task is required

### minimum-viable-change
- Least code that solves the problem
- No speculative features, unused abstractions
- Change only what's needed — no adjacent improvements
- Match existing style
- Unrelated issues: mention, don't fix
- Cite `file:line` in explanations

## Code Conventions

- **Second person**: "you install" not "user installs"
- **Present tense**: current time, not future
- **Active voice**: subject performs action
- **One concept per section**: don't combine installation + configuration + usage
- **Code examples must run**: every snippet tested before shipping

## Documentation Structure

Based on [Divio Documentation System](https://documentation.divio.com/):
- **Tutorial**: learning-oriented (how to learn)
- **How-to**: task-oriented (how to do)
- **Reference**: information-oriented (what it is)
- **Explanation**: understanding-oriented (why)

Each doc needs clear purpose.

## Wiki

- index.md updated when pages added/removed
- Pages not linked from index.md are invisible
- Ingest after task is mandatory

## File Naming

```
wiki/
├── index.md
├── architecture.md
├── conventions.md
├── domain.md
├── decisions.md         # ADRs
└── [topic]/
    └── overview.md
```

## Code Citation

Always use `file:line` when referencing code:
- In plans, diffs, explanations
- Lets reviewers verify reasoning
- Not optional

See also: [architecture.md](architecture.md)