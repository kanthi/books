# w

## Overview

`w` shows who is logged in **and** what they are doing, plus system uptime and load averages. It combines aspects of `uptime`, `who`, and a glimpse of each session’s current process — a classic first glance after SSH’ing into a busy server.

## Syntax

```bash
w [options] [user]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-h` | No header |
| `-s` | Short format (less detail) |
| `-f` | Toggle from field (remote host) |
| `-i` | Show IP instead of hostname when possible |
| `-o` | Old-style output order |
| `-u` | Ignore username for current process / idle calc variants |
| `user` | Show only this user |

## Examples with Explanations

### Default

```bash
w
# 10:22:01 up 5 days,  3:01,  4 users,  load average: 0.42, 0.35, 0.30
# USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
# alice    pts/0    203.0.113.10     09:01    0.00s  0.12s  0.01s w
```

### Filter one user

```bash
w alice
```

### Short / no header

```bash
w -h
w -s
```

### IP addresses

```bash
w -i
```

### Correlate with load tools

```bash
w
uptime
ps -u alice
top -bn1 | head
```

### When you need history

```bash
w
last -a | head
journalctl _COMM=sshd -n 20
```

## Understanding columns

| Column | Meaning |
|--------|---------|
| USER | Login name |
| TTY | Terminal device |
| FROM | Remote host (if any) |
| LOGIN@ | Login time |
| IDLE | Idle time on tty |
| JCPU | Time of all processes on tty |
| PCPU | Time of current process |
| WHAT | Current command line |

Exact columns vary slightly by implementation (procps-ng).

## Notes / Pitfalls

- `WHAT` is a snapshot — can be misleading for short-lived commands.
- Idle time does not mean CPU idle for the whole system.
- Containers and GUI sessions may not appear as classic pts entries.
- Do not rely on `w` alone for security auditing; use auth logs/journal.
- High load with few users often means services/cron, not interactive humans.

## 2026-relevant notes

- Still excellent for quick SSH triage; pair with `systemd-cgtop` / `btop` for service-heavy hosts.
- `loginctl list-sessions` gives systemd’s session view.
- Cloud bastions: many `FROM` IPs may be the bastion, not the end user.

## Related Commands

- `who` — simpler login list
- `uptime` — load + uptime only
- `ps` / `top` / `htop` — process detail
- `last` — login history
- `loginctl` — systemd sessions
- `finger` — legacy user info (if installed)

## Additional Resources

- `man w`
