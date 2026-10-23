# Specification

## Directory structure

A skill requires `SKILL.md`; other resources are optional:

```
skill-name/
├── SKILL.md          # Required: metadata + instructions
├── scripts/          # Optional: executable code
├── references/       # Optional: documentation
├── assets/           # Optional: templates, resources
└── ...               # Any additional files or directories
```

## `SKILL.md` format

The `SKILL.md` file must contain YAML frontmatter followed by Markdown content.

### Frontmatter

| Field | Required | Constraints |
|---|---|---|
| `name` | Yes | 1–64 lowercase alphanumeric/hyphen characters; no leading/trailing/consecutive hyphens; matches parent directory. |
| `description` | Yes | 1–1024 characters: what it does, when to use it, relevant keywords. |
| `license` | No | Short license name or bundled license-file reference. |
| `compatibility` | No | 1–500 characters if present; only for specific product/package/network/environment requirements. Usually unnecessary. |
| `metadata` | No | String-to-string map for extra client properties; use unique keys to avoid conflicts. |
| `allowed-tools` | No | Space-separated pre-approved tools; experimental, implementation support varies. |

**Minimal example:**

```markdown
---
name: skill-name
description: A description of what this skill does and when to use it.
---
```

**Example with optional fields:**

```markdown
---
name: pdf-processing
description: Extract PDF text, fill forms, merge files. Use when handling PDFs.
license: Apache-2.0
metadata:
  author: example-org
  version: "1.0"
---
```

#### `name` field

Use Unicode lowercase alphanumerics (`a-z`) and hyphens under the constraints above.

Valid: `pdf-processing`, `data-analysis`, `code-review`. Invalid: `PDF-Processing` (uppercase), `-pdf` (leading hyphen), `pdf--processing` (consecutive hyphens).

#### `description` field

**Good example:**

```yaml
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents or when the user mentions PDFs, forms, or document extraction.
```

**Poor example:**

```yaml
description: Helps with PDFs.
```

#### `license` field

```yaml
license: Proprietary. LICENSE.txt has complete terms
```

#### `compatibility` field

```yaml
compatibility: Designed for Claude Code (or similar products)
```

```yaml
compatibility: Requires git, docker, jq, and access to the internet
```

```yaml
compatibility: Requires Python 3.14+ and uv
```

#### `metadata` field

```yaml
metadata:
  author: example-org
  version: "1.0"
```

#### `allowed-tools` field

```yaml
allowed-tools: Bash(git:*) Bash(jq:*) Read
```

### Body content

Unrestricted Markdown instructions after frontmatter. Recommended: steps, input/output examples, common edge cases. Activation loads the entire file; split long reference content out.

## Optional directories

### `scripts/`

Executable code: self-contained or documented dependencies, helpful errors, graceful edge handling. Languages depend on implementation; Python/Bash/JavaScript are common.

### `references/`

Focused on-demand docs: `REFERENCE.md` (technical), `FORMS.md` (templates/formats), domains (`finance.md`, `legal.md`). Smaller focused files cost less context.

### `assets/`

Static document/config templates, images/diagrams, data/lookups/schemas.

## Progressive disclosure

1. **Metadata** (~100 tokens): The `name` and `description` fields are loaded at startup for all skills
2. **Instructions** (< 5000 tokens recommended): The full `SKILL.md` body is loaded when the skill is activated
3. **Resources** (as needed): Files (e.g. those in `scripts/`, `references/`, or `assets/`) are loaded only when required

Keep your main `SKILL.md` under 500 lines. Move detailed reference material to separate files.

## File references

When referencing other files in your skill, use relative paths from the skill root:

```markdown
See [the reference guide](references/REFERENCE.md) for details.

Run the extraction script:
scripts/extract.py
```

Keep file references one level deep from `SKILL.md`. Avoid deeply nested reference chains.

## Validation

Validate frontmatter/naming with the `skills-ref` library:

```bash
skills-ref validate ./my-skill
```
