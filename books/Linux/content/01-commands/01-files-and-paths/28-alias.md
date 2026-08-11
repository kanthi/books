# alias / unalias

## Overview

`alias` is a **shell builtin** that creates command shortcuts in the current shell session. Aliases are primarily for interactive convenience. They are **not** automatically available in non-interactive scripts (unless you explicitly enable/source them). For anything with arguments or logic, prefer a **shell function**.

Persist aliases in `~/.bashrc`, `~/.zshrc`, or a dedicated `~/.bash_aliases` sourced from your rc file.

## Syntax

```bash
alias
alias name='command string'
alias name=$'command with specials'
unalias name
unalias -a
```

## Common Options / related

| Form | Description |
|------|-------------|
| `alias` | List defined aliases |
| `alias name=value` | Define alias |
| `unalias name` | Remove one |
| `unalias -a` | Remove all |
| `type name` | Show how name resolves |
| `command name` | Bypass alias/function for external |
| `\name` | Bypass alias |

## Examples with Explanations

### Everyday shortcuts

```bash
alias ll='ls -lah'
alias la='ls -A'
alias gs='git status'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias ip='ip -c'
alias please='sudo'
```

### List and inspect

```bash
alias
alias ll
type ll
type -a ls
```

### Persist (bash)

```bash
# ~/.bashrc
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi
```

```bash
# ~/.bash_aliases
alias ll='ls -lah'
alias dc='docker compose'
```

Then `source ~/.bashrc` or open a new shell.

### Remove

```bash
unalias ll
unalias -a              # nuclear; current shell only
```

### Bypass aliases

```bash
command ls
\ls
/bin/ls
```

Essential when an alias breaks a scripted expectation interactively.

### sudo and alias expansion (bash)

```bash
alias sudo='sudo '
# trailing space makes bash expand the next word as an alias
sudo ll                 # may work if ll is alias
```

### Better as functions

```bash
mkcd() { mkdir -p -- "$1" && cd -- "$1"; }
backup() { cp -a -- "$1" "$1.bak.$(date +%Y%m%d%H%M%S)"; }
```

Aliases do not take parameters cleanly; functions do.

### Safety alias caveats

```bash
alias rm='rm -i'
# feels safe; non-interactive scripts still use raw rm
# other users/shells unaffected
```

## Notes / Pitfalls

- Non-interactive bash does not expand aliases by default (`shopt expand_aliases` can enable, but functions are clearer).
- Quote carefully: `alias e=echo hi` is wrong; use `alias e='echo hi'`.
- Recursive aliasing and shadowing builtins can confuse (`alias cd=...` — avoid unless intentional).
- zsh/fish have richer abbreviation systems; syntax differs.
- Exporting aliases to child shells is not a thing — source rc files instead.

## 2026-relevant notes

- Dotfile managers (chezmoi, yadm) commonly template alias collections per machine.
- Prefer shared functions in a small `~/.config/shell/functions` for portability across bash/zsh when possible.
- Tool-provided completions > heavy aliases for complex CLIs (`kubectl`, `docker`).

## Related Commands

- Shell functions — parameterized shortcuts
- `type` / `command -v` — resolution
- `ln -s` — filesystem shortcuts
- `hash` — bash command hashing
- `bind` / keymaps — interactive productivity beyond aliases

## Additional Resources

- `help alias`, `help unalias`, `man bash`
