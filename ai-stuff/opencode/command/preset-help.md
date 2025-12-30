---
description: Explain what this preset provides and how to use it
---

Explain this agentic development preset to me.

## What to Cover

### 1. The Orchestrator (@smart)
Explain the 5-step workflow:
- **Understand** - Assess complexity, decide to ask or build
- **Research** - Spawn subagents to gather context
- **Plan** - Create plan, todos, surface unresolved questions
- **Execute** - Work through tasks, delegate to specialists
- **Complete** - Verify quality, all todos done

### 2. Available Subagents
Explain each and when to use:
- **@codebase-explorer** - Find files, analyze implementations, trace data flow
- **@researcher** - External docs, best practices, API references
- **@implementer** - Focused code changes to single files
- **@tester** - Write tests (TDD or verification mode)
- **@debugger** - Deep error diagnosis, root cause analysis
- **@reviewer** - Code review for correctness, security, performance
- **@documenter** - READMEs, API docs, guides, changelogs

### 3. Available Commands
List each with brief description:
- `/commit` - Commit with meaningful message
- `/review` - Code review with automated checks
- `/test` - Run or write tests
- `/debug` - Diagnose errors
- `/refactor` - Refactor with safety checks
- `/research` - Research codebase and external docs
- `/document` - Generate documentation
- `/init` - Create AGENTS.md for the project
- `/gather-context` - Repo state and recent changes

### 4. How to Work With This Setup
- Just describe what you need - the orchestrator handles delegation
- Use slash commands for specific workflows
- The agent tracks progress with todos
- You control git - agent won't auto-commit

### 5. Customization
- `AGENT_RULES.md` - Add project-specific rules
- `agent/` - Modify subagent behavior
- `command/` - Add or edit commands

Keep the explanation practical and concise. Focus on how to use it, not theory.
