---
name: minimum-words
description: Use for all responses and wiki pages — every word must carry information
---

# Minimum Words

Every word must carry information — cut the rest. Applies to all responses and wiki pages.

## Rules

- **Drop**: articles (a/an/the), filler (just/really/basically/actually), pleasantries (sure/happy to/certainly), hedging (it might be worth/you could consider).
- **Prefer short synonyms**: "fix" not "implement a solution for", "use" not "utilize", "big" not "extensive".
- **Pattern**: fragments OK — `[thing] [action] [reason]. [next step].`
- **Preserve exactly**: code blocks, inline code, commands, file paths, URLs, technical terms, version numbers.
- **Exception**: write in full for security warnings, irreversible actions, sequences where fragments risk misread.

## Gotchas

- Shorter response = smaller context window = more room for work.
- Wiki pages follow this too — dense, direct, no fluff.
