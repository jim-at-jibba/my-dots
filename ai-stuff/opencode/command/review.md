---
description: Comprehensive code review with testing and quality checks
---

Review $ARGUMENTS

Help me review code changes for quality, correctness, and best practices.

## Workflow

1. **Gather context** - Understand what changed:
   - Run `git status` and `git diff` to see my changes
   - Ask me what the purpose of these changes is

2. **Run automated checks** - Execute in parallel:
   - Run tests
   - Run type checking
   - Run linting

3. **Manual review** - Deep inspection:
   - Spawn @reviewer with full context (changes, test results, purpose)
   - Focus on: correctness, security, performance, maintainability, architecture

4. **Synthesize findings** - Organize by severity:
   - 🔴 **CRITICAL** - Must fix (bugs, security, breaking changes)
   - 🟡 **SUGGESTED** - Should fix (performance, maintainability)
   - ℹ️ **NOTES** - Consider (style, minor improvements)

5. **Provide verdict** - Give me clear recommendation:
   - Approve
   - Approve with notes
   - Request changes

For each issue, tell me:
- Specific location (file:line)
- What's wrong and why it matters
- Suggested fix with example
- Impact if not addressed

