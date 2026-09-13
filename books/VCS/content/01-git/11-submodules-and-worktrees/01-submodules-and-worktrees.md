---
title: "Submodules and worktrees"
---

# Submodules and worktrees

A **worktree** is a second checkout of *this* repository (same `.git`, another directory and branch). A **submodule** is a pointer to a **different** repository recorded as a gitlink + `.gitmodules`. A **subtree** vendors that other history into this repo’s tree.

| Need | Tool |
|------|------|
| Two branches checked out at once (hotfix vs feature) | `git worktree` |
| Depend on another repo at a pinned commit, still fetchable | submodule |
| Vendor a library and forget the extra clone | subtree (or just copy) |

Prefer worktrees over stashing to “switch branches with dirty files.” Prefer a package manager over submodules when the other project is a library.

## Try this

1. `git worktree add ../desk-hotfix hotfix/login` from a repo that already has `main`. Commit in the hotfix tree; `git log` on `main` in the original tree. Remove the worktree with `git worktree remove`.
2. Add a tiny second repo as a submodule. Clone the parent with `--recurse-submodules`. Change the submodule pin and commit `.gitmodules` + the gitlink.
3. Compare `git submodule status` after a plain `git clone` without recurse (empty directory) vs with recurse.

## Git Worktree

Git worktree allows you to have multiple working directories for the same repository.

### Basic Worktree Operations

```bash
# List existing worktrees
git worktree list

# Add new worktree
git worktree add ../feature-work feature-branch

# Add worktree with new branch
git worktree add -b new-feature ../new-feature-work

# Remove worktree
git worktree remove ../feature-work

# Prune stale worktree references
git worktree prune
```

### Worktree Use Cases

#### Parallel Development
```bash
# Main development in current directory
# Feature development in separate directory
git worktree add ../feature-auth feature/authentication

# Work on feature in separate directory
cd ../feature-auth
# Make changes and commits

# Switch back to main work
cd ../main-repo
```

#### Testing Different Branches
```bash
# Create worktree for testing
git worktree add ../test-branch test-branch

# Run tests in separate environment
cd ../test-branch
npm test

# Clean up when done
cd ../main-repo
git worktree remove ../test-branch
```


## Git Submodules

Submodules allow you to include other Git repositories as subdirectories.

### Basic Submodule Operations

```bash
# Add submodule
git submodule add https://github.com/user/library.git libs/library

# Initialize submodules after cloning
git submodule init
git submodule update

# Or combine both commands
git submodule update --init

# Update submodules to latest commits
git submodule update --remote

# Update specific submodule
git submodule update --remote libs/library
```

### Working with Submodules

```bash
# Clone repository with submodules
git clone --recursive https://github.com/user/project.git

# Update submodule to specific commit
cd libs/library
git checkout v2.0
cd ../..
git add libs/library
git commit -m "Update library to v2.0"

# Push submodule changes
git push --recurse-submodules=on-demand
```

### Submodule Configuration

```bash
# Configure submodule to track specific branch
git config -f .gitmodules submodule.libs/library.branch main

# Update submodule configuration
git submodule sync

# Remove submodule
git submodule deinit libs/library
git rm libs/library
rm -rf .git/modules/libs/library
```


## Git Subtree

Git subtree provides an alternative to submodules for including external repositories.

### Basic Subtree Operations

```bash
# Add subtree
git subtree add --prefix=libs/library https://github.com/user/library.git main --squash

# Pull updates from subtree
git subtree pull --prefix=libs/library https://github.com/user/library.git main --squash

# Push changes back to subtree
git subtree push --prefix=libs/library https://github.com/user/library.git main

# Split subtree into separate branch
git subtree split --prefix=libs/library -b library-branch
```

### Subtree vs Submodule

| Feature | Submodule | Subtree |
|---------|-----------|---------|
| Complexity | More complex | Simpler |
| History | Separate | Merged |
| Cloning | Requires --recursive | Normal clone |
| Updates | Manual | Integrated |
| Size | Smaller | Larger |
