"""
GitHub PR comment handler for code review integration.
"""

import subprocess
import json
from typing import List, Optional, Dict, Any
from ..core.models import CodeIssue, IssueType
from ..utils.terminal import TerminalUI
from ..utils.error_handling import GitHubError, with_github_error_handling
from .issue_parser import IssueParser
from .cli_integration import GitHubCLI


class GitHubCommentHandler:
    """Handles GitHub PR commenting workflow"""
    
    def __init__(self, github_config: Dict[str, Any]):
        """Initialize GitHub comment handler"""
        self.config = github_config
        self.issue_parser = IssueParser()
        self.github_cli = GitHubCLI()
    
    @with_github_error_handling
    def handle_github_comments(
        self, 
        analysis: str, 
        base_branch: str, 
        target_branch: str
    ) -> bool:
        """Handle the complete GitHub commenting workflow"""
        TerminalUI.print_subsection_header("🐙 GitHub CLI Integration")
        
        # Check GitHub CLI
        if not self.github_cli.is_available():
            TerminalUI.print_error("GitHub CLI not found or not authenticated")
            TerminalUI.print_info("Please install and authenticate with: gh auth login")
            return False
        
        TerminalUI.print_success("GitHub CLI authenticated")
        
        # Get PR number
        pr_number = self.github_cli.get_pr_number(base_branch, target_branch)
        if not pr_number:
            TerminalUI.print_error(f"No PR found for {target_branch} -> {base_branch}")
            TerminalUI.print_info("Please create a PR first or ensure you're on the correct branch")
            return False
        
        TerminalUI.print_success(f"Found PR #{pr_number}")
        
        # Parse issues from analysis
        issues = self.issue_parser.parse_issues_from_analysis(analysis)
        if not issues:
            TerminalUI.print_warning("No commentable issues found in analysis")
            self._show_format_help()
            return True
        
        TerminalUI.print_cyan(f"Found {len(issues)} potential issues to comment on")
        
        # Interactive selection
        selected_issues = self._interactive_comment_selection(issues)
        if not selected_issues:
            TerminalUI.print_warning("No issues selected for commenting")
            return True
        
        # Create comments
        return self._create_pr_comments(selected_issues, pr_number, target_branch)
    
    def _interactive_comment_selection(self, issues: List[CodeIssue]) -> List[CodeIssue]:
        """Interactive selection of issues to comment on"""
        if not issues:
            return []
        
        TerminalUI.print_subsection_header("🔍 Select Issues for GitHub Comments")
        
        selected_issues = []
        max_comments = self.config.get('max_comments_per_pr', 20)
        
        for i, issue in enumerate(issues, 1):
            if len(selected_issues) >= max_comments:
                TerminalUI.print_warning(f"Reached maximum comments limit ({max_comments})")
                break
            
            # Display issue
            color = TerminalUI.print_error if issue.issue_type == IssueType.CRITICAL else \
                   TerminalUI.print_warning if issue.issue_type == IssueType.WARNING else \
                   TerminalUI.print_success
            
            type_emoji = "🔍" if issue.issue_type == IssueType.CRITICAL else \
                        "⚠️" if issue.issue_type == IssueType.WARNING else "✅"
            
            print(f"\n{type_emoji} Issue {i}/{len(issues)} ({issue.issue_type.value.upper()})")
            TerminalUI.print_file_info(issue.file_path, issue.line_number)
            TerminalUI.print_info(f"Description: {issue.description}")
            
            # Ask user
            choice = TerminalUI.get_user_choice(
                "Comment on this issue?", 
                ['y', 'n', 's'], 
                allow_quit=True
            )
            
            if choice == 'y':
                selected_issues.append(issue)
                TerminalUI.print_success("✅ Added to comment list")
            elif choice == 'n':
                TerminalUI.print_warning("⏭️  Skipped")
            elif choice == 's':
                TerminalUI.print_info(f"Full context: {issue.full_context}")
                # Ask again after showing context
                choice = TerminalUI.get_user_choice(
                    "Comment on this issue?", 
                    ['y', 'n'], 
                    allow_quit=False
                )
                if choice == 'y':
                    selected_issues.append(issue)
                    TerminalUI.print_success("✅ Added to comment list")
                else:
                    TerminalUI.print_warning("⏭️  Skipped")
            else:  # quit
                TerminalUI.print_warning("🛑 Stopping selection process")
                break
        
        return selected_issues
    
    def _create_pr_comments(
        self, 
        issues: List[CodeIssue], 
        pr_number: str, 
        target_branch: str
    ) -> bool:
        """Create PR comments for selected issues"""
        if not issues:
            return True
        
        TerminalUI.print_info(f"Creating {len(issues)} PR comments...")
        
        success_count = 0
        
        for i, issue in enumerate(issues, 1):
            try:
                # Format comment body
                comment_body = f"{issue.description}\n\n"
                
                # Try to create line-specific comment first
                if issue.line_number and issue.file_path:
                    success = self.github_cli.create_line_comment(
                        pr_number, issue.file_path, issue.line_number, 
                        comment_body, target_branch
                    )
                    
                    if success:
                        TerminalUI.print_success(f"✅ Comment {i}/{len(issues)}: {issue.file_path}:{issue.line_number}")
                        success_count += 1
                    else:
                        # Fallback to general comment
                        if self.github_cli.create_general_comment(pr_number, comment_body):
                            TerminalUI.print_success(f"✅ Comment {i}/{len(issues)}: {issue.file_path} (general)")
                            success_count += 1
                        else:
                            TerminalUI.print_error(f"❌ Failed to comment on {issue.file_path}")
                else:
                    # General PR comment
                    if self.github_cli.create_general_comment(pr_number, comment_body):
                        TerminalUI.print_success(f"✅ Comment {i}/{len(issues)}: General comment")
                        success_count += 1
                    else:
                        TerminalUI.print_error(f"❌ Failed to create general comment")
                        
            except Exception as e:
                TerminalUI.print_error(f"❌ Error creating comment for {issue.file_path}: {str(e)}")
        
        TerminalUI.print_info(f"Successfully created {success_count}/{len(issues)} comments")
        
        return success_count > 0
    
    def _show_format_help(self) -> None:
        """Show format help for issues"""
        validation = self.issue_parser.validate_issues_format("")
        
        TerminalUI.print_info("💡 Tip: Issues must be in 'Critical Issues', 'Warnings', or 'Improvements' sections")
        TerminalUI.print_info("💡 Format: - `filename.ext:Line X` - Description")
        
        if validation['sections_found']:
            TerminalUI.print_cyan(f"📋 Found sections: {', '.join(validation['sections_found'])}")
        else:
            TerminalUI.print_warning("❌ No recognized sections found in analysis")
        
        # Show format help
        print(self.issue_parser.get_format_help()) 