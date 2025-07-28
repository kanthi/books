# Chapter 11: Rewriting History

## Introduction to History Rewriting

Git allows you to modify commit history, which can be powerful for cleaning up your work before sharing it with others. However, rewriting history should be done carefully, especially on shared branches.

### When to Rewrite History

**Safe scenarios (private branches):**
- Clean up messy commit history before merging
- Fix commit messages with typos or unclear descriptions
- Combine related commits into logical units
- Remove sensitive information accidentally committed
- Reorganize commits for better logical flow

**Dangerous scenarios (shared branches):**
- Never rewrite history on public branches (main, develop)
- Avoid rewriting commits that others have based work on
- Don't rewrite history on collaborative feature branches

### The Golden Rule

**Never rewrite history that has been pushed and shared with others unless you have explicit agreement from all collaborators.**

## Interactive Rebasing

Interactive rebase is the most powerful tool for rewriting history. It allows you to modify, reorder, combine, and delete commits.

### Starting Interactive Rebase

```bash
# Rebase last 3 commits
git rebase -i HEAD~3

# Rebase from specific commit
git rebase -i abc1234

# Rebase from branch point
git rebase -i main
```

### Interactive Rebase Commands

When you start interactive rebase, Git opens an editor with commands:

```bash
pick f7f3f6d Add feature A
pick 310154e Fix typo in feature A
pick a5f4a0d Add feature B

# Rebase abc1234..def5678 onto abc1234 (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
```

### Common Rebase Operations

#### 1. Squashing Commits

Combine multiple related commits into one:

```bash
# Original commits:
pick f7f3f6d Add user login form
pick 310154e Fix login form validation
pick a5f4a0d Add login form styling

# Change to:
pick f7f3f6d Add user login form
squash 310154e Fix login form validation
squash a5f4a0d Add login form styling

# Result: Single commit with combined changes
```

#### 2. Reordering Commits

Change the order of commits:

```bash
# Original order:
pick f7f3f6d Add feature A
pick 310154e Add feature B
pick a5f4a0d Fix feature A

# Reorder to:
pick f7f3f6d Add feature A
pick a5f4a0d Fix feature A
pick 310154e Add feature B
```

#### 3. Editing Commits

Stop at a commit to make changes:

```bash
# Mark commit for editing:
edit f7f3f6d Add user authentication
pick 310154e Add password validation

# Git stops at the commit, allowing you to:
# Make changes to files
git add modified-file.js
git commit --amend

# Continue rebase
git rebase --continue
```

#### 4. Dropping Commits

Remove commits entirely:

```bash
# Remove unwanted commit:
pick f7f3f6d Add feature A
drop 310154e Add debug logging  # This commit will be removed
pick a5f4a0d Add feature B
```

#### 5. Rewording Commit Messages

Change commit messages:

```bash
# Change commit message:
reword f7f3f6d Add user authentication  # Will prompt for new message
pick 310154e Add password validation
```

## Amending Commits

### Amending the Last Commit

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

### Amending Author Information

```bash
# Change author of last commit
git commit --amend --author="New Author <new.email@example.com>"

# Change author and committer
git commit --amend --author="New Author <new.email@example.com>" --reset-author
```

## Squashing Commits

### Manual Squashing with Reset

```bash
# Reset to 3 commits ago (keeping changes)
git reset --soft HEAD~3

# Create new commit with all changes
git commit -m "Combined commit message"
```

### Squashing During Merge

```bash
# Squash merge (combines all commits into one)
git checkout main
git merge --squash feature-branch
git commit -m "Add complete feature X"
```

## Cherry-Picking

Cherry-picking allows you to apply specific commits from one branch to another.

### Basic Cherry-Pick

```bash
# Apply specific commit to current branch
git cherry-pick abc1234

# Cherry-pick multiple commits
git cherry-pick abc1234 def5678 ghi9012

# Cherry-pick range of commits
git cherry-pick abc1234..def5678
```

### Cherry-Pick Options

```bash
# Cherry-pick without committing (stage changes only)
git cherry-pick --no-commit abc1234

# Cherry-pick and edit commit message
git cherry-pick --edit abc1234

# Cherry-pick and sign off
git cherry-pick --signoff abc1234

# Continue after resolving conflicts
git cherry-pick --continue

# Abort cherry-pick
git cherry-pick --abort
```

### Cherry-Pick Use Cases

#### Hotfix to Multiple Branches

```bash
# Fix applied to main branch
git checkout main
git commit -m "Fix critical security issue"

# Apply same fix to release branch
git checkout release/v1.2
git cherry-pick main

# Apply to another release branch
git checkout release/v1.1
git cherry-pick main
```

#### Selective Feature Porting

```bash
# Pick specific improvements from feature branch
git checkout main
git cherry-pick feature-branch~2  # Pick specific commit
git cherry-pick feature-branch~1  # Pick another commit
```

## Handling Conflicts During Rebase

### Conflict Resolution Process

```bash
# Start rebase
git rebase -i HEAD~3

# If conflicts occur:
# CONFLICT (content): Merge conflict in file.txt
# error: could not apply abc1234... commit message

# 1. View conflicted files
git status

# 2. Resolve conflicts manually
vim file.txt  # Edit and resolve conflicts

# 3. Stage resolved files
git add file.txt

# 4. Continue rebase
git rebase --continue

# Or abort if needed
git rebase --abort
```

### Rebase Conflict Strategies

```bash
# Use merge strategy during rebase
git rebase -X ours main        # Prefer current branch
git rebase -X theirs main      # Prefer target branch

# Skip problematic commit
git rebase --skip

# Edit commit during conflict
git rebase --edit-todo
```

## Advanced History Rewriting

### Filter-Branch (Legacy)

```bash
# Remove file from entire history (use with caution)
git filter-branch --force --index-filter \
  'git rm --cached --ignore-unmatch secrets.txt' \
  --prune-empty --tag-name-filter cat -- --all
```

### Git Filter-Repo (Modern Alternative)

```bash
# Install git-filter-repo
pip install git-filter-repo

# Remove file from history
git filter-repo --path secrets.txt --invert-paths

# Remove directory from history
git filter-repo --path sensitive-dir/ --invert-paths

# Change author information
git filter-repo --mailmap mailmap.txt
```

### BFG Repo-Cleaner

```bash
# Install BFG
# Download from: https://rtyley.github.io/bfg-repo-cleaner/

# Remove large files
java -jar bfg.jar --strip-blobs-bigger-than 100M my-repo.git

# Remove sensitive data
java -jar bfg.jar --delete-files passwords.txt my-repo.git

# Clean up after BFG
cd my-repo.git
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

## Rewriting Shared History

### When Rewriting Shared History is Necessary

Sometimes you must rewrite shared history:
- Removing sensitive information (passwords, keys)
- Legal requirements (removing copyrighted content)
- Fixing critical issues in commit history

### Safe Shared History Rewriting Process

```bash
# 1. Communicate with all team members
# 2. Ensure everyone has pushed their work
# 3. Coordinate timing for the rewrite

# 4. Perform the rewrite
git filter-repo --path secrets.txt --invert-paths

# 5. Force push to all branches
git push --force-with-lease --all origin
git push --force-with-lease --tags origin

# 6. Team members must re-clone or reset their repositories
# Each team member:
git fetch origin
git reset --hard origin/main
```

### Communicating History Changes

```markdown
# Team notification template:
Subject: URGENT: Repository history rewrite required

Team,

We need to rewrite the repository history to remove sensitive information
that was accidentally committed.

REQUIRED ACTIONS:
1. Push all your current work before [DATE/TIME]
2. After the rewrite, you must:
   - Delete your local repository
   - Clone fresh from origin
   - OR reset your branches: git reset --hard origin/main

Timeline:
- [DATE/TIME]: Deadline to push work
- [DATE/TIME]: History rewrite performed
- [DATE/TIME]: Repository available with new history

Please confirm receipt of this message.
```

## Best Practices for History Rewriting

### Before Rewriting

1. **Backup your work**: Create backup branches
   ```bash
   git branch backup-before-rebase
   ```

2. **Ensure clean working directory**:
   ```bash
   git status  # Should show "working tree clean"
   ```

3. **Communicate with team**: Inform others about planned changes

### During Rewriting

1. **Work on feature branches**: Never rewrite main/develop directly
2. **Test after rewriting**: Ensure code still works
3. **Review changes carefully**: Double-check what you're changing

### After Rewriting

1. **Test thoroughly**: Run all tests
2. **Review history**: Ensure changes are correct
   ```bash
   git log --oneline --graph
   ```
3. **Force push carefully**: Use `--force-with-lease`
   ```bash
   git push --force-with-lease origin feature-branch
   ```

## Recovery from Mistakes

### Using Reflog

```bash
# View reflog to find lost commits
git reflog

# Recover lost commit
git checkout abc1234  # From reflog
git branch recovery-branch  # Create branch to save it

# Reset to previous state
git reset --hard HEAD@{2}  # From reflog entry
```

### Recovering from Bad Rebase

```bash
# Find the commit before rebase started
git reflog
# Find entry like: abc1234 HEAD@{5}: rebase -i (start)

# Reset to before rebase
git reset --hard HEAD@{5}

# Or create recovery branch
git branch recovery-branch HEAD@{5}
```

## Exercises

### Exercise 1: Interactive Rebase Practice
1. Create a repository with messy commit history
2. Use interactive rebase to clean it up:
   - Squash related commits
   - Reword unclear messages
   - Reorder commits logically
3. Compare before and after history

### Exercise 2: Cherry-Pick Scenarios
1. Create multiple branches with different features
2. Practice cherry-picking specific commits between branches
3. Handle conflicts during cherry-picking
4. Use cherry-pick for hotfix scenarios

### Exercise 3: Amending Commits
1. Practice amending commit messages
2. Add forgotten files to commits
3. Change author information
4. Understand when amending is appropriate

### Exercise 4: Recovery Practice
1. Intentionally mess up history with bad rebase
2. Use reflog to understand what happened
3. Recover lost commits
4. Reset to previous state

## Common Pitfalls and Solutions

### Pitfall 1: Rewriting Public History
```bash
# Problem: Rewrote history on shared branch
# Solution: Communicate with team and coordinate reset

# For team members:
git fetch origin
git reset --hard origin/main
```

### Pitfall 2: Lost Commits During Rebase
```bash
# Problem: Commits disappeared during rebase
# Solution: Use reflog to recover

git reflog
git branch recovery HEAD@{n}  # Where n is the reflog entry
```

### Pitfall 3: Conflicts During Interactive Rebase
```bash
# Problem: Complex conflicts during rebase
# Solution: Abort and try different approach

git rebase --abort
# Try smaller chunks or different strategy
```

## Summary

History rewriting is a powerful Git feature that enables:

- **Clean commit history**: Organize commits logically
- **Professional presentation**: Clean up before sharing
- **Error correction**: Fix mistakes in commit messages or content
- **Selective changes**: Apply specific commits across branches

Key tools covered:
- Interactive rebase for comprehensive history editing
- Commit amending for quick fixes
- Cherry-picking for selective commit application
- Recovery techniques for when things go wrong

Remember the golden rule: **Never rewrite shared history without team coordination**. Use these tools responsibly to maintain clean, professional commit histories while preserving collaboration integrity.

The next chapter will explore advanced Git commands that complement these history rewriting techniques for comprehensive repository management.