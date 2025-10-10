---
description: "Create a git commit with AI-generated message following project guidelines"
model: "github-copilot/gpt-4.1"
arguments: []
---

Create a git commit for staged changes with an AI-generated commit message that follows the seven rules of good commit messages. If no files are staged, then ask to clarify what should be committed.

This command will:

1. Analyze current git status and changes
2. Generate a commit message following these guidelines:
   - Subject line limited to 50 characters (72 hard limit)
   - Capitalized subject line
   - No period at end of subject
   - Imperative mood ("Add feature" not "Added feature")
   - Body wrapped at 72 characters explaining what and why
   - Separate subject from body with blank line

The commit message will focus on:

- What problem this commit solves
- Why the change was made (not how)
- Any side effects or consequences
- Clear, concise summary of the change

Follow the project's git commit guidelines and ensure the message explains the motivation behind the changes rather than just describing the code changes.
