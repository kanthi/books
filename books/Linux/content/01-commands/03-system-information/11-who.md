# who

## Overview

`who` shows who is logged in, with terminal, login time, and sometimes host/remote info from utmp/wtmp accounting. Related tools: `w` (richer: load + what they run), `users` (names only), `last` (historical logins).

## Syntax

```bash
who [options] [file]
who am i
whoami                 # different command: effective user
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | All information (combo flags) |
| `-b` | Boot time |
| `-d` | Dead processes |
| `-H` | Header |
| `-l` | Login processes |
| `-m` | Same as `who am i` (hostname and user for stdin) |
| `-q` | Count and names only |
| `-r` | Runlevel (legacy) |
| `-s` | Short format |
| `-t` | Last system clock change |
| `-u` | Idle time / PID |
| `-T` | Message status of mesg (+/−) |

Optional `file` defaults to utmp (often `/var/run/utmp` or `/run/utmp`).

## Examples with Explanations

### Who is on the system

```bash
who
who -H
who -u
who -q
```

### Boot time

```bash
who -b
uptime -s
```

### Yourself

```bash
who am i
who -m
logname
```

### Compare with w

```bash
who
w
users
```

`w` adds load averages and the current command line of each session.

### Historical

```bash
last
last -a
who /var/log/wtmp          # if supported / accessible
```

### Scripting inventory

```bash
who | awk '{print $1}' | sort -u
```

## Notes / Pitfalls

- utmp accuracy varies: display managers, wayland, lingering sessions, and containers may not appear as classic ttys.
- SSH multiplexing and tmux can make “one human, many lines”.
- Empty output on some minimal containers is normal — no utmp traffic.
- Privacy: listing logins is normal for admins; still treat usernames carefully in logs.
- `whoami` ≠ `who am i`.

## 2026-relevant notes

- Prefer `loginctl` on systemd for modern session management views.
- Audit pipelines use `last`/`journalctl` more than live `who`.
- Remote access gateways may hide real client IPs behind proxies — check sshd logs.

## Related Commands

- `w` — richer logged-in view
- `users` — names only
- `last` / `lastlog` — history
- `logname` — login name
- `loginctl` — systemd sessions
- `whoami` / `id` — identity of current process

## Additional Resources

- `man who`
