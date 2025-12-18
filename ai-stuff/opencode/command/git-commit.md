---
description: Create a smart git commit
model: github-copilot/gpt-4o
---

# Smart Commit

Create a git commit with well-crafted message following project commit guidelines.

## Instructions

1. **Check git status**:
   - Run `git status` to see staged and unstaged changes
   - Run `git diff --cached` to see what's staged (if anything)

2. **If files are already staged**:
   - Analyze the staged changes
   - Generate commit message
   - Commit
   - Mention if unstaged changes exist (in case user forgot something)

3. **If no files staged but unstaged changes exist**:
   - Run `git diff` to analyze the changes
   - Skip lock files (e.g., Podfile.lock, yarn.lock) — these are usually unintentional
   - Identify the most cohesive set of related changes
   - **Be decisive**: If there's a clear set of related changes + some lock files:
     - Stage and commit the related changes
     - Mention what was skipped: "Skipped: Podfile.lock (lock file)"
   - **Only ask if genuinely ambiguous**: Multiple unrelated non-lock-file changes where it's unclear which to commit:
     ```
     I see two unrelated sets of changes:
     1. Validation refactor (validation.ts, helpers.ts)
     2. README update (README.md)
     
     Which would you like to commit first?
     ```
   - Stage appropriate files using explicit paths: `git add <file1> <file2>`
   - **NEVER use `git add -A` or `git add .`** — always explicit file paths

4. **If nothing to commit**: Tell the user "Nothing to commit"

## Commit Message Rules

Follow these rules exactly:

**Subject line:**
- Start with a capital letter
- Use imperative mood (Add, Fix, Update, etc.)
- 50 characters or less
- No period at the end
- **Must describe the actual change** — not generic "Fix script" but "Update complexity threshold to 20"
- **Litmus test**: The subject should complete the sentence "If applied, this commit will ___"
  - ✅ "If applied, this commit will **update complexity threshold to 20**"
  - ❌ "If applied, this commit will **fix script**" (too vague)
  - ❌ "If applied, this commit will **fixed bug**" (wrong tense)

**Body (if needed):**
- Leave one blank line after the subject
- Wrap at 72 characters
- Explain what and why, not how
- Use bullet points with "-" for lists
- Each bullet point should start with a capital letter
- **NEVER include process notes** like "skipped Podfile.lock" — that's not part of the change

**Focus on:**
- What problem this commit solves
- Why the change was made (not how)
- Motivation behind the changes

**Examples of good vs bad:**
- Bad: "Fix complexity report script"
- Good: "Update complexity-report default threshold to 20"
- Bad: "Update file"  
- Good: "Extract validation helpers to reduce complexity"

## Commit Format

Use heredoc format for multi-line messages:

```bash
git commit -m "Subject line

- First bullet point
- Second bullet point
- Third bullet point"
```

Or for simple single-line commits:

```bash
git commit -m "Fix validation error on empty input"
```

## Notes

- Always use explicit file paths when staging, never `-A` or `.`
- Skip lock files unless user has explicitly staged them
- **Be decisive**: Don't ask for permission if the right action is clear. User can ESC to cancel or undo with `git reset HEAD~1`
- Only ask if there are multiple genuinely unrelated changes (not counting lock files)
- Keep subject line under 50 characters (hard limit 72)
- The message should explain WHY, not just describe WHAT changed
- After committing, give a **brief one-line confirmation**:
  ```
  Committed: `file.ts` — "Your commit message here"
  Skipped: Podfile.lock (lock file)
  ```
  Do NOT repeat the full commit details or ask what to do next
