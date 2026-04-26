# Optimizing skill descriptions

> How to improve your skill's description so it triggers reliably on relevant prompts.

A skill only helps if it gets activated. The `description` field in your `SKILL.md` frontmatter is the primary mechanism agents use to decide whether to load a skill for a given task.

## How skill triggering works

Agents use progressive disclosure to manage context. At startup, they load only the `name` and `description` of each available skill — just enough to decide when a skill might be relevant. When a user's task matches a description, the agent reads the full `SKILL.md` into context and follows its instructions.

This means the description carries the entire burden of triggering. If the description doesn't convey when the skill is useful, the agent won't know to reach for it.

One important nuance: agents typically only consult skills for tasks that require knowledge or capabilities beyond what they can handle alone. A simple, one-step request may not trigger a skill even if the description matches perfectly, because the agent can handle it with basic tools.

## Writing effective descriptions

* **Use imperative phrasing.** Frame the description as an instruction to the agent: "Use this skill when..." rather than "This skill does..."
* **Focus on user intent, not implementation.** Describe what the user is trying to achieve, not the skill's internal mechanics.
* **Err on the side of being pushy.** Explicitly list contexts where the skill applies, including cases where the user doesn't name the domain directly: "even if they don't explicitly mention 'CSV' or 'analysis.'"
* **Keep it concise.** A few sentences to a short paragraph is usually right. The specification enforces a hard limit of 1024 characters.

## Designing trigger eval queries

To test triggering, you need a set of eval queries — realistic user prompts labeled with whether they should or shouldn't trigger your skill.

```json
[
  { "query": "I've got a spreadsheet in ~/data/q4_results.xlsx with revenue in col C and expenses in col D — can you add a profit margin column and highlight anything under 10%?", "should_trigger": true },
  { "query": "whats the quickest way to convert this json file to yaml", "should_trigger": false }
]
```

Aim for about 20 queries: 8-10 that should trigger and 8-10 that shouldn't.

### Should-trigger queries

Vary them along several axes:

* **Phrasing**: some formal, some casual, some with typos or abbreviations.
* **Explicitness**: some name the skill's domain directly, others describe the need without naming it.
* **Detail**: mix terse prompts with context-heavy ones.
* **Complexity**: vary the number of steps and decision points.

The most useful should-trigger queries are ones where the skill would help but the connection isn't obvious from the query alone.

### Should-not-trigger queries

The most valuable negative test cases are **near-misses** — queries that share keywords or concepts with your skill but actually need something different.

For a CSV analysis skill, weak negative examples would be:

* `"Write a fibonacci function"` — obviously irrelevant.
* `"What's the weather today?"` — no keyword overlap.

Strong negative examples:

* `"I need to update the formulas in my Excel budget spreadsheet"` — shares "spreadsheet" and "data" concepts, but needs Excel editing, not CSV analysis.
* `"can you write a python script that reads a csv and uploads each row to our postgres database"` — involves CSV, but the task is database ETL, not analysis.

### Tips for realism

Real user prompts contain context that generic test queries lack. Include:

* File paths (`~/Downloads/report_final_v2.xlsx`)
* Personal context (`"my manager asked me to..."`)
* Specific details (column names, company names, data values)
* Casual language, abbreviations, and occasional typos

## Testing whether a description triggers

The basic approach: run each query through your agent with the skill installed and observe whether the agent invokes it.

Most agent clients provide some form of observability — execution logs, tool call histories, or verbose output — that lets you see which skills were consulted during a run.

A query "passes" if:

* `should_trigger` is `true` and the skill was invoked, or
* `should_trigger` is `false` and the skill was not invoked.

### Running multiple times

Model behavior is nondeterministic — the same query might trigger the skill on one run but not the next. Run each query multiple times (3 is a reasonable starting point) and compute a **trigger rate**: the fraction of runs where the skill was invoked.

A should-trigger query passes if its trigger rate is above a threshold (0.5 is a reasonable default). A should-not-trigger query passes if its trigger rate is below that threshold.

## Avoiding overfitting with train/validation splits

If you optimize the description against all your queries, you risk overfitting — crafting a description that works for these specific phrasings but fails on new ones.

The solution is to split your query set:

* **Train set (~60%)**: the queries you use to identify failures and guide improvements.
* **Validation set (~40%)**: queries you set aside and only use to check whether improvements generalize.

Make sure both sets contain a proportional mix of should-trigger and should-not-trigger queries. Shuffle randomly and keep the split fixed across iterations.

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

Five iterations is usually enough. If performance isn't improving, the issue may be with the queries (too easy, too hard, or poorly labeled) rather than the description.

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
