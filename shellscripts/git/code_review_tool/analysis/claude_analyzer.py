"""
Claude AI integration for code analysis.
"""

import anthropic
from typing import List, Dict, Any
from ..core.models import AnalysisConfig, DiffChunk, PromptInfo
from ..utils.error_handling import AnalysisError, with_analysis_error_handling
from ..utils.terminal import TerminalUI
from .chunker import DiffChunker


class ClaudeAnalyzer:
    """Handles Claude AI integration for code analysis"""
    
    def __init__(self, config: AnalysisConfig):
        """Initialize Claude analyzer with configuration"""
        self.config = config
        self.client = anthropic.Anthropic(api_key=config.anthropic_api_key)
        self.chunker = DiffChunker(config.max_tokens, config.max_file_size)
    
    @with_analysis_error_handling
    def analyze_diff(
        self, 
        diff: str, 
        prompt_info: PromptInfo, 
        base_branch: str, 
        target_branch: str
    ) -> str:
        """Analyze diff using Claude AI"""
        TerminalUI.print_info(f"Using '{prompt_info.name}' prompt...")
        
        # Check if diff needs chunking
        estimated_tokens = self.chunker.estimate_token_count(diff)
        TerminalUI.print_info(f"Estimated tokens: {estimated_tokens:,}")
        
        if self.chunker.needs_chunking(diff):
            if self.config.allow_chunking:
                TerminalUI.print_warning(f"Large diff detected ({estimated_tokens:,} tokens). Chunking analysis...")
                return self._analyze_large_diff_chunked(diff, prompt_info, base_branch, target_branch)
            else:
                TerminalUI.print_warning(f"Large diff detected ({estimated_tokens:,} tokens) but chunking disabled. Truncating...")
                # Truncate to fit
                available_chars = (self.config.max_tokens - 5000) * 4  # Reserve tokens and convert to chars
                if len(diff) > available_chars:
                    diff = diff[:available_chars] + "\n\n... [TRUNCATED - diff too large]"
        
        TerminalUI.print_info("Sending to Claude for analysis...")
        
        try:
            # Enhance diff with context for better line number understanding
            enhanced_diff = self._enhance_diff_with_context(diff)
            
            prompt = prompt_info.prompt_template.format(
                base_branch=base_branch,
                target_branch=target_branch,
                git_diff=enhanced_diff
            )
            
            response = self.client.messages.create(
                model=self.config.model,
                max_tokens=4000,
                temperature=0.1,
                messages=[{
                    "role": "user",
                    "content": prompt
                }]
            )
            
            return response.content[0].text
            
        except Exception as e:
            raise AnalysisError(f"Claude API error: {str(e)}")
    
    def _analyze_large_diff_chunked(
        self, 
        diff: str, 
        prompt_info: PromptInfo, 
        base_branch: str, 
        target_branch: str
    ) -> str:
        """Analyze large diff by breaking it into chunks"""
        chunks = self.chunker.chunk_diff_intelligently(diff)
        
        if len(chunks) == 1:
            TerminalUI.print_warning("Single chunk still too large, attempting analysis with truncation")
            return self.analyze_diff(chunks[0].content, prompt_info, base_branch, target_branch)
        
        TerminalUI.print_info(f"Analyzing in {len(chunks)} chunks...")
        
        chunk_analyses = []
        
        for chunk in chunks:
            TerminalUI.print_progress(chunk.chunk_number, chunk.total_chunks, "Analyzing chunk")
            
            try:
                # Create chunk-specific prompt
                enhanced_chunk = self._enhance_diff_with_context(chunk.content)
                chunk_prompt = self._create_chunk_prompt(
                    prompt_info, base_branch, target_branch, enhanced_chunk, 
                    chunk.chunk_number, chunk.total_chunks
                )
                
                response = self.client.messages.create(
                    model=self.config.model,
                    max_tokens=3000,  # Slightly less for chunks
                    temperature=0.1,
                    messages=[{
                        "role": "user",
                        "content": chunk_prompt
                    }]
                )
                
                chunk_analyses.append({
                    'chunk_number': chunk.chunk_number,
                    'file_paths': chunk.file_paths,
                    'analysis': response.content[0].text
                })
                
            except Exception as e:
                TerminalUI.print_error(f"Error analyzing chunk {chunk.chunk_number}: {str(e)}")
                chunk_analyses.append({
                    'chunk_number': chunk.chunk_number,
                    'file_paths': chunk.file_paths,
                    'analysis': f"Error analyzing this chunk: {str(e)}"
                })
        
        # Merge analyses
        return self._merge_chunk_analyses(chunk_analyses, base_branch, target_branch)
    
    def _create_chunk_prompt(
        self, 
        prompt_info: PromptInfo, 
        base_branch: str, 
        target_branch: str, 
        chunk_diff: str, 
        chunk_num: int, 
        total_chunks: int
    ) -> str:
        """Create a chunk-specific prompt"""
        chunk_context = f"""
## CHUNK ANALYSIS ({chunk_num} of {total_chunks})

This is part {chunk_num} of {total_chunks} of a large code review. Focus on analyzing this specific subset of changes.

IMPORTANT: 
- This is a partial analysis - only comment on the code changes present in this chunk
- Use file:line references specific to the changes shown
- Be concise but thorough for the changes present
- Note if any changes appear to be dependent on code not shown in this chunk

"""
        
        # Use a simplified version of the main prompt for chunks
        simplified_prompt = f"""
You are a senior software engineer reviewing code changes.

## Task
Analyze the code changes in this chunk between {base_branch} and {target_branch}.

## Output Format (Simplified for Chunk)

### Chunk {chunk_num} Analysis

#### 🔍 **Critical Issues** (This Chunk)
- [List critical issues with file:line references]

#### ⚠️ **Warnings** (This Chunk)  
- [List warnings with file:line references]

#### ✅ **Improvements** (This Chunk)
- [List positive changes with file:line references]

#### 📁 **Files in This Chunk**
- [Brief analysis of each file changed in this chunk]

---

{chunk_context}

Here are the changes in this chunk:

```diff
{chunk_diff}
```

Provide analysis for this chunk only.
"""
        
        return simplified_prompt
    
    def _merge_chunk_analyses(self, chunk_analyses: List[Dict], base_branch: str, target_branch: str) -> str:
        """Merge multiple chunk analyses into a single comprehensive report"""
        
        merged_report = f"""# Comprehensive Code Review: {target_branch} vs {base_branch}

## Executive Summary
**Analysis Method**: Large diff analyzed in {len(chunk_analyses)} chunks
**Risk Level**: [Determined from individual chunk analyses]
**Deployment Ready**: [Review individual chunk findings]

## Chunk-by-Chunk Analysis

"""
        
        # Add each chunk analysis
        for chunk_data in chunk_analyses:
            merged_report += f"""
### Chunk {chunk_data['chunk_number']} Analysis

**Files in this chunk**: {', '.join(chunk_data['file_paths'])}

{chunk_data['analysis']}

---

"""
        
        # Add combined summary
        merged_report += """
## Combined Summary

⚠️  **Large PR Notice**: This analysis was performed on a large diff split into multiple chunks. 
Please review each chunk section above for complete coverage.

### Recommended Next Steps:
1. Review each chunk analysis individually
2. Focus on critical issues identified across all chunks
3. Consider breaking this large PR into smaller, focused PRs for easier review
4. Ensure integration testing covers interactions between components changed in different chunks

### For Future PRs:
- Consider smaller, more focused changes
- Break large features into multiple PRs
- Use feature flags for incremental rollouts
"""
        
        return merged_report
    
    def _enhance_diff_with_context(self, diff: str) -> str:
        """Add helpful context about diff format for Claude"""
        context = """
## Git Diff Format Guide
- Lines starting with `---` show the original file path
- Lines starting with `+++` show the new file path  
- Lines starting with `@@` show line number ranges: `@@ -old_start,old_count +new_start,new_count @@`
- Lines starting with `-` are removed lines
- Lines starting with `+` are added lines
- Lines with no prefix are context/unchanged lines

When referencing changes, use the NEW line numbers (from the `+new_start` in the @@ headers).

---

"""
        return context + diff
    
    @with_analysis_error_handling
    def generate_problem_solving_steps(
        self, 
        analysis: str, 
        base_branch: str, 
        target_branch: str
    ) -> str:
        """Generate problem-solving steps based on the code review analysis"""
        TerminalUI.print_info("Generating problem-solving steps...")
        
        try:
            # Extract problem statement from analysis
            problem = self._extract_problems_from_analysis(analysis, base_branch, target_branch)
            
            # Use the full analysis as supporting information
            supporting_info = f"""
## Code Review Analysis Results

The following is a complete code review analysis comparing {target_branch} branch against {base_branch} branch:

{analysis}

## Branch Context
- **Base Branch**: {base_branch}
- **Target Branch**: {target_branch}
- **Review Type**: AI-powered code review using Claude

## Key Areas to Address
Focus on resolving critical issues first, then warnings, and finally implementing recommended improvements.
"""
            
            prompt = self._get_problem_solving_prompt().format(
                problem=problem,
                supporting_info=supporting_info
            )
            
            response = self.client.messages.create(
                model=self.config.model,
                max_tokens=4000,
                temperature=0.1,
                messages=[{
                    "role": "user",
                    "content": prompt
                }]
            )
            
            return response.content[0].text
            
        except Exception as e:
            raise AnalysisError(f"Failed to generate problem-solving steps: {str(e)}")
    
    def _extract_problems_from_analysis(self, analysis: str, base_branch: str, target_branch: str) -> str:
        """Extract key problems and issues from the code review analysis to create a problem statement"""
        
        # Extract the critical issues and warnings sections
        lines = analysis.split('\n')
        critical_issues = []
        warnings = []
        
        in_critical = False
        in_warnings = False
        
        for line in lines:
            if '🔍 **Critical Issues**' in line or 'Critical Issues' in line:
                in_critical = True
                in_warnings = False
                continue
            elif '⚠️ **Warnings**' in line or 'Warnings' in line:
                in_critical = False
                in_warnings = True
                continue
            elif line.startswith('####') or line.startswith('###'):
                in_critical = False
                in_warnings = False
                continue
                
            if in_critical and line.strip() and not line.startswith('#'):
                critical_issues.append(line.strip())
            elif in_warnings and line.strip() and not line.startswith('#'):
                warnings.append(line.strip())
        
        # Create problem statement
        problem_parts = []
        
        if critical_issues:
            problem_parts.append("Critical issues identified in code review that must be resolved before merging:")
            problem_parts.extend([f"- {issue}" for issue in critical_issues[:5]])  # Limit to top 5
            
        if warnings:
            problem_parts.append("\nAdditional warnings that should be addressed:")
            problem_parts.extend([f"- {warning}" for warning in warnings[:5]])  # Limit to top 5
        
        if not problem_parts:
            problem_parts.append(f"Code review completed for changes between {base_branch} and {target_branch}. Need to implement recommended improvements and ensure code quality standards are met.")
        
        return "\n".join(problem_parts)
    
    def _get_problem_solving_prompt(self) -> str:
        """Get the problem-solving prompt template"""
        return """
Create me a prompt that helps an ai agent work through a problem statement. Use the example as the returned format and the supporting docs attached to give as much information needed. Then create a list of steps to solve the problem.

The Problem: {problem}
Supporting information: {supporting_info}

Return in the following format:

# Problem

# Supporting Information

# Steps to Complete

<example>
## Problem

We want to set up a new MCP server, written in TypeScript. We are starting from an empty directory.

We are writing this in Cursor, so recording the important files in a `.cursor/rules/important-files.mdc` file is important.

We need to set up the basic file system for the project, install necessary dependencies, and set up the project structure.

## Supporting Information

### Tools

#### `pnpm`

Use `pnpm` as the package manager.

### File Structure

Recommended file structure:

#### `.cursor/rules/important-files.mdc`

A file that lists the important files for the project, which should be included in every chat.

Use the `mdc` format, which is a markdown format with these frontmatter fields:

```md
---
globs: **/**
alwaysApply: true
---

...content goes here...
```

Make sure to add a directive at the end of the file that if new files are added, they should be added to the `important-files.mdc` file.

#### `package.json`

The package.json file for the project.

Recommended scripts:

`build`: Builds the project using `tsc`.
`dev`: Runs the project in development mode using `tsx watch src/main.ts`.

Dependencies:

- `@modelcontextprotocol/sdk`: The MCP SDK. Latest version is `0.9.0`.
- `zod`: A schema declaration and validation library for TypeScript.

Dev dependencies:

- `tsx`: A faster version of `ts-node` that is optimized for the CLI.
- `typescript`: The TypeScript compiler, latest version: `5.8`
- `@types/node`: The types for Node.js, for 22+

`bin` should be set to `dist/main.js`.

`type` should be set to `module`.

#### `tsconfig.json`

The TypeScript configuration file for the project. Here is the recommended configuration from Matt Pocock's TSConfig cheat sheet.

```jsonc
{{
  "compilerOptions": {{
    /* Base Options: */
    "esModuleInterop": true,
    "skipLibCheck": true,
    "target": "es2022",
    "allowJs": true,
    "resolveJsonModule": true,
    "moduleDetection": "force",
    "isolatedModules": true,
    "verbatimModuleSyntax": true,

    /* Strictness */
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,

    /* If transpiling with TypeScript: */
    "module": "NodeNext",
    "outDir": "dist",
    "rootDir": "src",
    "sourceMap": true,

    /* AND if you're building for a library: */
    "declaration": true,

    /* If your code doesn't run in the DOM: */
    "lib": ["es2022"]
  }},
  "include": ["src"]
}}
```

#### `src/main.ts`

The entry point for the project.

```ts
import {{
  McpServer,
  ResourceTemplate,
}} from "@modelcontextprotocol/sdk/server/mcp.js";
import {{ StdioServerTransport }} from "@modelcontextprotocol/sdk/server/stdio.js";
import {{ z }} from "zod";

// Create an MCP server
const server = new McpServer({{
  name: "Demo",
  version: "1.0.0",
}});

// Add an addition tool
server.tool("add", {{ a: z.number(), b: z.number() }}, async ({{ a, b }}) => ({{
  content: [{{ type: "text", text: String(a + b) }}],
}}));

// Add a dynamic greeting resource
server.resource(
  "greeting",
  new ResourceTemplate("greeting://{{name}}", {{ list: undefined }}),
  async (uri, {{ name }}) => ({{
    contents: [
      {{
        uri: uri.href,
        text: `Hello, ${{name}}!`,
      }},
    ],
  }})
);

// Start receiving messages on stdin and sending messages on stdout
const transport = new StdioServerTransport();
await server.connect(transport);
```

#### `.gitignore`

A file that lists the files to ignore in the project. `dist` should be ignored since it is the output directory.

## Steps To Complete

- Create the `package.json` file with the recommended scripts and dependencies.
- Use a `pnpm add` command to install the dependencies so that they are pinned to the current version. Do NOT use `latest` or `next`.
- Install the dependencies.
- Create the `tsconfig.json` file with the recommended configuration.
- Create the other files described above.
- Run `pnpm build` to build the project.
</example>
""" 