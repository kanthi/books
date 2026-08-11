# pgrep

## Overview

`pgrep` lists process IDs matching selection criteria (name, full command line, user, terminal, etc.). `pkill` uses the **same selectors** but sends a signal instead of printing PIDs. Together they replace brittle `ps | grep` pipelines for operations and scripts. On Ubuntu both come from **procps**.

## Syntax

```bash
pgrep [options] pattern
pkill [options] pattern
```

## Common Options

Shared selection flags (both tools):

| Option | Description |
|--------|-------------|
| `-u USER`, `--uid` | Match effective user (name or UID) |
| `-U USER`, `--euid` | Match real user (see man for distinction) |
| `-g PGID` / `-G GID` | Process group / group membership |
| `-t TERM` | Controlling terminal (e.g. `pts/0`) |
| `-P PPID` | Children of PPID |
| `-f`, `--full` | Match against full command line, not only comm |
| `-x`, `--exact` | Exact match of the name (or full line with `-f`) |
| `-n` / `-o` | Newest / oldest match only |
| `-v` | Inverse match |
| `-c` | Count matches (pgrep) |
| `-d DELIM` | PID delimiter (default newline; `,` useful for `htop -p`) |
| `-a` | Show PID and full command (pgrep) |
| `-l` | Show PID and process name (pgrep) |
| `-i` | Case-insensitive |
| `-r` | Ignore descendants of pgrep/pkill itself (where supported) |

`pkill`-specific:

| Option | Description |
|--------|-------------|
| `-SIGNAL` / `-s SIGNAL` | Signal name or number (default **TERM**) |
| `-e`, `--echo` | Print what will be signaled (newer procps) |
| `-q` | Quiet |

## Safety

- Broad patterns (`pkill python`, `pkill java`) are classic outage sources — prefer **`-x`**, **`-f` with a specific string**, and **`-u`**.
- Escalate signals: **TERM → wait → KILL**; `pkill -9` should be rare.
- Managed services: prefer `systemctl stop/reload` over `pkill nginx`.
- Always inventory with `pgrep -a` before `pkill` on production.

## Key Use Cases

1. Resolve PIDs for scripts without parsing `ps`
2. Signal a homogeneous worker pool
3. Count processes for simple health checks
4. Feed PID lists to `top`/`htop`/`gdb`

## Examples with Explanations

### Example: list matching PIDs

```bash
pgrep sshd
pgrep -a nginx
pgrep -l python3
```

`-a` shows full command lines — best pre-kill inspection.

### Example: exact name match

```bash
pgrep -x sshd
pgrep -x nginx
```

Avoids partial matches against longer comm names when you want precision.

### Example: full command line

```bash
pgrep -af 'gunicorn.*myapp'
pgrep -f 'python3 /opt/app/worker.py'
```

`-f` is essential when every process is `python3` or `java`.

### Example: filter by user

```bash
pgrep -u www-data -a php-fpm
pgrep -u "$USER" -f train.py
```

Reduces collateral damage on shared systems.

### Example: count for monitoring

```bash
pgrep -c -x sidekiq
pgrep -c -u redis redis-server
```

Exit status is still 0/1 for found/not found; combine carefully in scripts.

### Example: newest / oldest only

```bash
pgrep -n -x myapp     # newest
pgrep -o -x myapp     # oldest (often the master)
```

Useful when a master/worker model embeds the same name.

### Example: children of a parent

```bash
pgrep -P "$(pgrep -xo master-process)"
```

List direct children by parent PID.

### Example: delimiter for other tools

```bash
htop -p "$(pgrep -d, nginx)"
top -p "$(pgrep -d, -x myapp)"
```

Comma-separated PID lists fit `htop -p` / `top -p`.

### Example: pkill graceful then force

```bash
pkill -TERM -x myapp
sleep 3
pkill -KILL -x myapp 2>/dev/null
```

Same discipline as `kill`: TERM first, KILL only for stragglers.

### Example: pkill with full-line match

```bash
pkill -u deploy -f 'uvicorn app.main:app'
```

Targets one service invocation pattern under one user.

### Example: avoid ps | grep

```bash
# fragile:
ps aux | grep '[n]ginx'
# better:
pgrep -a nginx
```

Character-class `grep` tricks are obsolete for this job.

## Understanding Output

- Default: one PID per line.
- Exit status **0** if any match, **1** if none, **2** on syntax/usage error, **3** fatal error (procps conventions).
- `pkill` exit status follows the same “matched or not” idea — check man page when scripting strict failure modes.

## Notes & Pitfalls

- Pattern is an **extended regex** by default — dots and brackets matter; quote patterns.
- Without `-f`, matching uses the process name (comm), often truncated to 15 characters historically — use `-f` for long names.
- Race: process can exit between `pgrep` and `kill`; handle missing PIDs.
- `pkill`/`pgrep` may see processes in other sessions; still restricted by permissions for signaling.
- In containers, you only see PIDs in your PID namespace.

## Related Commands

- `pkill` — signal instead of list (same selectors)
- `kill` / `killall` — by PID or simple name
- `pidof` — simpler name → PID (fewer filters)
- `ps` — rich table and custom columns
- `systemctl` — prefer for supervised units

## Additional Resources

- `man pgrep`
- `man pkill`
