# tmate

## Overview

`tmate` is a fork of tmux focused on **instant terminal sharing**. It creates a session and prints SSH/web URLs so collaborators can attach remotely. Great for pair debugging; treat access tokens as secrets. For local-only multiplexing without sharing, use stock `tmux`.

## Syntax

```bash
tmate [tmux-compatible options]
tmate show-messages
tmate wait tmate-ready
```

Most session control mirrors **tmux** keybindings and commands.

## Common usage patterns

| Action | Example |
|--------|---------|
| Start shared session | `tmate` |
| Wait until ready | `tmate wait tmate-ready` |
| Print connection info | `tmate show-messages` / display-panes messages |
| Detach | `Ctrl-b d` (default prefix like tmux) |
| Local config | `~/.tmate.conf` |

## Examples with Explanations

### Start a session

```bash
tmate
# note the ssh and web URLs printed
tmate wait tmate-ready
tmate show-messages
```

### Capture SSH URL for a colleague

```bash
tmate -F show-messages | grep 'ssh session:'
# or scripted:
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
```

### Read-only vs read-write links

tmate provides different access strings (RO/RW). Share **read-only** by default; only give RW to trusted peers.

### Config sketch

```bash
# ~/.tmate.conf
set -g tmate-server-host ssh.tmate.io
# org-hosted servers possible for privacy
```

### End session

```bash
# exit shells or kill-session
tmate kill-server
```

### Prefer local tmux when not sharing

```bash
tmux new -s solo
```

## Notes / Pitfalls

- Default public relay means session metadata/paths may transit third parties — use a **self-hosted** tmate server for sensitive work.
- Anyone with the RW SSH string has full terminal control — treat like a root password.
- Corporate networks may block outbound SSH to tmate hosts.
- Still tmux-based: know prefix keys, panes, and copy-mode.
- Don’t leave orphan shared sessions on bastion hosts.

## 2026-relevant notes

- Alternatives: VS Code Live Share, SSH with `tmux` + explicit user accounts, commercial pair tools.
- For regulated environments, mandate self-hosted relays or forbid tmate.
- Rotate by killing sessions after the pairing call ends.

## Related Commands

- `tmux` — local multiplexer foundation
- `screen` — classic alternative
- `ssh` — direct remote access
- `script` / `asciinema` — record sessions without live share

## Additional Resources

- `man tmate`, tmate.io documentation
