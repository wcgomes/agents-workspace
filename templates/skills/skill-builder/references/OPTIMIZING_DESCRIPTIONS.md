# Optimizing skill descriptions

`SKILL.md` frontmatter `description` primarily controls activation.

## How skill triggering works

Startup loads only each skill's name/description; a match loads all `SKILL.md`. Descriptions must convey when useful. Agents may skip matching simple one-step requests solvable with basic tools, consulting primarily for additional knowledge/capabilities.

## Writing effective descriptions

* Imperative "Use this skill when...", not "This skill does...".
* User intent, not internal mechanics.
* Explicit/pushy contexts, including unnamed domains: "even without mentioning CSV or analysis".
* A few sentences/short paragraph; hard maximum 1024 characters.

## Designing trigger eval queries

Label realistic queries with expected activation:

```json
[
  { "query": "I've got a spreadsheet in ~/data/q4_results.xlsx with revenue in col C and expenses in col D — can you add a profit margin column and highlight anything under 10%?", "should_trigger": true },
  { "query": "whats the quickest way to convert this json file to yaml", "should_trigger": false }
]
```

Aim for about 20 queries: 8-10 that should trigger and 8-10 that shouldn't.

### Should-trigger queries

Vary formality/typos/abbreviations, explicit vs implicit domain, terse vs detailed context, steps/decisions. Prioritize useful but non-obvious skill connections.

### Should-not-trigger queries

Prefer **near-misses** sharing keywords/concepts but needing other work.

For a CSV analysis skill, weak negative examples would be:

* `"Write a fibonacci function"` — obviously irrelevant.
* `"What's the weather today?"` — no keyword overlap.

Strong negative examples:

* `"I need to update the formulas in my Excel budget spreadsheet"` — shares "spreadsheet" and "data" concepts, but needs Excel editing, not CSV analysis.
* `"can you write a python script that reads a csv and uploads each row to our postgres database"` — involves CSV, but the task is database ETL, not analysis.

### Tips for realism

Include paths (`~/Downloads/report_final_v2.xlsx`), personal context ("my manager asked..."), columns/companies/values, casual language, abbreviations, and typos.

## Testing whether a description triggers

Run queries with the skill installed; observe invocation in logs/tool histories/verbose output. A run passes iff invocation equals `should_trigger`.

### Running multiple times

Repeat nondeterministic queries (start with 3 runs). **Trigger rate** = fraction invoking skill. Positive queries pass above threshold (default 0.5); negatives below it.

## Avoiding overfitting with train/validation splits

Avoid phrasing overfit: randomly split ~60% train (failure-guided changes), ~40% validation (generalization only). Preserve positive/negative proportions and keep the split fixed across iterations.

## The optimization loop

1. **Evaluate** the current description on both *train and validation sets*.
2. **Identify failures** in the *train set*: which should-trigger queries didn't trigger? Which should-not-trigger queries did?
   * Only use train set failures to guide your changes.
3. **Revise the description.** Focus on generalizing:
   * If should-trigger queries are failing, broaden the scope or add context about when the skill is useful.
   * If should-not-trigger queries are false-triggering, add specificity about what the skill does *not* do.
   * Avoid adding specific keywords from failed queries — that's overfitting.
   * If you're stuck after several iterations, try a structurally different approach.
   * Check that the description stays under the 1024-character limit.
4. **Repeat** steps 1-3 until all *train set* queries pass or you stop seeing meaningful improvement.
5. **Select the best iteration** by its validation pass rate — the fraction of queries in the *validation set* that passed. Note that the best description may not be the last one you produced.

Usually five iterations suffice; stalled improvement may mean easy/hard/mislabeled queries, not a bad description.

## Applying the result

Once you've selected the best description:

1. Update the `description` field in your `SKILL.md` frontmatter.
2. Verify the description is under the 1024-character limit.
3. Verify the description triggers as expected. Try a few prompts manually as a sanity check. For a more rigorous test, write 5-10 fresh queries and run them through the eval script.

Before and after:

```yaml
# Before
description: Process CSV files.

# After
description: >
  Analyze CSV and tabular data files — compute summary statistics,
  add derived columns, generate charts, and clean messy data. Use this
  skill when the user has a CSV, TSV, or Excel file and wants to
  explore, transform, or visualize the data, even if they don't
  explicitly mention "CSV" or "analysis."
```
