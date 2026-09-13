---
title: "Security and best practices"
---

# Security and best practices

Git stores whatever you commit, forever, in every clone that fetched it. Security here is **signed history**, **secrets that escaped into objects**, and **hooks that stop the next leak**. Host scanning (secret scanning, Dependabot) is the GitHub part.

## Signed commits

Annotated tags and commits can carry a signature (GPG or SSH). Verification is `git log --show-signature` and, on a forge, a “Verified” badge.

SSH signing (Git 2.34+), often simpler than GPG:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
git commit -S -m "DESK-12: close ticket"
git log --show-signature -1
```

GPG:

```bash
git config --global user.signingkey <KEYID>
git config --global commit.gpgsign true
git commit -S -m "DESK-12: close ticket"
```

Letters in `--show-signature`: `G` good, `B` bad, `U` unknown validity, `E` cannot check. Unknown validity usually means you have not imported the key.

Signing proves **which key** made the commit, not that the diff is correct. Still review the patch.

## Secrets in history

If a token hit a commit, rotating the token is step one. Rewriting history is step two, and every clone still has the old object until they fetch the rewrite and gc.

Do not `git rm` the file and commit — the blob remains in parent commits.

Current tool: **`git filter-repo`** (not `git filter-branch`).

```bash
pipx install git-filter-repo   # or your package manager

# Remove a file from all history (rewrites every commit that touched it):
git filter-repo --invert-paths --path secrets.env

# Replace a string (still rotate the credential):
git filter-repo --replace-text <(echo 'ghp_liveTOKEN==>REDACTED')
```

BFG Repo-Cleaner is the older fast path for bulky binaries; `filter-repo` is the maintained general tool.

After a rewrite:

```bash
git push --force-with-lease --all
git push --force-with-lease --tags
```

Tell every clone to re-clone or to reset hard to the new refs. Treat the old hashes as public.

Prevention:

```bash
# .gitignore
.env
*.pem
credentials.json
```

A `pre-commit` hook that greps staged diffs for `ghp_`, `AKIA`, `BEGIN PRIVATE KEY` (hooks chapter). Forge secret scanning is extra, not a substitute.

## Audit

```bash
git log --all --full-history -- path/to/file
git log --format='%H %an %ae %ad %s' --date=iso
git shortlog -sn
```

Author email is whatever `user.email` was. Signing is how you distinguish “this laptop’s key” from a spoofed `user.name`.

## Try this

1. Enable SSH commit signing. Make a commit. `git log --show-signature`. Confirm `G` or a forge Verified badge.
2. Commit a dummy `secrets.env` with `password=demo`. `git filter-repo --invert-paths --path secrets.env` on a **copy** of the repo. `git log --all -- secrets.env` should be empty. Keep the original copy until you are sure.
3. Add a pre-commit hook that rejects staged files named `.env`. Prove it blocks a commit, then `git commit --no-verify` once so you know the escape hatch exists — and that forges still see the file if you use it.
