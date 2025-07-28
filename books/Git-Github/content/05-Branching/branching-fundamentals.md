# Chapter 5: Branching Fundamentals

## What are Branches?

A branch in Git is simply a movable pointer to a specific commit. Unlike many other version control systems, Git branches are lightweight and fast to create, making branching and merging a core part of the Git workflow.

### Key Concepts

- **Branch**: A movable pointer to a commit
- **HEAD**: A pointer to the current branch
- **Default Branch**: Usually `main` or `master`
- **Working Directory**: Reflects the content of the current branch

## Why Use Branches?

Branches enable:
- **Parallel Development**: Work on multiple features simultaneously
- **Experimentation**: Try new ideas without affecting main code
- **Collaboration**: Multiple developers working independently
- **Release Management**: Maintain different versions
- **Bug Fixes**: Isolate fixes from ongoing development

## Creating and Switching Branches

### Creating Branches

```bash
# Create a new branch
git branch feature-login

# Create and switch to new branch
git checkout -b feature-login

# Modern syntax (Git 2.23+)
git switch -c feature-login

# Create branch from specific commit
git branch feature-login abc1234

# Create branch from another branch
git branch feature-login develop
```

### Switching Branches

```bash
# Switch to existing branch
git checkout feature-login

# Modern syntax
git switch feature-login

# Switch to previous branch
git checkout -
git switch -

# Switch and create if doesn't exist
git checkout -b feature-login
git switch -c feature-login
```

### Branch Information

```bash
# List all branches
git branch

# List all branches with last commit
git branch -v

# List remote branches
git branch -r

# List all branches (local and remote)
git branch -a

# Show current branch
git branch --show-current

# Show branches merged into current branch
git branch --merged

# Show branches not merged into current branch
git branch --no-merged
```

## Understanding Branch Pointers

### Visualizing Branches

```bash
# View branch history graphically
git log --oneline --graph --all

# More detailed graph
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all
```

Example output:
```
* 2f8a1b3 - (HEAD -> feature-login) Add login form (2 hours ago) <John Doe>
* 1a2b3c4 - (main) Initial commit (1 day ago) <John Doe>
```

### How Branches Work Internally

When you create a branch, Git creates a new pointer:

```bash
# View branch references
cat .git/refs/heads/main
cat .git/refs/heads/feature-login

# View HEAD
cat .git/HEAD
```

## Branch Management

### Renaming Branches

```bash
# Rename current branch
git branch -m new-name

# Rename specific branch
git branch -m old-name new-name

# Rename and update upstream
git branch -m old-name new-name
git push origin -u new-name
git push origin --delete old-name
```

### Deleting Branches

```bash
# Delete merged branch
git branch -d feature-login

# Force delete unmerged branch
git branch -D feature-login

# Delete remote branch
git push origin --delete feature-login

# Delete local tracking branch
git branch -dr origin/feature-login
```

### Cleaning Up Branches

```bash
# Remove remote-tracking branches that no longer exist
git remote prune origin

# Remove local branches that have been merged
git branch --merged | grep -v "\*\|main\|develop" | xargs -n 1 git branch -d
```

## Working with Branches

### Basic Branch Workflow

```bash
# 1. Create and switch to feature branch
git checkout -b feature-user-profile

# 2. Make changes and commit
echo "User profile code" > profile.js
git add profile.js
git commit -m "Add user profile functionality"

# 3. Switch back to main
git checkout main

# 4. Merge feature branch
git merge feature-user-profile

# 5. Delete feature branch
git branch -d feature-user-profile
```

### Tracking Remote Branches

```bash
# Create local branch tracking remote branch
git checkout -b feature-login origin/feature-login

# Set upstream for existing branch
git branch -u origin/feature-login

# Push and set upstream
git push -u origin feature-login

# View tracking relationships
git branch -vv
```

## Branch Naming Conventions

### Common Patterns

```bash
# Feature branches
feature/user-authentication
feature/shopping-cart
feat/payment-integration

# Bug fix branches
bugfix/login-error
fix/memory-leak
hotfix/security-patch

# Release branches
release/v1.2.0
release/2023-q4

# Development branches
develop
staging
integration
```

### Best Practices

- Use descriptive names
- Include issue numbers: `feature/123-user-login`
- Use consistent prefixes
- Keep names short but meaningful
- Use lowercase and hyphens

## Branch Strategies

### Feature Branch Strategy

```bash
# Start feature
git checkout main
git pull origin main
git checkout -b feature/new-dashboard

# Develop feature
# ... make changes and commits ...

# Finish feature
git checkout main
git pull origin main
git merge feature/new-dashboard
git push origin main
git branch -d feature/new-dashboard
```

### Topic Branches

Short-lived branches for specific topics:

```bash
# Quick fix
git checkout -b fix-typo
echo "Fixed typo" > README.md
git commit -am "Fix typo in README"
git checkout main
git merge fix-typo
git branch -d fix-typo
```

## Advanced Branch Operations

### Branch Comparison

```bash
# Compare branches
git diff main..feature-branch

# Show commits in feature branch not in main
git log main..feature-branch

# Show commits in main not in feature branch
git log feature-branch..main

# Show commits in either branch but not both
git log main...feature-branch --left-right
```

### Branch Statistics

```bash
# Show branch commit count
git rev-list --count feature-branch

# Show branch age
git log -1 --format="%cr" feature-branch

# Show branch author
git log -1 --format="%an" feature-branch
```

## Stashing Changes

When switching branches with uncommitted changes:

```bash
# Stash current changes
git stash

# Switch branch
git checkout other-branch

# Switch back and restore changes
git checkout original-branch
git stash pop

# Stash with message
git stash save "Work in progress on feature X"

# List stashes
git stash list

# Apply specific stash
git stash apply stash@{1}
```

## Practical Examples

### Example 1: Feature Development

```bash
# Start new feature
git checkout main
git pull origin main
git checkout -b feature/user-notifications

# Implement feature
echo "Notification system" > notifications.js
git add notifications.js
git commit -m "Add notification system"

echo "Email notifications" > email.js
git add email.js
git commit -m "Add email notification support"

# Push feature branch
git push -u origin feature/user-notifications

# Create pull request (on GitHub)
# After review and approval, merge
git checkout main
git pull origin main
git branch -d feature/user-notifications
```

### Example 2: Hotfix Workflow

```bash
# Critical bug found in production
git checkout main
git pull origin main
git checkout -b hotfix/security-vulnerability

# Fix the issue
echo "Security fix" > security.patch
git add security.patch
git commit -m "Fix security vulnerability"

# Deploy hotfix
git checkout main
git merge hotfix/security-vulnerability
git push origin main
git tag v1.0.1
git push origin v1.0.1

# Clean up
git branch -d hotfix/security-vulnerability
```

## Troubleshooting Branch Issues

### Common Problems

#### Cannot Switch Branch (Uncommitted Changes)
```bash
# Problem: You have uncommitted changes
git checkout other-branch
# error: Your local changes would be overwritten

# Solutions:
# 1. Commit changes
git add .
git commit -m "WIP: Save current work"

# 2. Stash changes
git stash
git checkout other-branch

# 3. Force checkout (loses changes)
git checkout -f other-branch
```

#### Branch Diverged from Remote
```bash
# Problem: Local and remote branches have diverged
git push
# error: Updates were rejected because the tip of your current branch is behind

# Solutions:
# 1. Pull and merge
git pull origin feature-branch

# 2. Pull and rebase
git pull --rebase origin feature-branch

# 3. Force push (dangerous)
git push --force-with-lease origin feature-branch
```

## Branch Aliases

Useful Git aliases for branch operations:

```bash
# Add to ~/.gitconfig or use git config --global
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.nb "checkout -b"
git config --global alias.bd "branch -d"
git config --global alias.bD "branch -D"
```

## Exercises

### Exercise 1: Basic Branching
1. Create a new repository
2. Make initial commit on main branch
3. Create a feature branch
4. Make commits on both branches
5. Visualize the branch structure

### Exercise 2: Branch Management
1. Create multiple feature branches
2. Practice switching between branches
3. Rename a branch
4. Delete merged and unmerged branches
5. Clean up old branches

### Exercise 3: Collaborative Workflow
1. Simulate working with remote branches
2. Create local tracking branches
3. Push branches to remote
4. Practice upstream relationships

## Best Practices Summary

1. **Create branches frequently** for features and fixes
2. **Use descriptive names** that explain the purpose
3. **Keep branches focused** on single features or fixes
4. **Merge or delete** branches when done
5. **Pull before creating** new branches from main
6. **Test before merging** to ensure quality
7. **Use consistent naming** conventions
8. **Document branch purpose** in commit messages

## Summary

Branching is one of Git's most powerful features, enabling:
- Parallel development workflows
- Safe experimentation
- Organized feature development
- Effective collaboration

Key concepts covered:
- Branch creation and management
- Switching between branches
- Branch naming conventions
- Basic branching workflows
- Troubleshooting common issues

Understanding branching fundamentals is essential for effective Git usage. In the next chapter, we'll explore merging strategies and conflict resolution, which are crucial for combining work from different branches.