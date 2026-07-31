# alias / unalias

## Overview
`alias` (shell builtin) creates shortcuts for commands in the current shell. Not inherited by scripts unless sourced. Persist in `~/.bashrc`, `~/.zshrc`, or `~/.bash_aliases`.

## Syntax
```bash
alias
alias name='command args'
unalias name
unalias -a
```

## Examples with Explanations
```bash
alias ll='ls -lah'
alias gs='git status'
alias ..='cd ..'
alias grep='grep --color=auto'
alias
type ll
unalias ll
```

### Useful patterns
```bash
alias please='sudo $(fc -ln -1)'     # humor; review before use
alias rm='rm -i'                     # safety; scripts bypass aliases
```

### Bypass alias
```bash
command ls
\ls
/bin/ls
```

## Notes & Pitfalls
- Aliases are **not** active in non-interactive scripts by default.  
- Functions are better for arguments (`mkcd() { mkdir -p "$1" && cd "$1"; }`).  
- `alias sudo='sudo '` allows alias expansion of the next word (bash).  

## Related Commands
- shell functions  
- `type` / `command -v`  
- `ln -s` — filesystem shortcuts
