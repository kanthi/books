# at

## Overview

`at` schedules a **one-shot** command to run once at a future time. Unlike `cron` (recurring) or systemd timers (rich units), `at` is ideal for “run this once tonight” admin tasks. Companion tools: `atq` (queue), `atrm` (remove), `batch` (run when load is low).

Requires `atd` service running and permission via `/etc/at.allow` / `/etc/at.deny`.

## Syntax

```bash
at [-q queue] [-f file] [-m] TIME
atq
atrm JOB...
batch
```

## Common Options

| Option | Description |
|--------|-------------|
| `-f file` | Read job from file |
| `-m` | Mail when done (even if no output) |
| `-M` | Never mail |
| `-q queue` | Queue letter (`a` default; higher letters later) |
| `-t time` | Time as `[[CC]YY]MMDDhhmm[.ss]` |
| `-v` | Show time job will run |
| `-c job` | Cat job contents |
| `-l` | Alias for `atq` on some systems |
| `-d` | Alias for `atrm` on some systems |

## Time expressions

```text
now + 30 minutes
now + 2 hours
teatime          # 16:00
noon
midnight
23:30
10am tomorrow
4pm + 3 days
```

## Examples with Explanations

### Interactive job

```bash
at now + 1 hour
# then type commands, finish with Ctrl-D
echo "hello from at" >> /tmp/at.out
systemctl restart demo
^D
```

### One-liner from pipe

```bash
echo 'systemctl restart nginx' | sudo at now + 5 minutes
echo 'wall "maintenance over"' | at 22:00
```

### From file

```bash
cat > /tmp/job.sh <<'EOF'
#!/bin/bash
/usr/local/bin/backup.sh
EOF
at -f /tmp/job.sh 2am tomorrow
```

### Queue management

```bash
atq
at -c 7                 # show job 7 script
atrm 7
```

### batch

```bash
echo '/usr/local/bin/heavy-index' | batch
```

Runs when system load allows (implementation-defined).

### Ensure service

```bash
systemctl status atd
sudo systemctl enable --now atd
```

## Notes / Pitfalls

- Environment is a snapshot — don’t assume your interactive aliases; use absolute paths.
- Output mailed to user if local mail works; on servers mail may be undelivered — redirect to files.
- Permissions: not all users may use `at` (allow/deny files).
- Timezone is system timezone (`timedatectl`).
- Not a substitute for durable job queues in multi-host apps.

## 2026-relevant notes

- Prefer `systemd-run --on-calendar=` / `--on-active=` for modern one-shots with cgroups/logging.
- `at` remains handy on classic servers for quick deferred restarts.
- Containers often lack `atd` — use external schedulers.

## Related Commands

- `atq` / `atrm` / `batch`
- `cron` / `crontab`
- `systemd-run` / timers
- `sleep` — simple delay in a live shell
- `wall` — broadcast messages

## Additional Resources

- `man at`, `man atd`
