"""
Core data models and types for the code review tool.
"""

from dataclasses import dataclass
from typing import List, Optional, Dict, Any
from enum import Enum


class IssueType(Enum):
    """Types of issues that can be found in code review"""
    CRITICAL = "critical"
    WARNING = "warning" 
    IMPROVEMENT = "improvement"


class RiskLevel(Enum):
    """Risk levels for code changes"""
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    HIGH = "HIGH"


class DeploymentStatus(Enum):
    """Deployment readiness status"""
    YES = "YES"
    NO = "NO"
    WITH_CONDITIONS = "WITH_CONDITIONS"


@dataclass
class AnalysisConfig:
    """Configuration for code analysis"""
    anthropic_api_key: str
    default_base_branch: str = "staging"
    model: str = "claude-sonnet-4-20250514"
    max_tokens: int = 190000
    chunk_overlap: int = 500
    min_chunk_size: int = 1000
    max_file_size: int = 10000
    allow_chunking: bool = True


@dataclass
class BranchInfo:
    """Information about git branches"""
    current: str
    base: str
    
    def __post_init__(self):
        if self.current == self.base:
            raise ValueError(f"Cannot compare branch '{self.current}' with itself")


@dataclass
class CodeIssue:
    """Represents a code issue that can be commented on"""
    file_path: str
    line_number: Optional[int]
    issue_type: IssueType
    description: str
    full_context: str


@dataclass
class DiffChunk:
    """A chunk of a git diff"""
    content: str
    file_paths: List[str]
    estimated_tokens: int
    chunk_number: int
    total_chunks: int


@dataclass
class AnalysisResult:
    """Result of code analysis"""
    analysis_text: str
    branch_info: BranchInfo
    diff_content: str
    risk_level: Optional[RiskLevel] = None
    deployment_ready: Optional[DeploymentStatus] = None
    issues: Optional[List[CodeIssue]] = None
    problem_solving_steps: Optional[str] = None
    
    @property
    def has_critical_issues(self) -> bool:
        """Check if analysis contains critical issues"""
        if not self.issues:
            return False
        return any(issue.issue_type == IssueType.CRITICAL for issue in self.issues)


@dataclass
class PromptInfo:
    """Information about an analysis prompt"""
    name: str
    description: str
    prompt_template: str


@dataclass
class GitResult:
    """Result of a git command execution"""
    success: bool
    output: str
    command: List[str]
    
    def raise_if_failed(self):
        """Raise exception if command failed"""
        if not self.success:
            from ..utils.error_handling import GitError
            raise GitError(self.command, self.output)


@dataclass
class AnalysisArgs:
    """Arguments for analysis"""
    base_branch: str
    prompt_key: str
    generate_steps: bool = False
    github_comments: bool = False
    max_file_size: int = 10000
    no_chunking: bool = False
    files_only: Optional[List[str]] = None
    exclude_files: Optional[List[str]] = None 