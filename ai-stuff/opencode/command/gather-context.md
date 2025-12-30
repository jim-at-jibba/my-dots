---
description: Gather context about repository state and recent changes
---

Gather Context $ARGUMENTS

Understand the current state of the repository and recent changes.

## Workflow

1. **Understand what I need** - Ask me if unclear:
   - Working tree changes (unstaged/staged)?
   - Recent commits (how many)?
   - Specific file/directory focus?
   - General repository overview?
   - Default: working tree + last 10 commits

2. **Gather git information** - Run in parallel:
   - `git status -s` for working tree state
   - `git diff` for unstaged changes
   - `git diff --staged` for staged changes
   - `git log --oneline -n [N]` for recent commits
   - `git diff HEAD~[N]..HEAD` for changes in last N commits

3. **Analyze codebase** - Understand the code:
   - If specific files/directories: spawn @codebase-explorer for structure and patterns
   - If general overview: identify key directories, technologies, recent activity
   - If unfamiliar tech found: spawn @researcher for context on tools and best practices

4. **Synthesize context** - Organize findings:
   - 📊 **REPOSITORY STATE** - Current branch, uncommitted changes, status
   - 📝 **RECENT ACTIVITY** - Commits, themes, development patterns
   - 📁 **KEY FILES** - Important files with file:line references
   - 🎯 **FOCUS AREAS** - Recommended areas to explore
   - ⚠️ **WARNINGS** - Conflicts, issues, or concerns

5. **Present summary** - Show me:
   - High-level overview of repository state
   - Specific changes with file:line references
   - Recent development activity and themes
   - Recommendations for what to focus on
   - Any warnings (uncommitted changes, merge conflicts, etc.)

## Scope Options

- **Working tree** - Current uncommitted changes
- **Recent commits** - Last N commits (default: 10)
- **General overview** - Project structure, technologies, architecture
- **Focused analysis** - Deep dive into specific areas
- **Combined** - Mix any of the above

## Tips

- Run git commands in parallel for efficiency
- Spawn @codebase-explorer and @researcher in parallel when both needed
- Focus on actionable insights, not raw data
- Provide file:line references for easy navigation
- Identify development themes from commit history

