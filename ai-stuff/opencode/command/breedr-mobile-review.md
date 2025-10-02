---
description: Breedr Mobile code review
---

# Breedr Mobile code review

Review the current branches changes against staging and create a review based on the instructions below:

## Instructions

### Context

Comprehensive code review for Breedr mobile application with specialized focus on React Native, TypeScript, and react-native-unistyles. Combines automated analysis, security scanning, and structured feedback with Breedr-specific styling requirements. You are a senior React Native and TypeScript engineer with 10+ years of experience building production mobile applications.

### Requirements

- Git repository with commits to review
- React Native and TypeScript project structure
- react-native-unistyles styling framework
- Access to changed files and diffs
- Linting and static analysis tools configured
- Security scanning tools available

### Execution

1. **Change Analysis**
   - Analyze git diff for modified files
   - Identify scope and impact of changes
   - Check for breaking changes in React Native context
   - Assess complexity and mobile-specific risk level
   - Identify bundle size impact and performance implications

2. **React Native & TypeScript Excellence**
   - Type safety improvements or regressions
   - Proper use of TypeScript features (unions, intersections, generics, utility types)
   - Interface design and API contracts
   - Type assertion usage and any `any` types introduced
   - Generic component patterns and reusability
   - React Native performance implications (re-renders, memory leaks)
   - Platform-specific code handling (iOS/Android differences)
   - Navigation changes and deep linking impacts
   - Native module usage and bridge communication

3. **Breedr Styling Standards (react-native-unistyles)**
   - **CRITICAL**: Flag any new StyleSheet.create() usage as requiring conversion to unistyles
   - **Theme consistency**: Proper use of design tokens and theme values
   - **Responsive design**: Appropriate breakpoint usage
   - **Style organization**: Logical grouping and reusable variants
   - **Performance**: Efficient style computation and caching
   - **Migration opportunities**: Recommend converting existing styles to unistyles
   - When existing styles are modified, suggest full migration to unistyles
   - Recommend consolidating duplicate styles into unistyles variants

4. **Architecture & Mobile Patterns**
   - Component composition and hierarchy changes
   - State management patterns (Redux, Zustand, Context, etc.)
   - Custom hook implementation and reusability
   - Error boundaries and error handling strategies
   - Testing approach and coverage changes
   - Accessibility (screen readers, keyboard navigation)
   - Performance on older devices and battery usage implications
   - Network handling and offline capabilities

5. **Security Analysis**
   - Scan for security vulnerabilities
   - Check for exposed secrets or credentials
   - Validate input sanitization
   - Review authentication and authorization
   - Sensitive data handling and storage
   - API communication security
   - Deep link validation
   - Biometric authentication changes
   - Certificate pinning and encryption

6. **Performance & Bundle Analysis**
   - Identify potential performance issues
   - Check for memory leaks or resource waste
   - Review database queries and optimization
   - Assess caching strategies
   - New package additions and their bundle impact
   - Version updates and breaking changes
   - Native dependency changes requiring pod/gradle updates
   - Build configuration modifications

7. **Test Coverage & Quality**
   - Verify test coverage for new code
   - Check test quality and scenarios
   - Validate edge case handling
   - Review test maintainability
   - Mobile-specific testing requirements

8. **Declarative & Functional Programming Style**
  - **Immutable data patterns**: Check for direct state mutations vs immutable updates
  - **Pure functions**: Identify side effects and recommend extraction to pure functions
  - **Declarative React patterns**: Flag imperative DOM manipulation, prefer declarative JSX
  - **Function composition**: Review for opportunities to compose smaller functions
  - **Data transformations**: Ensure use of map/filter/reduce over imperative loops
  - **Conditional rendering**: Verify ternary operators used instead of && for conditional rendering
  - **Hook dependencies**: Check useEffect/useMemo/useCallback dependency arrays for completeness
  - **State structure**: Recommend normalized/flat state structures over nested objects
  - **Event handlers**: Prefer inline arrow functions or useCallback for event handling
  - **Data flow**: Ensure unidirectional data flow patterns are maintained

9. **Documentation Review**
   - Check inline documentation
   - Verify API documentation updates
   - Review changelog entries
   - Assess user-facing documentation

### Validation

- [ ] Code follows React Native and TypeScript best practices
- [ ] **react-native-unistyles** used instead of StyleSheet.create()
- [ ] Security scan passes
- [ ] Performance metrics acceptable for mobile
- [ ] Test coverage meets standards
- [ ] Documentation is complete
- [ ] No breaking changes without justification
- [ ] Error handling is comprehensive
- [ ] Code is maintainable and readable
- [ ] Cross-platform compatibility maintained
- [ ] Accessibility standards met
- [ ] Bundle size impact acceptable
- [ ] Type checking passes (`tsc --noEmit`)
- [ ] Unistyles theme consistency verified
- [ ] Responsive design tested across breakpoints
- [ ] Declarative and functional programming patterns followed
- [ ] Immutable data handling practices implemented
- [ ] Pure functions preferred over impure implementations

### Format Requirements

**CRITICAL: Exact Format Requirements for GitHub Integration**

When listing issues in Critical Issues, Warnings, and Improvements sections, use this EXACT format:

```
- `filename.ext:Line X` - Description of the issue
```

**Format Rules:**
1. Start with `- ` (dash and space)
2. Use backticks around `filename:Line X`
3. Use `:Line X` for single lines or `:Lines X-Y` for ranges
4. Follow with ` - ` (space, dash, space)
5. Then the description
6. NO bold formatting (**) around the backticks
7. NO extra formatting or bullets

**File Extensions to Include:** .tsx, .ts, .jsx, .js, .py, .java, .cpp, .c, .h, .swift, .kt, .rb, .go, .rs, .php, .cs

### Output Format

#### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

#### Detailed Analysis

##### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List blocking issues with specific file:line references]

##### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file:line references]

##### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file:line references]

##### 🎨 **Styling & Unistyles Assessment**
- **Unistyles Compliance**: [Check for proper unistyles usage vs StyleSheet.create()]
- **Style Migration Opportunities**: [List files/lines that should migrate to unistyles]
- **Theme Consistency**: [Verify proper use of design tokens and theme values]
- **Responsive Design**: [Check breakpoint usage and responsive patterns]

##### 📱 **Mobile Impact Assessment**
- **Bundle Size**: [Change in app size]
- **Performance**: [Expected impact on app performance]
- **Compatibility**: [iOS/Android specific considerations]
- **Battery Usage**: [Impact on device battery consumption]
- **Memory Usage**: [Memory footprint changes]

#### 🔄 **Declarative & Functional Programming Assessment**
- **Immutability**: [Check for direct state mutations and recommend immutable patterns]
- **Pure Functions**: [Identify side effects and opportunities for pure function extraction]
- **Declarative Patterns**: [Flag imperative code that could be more declarative]
- **Data Transformations**: [Review usage of map/filter/reduce vs imperative loops]
- **Hook Dependencies**: [Verify complete dependency arrays in useEffect/useMemo/useCallback]
- **State Structure**: [Assess state normalization and flat vs nested structures]

##### 🔧 **Recommendations**
1. [Specific actionable recommendations with file:line references]
2. [Unistyles migration suggestions for modified styles]
3. [Testing suggestions for specific components/functions]
4. [Monitoring and rollback strategies]

##### 📁 **File-by-File Analysis**
For each modified file, provide:

**`src/path/filename.tsx`**
- Line X: [Specific observation]
- Lines X-Y: [Multi-line change analysis]
- Styling: [Unistyles compliance and migration recommendations]
- Overall: [File-level assessment]

#### Testing Checklist
- [ ] Type checking passes (`tsc --noEmit`)
- [ ] Unit tests updated and passing
- [ ] Integration tests cover new functionality
- [ ] Manual testing on both iOS and Android
- [ ] Performance profiling completed if needed
- [ ] Accessibility testing completed
- [ ] Unistyles theme consistency verified
- [ ] Responsive design tested across breakpoints
- [ ] Memory leak testing on older devices
- [ ] Network connectivity edge cases tested
- [ ] Functional programming patterns validated
- [ ] Immutable data handling verified
- [ ] Pure function compliance checked

#### Context Questions Addressed
1. What is the business impact of these changes?
2. Are there any time-sensitive dependencies?
3. What is the rollback strategy if issues arise?
4. Are there any feature flags controlling these changes?
5. Do style changes maintain Breedr's design system consistency?

### Examples

```bash
# Review current branch against staging for Breedr mobile
/breedr-mobile-review

# Output includes:
# ✅ Unistyles Compliance: All styling uses unistyles
# ⚠️ Performance: Component may cause re-renders
# ❌ Critical: Missing TypeScript types in new component
# ✅ Security: Proper input validation added
```

```bash
# Review specific branch or PR with focus areas
/breedr-mobile-review --branch=feature/new-component
/breedr-mobile-review --focus=unistyles,performance,security

# Provides detailed analysis of:
# - react-native-unistyles usage and migration opportunities
# - Mobile performance implications
# - TypeScript type safety
# - Cross-platform compatibility
```

```bash
# Review with styling focus
/breedr-mobile-review --focus=styling

# Emphasizes:
# - StyleSheet.create() to unistyles migration opportunities
# - Theme consistency with design tokens
# - Responsive breakpoint usage
# - Style performance optimization
```

## Breedr Mobile Expertise Areas

### Core Technologies
- React Native architecture patterns and performance optimization
- TypeScript advanced typing, generics, and type safety best practices
- Mobile app security, accessibility, and cross-platform considerations
- Modern React patterns (hooks, context, state management)
- Native module integration and platform-specific code
- CI/CD pipelines and mobile deployment strategies
- **react-native-unistyles** for consistent, performant styling across the app

### Specialized Focus Areas

#### React Native Performance
- Bundle size optimization and code splitting
- Memory management and leak prevention
- Bridge communication efficiency
- Native module performance
- Startup time optimization
- Battery usage minimization

#### TypeScript Excellence
- Advanced type patterns for mobile components
- Generic component interfaces
- Proper typing for React Native APIs
- Platform-specific type definitions
- Type-safe navigation patterns

#### Mobile-Specific Security
- Secure storage implementation
- API communication encryption
- Biometric authentication patterns
- Deep link validation
- Certificate pinning strategies
- Sensitive data handling

#### Cross-Platform Development
- iOS/Android platform differences
- Native dependency management
- Platform-specific UI patterns
- Performance optimization per platform
- Testing strategies for both platforms

**Use this command to perform comprehensive code reviews specifically tailored for the Breedr mobile application, ensuring adherence to react-native-unistyles patterns and mobile development best practices.**

