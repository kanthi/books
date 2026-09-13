---
title: "Stash, tags, and cleanup"
---

# Stash, tags, and cleanup

## Git Stash

Git stash temporarily saves your uncommitted changes, allowing you to switch branches or pull updates without committing incomplete work.

### Basic Stash Operations

```bash
# Stash current changes
git stash

# Stash with a message
git stash save "Work in progress on feature X"

# List all stashes
git stash list

# Apply most recent stash
git stash apply

# Apply and remove stash
git stash pop

# Apply specific stash
git stash apply stash@{2}

# Drop specific stash
git stash drop stash@{1}

# Clear all stashes
git stash clear
```

### Advanced Stash Options

```bash
# Stash including untracked files
git stash -u
git stash --include-untracked

# Stash only staged changes
git stash --staged

# Stash with patch mode (interactive)
git stash -p

# Create branch from stash
git stash branch new-feature-branch stash@{1}

# Show stash contents
git stash show
git stash show -p stash@{0}
```

### Stash Use Cases

#### Quick Branch Switch
```bash
# Working on feature, need to fix urgent bug
git stash save "Feature X in progress"
git checkout main
git checkout -b hotfix/urgent-bug
# Fix bug and commit
git checkout feature-branch
git stash pop
```

#### Pulling Updates
```bash
# Have uncommitted changes, need to pull
git stash
git pull origin main
git stash pop
# Resolve any conflicts if they occur
```

#### Experimenting with Changes
```bash
# Try different approach
git stash save "Current approach"
# Make experimental changes
# If experiment fails:
git reset --hard HEAD
git stash pop
```

## Git Blame and Annotate

Git blame shows who last modified each line of a file, helping track down the origin of code changes.

### Basic Blame Usage

```bash
# Show blame for entire file
git blame filename.txt

# Show blame for specific lines
git blame -L 10,20 filename.txt

# Show blame for function (if language supports it)
git blame -L :function_name filename.c
```

### Blame Options

```bash
# Show email addresses instead of names
git blame -e filename.txt

# Show commit hash in short format
git blame -s filename.txt

# Ignore whitespace changes
git blame -w filename.txt

# Show line numbers
git blame -n filename.txt

# Show original line numbers
git blame -f filename.txt
```

### Advanced Blame Features

```bash
# Follow file renames
git blame -C filename.txt

# Detect moved/copied lines within file
git blame -M filename.txt

# Detect moved/copied lines from other files
git blame -C -C filename.txt

# Show blame with commit dates
git blame --date=short filename.txt
```

### Blame with Time Range

```bash
# Blame since specific date
git blame --since="2023-01-01" filename.txt

# Blame until specific date
git blame --until="2023-12-31" filename.txt

# Blame for specific revision
git blame v1.0 -- filename.txt
```

## Git Grep

Git grep searches for patterns in tracked files, offering more features than regular grep for Git repositories.

### Basic Grep Usage

```bash
# Search for pattern in all tracked files
git grep "function_name"

# Search in specific files
git grep "pattern" -- "*.js"

# Search in specific directory
git grep "pattern" src/

# Case-insensitive search
git grep -i "pattern"
```

### Advanced Grep Options

```bash
# Show line numbers
git grep -n "pattern"

# Show only filenames
git grep -l "pattern"

# Show count of matches per file
git grep -c "pattern"

# Show context lines
git grep -A 3 -B 3 "pattern"  # 3 lines after and before

# Word boundary search
git grep -w "word"

# Regular expressions
git grep -E "pattern1|pattern2"
git grep -P "perl_regex_pattern"
```

### Grep in Specific Commits

```bash
# Search in specific commit
git grep "pattern" HEAD~5

# Search in all commits
git rev-list --all | xargs git grep "pattern"

# Search in commit range
git grep "pattern" v1.0..v2.0
```

### Complex Grep Queries

```bash
# Search for pattern and exclude another
git grep "function" --and --not -e "test"

# Search for multiple patterns in same file
git grep -e "pattern1" --and -e "pattern2"

# Search for pattern in specific file types
git grep "TODO" -- "*.js" "*.ts"

# Search with custom pathspec
git grep "pattern" -- ':!test/' ':!docs/'
```

## Git Log Advanced Features

### Custom Log Formatting

```bash
# Custom format
git log --pretty=format:"%h - %an, %ar : %s"

# Available format options:
# %H  - commit hash
# %h  - abbreviated commit hash
# %T  - tree hash
# %t  - abbreviated tree hash
# %P  - parent hashes
# %p  - abbreviated parent hashes
# %an - author name
# %ae - author email
# %ad - author date
# %ar - author date, relative
# %cn - committer name
# %ce - committer email
# %cd - committer date
# %cr - committer date, relative
# %s  - subject
# %b  - body
```

### Log Filtering

```bash
# Filter by author
git log --author="John Doe"
git log --author="john@example.com"

# Filter by committer
git log --committer="Jane Smith"

# Filter by date
git log --since="2023-01-01"
git log --until="2023-12-31"
git log --since="2 weeks ago"

# Filter by message
git log --grep="bug fix"
git log --grep="feature" --grep="enhancement" --all-match

# Filter by file changes
git log -- filename.txt
git log --follow -- filename.txt  # Follow renames
```

### Log Statistics and Analysis

```bash
# Show file change statistics
git log --stat

# Show patch (actual changes)
git log -p

# Show short stat
git log --shortstat

# Show name status (A/M/D)
git log --name-status

# Show only names of changed files
git log --name-only

# Show merge commits only
git log --merges

# Show non-merge commits only
git log --no-merges
```

### Advanced Log Queries

```bash
# Show commits that changed specific lines
git log -L 10,20:filename.txt

# Show commits that added or removed specific string
git log -S "function_name"

# Show commits that changed regex pattern
git log -G "regex_pattern"

# Show commits in date order (not topological)
git log --date-order

# Show first parent only (useful for merge commits)
git log --first-parent

# Show commits reachable from one ref but not another
git log main..feature-branch
git log feature-branch..main
```

## Git Reflog

Reflog records updates to branch tips and other references, providing a safety net for recovery.

### Basic Reflog Usage

```bash
# Show reflog for current branch
git reflog

# Show reflog for specific branch
git reflog feature-branch

# Show reflog for all references
git reflog --all

# Show reflog with dates
git reflog --date=iso
```

### Reflog Recovery Scenarios

#### Recover Deleted Branch
```bash
# Find the branch in reflog
git reflog

# Look for entry like: abc1234 HEAD@{5}: checkout: moving from deleted-branch to main
# Recreate branch
git branch recovered-branch abc1234
```

#### Recover from Hard Reset
```bash
# Find commit before reset
git reflog

# Look for entry before reset
# Reset to that commit
git reset --hard HEAD@{3}
```

#### Recover Lost Commits
```bash
# Find lost commits in reflog
git reflog

# Create branch to save lost commits
git branch recovery-branch HEAD@{2}
```

### Reflog Maintenance

```bash
# Expire reflog entries older than 30 days
git reflog expire --expire=30.days

# Expire unreachable entries immediately
git reflog expire --expire-unreachable=now --all

# Garbage collect after expiring
git gc --prune=now
```

## Exercises

### Exercise 1: Stash Mastery
1. Create a repository with ongoing work
2. Practice different stash operations
3. Use stash to switch between tasks
4. Create branches from stashes

### Exercise 2: Bug Hunting with Bisect
1. Create a repository with a known bug introduction
2. Use git bisect to find the problematic commit
3. Create an automated test script for bisect
4. Practice bisect with different scenarios

### Exercise 3: Code Investigation
1. Use git blame to understand code history
2. Use git grep to find patterns across codebase
3. Combine blame and grep for comprehensive analysis
4. Create aliases for common investigation tasks

### Exercise 4: Advanced Repository Management
1. Set up worktrees for parallel development
2. Experiment with submodules and subtrees
3. Use reflog for recovery scenarios
4. Practice advanced log filtering and formatting

## Best Practices

### Stash Management
1. **Use descriptive messages** for stashes
2. **Don't let stashes accumulate** - apply or drop them regularly
3. **Consider branches** for longer-term work instead of stashes
4. **Test after applying** stashes to ensure no conflicts

### Debugging Workflow
1. **Use bisect systematically** for complex bugs
2. **Combine blame with log** for complete context
3. **Create reproducible test cases** for bisect automation
4. **Document findings** for future reference

### Repository Organization
1. **Use worktrees** for parallel development needs
2. **Choose submodules vs subtrees** based on project requirements
3. **Regular maintenance** of reflog and garbage collection
4. **Monitor repository size** and performance

## Summary

Advanced Git commands provide powerful tools for:

- **Temporary storage**: Stash for work-in-progress management
- **Bug hunting**: Bisect for systematic problem identification
- **Code investigation**: Blame and grep for understanding code history
- **Advanced logging**: Custom formatting and filtering for analysis
- **Recovery**: Reflog for safety net and mistake recovery
- **Parallel work**: Worktrees for multiple working directories
- **Code reuse**: Submodules and subtrees for external dependencies

These commands form the advanced toolkit for Git power users, enabling sophisticated workflows and efficient problem-solving. Mastering them significantly improves productivity and confidence when working with complex Git repositories.

The next chapter will explore Git hooks and automation, building upon these advanced commands to create automated workflows and quality assurance processes.