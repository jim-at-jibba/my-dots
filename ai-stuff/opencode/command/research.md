---
description: Research codebase and external docs with parallel analysis
---

Research $ARGUMENTS

Help me research a topic using codebase analysis and external docs.

## Workflow

1. **Understand what I need** - Ask me:
   - Internal codebase understanding?
   - External documentation/best practices?
   - Combination of the above?

2. **Spawn subagents in parallel** - Always run concurrently for efficiency:
   - Spawn @codebase-explorer to find files and analyze implementations
   - Spawn @researcher for external docs, best practices, comparisons
   - Wait for all to complete

3. **Synthesize findings** - Combine and analyze:
   - **Codebase**: How it works, file:line references, patterns, architectural decisions
   - **External**: Key concepts, best practices, code examples, pitfalls, doc links
   - **Combined**: Current state vs recommended approach, gap analysis, options with trade-offs

4. **Present results** - Show me:
   - High-level overview
   - Detailed findings with specific references (file:line, doc URLs)
   - Patterns and best practices
   - Actionable recommendations

## Tips

- Always run subagents in parallel for maximum efficiency
- Focus on synthesis, not raw data dump
- Provide actionable recommendations
- Note version-specific information

