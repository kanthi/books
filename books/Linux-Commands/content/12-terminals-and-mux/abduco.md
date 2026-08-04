# abduco

## Overview

`abduco` is a minimal **session attach/detach** tool: it runs a process under a controlling terminal session you can disconnect from and reattach to later. Lighter than full multiplexers (`tmux`, `screen`) — no window manager, just detachable sessions. Often paired with `dvtm` for tiling inside the session.

Optional package; not installed by default on most distros.

## Syntax

```bash
abduco [options] [-e key] [-r] name
abduco -A name [command...]
abduco -l
```

## Common Options

| Option | Description |
|--------|-------------|
| `-A name` | Attach or create session `name` |
| `-a name` | Attach to existing session |
| `-c name command` | Create session running command |
| `-e key` | Escape key (default `Ctrl-\`) |
| `-r` | Read-only attach |
| `-l` | List sessions |
| `-n` | Create but don’t attach |
| `-f` | Force (see man for attach behavior) |
| `-q` | Quiet |

Exact flags can vary slightly by version — check `abduco -h`.

## Examples with Explanations

### Create / attach

```bash
abduco -A work
# runs $SHELL by default in a new session if needed
```

### Run a specific command

```bash
abduco -c build make -j$(nproc)
abduco -a build
```

### List and reattach

```bash
abduco -l
abduco -a work
```

### Detach

```text
Ctrl-\   (default detach key — confirm with man/help)
```

Or close the SSH client carefully knowing the session survives.

### Read-only observe

```bash
abduco -r -a work
```

### Pair with dvtm

```bash
abduco -A dev dvtm
```

`dvtm` provides tiling; `abduco` provides detach.

### vs tmux

```bash
# tmux: windows, panes, scripting, ecosystem
tmux new -s work
# abduco: tiny attach/detach
abduco -A work
```

## Notes / Pitfalls

- Must be installed; rare on enterprise minimal images.
- Escape key conflicts — rebind with `-e` if needed.
- Not a full replacement for tmux scripting/automation.
- Session socket location depends on build (`ABDUCO_SOCKET_DIR` / runtime dir).
- Sharing sessions multi-user needs careful permissions (prefer tmux/socket policies or separate tools).

## 2026-relevant notes

- Nice for constrained environments where tmux feels heavy, or for teaching detach basics.
- For production admin work, **tmux** or **systemd** still dominate.
- Combine with mosh/SSH keepalive for flaky links.

## Related Commands

- `tmux` / `screen` — full multiplexers
- `dvtm` — tiling wm for terminal
- `dtach` — similar detach tool
- `nohup` / `disown` — weaker persistence
- `systemd-run` — transient services

## Additional Resources

- `abduco -h`, project docs (martanne/abduco)
