"""
Configuration management for the code review tool.
"""

import os
import yaml
from pathlib import Path
from typing import Dict, Any, Optional
from ..core.models import AnalysisConfig, PromptInfo
from ..utils.error_handling import ConfigurationError


class ConfigManager:
    """Manages configuration loading and validation"""
    
    def __init__(self, config_path: Optional[Path] = None):
        """Initialize configuration manager"""
        if config_path is None:
            # Default to config file in same directory as this module
            config_path = Path(__file__).parent / "settings.yaml"
        
        self.config_path = config_path
        self._config_data: Optional[Dict[str, Any]] = None
        self._prompts_cache: Optional[Dict[str, PromptInfo]] = None
    
    def _load_config_file(self) -> Dict[str, Any]:
        """Load configuration from YAML file"""
        if self._config_data is not None:
            return self._config_data
        
        try:
            if not self.config_path.exists():
                raise ConfigurationError(f"Configuration file not found: {self.config_path}")
            
            with open(self.config_path, 'r', encoding='utf-8') as f:
                self._config_data = yaml.safe_load(f)
            
            if not self._config_data:
                raise ConfigurationError("Configuration file is empty")
            
            return self._config_data
            
        except yaml.YAMLError as e:
            raise ConfigurationError(f"Invalid YAML in configuration file: {str(e)}")
        except Exception as e:
            raise ConfigurationError(f"Failed to load configuration: {str(e)}")
    
    def get_analysis_config(self) -> AnalysisConfig:
        """Get analysis configuration"""
        config_data = self._load_config_file()
        analysis_config = config_data.get('analysis', {})
        
        # Get API key from environment
        api_key = os.getenv("ANTHROPIC_API_KEY")
        if not api_key:
            raise ConfigurationError("ANTHROPIC_API_KEY environment variable not set")
        
        return AnalysisConfig(
            anthropic_api_key=api_key,
            default_base_branch=analysis_config.get('default_base_branch', 'staging'),
            model=analysis_config.get('model', 'claude-sonnet-4-20250514'),
            max_tokens=analysis_config.get('max_tokens', 190000),
            chunk_overlap=analysis_config.get('chunk_overlap', 500),
            min_chunk_size=analysis_config.get('min_chunk_size', 1000),
            max_file_size=analysis_config.get('max_file_size', 10000),
            allow_chunking=analysis_config.get('allow_chunking', True)
        )
    
    def get_available_prompts(self) -> Dict[str, PromptInfo]:
        """Get available prompts configuration"""
        if self._prompts_cache is not None:
            return self._prompts_cache
        
        config_data = self._load_config_file()
        prompts_config = config_data.get('prompts', {})
        available_prompts = prompts_config.get('available', {})
        
        prompts = {}
        prompts_dir = Path(__file__).parent.parent / "prompts"
        
        for key, prompt_config in available_prompts.items():
            # Load prompt template from file
            prompt_file = prompts_dir / prompt_config['file']
            try:
                if prompt_file.exists():
                    with open(prompt_file, 'r', encoding='utf-8') as f:
                        prompt_template = f.read()
                else:
                    # Fallback to inline template if file doesn't exist
                    prompt_template = prompt_config.get('template', '')
                    if not prompt_template:
                        raise ConfigurationError(f"Prompt file not found and no inline template: {prompt_file}")
                
                prompts[key] = PromptInfo(
                    name=prompt_config['name'],
                    description=prompt_config['description'],
                    prompt_template=prompt_template
                )
            except Exception as e:
                raise ConfigurationError(f"Failed to load prompt '{key}': {str(e)}")
        
        self._prompts_cache = prompts
        return prompts
    
    def get_default_prompt_key(self) -> str:
        """Get the default prompt key"""
        config_data = self._load_config_file()
        prompts_config = config_data.get('prompts', {})
        return prompts_config.get('default', 'react-native')
    
    def get_github_config(self) -> Dict[str, Any]:
        """Get GitHub integration configuration"""
        config_data = self._load_config_file()
        return config_data.get('github', {
            'require_cli': True,
            'auto_comment': False,
            'max_comments_per_pr': 20
        })
    
    def get_output_config(self) -> Dict[str, Any]:
        """Get output configuration"""
        config_data = self._load_config_file()
        return config_data.get('output', {
            'analysis_dir': 'analysis',
            'save_steps_separately': True,
            'include_metadata': True
        })
    
    def validate_prompt_key(self, prompt_key: str) -> bool:
        """Validate that a prompt key exists"""
        available_prompts = self.get_available_prompts()
        return prompt_key in available_prompts
    
    def get_prompt_info(self, prompt_key: str) -> PromptInfo:
        """Get specific prompt information"""
        available_prompts = self.get_available_prompts()
        if prompt_key not in available_prompts:
            raise ConfigurationError(f"Unknown prompt key: {prompt_key}")
        return available_prompts[prompt_key]
    
    def list_available_prompts(self) -> Dict[str, str]:
        """Get a simple mapping of prompt keys to descriptions"""
        available_prompts = self.get_available_prompts()
        return {
            key: prompt.description 
            for key, prompt in available_prompts.items()
        }
    
    @classmethod
    def create_default_config(cls, config_path: Path) -> None:
        """Create a default configuration file"""
        default_config = {
            'analysis': {
                'max_tokens': 190000,
                'chunk_overlap': 500,
                'min_chunk_size': 1000,
                'default_base_branch': 'staging',
                'model': 'claude-sonnet-4-20250514',
                'max_file_size': 10000,
                'allow_chunking': True
            },
            'prompts': {
                'default': 'react-native',
                'available': {
                    'general': {
                        'name': 'General Code Review',
                        'description': 'General purpose code review',
                        'file': 'general.txt'
                    }
                }
            },
            'github': {
                'require_cli': True,
                'auto_comment': False,
                'max_comments_per_pr': 20
            },
            'output': {
                'analysis_dir': 'analysis',
                'save_steps_separately': True,
                'include_metadata': True
            }
        }
        
        try:
            config_path.parent.mkdir(parents=True, exist_ok=True)
            with open(config_path, 'w', encoding='utf-8') as f:
                yaml.dump(default_config, f, default_flow_style=False, indent=2)
        except Exception as e:
            raise ConfigurationError(f"Failed to create default config: {str(e)}") 