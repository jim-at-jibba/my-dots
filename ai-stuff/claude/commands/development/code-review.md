# Code Review Command

<instructions>
  <context>
    Comprehensive code review with automated analysis, security scanning, and structured feedback. Provides consistent review quality and catches issues before they reach production.
  </context>
  
  <requirements>
    - Git repository with commits to review
    - Access to changed files and diffs
    - Linting and static analysis tools configured
    - Security scanning tools available
  </requirements>
  
  <execution>
    1. **Change Analysis**
       - Analyze git diff for modified files
       - Identify scope and impact of changes
       - Check for breaking changes
       - Assess complexity and risk level
    
    2. **Code Quality Review**
       - Check adherence to style guidelines
       - Verify naming conventions
       - Assess code organization and structure
       - Review error handling patterns
    
    3. **Security Analysis**
       - Scan for security vulnerabilities
       - Check for exposed secrets or credentials
       - Validate input sanitization
       - Review authentication and authorization
    
    4. **Performance Review**
       - Identify potential performance issues
       - Check for memory leaks or resource waste
       - Review database queries and optimization
       - Assess caching strategies
    
    5. **Test Coverage**
       - Verify test coverage for new code
       - Check test quality and scenarios
       - Validate edge case handling
       - Review test maintainability
    
    6. **Documentation Review**
       - Check inline documentation
       - Verify API documentation updates
       - Review changelog entries
       - Assess user-facing documentation
  </execution>
  
  <validation>
    - [ ] Code follows project conventions
    - [ ] Security scan passes
    - [ ] Performance metrics acceptable
    - [ ] Test coverage meets standards
    - [ ] Documentation is complete
    - [ ] No breaking changes without justification
    - [ ] Error handling is comprehensive
    - [ ] Code is maintainable and readable
  </validation>
  
  <examples>
    ```bash
    # Review current branch against main
    /dev:code-review
    
    # Output format:
    # ✅ Code Quality: Follows conventions
    # ⚠️  Security: Minor issues found
    # ✅ Performance: No concerns
    # ❌ Tests: Coverage below threshold
    # ✅ Documentation: Complete
    ```
    
    ```bash
    # Review specific commit or PR
    /dev:code-review --commit=abc123
    /dev:code-review --pr=456
    
    # Focused review on specific changes
    ```
    
    ```bash
    # Review with specific focus areas
    /dev:code-review --focus=security,performance
    
    # Provides detailed analysis of:
    # - Security vulnerabilities
    # - Performance bottlenecks
    # - Optimization opportunities
    ```
  </examples>
</instructions>