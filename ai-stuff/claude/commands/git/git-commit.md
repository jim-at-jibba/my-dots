# Smart Git Commit Command

Intelligently analyze changes and create conventional commits, grouping related changes into separate commits.

## Instructions

Analyze the current repository state and create appropriate conventional commits based on change patterns: **$ARGUMENTS**

1. **Repository Analysis**
   - Check git status and identify all changes
   - Analyze file paths and change types to determine logical groupings
   - Identify conventional commit types based on file patterns

   ```bash
   # Get current status and changes
   git status --porcelain
   git diff --name-status
   git diff --stat
   ```

2. **Change Categorization**
   Group changes based on these patterns:
   - **feat**: New features, major additions
   - **fix**: Bug fixes, corrections
   - **refactor**: Code restructuring without functional changes  
   - **chore**: Maintenance, cleanup, deletions
   - **docs**: Documentation changes
   - **style**: Formatting, whitespace
   - **config**: Configuration file changes
   - **remove**: File deletions and removals

3. **Intelligent Grouping Logic**
   ```bash
   # Function to categorize files
   categorize_changes() {
       local status_output="$1"
       
       # Initialize arrays for different change types
       declare -A change_groups
       
       while IFS= read -r line; do
           local status="${line:0:2}"
           local file="${line:3}"
           
           # Determine category based on file path and change type
           case "$file" in
               **/test*|**/*test*|**/*.test.*|**/*spec*)
                   change_groups["test"]+="$file "
                   ;;
               **/doc*|**/*.md|**/README*)
                   change_groups["docs"]+="$file "
                   ;;
               **/.config/**|**/config/**|**/*rc|**/.env*|**/setup-*)
                   change_groups["config"]+="$file "
                   ;;
               **/lua/**|**/*.lua)
                   change_groups["config"]+="$file "
                   ;;
               **/hooks/**|**/utils/**)
                   change_groups["feat"]+="$file "
                   ;;
               **/scripts/**|**/*.sh)
                   change_groups["chore"]+="$file "
                   ;;
           esac
           
           # Categorize by git status
           case "$status" in
               "D "|\\ D)
                   change_groups["remove"]+="$file "
                   ;;
               "A "|\\ A|"??")
                   change_groups["feat"]+="$file "
                   ;;
               "M "|\\ M)
                   # Keep existing category or default to refactor
                   if [[ -z "${change_groups["feat"]} ${change_groups["fix"]} ${change_groups["config"]}" ]]; then
                       change_groups["refactor"]+="$file "
                   fi
                   ;;
           esac
       done <<< "$status_output"
       
       # Output categorized changes
       for category in "${!change_groups[@]}"; do
           if [[ -n "${change_groups[$category]}" ]]; then
               echo "$category:${change_groups[$category]}"
           fi
       done
   }
   ```

4. **Smart Commit Message Generation**
   ```bash
   # Generate conventional commit messages
   generate_commit_message() {
       local type="$1"
       local files="$2"
       local scope=""
       local description=""
       
       # Determine scope from file paths
       if echo "$files" | grep -q "lua/"; then
           scope="nvim"
       elif echo "$files" | grep -q "claude/"; then
           scope="ai"
       elif echo "$files" | grep -q "shell"; then
           scope="shell"
       elif echo "$files" | grep -q "zsh"; then
           scope="zsh"
       fi
       
       # Generate description based on type and files
       case "$type" in
           feat)
               if [[ "$scope" == "ai" ]]; then
                   description="add new AI/Claude functionality"
               elif [[ "$scope" == "nvim" ]]; then
                   description="add new Neovim configuration"
               else
                   description="add new features"
               fi
               ;;
           fix)
               description="resolve issues and bugs"
               ;;
           refactor)
               description="improve code structure and organization"
               ;;
           chore)
               if echo "$files" | grep -q "setup"; then
                   description="update setup and installation scripts"
               else
                   description="update maintenance tasks"
               fi
               ;;
           config)
               if [[ "$scope" == "nvim" ]]; then
                   description="update Neovim configuration"
               elif [[ "$scope" == "zsh" ]]; then
                   description="update shell configuration"
               else
                   description="update configuration files"
               fi
               ;;
           remove)
               description="clean up unused files and commands"
               ;;
           docs)
               description="update documentation"
               ;;
       esac
       
       # Format commit message
       if [[ -n "$scope" ]]; then
           echo "$type($scope): $description"
       else
           echo "$type: $description"
       fi
   }
   ```

5. **Execute Smart Commits**
   ```bash
   #!/bin/bash
   
   # Main execution function
   smart_git_commit() {
       echo "🔍 Analyzing repository changes..."
       
       # Get current status
       local git_status
       git_status=$(git status --porcelain)
       
       if [[ -z "$git_status" ]]; then
           echo "✅ No changes to commit"
           return 0
       fi
       
       echo "📋 Found changes:"
       echo "$git_status"
       echo ""
       
       # Categorize changes
       local categories
       categories=$(categorize_changes "$git_status")
       
       if [[ -z "$categories" ]]; then
           echo "❌ No categorizable changes found"
           return 1
       fi
       
       echo "🗂️  Change categories identified:"
       
       # Process each category
       local commit_count=0
       while IFS=':' read -r category files; do
           if [[ -n "$files" ]]; then
               echo "  📁 $category: $(echo $files | wc -w) files"
               
               # Generate commit message
               local commit_msg
               commit_msg=$(generate_commit_message "$category" "$files")
               
               # Stage files for this category
               echo "    Staging files: $files"
               for file in $files; do
                   git add "$file" 2>/dev/null || echo "    ⚠️  Could not stage: $file"
               done
               
               # Create commit
               echo "    📝 Creating commit: $commit_msg"
               if git commit -m "$commit_msg"; then
                   ((commit_count++))
                   echo "    ✅ Commit created successfully"
               else
                   echo "    ❌ Failed to create commit"
               fi
               echo ""
           fi
       done <<< "$categories"
       
       echo "🎉 Smart commit completed!"
       echo "📊 Created $commit_count commits"
       
       # Show final status
       echo ""
       echo "📋 Final repository status:"
       git status --short
   }
   
   # Run the smart commit
   smart_git_commit
   ```

6. **Advanced Features**
   
   **Dry Run Mode:**
   ```bash
   # Add --dry-run flag support
   if [[ "$1" == "--dry-run" ]] || [[ "$1" == "-n" ]]; then
       echo "🧪 DRY RUN MODE - No commits will be created"
       DRY_RUN=true
   fi
   
   # In commit section:
   if [[ "$DRY_RUN" == true ]]; then
       echo "    📝 Would create commit: $commit_msg"
       echo "    📁 Would stage files: $files"
   else
       # actual commit logic
   fi
   ```
   
   **Interactive Mode:**
   ```bash
   # Add --interactive flag
   if [[ "$1" == "--interactive" ]] || [[ "$1" == "-i" ]]; then
       echo "🤔 Review commit: $commit_msg"
       echo "📁 Files: $files"
       read -p "Create this commit? (y/n): " confirm
       if [[ "$confirm" =~ ^[Yy] ]]; then
           # create commit
       else
           echo "    ⏭️  Skipping commit"
       fi
   fi
   ```
   
   **Custom Grouping Rules:**
   ```bash
   # Support custom grouping via .gitcommit config file
   if [[ -f ".gitcommit" ]]; then
       echo "📖 Loading custom commit rules from .gitcommit"
       source .gitcommit
   fi
   ```

7. **Usage Examples**
   ```bash
   # Basic usage - analyze and commit all changes
   /git-commit
   
   # Dry run to see what would be committed
   /git-commit --dry-run
   
   # Interactive mode for manual approval
   /git-commit --interactive
   
   # Custom commit message prefix
   /git-commit --prefix "WIP: "
   ```

8. **Error Handling and Validation**
   ```bash
   # Validation checks
   validate_repository() {
       if ! git rev-parse --git-dir >/dev/null 2>&1; then
           echo "❌ Not in a git repository"
           return 1
       fi
       
       if git diff --cached --quiet && git diff --quiet; then
           echo "✅ No changes to commit"
           return 1
       fi
       
       return 0
   }
   
   # Pre-commit hooks integration
   run_pre_commit_checks() {
       if command -v pre-commit >/dev/null 2>&1; then
           echo "🔍 Running pre-commit hooks..."
           pre-commit run --all-files
       fi
   }
   ```

9. **Integration with Existing Workflow**
   ```bash
   # Support for conventional commit scopes from branch names
   get_scope_from_branch() {
       local branch
       branch=$(git branch --show-current)
       
       case "$branch" in
           feature/*|feat/*)
               echo "${branch#*/}" | cut -d'-' -f1
               ;;
           fix/*|bugfix/*)
               echo "${branch#*/}" | cut -d'-' -f1
               ;;
           *)
               echo ""
               ;;
       esac
   }
   ```

10. **Rollback and Recovery**
    ```bash
    # Provide rollback functionality
    if [[ "$1" == "--undo" ]]; then
        echo "🔄 Rolling back last smart commit session..."
        # Implementation for undoing the last set of commits
        # This would require tracking what was committed
    fi
    ```

**Configuration Options:**

Create a `.gitcommit` configuration file to customize behavior:
```bash
# Custom file patterns
FEAT_PATTERNS="src/**/*.new lib/**/*.js"
FIX_PATTERNS="**/*fix* **/*patch*"
CONFIG_PATTERNS="config/** *.config.* .env*"

# Custom commit message templates
FEAT_TEMPLATE="feat(\$scope): add \$description"
FIX_TEMPLATE="fix(\$scope): resolve \$description"

# Scope detection rules
SCOPE_RULES="
src/auth:auth
src/api:api  
config/:config
docs/:docs
"
```

This command will intelligently group your changes into appropriate conventional commits based on file patterns and change types, making your commit history clean and meaningful.