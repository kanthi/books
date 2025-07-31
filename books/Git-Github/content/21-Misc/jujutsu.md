# Jujutsu (jj): Next-Generation Version Control

Jujutsu (jj) is a modern version control system that aims to provide a better user experience than Git while maintaining compatibility with Git repositories.

## What is Jujutsu?

Jujutsu is designed to address many of Git's usability issues:
- **No staging area**: Direct commit workflow
- **Automatic conflict resolution**: Better merge handling
- **Immutable history**: Operations create new commits instead of modifying existing ones
- **Powerful revsets**: Advanced commit selection syntax
- **Git compatibility**: Works with existing Git repositories

## Key Concepts

### Fundamental Differences from Git

1. **No Index/Staging Area**: Changes are committed directly
2. **Working Copy Commits**: Your working directory is always a commit
3. **Change IDs**: Commits have stable identifiers that survive rebasing
4. **Automatic Rebasing**: Operations automatically maintain clean history

### Jujutsu vs Git Terminology

| Git | Jujutsu | Description |
|-----|---------|-------------|
| HEAD | @ | Current working copy |
| Branch | Branch | Named pointer to commit |
| Commit | Change | A set of changes with stable ID |
| Rebase | Rebase | Automatic history rewriting |
| Merge | Merge | Combining multiple parents |

## Installation

### Method 1: Package Managers

#### macOS (Homebrew)
```bash
brew install jj
```

#### Linux (Cargo)
```bash
# Install Rust if not already installed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Install jj
cargo install --git https://github.com/martinvonz/jj.git jj-cli
```

#### Ubuntu/Debian (from source)
```bash
# Install dependencies
sudo apt update
sudo apt install -y build-essential pkg-config libssl-dev

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# Clone and build jj
git clone https://github.com/martinvonz/jj.git
cd jj
cargo build --release
sudo cp target/release/jj /usr/local/bin/
```

### Method 2: Pre-built Binaries

```bash
# Download latest release
curl -L https://github.com/martinvonz/jj/releases/latest/download/jj-linux-x86_64.tar.gz | tar xz
sudo mv jj /usr/local/bin/
chmod +x /usr/local/bin/jj
```

## Initial Setup and Configuration

### First-Time Configuration

```bash
# Set up user information
jj config set --user user.name "Your Name"
jj config set --user user.email "your.email@example.com"

# Configure editor
jj config set --user ui.editor "code --wait"  # VS Code
# or
jj config set --user ui.editor "vim"          # Vim

# Configure diff tool
jj config set --user ui.diff.tool "code --wait --diff"
# or
jj config set --user ui.diff.tool "vimdiff"

# Configure merge tool
jj config set --user ui.merge-tool "code --wait"
```

### Configuration File

```toml
# ~/.jjconfig.toml
[user]
name = "Your Name"
email = "your.email@example.com"

[ui]
editor = "code --wait"
diff-tool = "code --wait --diff"
merge-tool = "code --wait"
pager = "less -FRX"

[colors]
"commit_id prefix" = "blue"
"change_id prefix" = "magenta"
"branch" = "green"
"tag" = "yellow"
"working_copy" = "green bold"

[revsets]
log = "@ | ancestors(remote_branches()..@, 2) | trunk()"

[aliases]
l = ["log", "-r", "(@ | ancestors(remote_branches()..@, 2) | trunk())"]
ll = ["log"]
st = ["status"]
d = ["diff"]
s = ["show"]
```

## Basic Operations

### Creating and Initializing Repositories

#### Initialize New Repository
```bash
# Create new jj repository
mkdir my-project
cd my-project
jj init

# Initialize with Git backend (recommended)
jj init --git
```

#### Clone Existing Git Repository
```bash
# Clone from Git repository
jj git clone https://github.com/user/repo.git
cd repo

# Or clone and convert existing Git repo
git clone https://github.com/user/repo.git
cd repo
jj init --git-repo .
```

### Working with Changes

#### Making Changes
```bash
# Check status
jj status

# View current changes
jj diff

# Create a new change (commit)
jj commit -m "Add new feature"

# Amend current change
echo "more content" >> file.txt
jj commit --amend -m "Add new feature with more content"

# Create new change and continue working
jj new
echo "another change" >> file2.txt
jj commit -m "Another feature"
```

#### Viewing History
```bash
# Show log (default view)
jj log

# Show detailed log
jj log --verbose

# Show specific range
jj log -r "main..@"

# Show graph
jj log --graph

# Custom log format
jj log --template 'commit_id.short() ++ " " ++ description.first_line() ++ "\n"'
```

### Real-World Workflow Examples

#### Scenario 1: Feature Development

```bash
# Start new feature
cd my-project
jj new main -m "Start user authentication feature"

# Make changes
echo "class UserAuth:" > auth.py
echo "    def login(self, username, password):" >> auth.py
echo "        pass" >> auth.py

# Commit current state
jj commit -m "Add UserAuth class skeleton"

# Continue development
echo "    def logout(self):" >> auth.py
echo "        pass" >> auth.py
echo "    def validate_user(self, username):" >> auth.py
echo "        return True" >> auth.py

# Commit additional changes
jj commit -m "Add logout and validation methods"

# Add tests
echo "import unittest" > test_auth.py
echo "from auth import UserAuth" >> test_auth.py
echo "" >> test_auth.py
echo "class TestUserAuth(unittest.TestCase):" >> test_auth.py
echo "    def test_login(self):" >> test_auth.py
echo "        auth = UserAuth()" >> test_auth.py
echo "        # Test implementation" >> test_auth.py

jj commit -m "Add unit tests for UserAuth"

# View the feature branch
jj log -r "main..@"
```

#### Scenario 2: Bug Fix with History Rewriting

```bash
# Discover bug in earlier commit
jj log --oneline
# * 3a2b1c9 Add unit tests for UserAuth
# * 2b1c9d8 Add logout and validation methods
# * 1c9d8e7 Add UserAuth class skeleton
# * 9d8e7f6 (main) Initial commit

# Fix bug in the validation method
jj edit 2b1c9d8  # Edit the commit with the bug
echo "    def validate_user(self, username):" >> auth.py
echo "        return username is not None and len(username) > 0" >> auth.py

# Commit the fix
jj commit --amend -m "Add logout and validation methods (fix validation logic)"

# Return to latest change
jj edit @

# View updated history (automatic rebasing)
jj log -r "main..@"
```

#### Scenario 3: Collaborative Development

```bash
# Fetch latest changes
jj git fetch

# Rebase current work on latest main
jj rebase -d main

# Push changes
jj git push --branch feature-auth

# Create pull request (using GitHub CLI)
gh pr create --title "Add user authentication" --body "Implements login, logout, and user validation"

# After review, squash commits before merge
jj squash -r "main..@" -m "Add complete user authentication system"
```

## Advanced Features

### Revsets (Revision Selection)

Jujutsu uses a powerful query language for selecting commits:

```bash
# Current working copy
jj log -r "@"

# All ancestors of current commit
jj log -r "ancestors(@)"

# All descendants of main
jj log -r "descendants(main)"

# Commits between main and current
jj log -r "main..@"

# All branches
jj log -r "branches()"

# Remote branches
jj log -r "remote_branches()"

# Commits by author
jj log -r 'author("john@example.com")'

# Commits with specific message
jj log -r 'description(regex:"fix|bug")'

# Complex queries
jj log -r "(main | @) & ancestors(remote_branches())"
```

### Conflict Resolution

Jujutsu has superior conflict resolution compared to Git:

```bash
# Create conflicting changes
jj new main -m "Feature A"
echo "feature A" > feature.txt
jj commit

jj new main -m "Feature B"
echo "feature B" > feature.txt
jj commit

# Merge (creates conflict)
jj merge

# View conflict
jj status
jj diff

# Resolve conflict
echo "feature A and B combined" > feature.txt
jj commit -m "Resolve conflict between features"

# Alternative: Use merge tool
jj resolve --tool
```

### Working with Multiple Changes

```bash
# Create multiple parallel changes
jj new main -m "Feature 1"
echo "feature 1" > f1.txt
jj commit

jj new main -m "Feature 2"
echo "feature 2" > f2.txt
jj commit

jj new main -m "Feature 3"
echo "feature 3" > f3.txt
jj commit

# View all changes
jj log --graph

# Combine specific changes
jj merge f1-commit-id f2-commit-id -m "Combine features 1 and 2"

# Reorder changes
jj rebase -d main -s f3-commit-id
```

## Integration with Git Workflows

### Git Interoperability

```bash
# Work with Git remotes
jj git remote add origin https://github.com/user/repo.git
jj git fetch
jj git push

# Import Git branches
jj git import

# Export to Git
jj git export

# Work with Git hooks
# Jj respects Git hooks in .git/hooks/
```

### Converting Git Repository

```bash
# Convert existing Git repo
cd existing-git-repo
jj init --git-repo .

# Import all Git history
jj git import

# Continue working with jj
jj status
jj log
```

### Hybrid Workflow (Git + Jujutsu)

```bash
# Use jj for local development
jj new main -m "Local feature development"
# ... make changes ...
jj commit -m "Implement feature"

# Export to Git for pushing
jj git export
git push origin feature-branch

# Or push directly with jj
jj git push --branch feature-branch
```

## Team Collaboration Scenarios

### Scenario 1: Code Review Workflow

```bash
# Developer A: Create feature
jj new main -m "Add payment processing"
# ... implement feature ...
jj commit -m "Implement payment gateway integration"
jj commit -m "Add payment validation"
jj commit -m "Add payment tests"

# Push for review
jj git push --branch payment-feature

# Developer B: Review and suggest changes
jj git fetch
jj new payment-feature -m "Address review comments"
# ... make changes ...
jj commit -m "Fix validation edge cases"
jj commit -m "Improve error handling"

# Squash before merge
jj squash -r "payment-feature..@" -m "Add payment processing with review fixes"
jj git push --branch payment-feature --force
```

### Scenario 2: Hotfix Workflow

```bash
# Critical bug discovered in production
jj new production -m "Hotfix: Fix critical security vulnerability"

# Quick fix
sed -i 's/vulnerable_function/secure_function/g' security.py
jj commit -m "Replace vulnerable function with secure implementation"

# Test the fix
python -m pytest tests/test_security.py
jj commit --amend -m "Fix critical security vulnerability (tested)"

# Deploy hotfix
jj git push --branch hotfix-security

# Merge to main after deployment
jj rebase -d main
jj git push --branch main
```

### Scenario 3: Large Feature with Multiple Developers

```bash
# Lead developer: Create feature branch
jj new main -m "Start user management system"
jj commit -m "Add user model and basic structure"
jj git push --branch user-management

# Developer 1: Work on authentication
jj git fetch
jj new user-management -m "Implement user authentication"
# ... implement auth ...
jj commit -m "Add login/logout functionality"
jj git push --branch user-auth

# Developer 2: Work on user profiles
jj new user-management -m "Implement user profiles"
# ... implement profiles ...
jj commit -m "Add user profile management"
jj git push --branch user-profiles

# Lead developer: Integrate features
jj git fetch
jj merge user-auth user-profiles -m "Integrate authentication and profiles"

# Resolve any conflicts
jj status
# ... resolve conflicts if any ...
jj commit -m "Resolve integration conflicts"

# Final integration
jj git push --branch user-management
```

## Advanced Configuration and Customization

### Custom Templates

```toml
# ~/.jjconfig.toml
[templates]
log_oneline = '''
change_id.short() ++ " " ++
if(description, description.first_line(), "(no description)") ++
if(branches, " (" ++ branches.join(", ") ++ ")")
'''

log_detailed = '''
"Commit: " ++ commit_id.hex() ++ "\n" ++
"Change: " ++ change_id.hex() ++ "\n" ++
"Author: " ++ author.name() ++ " <" ++ author.email() ++ ">\n" ++
"Date: " ++ author.timestamp() ++ "\n" ++
if(branches, "Branches: " ++ branches.join(", ") ++ "\n") ++
"\n" ++ indent("    ", description) ++ "\n"
'''
```

### Custom Commands (Aliases)

```toml
# ~/.jjconfig.toml
[aliases]
# Short status
s = ["status"]

# Detailed log with graph
lg = ["log", "--graph", "--template", "log_detailed"]

# Show changes in current branch
current = ["log", "-r", "main..@"]

# Quick commit with message
qc = ["commit", "-m"]

# Amend last commit
amend = ["commit", "--amend"]

# Create new change and commit
nc = ["new", "-m"]

# Show diff for specific change
show = ["diff", "-r"]

# Rebase current branch on main
sync = ["rebase", "-d", "main"]
```

### Integration with Development Tools

#### VS Code Integration

```json
// .vscode/settings.json
{
    "jujutsu.enable": true,
    "jujutsu.path": "/usr/local/bin/jj",
    "git.enabled": false,
    "scm.defaultViewMode": "tree"
}
```

#### Shell Integration

```bash
# ~/.bashrc or ~/.zshrc

# Jujutsu prompt integration
function jj_prompt() {
    if jj root >/dev/null 2>&1; then
        local branch=$(jj log -r @ --no-graph --template 'branches.join(" ")')
        local change_id=$(jj log -r @ --no-graph --template 'change_id.short()')
        if [ -n "$branch" ]; then
            echo " (jj:$branch)"
        else
            echo " (jj:$change_id)"
        fi
    fi
}

# Add to PS1
PS1='${PS1}$(jj_prompt)'

# Useful aliases
alias jst='jj status'
alias jl='jj log'
alias jd='jj diff'
alias jc='jj commit'
alias jn='jj new'
```

## Performance and Optimization

### Repository Maintenance

```bash
# Check repository health
jj debug check

# Optimize repository
jj debug reindex

# Clean up unreferenced changes
jj debug gc

# Repository statistics
jj debug stats
```

### Large Repository Handling

```bash
# Configure for large repositories
jj config set --repo core.preload-index false
jj config set --repo core.fsmonitor true

# Shallow clone for large repositories
jj git clone --depth 1 https://github.com/large/repo.git

# Sparse checkout
jj sparse set path/to/needed/files
```

## Migration Strategies

### Gradual Migration from Git

```bash
# Phase 1: Parallel usage
# Keep using Git for team collaboration
# Use jj for local development

# Phase 2: Team adoption
# Train team on jj basics
# Use jj for feature branches
# Continue using Git for main branch

# Phase 3: Full migration
# Move all development to jj
# Use jj git commands for remote operations
# Eventually move to native jj hosting (when available)
```

### Migration Script

```bash
#!/bin/bash
# migrate-to-jj.sh

REPO_URL=$1
REPO_NAME=$(basename "$REPO_URL" .git)

if [ -z "$REPO_URL" ]; then
    echo "Usage: $0 <git-repo-url>"
    exit 1
fi

echo "Migrating $REPO_URL to Jujutsu..."

# Clone with Git
git clone "$REPO_URL" "${REPO_NAME}-git"
cd "${REPO_NAME}-git"

# Initialize jj in the same directory
jj init --git-repo .

# Import all Git history
jj git import

# Set up remote
jj git remote add origin "$REPO_URL"

# Create jj-specific configuration
cat > .jjconfig.toml <<EOF
[ui]
default-command = "log"

[revsets]
log = "@ | ancestors(remote_branches()..@, 10) | heads(remote_branches())"

[aliases]
sync = ["git", "fetch", "--all-remotes"]
push = ["git", "push"]
EOF

echo "Migration completed!"
echo "Repository is now ready for jj usage"
echo "Run 'jj status' to get started"
```

## Troubleshooting Common Issues

### Issue 1: Conflict Resolution

```bash
# When conflicts occur
jj status  # Shows conflicted files

# View conflict markers
jj diff

# Resolve manually or with tool
jj resolve --tool

# Or edit files manually and commit
vim conflicted_file.txt
jj commit -m "Resolve conflict"
```

### Issue 2: Lost Changes

```bash
# View all changes (including abandoned)
jj log --revisions 'all()'

# Restore abandoned change
jj new <abandoned-change-id>

# Or use operation log
jj op log
jj op restore <operation-id>
```

### Issue 3: Git Synchronization Issues

```bash
# Force import from Git
jj git import --force

# Reset to match Git state
jj git export
git reset --hard origin/main
jj git import

# Check Git/jj consistency
jj debug check-git
```

This comprehensive guide covers Jujutsu from basic concepts to advanced usage, providing practical examples for teams transitioning from Git to this modern version control system.