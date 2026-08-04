# info

## Overview

`info` reads documentation in **Info** (Texinfo) format. GNU projects often put their deepest manuals here — structured as a tree of **nodes** with menus and cross-references — while `man` pages stay as flatter reference sheets.

For coreutils, bash, and many GNU tools, `info` can be more complete than the man page. Navigation is keyboard-driven and different from `less`; invest a few minutes in the keys once.

## Syntax

```bash
info [options] [menu-item ...]
info [options] -f file [node]
info [options] --index-search=string
```

## Common Options

| Option | Description |
|--------|-------------|
| `-f file` | Open a specific Info file |
| `-n node` | Start at named node |
| `-a` | Use all matching manuals |
| `-k string` / `--apropos` | Search indices for string |
| `-w` | Show location of Info file |
| `--index-search=str` | Go to index entry |
| `--show-options` | Jump to command-line options node (when present) |
| `--subnodes` | Dump node and subnodes (non-interactive) |
| `-o file` | Write output to file |
| `--vi-keys` | Vi-like key bindings |

## Navigation Keys (standalone info)

| Key | Action |
|-----|--------|
| `?` | List commands |
| `h` | Tutorial |
| `q` | Quit |
| `n` / `p` | Next / previous node at this level |
| `u` | Up to parent node |
| `l` | Last node (history back) |
| `]` / `[` | Forward / back in document order |
| `m` | Menu item by name |
| `f` | Follow cross-reference |
| `s` / `/` | Search |
| `Space` / `Del` | Scroll |
| `d` | Directory node (top-level catalogue) |

Emacs users often prefer `M-x info` inside Emacs; keys differ slightly.

## Examples with Explanations

### Open a manual

```bash
info ls
info coreutils
info bash
info libc
```

Tab completion or the directory node (`info` with no args, then browse) helps discovery.

### Jump to options / a node

```bash
info --show-options ls
info -n 'Invoking ls' coreutils
info -f coreutils -n 'Directory listing'
```

### Search

```bash
info --apropos=printf
info -k symlink
info --index-search=regex
```

### Where is the file?

```bash
info -w coreutils
# e.g. /usr/share/info/coreutils.info.gz
```

### Non-interactive extract

```bash
info --subnodes -o /tmp/ls-info.txt ls
info -o - --show-options ls | head -50
```

Useful for grepping offline or pasting into notes.

### Prefer man for quick flags, info for depth

```bash
man ls                 # quick reference
info ls                # full GNU narrative + examples
info coreutils         # whole suite manual
```

## Understanding the Info tree

1. **Directory node** — catalogue of installed manuals (`d`).
2. **Top node** — start of one manual.
3. **Menus** — child nodes (chapters/sections).
4. **Cross-references** — `*note …` links between topics.
5. **Indices** — topic/command/option indices for search.

Think of it as a hypertext book, not a single scrollable man page.

## Notes / Pitfalls

- Missing docs: install packages like `info`, `bash-doc`, `coreutils` info files (`*-doc` on some distros).
- People open `info` once, hate the UI, and never return — spend five minutes on `h` / `?`.
- Not every tool has an Info manual; many only ship man pages.
- `pinfo` is a friendlier alternative viewer if you install it.
- Dumping with `--subnodes` can be huge (`libc`); narrow to a node first.

## 2026-relevant notes

- Man pages improved a lot for systemd/iproute2; Info still wins for **GNU coreutils, findutils, bash, gdb, gcc** deep dives.
- In CI/containers, Info files are often omitted; generate or fetch docs on a full workstation.
- Some projects moved primary docs to HTML/web; Info remains the classic offline GNU format.

## Related Commands

- `man` — traditional manual pages
- `pinfo` — alternative Info browser
- `apropos` / `whatis` — man-db search / one-liners
- `help` — shell builtins
- `info --help` — viewer options

## Additional Resources

- `info info` — the Info reader manual itself
- [GNU Texinfo / Info documentation](https://www.gnu.org/software/texinfo/manual/info/)
