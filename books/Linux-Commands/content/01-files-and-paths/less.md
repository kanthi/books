# less

## Overview
`less` is an interactive pager for viewing files and stdin. Default pager for `man`. Forward and backward scroll, search, and follow mode.

## Syntax
```bash
less [options] [file...]
command | less
```

## Common Options
| Option | Description |
|--------|-------------|
| `-N` | Line numbers |
| `-S` | Chop long lines |
| `-i` / `-I` | Ignore case search |
| `-R` | Raw colors |
| `-F` | Quit if one screen |
| `-X` | No screen clear on exit |
| `+F` | Start in follow mode |
| `+/pattern` | Start at first match |

## Keys
| Key | Action |
|-----|--------|
| `q` | Quit |
| `/pat` `n` `N` | Search next/prev |
| `g` / `G` | Start / end |
| Space / `b` | Page down/up |
| `F` | Follow (Ctrl-C to stop) |
| `h` | Help |
| `&pat` | Filter lines |

## Examples with Explanations
```bash
less /var/log/syslog
less -N +/error app.log
less +F app.log
journalctl -u nginx --no-pager | less
man ls          # uses less usually
```

## Related Commands
- `more` — older pager  
- `bat` — clone with syntax highlight (if installed)  
- `tail -F` — follow only  
- `view` — vim read-only
