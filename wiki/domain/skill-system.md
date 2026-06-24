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
| `orchestrate` | Planning or executing delegated work | Full cycle: analyze, assemble team, delegate, review, synthesize | `skills/` |
| `wiki` | Context before tasks, ingestion after | Workspace knowledge base, self-learning | `skills/` |
| `skill-builder` | Creating or improving skills | Authoring following agentskills.io spec | `skills/` |
| `spec-builder` | Work needs a durable outcome contract before execution | Specs, proposals, task plans for spec-driven development | `skills/` |

> **Note:** Platform built-in skills are not documented in this workspace — each platform may have its own integrated skills. The focus is on skills in `skills/` (source code).

## Skill Lifecycle

```
1. Detection    — agent detects recurring pattern
2. Tracking     — candidate registered in wiki/skill-candidates/
3. Proposal     — 3+ encounters → proposal to user
4. Promotion    — approved → created in .agents/skills/
5. Usage        — workspace-local skill
```

## Loading by Platform

`install.sh` copies only `SKILL.md` to the platform path (run manually — the agent never runs `install.sh` automatically):

| Platform | Path |
|---|---|
| OpenCode | `~/.config/opencode/skills/<name>/SKILL.md` |
| Claude Code | `~/.claude/skills/<name>/SKILL.md` |
| Copilot | `~/.copilot/skills/<name>/SKILL.md` |
| Antigravity | `~/.gemini/antigravity/skills/<name>/SKILL.md` |

Subdirectories (`references/`, `scripts/`, etc.) are **not** installed.

## Description Drives Activation

The description in the frontmatter is what determines if a skill activates. Rules:

- **Imperative phrase**: "Use this skill when..." not "This skill helps..."
- **User intent**: what the user wants to do, not internal mechanics
- **Err on the side of more**: list contexts explicitly, including implicit ones
- **Name the boundary**: what the skill **does not** do, when relevant

## References

- [agentskills.io specification](../../skills/skill-builder/references/SPECIFICATION.md)
- [Writing Skills guide](../../skills/skill-builder/references/WRITING_SKILLS.md)
- [Best Practices](../../skills/skill-builder/references/BEST_PRACTICES.md)
