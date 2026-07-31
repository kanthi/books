# apropos

## Overview
`apropos` searches man page **names and short descriptions** for keywords. Use it when you remember what you want to do but not the command name. Equivalent to `man -k`.

## Syntax
```bash
apropos [options] keyword...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Require every keyword to match |
| `-r` | Regular expression |
| `-w` | Shell-style wildcards |
| `-s list` | Limit to sections (e.g. `1,8`) |
| `-e` | Exact match |
| `-l` | Do not truncate descriptions |

## Examples with Explanations
```bash
apropos password
apropos -a network interface
apropos -s 8 mount
apropos -r 'zip$'
man -k 'disk usage'
```

### Narrowing noise
```bash
apropos copy | grep -E '^\w+\s+\(1\)' | head
```

### Empty results
```bash
sudo mandb
apropos printf
```

## Related Commands
- `whatis` — description for a known name  
- `man -K` — full-text search (slow, thorough)  
- `man`  
- `info --apropos`
