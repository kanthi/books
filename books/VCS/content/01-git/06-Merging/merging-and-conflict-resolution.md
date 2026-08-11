# Chapter 6: Merging and Conflict Resolution

## Understanding Merging

Merging is the process of combining changes from different branches. Git provides several merge strategies to handle different scenarios effectively.

### Types of Merges

1. **Fast-Forward Merge**: When target branch hasn't diverged
2. **Three-Way Merge**: When branches have diverged
3. **Squash Merge**: Combines all commits into a single commit
4. **Rebase Merge**: Replays commits on top of target branch

## Fast-Forward Merges

### When Fast-Forward Occurs

Fast-forward happens when the target branch hasn't moved since the feature branch was created:

```
main:     A---B
               \
feature:        C---D
```

After fast-forward merge:
```
main:     A---B---C---D
```

### Performing Fast-Forward Merge

```bash
# Create and work on feature branch
git checkout -b feature-branch
echo "New feature" > feature.txt
git add feature.txt
git commit -m "Add new feature"

# Switch to main and merge
git checkout main
git merge feature-branch

# Output: Fast-forward merge
```

### Controlling Fast-Forward Behavior

```bash
# Force fast-forward (fails if not possible)
git merge --ff-only feature-branch

# Prevent fast-forward (always create merge commit)
git merge --no-ff feature-branch

# Default behavior (fast-forward when possible)
git merge feature-branch
```

## Three-Way Merges

### When Three-Way Merge Occurs

When both branches have new commits since they diverged:

```
main:     A---B---E---F
               \
feature:        C---D
```

Git finds the common ancestor (B) and creates a merge commit:

```
main:     A---B---E---F---M
               \           /
feature:        C---D-----
```

### Performing Three-Way Merge

```bash
# Scenario: Both branches have new commits
git checkout main
git merge feature-branch

# Git automatically creates merge commit
# Opens editor for merge commit message
```

### Merge Commit Messages

Default merge commit message format:
```
Merge branch 'feature-branch' into main

# Please enter a commit message to explain why this merge is necessary,
# especially if it merges an updated upstream into a topic branch.
```

Custom merge commit message:
```bash
git merge feature-branch -m "Merge feature: Add user authentication"
```

## Merge Conflicts

### What Causes Conflicts

Conflicts occur when:
- Same lines modified in both branches
- File deleted in one branch, modified in another
- File renamed differently in both branches

### Conflict Example

File content in main branch:
```javascript
function greet(name) {
    return "Hello, " + name + "!";
}
```

File content in feature branch:
```javascript
function greet(name) {
    return "Hi there, " + name + "!";
}
```

### Conflict Markers

When conflict occurs, Git adds conflict markers:

```javascript
function greet(name) {
<<<<<<< HEAD
    return "Hello, " + name + "!";
=======
    return "Hi there, " + name + "!";
>>>>>>> feature-branch
}
```

Conflict markers explained:
- `<<<<<<< HEAD`: Start of current branch content
- `=======`: Separator between conflicting content
- `>>>>>>> branch-name`: End of merging branch content

## Resolving Conflicts

### Manual Resolution Process

1. **Identify conflicts**:
```bash
git status
# Shows files with conflicts
```

2. **Edit conflicted files**:
```javascript
// Choose one version or combine both
function greet(name) {
    return "Hello there, " + name + "!";
}
```

3. **Stage resolved files**:
```bash
git add conflicted-file.js
```

4. **Complete the merge**:
```bash
git commit
# Or use: git merge --continue
```

### Conflict Resolution Strategies

#### Strategy 1: Accept One Side
```bash
# Accept current branch (HEAD)
git checkout --ours conflicted-file.js

# Accept incoming branch
git checkout --theirs conflicted-file.js

# Stage the resolution
git add conflicted-file.js
```

#### Strategy 2: Manual Edit
```bash
# Edit file to resolve conflicts manually
vim conflicted-file.js

# Remove conflict markers and choose/combine content
# Stage the resolved file
git add conflicted-file.js
```

#### Strategy 3: Use Merge Tool
```bash
# Configure merge tool (one-time setup)
git config --global merge.tool vimdiff

# Launch merge tool
git mergetool

# Popular merge tools: vimdiff, meld, kdiff3, p4merge
```

## Advanced Merge Strategies

### Merge Strategies

Git provides several merge strategies:

```bash
# Recursive (default for two branches)
git merge -s recursive feature-branch

# Ours (always prefer our version)
git merge -s ours feature-branch

# Theirs (always prefer their version)
git merge -s theirs feature-branch

# Octopus (for multiple branches)
git merge -s octopus branch1 branch2 branch3
```

### Merge Strategy Options

```bash
# Prefer our version for conflicts
git merge -X ours feature-branch

# Prefer their version for conflicts
git merge -X theirs feature-branch

# Ignore whitespace changes
git merge -X ignore-space-change feature-branch

# Ignore all whitespace
git merge -X ignore-all-space feature-branch
```

## Squash Merging

### What is Squash Merge

Squash merge combines all commits from feature branch into a single commit:

```bash
# Squash merge
git merge --squash feature-branch
git commit -m "Add complete user authentication feature"
```

### When to Use Squash Merge

- Clean up messy commit history
- Combine related commits
- Maintain linear history
- Before merging to main branch

### Squash Merge Example

```bash
# Feature branch has multiple commits
git log --oneline feature-auth
# a1b2c3d Fix typo in login form
# e4f5g6h Add password validation
# i7j8k9l Add login form
# m0n1o2p Start authentication feature

# Squash merge
git checkout main
git merge --squash feature-auth
git commit -m "Add user authentication system

- Login form with validation
- Password strength requirements
- Session management
- Error handling"
```

## Aborting Merges

### When to Abort

- Conflicts are too complex
- Wrong branch merged
- Need to prepare better

### How to Abort

```bash
# During merge conflict resolution
git merge --abort

# Reset to state before merge
git reset --hard HEAD

# If merge commit already created
git reset --hard HEAD~1
```

## Merge Tools

### Popular Merge Tools

#### Command Line Tools
- **vimdiff**: Built into Vim
- **emacs**: Built into Emacs
- **kdiff3**: Cross-platform GUI tool

#### GUI Tools
- **Meld**: Linux/Windows GUI tool
- **P4Merge**: Perforce visual merge tool
- **Beyond Compare**: Commercial tool
- **VS Code**: Built-in merge conflict resolution

### Configuring Merge Tools

```bash
# Configure VS Code as merge tool
git config --global merge.tool vscode
git config --global mergetool.vscode.cmd 'code --wait $MERGED'

# Configure Meld
git config --global merge.tool meld

# Configure P4Merge
git config --global merge.tool p4merge
git config --global mergetool.p4merge.path "/Applications/p4merge.app/Contents/MacOS/p4merge"
```

### Using Merge Tools

```bash
# Launch configured merge tool
git mergetool

# Use specific tool
git mergetool --tool=meld

# Don't prompt for each file
git mergetool --no-prompt
```

## Best Practices for Merging

### Before Merging

1. **Update target branch**:
```bash
git checkout main
git pull origin main
```

2. **Test feature branch**:
```bash
git checkout feature-branch
# Run tests, verify functionality
```

3. **Rebase if needed**:
```bash
git rebase main
```

### During Merging

1. **Read conflict carefully**
2. **Understand both changes**
3. **Test after resolution**
4. **Write meaningful merge commit messages**

### After Merging

1. **Test merged code**
2. **Delete feature branch**:
```bash
git branch -d feature-branch
```

3. **Push changes**:
```bash
git push origin main
```

## Common Merge Scenarios

### Scenario 1: Simple Feature Merge

```bash
# Feature completed, ready to merge
git checkout main
git pull origin main
git merge feature-user-profile
git push origin main
git branch -d feature-user-profile
```

### Scenario 2: Conflict Resolution

```bash
# Merge with conflicts
git checkout main
git merge feature-branch
# CONFLICT: Merge conflict in file.js

# Resolve conflicts
vim file.js  # Edit and resolve
git add file.js
git commit

# Push merged changes
git push origin main
```

### Scenario 3: Multiple Branch Merge

```bash
# Merge multiple related branches
git checkout main
git merge feature-frontend feature-backend
# Resolve any conflicts
git commit -m "Merge frontend and backend features"
```

## Merge vs Rebase

### When to Use Merge

- **Preserving context**: Keep branch history
- **Collaborative branches**: Multiple developers
- **Feature completion**: Clear feature boundaries
- **Public branches**: Already pushed branches

### When to Use Rebase

- **Linear history**: Clean, straight-line history
- **Private branches**: Not yet pushed
- **Cleanup**: Before merging to main
- **Synchronization**: Update feature branch with main

## Troubleshooting Merge Issues

### Common Problems

#### Problem: Merge Conflicts Too Complex
```bash
# Solution: Abort and try different approach
git merge --abort

# Try rebasing first
git rebase main
# Resolve conflicts incrementally
git checkout main
git merge feature-branch
```

#### Problem: Wrong Files Merged
```bash
# Solution: Reset to before merge
git reset --hard HEAD~1

# Or use reflog to find previous state
git reflog
git reset --hard HEAD@{1}
```

#### Problem: Merge Tool Not Working
```bash
# Solution: Configure different tool
git config --global merge.tool vimdiff

# Or resolve manually
git status  # See conflicted files
vim conflicted-file.js  # Edit manually
git add conflicted-file.js
git commit
```

## Exercises

### Exercise 1: Fast-Forward Merge
1. Create a repository with initial commit
2. Create feature branch and add commits
3. Merge back to main (should be fast-forward)
4. Verify the history

### Exercise 2: Three-Way Merge
1. Create feature branch from main
2. Add commits to both main and feature branch
3. Merge feature branch into main
4. Examine the merge commit

### Exercise 3: Conflict Resolution
1. Create conflicting changes in same file
2. Attempt to merge and encounter conflicts
3. Resolve conflicts manually
4. Complete the merge

### Exercise 4: Merge Tools
1. Install and configure a merge tool
2. Create merge conflicts
3. Use the merge tool to resolve conflicts
4. Compare with manual resolution

## Summary

Merging is a fundamental Git operation that enables:
- Combining work from different branches
- Integrating features into main codebase
- Collaborative development workflows
- Maintaining project history

Key concepts covered:
- Fast-forward vs three-way merges
- Conflict identification and resolution
- Merge strategies and options
- Merge tools and their configuration
- Best practices for successful merging

Understanding merging and conflict resolution is crucial for effective Git collaboration. The next chapter will explore advanced branching strategies that build upon these merging concepts to create robust development workflows.