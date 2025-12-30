---
description: Write comprehensive tests with TDD or verification approach
---

Test $ARGUMENTS

Help me write comprehensive tests for my code.

## Workflow

1. **Analyze** - Understand what to test:
   - Spawn @codebase-explorer to find implementation files and test patterns
   - Identify coverage gaps
   - Ask me: TDD (tests before implementation) or Verification (tests for existing code)?

2. **Plan strategy** - Prioritize test cases:
   - Happy path → Edge cases → Error paths → Integration
   - Focus on: core business logic, public APIs, error handling, security-critical code

3. **Write tests** - Create comprehensive test suite:
   - Spawn @tester with mode (TDD or Verification)
   - Follow project conventions and framework patterns
   - Use clear, descriptive test names (AAA pattern: Arrange, Act, Assert)

4. **Execute** - Run and validate:
   - Run tests
   - Verify pass/fail matches expectations
   - Check coverage

5. **Iterate** - Improve coverage:
   - If bugs found: spawn @debugger to fix
   - Add missing test cases for edge cases
   - Focus on critical paths

## Test Priorities

**Must test:**
- Core business logic
- Public APIs
- Error handling
- Security-critical code

**Should test:**
- Edge cases and boundaries
- Integration points
- Data transformations

**Can skip:**
- Trivial getters/setters
- Framework code
- Third-party libraries

## Validation Checklist

- [ ] All planned tests written
- [ ] Tests follow project conventions
- [ ] Clear, descriptive test names
- [ ] Edge cases covered
- [ ] Error paths tested
- [ ] Tests pass (verification) or fail appropriately (TDD)
- [ ] No flaky tests

