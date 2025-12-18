---
description: Load branch context quickly
model: github-copilot/gpt-4o
---

# Context Loader

Build up context from your current branch so you can continue working in a new conversation.

## Usage

```
/context [base-branch]
```

Default base branch: `staging`

## Purpose

This command is NOT about generating a report for the user. The goal is:
1. **You (the agent) read and understand** the work on this branch
2. **You internalize the context** so you can help with follow-up tasks
3. **You confirm briefly** that you understand, then ask what to work on

The user already knows what they're working on. They just need YOU to catch up quickly.

## Instructions

1. **Determine base branch**: Use `$1` if provided, otherwise default to `staging`

2. **Gather git information** (run these commands):
   - `git rev-parse --abbrev-ref HEAD` — get current branch name
   - `git log <base>..HEAD --oneline` — see commits
   - `git diff <base> --stat` — see file change summary

3. **Read the actual code changes**:
   - `git diff <base>..HEAD --name-only` — get list of changed files
   - Pick top 3-5 most important files (prioritize src/ over tests, most-changed files)
   - `git diff <base>..HEAD -- <file1> <file2> <file3>` — read actual diffs
   - If PR-*.md or QA notes exist, read those too

4. **Internalize** (do NOT output this, just understand):
   - What is being worked on?
   - What patterns do you see? (refactors, bug fixes, new features)
   - What are the key files involved?
   - What bugs were fixed? What was the approach?
   - What architectural changes were made?

5. **Respond briefly**:
   - 2-3 sentence summary confirming you understand the branch
   - Mention branch name and commit count
   - Mention the main focus area (e.g., "refactoring validation", "fixing eidLock bug")
   - Ask: "What would you like to work on?"

## Output Format

Keep it SHORT. Example:

```
I've reviewed the 27 commits on `crush-animal-id-tests` since staging. 
This branch refactors the UpdateAnimalIds validation (Yup → Zod), 
extracts helpers to reduce complexity, and fixes the eidLock cleanup bug. 
Key files: validation.ts, index.tsx, helpers.ts, extendedFieldValidation.ts.

What would you like to work on?
```

That's it. No headers, no bullet points, no detailed breakdown unless asked.

## Notes

- **IMPORTANT**: Always read the actual code diffs, not just commit messages
- The context is for YOU, not a report for the user
- If the user wants details, they'll ask
- If base branch doesn't exist, suggest alternatives
