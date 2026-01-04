---
description: Start a Ralph loop for iterative task completion
---

# Ralph Loop

Parse the arguments and create the ralph loop state file.

**Arguments format:** `"<prompt>" [--max-iterations N] [--completion-promise "TEXT"]`

## Instructions

1. Parse `$ARGUMENTS` to extract:
   - **prompt**: The task description (everything not a flag)
   - **--max-iterations N**: Max iterations before stopping (default: 50)
   - **--completion-promise "TEXT"**: Completion phrase (default: "DONE")

2. Create the state file at `.opencode/ralph-loop.local.md`:

```markdown
---
active: true
iteration: 1
max_iterations: <parsed or 50>
completion_promise: "<parsed or DONE>"
started_at: "<current ISO timestamp>"
---
<the prompt>
```

3. After creating the file, output this message:

```
Ralph loop activated!

Iteration: 1
Max iterations: <N>
Completion promise: <PROMISE>

══════════════════════════════════════════════════════════════════
CRITICAL - Ralph Loop Completion Promise
══════════════════════════════════════════════════════════════════

To complete this loop, output this EXACT text:
  <promise><PROMISE></promise>

STRICT REQUIREMENTS:
  - Use <promise> XML tags EXACTLY as shown
  - The statement MUST be completely TRUE before outputting
  - Do NOT output false statements to exit the loop
  - Do NOT lie even if you think you should exit

The loop will continue until you output the promise or max iterations.
══════════════════════════════════════════════════════════════════
```

4. Then immediately begin working on the task.

## Example

If user runs: `/ralph-loop Build a REST API with tests --max-iterations 30 --completion-promise "COMPLETE"`

Create `.opencode/ralph-loop.local.md` with:
- prompt: "Build a REST API with tests"
- max_iterations: 30
- completion_promise: "COMPLETE"

Then start working on building the REST API.
