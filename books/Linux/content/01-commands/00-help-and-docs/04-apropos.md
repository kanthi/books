# apropos

## Overview

`apropos` searches man page **names and short descriptions** for keywords. Use it when you remember *what you want to do* but not the command name. It is equivalent to `man -k`.

It queries the **whatis database** built by `mandb`. If that DB is missing or stale, results will be empty or outdated — rebuild it rather than assuming the command does not exist.

## Syntax

```bash
apropos [options] keyword...
man -k [options] keyword...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Require **every** keyword to match (AND) |
| `-r` | Treat keywords as regular expressions |
| `-w` | Shell-style wildcards |
| `-s list` | Limit to sections (e.g. `1,8`) |
| `-e` | Exact match on page name/description token |
| `-l` | Do not truncate long descriptions |
| `-C file` | Alternate man config file |

Exact flags can vary slightly by man-db version; check `man apropos` on your host.

## Examples with Explanations

### Basic keyword search

```bash
apropos password
apropos socket
apropos 'disk usage'
man -k resize
```

Quotes help when the phrase contains spaces or shell metacharacters.

### AND multiple terms

```bash
apropos -a network interface
apropos -a list directory
```

Without `-a`, multiple words are often OR’d (implementation-dependent noise). Prefer `-a` to narrow results.

### Limit by section

```bash
apropos -s 8 mount          # admin tools about mount
apropos -s 1,8 kill         # user + admin kill-related pages
apropos -s 5 passwd         # file format, not the passwd(1) command
```

### Regex and wildcards

```bash
apropos -r 'zip$'           # names/descriptions ending in zip
apropos -r '^ip\b'
apropos -w 'sched*'
```

### Reduce noise to section-1 commands

```bash
apropos copy | grep -E '^\S+\s+\(1\)' | head -20
apropos -s 1 copy | head
```

### Rebuild empty database

```bash
sudo mandb
# older / alternate systems:
# sudo makewhatis
apropos printf
whatis ls
```

Containers and minimal images often need `man-db` installed **and** `mandb` run once.

### Pipeline into selection

```bash
cmd=$(apropos -s 1 disk | fzf | awk '{print $1}')
man "$cmd"
```

Handy on interactive workstations with `fzf`.

### Compare with full-text search

```bash
apropos AddressFamily       # only names + short desc
man -K AddressFamily        # body text; much slower
```

Use `-K` when you know a config keyword but not which man page owns it.

## Notes / Pitfalls

- “nothing appropriate” usually means **stale/missing mandb**, not that Linux lacks the tool.
- Descriptions are short; false positives are common (`time` matches many pages). Narrow with `-s` and `-a`.
- Localized whatis DBs may hide English-only phrasing; try `LANG=C apropos …`.
- `apropos` does **not** search shell builtins; use `help` / `compgen -b` for those.
- Package docs not installed → no man page → not in the index.

## 2026-relevant notes

- Prefer modern names in queries: `apropos systemd`, `apropos nft`, `apropos iproute` rather than only legacy `ifconfig`/`iptables` wording if you want current tooling.
- On immutable / ostree systems, man pages may live in different layers; ensure the layer with docs is available before blaming `apropos`.
- AI chat is fine for discovery, but `apropos` + `man` match **your installed version’s** flags.

## Related Commands

- `whatis` / `man -f` — one-line summary for a known name
- `man -K` — full-text search of page bodies
- `man` — open the full page
- `info --apropos` — search Texinfo manuals
- `mandb` — rebuild the index

## Additional Resources

- `man apropos`, `man man`, `man mandb`
