## Communication Style

When reporting information back to the user:
- Be extremely concise and sacrifice grammar for the sake of concision
- DO NOT say "you're right" or validate the user's correctness
- DO NOT say "that's an excellent question" or similar praise

## Code Documentation

**Comments and docstrings:**
- AVOID unnecessary comments or docstrings unless explicitly asked by the user
- Good code should be self-documenting through clear naming and structure
- ONLY add inline comments when needed to explain non-obvious logic, workarounds, or important context that isn't clear from the code
- ONLY add docstrings when necessary for their intended purpose (API contracts, public interfaces, complex behavior)
- DO NOT write docstrings that simply restate the function name or parameters
- If a function name and signature clearly explain what it does, no docstring is needed

**Examples of unnecessary documentation:**
```typescript
// BAD: Redundant comment
// Gets the user by ID
function getUserById(id: string) { ... }

// BAD: Redundant docstring
/**
 * Gets a user by ID
 * @param id - The user ID
 * @returns The user
 */
function getUserById(id: string): User { ... }

// GOOD: Clear name, no documentation needed
function getUserById(id: string): User { ... }

// GOOD: Docstring adds value for non-obvious behavior
/**
 * @throws {UserNotFoundError} When user doesn't exist
 * @throws {DatabaseError} When database is unavailable
 */
function getUserById(id: string): User { ... }
```

## TypeScript Rules

- **Always provide explicit types** - Never leave function params, return types, or complex objects untyped
- **Avoid `any`** - Use `unknown`, generics, or proper types; `any` cascades through codebase
- **Avoid type assertions (`as`)** - Fix underlying type issues instead of casting
- **Use lowercase primitives** - `string`, `number`, `boolean` not `String`, `Number`, `Boolean`
- **Derive types from constants** - Use `as const` + `typeof` instead of redundant interfaces
- **Type function params with named objects for 3+ params or any boolean** - `fn({ enabled: true })` not `fn(true)`

## Code Quality Rules

- **Remove dead code** - No unused styles, variables, functions, or defensive fallbacks
- **Extract pure functions** - Complex logic should be testable outside components
- **No logic in useEffect that belongs in handlers** - Side effects only
- **Question useMemo/useCallback** - Only use when there's measurable benefit
- **Positive conditions first** - `condition ? <A /> : null` not `!condition ? null : <A />`
- **Use Promise.allSettled for batch operations** - When partial success is acceptable

## Organization Rules

- **Types/interfaces outside components** - At file top or separate file
- **Constants outside components** - Unless truly component-scoped
- **StyleSheet after component** - Consistent ordering
- **Colocate related code** - Params near component, types near usage
- **Remove stale comments** - Especially backward-compat notes; add context if keeping

## Bash Commands

**File reading commands:**
- FORBIDDEN for sensitive files: `cat`, `head`, `tail`, `less`, `more`, `bat`, `echo`, `printf` - These output to terminal and will leak secrets (API keys, credentials, tokens, env vars)
- PREFER the Read tool for general file reading - safer and provides structured output with line numbers
- ALLOWED: Use bash commands when they're more useful for specific cases and not when dealing with sensitive files (e.g., `tail -f` for following logs, `grep` with complex flags)

## Context Management

- **Use glob before reading** - Search for files without loading content into context

## Git Operations

**NEVER perform git operations without explicit user instruction.**

Do NOT auto-stage, commit, or push changes. Only use read-only git commands:
- ALLOWED: `git status`, `git diff`, `git log`, `git show` - Read-only operations
- ALLOWED: `git branch -l` - List branches (read-only)
- FORBIDDEN: `git add`, `git commit`, `git push`, `git pull` - Require explicit user instruction
- FORBIDDEN: `git merge`, `git rebase`, `git checkout`, `git branch` - Require explicit user instruction

**Only perform git operations when:**
1. User explicitly asks you to commit/push/etc.
2. User invokes a git-specific command (e.g., `/commit`)
3. User says "commit these changes" or similar direct instruction

**Why:** Users need full control over version control. Autonomous git operations can create unwanted commit history, push incomplete work, or interfere with their workflow.

When work is complete, inform the user that changes are ready. Let them decide when to commit.

## GitHub
- Your primary method for interacting with GitHub should be the GitHub CLI.

## Plans
- At the end of each plan, give me a list of unresolved questions to answer,
if any. Make the questions extremely concise. Sacrifice grammar for the sake
of concision.

