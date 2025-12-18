---
description: "Run tests only for files changed on this branch"
model: github-copilot/gpt-4o
---

Run tests for files changed on this branch. Be simple and direct — do NOT write a bash script.

## Instructions

1. **Determine base branch**: If `$ARGUMENTS` is provided, use it. Otherwise default to `staging`.

2. **Get changed files**:
   ```
   git diff --name-only staging...HEAD
   ```

3. **Collect test files to run**:
   - Any changed file ending in `.test.ts` or `.test.tsx` → add to list
   - For each changed source file (`.ts`, `.tsx` but NOT `.test.ts`, `.d.ts`, or in `/generated/`):
     - Look for a test file in the SAME directory or its `__tests__` subdirectory
     - Match by exact filename: `foo.ts` → `foo.test.ts` or `__tests__/foo.test.ts`
     - Do NOT search the whole codebase — only check the same directory
     - If file is named `index.tsx`, check for `index.test.tsx` or `__tests__/index.test.tsx` in that same folder only

4. **Skip if no tests found**: If no test files exist, say so and exit.

5. **Run tests**: 
   ```
   yarn test path/to/first.test.ts path/to/second.test.ts
   ```

6. **Report results briefly**.

## Important

- Do NOT write a bash script. Just run commands directly.
- Do NOT use ripgrep or find to search the whole codebase.
- Only look for test files in the same directory as the changed source file.
- `index.tsx` is common — do NOT match all `index.test.tsx` files, only the one in the same folder.
