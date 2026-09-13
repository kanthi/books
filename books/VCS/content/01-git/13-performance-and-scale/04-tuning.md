---
title: "Tuning and health"
---

# Tuning and health

## Git Performance Optimization

### Repository Size Management

Large repositories can impact performance. Here are strategies to optimize:

#### Shallow Clones
```bash
# Clone with limited history
git clone --depth 1 https://github.com/user/repo.git

# Deepen shallow clone
git fetch --unshallow

# Shallow clone specific branch
git clone --depth 1 --branch main https://github.com/user/repo.git
```

#### Sparse Checkout
```bash
# Enable sparse checkout
git config core.sparseCheckout true

# Define which directories to include
echo "src/" > .git/info/sparse-checkout
echo "docs/" >> .git/info/sparse-checkout

# Apply sparse checkout
git read-tree -m -u HEAD
```

#### Git LFS (Large File Storage)
```bash
# Install Git LFS
git lfs install

# Track large files
git lfs track "*.psd"
git lfs track "*.zip"
git lfs track "videos/*"

# Add .gitattributes
git add .gitattributes

# Large files are now stored in LFS
git add large-file.zip
git commit -m "Add large file via LFS"
```

### Repository Maintenance

#### Garbage Collection
```bash
# Manual garbage collection
git gc

# Aggressive garbage collection
git gc --aggressive

# Prune unreachable objects
git prune

# Check repository size
git count-objects -vH
```

#### Pack File Optimization
```bash
# Repack repository
git repack -ad

# Repack with delta compression
git repack -a -d --depth=50 --window=50

# Verify pack integrity
git verify-pack -v .git/objects/pack/pack-*.idx
```


## Performance Monitoring

### Repository Health Metrics

#### Size and Performance Monitoring
```bash
#!/bin/bash
# Repository health check

echo "Repository Health Report"
echo "======================="

echo "Repository size:"
du -sh .git

echo -e "\nObject count:"
git count-objects -v

echo -e "\nLargest files:"
git rev-list --objects --all | \
git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | \
grep '^blob' | sort -k3nr | head -10

echo -e "\nBranch count:"
git branch -a | wc -l

echo -e "\nRecent activity:"
git log --oneline --since="7 days ago" | wc -l
```

#### Performance Benchmarking
```bash
#!/bin/bash
# Git operation benchmarks

echo "Git Performance Benchmarks"
echo "=========================="

echo "Clone time:"
time git clone --quiet https://github.com/user/repo.git temp-repo
rm -rf temp-repo

echo -e "\nStatus time:"
time git status > /dev/null

echo -e "\nLog time:"
time git log --oneline -100 > /dev/null

echo -e "\nDiff time:"
time git diff HEAD~10 HEAD > /dev/null
```

