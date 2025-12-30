---
description: Create atomic git commits with conventional messages
---

Commit $ARGUMENTS

Create git commits for my changes.

## Process

1. **Analyze and plan** - Review conversation history, run `git status -s` and `git diff`, determine if changes should be one or multiple logical commits, group related files, draft conventional commit messages (`type: description`) in imperative mood focusing on why
2. **Present plan** - List files for each commit, show commit messages with type prefix, ask: "I plan to create [N] commit(s) with these changes. Shall I proceed?"
3. **Execute upon confirmation** - Use `git add` with specific files (never `-A` or `.`), create commits with planned messages, show result with `git log --oneline -n [N]`

## Commit Message Format

Use conventional commit format: `type: description`

**Types:**
- `feat:` - New feature (user-facing)
- `fix:` - Bug fix (user-facing)
- `docs:` - Documentation only
- `chore:` - Maintenance, tooling, dependencies
- `refactor:` - Code restructuring without behavior change
- `test:` - Adding or updating tests
- `perf:` - Performance improvement
- `ci:` - CI/CD changes

**Note:** During release generation, `chore:`, `docs:`, and `ci:` commits are filtered from changelog. Only user-facing changes (`fix:`, `feat:`, etc.) are included.

