# Refactor Analysis Command

<instructions>
  <context>
    Systematic code refactoring analysis with automated detection of code smells, duplication, and improvement opportunities. Provides actionable recommendations with risk assessment and implementation guidance.
  </context>
  
  <requirements>
    - Access to codebase files and structure
    - Static analysis tools configured
    - Code complexity metrics available
    - Version control history for change patterns
  </requirements>
  
  <execution>
    1. **Code Smell Detection**
       - Identify long methods and large classes
       - Detect duplicate code patterns
       - Find complex conditional logic
       - Spot inappropriate coupling
    
    2. **Architecture Analysis**
       - Review module dependencies
       - Identify circular dependencies
       - Analyze layer violations
       - Check separation of concerns
    
    3. **Performance Analysis**
       - Identify performance bottlenecks
       - Detect inefficient algorithms
       - Find memory usage issues
       - Review database query patterns
    
    4. **Maintainability Assessment**
       - Calculate code complexity metrics
       - Assess test coverage gaps
       - Review documentation quality
       - Analyze change frequency patterns
    
    5. **Refactoring Recommendations**
       - Prioritize refactoring opportunities
       - Assess risk levels for each change
       - Provide step-by-step implementation plans
       - Suggest testing strategies
    
    6. **Impact Analysis**
       - Identify affected components
       - Estimate effort and timeline
       - Calculate risk vs benefit
       - Plan rollout strategy
  </execution>
  
  <validation>
    - [ ] All code smells identified
    - [ ] Architecture issues documented
    - [ ] Performance bottlenecks found
    - [ ] Refactoring plan is actionable
    - [ ] Risk assessment complete
    - [ ] Testing strategy defined
    - [ ] Implementation steps clear
    - [ ] Impact analysis thorough
  </validation>
  
  <examples>
    ```bash
    # Analyze entire codebase
    /dev:refactor-analysis
    
    # Output includes:
    # - Code complexity heatmap
    # - Duplication report
    # - Refactoring opportunities
    # - Priority recommendations
    ```
    
    ```bash
    # Focus on specific module
    /dev:refactor-analysis --module=user-service
    
    # Targeted analysis:
    # - Module-specific issues
    # - Internal dependencies
    # - API boundary analysis
    # - Performance characteristics
    ```
    
    ```bash
    # Analyze for specific issues
    /dev:refactor-analysis --focus=performance,security
    
    # Specialized analysis:
    # - Performance bottlenecks
    # - Security vulnerabilities
    # - Optimization opportunities
    # - Risk mitigation strategies
    ```
  </examples>
</instructions>