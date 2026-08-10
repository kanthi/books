# loginctl

## Overview

`loginctl` manages **systemd-logind** seats, sessions, and users: who is logged in, idle hints, kill sessions, and **lingering** (keep user services running after logout). Essential for systemd user instances and multi-seat systems.

## Syntax

```bash
loginctl [options] command [args...]
```

## Common Commands

| Command | Description |
|---------|-------------|
| `list-sessions` | Active sessions |
| `session-status ID` | Detail |
| `user-status USER` | User’s sessions / linger |
| `list-users` | Users with sessions |
| `enable-linger` / `disable-linger` | User services without login |
| `terminate-session` / `kill-session` | End session |
| `lock-session` | Lock session (where a lock agent exists) |
| `show-session` | Low-level properties |

## Examples with Explanations

### Who is logged in

```bash
loginctl list-sessions
loginctl list-users
who
```

### Session details

```bash
loginctl session-status
loginctl show-session "$XDG_SESSION_ID" -p Remote -p Type -p State
```

### Enable lingering for user services

```bash
loginctl enable-linger "$USER"
# or for another account:
sudo loginctl enable-linger deploy
systemctl --user status
```

Required for rootless Podman/user timers to survive logout.

### Terminate a stale session

```bash
loginctl list-sessions
sudo loginctl terminate-session 42
```

## Notes & Pitfalls

- Killing sessions drops that session’s processes (including SSH shells attached to it).  
- Linger creates `/var/lib/systemd/linger/USER`.  
- In containers, logind may be absent.

## Related Commands

- `systemctl --user`  
- `who` / `w` / `last`  
- `machinectl`  

## Additional Resources

- `man loginctl`  
- `man logind.conf`
