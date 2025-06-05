"""
Main orchestrator for the code review tool.
Coordinates all components to perform the analysis workflow.
"""

from pathlib import Path
from typing import Optional
from ..core.models import AnalysisConfig, AnalysisArgs, AnalysisResult, BranchInfo
from ..config.config_manager import ConfigManager
from ..git.repository import GitRepository
from ..analysis.claude_analyzer import ClaudeAnalyzer
from ..github.issue_parser import IssueParser
from ..utils.terminal import TerminalUI
from ..utils.file_operations import FileOperations
from ..utils.error_handling import with_analysis_error_handling


class AnalysisOrchestrator:
    """Orchestrates the complete code review analysis workflow"""
    
    def __init__(self, config_manager: Optional[ConfigManager] = None):
        """Initialize orchestrator with configuration"""
        self.config_manager = config_manager or ConfigManager()
        self.config = self.config_manager.get_analysis_config()
        self.git_repo = GitRepository()
        self.analyzer = ClaudeAnalyzer(self.config)
        self.issue_parser = IssueParser()
    
    @with_analysis_error_handling
    def run_analysis(self, args: AnalysisArgs) -> AnalysisResult:
        """Run the complete analysis workflow"""
        TerminalUI.print_section_header("🚀 AI-Powered Code Review Tool")
        
        # Show configuration
        self._display_configuration(args)
        
        # Get branch information
        branch_info = self.git_repo.get_branch_info(args.base_branch)
        TerminalUI.print_cyan(f"Current branch: {branch_info.current}")
        TerminalUI.print_cyan(f"Comparing against: {branch_info.base}")
        
        # Get diff
        diff = self.git_repo.get_diff(
            branch_info.base, 
            branch_info.current, 
            args.files_only, 
            args.exclude_files
        )
        
        if not diff:
            TerminalUI.print_success("No changes to analyze!")
            return AnalysisResult(
                analysis_text="No changes found between branches.",
                branch_info=branch_info,
                diff_content=""
            )
        
        # Display diff statistics
        self._display_diff_stats(branch_info.base, branch_info.current, diff)
        
        # Get prompt information
        prompt_info = self.config_manager.get_prompt_info(args.prompt_key)
        
        # Analyze with Claude
        analysis = self.analyzer.analyze_diff(
            diff, prompt_info, branch_info.base, branch_info.current
        )
        
        # Parse issues for GitHub integration
        issues = self.issue_parser.parse_issues_from_analysis(analysis)
        
        # Generate problem-solving steps if requested
        steps = None
        if args.generate_steps:
            steps = self.analyzer.generate_problem_solving_steps(
                analysis, branch_info.base, branch_info.current
            )
        
        # Create result
        result = AnalysisResult(
            analysis_text=analysis,
            branch_info=branch_info,
            diff_content=diff,
            issues=issues,
            problem_solving_steps=steps
        )
        
        return result
    
    def save_results(self, result: AnalysisResult) -> tuple[Path, Optional[Path]]:
        """Save analysis results to files"""
        output_config = self.config_manager.get_output_config()
        
        return FileOperations.save_analysis_to_file(
            result.analysis_text,
            result.branch_info.base,
            result.branch_info.current,
            result.problem_solving_steps,
            output_config.get('analysis_dir', 'analysis')
        )
    
    def display_results(self, result: AnalysisResult) -> None:
        """Display analysis results to terminal"""
        TerminalUI.print_section_header("📋 ANALYSIS RESULTS")
        print(result.analysis_text)
        
        if result.problem_solving_steps:
            TerminalUI.print_section_header("🔧 PROBLEM-SOLVING STEPS")
            print(result.problem_solving_steps)
    
    def _display_configuration(self, args: AnalysisArgs) -> None:
        """Display current configuration"""
        prompt_info = self.config_manager.get_prompt_info(args.prompt_key)
        TerminalUI.print_cyan(f"Using prompt: {prompt_info.name}")
        TerminalUI.print_info(f"   {prompt_info.description}")
        
        # Show configuration for large PR handling
        if args.max_file_size != 10000:
            TerminalUI.print_cyan(f"Max file size: {args.max_file_size} lines")
        if args.no_chunking:
            TerminalUI.print_warning("Chunking disabled - large PRs may fail")
        if args.files_only:
            TerminalUI.print_cyan(f"Analyzing only: {', '.join(args.files_only)}")
        if args.exclude_files:
            TerminalUI.print_cyan(f"Excluding: {', '.join(args.exclude_files)}")
        
        if args.generate_steps:
            TerminalUI.print_cyan("Problem-solving steps will be generated after analysis")
        if args.github_comments:
            TerminalUI.print_cyan("GitHub PR comments will be created interactively")
    
    def _display_diff_stats(self, base_branch: str, target_branch: str, diff: str) -> None:
        """Display diff statistics"""
        diff_stats = self.git_repo.get_diff_stats(base_branch, target_branch)
        
        TerminalUI.print_info(f"Diff size: {len(diff.splitlines())} lines")
        TerminalUI.print_info(f"Files changed: {diff_stats['files_changed']}")
        TerminalUI.print_info(f"Total changes: {diff_stats['total_changes']} (+{diff_stats['insertions']}/-{diff_stats['deletions']})")
    
    def list_available_prompts(self) -> None:
        """Display available prompts"""
        TerminalUI.print_subsection_header("📝 Available Prompts")
        
        prompts = self.config_manager.list_available_prompts()
        default_key = self.config_manager.get_default_prompt_key()
        
        for key, description in prompts.items():
            status = " (default)" if key == default_key else ""
            TerminalUI.print_cyan(f"  {key:<15} - {description}{status}")
        print()
    
    def validate_configuration(self) -> bool:
        """Validate that configuration is properly set up"""
        try:
            # Test configuration loading
            config = self.config_manager.get_analysis_config()
            prompts = self.config_manager.get_available_prompts()
            
            if not prompts:
                TerminalUI.print_error("No prompts configured")
                return False
            
            TerminalUI.print_success("Configuration validated successfully")
            return True
            
        except Exception as e:
            TerminalUI.print_error(f"Configuration validation failed: {str(e)}")
            return False 