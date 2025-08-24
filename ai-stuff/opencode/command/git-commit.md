---
description: Git Commit Command
---

Git commit for all staged files following these rules:

- Takes all changed and new files, suggests a commit message, ALWAYS asks for confirmation, and creates the commit ONLY after explicit approval
- This task is one of ONLY two places where committing is allowed (the other being commit-fast)
- Format of commit message depends on the affected files:
  - For package changes (e.g., apps/graphql): `[package1,package2] description of changes`
    - Git-related files: `[gitignore] description of changes`
    - Claude related files (e. g. CLAUDE.md or changes in .claude folder): `[claude] description of changes`
    - Other root configs: use appropriate descriptor in square brackets
  - Description should start with lowercase letter
  - Description should be concise and explain what was changed
- The scope in square brackets should be consistent across all suggested message options - it's a fixed rule based on the files changed, not something to vary between options
- When suggesting commit messages, use `git log -n 100 --oneline` to review the most recent commit messages for inspiration on format and style
- Format the suggested commit messages in orange text to make them more readable in the terminal
- Only after I explicitly confirm or modify the commit message, proceed with `git commit -m "message"`
- If I tell you that you can push the changes, you can run `git push` directly without asking for permission
- Do NOT add Claude co-authorship footer to commits

## Examples of Good Commit Messages

- `[ui] fix username retrieval issues in Header component on initial render`
- `[alerts] new notification module for system and maintenance type of alerts`
- `[queue-payment-processing] moved generateMonthlyStatementJob to queue from admin`
- `[admin] new action for creating manual adjustments in user profile`

