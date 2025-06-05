#!/usr/bin/env python3
"""
React Native TypeScript Branch Analysis Tool
Compares staging branch with currently checked out branch using Claude Opus 4 for expert code review
"""

import subprocess
import sys
import os
import argparse
from typing import List, Optional
import anthropic
from pathlib import Path

# Configuration
ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY")
DEFAULT_BASE_BRANCH = "staging"  # Default base branch
MODEL = "claude-sonnet-4-20250514"  # Claude Opus 4

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

## Important: Line-Specific Analysis
When reviewing code changes, ALWAYS reference specific files and line numbers. Use this format:
- **File references**: `src/components/Button.tsx`
- **Line references**: `Line 23` or `Lines 15-18`
- **Change references**: `@@ -10,7 +10,8 @@` (when referencing diff chunks)

For each issue, improvement, or observation, cite the exact location where it occurs.

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

def get_git_diff(base_branch: str, target_branch: str) -> str:
    """Get git diff between branches with enhanced line number context"""
    print_colored(f"📊 Getting diff between '{base_branch}' and '{target_branch}'...", Colors.OKBLUE)
    
    success, diff = run_git_command([
        "git", "diff", 
        f"{base_branch}...{target_branch}",
        "--no-merges",
        "--unified=3"  # Show 3 lines of context around changes
    ])
    
    if not success:
        print_colored(f"❌ Error getting diff: {diff}", Colors.FAIL)
        sys.exit(1)
    
    if not diff:
        print_colored("ℹ️  No differences found between branches.", Colors.WARNING)
        return ""
    
    return diff

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

def analyze_with_claude(diff: str, base_branch: str, target_branch: str, prompt_key: str = DEFAULT_PROMPT) -> str:
    """Send diff to Claude for analysis"""
    if not ANTHROPIC_API_KEY:
        print_colored("❌ Error: ANTHROPIC_API_KEY environment variable not set", Colors.FAIL)
        print_colored("Please set your API key: export ANTHROPIC_API_KEY='your-api-key'", Colors.OKBLUE)
        sys.exit(1)
    
    prompt_info = PROMPTS[prompt_key]
    print_colored(f"🤖 Using '{prompt_info['name']}' prompt...", Colors.OKBLUE)
    print_colored("🤖 Sending to Claude Opus 4 for analysis...", Colors.OKBLUE)
    
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

def sanitize_filename(name: str) -> str:
    """Sanitize branch name for use in filename"""
    # Replace invalid filename characters with underscores
    invalid_chars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|']
    sanitized = name
    for char in invalid_chars:
        sanitized = sanitized.replace(char, '_')
    return sanitized

def save_analysis(analysis: str, base_branch: str, target_branch: str):
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
        print_colored(f"💾 Analysis saved to: {filepath}", Colors.OKGREEN)
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
    
    return parser.parse_args()

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
    
    print_colored("🚀 AI-Powered Code Review Tool", Colors.HEADER)
    print_colored("=" * 50, Colors.HEADER)
    
    # Show selected prompt info
    prompt_info = PROMPTS[prompt_key]
    print_colored(f"📝 Using prompt: {prompt_info['name']}", Colors.OKCYAN)
    print_colored(f"   {prompt_info['description']}", Colors.OKBLUE)
    
    # Verify git repository
    check_git_repo()
    
    # Get current branch
    current_branch = get_current_branch(base_branch)
    print_colored(f"📍 Current branch: {current_branch}", Colors.OKCYAN)
    print_colored(f"🎯 Comparing against: {base_branch}", Colors.OKCYAN)
    
    # Get diff
    diff = get_git_diff(base_branch, current_branch)
    if not diff:
        print_colored("✅ No changes to analyze!", Colors.OKGREEN)
        sys.exit(0)
    
    print_colored(f"📏 Diff size: {len(diff.splitlines())} lines", Colors.OKBLUE)
    
    # Count files changed for better context
    files_changed = len([line for line in diff.split('\n') if line.startswith('diff --git')])
    print_colored(f"📁 Files changed: {files_changed}", Colors.OKBLUE)
    
    # Analyze with Claude
    analysis = analyze_with_claude(diff, base_branch, current_branch, prompt_key)
    
    # Display results
    print_colored("\n" + "=" * 80, Colors.HEADER)
    print_colored("📋 ANALYSIS RESULTS", Colors.HEADER)
    print_colored("=" * 80, Colors.HEADER)
    print(analysis)
    
    # Save to file
    save_analysis(analysis, base_branch, current_branch)
    
    print_colored("\n✅ Analysis complete!", Colors.OKGREEN)

if __name__ == "__main__":
    main()
