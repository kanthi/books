# Chapter 3: Core Git Operations

## Working with Files

### Adding Files to Git

Git tracks files through explicit commands. Understanding how to add files effectively is crucial for good Git workflow.

```bash
# Add a specific file
git add filename.txt

# Add multiple specific files
git add file1.txt file2.txt file3.txt

# Add all files in current directory
git add .

# Add all files in the repository
git add -A

# Add all files with specific pattern
git add *.js
git add src/*.py
git add "*.txt"

# Add parts of a file interactively
git add -p filename.txt
```

### Interactive Staging

Interactive staging allows you to stage parts of files:

```bash
# Interactive staging
git add -i

# Patch mode (stage hunks)
git add -p

# Edit mode (manually edit hunks)
git add -e
```

When using `git add -p`, you'll see options:
- `y` - stage this hunk
- `n` - do not stage this hunk
- `s` - split the hunk into smaller hunks
- `e` - manually edit the hunk
- `q` - quit

## Viewing Repository Status and Changes

### Git Status

```bash
# Basic status
git status

# Short format
git status -s
git status --short

# Show ignored files too
git status --ignored
```

Status output meanings:
- `??` - Untracked files
- `A` - Added (staged)
- `M` - Modified
- `D` - Deleted
- `R` - Renamed
- `C` - Copied

### Viewing Differences

```bash
# Show unstaged changes
git diff

# Show staged changes
git diff --staged
git diff --cached

# Show changes between commits
git diff HEAD~1 HEAD

# Show changes for specific file
git diff filename.txt

# Show word-level differences
git diff --word-diff

# Show statistics
git diff --stat
```

### Viewing File History

```bash
# Show commits that modified a file
git log filename.txt

# Show changes to a file over time
git log -p filename.txt

# Show who changed what line
git blame filename.txt

# Show file content at specific commit
git show commit-hash:filename.txt
```

## Committing Changes

### Basic Commits

```bash
# Commit staged changes
git commit -m "Commit message"

# Commit with detailed message
git commit -m "Short description

Longer explanation of what this commit does and why.
Can include multiple paragraphs and bullet points:
- Feature A added
- Bug B fixed
- Performance improved"

# Add and commit tracked files in one step
git commit -am "Update existing files"

# Commit with editor for longer message
git commit
```

### Amending Commits

```bash
# Change the last commit message
git commit --amend -m "New commit message"

# Add files to the last commit
git add forgotten-file.txt
git commit --amend --no-edit

# Amend with new message and files
git add new-file.txt
git commit --amend -m "Updated commit message"
```

### Commit Message Best Practices

#### Structure
```
Short summary (50 chars or less)

More detailed explanation if needed. Wrap at 72 characters.
Explain what and why, not how.

- Use bullet points if helpful
- Reference issue numbers: Fixes #123
- Use imperative mood: "Add feature" not "Added feature"
```

#### Good Examples
```bash
git commit -m "Add user authentication system"

git commit -m "Fix memory leak in image processing

The image cache wasn't being cleared properly after processing,
causing memory usage to grow continuously. This fix ensures
the cache is cleared after each batch of images.

Fixes #456"
```

## Working with .gitignore

### Creating .gitignore

```bash
# Create .gitignore file
touch .gitignore

# Add patterns to ignore
echo "*.log" >> .gitignore
echo "node_modules/" >> .gitignore
echo ".env" >> .gitignore
```

### Common .gitignore Patterns

```gitignore
# Compiled files
*.class
*.o
*.pyc
__pycache__/

# Logs
*.log
logs/

# Dependencies
node_modules/
vendor/

# Environment files
.env
.env.local

# IDE files
.vscode/
.idea/
*.swp
*.swo

# OS files
.DS_Store
Thumbs.db

# Build directories
build/
dist/
target/

# Temporary files
*.tmp
*.temp
~*
```

### Advanced .gitignore Patterns

```gitignore
# Ignore all .txt files except important.txt
*.txt
!important.txt

# Ignore files in any directory named temp
temp/

# Ignore .log files in root directory only
/*.log

# Ignore all files in logs directory but keep the directory
logs/*
!logs/.gitkeep

# Use double asterisk for recursive matching
**/node_modules/
```

### Managing Already Tracked Files

```bash
# Remove file from Git but keep in working directory
git rm --cached filename.txt

# Remove directory from Git but keep locally
git rm -r --cached directory/

# After adding to .gitignore, remove from tracking
git rm --cached *.log
git commit -m "Remove log files from tracking"
```

## Viewing History and Logs

### Basic Log Commands

```bash
# Show commit history
git log

# One line per commit
git log --oneline

# Show last 5 commits
git log -5

# Show commits with file changes
git log --stat

# Show commits with actual changes
git log -p
```

### Advanced Log Formatting

```bash
# Custom format
git log --pretty=format:"%h - %an, %ar : %s"

# Graph view
git log --graph --oneline --all

# Show commits by author
git log --author="John Doe"

# Show commits in date range
git log --since="2023-01-01" --until="2023-12-31"

# Show commits that modified specific file
git log -- filename.txt

# Show commits with specific message
git log --grep="bug fix"
```

### Useful Log Aliases

Add these to your Git configuration:

```bash
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

git config --global alias.hist "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
```

## Undoing Changes

### Unstaging Files

```bash
# Unstage specific file
git reset HEAD filename.txt

# Unstage all files
git reset HEAD

# In newer Git versions
git restore --staged filename.txt
```

### Discarding Changes

```bash
# Discard changes in working directory
git checkout -- filename.txt

# Discard all changes in working directory
git checkout -- .

# In newer Git versions
git restore filename.txt
git restore .
```

### Reverting Commits

```bash
# Create new commit that undoes a previous commit
git revert commit-hash

# Revert without creating commit (stage changes)
git revert --no-commit commit-hash

# Revert merge commit
git revert -m 1 merge-commit-hash
```

## File Operations

### Renaming and Moving Files

```bash
# Rename file
git mv old-name.txt new-name.txt

# Move file to directory
git mv file.txt directory/

# Equivalent manual process
mv old-name.txt new-name.txt
git add new-name.txt
git rm old-name.txt
```

### Removing Files

```bash
# Remove file from Git and working directory
git rm filename.txt

# Remove file from Git but keep in working directory
git rm --cached filename.txt

# Remove directory
git rm -r directory/

# Force removal (if file is modified)
git rm -f filename.txt
```

## Practical Exercises

### Exercise 1: File Management
1. Create a new repository
2. Add several files with different content
3. Practice staging files individually and in groups
4. Create commits with meaningful messages
5. View the history in different formats

### Exercise 2: Working with Changes
1. Modify several files
2. Use `git diff` to see changes
3. Stage some changes but not others
4. Use `git diff --staged` to see staged changes
5. Commit and view the result

### Exercise 3: .gitignore Practice
1. Create files that should be ignored (logs, temp files)
2. Create and configure .gitignore
3. Test that ignored files don't appear in status
4. Practice ignoring already-tracked files

### Exercise 4: History Exploration
1. Create several commits with different types of changes
2. Use various `git log` commands to explore history
3. Practice finding specific commits by author, date, or message
4. Use `git blame` to see who changed what

## Common Workflows

### Daily Development Workflow
```bash
# Start of day
git status                    # Check current state
git pull                      # Get latest changes

# During development
git add .                     # Stage changes
git commit -m "Description"   # Commit changes
git push                      # Share changes

# End of day
git status                    # Ensure clean state
git log --oneline -5          # Review recent work
```

### Feature Development Workflow
```bash
# Start feature
git checkout -b feature-name
git add .
git commit -m "Start feature implementation"

# During development
git add modified-files
git commit -m "Implement part of feature"

# Complete feature
git add .
git commit -m "Complete feature implementation"
git checkout main
git merge feature-name
```

## Summary

This chapter covered core Git operations including:
- Adding and staging files effectively
- Viewing repository status and changes
- Creating meaningful commits
- Managing ignored files with .gitignore
- Exploring repository history
- Undoing changes safely
- Basic file operations

These operations form the daily toolkit for Git users. Mastering them enables efficient version control and sets the foundation for more advanced Git features covered in subsequent chapters.

The key to becoming proficient with Git is practicing these core operations until they become second nature. Each operation serves a specific purpose in the Git workflow, and understanding when and how to use each one is crucial for effective version control.