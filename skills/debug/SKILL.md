---
name: debug
description: Use this skill when debugging, investigating errors, fixing bugs, or fixing unexpected behavior.
---

# Debug

**Runs inside a subagent.** The main agent never debugs or investigates errors
itself (see `AGENTS.md` → "The One Rule"); it delegates that work. This skill is
for the specialist subagent doing the investigation. Load it before debugging.

Investigate systematically. Verify each hypothesis before moving to the next. Fix → verify → repeat until resolved.

---

## Investigation Cycle

```
Observe → Hypothesize → Verify → Fix → Confirm
    ↑__________________________________|
```

### Phase 1: Observe

1. Collect error messages, logs, and output
2. Identify the exact failure point (file, line, command)
3. Determine what's working vs what's broken
4. Isolate the smallest reproducible case

### Phase 2: Hypothesize

1. Generate possible causes (at least 3)
2. Rank by likelihood
3. Plan verification for each

### Phase 3: Verify

Test the most likely hypothesis first. Verification must be:
- **Falsifiable** — can prove wrong
- **Specific** — points to exact cause
- **Quick** — don't spend 30min testing unlikely cause

### Phase 4: Fix

Apply fix for confirmed cause. Verify fix doesn't break other things.

### Phase 5: Confirm

Run tests, verify behavior, confirm resolution. If not resolved → restart cycle.

---

## <HARD-GATE> Before Declaring Fixed

1. **Reproduce the issue** — confirm it existed
2. **Apply fix** — change only what's needed
3. **Verify fix** — confirm issue gone
4. **Test for regressions** — nothing else broke

Do NOT skip regression testing. A fix that breaks other things isn't fixed.

---

## Investigation Techniques

### Narrow the Scope

1. Binary search through changed files
2. Isolate failing component from rest
3. Remove variables one at a time

### Check the Basics First

- Syntax errors
- Missing imports
- Typos in names
- Wrong file paths
- Environment variables

Basics account for 50%+ of bugs. Check before assuming complexity.

### Defense in Depth

When initial investigation doesn't find cause:

1. Check edge cases
2. Test boundary conditions
3. Verify all dependencies are correct versions
4. Test with minimal repro case
5. Add logging to trace execution path

### Condition-Based Waiting

When waiting for async operations:
- Check explicit conditions (file exists, output received)
- Use appropriate timeouts
- Don't assume "it'll work eventually"

---

## If Stuck

1. Document what you've tried and what happened
2. Take a step back — assume less about the cause
3. Try a different angle (input format, environment, user)
4. Ask: what changed recently?

Two failed hypotheses → broaden search. Three → escalate with summary.

---

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "Probably just timing" | Prove it with logs. |
| "Works on my machine" | Environment difference is a real cause. |
| "This shouldn't matter" | Test it before assuming. |
| "I'll fix it later" | Fix now or document why not. |

---

## Gotchas

- Error messages point to where problem manifests, not necessarily where cause is.
- "Works on my machine" is a valid hypothesis, not an excuse.
- Adding logging changes timing — can mask race conditions.
- Multiple fixes at once = don't know which one worked.
- A fix that adds more code than necessary is not minimal.
