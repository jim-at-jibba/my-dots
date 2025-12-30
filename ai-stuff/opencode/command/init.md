---
description: Initialize AGENTS.md file with best practices for agentic development
---

# Initialize AGENTS.md

Analyze the codebase and create an AGENTS.md file with project-specific guidance for AI coding agents.

**Injected into every agent prompt** - Make it concise but comprehensive. Include only what agents can't infer from code.

## Process

1. **Analyze codebase** - Examine: README (project overview, tech stack, commands, setup), config files (package.json, tsconfig.json, etc.), project structure (business logic, database schemas, API routing, applications, components), code organization patterns, testing setup, existing agent rules (.cursor/rules/, .cursorrules, .github/copilot-instructions.md)
2. **Generate AGENTS.md** - Include: **Build/lint/test commands** (especially single test execution), **Project structure** (where to find business logic, schemas, routes, apps, components), **Code style** (imports, formatting, types, naming, error handling), **Key conventions**, **Safety constraints**, incorporate existing Cursor/Copilot rules if found
3. **Write** - If AGENTS.md exists, improve it; otherwise create new; write to specified path (default: current directory)

## Guidelines

- Be specific, not generic - avoid vague phrases like "Follow best practices"
- Exact commands with syntax, especially single test execution
- Essential sections: Commands, Code Style, Conventions, Safety

## Example Structure

Analyze the project and generate appropriate content. Example format only:

```markdown
# AGENTS.md

## Commands
- Install: [dependency install command]
- Test all: [test command]
- Test single: [single test execution with path]
- Lint: [linter command]

## Project Structure
- Business logic: [location of core business logic]
- Database schemas: [location of schema definitions]
- API routes: [location of API routing/endpoints]
- Applications: [location of app entry points]
- Components: [location of UI/shared components]
- Tests: [location and organization of tests]

## Code Style
- [Language-specific style guidelines]
- [Import/module patterns]
- [Error handling patterns]

## Conventions
- [File organization patterns]
- [Naming conventions]

## Safety
- Never execute shell commands with user input
- Never use `sudo` without explicit permission
```

