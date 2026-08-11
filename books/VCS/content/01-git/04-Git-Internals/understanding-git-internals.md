# Chapter 4: Understanding Git Internals

## Git's Data Model

Understanding how Git stores and manages data internally is crucial for mastering advanced Git operations. Git's design is elegant and simple once you understand the underlying concepts.

### Git as a Content-Addressable Filesystem

Git is fundamentally a content-addressable filesystem with a VCS user interface written on top. This means:
- Every piece of content is stored based on its hash
- The hash serves as both identifier and integrity check
- Content is immutable once stored

## Git Objects

Git stores all data as objects in the `.git/objects` directory. There are four types of objects:

### 1. Blob Objects

Blobs store file content without any metadata.

```bash
# Create a blob object manually
echo "Hello, World!" | git hash-object -w --stdin

# View blob content
git cat-file -p <blob-hash>

# Check object type
git cat-file -t <blob-hash>
```

Example:
```bash
$ echo "Hello, Git!" | git hash-object -w --stdin
8d0e41234f24b6da002d962a26c2495ea16a425f

$ git cat-file -p 8d0e41234f24b6da002d962a26c2495ea16a425f
Hello, Git!

$ git cat-file -t 8d0e41234f24b6da002d962a26c2495ea16a425f
blob
```

### 2. Tree Objects

Trees store directory structure and point to blobs and other trees.

```bash
# View tree object
git cat-file -p <tree-hash>

# Create tree object manually
git write-tree
```

Tree object format:
```
100644 blob a906cb2a4a904a152e80877d4088654daad0c859    README.md
100644 blob 8d1c8b69c050f2424c26d2073fac4b4f2c47c4f8    index.html
040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0    src
```

### 3. Commit Objects

Commits point to trees and contain metadata.

```bash
# View commit object
git cat-file -p <commit-hash>

# Show commit structure
git show --format=raw <commit-hash>
```

Commit object format:
```
tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
parent 1a410efbd13591db07496601ebc7a059dd55cfe9
author John Doe <john@example.com> 1234567890 +0000
committer John Doe <john@example.com> 1234567890 +0000

Initial commit message
```

### 4. Tag Objects

Tags create permanent references to specific commits.

```bash
# Create annotated tag
git tag -a v1.0 -m "Version 1.0"

# View tag object
git cat-file -p v1.0
```

## SHA-1 Hashing

Git uses SHA-1 hashing to identify objects:

### How Hashes are Generated

```bash
# For blobs: hash of "blob <size>\0<content>"
echo -n "Hello, Git!" | git hash-object --stdin

# Manual calculation
echo -n "blob 11\0Hello, Git!" | sha1sum
```

### Hash Properties
- **Deterministic**: Same content always produces same hash
- **Unique**: Extremely unlikely for different content to have same hash
- **Integrity**: Any change in content changes the hash

## References and HEAD

### Understanding References

References (refs) are pointers to commits stored in `.git/refs/`:

```bash
# View all references
git show-ref

# View specific reference
cat .git/refs/heads/main

# View HEAD
cat .git/HEAD
```

### Types of References

#### Branch References
```bash
# Branch refs are in .git/refs/heads/
ls .git/refs/heads/

# Each file contains a commit hash
cat .git/refs/heads/main
```

#### Tag References
```bash
# Tag refs are in .git/refs/tags/
ls .git/refs/tags/

# Lightweight tags point directly to commits
# Annotated tags point to tag objects
```

#### Remote References
```bash
# Remote refs are in .git/refs/remotes/
ls .git/refs/remotes/origin/
```

### HEAD Reference

HEAD is a symbolic reference pointing to the current branch:

```bash
# View HEAD
cat .git/HEAD
# Output: ref: refs/heads/main

# In detached HEAD state
git checkout <commit-hash>
cat .git/HEAD
# Output: <commit-hash>
```

## The Git Directory Structure

### Complete .git Directory Layout

```
.git/
├── HEAD                    # Current branch reference
├── config                  # Repository configuration
├── description            # Repository description
├── index                  # Staging area (binary file)
├── hooks/                 # Hook scripts
│   ├── pre-commit
│   ├── post-commit
│   └── ...
├── info/                  # Additional repository info
│   └── exclude            # Local ignore patterns
├── objects/               # Object database
│   ├── 01/
│   ├── 02/
│   ├── ...
│   ├── info/
│   └── pack/              # Packed objects
├── refs/                  # References
│   ├── heads/             # Branch references
│   ├── tags/              # Tag references
│   └── remotes/           # Remote references
└── logs/                  # Reference logs (reflog)
    ├── HEAD
    └── refs/
```

### The Index (Staging Area)

The index is a binary file that stores staging area information:

```bash
# View index contents
git ls-files --stage

# View index in detail
git ls-files --debug
```

Index entry format:
```
100644 a906cb2a4a904a152e80877d4088654daad0c859 0    README.md
100644 8d1c8b69c050f2424c26d2073fac4b4f2c47c4f8 0    index.html
```

## How Git Stores Data

### Object Storage

Objects are stored in `.git/objects/` using the first two characters of the hash as directory name:

```bash
# Hash: a906cb2a4a904a152e80877d4088654daad0c859
# Stored as: .git/objects/a9/06cb2a4a904a152e80877d4088654daad0c859

# View object directly (compressed)
cat .git/objects/a9/06cb2a4a904a152e80877d4088654daad0c859

# Decompress and view
git cat-file -p a906cb2a4a904a152e80877d4088654daad0c859
```

### Pack Files

Git optimizes storage using pack files:

```bash
# Trigger garbage collection and packing
git gc

# View pack files
ls .git/objects/pack/

# View pack contents
git verify-pack -v .git/objects/pack/pack-*.idx
```

## Plumbing vs Porcelain Commands

Git commands are divided into two categories:

### Porcelain Commands (User-Friendly)
- `git add`, `git commit`, `git push`
- High-level commands for daily use
- Hide internal complexity

### Plumbing Commands (Low-Level)
- `git hash-object`, `git cat-file`, `git write-tree`
- Direct access to Git internals
- Used for scripting and understanding

### Useful Plumbing Commands

```bash
# Object manipulation
git hash-object -w <file>      # Create blob object
git cat-file -p <hash>         # View object content
git cat-file -t <hash>         # View object type
git cat-file -s <hash>         # View object size

# Tree manipulation
git write-tree                 # Create tree from index
git read-tree <tree-hash>      # Read tree into index

# Reference manipulation
git update-ref refs/heads/branch <commit-hash>
git symbolic-ref HEAD refs/heads/branch

# Index manipulation
git update-index --add <file>
git ls-files --stage
```

## Practical Examples

### Example 1: Creating Objects Manually

```bash
# Create a blob
echo "Hello, Git internals!" | git hash-object -w --stdin
# Output: 7c4a013e52c76442ab80ee5572399a5a4c3f4e5f

# Create a tree
git update-index --add --cacheinfo 100644 7c4a013e52c76442ab80ee5572399a5a4c3f4e5f hello.txt
git write-tree
# Output: 68aba62e560c0ebc3396e8ae9335232cd93a3f60

# Create a commit
echo "First commit" | git commit-tree 68aba62e560c0ebc3396e8ae9335232cd93a3f60
# Output: 166ae0c4d3f420721acbb115cc33848dfcc2121a
```

### Example 2: Exploring Object Relationships

```bash
# Start with a commit
git cat-file -p HEAD

# Follow the tree
git cat-file -p <tree-hash>

# View a blob
git cat-file -p <blob-hash>

# Trace the parent chain
git cat-file -p HEAD^
git cat-file -p HEAD^^
```

### Example 3: Understanding Branches

```bash
# Create branch manually
git update-ref refs/heads/new-branch HEAD

# Verify branch creation
git branch

# Switch to branch
git symbolic-ref HEAD refs/heads/new-branch
```

## Git's Efficiency

### Delta Compression

Git uses delta compression for efficiency:
- Similar objects are stored as deltas
- Pack files contain base objects and deltas
- Reduces storage space significantly

### Deduplication

Git automatically deduplicates content:
- Identical files share the same blob object
- Moving/copying files doesn't duplicate content
- Only metadata changes

## Debugging with Internals Knowledge

### Finding Corrupted Objects

```bash
# Check repository integrity
git fsck

# Find dangling objects
git fsck --unreachable

# Recover lost commits
git reflog
git fsck --lost-found
```

### Understanding Performance Issues

```bash
# Check repository size
du -sh .git

# Analyze pack files
git count-objects -v

# Find large objects
git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | grep '^blob' | sort -k3nr | head -10
```

## Exercises

### Exercise 1: Object Exploration
1. Create a simple file and add it to Git
2. Find the blob hash and examine the object
3. Make a commit and explore the commit object
4. Trace the relationships between commit, tree, and blob

### Exercise 2: Manual Object Creation
1. Use plumbing commands to create a blob object
2. Create a tree object containing the blob
3. Create a commit object pointing to the tree
4. Update a branch reference to point to your commit

### Exercise 3: Repository Analysis
1. Analyze your repository's object database
2. Find the largest objects
3. Understand the pack file structure
4. Use `git fsck` to verify integrity

## Advanced Topics

### Object Packing

```bash
# Force packing
git repack -ad

# Analyze pack efficiency
git gc --aggressive

# Unpack objects for inspection
git unpack-objects < .git/objects/pack/pack-*.pack
```

### Custom Hash Functions

Git is transitioning from SHA-1 to SHA-256:

```bash
# Create repository with SHA-256
git init --object-format=sha256

# Check hash function
git config core.repositoryformatversion
```

## Summary

Understanding Git internals provides:
- **Deeper comprehension** of Git operations
- **Better debugging** capabilities
- **Confidence** in advanced operations
- **Optimization** knowledge for large repositories

Key concepts covered:
- Git's object model (blob, tree, commit, tag)
- SHA-1 hashing and content addressing
- References and HEAD
- The .git directory structure
- Plumbing vs porcelain commands
- Storage optimization techniques

This internal knowledge forms the foundation for understanding advanced Git features like rebasing, cherry-picking, and complex merge scenarios covered in later chapters. When Git behaves unexpectedly, understanding these internals helps you diagnose and fix issues effectively.