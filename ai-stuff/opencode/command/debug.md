---
description: Systematic debugging with root cause analysis and fixes
---

Debug $ARGUMENTS

Help me diagnose and fix a bug systematically.

## Workflow

1. **Reproduce** - Confirm the issue:
   - Run failing tests or reproduce the bug
   - Capture full error output and stack traces
   - Ask me for reproduction steps if unclear

2. **Gather evidence** - Collect context:
   - Error messages and logs
   - Recent changes (`git log`, `git diff`)
   - Environment details
   - Related code

3. **Analyze root cause** - Deep investigation:
   - Spawn @debugger with comprehensive context
   - Provide: errors, stack traces, reproduction steps, relevant code
   - Get root cause analysis and recommended fix

4. **Implement fix** - Apply the solution:
   - Make focused changes
   - Update tests to prevent regression
   - Keep changes minimal

5. **Validate** - Verify the fix:
   - Run all tests
   - Verify types
   - Test edge cases
   - Ensure no regressions

6. **Prevent** - Strengthen defenses:
   - Add test cases that would catch this bug
   - Improve validation/error handling
   - Document the issue and fix

## Debugging Strategies

- **Failing tests** - Read expectations, run in isolation, check setup/teardown
- **Runtime errors** - Follow stack trace, check variable states, trace backwards
- **Logic bugs** - Add logging, trace data transformations, check boundaries
- **Performance** - Profile hot paths, check for N+1 queries, identify memory leaks
- **Integration** - Verify API contracts, check data formats, test in isolation

## Validation Checklist

- [ ] Failing test now passes
- [ ] All other tests still pass
- [ ] Types valid
- [ ] Manual testing confirms fix
- [ ] Edge cases handled
- [ ] No regressions introduced
- [ ] Prevention tests added

