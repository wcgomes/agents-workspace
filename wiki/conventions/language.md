# Language Convention

> Default language for files and content is English. User may communicate in any language.

## Default Language

**English** is the default language for all workspace files and content, including:

- Wiki pages (`wiki/**/*.md`)
- `AGENTS.md`
- `README.md`
- Skill files (`skills/**/SKILL.md`)
- Commit messages
- Code comments (when applicable)
- Variable names, function names, and identifiers

## User Communication

The **user** may communicate in any language. The agent adapts to the user's language in conversation.

When the user communicates in a non-English language, the agent:

- Responds in the user's language
- Still writes/modifies files in English (unless the user explicitly requests otherwise)
- Translates user intent accurately into English for file content

## Why English

- **Consistency**: all workspace files follow one convention
- **Collaboration**: English is the lingua franca of software development
- **Tooling**: most CI/CD, linters, and documentation tools assume English
- **Discoverability**: English content is more searchable and accessible globally

## Exception

If the user explicitly requests content in another language (e.g., localized documentation), follow the request. The convention is a default, not a hard restriction.
