# at / atq / atrm

## Overview
`at` schedules **one-shot** jobs for a later time. Recurring work belongs in `cron` or systemd timers. Requires the `atd` daemon.

## Syntax
```bash
at [options] TIME
at -f script TIME
atq
atrm id...
batch
```

## Time expressions
Examples: `now + 5 minutes`, `23:30`, `midnight`, `noon tomorrow`, `4pm + 2 days`, `teatime`.

## Examples with Explanations
### Interactive
```bash
at now + 10 minutes
# type commands, finish with Ctrl-D
```

### From pipe / file
```bash
echo '/usr/local/bin/backup.sh >> /var/log/backup.at.log 2>&1' | at 02:30
at -f ./job.sh midnight
```

### Queue management
```bash
atq
at -c 3          # show job body
atrm 3
```

### Low-load batch queue
```bash
echo './heavy.sh' | batch
```

## Permissions & service
```bash
systemctl status atd
# /etc/at.allow  /etc/at.deny
```

## Output
Job stdout/stderr is mailed to the user if a local MTA exists; otherwise redirect inside the job.

## Related Commands
- `crontab` / `anacron`  
- `systemd-run --on-calendar=` / `.timer` units  
- `sleep`
