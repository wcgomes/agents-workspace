# Skill System

> Skills are behavioral rules loaded on demand. They are not plugins — they are instructions.

## What is a Skill

A skill is a directory with a `SKILL.md` file (required) and optional resources:

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: docs loaded on demand
├── assets/           # Optional: templates, static resources
└── evals/            # Optional: test cases
```

## Discovery and Activation

Skills are loaded in three progressive stages:

| Stage | Tokens | When | What loads |
|---|---|---|---|
| **Discovery** | ~100 | Startup | `name` + `description` of all skills |
| **Activation** | < 5000 | Task matches trigger | Full `SKILL.md` |
| **Resources** | On demand | Referenced in SKILL.md | `scripts/`, `references/`, `assets/` |

## Available Skills

| Skill | Trigger | Function | Source |
|---|---|---|---|
| `orchestrate` | Planning or executing non-trivial delegated work | Analyze, define roles, match specialists, dispatch, strategic review, synthesize | `templates/skills/` |
| `wiki-query` | Explicit read-only wiki requests; project consultation subject to the Wiki gate | Lightweight knowledge lookup without loading the full `wiki` skill | `templates/skills/` |
| `wiki` | Explicit wiki setup and maintenance; post-review ingestion after a positive Learn (pre-check) | Full workspace knowledge maintenance and self-learning workflow | `templates/skills/` |
| `skill-builder` | Creating or improving skills | Authoring following agentskills.io spec | `templates/skills/` |
| `spec-builder` | Work needs a durable outcome contract before execution | Specs, proposals, task plans for spec-driven development | `templates/skills/` |

> **Note:** Platform built-in skills are not documented in this workspace — each platform may have its own integrated skills. The focus is on skills in `templates/skills/` (source code).

The [Wiki gate](../../templates/AGENTS.md#coordinator-flow) limits automatic wiki steps to tasks associated with an identified project containing root-level `wiki/`; explicit wiki requests bypass it.

## Skill Independence

Skills never reference other skills by name; only the boot policy composes them. Integration goes through generic handoff fields (`Contract ref:`) and checks the governing artifact declares itself (for specs, the `tasks.md` Readiness line). Rule text stays harness-, model-, and agent-name-agnostic; agent names appear only in illustrative team tables. See [ADR 0005](../decisions/0005-skill-independence-and-lean-coordination.md).

## Wiki versus Skill

Wiki captures durable declarative knowledge: what is true or decided about the workspace. Skills carry recurring procedural workflows. Only when content is clearly procedural and clearly recurring does the agent flag it for you to choose: turn it into a reusable skill, or keep it in the wiki. You decide; the agent never automatically creates a skill. Check existing skills first to adapt rather than duplicate.

Keeping content in the wiki still requires material net durable value after context, maintenance, and duplication costs. See the [wiki skill](../../templates/skills/wiki/SKILL.md) for the evaluation and maintenance procedure.

## Loading by Platform

Installed skills include `SKILL.md` and resource subdirectories, so relative resource links remain usable. See [installation flow](installation-flow.md#what-is-installed) for copy semantics and platform destinations. Run the installer manually; the agent never runs it automatically.

## Description Drives Activation

The description in the frontmatter is what determines if a skill activates. Rules:

- **Imperative phrase**: "Use this skill when..." not "This skill helps..."
- **User intent**: what the user wants to do, not internal mechanics
- **Err on the side of more**: list contexts explicitly, including implicit ones
- **Name the boundary**: what the skill **does not** do, when relevant

## References

- [agentskills.io specification](../../templates/skills/skill-builder/references/SPECIFICATION.md)
- [Writing Skills guide](../../templates/skills/skill-builder/references/WRITING_SKILLS.md)
- [Best Practices](../../templates/skills/skill-builder/references/BEST_PRACTICES.md)
