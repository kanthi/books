# ss

## Overview
The `ss` (Socket Statistics) command is a modern replacement for netstat. It displays socket statistics and can show more TCP and state information than other tools.

## Syntax
```bash
ss [options] [filter]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Don't resolve names |
| `-a` | All sockets |
| `-l` | Listening sockets |
| `-p` | Show processes |
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-x` | Unix sockets |
| `-4` | IPv4 only |
| `-6` | IPv6 only |
| `-r` | Resolve names |
| `-m` | Memory usage |
| `-o` | Timer info |

## Socket States
| State | Description |
|-------|-------------|
| ESTAB | Established |
| LISTEN | Listening |
| TIME-WAIT | Time wait |
| CLOSE-WAIT | Close wait |
| SYN-SENT | Connection attempt |
| SYN-RECV | Connection request |
| FIN-WAIT-1 | Connection closed |
| FIN-WAIT-2 | Connection closed |
| LAST-ACK | Acknowledgment wait |
| CLOSING | Both sides closed |

## Key Use Cases
1. Socket monitoring
2. Connection tracking
3. Network debugging
4. Performance analysis
5. Security auditing

## Examples with Explanations
### Example 1: Listening Ports
```bash
ss -tulpn
```
Show TCP/UDP listeners

### Example 2: Established
```bash
ss -o state established
```
Show active connections

### Example 3: Process Info
```bash
ss -tp
```
Show with process names

## Common Usage Patterns
1. Check listeners:
   ```bash
   ss -l
   ```
2. Memory stats:
   ```bash
   ss -m
   ```
3. Filter state:
   ```bash
   ss state time-wait
   ```

## Related Commands
- `netstat` - Network stats
- `lsof` - List open files
- `ip` - IP utilities
- `nstat` - Network stats
- `sockstat` - Socket status

## Additional Resources
- [SS Manual](https://man7.org/linux/man-pages/man8/ss.8.html)
- [Network Guide](https://www.cyberciti.biz/files/ss.html)
- [System Administration](https://www.tecmint.com/ss-command-examples-in-linux/)

## Best Practices
1. Use filters
2. Check states
3. Monitor memory
4. Track processes
5. Document findings

## Security Considerations
1. Port exposure
2. Process verification
3. Connection states
4. Resource usage
5. Information exposure

## Troubleshooting
1. Connection issues
2. Memory problems
3. Process tracking
4. State transitions
5. Resource limits

## Filter Examples
1. By port:
   ```bash
   ss sport = :80
   ```
2. By address:
   ```bash
   ss dst 192.168.1.1
   ```
3. By state:
   ```bash
   ss state listening
   ```
