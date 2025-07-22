# Update README Command

<instructions>
  <context>
    Comprehensive README maintenance with automatic content generation, project analysis, and documentation best practices. Ensures README stays current with project changes and provides excellent developer experience.
  </context>
  
  <requirements>
    - Access to project files and structure
    - Package management files (package.json, requirements.txt, etc.)
    - CI/CD configuration and badges
    - License and contribution guidelines
  </requirements>
  
  <execution>
    1. **Project Analysis**
       - Scan project structure and files
       - Identify key technologies and frameworks
       - Analyze build and deployment processes
       - Extract project metadata and dependencies
    
    2. **Content Structure Generation**
       - Create comprehensive table of contents
       - Generate project description and purpose
       - Add installation and setup instructions
       - Include usage examples and tutorials
    
    3. **Badge and Status Integration**
       - Add CI/CD pipeline status badges
       - Include code coverage and quality badges
       - Add dependency status indicators
       - Include license and version badges
    
    4. **Documentation Links**
       - Link to detailed documentation
       - Add API documentation references
       - Include changelog and release notes
       - Link to issue tracker and discussions
    
    5. **Contribution Guidelines**
       - Add contribution instructions
       - Include code of conduct
       - Document development setup
       - Add pull request guidelines
    
    6. **Maintenance and Updates**
       - Verify all links are working
       - Update screenshots and examples
       - Refresh dependency information
       - Validate installation instructions
  </execution>
  
  <validation>
    - [ ] README reflects current project state
    - [ ] Installation instructions work
    - [ ] All links are functional
    - [ ] Examples are up-to-date
    - [ ] Badges show correct status
    - [ ] Contribution guidelines clear
    - [ ] Project purpose well explained
    - [ ] Documentation structure logical
  </validation>
  
  <examples>
    ```bash
    # Update README with current project state
    /docs:update-readme
    
    # Updated sections:
    # - Project description
    # - Installation instructions
    # - Usage examples
    # - Contributing guidelines
    ```
    
    ```bash
    # Update README with new feature highlights
    /docs:update-readme --highlight-features
    
    # Feature-focused update:
    # - New feature descriptions
    # - Updated examples
    # - Enhanced screenshots
    # - Migration guides
    ```
    
    ```bash
    # Update README for specific audience
    /docs:update-readme --audience=developers
    
    # Developer-focused update:
    # - Technical details
    # - Architecture overview
    # - Development setup
    # - API references
    ```
  </examples>
</instructions>