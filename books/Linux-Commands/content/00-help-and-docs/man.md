# man

## Overview
`man` displays the system manual. Sections cover commands, syscalls, libraries, file formats, and admin topics. Still the authoritative offline reference.

## Syntax
```bash
man [section] name
man [options] name
```

## Sections (common)
| Sec | Content | Example |
|-----|---------|---------|
| 1 | User commands | `man 1 printf` |
| 2 | System calls | `man 2 open` |
| 3 | Library functions | `man 3 printf` |
| 4 | Devices | `man 4 null` |
| 5 | File formats | `man 5 passwd` |
| 7 | Overviews/conventions | `man 7 signal` |
| 8 | Admin commands | `man 8 mount` |

## Common Options
| Option | Description |
|--------|-------------|
| `-k` / `--apropos` | Search short descriptions |
| `-f` / `--whatis` | One-line summary |
| `-a` | All matching sections |
| `-w` | Path to man file |
| `-K` | Full-text search (slow) |
| `MANPAGER` | Override pager |

## Examples with Explanations
### Basics
```bash
man ls
man 5 sshd_config
man man
```

### Disambiguate
```bash
man -a printf          # cycle sections
man 3 printf           # C library
whatis printf
```

### Search
```bash
man -k resize
apropos network interface
```

### Where is the page?
```bash
man -w ls
```

### Readable width / browser
```bash
MANWIDTH=80 man ls
man -Hxdg-open ls      # HTML if supported
```

## Pager keys (less)
`/pattern`, `n`, `g`/`G`, `q`, `h` help.

## Related Commands
- `info` — Texinfo manuals  
- `tldr` / `cheat` — community examples (if installed)  
- `help` — shell builtins  
- `apropos` / `whatis`
