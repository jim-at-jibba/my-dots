# Generate Tests Command

<instructions>
  <context>
    Comprehensive test suite generation with unit, integration, and end-to-end tests. Analyzes existing code patterns and generates thorough test coverage following testing best practices and project conventions.
  </context>
  
  <requirements>
    - Testing framework configured (Jest, Mocha, pytest, Go test, etc.)
    - Test utilities and mocking libraries available
    - Code coverage tools configured
    - CI/CD pipeline supports test execution
  </requirements>
  
  <execution>
    1. **Code Analysis**
       - Analyze function signatures and interfaces
       - Identify public APIs and entry points
       - Map dependencies and external services
       - Detect edge cases and error conditions
    
    2. **Test Strategy Planning**
       - Determine test types needed (unit, integration, e2e)
       - Identify testing boundaries and isolation points
       - Plan mock strategies for dependencies
       - Define test data requirements
    
    3. **Unit Test Generation**
       - Generate tests for individual functions
       - Create positive and negative test cases
       - Add boundary condition testing
       - Include error handling verification
    
    4. **Integration Test Creation**
       - Test component interactions
       - Verify API contract compliance
       - Test database operations
       - Validate external service integration
    
    5. **End-to-End Test Development**
       - Create user journey tests
       - Test complete workflows
       - Validate UI interactions
       - Test cross-browser compatibility
    
    6. **Test Infrastructure**
       - Set up test fixtures and data
       - Configure test environment
       - Create test utilities and helpers
       - Set up continuous testing
  </execution>
  
  <validation>
    - [ ] All public functions have unit tests
    - [ ] Edge cases are covered
    - [ ] Error conditions are tested
    - [ ] Integration points are validated
    - [ ] User workflows are tested
    - [ ] Test coverage meets standards
    - [ ] Tests are maintainable
    - [ ] CI/CD integration works
  </validation>
  
  <examples>
    ```bash
    # Generate tests for current changes
    /test:generate-tests
    
    # Generated test types:
    # - Unit tests for new functions
    # - Integration tests for API changes
    # - Updated existing test suites
    # - Test data and fixtures
    ```
    
    ```bash
    # Generate tests for specific module
    /test:generate-tests --module=user-service
    
    # Comprehensive module testing:
    # - All service methods tested
    # - Database interaction tests
    # - External API integration tests
    # - Error handling scenarios
    ```
    
    ```bash
    # Generate specific test types
    /test:generate-tests --types=unit,integration
    
    # Focused test generation:
    # - Unit tests only
    # - Integration tests only
    # - Custom test combinations
    ```
  </examples>
</instructions>