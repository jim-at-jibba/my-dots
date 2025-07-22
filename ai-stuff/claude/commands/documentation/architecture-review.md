# Architecture Review Command

<instructions>
  <context>
    Comprehensive architecture documentation and review with system design analysis, component mapping, and technical debt assessment. Creates and maintains architectural documentation that guides development decisions.
  </context>
  
  <requirements>
    - Access to complete codebase and project structure
    - System design and architecture documentation tools
    - Dependency analysis and visualization tools
    - Performance and scalability metrics
  </requirements>
  
  <execution>
    1. **System Architecture Analysis**
       - Map system components and services
       - Analyze inter-service communication patterns
       - Document data flow and processing pipelines
       - Identify architectural patterns and styles
    
    2. **Component Documentation**
       - Document individual component responsibilities
       - Map component dependencies and interfaces
       - Analyze coupling and cohesion patterns
       - Identify reusable components and libraries
    
    3. **Technical Debt Assessment**
       - Identify architectural inconsistencies
       - Analyze code quality and maintainability
       - Document technical debt and improvement opportunities
       - Assess scalability and performance bottlenecks
    
    4. **Documentation Generation**
       - Create architecture diagrams and visualizations
       - Generate component interaction diagrams
       - Document API contracts and interfaces
       - Create deployment and infrastructure diagrams
    
    5. **Review and Recommendations**
       - Assess architecture against industry best practices
       - Identify improvement opportunities
       - Document architectural decisions and rationale
       - Create roadmap for architectural evolution
    
    6. **Knowledge Sharing**
       - Create architecture overview presentations
       - Document onboarding materials for new developers
       - Establish architecture review processes
       - Create decision logs and ADRs
  </execution>
  
  <validation>
    - [ ] System architecture clearly documented
    - [ ] Component relationships mapped
    - [ ] Technical debt identified
    - [ ] Improvement roadmap created
    - [ ] Architecture diagrams accurate
    - [ ] Decision rationale documented
    - [ ] Knowledge sharing materials ready
    - [ ] Review processes established
  </validation>
  
  <examples>
    ```bash
    # Complete architecture review and documentation
    /docs:architecture-review
    
    # Generated documentation:
    # - System overview diagrams
    # - Component documentation
    # - Technical debt analysis
    # - Improvement recommendations
    ```
    
    ```bash
    # Review specific architecture layer
    /docs:architecture-review --layer=data-layer
    
    # Layer-specific review:
    # - Data architecture analysis
    # - Database design review
    # - Data flow documentation
    # - Performance optimization
    ```
    
    ```bash
    # Architecture review for scaling
    /docs:architecture-review --focus=scalability
    
    # Scalability-focused review:
    # - Performance bottlenecks
    # - Scaling strategies
    # - Load balancing options
    # - Infrastructure requirements
    ```
  </examples>
</instructions>