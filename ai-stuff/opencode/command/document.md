---
description: Create or update documentation with research, planning, and review
---

Document $ARGUMENTS

Help me create or update documentation systematically.

## Workflow

1. **Research** - Understand what to document:
   - Spawn @codebase-explorer to find existing docs and code to document
   - Spawn @researcher for external doc best practices if needed
   - Synthesize: target audience, format, examples needed

2. **Plan** - Design the documentation:
   - Structure (sections, order, examples, audience-specific content)
   - List files to create/update
   - Present the plan to me and get my approval

3. **Execute** - Write the documentation:
   - Use TodoWrite to track progress
   - Spawn @documenter agents (one per file for parallel work)
   - Provide clear instructions with target audience and format

4. **Review** - Validate quality:
   - Verify: accuracy, completeness, clarity, working examples, consistency, valid links
   - Test all code examples
   - Optionally spawn @reviewer for critical docs

5. **Report** - Summarize for me:
   - What was created/updated
   - Key sections added
   - Examples included
   - Any follow-up needed

## Documentation Types

- **README** - Project overview, installation, quick start, usage examples
- **API docs** - Function signatures, parameters, return values, errors, examples
- **User guides** - Step-by-step instructions, use cases, troubleshooting
- **Architecture** - System overview, component relationships, data flow, design decisions
- **Inline comments** - Why not what, edge cases, algorithms, performance notes
- **Changelogs** - Version, date, breaking changes, features, fixes, migrations

## Best Practices

- **Audience-focused** - Write for the intended reader (end users, developers, contributors)
- **Example-driven** - Show don't tell, realistic copy-pasteable examples with expected output
- **Maintainable** - Keep docs close to code, update together, consistent formatting
- **Clear and concise** - Simple language, define terms, break into steps, structured headings
- **Accurate** - Test all examples, match implementation, verify links

