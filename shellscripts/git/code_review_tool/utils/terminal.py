"""
Terminal UI utilities for consistent colored output and user interaction.
"""

from typing import Optional


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


class TerminalUI:
    """Terminal user interface utilities"""
    
    @staticmethod
    def print_colored(message: str, color: str = Colors.ENDC) -> None:
        """Print colored message to terminal"""
        print(f"{color}{message}{Colors.ENDC}")
    
    @staticmethod
    def print_header(message: str) -> None:
        """Print a header message"""
        TerminalUI.print_colored(message, Colors.HEADER)
    
    @staticmethod
    def print_success(message: str) -> None:
        """Print a success message"""
        TerminalUI.print_colored(message, Colors.OKGREEN)
    
    @staticmethod
    def print_info(message: str) -> None:
        """Print an info message"""
        TerminalUI.print_colored(message, Colors.OKBLUE)
    
    @staticmethod
    def print_warning(message: str) -> None:
        """Print a warning message"""
        TerminalUI.print_colored(message, Colors.WARNING)
    
    @staticmethod
    def print_error(message: str) -> None:
        """Print an error message"""
        TerminalUI.print_colored(message, Colors.FAIL)
    
    @staticmethod
    def print_cyan(message: str) -> None:
        """Print a cyan message"""
        TerminalUI.print_colored(message, Colors.OKCYAN)
    
    @staticmethod
    def print_section_header(title: str) -> None:
        """Print a section header with decorative lines"""
        TerminalUI.print_header(title)
        TerminalUI.print_header("=" * len(title))
    
    @staticmethod
    def print_subsection_header(title: str) -> None:
        """Print a subsection header with decorative lines"""
        TerminalUI.print_header(title)
        TerminalUI.print_header("-" * len(title))
    
    @staticmethod
    def confirm_action(message: str) -> bool:
        """Ask user for confirmation"""
        while True:
            choice = input(f"{message} [y/n]: ").lower().strip()
            if choice in ['y', 'yes']:
                return True
            elif choice in ['n', 'no']:
                return False
            else:
                TerminalUI.print_warning("Please enter 'y' (yes) or 'n' (no)")
    
    @staticmethod
    def get_user_choice(message: str, choices: list, allow_quit: bool = True) -> Optional[str]:
        """Get user choice from a list of options"""
        choices_str = "/".join(choices)
        if allow_quit:
            choices_str += "/q"
        
        while True:
            choice = input(f"{message} [{choices_str}]: ").lower().strip()
            if choice in choices:
                return choice
            elif allow_quit and choice in ['q', 'quit']:
                return None
            else:
                valid_choices = choices + (['q', 'quit'] if allow_quit else [])
                TerminalUI.print_warning(f"Please enter one of: {', '.join(valid_choices)}")
    
    @staticmethod
    def print_progress(current: int, total: int, message: str) -> None:
        """Print progress information"""
        TerminalUI.print_info(f"{message} ({current}/{total})")
    
    @staticmethod
    def print_file_info(filename: str, line_number: Optional[int] = None) -> None:
        """Print file information in a consistent format"""
        if line_number:
            TerminalUI.print_cyan(f"File: {filename}:{line_number}")
        else:
            TerminalUI.print_cyan(f"File: {filename}")
    
    @staticmethod
    def print_analysis_summary(
        risk_level: str, 
        deployment_ready: str, 
        files_changed: int, 
        lines_changed: int
    ) -> None:
        """Print analysis summary information"""
        TerminalUI.print_section_header("Analysis Summary")
        TerminalUI.print_info(f"Risk Level: {risk_level}")
        TerminalUI.print_info(f"Deployment Ready: {deployment_ready}")
        TerminalUI.print_info(f"Files Changed: {files_changed}")
        TerminalUI.print_info(f"Lines Changed: {lines_changed}")
        print()  # Add spacing 