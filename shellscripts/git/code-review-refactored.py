#!/usr/bin/env python3
"""
Wrapper script for the refactored AI-Powered Code Review Tool.
"""

import sys
import os
from pathlib import Path

# Add the code_review_tool package to the Python path
tool_dir = Path(__file__).parent / "code_review_tool"
sys.path.insert(0, str(tool_dir.parent))

# Import and run the main function
try:
    from code_review_tool.main import main
    main()
except ImportError as e:
    print(f"Error importing code review tool: {e}")
    print("Make sure all dependencies are installed:")
    print("  pip install anthropic pyyaml")
    sys.exit(1)
except Exception as e:
    print(f"Error running code review tool: {e}")
    sys.exit(1) 