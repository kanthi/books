# help (shell builtin)

## Overview
`help` shows documentation for **shell builtins** (commands implemented inside the shell, not as `/usr/bin/...` programs). External tools use `--help` or `man` instead.

## Syntax
```bash
help [-dms] [pattern...]
```

Bash options:
| Option | Description |
|--------|-------------|
| `-d` | Short description |
| `-m` | Manpage-like format |
| `-s` | Short usage synopsis |

## Examples with Explanations
```bash
help cd
help [[
help declare
help -m printf
help | less
```

### Builtin vs external
```bash
type cd          # builtin
type ls          # usually hashed external
type -a echo     # may show both
help cd          # works
ls --help        # external flag
man ls           # full manual
```

### List builtins (bash)
```bash
compgen -b | column
enable -a
```

## Notes
- Non-interactive scripts still *run* builtins; `help` is for humans.  
- `zsh` uses `run-help`; `fish` has `help` integrating web docs.  
- Prefer `man bash` for deep shell language reference.

## Related Commands
- `man bash` / `info bash`  
- `type` / `command -V`  
- `whatis` / `man` for external commands
