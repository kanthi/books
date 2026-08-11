# env

## Overview

`env` runs a program in a modified environment, or prints the current environment variables when given no command. It is essential for shebangs (`#!/usr/bin/env bash`), clearing the environment (`-i`), and injecting variables for a single command without exporting them permanently in the shell.

## Syntax

```bash
env [options] [NAME=VALUE]... [command [args...]]
env                       # print environment
```

## Common Options

| Option | Description |
|--------|-------------|
| `-i`, `--ignore-environment` | Start with an empty environment |
| `-u NAME`, `--unset=NAME` | Remove variable |
| `-0`, `--null` | NUL-delimit output |
| `-C dir`, `--chdir=dir` | Change directory before exec (newer coreutils) |
| `-S string` | Split string on shebang lines (see man) |
| `-v` | Verbose |
| `--` | End of options |

## Examples with Explanations

### Print environment

```bash
env
env | sort
env | grep -E '^(PATH|HOME|USER)='
printenv PATH               # single var alternative
```

### Run with extra variables

```bash
env FOO=bar BAZ=1 ./script.sh
env NODE_ENV=production node app.js
```

Equivalent to shell `FOO=bar ./script.sh` for simple cases; `env` shines with cleared environments and shebangs.

### Clear environment

```bash
env -i PATH=/usr/bin:/bin HOME="$HOME" bash --noprofile --norc
env -i $(cat allowed.env | xargs) command
```

Useful for clean builds and debugging “works in my shell” issues.

### Unset for one command

```bash
env -u http_proxy -u https_proxy curl -I https://example.com
```

### Shebang portability

```bash
#!/usr/bin/env bash
#!/usr/bin/env python3
```

`env` locates the interpreter via `PATH`, avoiding hard-coded `/usr/bin/python3` when layouts differ. (Security-sensitive contexts may prefer absolute paths.)

### Chdir then run (when supported)

```bash
env -C /var/www -i PATH=/usr/bin:/bin ./deploy.sh
```

### NUL-safe dump

```bash
env -0 | tr '\0' '\n' | sort
```

## Notes / Pitfalls

- `env -i` is easy to over-strip — many programs need `PATH`, `HOME`, `TERM`, `LANG`.
- Shebang line length limits exist; complex `env -S` usage has edge cases.
- Printing env may leak secrets (`AWS_*`, tokens) — avoid pasting full dumps.
- Order of assignment and `-u` matters; see man page for processing order.
- Shell builtins are not found by `env` — it execs real programs from PATH.

## 2026-relevant notes

- Container entrypoints often use `env` or exec forms to inject config.
- Prefer explicit `.env` loading tools or systemd `Environment=` for services.
- Security: `LD_PRELOAD` and similar can be injected via env — hardened systems scrub them for setuid.

## Related Commands

- `printenv` — print variables
- `export` / `set` — shell environment
- `envdir` / `dotenv` — external env loaders
- `systemd-run` / unit `Environment=` — service env
- `sudo -E` / `sudo --preserve-env` — elevated env policy

## Additional Resources

- `man env`
