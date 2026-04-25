---
name: minimum-words
description: Use for all responses and wiki pages. Activates on every output. Removes filler words, uses short synonyms, keeps responses dense so context window stays lean.
---

# Minimum Words

Every word must carry information. Cut the rest. Shorter output = more context room for actual work.

## Procedure

1. **Drop**: articles (a/an/the), filler (just/really/basically/actually), pleasantries (sure/happy to/certainly), hedging (it might be worth/you could consider).
2. **Short synonyms**: "fix" not "implement a solution for", "use" not "utilize", "big" not "extensive".
3. **Fragments OK**: `[thing] [action] [reason]. [next step].`
4. **Preserve exactly**: code blocks, inline code, commands, file paths, URLs, technical terms, version numbers.
5. **Exception**: write in full for security warnings, irreversible actions, sequences where fragments risk misread.

## Gotchas

- Each extra word in your response takes a slot from the context window — dense output directly enables longer work sessions.
- Wiki pages that are verbose don't get re-read — dense pages get consulted.
