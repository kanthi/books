# cron

## Overview

`cron` is the classic daemon that runs scheduled jobs from per-user and system crontab files. On modern Ubuntu, **systemd timers** are often a better fit for service-integrated jobs, but cron remains everywhere: shared hosting, legacy scripts, and simple user schedules. This page covers how the daemon interprets schedules and where jobs live; day-to-day editing is usually via `crontab`.

## Syntax

Jobs are **not** started as `cron …`. You install lines into a crontab; `cron` reads them.

Crontab schedule fields:

```text
* * * * * command
│ │ │ │ │
│ │ │ │ └── day of week (0–7, Sun=0 or 7; some versions allow names)
│ │ │ └──── month (1–12)
│ │ └────── day of month (1–31)
│ └──────── hour (0–23)
└────────── minute (0–59)
```

System drop-in files under `/etc/cron.d/` use an **extra username field** after the schedule:

```text
* * * * * root /usr/local/bin/job.sh
```

## Common schedule patterns

| Expression | Meaning |
|------------|---------|
| `*/15 * * * *` | Every 15 minutes |
| `0 * * * *` | Top of every hour |
| `0 3 * * *` | Daily at 03:00 |
| `0 9 * * 1-5` | Weekdays 09:00 |
| `0 0 1 * *` | Monthly, 1st at midnight |
| `@reboot` | Once at cron startup (after boot) |
| `@daily` / `@weekly` / `@hourly` | Nicknames (implementation-specific paths) |

Special characters: `*` any, `,` list, `-` range, `/` step. Extensions like `L`, `W`, `#` are **not** portable — stick to the five standard fields unless you know your cron flavor.

## Key Use Cases

1. Periodic backups and reports  
2. Log or temp cleanup  
3. Polling scripts that are not worth a long-running daemon  
4. User-level schedules without writing systemd units  

## Safety

- Jobs run with a **minimal environment** — always use absolute paths and set `PATH`/`SHELL` in the crontab when needed.  
- Mail/`MAILTO` can flood or leak output; redirect stdout/stderr intentionally.  
- Never put secrets on the command line in a world-readable system crontab; use root-owned scripts with `0600` or secret managers.  
- Overlapping long jobs: guard with `flock` so two copies do not run at once.

## Examples with Explanations

### User crontab (via crontab tool)

```bash
crontab -l
crontab -e
```

`cron` executes the commands as that user. See the `crontab` chapter for flags.

### Example job lines

```cron
# m h dom mon dow command
0 3 * * * /usr/local/bin/backup.sh >>/var/log/backup.log 2>&1
*/15 * * * * /usr/bin/flock -n /tmp/poll.lock /usr/local/bin/poll.sh
@reboot /usr/local/bin/start-tunnel.sh
```

Redirects capture output; `flock -n` skips a run if the previous still holds the lock.

### System-wide locations (Ubuntu)

| Path | Role |
|------|------|
| `/etc/crontab` | System crontab (has user field) |
| `/etc/cron.d/*` | Drop-in packages/admin jobs (user field) |
| `/etc/cron.daily/` etc. | Scripts run by `run-parts` on a schedule |
| `/var/spool/cron/crontabs/` | Per-user crontabs (do not edit by hand) |

```bash
ls /etc/cron.d
ls /etc/cron.daily
```

### Environment inside cron

```cron
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
MAILTO=you@example.com
0 4 * * * /usr/local/bin/nightly.sh
```

Variables at the top of a crontab apply to later lines. `HOME` is usually the user’s home; do not assume interactive aliases.

### Debugging “it didn’t run”

```bash
# Is cron running?
systemctl status cron          # Debian/Ubuntu package name
systemctl status crond         # some RHEL-like systems

# Logs (paths vary)
journalctl -u cron -n 50 --no-pager
grep CRON /var/log/syslog | tail

# Syntax / permission issues
crontab -l
ls -l /usr/local/bin/nightly.sh   # must be executable; readable by the job user
```

Common failures: relative paths, missing `+x`, script expects a TTY, job runs as wrong user, anacron vs laptop sleep (see `anacron`).

### Prefer systemd timers when…

```bash
systemctl list-timers --all
# unit pair: foo.service + foo.timer
```

Timers give dependency ordering, better logging via the journal, and clearer failure states. Use cron when you need a portable one-liner or cannot install units.

## Understanding Output

Successful jobs are silent unless they print. By default many crons mail any stdout/stderr to the user (`MAILTO`). If mail is unconfigured, output may vanish into a local mailbox or be discarded — **always log explicitly** for important jobs.

## Notes & Pitfalls

- Day-of-month **and** day-of-week both set: meaning is “either matches” on Vixie/cronie (easy to schedule more often than intended).  
- Timezone is the system timezone (`timedatectl`); DST transitions can skip or double an hour.  
- Laptops/desktops asleep at the scheduled minute **miss** the job (use anacron or timers with `Persistent=true`).  
- Percent signs `%` in commands are special in some crons (newline to stdin) — escape as `\%`.  
- SELinux/AppArmor may deny scripts that work interactively.

## Related Commands

- `crontab` — install and list user crontabs  
- `anacron` — catch up periodic jobs on machines that sleep  
- `at` — one-shot future jobs  
- `systemctl` / timers — modern alternative  
- `flock` — mutual exclusion for long jobs  
- `logger` — send job messages to syslog/journal  

## Additional Resources

- `man cron` / `man 5 crontab`  
- [crontab.guru](https://crontab.guru/) — schedule explainer  
