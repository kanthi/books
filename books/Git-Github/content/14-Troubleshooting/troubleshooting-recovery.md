# Chapter 14: Troubleshooting and Recovery

## Common Git Problems and Solutions

### Repository Corruption

#### Symptoms
- Git commands fail with "object not found" errors
- Repository appears corrupted or inconsistent
- Strange behavior during operations

#### Diagnosis
```bash
# Check repository integrity
git fsck --full

# Check for dangling objects
git fsck --unreachable

# Verify pack files
git verify-pack -v .git/objects/pack/pack-*.idx

# Check object database
git count-objects -v
```

#### Recovery Steps
```bash
# 1. Backup current repository
cp -r .git .git.backup

# 2. Try garbage collection
git gc --aggressive --prune=now

# 3. Rebuild index if corrupted
rm .git/index
git reset

# 4. If severe corruption, clone fresh copy
git clone --mirror <remote-url> .git.new
mv .git .git.corrupted
mv .git.new .git
git reset --hard HEAD
```

### Lost Commits

#### Using Reflog
```bash
# View reflog to find lost commits
git reflog

# Look for entries like:
# abc1234 HEAD@{5}: reset: moving to HEAD~3
# def5678 HEAD@{6}: commit: Important work

# Recover lost commit
git checkout def5678
git branch recovery-branch

# Or reset to lost commit
git reset --hard def5678
```

#### Finding Dangling Commits
```bash
# Find unreachable commits
git fsck --unreachable | grep commit

# Examine unreachable commits
git show <commit-hash>

# Create branch from recovered commit
git branch recovered-work <commit-hash>
```

#### Recovery from Hard Reset
```bash
# Find commit before reset
git reflog | grep "reset:"

# Example output:
# abc1234 HEAD@{1}: reset: moving to HEAD~5
# def5678 HEAD@{2}: commit: Work before reset

# Recover to state before reset
git reset --hard HEAD@{2}

# Or create branch to preserve current state
git branch before-recovery
git reset --hard def5678
```

### Branch Recovery

#### Deleted Branch Recovery
```bash
# Find deleted branch in reflog
git reflog | grep "checkout: moving from deleted-branch"

# Example:
# abc1234 HEAD@{10}: checkout: moving from feature-branch to main

# Recreate branch
git branch feature-branch abc1234

# Verify recovery
git log feature-branch --oneline
```

#### Corrupted Branch Reference
```bash
# Check branch references
cat .git/refs/heads/branch-name

# If reference is corrupted, find correct commit
git log --all --grep="last known commit message"

# Update branch reference
git update-ref refs/heads/branch-name <correct-commit-hash>
```

### Merge Conflicts Resolution

#### Complex Merge Conflicts
```bash
# Abort current merge
git merge --abort

# Use different merge strategy
git merge -X ours feature-branch    # Prefer our changes
git merge -X theirs feature-branch  # Prefer their changes

# Use specific merge strategy
git merge -s recursive -X patience feature-branch
```

#### Binary File Conflicts
```bash
# For binary files, choose one version
git checkout --ours binary-file.jpg
git checkout --theirs binary-file.jpg

# Add resolved file
git add binary-file.jpg
git commit
```

#### Resolving Rename Conflicts
```bash
# When files are renamed differently in branches
# Git shows both versions

# Choose the correct name and remove the other
git rm old-name.txt
git add new-name.txt
git commit
```

### Rebase Problems

#### Rebase Conflicts
```bash
# During rebase, conflicts occur
git status  # Shows conflicted files

# Resolve conflicts in files
vim conflicted-file.txt

# Stage resolved files
git add conflicted-file.txt

# Continue rebase
git rebase --continue

# Or skip problematic commit
git rebase --skip

# Or abort rebase
git rebase --abort
```

#### Rebase Gone Wrong
```bash
# Find state before rebase
git reflog | grep "rebase"

# Example:
# abc1234 HEAD@{5}: rebase -i (start): checkout HEAD~3
# def5678 HEAD@{6}: commit: Work before rebase

# Reset to before rebase
git reset --hard HEAD@{6}

# Or create recovery branch
git branch rebase-recovery HEAD@{6}
```

#### Interactive Rebase Issues
```bash
# If rebase editor shows wrong commits
git rebase --edit-todo

# If you need to modify a commit during rebase
git commit --amend
git rebase --continue

# If rebase creates duplicate commits
git rebase --onto <new-base> <old-base> <branch>
```

### Remote Repository Issues

#### Push Rejected
```bash
# Error: Updates were rejected because remote contains work

# Solution 1: Pull and merge
git pull origin main
git push origin main

# Solution 2: Pull with rebase
git pull --rebase origin main
git push origin main

# Solution 3: Force push (dangerous)
git push --force-with-lease origin main
```

#### Diverged Branches
```bash
# Local and remote have diverged
git status
# Your branch and 'origin/main' have diverged

# View divergence
git log --oneline --graph origin/main main

# Solution 1: Merge remote changes
git merge origin/main

# Solution 2: Rebase onto remote
git rebase origin/main

# Solution 3: Reset to remote (loses local changes)
git reset --hard origin/main
```

#### Authentication Issues
```bash
# SSH key problems
ssh -T git@github.com

# If key not found
ssh-add ~/.ssh/id_rsa

# Generate new key if needed
ssh-keygen -t ed25519 -C "your.email@example.com"

# HTTPS credential issues
git config --global credential.helper store
# Or use credential manager
git config --global credential.helper manager
```

### Working Directory Issues

#### Untracked Files Blocking Operations
```bash
# Error: The following untracked files would be overwritten

# Solution 1: Stash including untracked files
git stash -u

# Solution 2: Remove untracked files
git clean -fd

# Solution 3: Add files to .gitignore
echo "problematic-file" >> .gitignore
git add .gitignore
git commit -m "Add gitignore entry"
```

#### File Permission Issues
```bash
# Git tracking file permission changes
git config core.filemode false

# Reset file permissions
git diff --summary | grep --color=never "mode change" | cut -d' ' -f7- | xargs chmod 644

# For executable files
find . -name "*.sh" -exec chmod +x {} \;
```

#### Line Ending Issues
```bash
# Configure line ending handling
git config --global core.autocrlf true   # Windows
git config --global core.autocrlf input  # macOS/Linux

# Fix existing line ending issues
git add --renormalize .
git commit -m "Normalize line endings"
```

## Advanced Recovery Techniques

### Repository Reconstruction

#### From Corrupted Repository
```bash
# Create new repository
mkdir recovered-repo
cd recovered-repo
git init

# Extract objects from corrupted repository
cp -r ../corrupted-repo/.git/objects .git/

# Find all commits
git fsck --unreachable | grep commit | cut -d' ' -f3 > commits.txt

# Examine commits to find branch heads
while read commit; do
    echo "=== $commit ==="
    git log --oneline -1 $commit
    git show --name-only $commit
done < commits.txt

# Recreate branches
git branch main <main-branch-commit>
git branch feature <feature-branch-commit>
```

#### From Backup Files
```bash
# If you have file backups but no Git history
git init
git add .
git commit -m "Restore from backup"

# If you have multiple backup versions
for backup in backup-*; do
    cp -r "$backup"/* .
    git add .
    git commit -m "Restore from $backup"
done
```

### Data Recovery Tools

#### Git Filter-Repo for History Cleanup
```bash
# Install git-filter-repo
pip install git-filter-repo

# Remove sensitive file from entire history
git filter-repo --path sensitive-file.txt --invert-paths

# Remove large files
git filter-repo --strip-blobs-bigger-than 10M

# Change author information
echo "Old Name <old@email.com> = New Name <new@email.com>" > mailmap
git filter-repo --mailmap mailmap
```

#### BFG Repo-Cleaner
```bash
# Download BFG from https://rtyley.github.io/bfg-repo-cleaner/

# Remove passwords from history
java -jar bfg.jar --replace-text passwords.txt my-repo.git

# Remove large files
java -jar bfg.jar --strip-blobs-bigger-than 100M my-repo.git

# Clean up after BFG
cd my-repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### Emergency Procedures

#### Complete Repository Recovery
```bash
#!/bin/bash
# emergency-recovery.sh

REPO_PATH="$1"
BACKUP_PATH="${REPO_PATH}.emergency-backup"

echo "Starting emergency recovery for $REPO_PATH"

# 1. Create backup
echo "Creating backup..."
cp -r "$REPO_PATH" "$BACKUP_PATH"

# 2. Check repository integrity
echo "Checking repository integrity..."
cd "$REPO_PATH"
if ! git fsck --full; then
    echo "Repository corruption detected"
fi

# 3. Attempt automatic recovery
echo "Attempting automatic recovery..."
git gc --aggressive --prune=now

# 4. Check if recovery successful
if git fsck --full; then
    echo "Recovery successful"
else
    echo "Automatic recovery failed, manual intervention required"
    exit 1
fi

# 5. Verify branches
echo "Verifying branches..."
git branch -a

# 6. Check recent commits
echo "Recent commits:"
git log --oneline -10

echo "Emergency recovery completed"
```

#### Disaster Recovery Plan
```bash
#!/bin/bash
# disaster-recovery.sh

# Configuration
REMOTE_URL="https://github.com/user/repo.git"
LOCAL_PATH="./recovered-repo"
BACKUP_PATH="./repo-backup"

echo "=== DISASTER RECOVERY PROCEDURE ==="

# Step 1: Assess damage
echo "1. Assessing repository damage..."
if [ -d ".git" ]; then
    git fsck --full > fsck-report.txt 2>&1
    if [ $? -eq 0 ]; then
        echo "Repository appears intact"
        exit 0
    else
        echo "Repository corruption detected"
    fi
else
    echo "No Git repository found"
fi

# Step 2: Create backup of current state
echo "2. Creating backup of current state..."
if [ -d ".git" ]; then
    cp -r . "$BACKUP_PATH"
    echo "Backup created at $BACKUP_PATH"
fi

# Step 3: Clone fresh copy from remote
echo "3. Cloning fresh copy from remote..."
git clone "$REMOTE_URL" "$LOCAL_PATH"

# Step 4: Recover local changes
echo "4. Attempting to recover local changes..."
if [ -d "$BACKUP_PATH" ]; then
    cd "$LOCAL_PATH"

    # Copy working directory changes
    rsync -av --exclude='.git' "$BACKUP_PATH/" ./

    # Show what was recovered
    git status

    echo "Local changes recovered. Review and commit as needed."
fi

echo "=== RECOVERY COMPLETE ==="
```

## Preventive Measures

### Repository Health Monitoring

#### Health Check Script
```bash
#!/bin/bash
# repo-health-check.sh

echo "=== REPOSITORY HEALTH CHECK ==="

# Check repository integrity
echo "Checking repository integrity..."
if git fsck --full --strict; then
    echo "✓ Repository integrity: OK"
else
    echo "✗ Repository integrity: ISSUES FOUND"
fi

# Check repository size
echo "Checking repository size..."
repo_size=$(du -sh .git | cut -f1)
echo "Repository size: $repo_size"

# Check for large objects
echo "Checking for large objects..."
git rev-list --objects --all | \
git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
grep '^blob' | sort -k3nr | head -5 | \
while read type hash size path; do
    echo "Large object: $path ($size bytes)"
done

# Check branch count
branch_count=$(git branch -a | wc -l)
echo "Branch count: $branch_count"

# Check recent activity
echo "Recent activity (last 7 days):"
git log --since="7 days ago" --oneline | wc -l | xargs echo "Commits:"

# Check for potential issues
echo "Checking for potential issues..."

# Uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "⚠ Uncommitted changes detected"
fi

# Untracked files
if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "⚠ Untracked files present"
fi

# Stashes
stash_count=$(git stash list | wc -l)
if [ $stash_count -gt 0 ]; then
    echo "⚠ $stash_count stashes present"
fi

echo "=== HEALTH CHECK COMPLETE ==="
```

### Backup Strategies

#### Automated Backup Script
```bash
#!/bin/bash
# backup-repo.sh

REPO_PATH="$1"
BACKUP_DIR="/backups/git-repos"
DATE=$(date +%Y%m%d_%H%M%S)
REPO_NAME=$(basename "$REPO_PATH")

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create bare clone backup
echo "Creating backup of $REPO_NAME..."
git clone --bare "$REPO_PATH" "$BACKUP_DIR/${REPO_NAME}_${DATE}.git"

# Compress backup
cd "$BACKUP_DIR"
tar -czf "${REPO_NAME}_${DATE}.tar.gz" "${REPO_NAME}_${DATE}.git"
rm -rf "${REPO_NAME}_${DATE}.git"

# Keep only last 10 backups
ls -t "${REPO_NAME}"_*.tar.gz | tail -n +11 | xargs rm -f

echo "Backup completed: $BACKUP_DIR/${REPO_NAME}_${DATE}.tar.gz"
```

#### Remote Backup Strategy
```bash
#!/bin/bash
# remote-backup.sh

# Multiple remote backups
git remote add backup-github https://github.com/user/repo-backup.git
git remote add backup-gitlab https://gitlab.com/user/repo-backup.git

# Push to all remotes
for remote in origin backup-github backup-gitlab; do
    echo "Pushing to $remote..."
    git push "$remote" --all
    git push "$remote" --tags
done
```

### Monitoring and Alerting

#### Repository Monitor
```bash
#!/bin/bash
# repo-monitor.sh

REPO_PATH="$1"
ALERT_EMAIL="admin@example.com"

cd "$REPO_PATH"

# Check for corruption
if ! git fsck --full --quiet; then
    echo "Repository corruption detected in $REPO_PATH" | \
    mail -s "Git Repository Alert" "$ALERT_EMAIL"
fi

# Check repository size
size=$(du -s .git | cut -f1)
if [ $size -gt 1000000 ]; then  # 1GB in KB
    echo "Repository size exceeded 1GB: $REPO_PATH" | \
    mail -s "Git Repository Size Alert" "$ALERT_EMAIL"
fi

# Check for old branches
git for-each-ref --format='%(refname:short) %(committerdate)' refs/heads | \
while read branch date; do
    if [ $(date -d "$date" +%s) -lt $(date -d "90 days ago" +%s) ]; then
        echo "Old branch detected: $branch (last commit: $date)"
    fi
done
```

## Exercises

### Exercise 1: Corruption Recovery
1. Create a repository and simulate corruption
2. Practice using fsck and recovery commands
3. Implement automated health checks
4. Test backup and restore procedures

### Exercise 2: Conflict Resolution
1. Create complex merge conflicts
2. Practice different resolution strategies
3. Handle binary file conflicts
4. Resolve rebase conflicts

### Exercise 3: History Recovery
1. Simulate lost commits and branches
2. Use reflog for recovery
3. Practice filter-repo for cleanup
4. Implement emergency recovery procedures

### Exercise 4: Preventive Measures
1. Set up automated backups
2. Implement repository monitoring
3. Create disaster recovery plan
4. Test recovery procedures

## Best Practices

### Prevention
1. **Regular backups**: Automate repository backups
2. **Health monitoring**: Regular integrity checks
3. **Team training**: Educate team on Git best practices
4. **Branch protection**: Prevent direct pushes to important branches
5. **Code review**: Catch issues before they enter main branch

### Recovery
1. **Stay calm**: Don't panic when issues occur
2. **Backup first**: Always backup before attempting recovery
3. **Understand the problem**: Diagnose before attempting fixes
4. **Document incidents**: Learn from recovery experiences
5. **Test procedures**: Regularly test recovery procedures

### Communication
1. **Alert team**: Inform team of repository issues
2. **Document steps**: Record recovery procedures
3. **Share knowledge**: Train team members on recovery
4. **Post-mortem**: Analyze incidents to prevent recurrence
5. **Update procedures**: Improve based on experience

## Summary

Effective Git troubleshooting and recovery requires:

- **Diagnostic skills**: Understanding Git internals and error messages
- **Recovery techniques**: Using reflog, fsck, and specialized tools
- **Preventive measures**: Monitoring, backups, and health checks
- **Emergency procedures**: Systematic approach to disaster recovery
- **Team coordination**: Communication and documentation

Key skills developed:
- Repository corruption diagnosis and repair
- Commit and branch recovery techniques
- Conflict resolution strategies
- Advanced recovery tools usage
- Preventive monitoring implementation

Git's distributed nature provides inherent resilience, but understanding recovery techniques ensures you can handle any situation confidently. These skills are essential for maintaining repository health and team productivity.

The next chapter will explore GitHub's advanced features, building upon this solid foundation of Git troubleshooting and recovery skills.