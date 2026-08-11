# man

## Overview

`man` displays the system manual. Pages are organized into **sections** covering user commands, system calls, libraries, file formats, and admin tools. It remains the authoritative offline reference on Linux — faster and more version-accurate than random web snippets for the packages you actually have installed.

Most pages are viewed through a pager (usually `less`). Press `q` to quit, `/` to search.

## Syntax

```bash
man [section] name
man [options] name
man -k keyword          # same as apropos
man -f name             # same as whatis
```

## Sections (common)

| Sec | Content | Example |
|-----|---------|---------|
| 1 | User commands | `man 1 printf` |
| 2 | System calls | `man 2 open` |
| 3 | Library functions | `man 3 printf` |
| 4 | Special files / devices | `man 4 null` |
| 5 | File formats / configs | `man 5 passwd` |
| 6 | Games | — |
| 7 | Overviews / conventions | `man 7 signal` |
| 8 | Admin commands | `man 8 mount` |
| 9 | Kernel routines (some systems) | — |

When the same name exists in multiple sections (e.g. `printf` in 1 and 3, `passwd` in 1 and 5), specify the section number.

## Common Options

| Option | Description |
|--------|-------------|
| `-k` / `--apropos` | Search short descriptions |
| `-f` / `--whatis` | One-line summary for a known name |
| `-a` | Show all matching sections in turn |
| `-w` / `--path` | Print path to the man file, don’t open it |
| `-W` | List all matching paths |
| `-K` | Full-text search of page bodies (slow) |
| `-P pager` | Override pager (`less`, `cat`, …) |
| `-L locale` | Force locale for translated pages |
| `MANPAGER` / `PAGER` | Environment override for pager |
| `MANWIDTH` | Force formatting width (useful in scripts) |

## Examples with Explanations

### Open a page

```bash
man ls
man 5 sshd_config
man 8 systemctl
man man
```

`sshd_config` lives in section 5 (file formats), not as a user command.

### Disambiguate sections

```bash
man -a printf          # cycle through every section that has printf
man 3 printf           # C library specifically
whatis printf          # see which sections exist
man -w -a passwd       # paths for all passwd pages
```

### Search when you forget the name

```bash
man -k resize
man -k 'disk usage'
apropos network interface
man -K 'AddressFamily'   # full-text; can take a while
```

### Locate the source file

```bash
man -w ls
# e.g. /usr/share/man/man1/ls.1.gz
zcat "$(man -w ls)" | head
```

Useful when debugging missing or outdated pages after package installs.

### Readable width and plain text dump

```bash
MANWIDTH=80 man ls
man ls | col -b > /tmp/ls.txt    # strip backspaces/overstrike
man -P cat ls | head -40
```

### HTML / browser (if supported)

```bash
man -H ls                 # uses browser from $BROWSER or similar
man -Tutf8 ls | less -R
```

### Scripting existence checks

```bash
if man -w journalctl >/dev/null 2>&1; then
  echo "journalctl man page present"
fi
```

## Pager keys (less)

| Key | Action |
|-----|--------|
| `q` | Quit |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `g` / `G` | Top / bottom |
| `Space` / `b` | Page down / up |
| `h` | Help |

## Notes / Pitfalls

- Empty or stale results after installing packages: rebuild the index with `sudo mandb` (or `sudo makewhatis` on some BSDs / older systems).
- Container images often ship **without** man pages to save space. Install `man-db` and the relevant `*-doc` / man packages, or read docs on the host.
- Section order and default “first match” can surprise you — prefer explicit `man 5 name` for configs.
- Locale: if a translated page is incomplete, force English with `LANG=C man …` or `man -L C …`.
- `man` is not for shell builtins (`cd`, `[[`, `declare`) — use `help` (bash) instead.

## 2026-relevant notes

- Systemd, iproute2, and Podman pages are high quality; prefer `man systemctl`, `man ip-link`, `man podman-run` over outdated blog posts for flag accuracy.
- Many modern tools also ship `--help` that is good enough for flags; use `man` when you need semantics, exit codes, and file formats.
- Container and snap sandboxes may not see host man pages; read docs in the environment where the tool is installed.

## Related Commands

- `info` — Texinfo hypertext manuals (GNU tools)
- `help` — shell builtins
- `apropos` / `whatis` — search and one-liners
- `tldr` / `cheat` — community example sheets (if installed)
- `mandb` — rebuild the whatis database

## Additional Resources

- `man man`, `man man-pages`, `man 7 man-pages`
- [Linux man-pages project](https://www.kernel.org/doc/man-pages/)
