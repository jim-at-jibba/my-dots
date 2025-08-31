# QA Test Suite

Analyze the changes on the current git branch compared to staging and generate a focused QA test report.

Steps:
1. Compare current branch to staging to identify modified files
2. Review commit messages to understand changes
3. Create practical test cases with priorities (HIGH/MEDIUM/LOW)
4. Include success criteria and red flags

Output format:
- Simple test cases with checkboxes
- Priority levels for each test
- Expected results for each test
- Critical red flags to watch for
- Success criteria (must pass vs should pass)

Focus on actionable test scenarios without fluff. The base branch for comparison is always "staging".

**Use this command to perform a comprehensive analysis of what has been done on this branch and create a test suite that can be given to a QA team**
