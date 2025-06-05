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
MODEL = "claude-opus-4-20250514"  # Claude Opus 4

# Analysis prompt
ANALYSIS_PROMPT = """
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

def analyze_with_claude(diff: str, base_branch: str, target_branch: str) -> str:
    """Send diff to Claude for analysis"""
    if not ANTHROPIC_API_KEY:
        print_colored("❌ Error: ANTHROPIC_API_KEY environment variable not set", Colors.FAIL)
        print_colored("Please set your API key: export ANTHROPIC_API_KEY='your-api-key'", Colors.OKBLUE)
        sys.exit(1)
    
    print_colored("🤖 Sending to Claude Opus 4 for analysis...", Colors.OKBLUE)
    
    try:
        client = anthropic.Anthropic(api_key=ANTHROPIC_API_KEY)
        
        # Enhance diff with context for better line number understanding
        enhanced_diff = enhance_diff_with_context(diff)
        
        prompt = ANALYSIS_PROMPT.format(
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

def save_analysis(analysis: str, base_branch: str, target_branch: str):
    """Save analysis to file"""
    filename = f"analysis_{target_branch}_vs_{base_branch}.md"
    try:
        with open(filename, 'w') as f:
            f.write(f"# Branch Analysis: {target_branch} vs {base_branch}\n\n")
            f.write(analysis)
        print_colored(f"💾 Analysis saved to: {filename}", Colors.OKGREEN)
    except Exception as e:
        print_colored(f"⚠️  Could not save to file: {str(e)}", Colors.WARNING)

def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="React Native TypeScript Branch Analysis Tool",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s                    # Compare current branch with staging
  %(prog)s -b main           # Compare current branch with main
  %(prog)s --base develop    # Compare current branch with develop
        """
    )
    
    parser.add_argument(
        "-b", "--base",
        default=DEFAULT_BASE_BRANCH,
        help=f"Base branch to compare against (default: {DEFAULT_BASE_BRANCH})"
    )
    
    return parser.parse_args()

def main():
    """Main script execution"""
    # Parse arguments
    args = parse_arguments()
    base_branch = args.base
    
    print_colored("🚀 React Native TypeScript Branch Analysis Tool", Colors.HEADER)
    print_colored("=" * 50, Colors.HEADER)
    
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
    analysis = analyze_with_claude(diff, base_branch, current_branch)
    
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
