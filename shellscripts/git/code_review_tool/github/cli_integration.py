"""
GitHub CLI integration wrapper.
"""

import subprocess
import json
from typing import Optional
from ..utils.terminal import TerminalUI
from ..utils.error_handling import GitHubError


class GitHubCLI:
    """Wrapper for GitHub CLI operations"""
    
    def is_available(self) -> bool:
        """Check if GitHub CLI is installed and authenticated"""
        try:
            # Check if gh is installed
            result = subprocess.run(
                ["gh", "--version"], 
                capture_output=True, 
                text=True, 
                check=True
            )
            
            # Check if authenticated
            result = subprocess.run(
                ["gh", "auth", "status"], 
                capture_output=True, 
                text=True, 
                check=True
            )
            return True
        except (subprocess.CalledProcessError, FileNotFoundError):
            return False
    
    def get_pr_number(self, base_branch: str, target_branch: str) -> Optional[str]:
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
    
    def create_line_comment(
        self, 
        pr_number: str, 
        file_path: str, 
        line_number: int, 
        comment_body: str, 
        target_branch: str
    ) -> bool:
        """Create a line-specific PR comment"""
        try:
            # Get the commit SHA for the current branch
            commit_result = subprocess.run(
                ["git", "rev-parse", target_branch], 
                capture_output=True, 
                text=True, 
                check=True
            )
            commit_sha = commit_result.stdout.strip()
            
            # Use gh API to create line-specific comment
            result = subprocess.run([
                "gh", "api", f"repos/:owner/:repo/pulls/{pr_number}/comments",
                "--method", "POST",
                "--field", f"body={comment_body}",
                "--field", f"commit_id={commit_sha}",
                "--field", f"path={file_path}",
                "--field", f"line={line_number}",
                "--field", "side=RIGHT"
            ], capture_output=True, text=True)
            
            return result.returncode == 0
            
        except subprocess.CalledProcessError:
            return False
    
    def create_general_comment(self, pr_number: str, comment_body: str) -> bool:
        """Create a general PR comment"""
        try:
            result = subprocess.run([
                "gh", "pr", "comment", pr_number, 
                "--body", comment_body
            ], capture_output=True, text=True)
            
            return result.returncode == 0
            
        except subprocess.CalledProcessError:
            return False
    
    def get_pr_info(self, pr_number: str) -> Optional[dict]:
        """Get PR information"""
        try:
            result = subprocess.run([
                "gh", "pr", "view", pr_number,
                "--json", "title,body,state,author,url"
            ], capture_output=True, text=True, check=True)
            
            return json.loads(result.stdout)
            
        except (subprocess.CalledProcessError, json.JSONDecodeError):
            return None 