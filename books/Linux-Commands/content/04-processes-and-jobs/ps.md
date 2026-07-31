# ps

## Overview
`ps` snapshots processes. Linux `ps` accepts both BSD-style (`ps aux`) and UNIX-style (`ps -ef`) option sets — mixing styles works but can confuse; pick one family per command.

## Syntax
```bash
ps [options]
```

## Common Invocations
| Form | Description |
|------|-------------|
| `ps aux` | BSD: all users, with CPU/MEM |
| `ps -ef` | UNIX: full listing |
| `ps -u USER` | User’s processes |
| `ps -p PID` | Specific PID |
| `ps -C name` | By command name |
| `ps --forest` / `f` | Tree view |

Useful output controls: `-o pid,ppid,user,pcpu,%mem,stat,cmd` (custom columns), `--sort=-%mem`.

## Key Use Cases
1. Identify heavy CPU/memory processes  
2. Find PIDs for signaling  
3. Inspect command lines and parentage  
4. Script process inventory  

## Examples with Explanations
### Classic full lists
```bash
ps aux | head
ps -ef | head
```

### Top memory consumers
```bash
ps aux --sort=-%mem | head -n 15
```

### Top CPU
```bash
ps aux --sort=-%cpu | head -n 15
```

### Custom columns
```bash
ps -eo pid,ppid,user,%cpu,%mem,stat,etime,cmd --sort=-%cpu | head
```

### By user / name
```bash
ps -u www-data -o pid,cmd
ps -C nginx -o pid,cmd
```

### Tree
```bash
ps auxf | less
# or
pstree -ap | less
```

### One PID detail
```bash
ps -p 1 -o pid,user,cmd,lstart
```

### Threads
```bash
ps -eLf | head
# or: ps -p PID -L
```

## Understanding Output
- **STAT** codes: `R` running, `S` sleep, `D` uninterruptible, `Z` zombie, `T` stopped; `+` foreground, `l` multi-threaded, etc.  
- **%CPU** is not normalized the same as `top` over long intervals.  
- **VSZ/RSS** memory columns differ (virtual vs resident).  

## Notes & Pitfalls
- `ps` is a snapshot; use `top`/`htop` for continuous view.  
- Prefer `pgrep` when you only need PIDs by name.  
- Kernel threads appear in brackets `[kthreadd]`.  

## Related Commands
- `top` / `htop` — interactive  
- `pgrep` / `pkill` — select/signal by pattern  
- `pstree` — hierarchy  
- `pidof` — simple name lookup  
- `/proc/PID` — detailed kernel process API  

## Additional Resources
- `man ps`
