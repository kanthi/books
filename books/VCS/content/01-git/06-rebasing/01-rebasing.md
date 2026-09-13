---
title: "Rebasing and linear history"
---

# Rebasing and linear history

`git rebase` **copies** commits onto a new base. The originals remain until the reflog expires. A merge commit **joins** two lines; a rebase **replays** one line on top of the other.

This chapter is the rebase skill. Amend, squash-without-rebase, and cherry-pick stay in Commits and history. Do not rebase commits other people already based work on unless the team agreed.

## Why rebase

```text
before (feature branched from old main):

main:     A---B---C
                 \
feature:          D---E

after git rebase main (on feature):

main:     A---B---C
                    \
feature:             D'--E'
```

`D'` and `E'` are new commits (new hashes) with the same patches as `D` and `E`. `feature` now fast-forwards onto `main`.

Use it to:

- Update a feature branch without a merge commit (`git rebase main`).
- Edit, squash, or reorder **your unpublished** commits (`git rebase -i`).
- Keep `main` a straight line if that is the house style.

Do **not** use it to “make GitHub’s network graph pretty” after five people have pulled `feature`.

## Merge vs rebase

| | Merge | Rebase |
|--|-------|--------|
| Graph | Extra merge commit (or fast-forward) | Linear copies |
| Original commits | Unchanged | Replaced by new hashes |
| Conflicts | Once, at merge time | Potentially **once per copied commit** |
| Shared branches | Safe | Dangerous without coordination |
| Reflog | Merge commit is obvious | Copies; originals still in reflog |

Both are valid. Trunk-based teams often rebase feature branches onto `main` locally, then merge (or fast-forward) the result. Git Flow often merges. The workflow chapter picks a policy; this chapter is the mechanism.

```bash
# Update feature with merge (preserves D, E):
git switch feature
git merge main

# Update feature with rebase (rewrites D, E):
git switch feature
git rebase main
```

## Interactive rebase

```bash
git rebase -i HEAD~3
git rebase -i main
```

The todo list:

```text
pick abc1111 Add login form
pick def2222 Fix typo
pick ghi3333 Add validation
```

Commands: `pick`, `reword`, `edit`, `squash`, `fixup`, `drop`, `reword` the message only. Order of lines is order of replay.

```text
# squash the typo into login:
pick abc1111 Add login form
fixup def2222 Fix typo
pick ghi3333 Add validation
```

```bash
# Git stops on `edit`:
git add .
git commit --amend --no-edit
git rebase --continue
```

Abort anytime:

```bash
git rebase --abort
```

## Rebase conflicts are not merge conflicts

A merge conflict is “two tips vs one merge base.” A rebase conflict is “this **one** copied commit vs the new base (or the last successful copy).”

You may resolve the same file several times, once per copied commit. That is expected. `git status` tells you which commit is being applied.

Walkthrough:

```bash
git switch feature
git rebase main
# CONFLICT (content): Merge conflict in src/tickets.py
# error: could not apply def2222... Fix typo
```

```bash
git status
# shows: rebase in progress; both modified: src/tickets.py
```

Edit the file, remove conflict markers, then:

```bash
git add src/tickets.py
git rebase --continue
```

If this commit should not exist:

```bash
git rebase --skip
```

If you are lost:

```bash
git rebase --abort
# feature is back to D---E
```

Strategy flags (use sparingly):

```bash
git rebase -X ours main
git rebase -X theirs main
```

During a rebase, **ours** is the branch you are rebasing *onto* (usually `main`), **theirs** is the commit being copied. That is the opposite of many people’s merge intuition. Check `git status` before `-X`.

## After a rebase: push

If `feature` was never pushed, `git push -u origin feature` is enough.

If you already pushed the old `D---E`:

```bash
git push --force-with-lease origin feature
```

`--force-with-lease` refuses to overwrite if someone else pushed in the meantime. Plain `--force` does not. Never `--force-with-lease` to `main` unless the team is in a rewrite window (Commits and history covers shared-history rewrites).

## Recover

```bash
git reflog
# abc1111 HEAD@{3}: rebase (start): checkout main
git switch -c feature-backup HEAD@{3}
```

The originals are there until gc. Troubleshooting drills this.

## Try this

1. On a throwaway repo, make `main` and a `feature` with two commits. Commit on `main`. `git rebase main` on `feature`. `git log --oneline --graph --all`. Confirm new hashes.
2. `git rebase -i HEAD~3` and `fixup` a typo commit. Confirm one commit remains.
3. Create a real conflict (same line on `main` and `feature`). Rebase. Resolve. `--continue`. Then `git rebase --abort` on a second clone of the same conflict and compare the graphs.
4. Push `feature`, rebase, `git push` (it should reject), then `--force-with-lease`.
