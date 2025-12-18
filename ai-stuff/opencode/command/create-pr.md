---
description: "Create GitHub PR with well-crafted title and description"
model: github-copilot/gpt-5-mini
arguments:
  - name: base
    description: "Base branch (default: staging)"
    required: false
---

Create a GitHub pull request for the current branch. Be decisive — create the PR without asking for confirmation.

## Steps

1. **Parse arguments**: Use $ARGUMENTS as base branch. If empty, default to `staging`.

2. **Gather context** (run in parallel):
   - `git log <base>..HEAD --oneline` — commits on this branch
   - `git diff <base>..HEAD --stat` — files changed
   - `git branch --show-current` — current branch name
   - Check if branch is pushed: `git rev-parse --abbrev-ref @{upstream}`

3. **If context is unclear**: If commits/diff don't provide enough context to understand what changed and how to test it, read the top 3-5 most-changed files to understand the implementation.

4. **Push if needed**: If branch is not pushed, run `git push -u origin HEAD`

5. **Extract ticket number**: Look for `BRD-XXXX` pattern in branch name. If not found, leave ticket blank.

6. **Write the PR title**:
   - Capitalized imperative mood: "Add", "Fix", "Update", "Refactor" (NOT "fix:" or "feat:")
   - Concise but descriptive (~50 chars)
   - Append ticket in parentheses if found: `(BRD-1234)`
   - Examples:
     - Good: "Fix profile validation for empty email fields (BRD-1234)"
     - Good: "Add CSV export to reports screen"
     - Bad: "Bug fix" (too vague)
     - Bad: "fix: update validation" (no conventional commit prefixes)

7. **Write the PR description** using this template:

```markdown
## Summary
- (2-4 bullet points explaining WHY this change was made and WHAT it does)
- (Focus on motivation and impact, not just listing files)

## How to Test
- (2-4 bullet points with concrete steps to verify the change)
- (Include: where to navigate, what to do, what to expect)
- (Example: "1. Go to Profile > Edit. 2. Clear email field and submit. 3. Should show validation error.")

## Ticket
BRD-XXXX (or "N/A" if no ticket)

## Screenshots
(Leave empty — author will add manually if this is a UI change)

## Checklist
- [ ] I have performed a self-review of my code
- [ ] I have added tests (or tests are not applicable)
- [ ] If user-facing: posted in #product-playground with a demo video
```

8. **Create the PR**:
```bash
gh pr create --base <base> --title "<title>" --body "<description>"
```

9. **Output**: Show the PR URL. One line. Done.

## Key Principles

- **Explain the WHY**: The summary should answer "why does this change exist?" not just "what files changed"
- **Be concise**: Reviewers skim. Bullet points > paragraphs.
- **No fluff**: Don't add sections you won't use. The template is minimal by design.
- **Decisive**: Create the PR immediately. User can edit on GitHub if needed.
