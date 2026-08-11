# less

## Overview

`less` is a **pager**: it displays text one screen at a time with searching, scrolling both ways, and optional follow mode. It is the default pager for `man` on most systems and a better interactive viewer than `more` for large logs and command output.

Unlike editors, `less` does not modify files (unless you explicitly open an editor from it).

## Syntax

```bash
less [options] [file ...]
command | less
```

## Common Options

| Option | Description |
|--------|-------------|
| `-N` | Show line numbers |
| `-i` / `-I` | Ignore case in searches (smart / full) |
| `-S` | Chop long lines (no wrap); horizontal scroll |
| `-R` | Raw ANSI colors (for colored logs/`rg`/`ls`) |
| `-F` | Quit if content fits on one screen |
| `-X` | Don’t clear screen on quit (behavior depends on term) |
| `-n` | Suppress line numbers (default) |
| `+F` | Start in follow mode (like `tail -f`) |
| `+G` | Start at end of file |
| `+/pattern` | Start at first match |
| `-M` / `-m` | Long / short prompt with position |
| `-J` | Status column for marks |
| `--incsearch` | Incremental search (newer less) |

## Essential keys

| Key | Action |
|-----|--------|
| `q` | Quit |
| `Space` / `b` | Page down / up |
| `d` / `u` | Half page down / up |
| `j` / `k` or arrows | Line down / up |
| `g` / `G` | Top / bottom |
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `&pattern` | Show only matching lines |
| `F` | Follow (tail -f style); `Ctrl-C` to stop |
| `ma` | Mark position `a` |
| `'a` | Go to mark `a` |
| `s` | Save input to a file (when from pipe, if supported) |
| `h` | Help |
| `v` | Open in `$VISUAL` / `$EDITOR` |

## Examples with Explanations

### Open files

```bash
less /var/log/syslog
less -N /etc/ssh/sshd_config
less +G /var/log/kern.log          # jump to end
less +/Listen /etc/ssh/sshd_config # jump to pattern
```

### Pipe command output

```bash
journalctl -u nginx -n 500 | less
dmesg --color=always | less -R
ls --color=always | less -R
ps auxf | less
```

### Follow a growing log

```bash
less +F /var/log/syslog
# or open normally, then press F
# Ctrl-C leaves follow mode but keeps less open
```

### Chop long lines (tables, wide logs)

```bash
less -S /var/log/app.log
# use arrow keys / horizontal scroll
```

### Case-insensitive search

```bash
less -i messages.log
# then /error matches Error ERROR error
```

### Multiple files

```bash
less *.conf
# :n next file, :p previous file
```

### Sensible defaults via environment

```bash
export LESS='-R -i -M'
export LESSHISTFILE=-          # disable ~/.lesshst if desired
export PAGER=less
export MANPAGER='less -R'
```

### Compare with more / bat

```bash
more file.txt           # limited backward motion
less file.txt           # full interactive pager
bat file.txt            # syntax highlight; still may use less as pager
```

## Notes / Pitfalls

- Without `-R`, ANSI color sequences show as junk.
- Binary files: less may warn; use `less -a` / `strings` / `xxd` instead of paging binaries casually.
- Very large files: less is efficient but searching huge unindexed logs still costs I/O.
- `LESSOPEN` preprocessor can auto-decompress `.gz` on some setups — know your distro defaults.
- When used as `PAGER`, interactive keys must work; avoid forcing `cat` as pager except in scripts.

## 2026-relevant notes

- `journalctl` integrates with pagers; `SYSTEMD_PAGER=less` / `PAGER=less` still apply.
- Colored tooling (`rg`, `fd`, `eza`, `ip -c`) should be paired with `less -R` or `unbuffer`-style hacks when piping.
- `bat` / `delta` improve reading UX but often shell out to `less` underneath.

## Related Commands

- `more` — simpler historical pager
- `most` — alternate pager (if installed)
- `bat` — cat clone with highlighting
- `tail -f` / `journalctl -f` — follow only
- `view` / `vim -R` — read-only editor as pager
- `man` — uses a pager by default

## Additional Resources

- `man less`, press `h` inside less
