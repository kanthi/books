# nice / renice

## Overview
`nice` starts a process with an adjusted **CPU niceness** (priority bias). `renice` changes niceness of running processes. Range is typically **-20** (highest priority) to **19** (lowest). Unprivileged users can only increase nice (make friendlier).

## Syntax
```bash
nice [-n adjustment] command
renice [-n] priority [-p PID...] [-u user...]
```

## Examples with Explanations
### Start low priority
```bash
nice -n 19 ./batch-compress.sh
nice -n 10 tar -czf backup.tgz data/
```

### Renice running
```bash
renice -n 15 -p 1234
sudo renice -n -5 -p 1234     # needs privilege for negative
renice -n 10 -u builduser
```

### Inspect
```bash
ps -o pid,ni,comm -p 1234
top   # NI column
```

## Notes
- Niceness is **not** hard realtime priority (`chrt`/`SCHED_FIFO`).  
- I/O priority is separate (`ionice` on Linux).  
- Default nice is 0.

## Related Commands
- `ionice` — I/O class/priority  
- `chrt` — scheduling policy  
- `timeout` — time bound  
- `ps` / `top` — observe
