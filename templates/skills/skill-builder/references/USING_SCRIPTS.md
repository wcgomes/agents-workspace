# Using scripts in skills

Use one-off commands or reusable self-contained `scripts/` executables with agent-friendly interfaces.

## One-off commands

Reference existing packages directly in `SKILL.md`; no `scripts/` directory needed.

### uvx

[uvx](https://docs.astral.sh/uv/guides/tools/) runs Python packages in isolated environments with aggressive caching. It ships with [uv](https://docs.astral.sh/uv/).

```bash
uvx ruff@0.8.0 check .
uvx black@24.10.0 .
```

* Separate install, not bundled with Python; cached repeats are near-instant.

### pipx

[pipx](https://pipx.pypa.io/) runs Python packages in isolated environments.

```bash
pipx run 'black==24.10.0' .
pipx run 'ruff==0.8.0' check .
```

* Separately installed, mature `uvx` alternative; not bundled with Python.

### npx

[npx](https://docs.npmjs.com/cli/commands/npx) runs npm packages, downloading them on demand. It ships with npm (which ships with Node.js).

```bash
npx eslint@9 --fix .
npx create-vite@6 my-app
```

* No extra install beyond Node.js; pin `npx package@version` for reproducibility.

### bunx

[bunx](https://bun.sh/docs/cli/bunx) is Bun's equivalent of `npx`. It ships with [Bun](https://bun.sh/).

```bash
bunx eslint@9 --fix .
bunx create-vite@6 my-app
```

* Drop-in replacement for `npx` in Bun-based environments.

### deno run

[deno run](https://docs.deno.com/runtime/reference/cli/run/) runs scripts directly from URLs or specifiers. It ships with [Deno](https://deno.com/).

```bash
deno run npm:create-vite@6 my-app
deno run --allow-read npm:eslint@9 -- --fix .
```

* Permission flags (`--allow-read`, etc.) are required for filesystem/network access.
* Use `--` to separate Deno flags from the tool's own flags.

### go run

[go run](https://pkg.go.dev/cmd/go#hdr-Compile_and_run_Go_program) compiles and runs Go packages directly. It is built into the `go` command.

```bash
go run golang.org/x/tools/cmd/goimports@v0.28.0 .
go run github.com/golangci/golangci-lint/cmd/golangci-lint@v1.62.0 run
```

* Built into Go — no extra tooling needed.
* Pin versions or use `@latest` to make the command explicit.

**Tips for one-off commands in skills:**

* Pin versions (e.g., `npx eslint@9.0.0`) for stable behavior.
* State prerequisites in `SKILL.md`; use `compatibility` for runtime requirements, never assume availability.
* A few flags fit one-off commands; move complex/error-prone logic into tested `scripts/`.

## Referencing scripts from `SKILL.md`

Use automatically resolved **skill-root-relative paths** for bundled files. List scripts in `SKILL.md`:

```markdown
## Available scripts

- **`scripts/validate.sh`** — Validates configuration files
- **`scripts/process.py`** — Processes input data
```

Then instruct the agent to run them:

````markdown
## Workflow

1. Run the validation script:
   ```bash
   bash scripts/validate.sh "$INPUT_FILE"
   ```

2. Process the results:
   ```bash
    python3 scripts/process.py --input results.json
    ```
````

The same relative-path convention works in support files like `references/*.md` — script execution paths are relative to the **skill directory root**.

## Self-contained scripts

Bundle reusable `scripts/` logic with inline dependencies: one command, no separate manifest/install step.

### Python (PEP 723)

[PEP 723](https://peps.python.org/pep-0723/) defines a standard format for inline script metadata. Declare dependencies in a TOML block inside `# ///` markers:

```python
# /// script
# dependencies = [
#   "beautifulsoup4",
# ]
# ///

from bs4 import BeautifulSoup

html = '<html><body><h1>Welcome</h1><p class="info">This is a test.</p></body></html>'
print(BeautifulSoup(html, "html.parser").select_one("p.info").get_text())
```

Run with [uv](https://docs.astral.sh/uv/) (recommended):

```bash
uv run scripts/extract.py
```

`uv run` creates an isolated environment, installs the declared dependencies, and runs the script. [pipx](https://pipx.pypa.io/) also supports PEP 723.

* Pin versions with PEP 508 specifiers: `"beautifulsoup4>=4.12,<5"`.
* Use `requires-python` to constrain the Python version.
* Use `uv lock --script` to create a lockfile for full reproducibility.

### Deno

Deno's `npm:` and `jsr:` import specifiers make every script self-contained by default:

```typescript
#!/usr/bin/env -S deno run

import * as cheerio from "npm:cheerio@1.0.0";

const html = `<html><body><h1>Welcome</h1><p class="info">This is a test.</p></body></html>`;
const $ = cheerio.load(html);
console.log($("p.info").text());
```

```bash
deno run scripts/extract.ts
```

* Use `npm:` for npm packages, `jsr:` for Deno-native packages.
* Version specifiers follow semver: `@1.0.0` (exact), `@^1.0.0` (compatible).
* Dependencies are cached globally. Use `--reload` to force re-fetch.

### Bun

Bun auto-installs missing packages at runtime when no `node_modules` directory is found. Pin versions directly in the import path:

```typescript
#!/usr/bin/env bun

import * as cheerio from "cheerio@1.0.0";

const html = `<html><body><h1>Welcome</h1><p class="info">This is a test.</p></body></html>`;
const $ = cheerio.load(html);
console.log($("p.info").text());
```

```bash
bun run scripts/extract.ts
```

* No `package.json` or `node_modules` needed. TypeScript works natively.
* Packages are cached globally. First run downloads; subsequent runs are near-instant.
* If a `node_modules` directory exists anywhere up the directory tree, auto-install is disabled.

### Ruby

Bundler ships with Ruby since 2.6. Use `bundler/inline` to declare gems directly in the script:

```ruby
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'nokogiri'
end

html = '<html><body><h1>Welcome</h1><p class="info">This is a test.</p></body></html>'
doc = Nokogiri::HTML(html)
puts doc.at_css('p.info').text
```

```bash
ruby scripts/extract.rb
```

* Pin versions explicitly (`gem 'nokogiri', '~> 1.16'`) — there is no lockfile.
* An existing `Gemfile` or `BUNDLE_GEMFILE` env var can interfere.

## Designing scripts for agentic use

Agents choose next actions from stdout/stderr.

### Avoid interactive prompts

Hard requirement: non-interactive shells cannot answer TTY/password/confirmation prompts; scripts hang. Accept flags, environment variables, or stdin instead:

```
# Bad: hangs waiting for input
$ python scripts/deploy.py
Target environment: _

# Good: clear error with guidance
$ python scripts/deploy.py
Error: --env is required. Options: development, staging, production.
Usage: python scripts/deploy.py --env staging --tag v1.2.3
```

### Document usage with `--help`

`--help` teaches the interface: include description, flags, examples:

```
Usage: scripts/process.py [OPTIONS] INPUT_FILE

Process input data and produce a summary report.

Options:
  --format FORMAT    Output format: json, csv, table (default: json)
  --output FILE      Write output to FILE instead of stdout
  --verbose          Print progress to stderr

Examples:
  scripts/process.py data.csv
  scripts/process.py --format csv --output report.csv data.csv
```

Keep help short; it consumes context.

### Write helpful error messages

Errors guide retries: state failure, expected input, and remedy, not "invalid input":

```
Error: --format must be one of: json, csv, table.
       Received: "xml"
```

### Use structured output

Prefer JSON/CSV/TSV for agents and pipeline tools (`jq`, `cut`, `awk`). Structured data to stdout; progress/warnings/diagnostics to stderr, preserving parseability.

### Further considerations

* **Idempotency:** retries favor "create if absent", not duplicate failures.
* **Input:** reject ambiguity with clear errors; prefer enums/closed sets, never guess.
* **Dry-run:** preview destructive/stateful operations via `--dry-run`.
* **Exit codes:** distinct failure codes, documented in `--help`.
* **Safety:** destructive operations require explicit `--confirm`/`--force` or other safeguards.
* **Output size:** harnesses may truncate at 10–30K characters. Default large output to summary/limit with pagination (`--offset`), or require `--output` file/explicit `-` for stdout.
