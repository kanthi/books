---
title: "Why Git"
---

# Why Git

Version control records snapshots of files over time so you can compare, revert, and collaborate without `index_final_v2.html`. Git is the usual tool for that job: a **distributed** repository on every clone, not a checkout from a single server.

This chapter is the *why*. Evolution is the history. The mental model is the *how Git thinks*. Install and First repository are the *how you type*.

## Without it

```text
desk-tickets/
├── app.py
├── app_backup.py
├── app_final.py
├── app_final_v2.py
└── app_really_final_fixed.py
```

You lose which copy is current, who changed the login line, and any way to undo Tuesday without also undoing Wednesday. Two people editing `app.py` overwrite each other.

A VCS keeps one tree, a history of snapshots, and a way to merge parallel work.

## Local, centralized, distributed

| Generation | Idea | Examples |
|------------|------|----------|
| Local | Deltas on one disk | SCCS, RCS |
| Centralized | One server is the repository | CVS, Subversion, Perforce |
| Distributed | Every clone is a repository | Git, Mercurial |

Centralized: you need the network to commit; the server dying loses history you do not have locally. Distributed: `git commit` is local; `origin` is a remote you push to when you choose. That is why Git works on a train, and why rewriting commits you already pushed is a **people** problem.

The Evolution chapter walks SCCS → RCS → CVS → SVN → Git in detail. You do not need it before `git init`.

## Why Git specifically

- **Snapshots, not patch stacks as the primary model.** A commit points at a full tree. Unchanged files reuse blob hashes.
- **Branches are cheap.** A branch is a file containing a hash. Merging and rebasing are ordinary graph operations.
- **Integrity.** Object names are hashes of content. Bit flips and silent edits show up as missing or mismatched objects.
- **Offline.** Log, diff, commit, branch, merge all work without `origin`.
- **Everywhere.** The forges (GitHub, GitLab, Gitea) speak Git remotes. Jujutsu can sit on a Git object store. Learning Git is not loyalty to one website.

Git vs Subversion (the comparison that still comes up):

| | Git | SVN |
|--|-----|-----|
| Architecture | Distributed | Centralized |
| Offline commit | Yes | No |
| Branching | Name on a commit | Copy in the tree |
| Default unit | Snapshot | File deltas |
| Typical remote | Any number | One canonical server |

Mercurial is also distributed and simpler in places. Git won the ecosystem, not a purity contest.

## What Git is not

- Not a backup system by itself (a single laptop clone can die).
- Not a forge. Hosting, pull requests, and CI are products on top.
- Not a substitute for talking to the person who pushed the branch you are about to rebase.

## Try this

1. Pick a tool you use (editor, browser, this book’s repo). Find whether its source is in Git. You will almost always say yes.
2. Recreate the `app_final_v2.py` mess with three copies of a text file. Then imagine merging a one-line fix that exists only in copy two. That is the problem Git’s graph is for.
3. After you finish Mental model, come back and explain in one sentence why `origin` is not “the repository.”
