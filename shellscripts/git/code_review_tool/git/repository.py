"""
Git repository operations for the code review tool.
"""

import subprocess
from pathlib import Path
from typing import List, Optional, Tuple
from ..core.models import GitResult, BranchInfo
from ..utils.error_handling import GitError, with_git_error_handling
from ..utils.terminal import TerminalUI


class GitRepository:
    """Handles git repository operations"""
    
    def __init__(self, repo_path: Optional[Path] = None):
        """Initialize git repository handler"""
        self.repo_path = repo_path or Path.cwd()
        self._validate_git_repo()
    
    def _validate_git_repo(self) -> None:
        """Verify we're in a git repository"""
        git_dir = self.repo_path / ".git"
        if not git_dir.exists():
            raise GitError([], "Not in a git repository")
    
    def _run_git_command(self, command: List[str]) -> GitResult:
        """Run git command and return result"""
        try:
            result = subprocess.run(
                command, 
                capture_output=True, 
                text=True, 
                check=True,
                cwd=self.repo_path
            )
            return GitResult(
                success=True,
                output=result.stdout.strip(),
                command=command
            )
        except subprocess.CalledProcessError as e:
            return GitResult(
                success=False,
                output=e.stderr.strip(),
                command=command
            )
    
    @with_git_error_handling
    def get_current_branch(self) -> str:
        """Get the currently checked out branch"""
        TerminalUI.print_info("Getting current branch...")
        
        result = self._run_git_command(["git", "rev-parse", "--abbrev-ref", "HEAD"])
        result.raise_if_failed()
        
        return result.output.strip()
    
    @with_git_error_handling
    def get_branch_info(self, base_branch: str) -> BranchInfo:
        """Get branch information and validate"""
        current_branch = self.get_current_branch()
        
        if current_branch == base_branch:
            TerminalUI.print_warning(f"Currently on {base_branch} branch. Cannot compare with itself.")
            TerminalUI.print_info(f"Please checkout a different branch to compare against {base_branch}.")
            raise GitError([], f"Cannot compare branch '{current_branch}' with itself")
        
        return BranchInfo(current=current_branch, base=base_branch)
    
    @with_git_error_handling
    def get_diff(
        self, 
        base_branch: str, 
        target_branch: str, 
        files_only: Optional[List[str]] = None, 
        exclude_files: Optional[List[str]] = None
    ) -> str:
        """Get git diff between branches with enhanced line number context"""
        TerminalUI.print_info(f"Getting diff between '{base_branch}' and '{target_branch}'...")
        
        # Build git diff command
        cmd = ["git", "diff", f"{base_branch}...{target_branch}", "--no-merges", "--unified=3"]
        
        # Add file filters if specified
        if files_only:
            cmd.extend(["--"] + files_only)
            TerminalUI.print_cyan(f"Analyzing only: {', '.join(files_only)}")
        
        result = self._run_git_command(cmd)
        result.raise_if_failed()
        
        if not result.output:
            TerminalUI.print_warning("No differences found between branches.")
            return ""
        
        # Apply file exclusions if specified
        diff_content = result.output
        if exclude_files:
            diff_content = self._filter_excluded_files(diff_content, exclude_files)
            TerminalUI.print_cyan(f"Excluded: {', '.join(exclude_files)}")
        
        return diff_content
    
    def _filter_excluded_files(self, diff: str, exclude_files: List[str]) -> str:
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
    
    @with_git_error_handling
    def get_commit_sha(self, branch: str) -> str:
        """Get commit SHA for a branch"""
        result = self._run_git_command(["git", "rev-parse", branch])
        result.raise_if_failed()
        return result.output.strip()
    
    @with_git_error_handling
    def get_diff_stats(self, base_branch: str, target_branch: str) -> dict:
        """Get diff statistics"""
        result = self._run_git_command([
            "git", "diff", f"{base_branch}...{target_branch}", 
            "--stat", "--no-merges"
        ])
        result.raise_if_failed()
        
        # Parse stats from output
        lines = result.output.split('\n')
        files_changed = 0
        insertions = 0
        deletions = 0
        
        for line in lines:
            if 'files changed' in line or 'file changed' in line:
                parts = line.split(',')
                for part in parts:
                    part = part.strip()
                    if 'file' in part and 'changed' in part:
                        files_changed = int(part.split()[0])
                    elif 'insertion' in part:
                        insertions = int(part.split()[0])
                    elif 'deletion' in part:
                        deletions = int(part.split()[0])
        
        return {
            'files_changed': files_changed,
            'insertions': insertions,
            'deletions': deletions,
            'total_changes': insertions + deletions
        }
    
    @with_git_error_handling
    def get_changed_files(self, base_branch: str, target_branch: str) -> List[str]:
        """Get list of changed files between branches"""
        result = self._run_git_command([
            "git", "diff", f"{base_branch}...{target_branch}", 
            "--name-only", "--no-merges"
        ])
        result.raise_if_failed()
        
        if not result.output:
            return []
        
        return [line.strip() for line in result.output.split('\n') if line.strip()]
    
    def enhance_diff_with_context(self, diff: str) -> str:
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