---
description: Generate handoff, clear context, and auto-continue in fresh Claude session
---

Generate a structured handoff document optimized for token efficiency, save it to the project, and prepare for session restart.

## Step 1: Generate Structured Handoff

Use this format. Be concise - use file references instead of describing code:

```markdown
# Handoff: [Brief title]

## Goal
[One sentence: what we're building/fixing]

## Status
- [ ] or [x] for each major milestone

## Files to Focus On
- `path/to/file.ts:10-25` - [why this section matters]
- `path/to/other.ts:fn_name` - [what needs attention]

## Key Decisions
| Decision | Reasoning |
|----------|-----------|
| Chose X over Y | [why] |

## Failed Approaches (don't retry)
- Tried [X] → failed because [Y]

## Current Blocker (if any)
[What's stopping progress right now]

## Next Action
[Single, specific next step to take]
```

## Step 2: Save and Prepare

After generating the summary, save it and prepare for restart:

```bash
# Save handoff to project root
cat > "HANDOFF.md" << 'HANDOFF_EOF'
[INSERT YOUR GENERATED HANDOFF HERE]
HANDOFF_EOF

# Also copy to clipboard as backup
cat "HANDOFF.md" | pbcopy

echo ""
echo "================================================"
echo "HANDOFF SAVED"
echo "================================================"
echo "  ✓ Saved to ./HANDOFF.md"
echo "  ✓ Copied to clipboard"
echo ""
echo "To continue in new session:"
echo "  1. Exit: Ctrl+C (twice)"
echo "  2. Start: claude"
echo "  3. Resume: /handoff-resume"
echo "     (or paste from clipboard)"
echo "================================================"
```

## Tips

- **Use file refs, not summaries** - Claude can read files fresh
- **Track failed approaches** - Saves re-trying dead ends
- **One next action** - Not a list, just the immediate step
- **Run at ~70% context** - Before forced compaction
