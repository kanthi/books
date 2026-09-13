---
title: "Bisection"
---

# Bisection

## Git Bisect

Git bisect helps you find the commit that introduced a bug using binary search.

### Basic Bisect Workflow

```bash
# Start bisect session
git bisect start

# Mark current commit as bad
git bisect bad

# Mark known good commit
git bisect good v1.0

# Git checks out middle commit
# Test the commit, then mark it:
git bisect good    # if test passes
git bisect bad     # if test fails

# Continue until Git finds the problematic commit
# Git will show: "X is the first bad commit"

# End bisect session
git bisect reset
```

### Automated Bisect

```bash
# Automated bisect with test script
git bisect start HEAD v1.0
git bisect run ./test-script.sh

# Test script should exit with:
# 0 for good commit
# 1-127 for bad commit (except 125)
# 125 to skip commit
```

### Example Test Script

```bash
#!/bin/bash
# test-script.sh

# Build the project
make clean && make

# Run tests
if ./run-tests.sh; then
    exit 0  # Good commit
else
    exit 1  # Bad commit
fi
```

### Bisect with Specific Path

```bash
# Bisect only commits that changed specific files
git bisect start -- src/main.c include/header.h
git bisect bad
git bisect good v1.0
```
