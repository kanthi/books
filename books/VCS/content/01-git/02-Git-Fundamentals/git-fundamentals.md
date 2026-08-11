# Chapter 2: Git Fundamentals

## Installing Git

### macOS
```bash
# Using Homebrew (recommended)
brew install git

# Using Xcode Command Line Tools
xcode-select --install

# Verify installation
git --version
```

### Linux (Ubuntu/Debian)
```bash
# Update package list
sudo apt update

# Install Git
sudo apt install git

# Verify installation
git --version
```

### Windows
1. Download from [git-scm.com](https://git-scm.com/download/win)
2. Run the installer with default settings
3. Open Git Bash or Command Prompt
4. Verify: `git --version`

## Initial Configuration

Before using Git, you need to configure your identity:

```bash
# Set your name and email (required)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor (optional)
git config --global core.editor "code --wait"  # VS Code
git config --global core.editor "vim"          # Vim
git config --global core.editor "nano"         # Nano

# View your configuration
git config --list
git config user.name
git config user.email
```

### Configuration Levels

Git has three levels of configuration:

1. **System** (`--system`): Applies to all users on the system
2. **Global** (`--global`): Applies to all repositories for the current user
3. **Local** (default): Applies only to the current repository

## The Three States of Git

Understanding Git's three states is crucial:

### 1. Working Directory
- Your current project files
- Where you make changes
- Untracked or modified files

### 2. Staging Area (Index)
- Files prepared for the next commit
- A snapshot of what will be committed
- Use `git add` to stage files

### 3. Git Repository
- Committed snapshots of your project
- Permanent record of changes
- Use `git commit` to save to repository

```
Working Directory → Staging Area → Git Repository
     (modify)         (stage)        (commit)
```

## Repository Initialization

### Creating a New Repository

```bash
# Create a new directory
mkdir my-project
cd my-project

# Initialize Git repository
git init

# Check status
git status
```

### Cloning an Existing Repository

```bash
# Clone from GitHub
git clone https://github.com/user/repository.git

# Clone to specific directory
git clone https://github.com/user/repository.git my-folder

# Clone specific branch
git clone -b branch-name https://github.com/user/repository.git
```

## Basic Git Workflow

### 1. Check Status
```bash
git status
```

### 2. Add Files to Staging Area
```bash
# Add specific file
git add filename.txt

# Add all files in current directory
git add .

# Add all files with specific extension
git add *.js

# Add all files (including deleted ones)
git add -A
```

### 3. Commit Changes
```bash
# Commit with message
git commit -m "Add initial project files"

# Commit with detailed message
git commit -m "Add user authentication

- Implement login functionality
- Add password validation
- Create user session management"

# Add and commit in one step (tracked files only)
git commit -am "Update existing files"
```

### 4. View History
```bash
# View commit history
git log

# Compact view
git log --oneline

# Graphical view
git log --graph --oneline --all

# Show specific number of commits
git log -5
```

## Understanding Git Objects

Git stores data as snapshots, not differences. Every commit contains:

### Commit Object
- Points to a tree object
- Contains author and committer info
- Contains commit message
- Points to parent commit(s)

### Tree Object
- Represents directory structure
- Points to blob objects (files)
- Points to other tree objects (subdirectories)

### Blob Object
- Contains file content
- Identified by SHA-1 hash of content

## File States in Git

Files in your working directory can be in one of these states:

### Untracked
- New files not yet added to Git
- Git doesn't know about them

### Tracked
Files that Git knows about, which can be:

#### Unmodified
- File hasn't changed since last commit
- Clean working directory

#### Modified
- File has been changed but not staged
- Changes exist in working directory

#### Staged
- File has been added to staging area
- Ready for next commit

## The .git Directory

When you run `git init`, Git creates a `.git` directory containing:

```
.git/
├── HEAD              # Points to current branch
├── config            # Repository configuration
├── description       # Repository description
├── hooks/            # Client/server-side hook scripts
├── info/             # Global exclude file
├── objects/          # Git objects (commits, trees, blobs)
├── refs/             # References (branches, tags)
└── index             # Staging area information
```

## Common Git Commands Summary

```bash
# Repository setup
git init                    # Initialize repository
git clone <url>            # Clone repository

# Configuration
git config --global user.name "Name"
git config --global user.email "email"

# Basic workflow
git status                 # Check repository status
git add <file>            # Stage file
git add .                 # Stage all files
git commit -m "message"   # Commit changes
git log                   # View history

# Information
git show                  # Show last commit
git diff                  # Show unstaged changes
git diff --staged         # Show staged changes
```

## Best Practices

### Commit Messages
- Use present tense ("Add feature" not "Added feature")
- Keep first line under 50 characters
- Use imperative mood ("Fix bug" not "Fixes bug")
- Provide context in the body if needed

### When to Commit
- Commit early and often
- Each commit should represent a logical change
- Don't commit broken code
- Commit related changes together

### Repository Organization
- Use meaningful directory structure
- Keep repositories focused on single projects
- Use .gitignore for files that shouldn't be tracked

## Exercises

### Exercise 1: First Repository
1. Create a new directory called `git-practice`
2. Initialize it as a Git repository
3. Create a `README.md` file with project description
4. Add and commit the file
5. Check the repository status and history

### Exercise 2: Multiple Commits
1. Create three files: `index.html`, `style.css`, `script.js`
2. Add some basic content to each
3. Stage and commit each file separately
4. View the commit history
5. Make changes to one file and commit again

### Exercise 3: Configuration Practice
1. Check your current Git configuration
2. Set up a different editor if you haven't already
3. Create a repository-specific configuration
4. Compare global vs local settings

## Troubleshooting Common Issues

### "Author identity unknown"
```bash
# Solution: Configure user name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### "Not a git repository"
```bash
# Solution: Initialize repository or navigate to existing one
git init
# or
cd /path/to/git/repository
```

### Accidentally committed wrong files
```bash
# Solution: Amend the last commit (if not pushed)
git add correct-file.txt
git commit --amend
```

## Summary

This chapter covered Git fundamentals including:
- Installation and configuration
- The three states of Git
- Basic workflow (add, commit, status, log)
- Understanding Git objects and file states
- Best practices for commits and repository management

These fundamentals form the foundation for all Git operations. In the next chapter, we'll explore core Git operations in more detail, including working with files, viewing changes, and managing your repository effectively.

Understanding these concepts is crucial because they underpin everything else you'll do with Git. The three-state model, in particular, is key to understanding how Git manages your files and changes.