# history

## Overview

`history` shows the shell’s command history list (bash). Operators use it to recall prior commands, audit what was run in a session, and re-run lines with event designators (`!!`, `!n`). Configuration lives in `HISTFILE`, `HISTSIZE`, `HISTFILESIZE`, and related bash variables — deep customization belongs in shell-config docs.

## Syntax

```bash
history [n]
history -c
history -d offset
history -a|-n|-r|-w [filename]
```

Without options, lists history with numbers.

## Common Options

| Option | Description |
|--------|-------------|
| `n` | Show last `n` entries |
| `-c` | Clear history list |
| `-d offset` | Delete entry at offset |
| `-a` | Append new lines to `$HISTFILE` |
| `-n` | Read unseen lines from `$HISTFILE` |
| `-r` | Read file and replace current history |
| `-w` | Write current history to file |
| `-p` | Expand history designators (advanced) |
| `-s` | Append args as a single history entry |

## Examples with Explanations

### Show recent commands

```bash
history | tail -20
history 30
```

### Search history (interactive bash)

```bash
# Ctrl-R  reverse incremental search (readline)
history | grep ssh
```

### Re-run by number / last command

```bash
!552          # re-run event 552
!!            # re-run last command
sudo !!       # common: repeat last with sudo
```

Be careful with destructive lines — review before firing `!!`.

### Append now (multi-session)

```bash
history -a
```

Useful so another terminal can `history -n` and see your latest commands.

### Clear session history

```bash
history -c
history -w    # optional: persist the empty/cleared state carefully
```

Clearing does not erase other users’ audits (journal, `auth.log`, bash_history on disk may still exist until overwritten).

### Delete one awkward line

```bash
history | tail
history -d 1042
```

Still may exist in `$HISTFILE` until rewritten — know privacy limits of shell history.

### Where history is stored

```bash
echo "$HISTFILE"          # typically ~/.bash_history
echo "$HISTSIZE" "$HISTFILESIZE"
```

## Notes

- Commands prefixed with space may be omitted if `HISTCONTROL=ignorespace` (common).
- `HISTCONTROL=ignoredups` / `erasedups` change what gets stored.
- History is **not** a security log — rootkits and other shells won’t appear; privileged ops need proper auditing.
- zsh uses a different history system (`fc`, `HISTFILE`); this page is bash-oriented as Ubuntu default login shell for many admins.
- Avoid putting secrets on the command line; they land in history and process tables.

## Related Commands

- `type` / `command` — resolve what will run
- `alias` — expansions that also show up as typed
- `fc` — fix/re-run history ranges (bash)
- `script` — full terminal typescript recording

## Additional Resources

- `help history`
- `man bash` (HISTORY section)
