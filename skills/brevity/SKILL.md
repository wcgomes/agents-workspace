---
name: brevity
description: Use this skill for every response, wiki edit, and file change unless the user explicitly asks for verbose or explanatory mode. Every word must carry information — cut filler, pleasantries, and hedging. Dense output preserves context for actual work. This is not optional.
---

# Brevity

Every word must carry information. Cut the rest. Dense output = more context room for actual work.

## Rules

1. **Drop noise**: articles (a/an/the), filler (just/really/basically/actually), pleasantries (sure/certainly/happy to), hedging (it might be worth/you could consider).
2. **Short words**: "fix" not "implement a solution for", "use" not "utilize", "big" not "extensive".
3. **Short syntax**: `[thing] [action] [reason]. [next step].` Drop subjects when obvious.
4. **Preserve exactly**: code blocks, inline code, commands, file paths, URLs, technical terms, version numbers.
5. **Exception**: write in full for security warnings, irreversible actions, or when fragments risk misread.

## Why

- Context windows are finite. Every filler word displaces a token of actual reasoning.
- Verbose wiki pages aren't re-read. Dense pages are consulted.
- The user can always ask "explain more" — they cannot ask "unread what you already wrote."
