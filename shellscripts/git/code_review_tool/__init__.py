"""
AI-Powered Code Review Tool

A refactored, modular code review tool that uses Claude AI to analyze git diffs
and provide comprehensive code reviews with GitHub integration.
"""

__version__ = "2.0.0"
__author__ = "James Best"

from .core.orchestrator import AnalysisOrchestrator
from .core.models import AnalysisConfig, AnalysisResult
from .config.config_manager import ConfigManager

__all__ = [
    "AnalysisOrchestrator",
    "AnalysisConfig", 
    "AnalysisResult",
    "ConfigManager"
] 