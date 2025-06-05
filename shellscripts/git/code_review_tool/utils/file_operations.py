"""
File operation utilities for the code review tool.
"""

import os
import tempfile
from pathlib import Path
from typing import Optional
from .terminal import TerminalUI
from .error_handling import CodeReviewError


class FileOperations:
    """Utilities for file operations"""
    
    @staticmethod
    def sanitize_filename(name: str) -> str:
        """Sanitize branch name for use in filename"""
        invalid_chars = ['/', '\\', ':', '*', '?', '"', '<', '>', '|']
        sanitized = name
        for char in invalid_chars:
            sanitized = sanitized.replace(char, '_')
        return sanitized
    
    @staticmethod
    def ensure_directory_exists(directory: Path) -> None:
        """Ensure directory exists, create if it doesn't"""
        try:
            directory.mkdir(parents=True, exist_ok=True)
        except Exception as e:
            raise CodeReviewError(f"Failed to create directory {directory}: {str(e)}")
    
    @staticmethod
    def save_analysis_to_file(
        analysis: str, 
        base_branch: str, 
        target_branch: str, 
        steps: Optional[str] = None,
        output_dir: str = "analysis"
    ) -> tuple[Path, Optional[Path]]:
        """Save analysis to file in analysis folder"""
        # Create analysis directory if it doesn't exist
        analysis_dir = Path(output_dir)
        FileOperations.ensure_directory_exists(analysis_dir)
        
        # Sanitize branch names for filename
        safe_target = FileOperations.sanitize_filename(target_branch)
        safe_base = FileOperations.sanitize_filename(base_branch)
        
        # Save main analysis
        filename = f"analysis_{safe_target}_vs_{safe_base}.md"
        filepath = analysis_dir / filename
        
        try:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(f"# Branch Analysis: {target_branch} vs {base_branch}\n\n")
                f.write(analysis)
                
                # Add problem-solving steps if provided
                if steps:
                    f.write(f"\n\n---\n\n# Problem-Solving Steps\n\n")
                    f.write(steps)
                    
            TerminalUI.print_success(f"Analysis saved to: {filepath}")
            
            # Also save steps to a separate file if provided
            steps_filepath = None
            if steps:
                steps_filename = f"steps_{safe_target}_vs_{safe_base}.md"
                steps_filepath = analysis_dir / steps_filename
                with open(steps_filepath, 'w', encoding='utf-8') as f:
                    f.write(f"# Problem-Solving Steps: {target_branch} vs {base_branch}\n\n")
                    f.write(steps)
                TerminalUI.print_success(f"Steps saved to: {steps_filepath}")
                
            return filepath, steps_filepath
            
        except Exception as e:
            TerminalUI.print_warning(f"Could not save to file: {str(e)}")
            raise CodeReviewError(f"Failed to save analysis: {str(e)}")
    
    @staticmethod
    def read_file_content(filepath: Path) -> str:
        """Read file content with error handling"""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                return f.read()
        except FileNotFoundError:
            raise CodeReviewError(f"File not found: {filepath}")
        except Exception as e:
            raise CodeReviewError(f"Failed to read file {filepath}: {str(e)}")
    
    @staticmethod
    def write_file_content(filepath: Path, content: str) -> None:
        """Write file content with error handling"""
        try:
            # Ensure parent directory exists
            FileOperations.ensure_directory_exists(filepath.parent)
            
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        except Exception as e:
            raise CodeReviewError(f"Failed to write file {filepath}: {str(e)}")
    
    @staticmethod
    def create_temp_file(content: str, suffix: str = ".txt") -> str:
        """Create a temporary file with content"""
        try:
            with tempfile.NamedTemporaryFile(mode='w', suffix=suffix, delete=False, encoding='utf-8') as f:
                f.write(content)
                return f.name
        except Exception as e:
            raise CodeReviewError(f"Failed to create temporary file: {str(e)}")
    
    @staticmethod
    def file_exists(filepath: Path) -> bool:
        """Check if file exists"""
        return filepath.exists() and filepath.is_file()
    
    @staticmethod
    def get_file_size(filepath: Path) -> int:
        """Get file size in bytes"""
        try:
            return filepath.stat().st_size
        except Exception:
            return 0 