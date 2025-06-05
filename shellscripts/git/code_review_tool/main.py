#!/usr/bin/env python3
"""
AI-Powered Code Review Tool - Main Entry Point

A refactored, modular code review tool that uses Claude AI to analyze git diffs
and provide comprehensive code reviews with GitHub integration.
"""

import sys
import argparse
from pathlib import Path
from typing import Optional

from .core.orchestrator import AnalysisOrchestrator
from .core.models import AnalysisArgs
from .config.config_manager import ConfigManager
from .github.comment_handler import GitHubCommentHandler
from .utils.terminal import TerminalUI
from .utils.error_handling import ConfigurationError


class CLIParser:
    """Handles command line argument parsing"""
    
    def __init__(self, config_manager: ConfigManager):
        """Initialize CLI parser with configuration"""
        self.config_manager = config_manager
    
    def create_parser(self) -> argparse.ArgumentParser:
        """Create argument parser"""
        parser = argparse.ArgumentParser(
            description="AI-Powered Code Review Tool",
            formatter_class=argparse.RawDescriptionHelpFormatter,
            epilog=self._get_examples_text()
        )
        
        # Get available prompts for choices
        available_prompts = list(self.config_manager.get_available_prompts().keys())
        default_prompt = self.config_manager.get_default_prompt_key()
        default_base = self.config_manager.get_analysis_config().default_base_branch
        
        parser.add_argument(
            "-b", "--base",
            default=default_base,
            help=f"Base branch to compare against (default: {default_base})"
        )
        
        parser.add_argument(
            "-p", "--prompt",
            default=default_prompt,
            choices=available_prompts,
            help=f"Analysis prompt to use (default: {default_prompt}). Choose from: {', '.join(available_prompts)}"
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
        
        parser.add_argument(
            "--validate-config",
            action="store_true",
            help="Validate configuration and exit"
        )
        
        return parser
    
    def parse_args(self, args: Optional[list] = None) -> AnalysisArgs:
        """Parse command line arguments into AnalysisArgs"""
        parser = self.create_parser()
        parsed_args = parser.parse_args(args)
        
        return AnalysisArgs(
            base_branch=parsed_args.base,
            prompt_key=parsed_args.prompt,
            generate_steps=parsed_args.generate_steps,
            github_comments=parsed_args.github_comments,
            max_file_size=parsed_args.max_file_size,
            no_chunking=parsed_args.no_chunking,
            files_only=parsed_args.files_only,
            exclude_files=parsed_args.exclude_files
        )
    
    def _get_examples_text(self) -> str:
        """Get examples text for help"""
        return """
Examples:
  %(prog)s                              # Compare current branch with staging using default prompt
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


def main():
    """Main entry point"""
    try:
        # Initialize configuration
        config_manager = ConfigManager()
        
        # Create CLI parser
        cli_parser = CLIParser(config_manager)
        parser = cli_parser.create_parser()
        parsed_args = parser.parse_args()
        
        # Handle special commands
        if parsed_args.list_prompts:
            orchestrator = AnalysisOrchestrator(config_manager)
            orchestrator.list_available_prompts()
            sys.exit(0)
        
        if parsed_args.validate_config:
            orchestrator = AnalysisOrchestrator(config_manager)
            if orchestrator.validate_configuration():
                TerminalUI.print_success("✅ Configuration is valid!")
                sys.exit(0)
            else:
                TerminalUI.print_error("❌ Configuration validation failed!")
                sys.exit(1)
        
        # Parse arguments into AnalysisArgs
        args = cli_parser.parse_args()
        
        # Initialize orchestrator
        orchestrator = AnalysisOrchestrator(config_manager)
        
        # Run analysis
        result = orchestrator.run_analysis(args)
        
        # Display results
        orchestrator.display_results(result)
        
        # Handle GitHub comments if requested
        if args.github_comments and result.issues:
            github_handler = GitHubCommentHandler(config_manager.get_github_config())
            success = github_handler.handle_github_comments(
                result.analysis_text, 
                result.branch_info.base, 
                result.branch_info.current
            )
            if not success:
                TerminalUI.print_warning("⚠️  GitHub commenting encountered issues")
        
        # Save results
        analysis_file, steps_file = orchestrator.save_results(result)
        
        # Final status
        TerminalUI.print_success("\n✅ Analysis complete!")
        if args.generate_steps:
            TerminalUI.print_success("✅ Problem-solving steps generated!")
        if args.github_comments:
            TerminalUI.print_success("✅ GitHub integration completed!")
        
    except ConfigurationError as e:
        TerminalUI.print_error(f"Configuration error: {str(e)}")
        TerminalUI.print_info("Try running with --validate-config to check your setup")
        sys.exit(1)
    except KeyboardInterrupt:
        TerminalUI.print_warning("\n⚠️  Analysis interrupted by user")
        sys.exit(1)
    except Exception as e:
        TerminalUI.print_error(f"Unexpected error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 