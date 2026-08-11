---
title: "Git Cheatsheet"
---

# Git Cheatsheet

Quick reference for everyday Git. Prefer full chapters for *why* and recovery detail.

## Setup

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false   # or true if you prefer rebase pulls
git config --global core.editor "nvim"  # or code --wait, vim, …
```

## Create and clone

| Command | Purpose |
|---------|---------|
| `git init` | New repo in current directory |
| `git clone <url>` | Copy remote repo |
| `git clone --depth 1 <url>` | Shallow clone |
| `git remote -v` | List remotes |
| `git remote add origin <url>` | Add origin |

## Daily loop

```bash
git status
git diff                 # unstaged
git diff --staged        # staged
git add <file>           # or git add -p
git commit -m "msg"
git push
git pull                 # fetch + merge (or rebase per config)
```

## Branching

| Command | Purpose |
|---------|---------|
| `git branch` | List local branches |
| `git branch <name>` | Create branch |
| `git switch <name>` | Switch branch (modern) |
| `git switch -c <name>` | Create and switch |
| `git branch -d <name>` | Delete merged branch |
| `git branch -D <name>` | Force-delete |
| `git merge <branch>` | Merge into current |
| `git rebase <branch>` | Replay commits on tip |
| `git log --oneline --graph --all` | History graph |

## History and inspection

```bash
git log -n 20
git log -p                 # with patches
git show <commit>
git blame <file>
git grep "TODO"
git stash push -m "wip"
git stash list
git stash pop
```

## Undo (safe → sharp)

| Goal | Prefer |
|------|--------|
| Unstage file | `git restore --staged <file>` |
| Discard unstaged | `git restore <file>` |
| Amend last commit (not pushed) | `git commit --amend` |
| New commit that undoes | `git revert <commit>` |
| Move branch tip (careful) | `git reset --soft/--mixed/--hard` |

Never rewrite history that others have already based work on without a team plan.

## Remotes and PR flow

```bash
git fetch origin
git pull origin main
git push -u origin HEAD
git push origin --delete <branch>
```

## Tags and releases

```bash
git tag v1.0.0
git tag -a v1.0.0 -m "release"
git push origin v1.0.0
git push origin --tags
```

## Worktrees and cleanup

```bash
git worktree add ../feature-x feature-x
git worktree list
git worktree remove ../feature-x
git clean -nd                # dry-run untracked
git gc --prune=now
```

## Conflict markers (merge/rebase)

```text
<<<<<<< HEAD
your side
=======
their side
>>>>>>> branch
```

Edit, `git add`, then `git merge --continue` or `git rebase --continue`.

## See also

- Full fundamentals and remotes chapters later in this part  
- Troubleshooting / recovery for detached HEAD, lost commits, and reflog  
