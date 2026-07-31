# nohup

## Overview
`nohup` runs a command immune to **SIGHUP**, so it keeps running after logout when started from a terminal. Output defaults to `nohup.out` if not redirected.

## Syntax
```bash
nohup command [args...]
nohup command [args...] >file 2>&1 &
```

## When to use what
| Need | Prefer |
|------|--------|
| Quick one-off after SSH logout | `nohup … &` or `tmux`/`screen` |
| Survives reboot | `systemd` user/system service or timer |
| Managed restart/logs | `systemd-run` / unit file |
| Interactive detach | `tmux` / `screen` |

## Examples with Explanations
### Classic background job
```bash
nohup ./long-job.sh > long-job.log 2>&1 &
echo $!
```

### Default nohup.out
```bash
nohup python train.py &
# writes ./nohup.out
```

### Check later
```bash
tail -f long-job.log
ps -p <pid> -o pid,etime,cmd
```

### Better: transient systemd unit
```bash
systemd-run --unit=longjob --user ./long-job.sh
journalctl --user -u longjob -f
```

### Better: tmux session
```bash
tmux new -d -s train './long-job.sh'
tmux attach -t train
```

## Notes
- `nohup` does not daemonize fully; still a child process.  
- `&` backgrounds in the shell; `nohup` alone still attaches until backgrounded.  
- `disown` is a bash alternative after starting a job.

## Related Commands
- `tmux` / `screen`  
- `systemd-run` / `systemctl`  
- `setsid`  
- `timeout` — bound runtime
