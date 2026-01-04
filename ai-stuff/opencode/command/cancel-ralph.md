---
description: Cancel the active Ralph loop
---

# Cancel Ralph

Check for and cancel the active Ralph loop.

## Instructions

1. Check if `.opencode/ralph-loop.local.md` exists

2. If it does NOT exist:
   - Say: "No active Ralph loop found."

3. If it EXISTS:
   - Read the current iteration from the file
   - Delete the file `.opencode/ralph-loop.local.md`
   - Say: "Cancelled Ralph loop (was at iteration N)"

That's it. Do not perform any other actions.
