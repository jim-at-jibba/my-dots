#!/usr/bin/env python3
"""
React Native TypeScript Branch Analysis Tool
Compares staging branch with currently checked out branch using Claude Opus 4 for expert code review
"""

import subprocess
import sys
import os
import argparse
from typing import List, Optional, Dict, Tuple
import anthropic
from pathlib import Path
import re
import tempfile
import json
from dataclasses import dataclass

# Configuration
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY")
DEFAULT_BASE_BRANCH = "staging"  # Default base branch
MODEL = "claude-sonnet-4-20250514"  # Claude Opus 4
# MODEL = "claude-3-opus-latest"  # For testing
# MODEL = "claude-opus-4-20250514"  # Claude Opus 4

# Token limits and chunking settings
MAX_TOKENS = 190000  # Leave some buffer under 200k
CHUNK_OVERLAP = 500  # Lines of overlap between chunks
MIN_CHUNK_SIZE = 1000  # Minimum lines per chunk

# Problem-solving prompt template
PROBLEM_SOLVING_PROMPT = """
Create me a prompt that helps an ai agent work through a problem statement. Use the example as the returned format and the supporting docs attached to give as much information needed. Then create a list of steps to solve the problem.

The Problem: {problem}
Supporting information: {supporting_info}

Return in the following format:

# Problem

# Supporting Information

# Steps to Complete

<example>
## Problem

We want to set up a new MCP server, written in TypeScript. We are starting from an empty directory.

We are writing this in Cursor, so recording the important files in a `.cursor/rules/important-files.mdc` file is important.

We need to set up the basic file system for the project, install necessary dependencies, and set up the project structure.

## Supporting Information

### Tools

#### `pnpm`

Use `pnpm` as the package manager.

### File Structure

Recommended file structure:

#### `.cursor/rules/important-files.mdc`

A file that lists the important files for the project, which should be included in every chat.

Use the `mdc` format, which is a markdown format with these frontmatter fields:

```md
---
globs: **/**
alwaysApply: true
---

...content goes here...
```

Make sure to add a directive at the end of the file that if new files are added, they should be added to the `important-files.mdc` file.

#### `package.json`

The package.json file for the project.

Recommended scripts:

`build`: Builds the project using `tsc`.
`dev`: Runs the project in development mode using `tsx watch src/main.ts`.

Dependencies:

- `@modelcontextprotocol/sdk`: The MCP SDK. Latest version is `0.9.0`.
- `zod`: A schema declaration and validation library for TypeScript.

Dev dependencies:

- `tsx`: A faster version of `ts-node` that is optimized for the CLI.
- `typescript`: The TypeScript compiler, latest version: `5.8`
- `@types/node`: The types for Node.js, for 22+

`bin` should be set to `dist/main.js`.

`type` should be set to `module`.

#### `tsconfig.json`

The TypeScript configuration file for the project. Here is the recommended configuration from Matt Pocock's TSConfig cheat sheet.

```jsonc
{{
  "compilerOptions": {{
    /* Base Options: */
    "esModuleInterop": true,
    "skipLibCheck": true,
    "target": "es2022",
    "allowJs": true,
    "resolveJsonModule": true,
    "moduleDetection": "force",
    "isolatedModules": true,
    "verbatimModuleSyntax": true,

    /* Strictness */
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,

    /* If transpiling with TypeScript: */
    "module": "NodeNext",
    "outDir": "dist",
    "rootDir": "src",
    "sourceMap": true,

    /* AND if you're building for a library: */
    "declaration": true,

    /* If your code doesn't run in the DOM: */
    "lib": ["es2022"]
  }},
  "include": ["src"]
}}
```

#### `src/main.ts`

The entry point for the project.

```ts
import {{
  McpServer,
  ResourceTemplate,
}} from "@modelcontextprotocol/sdk/server/mcp.js";
import {{ StdioServerTransport }} from "@modelcontextprotocol/sdk/server/stdio.js";
import {{ z }} from "zod";

// Create an MCP server
const server = new McpServer({{
  name: "Demo",
  version: "1.0.0",
}});

// Add an addition tool
server.tool("add", {{ a: z.number(), b: z.number() }}, async ({{ a, b }}) => ({{
  content: [{{ type: "text", text: String(a + b) }}],
}}));

// Add a dynamic greeting resource
server.resource(
  "greeting",
  new ResourceTemplate("greeting://{{name}}", {{ list: undefined }}),
  async (uri, {{ name }}) => ({{
    contents: [
      {{
        uri: uri.href,
        text: `Hello, ${{name}}!`,
      }},
    ],
  }})
);

// Start receiving messages on stdin and sending messages on stdout
const transport = new StdioServerTransport();
await server.connect(transport);
```

#### `.gitignore`

A file that lists the files to ignore in the project. `dist` should be ignored since it is the output directory.

## Steps To Complete

- Create the `package.json` file with the recommended scripts and dependencies.
- Use a `pnpm add` command to install the dependencies so that they are pinned to the current version. Do NOT use `latest` or `next`.
- Install the dependencies.
- Create the `tsconfig.json` file with the recommended configuration.
- Create the other files described above.
- Run `pnpm build` to build the project.
</example>
"""

# Available prompts
PROMPTS = {
    "react-native": {
        "name": "React Native/TypeScript",
        "description": "Expert React Native and TypeScript code review",
        "prompt": """
You are a senior React Native and TypeScript engineer with 10+ years of experience building production mobile applications. You have deep expertise in:

- React Native architecture patterns and performance optimization
- TypeScript advanced typing, generics, and type safety best practices
- Mobile app security, accessibility, and cross-platform considerations
- Modern React patterns (hooks, context, state management)
- Native module integration and platform-specific code
- CI/CD pipelines and mobile deployment strategies

## Task
Analyze the code changes between the staging branch and the provided branch. Provide a comprehensive technical review focusing on React Native and TypeScript specific concerns.

## CRITICAL: Exact Format Requirements for GitHub Integration

When listing issues in the Critical Issues, Warnings, and Improvements sections, you MUST use this EXACT format for each line:

**Required Format:**
```
- `filename.ext:Line X` - Description of the issue
```

**Examples:**
```
- `src/components/Button.tsx:Line 23` - Missing null check for props.onPress
- `src/utils/api.ts:Lines 45-48` - Potential memory leak in event listener
- `app/screens/Home.tsx:Line 12` - Consider using useMemo for expensive calculation
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

This format is required for automated GitHub PR comment generation.

## Analysis Framework

### 1. **Code Quality & TypeScript Excellence**
- Type safety improvements or regressions
- Proper use of TypeScript features (unions, intersections, generics, utility types)
- Interface design and API contracts
- Type assertion usage and any `any` types introduced
- Generic component patterns and reusability

### 2. **React Native Specific Concerns**
- Performance implications (re-renders, memory leaks, bundle size)
- Platform-specific code handling (iOS/Android differences)
- Navigation changes and deep linking impacts
- Native module usage and bridge communication
- Metro bundler configuration changes

### 3. **Architecture & Patterns**
- Component composition and hierarchy changes
- State management patterns (Redux, Zustand, Context, etc.)
- Custom hook implementation and reusability
- Error boundaries and error handling strategies
- Testing approach and coverage changes

### 4. **Mobile-Specific Considerations**
- Accessibility (screen readers, keyboard navigation)
- Responsive design and different screen sizes
- Performance on older devices
- Battery usage implications
- Network handling and offline capabilities

### 5. **Security & Best Practices**
- Sensitive data handling and storage
- API communication security
- Deep link validation
- Biometric authentication changes
- Certificate pinning and encryption

### 6. **Dependencies & Infrastructure**
- New package additions and their bundle impact
- Version updates and breaking changes
- Native dependency changes requiring pod/gradle updates
- Build configuration modifications
- Environment-specific configurations

## Output Format

### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

### Detailed Analysis

#### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List any blocking issues with specific file and line references]
- Format: `src/path/file.tsx:Line X - Issue description`

#### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file and line references]
- Format: `src/path/file.tsx:Lines X-Y - Warning description`

#### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file and line references]
- Format: `src/path/file.tsx:Line X - Improvement description`

#### 📱 **Mobile Impact Assessment**
- **Bundle Size**: [Change in app size]
- **Performance**: [Expected impact on app performance]
- **Compatibility**: [iOS/Android specific considerations]

#### 🔧 **Recommendations**
1. [Specific actionable recommendations with file:line references]
2. [Testing suggestions for specific components/functions]
3. [Monitoring and rollback strategies]

#### 📁 **File-by-File Analysis**
For each modified file, provide:
- **Risk assessment** for that file
- **Specific line-by-line comments** for critical changes
- **Testing requirements** for that file

Format:
**`src/path/filename.tsx`**
- Line X: [Specific observation]
- Lines X-Y: [Multi-line change analysis]
- Overall: [File-level assessment]

### Testing Checklist
- [ ] Type checking passes (`tsc --noEmit`)
- [ ] Unit tests updated and passing
- [ ] Integration tests cover new functionality
- [ ] Manual testing on both iOS and Android
- [ ] Performance profiling if needed
- [ ] Accessibility testing completed

## Context Questions to Address
Before analysis, consider:
1. What is the business impact of these changes?
2. Are there any time-sensitive dependencies?
3. What is the rollback strategy if issues arise?
4. Are there any feature flags controlling these changes?

---

Here are the changes between {base_branch} and {target_branch}:

```diff
{git_diff}
```

Please provide a thorough analysis following this framework.
"""
    },
    
    "breedr-mob": {
        "name": "Breedr Mobile (React Native + Unistyles)",
        "description": "Breedr mobile app code review with React Native and react-native-unistyles focus",
        "prompt": """
You are a senior React Native and TypeScript engineer with 10+ years of experience building production mobile applications, with specific expertise in the Breedr mobile application architecture. You have deep expertise in:

- React Native architecture patterns and performance optimization
- TypeScript advanced typing, generics, and type safety best practices
- Mobile app security, accessibility, and cross-platform considerations
- Modern React patterns (hooks, context, state management)
- Native module integration and platform-specific code
- CI/CD pipelines and mobile deployment strategies
- **react-native-unistyles** for consistent, performant styling across the app

## Breedr Mobile Specific Requirements

### Styling with react-native-unistyles
- **ALWAYS use react-native-unistyles** for all styling instead of StyleSheet.create()
- When reviewing style changes, **recommend migrating existing StyleSheet.create() to unistyles**
- Ensure proper use of unistyles themes, breakpoints, and dynamic styling
- Check for consistent spacing, colors, and typography using unistyles tokens
- Verify responsive design using unistyles breakpoint system
- Recommend creating reusable style variants when patterns emerge

### Style Migration Priorities
- Flag any new StyleSheet.create() usage as requiring conversion to unistyles
- When existing styles are modified, suggest full migration to unistyles
- Recommend consolidating duplicate styles into unistyles variants
- Ensure proper TypeScript integration with unistyles

## Task
Analyze the code changes between the staging branch and the provided branch. Provide a comprehensive technical review focusing on React Native, TypeScript, and Breedr-specific styling concerns.

## CRITICAL: Exact Format Requirements for GitHub Integration

When listing issues in the Critical Issues, Warnings, and Improvements sections, you MUST use this EXACT format for each line:

**Required Format:**
```
- `filename.ext:Line X` - Description of the issue
```

**Examples:**
```
- `src/components/Button.tsx:Line 23` - Missing null check for props.onPress
- `src/utils/api.ts:Lines 45-48` - Potential memory leak in event listener
- `app/screens/Home.tsx:Line 12` - Consider using useMemo for expensive calculation
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

This format is required for automated GitHub PR comment generation.

## Analysis Framework

### 1. **Code Quality & TypeScript Excellence**
- Type safety improvements or regressions
- Proper use of TypeScript features (unions, intersections, generics, utility types)
- Interface design and API contracts
- Type assertion usage and any `any` types introduced
- Generic component patterns and reusability

### 2. **React Native Specific Concerns**
- Performance implications (re-renders, memory leaks, bundle size)
- Platform-specific code handling (iOS/Android differences)
- Navigation changes and deep linking impacts
- Native module usage and bridge communication
- Metro bundler configuration changes

### 3. **Breedr Styling Standards (react-native-unistyles)**
- **Unistyles usage compliance** - Flag StyleSheet.create() usage
- **Theme consistency** - Proper use of design tokens and theme values
- **Responsive design** - Appropriate breakpoint usage
- **Style organization** - Logical grouping and reusable variants
- **Performance** - Efficient style computation and caching
- **Migration opportunities** - Recommend converting existing styles to unistyles

### 4. **Architecture & Patterns**
- Component composition and hierarchy changes
- State management patterns (Redux, Zustand, Context, etc.)
- Custom hook implementation and reusability
- Error boundaries and error handling strategies
- Testing approach and coverage changes

### 5. **Mobile-Specific Considerations**
- Accessibility (screen readers, keyboard navigation)
- Responsive design and different screen sizes
- Performance on older devices
- Battery usage implications
- Network handling and offline capabilities

### 6. **Security & Best Practices**
- Sensitive data handling and storage
- API communication security
- Deep link validation
- Biometric authentication changes
- Certificate pinning and encryption

### 7. **Dependencies & Infrastructure**
- New package additions and their bundle impact
- Version updates and breaking changes
- Native dependency changes requiring pod/gradle updates
- Build configuration modifications
- Environment-specific configurations

## Output Format

### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

### Detailed Analysis

#### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List any blocking issues with specific file and line references]
- Format: `src/path/file.tsx:Line X - Issue description`

#### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file and line references]
- Format: `src/path/file.tsx:Lines X-Y - Warning description`

#### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file and line references]
- Format: `src/path/file.tsx:Line X - Improvement description`

#### 🎨 **Styling & Unistyles Assessment**
- **Unistyles Compliance**: [Check for proper unistyles usage vs StyleSheet.create()]
- **Style Migration Opportunities**: [List files/lines that should migrate to unistyles]
- **Theme Consistency**: [Verify proper use of design tokens and theme values]
- **Responsive Design**: [Check breakpoint usage and responsive patterns]

#### 📱 **Mobile Impact Assessment**
- **Bundle Size**: [Change in app size]
- **Performance**: [Expected impact on app performance]
- **Compatibility**: [iOS/Android specific considerations]

#### 🔧 **Recommendations**
1. [Specific actionable recommendations with file:line references]
2. [Unistyles migration suggestions for modified styles]
3. [Testing suggestions for specific components/functions]
4. [Monitoring and rollback strategies]

#### 📁 **File-by-File Analysis**
For each modified file, provide:
- **Risk assessment** for that file
- **Specific line-by-line comments** for critical changes
- **Unistyles compliance check** for any styling changes
- **Testing requirements** for that file

Format:
**`src/path/filename.tsx`**
- Line X: [Specific observation]
- Lines X-Y: [Multi-line change analysis]
- Styling: [Unistyles compliance and migration recommendations]
- Overall: [File-level assessment]

### Testing Checklist
- [ ] Type checking passes (`tsc --noEmit`)
- [ ] Unit tests updated and passing
- [ ] Integration tests cover new functionality
- [ ] Manual testing on both iOS and Android
- [ ] Performance profiling if needed
- [ ] Accessibility testing completed
- [ ] Unistyles theme consistency verified
- [ ] Responsive design tested across breakpoints

## Context Questions to Address
Before analysis, consider:
1. What is the business impact of these changes?
2. Are there any time-sensitive dependencies?
3. What is the rollback strategy if issues arise?
4. Are there any feature flags controlling these changes?
5. Do style changes maintain Breedr's design system consistency?

---

Here are the changes between {base_branch} and {target_branch}:

```diff
{git_diff}
```

Please provide a thorough analysis following this framework, with special attention to react-native-unistyles usage and migration opportunities.
"""
    },
    
    "general": {
        "name": "General Code Review",
        "description": "General purpose code review for any language/framework",
        "prompt": """
You are a senior software engineer with extensive experience in code review and software architecture. 

## Task
Analyze the code changes between the {base_branch} branch and {target_branch} branch. Provide a comprehensive technical review.

## Important: Line-Specific Analysis
When reviewing code changes, ALWAYS reference specific files and line numbers. Use this format:
- **File references**: `src/path/file.ext`
- **Line references**: `Line 23` or `Lines 15-18`
- **Change references**: `@@ -10,7 +10,8 @@` (when referencing diff chunks)

For each issue, improvement, or observation, cite the exact location where it occurs.

## Analysis Framework

### 1. **Code Quality**
- Code clarity and readability
- Proper naming conventions
- Code organization and structure
- Documentation and comments
- Potential bugs or logic errors

### 2. **Performance & Efficiency**
- Algorithm efficiency
- Memory usage patterns
- Database query optimization
- Caching strategies
- Resource management

### 3. **Security Considerations**
- Input validation and sanitization
- Authentication and authorization
- Data exposure risks
- Dependency vulnerabilities
- Configuration security

### 4. **Architecture & Design**
- Design patterns usage
- Separation of concerns
- Code reusability
- Maintainability
- Testing strategies

### 5. **Dependencies & Configuration**
- New dependencies and their impact
- Version updates and breaking changes
- Configuration changes
- Build and deployment considerations

## Output Format

### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

### Detailed Analysis

#### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List any blocking issues with specific file and line references]

#### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file and line references]

#### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file and line references]

#### 🔧 **Recommendations**
1. [Specific actionable recommendations with file:line references]
2. [Testing suggestions]
3. [Monitoring considerations]

#### 📁 **File-by-File Analysis**
For each modified file, provide:
- **Risk assessment** for that file
- **Specific line-by-line comments** for critical changes
- **Testing requirements** for that file

---

Here are the changes between {base_branch} and {target_branch}:

```diff
{git_diff}
```

Please provide a thorough analysis following this framework.
"""
    },
    
    "python": {
        "name": "Python Code Review",
        "description": "Python-focused code review with PEP standards",
        "prompt": """
You are a senior Python developer with expertise in Python best practices, PEP standards, and modern Python development.

## Task
Analyze the Python code changes between {base_branch} and {target_branch}. Focus on Python-specific concerns and best practices.

## Important: Line-Specific Analysis
When reviewing code changes, ALWAYS reference specific files and line numbers. Use this format:
- **File references**: `src/module.py`
- **Line references**: `Line 23` or `Lines 15-18`

For each issue, improvement, or observation, cite the exact location where it occurs.

## Analysis Framework

### 1. **Python Standards & Style**
- PEP 8 compliance (formatting, naming conventions)
- PEP 257 docstring conventions
- Type hints and annotations (PEP 484, 526)
- Import organization and structure
- Code readability and pythonic patterns

### 2. **Code Quality & Safety**
- Exception handling patterns
- Resource management (context managers, file handling)
- Memory efficiency and generator usage
- Potential security vulnerabilities
- Code complexity and maintainability

### 3. **Testing & Documentation**
- Test coverage and quality
- Docstring completeness and accuracy
- Type annotation coverage
- Example usage in docstrings

### 4. **Performance & Efficiency**
- Algorithm efficiency and Big O considerations
- Appropriate data structure usage
- Database queries and ORM usage
- Async/await patterns if applicable
- Memory usage patterns

### 5. **Dependencies & Environment**
- New package dependencies
- Version compatibility
- Requirements.txt or pyproject.toml changes
- Virtual environment considerations

## Output Format

### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

### Detailed Analysis

#### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List any blocking issues with specific file and line references]

#### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file and line references]

#### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file and line references]

#### 🐍 **Python-Specific Recommendations**
- PEP compliance suggestions
- Pythonic pattern improvements
- Performance optimizations
- Testing enhancements

#### 📁 **File-by-File Analysis**
For each modified Python file, provide:
- **PEP compliance check**
- **Type annotation coverage**
- **Specific line-by-line comments**
- **Testing recommendations**

---

Here are the changes between {base_branch} and {target_branch}:

```diff
{git_diff}
```

Please provide a thorough analysis following this framework.
"""
    },
    
    "web": {
        "name": "Web Development (React/JS/TS)",
        "description": "Frontend web development review for React, JavaScript, and TypeScript",
        "prompt": """
You are a senior frontend developer with expertise in modern web development, React, JavaScript, and TypeScript.

## Task
Analyze the web development code changes between {base_branch} and {target_branch}. Focus on frontend best practices, performance, and user experience.

## Important: Line-Specific Analysis
When reviewing code changes, ALWAYS reference specific files and line numbers. Use this format:
- **File references**: `src/components/Button.tsx`
- **Line references**: `Line 23` or `Lines 15-18`

For each issue, improvement, or observation, cite the exact location where it occurs.

## Analysis Framework

### 1. **Code Quality & TypeScript**
- Type safety and TypeScript best practices
- Component design patterns
- Props interface design
- Generic usage and type utilities
- ESLint/Prettier compliance

### 2. **React Best Practices**
- Component composition and reusability
- Hook usage and custom hooks
- State management patterns
- Effect dependencies and cleanup
- Performance optimization (memoization, lazy loading)

### 3. **Performance & User Experience**
- Bundle size impact
- Runtime performance (re-renders, computations)
- Accessibility (WCAG compliance)
- SEO considerations
- Loading states and error boundaries

### 4. **Styling & Design**
- CSS/SCSS organization
- Responsive design patterns
- Design system compliance
- CSS-in-JS patterns (if applicable)
- Animation and transition performance

### 5. **Testing & Quality Assurance**
- Unit test coverage
- Integration test patterns
- E2E test considerations
- Accessibility testing
- Performance testing

## Output Format

### Executive Summary
**Risk Level**: [LOW/MEDIUM/HIGH]
**Deployment Ready**: [YES/NO/WITH_CONDITIONS]
**Key Highlights**: [2-3 bullet points of most important findings]

### Detailed Analysis

#### 🔍 **Critical Issues** (Must Fix Before Merge)
- [List any blocking issues with specific file and line references]

#### ⚠️ **Warnings** (Should Address)
- [List concerns with specific file and line references]

#### ✅ **Improvements** (Positive Changes)
- [Highlight good practices with specific file and line references]

#### 🌐 **Web-Specific Considerations**
- **Bundle Size**: [Impact on load times]
- **Performance**: [Runtime performance impact]
- **Accessibility**: [A11y compliance check]
- **SEO**: [Search engine optimization impact]

#### 🔧 **Recommendations**
1. [Performance optimizations]
2. [Accessibility improvements]
3. [Testing strategies]
4. [Code organization suggestions]

#### 📁 **Component-by-Component Analysis**
For each modified component/file:
- **Reusability assessment**
- **Performance impact**
- **Accessibility compliance**
- **Testing coverage**

---

Here are the changes between {base_branch} and {target_branch}:

```diff
{git_diff}
```

Please provide a thorough analysis following this framework.
"""
    }
}

DEFAULT_PROMPT = "react-native"

# Analysis prompt (legacy - now uses PROMPTS dict)
ANALYSIS_PROMPT = PROMPTS[DEFAULT_PROMPT]["prompt"]

class Colors:
    """Terminal colors for better UX"""
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'

@dataclass
class CodeIssue:
    """Represents a code issue that can be commented on"""
    file_path: str
    line_number: Optional[int]
    issue_type: str  # 'critical', 'warning', 'improvement'
    description: str
    full_context: str

def print_colored(message: str, color: str = Colors.ENDC):
    """Print colored message to terminal"""
    print(f"{color}{message}{Colors.ENDC}")

def run_git_command(command: List[str]) -> tuple[bool, str]:
    """Run git command and return success status and output"""
    try:
        result = subprocess.run(
            command, 
            capture_output=True, 
            text=True, 
            check=True
        )
        return True, result.stdout.strip()
    except subprocess.CalledProcessError as e:
        return False, e.stderr.strip()

def check_git_repo():
    """Verify we're in a git repository"""
    if not Path(".git").exists():
        print_colored("❌ Error: Not in a git repository", Colors.FAIL)
        sys.exit(1)

def get_current_branch(base_branch: str) -> str:
    """Get the currently checked out branch"""
    print_colored("🔍 Getting current branch...", Colors.OKBLUE)
    
    success, output = run_git_command(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    if not success:
        print_colored(f"❌ Error getting current branch: {output}", Colors.FAIL)
        sys.exit(1)
    
    current_branch = output.strip()
    if current_branch == base_branch:
        print_colored(f"⚠️  Currently on {base_branch} branch. Cannot compare with itself.", Colors.WARNING)
        print_colored(f"Please checkout a different branch to compare against {base_branch}.", Colors.OKBLUE)
        sys.exit(1)
    
    return current_branch

def get_git_diff(base_branch: str, target_branch: str, files_only: Optional[List[str]] = None, exclude_files: Optional[List[str]] = None) -> str:
    """Get git diff between branches with enhanced line number context"""
    print_colored(f"📊 Getting diff between '{base_branch}' and '{target_branch}'...", Colors.OKBLUE)
    
    # Build git diff command
    cmd = ["git", "diff", f"{base_branch}...{target_branch}", "--no-merges", "--unified=3"]
    
    # Add file filters if specified
    if files_only:
        cmd.extend(["--"] + files_only)
        print_colored(f"🎯 Analyzing only: {', '.join(files_only)}", Colors.OKCYAN)
    
    success, diff = run_git_command(cmd)
    
    if not success:
        print_colored(f"❌ Error getting diff: {diff}", Colors.FAIL)
        sys.exit(1)
    
    if not diff:
        print_colored("ℹ️  No differences found between branches.", Colors.WARNING)
        return ""
    
    # Apply file exclusions if specified
    if exclude_files:
        diff = filter_excluded_files(diff, exclude_files)
        print_colored(f"🚫 Excluded: {', '.join(exclude_files)}", Colors.OKCYAN)
    
    return diff

def filter_excluded_files(diff: str, exclude_files: List[str]) -> str:
    """Remove excluded files from diff"""
    lines = diff.split('\n')
    filtered_lines = []
    current_file = None
    skip_current_file = False
    
    for line in lines:
        if line.startswith('diff --git'):
            # Check if this file should be excluded
            current_file = line
            skip_current_file = any(excluded in line for excluded in exclude_files)
            
            if not skip_current_file:
                filtered_lines.append(line)
        elif not skip_current_file:
            filtered_lines.append(line)
    
    return '\n'.join(filtered_lines)

def enhance_diff_with_context(diff: str) -> str:
    """Add helpful context about diff format for Claude"""
    context = """
## Git Diff Format Guide
- Lines starting with `---` show the original file path
- Lines starting with `+++` show the new file path  
- Lines starting with `@@` show line number ranges: `@@ -old_start,old_count +new_start,new_count @@`
- Lines starting with `-` are removed lines
- Lines starting with `+` are added lines
- Lines with no prefix are context/unchanged lines

When referencing changes, use the NEW line numbers (from the `+new_start` in the @@ headers).

---

"""
    return context + diff

def analyze_with_claude(diff: str, base_branch: str, target_branch: str, prompt_key: str = DEFAULT_PROMPT, max_file_size: int = 10000, allow_chunking: bool = True) -> str:
    """Send diff to Claude for analysis"""
    if not ANTHROPIC_API_KEY:
        print_colored("❌ Error: ANTHROPIC_API_KEY environment variable not set", Colors.FAIL)
        print_colored("Please set your API key: export ANTHROPIC_API_KEY='your-api-key'", Colors.OKBLUE)
        sys.exit(1)
    
    prompt_info = PROMPTS[prompt_key]
    print_colored(f"🤖 Using '{prompt_info['name']}' prompt...", Colors.OKBLUE)
    
    # Check if diff needs chunking
    estimated_tokens = estimate_token_count(diff)
    print_colored(f"📊 Estimated tokens: {estimated_tokens:,}", Colors.OKBLUE)
    
    if estimated_tokens > MAX_TOKENS:
        if allow_chunking:
            print_colored(f"⚠️  Large diff detected ({estimated_tokens:,} tokens). Chunking analysis...", Colors.WARNING)
            return analyze_large_diff_chunked(diff, base_branch, target_branch, prompt_key, max_file_size)
        else:
            print_colored(f"⚠️  Large diff detected ({estimated_tokens:,} tokens) but chunking disabled. Truncating...", Colors.WARNING)
            # Truncate to fit
            available_chars = (MAX_TOKENS - 5000) * 4  # Reserve tokens and convert to chars
            if len(diff) > available_chars:
                diff = diff[:available_chars] + "\n\n... [TRUNCATED - diff too large]"
    
    print_colored("🤖 Sending to Claude for analysis...", Colors.OKBLUE)
    
    try:
        client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
        
        # Enhance diff with context for better line number understanding
        enhanced_diff = enhance_diff_with_context(diff)
        
        prompt = prompt_info["prompt"].format(
            base_branch=base_branch,
            target_branch=target_branch,
            git_diff=enhanced_diff
        )
        
        response = client.messages.create(
            model=MODEL,
            max_tokens=4000,
            temperature=0.1,
            messages=[{
                "role": "user",
                "content": prompt
            }]
        )
        
        return response.content[0].text
        
    except Exception as e:
        print_colored(f"❌ Error calling Claude API: {str(e)}", Colors.FAIL)
        sys.exit(1)

def analyze_large_diff_chunked(diff: str, base_branch: str, target_branch: str, prompt_key: str, max_file_size: int = 10000) -> str:
    """Analyze large diff by breaking it into chunks"""
    prompt_info = PROMPTS[prompt_key]
    client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
    
    # Get chunks with custom file size limit
    chunks = chunk_diff_intelligently(diff, MAX_TOKENS, max_file_size)
    
    if len(chunks) == 1:
        print_colored("⚠️  Single chunk still too large, attempting analysis with truncation", Colors.WARNING)
        return analyze_with_claude(chunks[0], base_branch, target_branch, prompt_key, max_file_size, allow_chunking=False)
    
    print_colored(f"📦 Analyzing in {len(chunks)} chunks...", Colors.OKBLUE)
    
    chunk_analyses = []
    
    for i, chunk in enumerate(chunks, 1):
        print_colored(f"🔍 Analyzing chunk {i}/{len(chunks)}...", Colors.OKBLUE)
        
        try:
            # Create chunk-specific prompt
            enhanced_chunk = enhance_diff_with_context(chunk)
            chunk_prompt = create_chunk_prompt(prompt_info, base_branch, target_branch, enhanced_chunk, i, len(chunks))
            
            response = client.messages.create(
                model=MODEL,
                max_tokens=3000,  # Slightly less for chunks
                temperature=0.1,
                messages=[{
                    "role": "user",
                    "content": chunk_prompt
                }]
            )
            
            chunk_analyses.append({
                'chunk_number': i,
                'analysis': response.content[0].text
            })
            
        except Exception as e:
            print_colored(f"❌ Error analyzing chunk {i}: {str(e)}", Colors.FAIL)
            chunk_analyses.append({
                'chunk_number': i,
                'analysis': f"Error analyzing this chunk: {str(e)}"
            })
    
    # Merge analyses
    return merge_chunk_analyses(chunk_analyses, base_branch, target_branch)

def create_chunk_prompt(prompt_info: dict, base_branch: str, target_branch: str, chunk_diff: str, chunk_num: int, total_chunks: int) -> str:
    """Create a chunk-specific prompt"""
    chunk_context = f"""
## CHUNK ANALYSIS ({chunk_num} of {total_chunks})

This is part {chunk_num} of {total_chunks} of a large code review. Focus on analyzing this specific subset of changes.

IMPORTANT: 
- This is a partial analysis - only comment on the code changes present in this chunk
- Use file:line references specific to the changes shown
- Be concise but thorough for the changes present
- Note if any changes appear to be dependent on code not shown in this chunk

"""
    
    # Use a simplified version of the main prompt for chunks
    simplified_prompt = f"""
You are a senior software engineer reviewing code changes.

## Task
Analyze the code changes in this chunk between {base_branch} and {target_branch}.

## Output Format (Simplified for Chunk)

### Chunk {chunk_num} Analysis

#### 🔍 **Critical Issues** (This Chunk)
- [List critical issues with file:line references]

#### ⚠️ **Warnings** (This Chunk)  
- [List warnings with file:line references]

#### ✅ **Improvements** (This Chunk)
- [List positive changes with file:line references]

#### 📁 **Files in This Chunk**
- [Brief analysis of each file changed in this chunk]

---

{chunk_context}

Here are the changes in this chunk:

```diff
{chunk_diff}
```

Provide analysis for this chunk only.
"""
    
    return simplified_prompt

def merge_chunk_analyses(chunk_analyses: List[Dict], base_branch: str, target_branch: str) -> str:
    """Merge multiple chunk analyses into a single comprehensive report"""
    
    merged_report = f"""# Comprehensive Code Review: {target_branch} vs {base_branch}

## Executive Summary
**Analysis Method**: Large diff analyzed in {len(chunk_analyses)} chunks
**Risk Level**: [Determined from individual chunk analyses]
**Deployment Ready**: [Review individual chunk findings]

## Chunk-by-Chunk Analysis

"""
    
    # Add each chunk analysis
    for chunk_data in chunk_analyses:
        merged_report += f"""
### Chunk {chunk_data['chunk_number']} Analysis

{chunk_data['analysis']}

---

"""
    
    # Add combined summary
    merged_report += """
## Combined Summary

⚠️  **Large PR Notice**: This analysis was performed on a large diff split into multiple chunks. 
Please review each chunk section above for complete coverage.

### Recommended Next Steps:
1. Review each chunk analysis individually
2. Focus on critical issues identified across all chunks
3. Consider breaking this large PR into smaller, focused PRs for easier review
4. Ensure integration testing covers interactions between components changed in different chunks

### For Future PRs:
- Consider smaller, more focused changes
- Break large features into multiple PRs
- Use feature flags for incremental rollouts
"""
    
    return merged_report

def sanitize_filename(name: str) -> str:
    """Sanitize branch name for use in filename"""
    # Replace invalid filename characters with underscores
    invalid_chars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|']
    sanitized = name
    for char in invalid_chars:
        sanitized = sanitized.replace(char, '_')
    return sanitized

def extract_problems_from_analysis(analysis: str, base_branch: str, target_branch: str) -> str:
    """Extract key problems and issues from the code review analysis to create a problem statement"""
    
    # Extract the critical issues and warnings sections
    lines = analysis.split('\n')
    critical_issues = []
    warnings = []
    
    in_critical = False
    in_warnings = False
    
    for line in lines:
        if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
            in_critical = True
            in_warnings = False
            continue
        elif '⚠️ **Warnings**' in line or 'Warnings' in line:
            in_critical = False
            in_warnings = True
            continue
        elif line.startswith('####') or line.startswith('###'):
            in_critical = False
            in_warnings = False
            continue
            
        if in_critical and line.strip() and not line.startswith('#'):
            critical_issues.append(line.strip())
        elif in_warnings and line.strip() and not line.startswith('#'):
            warnings.append(line.strip())
    
    # Create problem statement
    problem_parts = []
    
    if critical_issues:
        problem_parts.append("Critical issues identified in code review that must be resolved before merging:")
        problem_parts.extend([f"- {issue}" for issue in critical_issues[:5]])  # Limit to top 5
        
    if warnings:
        problem_parts.append("\nAdditional warnings that should be addressed:")
        problem_parts.extend([f"- {warning}" for warning in warnings[:5]])  # Limit to top 5
    
    if not problem_parts:
        problem_parts.append(f"Code review completed for changes between {base_branch} and {target_branch}. Need to implement recommended improvements and ensure code quality standards are met.")
    
    return "\n".join(problem_parts)

def generate_problem_solving_steps(analysis: str, base_branch: str, target_branch: str) -> str:
    """Generate problem-solving steps based on the code review analysis"""
    if not ANTHROPIC_API_KEY:
        print_colored("❌ Error: ANTHROPIC_API_KEY environment variable not set", Colors.FAIL)
        sys.exit(1)
    
    print_colored("🔧 Generating problem-solving steps...", Colors.OKBLUE)
    
    try:
        client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
        
        # Extract problem statement from analysis
        problem = extract_problems_from_analysis(analysis, base_branch, target_branch)
        
        # Use the full analysis as supporting information
        supporting_info = f"""
## Code Review Analysis Results

The following is a complete code review analysis comparing {target_branch} branch against {base_branch} branch:

{analysis}

## Branch Context
- **Base Branch**: {base_branch}
- **Target Branch**: {target_branch}
- **Review Type**: AI-powered code review using Claude Opus 4

## Key Areas to Address
Focus on resolving critical issues first, then warnings, and finally implementing recommended improvements.
"""
        
        prompt = PROBLEM_SOLVING_PROMPT.format(
            problem=problem,
            supporting_info=supporting_info
        )
        
        response = client.messages.create(
            model=MODEL,
            max_tokens=4000,
            temperature=0.1,
            messages=[{
                "role": "user",
                "content": prompt
            }]
        )
        
        return response.content[0].text
        
    except Exception as e:
        print_colored(f"❌ Error generating problem-solving steps: {str(e)}", Colors.FAIL)
        sys.exit(1)

def save_analysis(analysis: str, base_branch: str, target_branch: str, steps: Optional[str] = None):
    """Save analysis to file in analysis folder"""
    # Create analysis directory if it doesn't exist
    analysis_dir = Path("analysis")
    analysis_dir.mkdir(exist_ok=True)
    
    # Sanitize branch names for filename
    safe_target = sanitize_filename(target_branch)
    safe_base = sanitize_filename(base_branch)
    
    filename = f"analysis_{safe_target}_vs_{safe_base}.md"
    filepath = analysis_dir / filename
    
    try:
        with open(filepath, 'w') as f:
            f.write(f"# Branch Analysis: {target_branch} vs {base_branch}\n\n")
            f.write(analysis)
            
            # Add problem-solving steps if provided
            if steps:
                f.write(f"\n\n---\n\n# Problem-Solving Steps\n\n")
                f.write(steps)
                
        print_colored(f"💾 Analysis saved to: {filepath}", Colors.OKGREEN)
        
        # Also save steps to a separate file if provided
        if steps:
            steps_filename = f"steps_{safe_target}_vs_{safe_base}.md"
            steps_filepath = analysis_dir / steps_filename
            with open(steps_filepath, 'w') as f:
                f.write(f"# Problem-Solving Steps: {target_branch} vs {base_branch}\n\n")
                f.write(steps)
            print_colored(f"📋 Steps saved to: {steps_filepath}", Colors.OKGREEN)
            
    except Exception as e:
        print_colored(f"⚠️  Could not save to file: {str(e)}", Colors.WARNING)

def list_prompts():
    """Display available prompts"""
    print_colored("📝 Available Prompts:", Colors.HEADER)
    print_colored("-" * 40, Colors.HEADER)
    
    for key, prompt_info in PROMPTS.items():
        status = " (default)" if key == DEFAULT_PROMPT else ""
        print_colored(f"  {key:<15} - {prompt_info['name']}{status}", Colors.OKCYAN)
        print_colored(f"                  {prompt_info['description']}", Colors.OKBLUE)
        print()

def check_gh_cli() -> bool:
    """Check if GitHub CLI is installed and authenticated"""
    try:
        # Check if gh is installed
        result = subprocess.run(["gh", "--version"], capture_output=True, text=True, check=True)
        
        # Check if authenticated
        result = subprocess.run(["gh", "auth", "status"], capture_output=True, text=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def get_pr_number(base_branch: str, target_branch: str) -> Optional[str]:
    """Get PR number for the current branch"""
    try:
        # Try to find PR for current branch
        result = subprocess.run([
            "gh", "pr", "list", 
            "--head", target_branch,
            "--base", base_branch,
            "--json", "number",
            "--limit", "1"
        ], capture_output=True, text=True, check=True)
        
        prs = json.loads(result.stdout)
        if prs:
            return str(prs[0]["number"])
        return None
    except (subprocess.CalledProcessError, json.JSONDecodeError):
        return None

def parse_issues_from_analysis(analysis: str) -> List[CodeIssue]:
    """Parse code issues from the analysis text with multiple pattern support"""
    issues = []
    lines = analysis.split('\n')
    
    current_section = None
    issue_type = None
    
    # Multiple regex patterns to handle different formats
    patterns = [
        # Primary pattern: - `file.ext:Line X` - description
        r'^\s*[-*]\s*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\s*[-–—]\s*(.+)$',
        
        # Pattern with bold formatting: - **`file.ext:Line X`** - description  
        r'^\s*[-*]\s*\*\*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\*\*\s*[-–—]\s*(.+)$',
        
        # Pattern without bullet: `file.ext:Line X` - description
        r'^\s*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\s*[-–—]\s*(.+)$',
        
        # Pattern with Format prefix: Format: `file.ext:Line X - description`
        r'^\s*(?:Format:\s*)?`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))\s*[-–—]\s*([^`]+)`$'
    ]
    
    for line in lines:
        line = line.strip()
        
        # Detect section headers
        if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
            current_section = 'critical'
            issue_type = 'critical'
            continue
        elif '⚠️ **Warnings**' in line or 'Warnings' in line:
            current_section = 'warnings'
            issue_type = 'warning'
            continue
        elif '✅ **Improvements**' in line or 'Improvements' in line:
            current_section = 'improvements'
            issue_type = 'improvement'
            continue
        elif line.startswith('####') or line.startswith('###'):
            current_section = None
            continue
        
        # Parse issue lines
        if current_section and line and not line.startswith('#'):
            # Try each pattern until one matches
            for pattern in patterns:
                file_line_match = re.search(pattern, line)
                if file_line_match:
                    groups = file_line_match.groups()
                    file_path = groups[0]
                    line_num = groups[1] or groups[2]  # Single line or start of range
                    description = groups[4].strip() if len(groups) > 4 and groups[4] else "No description"
                    
                    if line_num:
                        line_num = int(line_num)
                    
                    issues.append(CodeIssue(
                        file_path=file_path,
                        line_number=line_num,
                        issue_type=issue_type,
                        description=description,
                        full_context=line
                    ))
                    break  # Stop trying patterns once we find a match
    
    return issues

def interactive_comment_selection(issues: List[CodeIssue]) -> List[CodeIssue]:
    """Interactive selection of issues to comment on"""
    if not issues:
        print_colored("No issues found to comment on.", Colors.WARNING)
        return []
    
    print_colored("\n🔍 Found Issues for GitHub Comments:", Colors.HEADER)
    print_colored("=" * 50, Colors.HEADER)
    
    selected_issues = []
    
    for i, issue in enumerate(issues, 1):
        # Display issue
        color = Colors.FAIL if issue.issue_type == 'critical' else Colors.WARNING if issue.issue_type == 'warning' else Colors.OKGREEN
        type_emoji = "🔍" if issue.issue_type == 'critical' else "⚠️" if issue.issue_type == 'warning' else "✅"
        
        print_colored(f"\n{type_emoji} Issue {i}/{len(issues)} ({issue.issue_type.upper()})", color)
        print_colored(f"File: {issue.file_path}", Colors.OKCYAN)
        if issue.line_number:
            print_colored(f"Line: {issue.line_number}", Colors.OKCYAN)
        print_colored(f"Description: {issue.description}", Colors.OKBLUE)
        
        # Ask user
        while True:
            choice = input(f"\nComment on this issue? [y/n/q/s]: ").lower().strip()
            if choice in ['y', 'yes']:
                selected_issues.append(issue)
                print_colored("✅ Added to comment list", Colors.OKGREEN)
                break
            elif choice in ['n', 'no']:
                print_colored("⏭️  Skipped", Colors.WARNING)
                break
            elif choice in ['q', 'quit']:
                print_colored("🛑 Stopping selection process", Colors.WARNING)
                return selected_issues
            elif choice in ['s', 'show']:
                print_colored(f"Full context: {issue.full_context}", Colors.OKBLUE)
            else:
                print_colored("Please enter 'y' (yes), 'n' (no), 'q' (quit), or 's' (show full context)", Colors.WARNING)
    
    return selected_issues

def create_pr_comments(issues: List[CodeIssue], pr_number: str, target_branch: str) -> bool:
    """Create PR comments for selected issues"""
    if not issues:
        return True
    
    print_colored(f"\n💬 Creating {len(issues)} PR comments...", Colors.OKBLUE)
    
    success_count = 0
    
    for i, issue in enumerate(issues, 1):
        try:
            # Format comment body
            comment_body = f"{issue.description}\n\n"
            
            # Create comment command
            cmd = ["gh", "pr", "comment", pr_number, "--body", comment_body]
            
            # Add file/line specific comment if we have line number
            if issue.line_number and issue.file_path:
                # Get the commit SHA for the current branch
                success, commit_sha = run_git_command(["git", "rev-parse", target_branch])
                if success:
                    # Use gh pr comment with file/line targeting
                    result = subprocess.run([
                        "gh", "api", f"repos/:owner/:repo/pulls/{pr_number}/comments",
                        "--method", "POST",
                        "--field", f"body={comment_body}",
                        "--field", f"commit_id={commit_sha.strip()}",
                        "--field", f"path={issue.file_path}",
                        "--field", f"line={issue.line_number}",
                        "--field", "side=RIGHT"
                    ], capture_output=True, text=True)
                    
                    if result.returncode == 0:
                        print_colored(f"✅ Comment {i}/{len(issues)}: {issue.file_path}:{issue.line_number}", Colors.OKGREEN)
                        success_count += 1
                    else:
                        # Fallback to general comment
                        result = subprocess.run(["gh", "pr", "comment", pr_number, "--body", comment_body], 
                                              capture_output=True, text=True)
                        if result.returncode == 0:
                            print_colored(f"✅ Comment {i}/{len(issues)}: {issue.file_path} (general)", Colors.OKGREEN)
                            success_count += 1
                        else:
                            print_colored(f"❌ Failed to comment on {issue.file_path}: {result.stderr}", Colors.FAIL)
                else:
                    # Fallback to general comment
                    result = subprocess.run(["gh", "pr", "comment", pr_number, "--body", comment_body], 
                                          capture_output=True, text=True)
                    if result.returncode == 0:
                        print_colored(f"✅ Comment {i}/{len(issues)}: {issue.file_path} (general)", Colors.OKGREEN)
                        success_count += 1
                    else:
                        print_colored(f"❌ Failed to comment on {issue.file_path}: {result.stderr}", Colors.FAIL)
            else:
                # General PR comment
                result = subprocess.run(["gh", "pr", "comment", pr_number, "--body", comment_body], 
                                      capture_output=True, text=True)
                if result.returncode == 0:
                    print_colored(f"✅ Comment {i}/{len(issues)}: General comment", Colors.OKGREEN)
                    success_count += 1
                else:
                    print_colored(f"❌ Failed to create general comment: {result.stderr}", Colors.FAIL)
                    
        except Exception as e:
            print_colored(f"❌ Error creating comment for {issue.file_path}: {str(e)}", Colors.FAIL)
    
    print_colored(f"\n📊 Successfully created {success_count}/{len(issues)} comments", 
                  Colors.OKGREEN if success_count == len(issues) else Colors.WARNING)
    
    return success_count > 0

def handle_github_comments(analysis: str, base_branch: str, target_branch: str) -> bool:
    """Handle the complete GitHub commenting workflow"""
    print_colored("\n🐙 GitHub CLI Integration", Colors.HEADER)
    print_colored("-" * 30, Colors.HEADER)
    
    # Check GitHub CLI
    if not check_gh_cli():
        print_colored("❌ GitHub CLI not found or not authenticated", Colors.FAIL)
        print_colored("Please install and authenticate with: gh auth login", Colors.OKBLUE)
        return False
    
    print_colored("✅ GitHub CLI authenticated", Colors.OKGREEN)
    
    # Get PR number
    pr_number = get_pr_number(base_branch, target_branch)
    if not pr_number:
        print_colored(f"❌ No PR found for {target_branch} -> {base_branch}", Colors.FAIL)
        print_colored("Please create a PR first or ensure you're on the correct branch", Colors.OKBLUE)
        return False
    
    print_colored(f"✅ Found PR #{pr_number}", Colors.OKGREEN)
    
    # Parse issues from analysis
    issues = parse_issues_from_analysis(analysis)
    if not issues:
        print_colored("ℹ️  No commentable issues found in analysis", Colors.WARNING)
        print_colored("💡 Tip: Issues must be in 'Critical Issues', 'Warnings', or 'Improvements' sections", Colors.OKBLUE)
        print_colored("💡 Format: - `filename.ext:Line X` - Description", Colors.OKBLUE)
        
        # Debug: Show what sections were found
        lines = analysis.split('\n')
        sections_found = []
        for line in lines:
            line = line.strip()
            if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
                sections_found.append('Critical Issues')
            elif '⚠️ **Warnings**' in line or 'Warnings' in line:
                sections_found.append('Warnings')
            elif '✅ **Improvements**' in line or 'Improvements' in line:
                sections_found.append('Improvements')
        
        if sections_found:
            print_colored(f"📋 Found sections: {', '.join(sections_found)}", Colors.OKCYAN)
        else:
            print_colored("❌ No recognized sections found in analysis", Colors.WARNING)
        
        return True
    
    print_colored(f"🔍 Found {len(issues)} potential issues to comment on", Colors.OKCYAN)
    
    # Interactive selection
    selected_issues = interactive_comment_selection(issues)
    if not selected_issues:
        print_colored("ℹ️  No issues selected for commenting", Colors.WARNING)
        return True
    
    # Create comments
    return create_pr_comments(selected_issues, pr_number, target_branch)

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="AI-Powered Code Review Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                              # Compare current branch with staging using React Native prompt
  %(prog)s -b main                     # Compare current branch with main
  %(prog)s -p python                   # Use Python-specific prompt
  %(prog)s -b develop -p general       # Compare with develop using general prompt
  %(prog)s --list-prompts              # Show available prompts
  %(prog)s --generate-steps            # Generate problem-solving steps after code review analysis
  %(prog)s -b main -p react-native --generate-steps  # Full analysis with steps
  %(prog)s --github-comments           # Interactive GitHub PR commenting
  %(prog)s --github-comments --generate-steps  # Full workflow with GitHub integration
  
Large PR Handling:
  %(prog)s --max-file-size 5000        # Skip files larger than 5000 lines
  %(prog)s --no-chunking               # Disable chunking (may fail on large PRs)
  %(prog)s --files-only src/components/ src/utils/  # Only analyze specific files
  %(prog)s --exclude-files package-lock.json yarn.lock  # Exclude specific files
  %(prog)s --files-only src/auth/ --max-file-size 3000  # Combined filtering
        """
    )
    
    parser.add_argument(
        "-b", "--base",
        default=DEFAULT_BASE_BRANCH,
        help=f"Base branch to compare against (default: {DEFAULT_BASE_BRANCH})"
    )
    
    parser.add_argument(
        "-p", "--prompt",
        default=DEFAULT_PROMPT,
        choices=list(PROMPTS.keys()),
        help=f"Analysis prompt to use (default: {DEFAULT_PROMPT}). Choose from: {', '.join(PROMPTS.keys())}"
    )
    
    parser.add_argument(
        "--list-prompts",
        action="store_true",
        help="List available prompts and exit"
    )
    
    parser.add_argument(
        "--generate-steps",
        action="store_true",
        help="Generate problem-solving steps after code review analysis"
    )
    
    parser.add_argument(
        "--github-comments",
        action="store_true",
        help="Interactively create GitHub PR comments for found issues (requires gh CLI)"
    )
    
    parser.add_argument(
        "--max-file-size",
        type=int,
        default=10000,
        help="Maximum lines per file to include in analysis (default: 10000)"
    )
    
    parser.add_argument(
        "--no-chunking",
        action="store_true",
        help="Disable chunking for large diffs (may fail with token limit error)"
    )
    
    parser.add_argument(
        "--files-only",
        nargs="+",
        help="Only analyze specific files (space-separated list of file paths)"
    )
    
    parser.add_argument(
        "--exclude-files",
        nargs="+",
        help="Exclude specific files from analysis (space-separated list of file paths)"
    )
    
    return parser.parse_args()

def estimate_token_count(text: str) -> int:
    """Rough estimation of token count (approximately 4 characters per token)"""
    return len(text) // 4

def filter_large_files(diff: str, max_file_size: int = 10000) -> Tuple[str, List[str]]:
    """Filter out extremely large file changes from diff"""
    lines = diff.split('\n')
    filtered_lines = []
    current_file = None
    current_file_lines = []
    skipped_files = []
    
    for line in lines:
        if line.startswith('diff --git'):
            # Process previous file
            if current_file and len(current_file_lines) > max_file_size:
                skipped_files.append(current_file)
                # Add a summary instead
                filtered_lines.append(f"diff --git {current_file}")
                filtered_lines.append(f"# LARGE FILE SKIPPED: {len(current_file_lines)} lines")
                filtered_lines.append(f"# File too large for analysis - review manually")
            elif current_file:
                filtered_lines.extend(current_file_lines)
            
            # Start new file
            current_file = line.split(' ')[-1] if ' ' in line else line
            current_file_lines = [line]
        else:
            current_file_lines.append(line)
    
    # Process last file
    if current_file and len(current_file_lines) > max_file_size:
        skipped_files.append(current_file)
        filtered_lines.append(f"diff --git {current_file}")
        filtered_lines.append(f"# LARGE FILE SKIPPED: {len(current_file_lines)} lines")
    elif current_file:
        filtered_lines.extend(current_file_lines)
    
    return '\n'.join(filtered_lines), skipped_files

def split_diff_by_files(diff: str) -> List[Dict[str, str]]:
    """Split diff into individual file chunks"""
    files = []
    lines = diff.split('\n')
    current_file = None
    current_content = []
    
    for line in lines:
        if line.startswith('diff --git'):
            # Save previous file
            if current_file:
                files.append({
                    'file': current_file,
                    'content': '\n'.join(current_content),
                    'line_count': len(current_content)
                })
            
            # Start new file
            current_file = line.split(' ')[-1] if ' ' in line else "unknown"
            current_content = [line]
        else:
            current_content.append(line)
    
    # Add last file
    if current_file:
        files.append({
            'file': current_file,
            'content': '\n'.join(current_content),
            'line_count': len(current_content)
        })
    
    return files

def chunk_diff_intelligently(diff: str, max_tokens: int = MAX_TOKENS, max_file_size: int = 10000) -> List[str]:
    """Split diff into chunks that fit within token limits"""
    # First, try filtering large files
    filtered_diff, skipped_files = filter_large_files(diff, max_file_size)
    
    if skipped_files:
        print_colored(f"⚠️  Skipped {len(skipped_files)} large files: {', '.join(skipped_files[:3])}{'...' if len(skipped_files) > 3 else ''}", Colors.WARNING)
    
    # Check if filtered diff fits
    if estimate_token_count(filtered_diff) <= max_tokens:
        return [filtered_diff]
    
    # Split by files and group into chunks
    file_chunks = split_diff_by_files(filtered_diff)
    chunks = []
    current_chunk = ""
    current_chunk_tokens = 0
    
    # Reserve tokens for prompt template
    available_tokens = max_tokens - 5000  # Reserve for prompt overhead
    
    for file_data in file_chunks:
        file_content = file_data['content']
        file_tokens = estimate_token_count(file_content)
        
        # If single file is too large, skip it
        if file_tokens > available_tokens * 0.8:
            print_colored(f"⚠️  Skipping large file: {file_data['file']} ({file_tokens} tokens)", Colors.WARNING)
            continue
        
        # If adding this file would exceed limit, start new chunk
        if current_chunk_tokens + file_tokens > available_tokens and current_chunk:
            chunks.append(current_chunk)
            current_chunk = file_content
            current_chunk_tokens = file_tokens
        else:
            current_chunk += "\n\n" + file_content if current_chunk else file_content
            current_chunk_tokens += file_tokens
    
    # Add final chunk
    if current_chunk:
        chunks.append(current_chunk)
    
    return chunks if chunks else [filtered_diff[:available_tokens * 4]]  # Fallback

def main():
    """Main script execution"""
    # Parse arguments
    args = parse_arguments()
    
    # Handle list prompts option
    if args.list_prompts:
        list_prompts()
        sys.exit(0)
    
    base_branch = args.base
    prompt_key = args.prompt
    generate_steps = args.generate_steps
    github_comments = args.github_comments
    
    print_colored("🚀 AI-Powered Code Review Tool", Colors.HEADER)
    print_colored("=" * 50, Colors.HEADER)
    
    # Show selected prompt info
    prompt_info = PROMPTS[prompt_key]
    print_colored(f"📝 Using prompt: {prompt_info['name']}", Colors.OKCYAN)
    print_colored(f"   {prompt_info['description']}", Colors.OKBLUE)
    
    # Show configuration for large PR handling
    if args.max_file_size != 10000:
        print_colored(f"📏 Max file size: {args.max_file_size} lines", Colors.OKCYAN)
    if args.no_chunking:
        print_colored(f"⚠️  Chunking disabled - large PRs may fail", Colors.WARNING)
    if args.files_only:
        print_colored(f"🎯 Analyzing only: {', '.join(args.files_only)}", Colors.OKCYAN)
    if args.exclude_files:
        print_colored(f"🚫 Excluding: {', '.join(args.exclude_files)}", Colors.OKCYAN)
    
    if generate_steps:
        print_colored("🔧 Problem-solving steps will be generated after analysis", Colors.OKCYAN)
    if github_comments:
        print_colored("🐙 GitHub PR comments will be created interactively", Colors.OKCYAN)
    
    # Verify git repository
    check_git_repo()
    
    # Get current branch
    current_branch = get_current_branch(base_branch)
    print_colored(f"📍 Current branch: {current_branch}", Colors.OKCYAN)
    print_colored(f"🎯 Comparing against: {base_branch}", Colors.OKCYAN)
    
    # Get diff
    diff = get_git_diff(base_branch, current_branch, args.files_only, args.exclude_files)
    if not diff:
        print_colored("✅ No changes to analyze!", Colors.OKGREEN)
        sys.exit(0)
    
    print_colored(f"📏 Diff size: {len(diff.splitlines())} lines", Colors.OKBLUE)
    
    # Count files changed for better context
    files_changed = len([line for line in diff.split('\n') if line.startswith('diff --git')])
    print_colored(f"📁 Files changed: {files_changed}", Colors.OKBLUE)
    
    # Analyze with Claude
    analysis = analyze_with_claude(diff, base_branch, current_branch, prompt_key, args.max_file_size, not args.no_chunking)
    
    # Generate problem-solving steps if requested
    steps = None
    if generate_steps:
        steps = generate_problem_solving_steps(analysis, base_branch, current_branch)
    
    # Display results
    print_colored("\n" + "=" * 80, Colors.HEADER)
    print_colored("📋 ANALYSIS RESULTS", Colors.HEADER)
    print_colored("=" * 80, Colors.HEADER)
    print(analysis)
    
    # Display steps if generated
    if steps:
        print_colored("\n" + "=" * 80, Colors.HEADER)
        print_colored("🔧 PROBLEM-SOLVING STEPS", Colors.HEADER)
        print_colored("=" * 80, Colors.HEADER)
        print(steps)
    
    # Handle GitHub comments if requested
    if github_comments:
        success = handle_github_comments(analysis, base_branch, current_branch)
        if not success:
            print_colored("⚠️  GitHub commenting encountered issues", Colors.WARNING)
    
    # Save to file
    save_analysis(analysis, base_branch, current_branch, steps)
    
    print_colored("\n✅ Analysis complete!", Colors.OKGREEN)
    if generate_steps:
        print_colored("✅ Problem-solving steps generated!", Colors.OKGREEN)
    if github_comments:
        print_colored("✅ GitHub integration completed!", Colors.OKGREEN)

if __name__ == "__main__":
    main()
