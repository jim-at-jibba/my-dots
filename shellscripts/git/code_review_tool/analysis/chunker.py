"""
Diff chunking logic for handling large code changes.
"""

from typing import List, Tuple
from ..core.models import DiffChunk
from ..utils.terminal import TerminalUI


class DiffChunker:
    """Handles chunking of large diffs for analysis"""
    
    def __init__(self, max_tokens: int, max_file_size: int):
        """Initialize chunker with token and file size limits"""
        self.max_tokens = max_tokens
        self.max_file_size = max_file_size
    
    def estimate_token_count(self, text: str) -> int:
        """Rough estimation of token count (approximately 4 characters per token)"""
        return len(text) // 4
    
    def needs_chunking(self, diff: str) -> bool:
        """Check if diff needs to be chunked"""
        estimated_tokens = self.estimate_token_count(diff)
        return estimated_tokens > self.max_tokens
    
    def filter_large_files(self, diff: str) -> Tuple[str, List[str]]:
        """Filter out extremely large file changes from diff"""
        lines = diff.split('\n')
        filtered_lines = []
        current_file = None
        current_file_lines = []
        skipped_files = []
        
        for line in lines:
            if line.startswith('diff --git'):
                # Process previous file
                if current_file and len(current_file_lines) > self.max_file_size:
                    skipped_files.append(current_file)
                    # Add a summary instead
                    filtered_lines.append(f"diff --git {current_file}")
                    filtered_lines.append(f"# LARGE FILE SKIPPED: {len(current_file_lines)} lines")
                    filtered_lines.append(f"# File too large for analysis - review manually")
                elif current_file:
                    filtered_lines.extend(current_file_lines)
                
                # Start new file
                current_file = line.split(' ')[-1] if ' ' in line else line
                current_file_lines = [line]
            else:
                current_file_lines.append(line)
        
        # Process last file
        if current_file and len(current_file_lines) > self.max_file_size:
            skipped_files.append(current_file)
            filtered_lines.append(f"diff --git {current_file}")
            filtered_lines.append(f"# LARGE FILE SKIPPED: {len(current_file_lines)} lines")
        elif current_file:
            filtered_lines.extend(current_file_lines)
        
        return '\n'.join(filtered_lines), skipped_files
    
    def split_diff_by_files(self, diff: str) -> List[dict]:
        """Split diff into individual file chunks"""
        files = []
        lines = diff.split('\n')
        current_file = None
        current_content = []
        
        for line in lines:
            if line.startswith('diff --git'):
                # Save previous file
                if current_file:
                    files.append({
                        'file': current_file,
                        'content': '\n'.join(current_content),
                        'line_count': len(current_content)
                    })
                
                # Start new file
                current_file = line.split(' ')[-1] if ' ' in line else "unknown"
                current_content = [line]
            else:
                current_content.append(line)
        
        # Add last file
        if current_file:
            files.append({
                'file': current_file,
                'content': '\n'.join(current_content),
                'line_count': len(current_content)
            })
        
        return files
    
    def chunk_diff_intelligently(self, diff: str) -> List[DiffChunk]:
        """Split diff into chunks that fit within token limits"""
        # First, try filtering large files
        filtered_diff, skipped_files = self.filter_large_files(diff)
        
        if skipped_files:
            TerminalUI.print_warning(
                f"Skipped {len(skipped_files)} large files: "
                f"{', '.join(skipped_files[:3])}{'...' if len(skipped_files) > 3 else ''}"
            )
        
        # Check if filtered diff fits
        if not self.needs_chunking(filtered_diff):
            return [DiffChunk(
                content=filtered_diff,
                file_paths=self._extract_file_paths(filtered_diff),
                estimated_tokens=self.estimate_token_count(filtered_diff),
                chunk_number=1,
                total_chunks=1
            )]
        
        # Split by files and group into chunks
        file_chunks = self.split_diff_by_files(filtered_diff)
        chunks = []
        current_chunk = ""
        current_chunk_tokens = 0
        current_files = []
        
        # Reserve tokens for prompt template
        available_tokens = self.max_tokens - 5000  # Reserve for prompt overhead
        
        for file_data in file_chunks:
            file_content = file_data['content']
            file_tokens = self.estimate_token_count(file_content)
            
            # If single file is too large, skip it
            if file_tokens > available_tokens * 0.8:
                TerminalUI.print_warning(f"Skipping large file: {file_data['file']} ({file_tokens} tokens)")
                continue
            
            # If adding this file would exceed limit, start new chunk
            if current_chunk_tokens + file_tokens > available_tokens and current_chunk:
                chunks.append(DiffChunk(
                    content=current_chunk,
                    file_paths=current_files.copy(),
                    estimated_tokens=current_chunk_tokens,
                    chunk_number=len(chunks) + 1,
                    total_chunks=0  # Will be set later
                ))
                current_chunk = file_content
                current_chunk_tokens = file_tokens
                current_files = [file_data['file']]
            else:
                current_chunk += "\n\n" + file_content if current_chunk else file_content
                current_chunk_tokens += file_tokens
                current_files.append(file_data['file'])
        
        # Add final chunk
        if current_chunk:
            chunks.append(DiffChunk(
                content=current_chunk,
                file_paths=current_files,
                estimated_tokens=current_chunk_tokens,
                chunk_number=len(chunks) + 1,
                total_chunks=0  # Will be set later
            ))
        
        # Update total_chunks for all chunks
        total_chunks = len(chunks)
        for chunk in chunks:
            chunk.total_chunks = total_chunks
        
        # Fallback if no chunks created
        if not chunks:
            # Truncate the original diff
            truncated_content = filtered_diff[:available_tokens * 4]  # Convert tokens to chars
            chunks.append(DiffChunk(
                content=truncated_content + "\n\n... [TRUNCATED - diff too large]",
                file_paths=self._extract_file_paths(truncated_content),
                estimated_tokens=available_tokens,
                chunk_number=1,
                total_chunks=1
            ))
        
        return chunks
    
    def _extract_file_paths(self, diff_content: str) -> List[str]:
        """Extract file paths from diff content"""
        file_paths = []
        for line in diff_content.split('\n'):
            if line.startswith('diff --git'):
                # Extract file path from diff header
                parts = line.split(' ')
                if len(parts) >= 4:
                    file_path = parts[-1]  # Take the last part (new file path)
                    if file_path.startswith('b/'):
                        file_path = file_path[2:]  # Remove 'b/' prefix
                    file_paths.append(file_path)
        return file_paths 