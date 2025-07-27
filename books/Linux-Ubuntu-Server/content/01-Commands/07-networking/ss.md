# ss

## Overview
The `ss` command is a utility to investigate sockets. It's a modern replacement for netstat, providing detailed information about network connections.

## Syntax
```bash
ss [options] [filter]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Don't resolve names |
| `-r` | Resolve names |
| `-a` | All sockets |
| `-l` | Listening sockets |
| `-p` | Show processes |
| `-t` | TCP sockets |
| `-u` | UDP sockets |
| `-w` | RAW sockets |
| `-x` | Unix sockets |
| `-4` | IPv4 only |
| `-6` | IPv6 only |
| `-i` | Show TCP internal info |
| `-s` | Summary statistics |

## Key Use Cases
1. Network monitoring
2. Connection tracking
3. Socket analysis
4. Performance tuning
5. Troubleshooting

## Examples with Explanations
### Example 1: List Connections
```bash
ss -tuln
```
Show TCP/UDP listening ports

### Example 2: Process Info
```bash
ss -tulnp
```
Show processes using sockets

### Example 3: Connection Stats
```bash
ss -s
```
Show socket statistics

## Understanding Output
Connection state flags:
- LISTEN: Listening for connections
- ESTAB: Established connection
- TIME-WAIT: Connection terminating
- CLOSE-WAIT: Remote end closed
- SYN-SENT: Connection attempt
- FIN-WAIT: Socket closed

## Common Usage Patterns
1. Monitor TCP connections:
   ```bash
   ss -tan state established
   ```
2. Check specific port:
   ```bash
   ss -tulnp sport = :80
   ```
3. Memory usage:
   ```bash
   ss -m
   ```

## Performance Analysis
- Connection states
- Memory usage
- Buffer sizes
- Queue lengths
- Timing information

## Related Commands
- `netstat` - Network statistics
- `lsof` - List open files
- `ip` - IP utilities
- `tcpdump` - Packet analyzer
- `nmap` - Network scanner

## Additional Resources
- [SS Manual](https://man7.org/linux/man-pages/man8/ss.8.html)
- [Network Monitoring Guide](https://www.cyberciti.biz/tips/linux-investigate-sockets-network-connections.html)
- [Socket Programming](https://beej.us/guide/bgnet/)

## Best Practices
1. Regular monitoring
2. Performance baselines
3. Security checks
4. Documentation
5. Alert thresholds

## Troubleshooting
1. Connection issues
2. Port conflicts
3. Memory problems
4. Process identification
5. Network bottlenecks

## Socket States
1. Established
2. Listen
3. Time Wait
4. Close Wait
5. Syn Sent
