# Illustrative wiki layout

```
wiki/
├── index.md              # Required routing map — compact keywords + descriptions
├── architecture.md       # System structure overview (single file)
├── conventions/          # One file per convention
│   ├── index.md          # Required for every new content folder
│   └── <pattern-name>.md
├── domain/               # One file per business rule — descriptive facts, not spec contracts
│   ├── index.md
│   └── <rule-name>.md
├── decisions/            # One file per ADR
│   ├── index.md
│   └── <NNNN-decision-name>.md
├── records/             # Date-bound artifacts
│   ├── index.md
│   └── incidents/
│       ├── index.md
│       └── YYYYMMDD-<incident-name>.md
└── ...
```
