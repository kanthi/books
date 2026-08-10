---
title: Intro
---

# Intro

Run work later or periodically. Classic `cron`/`crontab`/`anacron`/`at` remain everywhere; on systemd hosts also consider timers (`systemctl list-timers`, `systemd-run`).

## Commands in this part

| Command | Role |
|---------|------|
| `cron` | cron is the classic daemon that runs scheduled jobs from per-user and system crontab files. |
| `crontab` | crontab installs, lists, and removes per-user crontab files that the cron daemon executes. |
| `anacron` | anacron runs periodic commands on machines that are not on 24/7 — laptops, desktops, and intermittent VMs. |
| `at` | at schedules a one-shot command to run once at a future time. |


## Suggested starting points

1. User jobs: `crontab -e` / `crontab -l`.
2. Daemon and system tables: `cron`, `/etc/cron.d`.
3. Machines that sleep: `anacron`.
4. One-shot future jobs: `at`.
5. Modern alternative: systemd timers (Services and runtime).

## Related parts

- Services and runtime — `systemd-run`, timers
- Logging — capture job output with `logger`/`journalctl`
- Shell commands — reliable one-liners for jobs

Continue with the individual command pages in this part.
