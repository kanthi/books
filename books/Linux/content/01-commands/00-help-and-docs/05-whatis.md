# whatis

## Overview

`whatis` prints **single-line descriptions** from the man-db whatis index. Use it when you want a one-sentence reminder of what a command or page is without opening the full manual. Same idea as `man -f`.

It answers “what is this name?” — not “what command does X?” (that’s `apropos` / `man -k`).

## Syntax

```bash
whatis [options] name...
man -f name...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-s list` | Only these sections (e.g. `1,8` or `5`) |
| `-l` | Long / multi-line output when available |
| `-r` | Interpret name as regex (implementation-dependent) |
| `-w` | Wildcard match on names |
| `-v` | Verbose diagnostics |
| `-d` | Debug (man-db) |

## Examples with Explanations

### Quick one-liners

```bash
whatis ls
whatis passwd
whatis passwd chmod mount
man -f ls                   # equivalent
```

### Disambiguate by section

```bash
whatis passwd
whatis -s 1 passwd          # the command
whatis -s 5 passwd          # /etc/passwd format
whatis -s 2,3 open          # syscall / libc
```

### Multiple names in scripts

```bash
for c in curl wget aria2c; do
  whatis "$c" 2>/dev/null || echo "$c: no man summary"
done
```

### Missing database

```bash
# typical message: whatis: nothing appropriate
sudo mandb
whatis ls
whatis systemctl
```

Minimal Docker images: install `man-db` and relevant man packages first.

### Combine with type / path

```bash
type mount
command -v mount
whatis mount
man 8 mount
```

`type` shows *how the shell runs it*; `whatis` shows *what the man index claims it is*.

### Wildcard / regex (when supported)

```bash
whatis -w 'system*'
whatis -r '^ip$'
```

### Verify pages after package install

```bash
sudo apt install --reinstall manpages manpages-dev   # Debian/Ubuntu example
sudo mandb
whatis open openat
```

## Understanding Output

Typical line shape:

```text
ls (1)               - list directory contents
passwd (1)           - change user password
passwd (5)           - the password file
```

Columns: **name**, **(section)**, **short description**. Multiple lines appear when the name exists in several sections.

Exit status is non-zero when no entry matches (handy in scripts).

## Notes / Pitfalls

- No output / “nothing appropriate” → run `sudo mandb`, install docs packages, or wrong name.
- Builtins like `cd` may have thin or missing whatis entries; use `help cd`.
- Descriptions can be outdated relative to a newer binary if packages diverged; open `man` when accuracy matters.
- `whatis` does not search descriptions for keywords — use `apropos`.
- Localized systems may show translated one-liners; use `LANG=C whatis …` for English.

## 2026-relevant notes

- Still the fastest “sanity check” that a tool is installed *with documentation* on the box.
- Pair with `command -v` in onboarding scripts: binary present + whatis present = usable offline reference.
- Some distros split man pages into `*-doc` packages (especially libraries); `whatis` missing does not always mean the binary is missing.

## Related Commands

- `apropos` / `man -k` — keyword search across descriptions
- `man` — full page
- `info` — Texinfo manuals
- `command -v` / `type` — how the shell resolves a name
- `mandb` — rebuild the whatis database

## Additional Resources

- `man whatis`, `man man`
