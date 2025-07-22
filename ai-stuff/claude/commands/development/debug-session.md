# Debug Session Command

<instructions>
  <context>
    Systematic debugging approach with automated issue detection, root cause analysis, and step-by-step resolution. Combines static analysis, runtime debugging, and systematic problem-solving methodologies.
  </context>
  
  <requirements>
    - Access to application logs and error messages
    - Debugging tools configured (debugger, profiler, etc.)
    - Test environment or reproduction steps
    - Source code access and version control
  </requirements>
  
  <execution>
    1. **Issue Analysis**
       - Gather error messages and stack traces
       - Identify reproduction steps
       - Analyze error patterns and frequency
       - Classify issue type and severity
    
    2. **Environment Investigation**
       - Check environment variables and configuration
       - Verify dependency versions
       - Analyze system resources and limits
       - Review recent changes and deployments
    
    3. **Code Analysis**
       - Trace code execution paths
       - Identify potential null pointer/undefined access
       - Check boundary conditions and edge cases
       - Review error handling and logging
    
    4. **Data Analysis**
       - Examine input data and parameters
       - Validate data types and formats
       - Check database state and queries
       - Analyze network requests and responses
    
    5. **Root Cause Identification**
       - Isolate the minimal reproduction case
       - Identify the exact failure point
       - Determine underlying cause
       - Assess impact and affected components
    
    6. **Resolution Strategy**
       - Develop fix implementation plan
       - Create test cases for the issue
       - Implement monitoring and prevention
       - Document lessons learned
  </execution>
  
  <validation>
    - [ ] Issue clearly reproduced
    - [ ] Root cause identified
    - [ ] Fix strategy defined
    - [ ] Test cases created
    - [ ] Monitoring implemented
    - [ ] Documentation updated
    - [ ] Similar issues prevented
    - [ ] Knowledge shared with team
  </validation>
  
  <examples>
    ```bash
    # Debug current application error
    /dev:debug-session
    
    # Interactive debugging:
    # - Error analysis
    # - Log investigation
    # - Code tracing
    # - Solution implementation
    ```
    
    ```bash
    # Debug specific error with context
    /dev:debug-session --error="NullPointerException" --context="user-login"
    
    # Focused debugging:
    # - Specific error type analysis
    # - Contextual code review
    # - Targeted fix implementation
    ```
    
    ```bash
    # Debug performance issue
    /dev:debug-session --type=performance --metric=response-time
    
    # Performance debugging:
    # - Profiling analysis
    # - Bottleneck identification
    # - Optimization recommendations
    # - Performance testing
    ```
  </examples>
</instructions>