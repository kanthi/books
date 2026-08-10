# systemd-run

## Overview

`systemd-run` creates **transient** units on the fly: one-shot commands, background services, or temporary timers without writing unit files. Ideal for resource-limited jobs, ad-hoc schedules, and testing cgroup settings.

## Syntax

```bash
systemd-run [options] command [args...]
systemd-run --user [options] command...
```

## Common Options

| Option | Description |
|--------|-------------|
| `--unit=name` | Name the transient unit |
| `--property=…` / `-p` | Set unit properties (`CPUQuota=`, `MemoryMax=`, …) |
| `--timer-property=…` | For `--on-calendar` / timers |
| `--on-calendar=` | Schedule like a timer |
| `--on-active=` | Run after a delay |
| `-t` / `--pty` | PTY for interactive |
| `-P` / `--pipe` | Connect stdin/stdout |
| `--wait` | Wait until finish |
| `--collect` | Garbage-collect unit after exit |
| `--uid=` / `--gid=` | Run as user/group |
| `--working-directory=` | cwd |

## Safety

- Transient timers/services disappear after reboot (unless you convert to real units).  
- Resource properties can OOM-kill aggressively — test with `--user` when possible.  
- Privileged properties need root.

## Examples with Explanations

### One-shot with wait

```bash
sudo systemd-run --wait --unit=scratch-job \
  /usr/local/bin/backup.sh
systemctl status scratch-job
```

### CPU/memory limits

```bash
sudo systemd-run -p CPUQuota=50% -p MemoryMax=512M --unit=heavy \
  --wait /usr/local/bin/encode.sh
```

### Transient timer

```bash
sudo systemd-run --on-calendar='*-*-* 03:00:00' --unit=nightly-backup \
  /usr/local/bin/backup.sh
systemctl list-timers | grep nightly
```

### User scope

```bash
systemd-run --user --on-active=10min --notify-me \
  notify-send 'Timer fired'
```

### Interactive shell in a scope

```bash
systemd-run --pty --same-dir --wait --collect bash
```

## Related Commands

- `systemctl` — manage the resulting unit  
- `systemd-analyze` — calendar expression help  
- `cron` / `at` — classic scheduling  
- `nice` / `ionice` / `systemd-cgtop` — resource control neighbors  

## Additional Resources

- `man systemd-run`  
- `man systemd.timer`  
- `man systemd.resource-control`
