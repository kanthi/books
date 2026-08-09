# ss

## Overview
`ss` (socket statistics) inspects TCP/UDP/UNIX sockets. It is the modern replacement for most `netstat` use cases and is faster on busy systems.

## Syntax
```bash
ss [options] [filter]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t` / `-u` / `-x` | TCP / UDP / UNIX |
| `-l` | Listening sockets |
| `-a` | All (listen + established) |
| `-n` | Numeric hosts/ports (no resolve) |
| `-p` | Process that owns the socket |
| `-e` | Extended detail |
| `-m` | Socket memory |
| `-s` | Summary statistics |
| `-4` / `-6` | Address family |
| `-H` | Suppress header (newer) |
| `-o` | Timer info |

## Key Use Cases
1. See what is listening and on which port  
2. Find connections to/from a host  
3. Map sockets to PIDs/processes  
4. Diagnose TIME-WAIT / backlog issues  

## Examples with Explanations
### Listening TCP with processes
```bash
sudo ss -lntp
```
`-p` usually needs root for other users’ processes.

### Established connections
```bash
ss -tnp
```

### Filter by port
```bash
ss -lntp '( sport = :22 )'
ss -tnp '( dport = :443 or sport = :443 )'
```

### Filter by destination
```bash
ss -tn dst 1.1.1.1
```

### UDP listeners
```bash
sudo ss -lunp
```

### Summary
```bash
ss -s
```

### UNIX domain sockets
```bash
ss -xlp | head
```

## Understanding Output
Columns typically include state (`LISTEN`, `ESTAB`), local/peer addresses, and process (`users:(("nginx",pid=…,fd=…))`). Prefer `-n` in scripts for stable output.

## Common Usage Patterns
### “What owns port 8080?”
```bash
sudo ss -lntp | grep ':8080'
# or
sudo ss -lntp '( sport = :8080 )'
```

### Count connections per state
```bash
ss -ant | awk 'NR>1 {print $1}' | sort | uniq -c | sort -nr
```

## Notes & Pitfalls
- Filters use a small language; quote them for the shell.  
- `netstat` is still found on some systems but often via `net-tools` legacy package.  
- For packet capture use `tcpdump`/`wireshark`, not `ss`.  

## Related Commands
- `lsof -i` — alternate open-file view  
- `ip` — addresses and routes  
- `nmap` — external port scans  
- `netstat` — legacy  

## Additional Resources
- `man ss`
