---
description: Large-scale refactoring with phased execution and validation
---

Refactor $ARGUMENTS

Help me refactor code systematically with minimal risk.

## Strategy

Minimize risk through:
- Small phases (change one thing at a time)
- Continuous testing (validate after each phase)
- Incremental migration (old and new coexist temporarily)
- Type-driven (let compiler catch breaks)
- Reversible (each phase can be rolled back)

## Workflow

1. **Analyze** - Understand the scope:
   - Spawn @codebase-explorer to find affected files and dependencies
   - Spawn @tester to identify test coverage gaps
   - Map integration points and risks

2. **Design strategy** - Create a phased plan:
   - Break into incremental phases that can be validated independently
   - Each phase should be reversible and build on previous phases
   - Present the strategy to me with phase breakdown and effort estimates
   - Get my confirmation before proceeding

3. **Prepare tests** - Establish baseline:
   - Spawn @tester in TDD mode to create characterization tests
   - Ensure existing behavior is captured
   - Run tests to establish baseline (proves refactor doesn't change behavior)

4. **Execute phases** - For each phase:
   - Implement changes (stay focused on one thing)
   - Run tests (spawn @debugger if failing)
   - Type check and fix immediately
   - Manual validation
   - Atomic commit with clear message
   - Update me on progress
   - If phase fails repeatedly: reassess, break into smaller phases, ask me

5. **Cleanup** - Finalize the refactoring:
   - Remove scaffolding and temporary code
   - Final validation (all tests pass, types valid, no dead code)
   - Spawn @reviewer for final check
   - Document lessons learned

6. **Report** - Summarize for me:
   - What was refactored
   - Phases completed
   - Tests added/updated
   - Issues encountered
   - Follow-up recommendations

## Validation Checklist

**After each phase:**
- [ ] All tests pass
- [ ] Types valid
- [ ] Manual testing done
- [ ] Commit created

**Before declaring complete:**
- [ ] All phases done
- [ ] Old code removed
- [ ] Tests comprehensive
- [ ] Documentation updated
- [ ] Review completed

