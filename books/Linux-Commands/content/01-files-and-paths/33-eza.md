# eza

## Overview

`eza` is a modern replacement for `ls` (community successor to `exa`) with colors, git status, icons (optional), tree view, and friendlier defaults. Install separately (`apt install eza`, `cargo install eza`, etc.). Keep knowing classic `ls` for minimal systems and scripts.

## Syntax

```bash
eza [options] [path...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l`, `--long` | Long format |
| `-a`, `--all` | Show hidden (not `.` / `..`) |
| `-A` | Show hidden including `.` / `..` variants per version |
| `-h`, `--header` | Header row in long mode |
| `-g`, `--group` | Show group |
| `-b`, `--binary` | Binary (power-of-two) sizes |
| `-B`, `--bytes` | Exact bytes |
| `--git` | Git status column |
| `--git-ignore` | Ignore gitignored entries |
| `-T`, `--tree` | Tree view |
| `-L`, `--level` | Tree depth |
| `-s`, `--sort` | Sort field (`name`, `size`, `modified`, …) |
| `-r`, `--reverse` | Reverse sort |
| `-t`, `--time` / `--time-style` | Time field / format |
| `-i`, `--inode` | Inodes |
| `-u` / `-U` | User / don’t show user |
| `--icons` | Icon glyphs (needs font) |
| `-1` | One per line |
| `-d` | List directories as dirs, not contents |
| `-R` | Recurse without tree graphics |

Flags evolve quickly — `eza --help` is authoritative for your version.

## Examples with Explanations

### Everyday aliases

```bash
eza
eza -la
eza -lah --git
eza -lah --group --header
```

Suggested aliases:

```bash
alias ls='eza'
alias ll='eza -lah --git'
alias lt='eza -T -L 2'
```

### Sorting

```bash
eza -l --sort=modified
eza -l --sort=size -r
eza -l --sort=ext
```

### Tree view

```bash
eza -T -L 2
eza -T -L 3 --git-ignore
eza -T -L 2 -a
```

### Git-aware listing

```bash
eza -l --git
eza -l --git --git-ignore
```

Shows modified/untracked markers when inside a repository.

### Headers and metadata

```bash
eza -lbh --header --group
eza -l --inode --links
```

### Compare with ls / tree

```bash
ls -lah
eza -lah --git
tree -L 2
eza -T -L 2
```

### Scripts: prefer classic ls

```bash
# portable scripts
ls -1
# interactive human shell
eza -lah --git
```

## Notes / Pitfalls

- Not installed everywhere; don’t hard-depend in production automation.
- Icons need a Nerd Font / patched font or they look like tofu boxes.
- Color/git features add cost on huge directories and network FS — fall back to `ls -U`/`find` when needed.
- Option names differ from `ls`; muscle memory transfer is incomplete.
- Output is still human-oriented; don’t parse it in scripts.

## 2026-relevant notes

- `eza` is the maintained path for many who used `exa`.
- Fits a modern toolkit with `bat`, `fd`, `rg`, `delta`, `zoxide`.
- Remote SSH to Alpine/BusyBox hosts: expect plain `ls` only.

## Related Commands

- `ls` — portable listing
- `tree` — classic tree
- `lsd` — another modern ls
- `fd` / `find` — selection
- `stat` — precise metadata
- `git status` — full git detail

## Additional Resources

- `eza --help`, `man eza` (if packaged)
- [eza-community/eza](https://github.com/eza-community/eza)
