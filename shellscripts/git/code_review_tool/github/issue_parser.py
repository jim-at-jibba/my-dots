"""
Parse code issues from analysis text for GitHub PR commenting.
"""

import re
from typing import List
from ..core.models import CodeIssue, IssueType
from ..utils.terminal import TerminalUI


class IssueParser:
    """Parses code issues from analysis text"""
    
    def __init__(self):
        """Initialize issue parser with regex patterns"""
        # Multiple regex patterns to handle different formats
        self.patterns = [
            # Primary pattern: - `file.ext:Line X` - description
            r'^\s*[-*]\s*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\s*[-–—]\s*(.+)$',
            
            # Pattern with bold formatting: - **`file.ext:Line X`** - description  
            r'^\s*[-*]\s*\*\*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\*\*\s*[-–—]\s*(.+)$',
            
            # Pattern without bullet: `file.ext:Line X` - description
            r'^\s*`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))`\s*[-–—]\s*(.+)$',
            
            # Pattern with Format prefix: Format: `file.ext:Line X - description`
            r'^\s*(?:Format:\s*)?`([^`]+\.(?:tsx?|jsx?|py|js|ts|java|cpp|c|h|swift|kt|rb|go|rs|php|cs)):(?:Line\s*(\d+)|Lines\s*(\d+)-(\d+))\s*[-–—]\s*([^`]+)`$'
        ]
    
    def parse_issues_from_analysis(self, analysis: str) -> List[CodeIssue]:
        """Parse code issues from the analysis text with multiple pattern support"""
        issues = []
        lines = analysis.split('\n')
        
        current_section = None
        issue_type = None
        
        for line in lines:
            line = line.strip()
            
            # Detect section headers
            if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
                current_section = 'critical'
                issue_type = IssueType.CRITICAL
                continue
            elif '⚠️ **Warnings**' in line or 'Warnings' in line:
                current_section = 'warnings'
                issue_type = IssueType.WARNING
                continue
            elif '✅ **Improvements**' in line or 'Improvements' in line:
                current_section = 'improvements'
                issue_type = IssueType.IMPROVEMENT
                continue
            elif line.startswith('####') or line.startswith('###'):
                current_section = None
                continue
            
            # Parse issue lines
            if current_section and line and not line.startswith('#'):
                issue = self._parse_issue_line(line, issue_type)
                if issue:
                    issues.append(issue)
        
        return issues
    
    def _parse_issue_line(self, line: str, issue_type: IssueType) -> CodeIssue:
        """Parse a single issue line using multiple patterns"""
        # Try each pattern until one matches
        for pattern in self.patterns:
            file_line_match = re.search(pattern, line)
            if file_line_match:
                groups = file_line_match.groups()
                file_path = groups[0]
                line_num = groups[1] or groups[2]  # Single line or start of range
                description = groups[4].strip() if len(groups) > 4 and groups[4] else "No description"
                
                if line_num:
                    line_num = int(line_num)
                
                return CodeIssue(
                    file_path=file_path,
                    line_number=line_num,
                    issue_type=issue_type,
                    description=description,
                    full_context=line
                )
        
        return None
    
    def validate_issues_format(self, analysis: str) -> dict:
        """Validate the format of issues in analysis and provide feedback"""
        lines = analysis.split('\n')
        sections_found = []
        issues_found = 0
        format_issues = []
        
        current_section = None
        
        for line_num, line in enumerate(lines, 1):
            line = line.strip()
            
            # Track sections
            if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
                sections_found.append('Critical Issues')
                current_section = 'critical'
                continue
            elif '⚠️ **Warnings**' in line or 'Warnings' in line:
                sections_found.append('Warnings')
                current_section = 'warnings'
                continue
            elif '✅ **Improvements**' in line or 'Improvements' in line:
                sections_found.append('Improvements')
                current_section = 'improvements'
                continue
            elif line.startswith('####') or line.startswith('###'):
                current_section = None
                continue
            
            # Check issue format in relevant sections
            if current_section and line and not line.startswith('#'):
                if self._looks_like_issue_line(line):
                    if self._parse_issue_line(line, IssueType.CRITICAL):
                        issues_found += 1
                    else:
                        format_issues.append({
                            'line_number': line_num,
                            'content': line,
                            'issue': 'Invalid issue format'
                        })
        
        return {
            'sections_found': sections_found,
            'issues_found': issues_found,
            'format_issues': format_issues,
            'valid': len(format_issues) == 0 and issues_found > 0
        }
    
    def _looks_like_issue_line(self, line: str) -> bool:
        """Check if a line looks like it should be an issue line"""
        # Look for patterns that suggest this should be an issue
        indicators = [
            line.startswith('- '),
            line.startswith('* '),
            '`' in line and ':' in line,
            'Line' in line,
            '.tsx' in line or '.ts' in line or '.js' in line or '.py' in line
        ]
        return any(indicators)
    
    def get_format_help(self) -> str:
        """Get help text for proper issue formatting"""
        return """
## Proper Issue Format for GitHub Comments

Issues must be in 'Critical Issues', 'Warnings', or 'Improvements' sections and follow this format:

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

**Supported File Extensions:** .tsx, .ts, .jsx, .js, .py, .java, .cpp, .c, .h, .swift, .kt, .rb, .go, .rs, .php, .cs
""" 