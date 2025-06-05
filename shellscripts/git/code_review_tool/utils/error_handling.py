"""
Error handling utilities and custom exceptions for the code review tool.
"""

from typing import List
import sys
from .terminal import TerminalUI


class CodeReviewError(Exception):
    """Base exception for code review tool errors"""
    pass


class GitError(CodeReviewError):
    """Exception for git command failures"""
    def __init__(self, command: List[str], message: str):
        self.command = command
        self.message = message
        super().__init__(f"Git command failed: {' '.join(command)}")


class AnalysisError(CodeReviewError):
    """Exception for analysis failures"""
    pass


class GitHubError(CodeReviewError):
    """Exception for GitHub integration failures"""
    pass


class ConfigurationError(CodeReviewError):
    """Exception for configuration issues"""
    pass


def handle_git_error(cmd: List[str], error: str) -> None:
    """Handle git command errors consistently"""
    TerminalUI.print_error(f"Git command failed: {' '.join(cmd)}")
    TerminalUI.print_error(f"Error: {error}")
    sys.exit(1)


def handle_analysis_error(error: str) -> None:
    """Handle analysis errors consistently"""
    TerminalUI.print_error(f"Analysis failed: {error}")
    sys.exit(1)


def handle_github_error(error: str) -> None:
    """Handle GitHub integration errors consistently"""
    TerminalUI.print_error(f"GitHub integration failed: {error}")
    sys.exit(1)


def with_git_error_handling(func):
    """Decorator for git operations with automatic error handling"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except GitError as e:
            handle_git_error(e.command, e.message)
        except Exception as e:
            TerminalUI.print_error(f"Unexpected error in git operation: {str(e)}")
            sys.exit(1)
    return wrapper


def with_analysis_error_handling(func):
    """Decorator for analysis operations with automatic error handling"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except AnalysisError as e:
            handle_analysis_error(str(e))
        except Exception as e:
            TerminalUI.print_error(f"Unexpected error in analysis: {str(e)}")
            sys.exit(1)
    return wrapper


def with_github_error_handling(func):
    """Decorator for GitHub operations with automatic error handling"""
    def wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except GitHubError as e:
            handle_github_error(str(e))
        except Exception as e:
            TerminalUI.print_error(f"Unexpected error in GitHub integration: {str(e)}")
            sys.exit(1)
    return wrapper 