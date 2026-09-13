---
title: "Installation and configuration"
---

# Installation and configuration

Get a current `git`, set identity, pick SSH or HTTPS, then leave the three-tree model to Mental model and the add/commit loop to First repository.

```bash
git --version
# You want 2.45+ for the examples in this part (switch, restore, SSH signing).
```

## Install

**Linux:** the distro package is fine (`git` on Arch/Fedora, `git` via `apt` on Debian/Ubuntu). Avoid ancient enterprise images still on 2.25.

**macOS:** `brew install git` or Xcode Command Line Tools (`xcode-select --install`). Apple’s `/usr/bin/git` lags; Homebrew’s wins on `$PATH`.

**Windows:** the installer from git-scm.com, or `winget install Git.Git`. Use the bundled Git Bash or a real terminal; line endings: `core.autocrlf` is `true` on Windows, `input` on Unix if a mixed team complains.

## Three config layers

| Layer | Flag | Typical file | Who |
|-------|------|--------------|-----|
| System | `--system` | `/etc/gitconfig` | every user on the machine |
| Global | `--global` | `~/.gitconfig` | you, every repo |
| Local | `--local` (default) | `.git/config` | this repo only |

Later keys **override** earlier ones. Work email in a company repo is a local `user.email`, not a second global.

```bash
git config --global user.name "Ada Desk"
git config --global user.email "ada@example.com"
git config --global init.defaultBranch main
git config --global core.editor "nvim"

git config --list --show-origin --show-scope
git config --show-origin user.email
```

`--show-origin` tells you which file won. `--unset` removes a key at the layer you name.

Repo-only:

```bash
cd desk-tickets
git config user.email "ada@work.example"
# writes .git/config, not ~/.gitconfig
```

### `includeIf` (home vs work)

```gitconfig
# ~/.gitconfig
[user]
    name = Ada Desk
    email = ada@example.com

[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

```gitconfig
# ~/.gitconfig-work
[user]
    email = ada@work.example
```

Any repo under `~/work/` picks up the work email without a per-repo command.

### Settings worth setting once

```bash
git config --global init.defaultBranch main
git config --global pull.ff only          # refuse surprise merge commits on pull
# or: git config --global pull.rebase true
git config --global rerere.enabled true   # reuse recorded conflict resolutions
git config --global diff.algorithm histogram
git config --global merge.conflictstyle zdiff3
```

`pull.ff only` means `git pull` fast-forwards or fails. You then merge or rebase on purpose. That is safer than the old default that created merge commits you did not ask for.

Do **not** set `core.fileMode false` unless you are on a filesystem that cannot store executable bits and you know why.

## Identity

`user.name` and `user.email` go **into every commit**. They are not a login. Forges match email to an account; a typo produces “unknown author” on GitHub, not a failed `git commit`.

```bash
git config --global user.useConfigOnly true
```

With that, Git refuses to commit if identity is missing instead of guessing `$USER@$HOST`.

Signing commits (SSH or GPG) is the Security chapter. Set identity here first.

## SSH vs HTTPS

| | SSH | HTTPS |
|--|-----|-------|
| URL | `git@github.com:org/repo.git` | `https://github.com/org/repo.git` |
| Auth | Key in `~/.ssh` | Credential helper / PAT |
| Typical | Daily push/fetch | Firewalled laptops, `git clone` in docs |

Generate a key (ed25519):

```bash
ssh-keygen -t ed25519 -C "ada@example.com" -f ~/.ssh/id_ed25519_desk
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519_desk
```

Put the **`.pub`** on the forge (GitHub: Settings → SSH keys). Test:

```bash
ssh -T git@github.com
```

Per-host key (work vs personal):

```text
# ~/.ssh/config
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_desk
  IdentitiesOnly yes
```

HTTPS: a **fine-grained PAT** or the forge’s credential helper, not your account password. Git’s built-in:

```bash
git config --global credential.helper cache          # memory, short-lived
# macOS: osxkeychain; Windows: manager; Linux: libsecret if you want a wallet
```

Switch an existing remote:

```bash
git remote -v
git remote set-url origin git@github.com:org/desk-tickets.git
```

Auth failures are almost always: wrong key, `IdentitiesOnly` missing, or HTTPS still expecting a password. `GIT_SSH_COMMAND="ssh -v"` prints which key was offered.

## Try this

1. `git config --list --show-origin --show-scope | less`. Find where `user.email` is set.
2. `git config --global user.useConfigOnly true`, `git init /tmp/no-ident && cd /tmp/no-ident`, try to commit without local identity. Confirm Git refuses.
3. Add an `includeIf` for a directory you actually use. `git config user.email` inside and outside that directory.
4. `ssh -T` to your forge. Clone the same repo over SSH and over HTTPS once, then `git remote set-url` to keep one.
