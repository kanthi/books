# export

## Overview

`export` marks shell variables for the **environment** so child processes inherit them. Without export, a variable is shell-local. Operators use it for `PATH`, `EDITOR`, proxy variables, language settings, and app config in a session. Permanent setup belongs in shell rc files or systemd units — not ad-hoc forever in one terminal.

## Syntax

```bash
export [-fn] [name[=value] ...]
export -p
```

## Common Options

| Option | Description |
|--------|-------------|
| `name=value` | Set and export in one step |
| `-p` | Print all exported variables (declare style) |
| `-n` | Remove export property (variable may remain) |
| `-f` | Export functions (bash; use sparingly) |

## Examples with Explanations

### Set for children

```bash
export EDITOR=vim
export LANG=en_US.UTF-8
export PATH="$HOME/.local/bin:$PATH"
```

New processes from this shell see these values.

### One-shot without permanent export

```bash
EDITOR=vim git commit
env NODE_ENV=production node app.js
```

Prefix assignment affects one command; `export` is for the rest of the session (or until changed).

### Show exports

```bash
export -p | head
export -p | grep -E 'PATH|HOME|EDITOR'
env | sort
printenv PATH
```

### Unexport / unset

```bash
export -n MYTEMP          # still set, not in environment
unset MYTEMP              # remove entirely
```

### Common operator variables

```bash
export http_proxy=http://proxy.example:3128
export https_proxy=$http_proxy
export no_proxy=localhost,127.0.0.1,.example.com
export DEBIAN_FRONTEND=noninteractive   # apt in scripts (careful)
```

### Persist for your user (pointer)

```bash
# add to ~/.bashrc or ~/.profile as appropriate — then open a new shell
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
```

System services should use unit `Environment=` / `EnvironmentFile=`, not your interactive exports.

## Notes

- Child shells inherit exports; already-running processes do not update retroactively.
- `export` is a **builtin** — see `type export`.
- Secrets in the environment are visible to other processes with same privileges (`/proc/pid/environ`) — prefer files with mode `600` or secret managers for sensitive material.
- Arrays and complex bash structures don’t export portably; stick to strings for environment.
- Typo’d `PATH=` without preserving old value can break the session (`command not found`).

## Related Commands

- `env` — run with modified environment / print env
- `printenv` — print variables
- `set` — shell options and variables (broader)
- `declare -x` — bash equivalent flavor
- `systemctl` — service environment

## Additional Resources

- `help export`
- `man bash` (PARAMETERS / ENVIRONMENT)
