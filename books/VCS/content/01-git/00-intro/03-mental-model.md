---
title: "The Git mental model"
---

# The Git mental model

Git is a content-addressed database of snapshots plus movable names (refs). Commands add objects and move those names. If you hold the graph, `reset`, `rebase`, and `reflog` stop feeling like magic.

Install and First repository assume this chapter.

## Snapshots, not a patch pile

A commit names a **tree** (the whole project at that instant), plus parent commit(s), plus metadata. Git does store deltas inside packfiles for disk; that is compression, not the data model. Unchanged files keep the same **blob** hash across commits, which is why a one-line edit is cheap.

Filenames live in **trees**, not in blobs. Rename a file: new tree, same blob.

## Three trees

Everyday Git is three snapshots of the same project:

| Tree | On disk | Role |
|------|---------|------|
| Working directory | your files | What you edit |
| Index (staging area) | `.git/index` | What the *next* commit will contain |
| HEAD commit | object in `.git/objects` | Last committed snapshot on this branch |

```text
working directory  --git add-->  index  --git commit-->  HEAD
                 <--git restore--      <--git reset--
```

- `git add` copies working-tree bytes into the index (and writes blobs).
- `git commit` writes a tree from the index, then a commit pointing at that tree and at current HEAD.
- `git restore <file>` copies from the index (or a commit) onto the working tree.
- `git reset` moves HEAD and optionally the index and working tree (see below).

There is no fourth “GitHub tree.” A remote is another repository’s refs plus objects you have fetched.

`git commit -a` skips `git add` only for **already tracked** files. New files still need `git add`.

## The DAG

Commits form a **directed acyclic graph**. Each commit points at parent(s). A branch is a movable name for one commit. Merge: a commit with two parents. Rebase: copies of commits with a new parent (new hashes, similar diffs).

```text
A <-- B <-- C          main
            ^
            D <-- E    feature
```

`HEAD` usually points at a **branch name**, not at a raw commit:

```text
HEAD -> refs/heads/main -> C
```

**Detached HEAD** means `HEAD` holds a commit hash directly (you checked out a tag or a raw SHA). New commits are easy to lose when you switch away — create a branch before you leave, or find them in the reflog.

```bash
git cat-file -p HEAD
git rev-parse HEAD main
git log --oneline --graph --all
git status                 # says "detached at …" when it is
```

## Four object types

| Type | Payload |
|------|---------|
| **blob** | file bytes (no filename) |
| **tree** | name → object (blob or nested tree) |
| **commit** | tree + parents + author + message |
| **tag** | annotated pointer + message + optional signature |

Object names are hashes of content (SHA-1 historically; SHA-256 repos exist). Change one byte of a file → new blob, new tree, new commit.

## Refs

| Ref | Meaning |
|-----|---------|
| `refs/heads/main` | branch `main` |
| `refs/tags/v1.0` | tag |
| `HEAD` | usually `ref: refs/heads/main` |
| `refs/remotes/origin/main` | last fetched `main` from `origin` |
| `refs/stash` | stash stack |

```bash
git show-ref
cat .git/HEAD
cat .git/refs/heads/main     # or .git/packed-refs
```

Deleting a branch deletes the **name**, not the commits. Commits remain until nothing (including reflog) reaches them and `git gc` collects them.

## `reset`: three scopes

Same command, three depths. All move **HEAD** (the branch tip, if attached).

| Mode | HEAD | Index | Working tree |
|------|------|-------|--------------|
| `--soft` | moves | kept | kept |
| `--mixed` (default) | moves | matches HEAD | kept |
| `--hard` | moves | matches HEAD | matches HEAD |

```bash
git reset --soft HEAD~1    # undo commit, keep staging
git reset HEAD~1           # undo commit, unstage, keep files
git reset --hard HEAD~1    # throw away the commit and the work
```

`--hard` is how you destroy uncommitted work. Reflog still has the old HEAD for a while; the working tree does not.

## What this part will not do

- Teach the GitHub pull-request UI (GitHub part).
- Treat `origin/main` as “the” history. It is a remote-tracking ref.
- Replace Internals. This chapter is the map; Internals is `cat-file` and packfiles.

## Try this

1. `git init`, add `hello.txt`, commit. `find .git/objects -type f` then `git cat-file -t` / `-p` on each hash. You should see blob, tree, commit.
2. Edit the file, `git add`, do not commit. `git diff` vs `git diff --cached`. Working tree vs index.
3. Commit, then `git reset --soft HEAD~1`. `git status` still shows staged changes. `git reset --hard` (only in this toy repo) and they are gone.
4. `git switch --detach HEAD` (or `git checkout --detach`). Make a commit. `git switch main`. Find the orphan with `git reflog`.
5. Two branches, `git log --oneline --graph --all`. Draw the DAG and label `HEAD`.
