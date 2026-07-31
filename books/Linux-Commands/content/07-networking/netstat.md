# netstat

## Overview
The `netstat` command displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships.

## Syntax
```bash
netstat [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | All connections |
| `-n` | Numeric addresses |
| `-p` | Show PID/Program |
| `-t` | TCP connections |
| `-u` | UDP connections |
| `-l` | Listening sockets |
| `-i` | Interface stats |
| `-r` | Routing table |
| `-s` | Protocol stats |
| `-c` | Continuous output |
| `-e` | Extended info |
| `-v` | Verbose mode |

## Connection States
| State | Description |
|-------|-------------|
| LISTEN | Waiting for connection |
| SYN_SENT | Active open |
| SYN_RECV | Passive open |
| ESTABLISHED | Connection ok |
| FIN_WAIT1 | Closing |
| FIN_WAIT2 | Closing |
| TIME_WAIT | 2MSL wait |
| CLOSED | Socket is free |
| CLOSE_WAIT | Remote closed |
| LAST_ACK | Closing |

## Key Use Cases
1. Connection monitoring
2. Port scanning
3. Process tracking
4. Network debugging
5. Security auditing

## Examples with Explanations
### Example 1: Active Connections
```bash
netstat -tuln
```
Show TCP/UDP listeners

### Example 2: Process Info
```bash
netstat -tp
```
Show with program names

### Example 3: Route Table
```bash
netstat -r
```
Show routing table

## Common Usage Patterns
1. Check listeners:
   ```bash
   netstat -an | grep LISTEN
   ```
2. Process ports:
   ```bash
   netstat -tulpn
   ```
3. Interface stats:
   ```bash
   netstat -i
   ```

## Related Commands
- `ss` - Socket statistics
- `lsof` - List open files
- `ip` - IP utilities
- `route` - Routing table
- `iptables` - Firewall rules

## Additional Resources
- [Netstat Manual](https://linux.die.net/man/8/netstat)
- [Network Guide](https://www.cyberciti.biz/faq/linux-netstat-command-examples/)
- [System Administration](https://www.tecmint.com/linux-netstat-command-examples/)

## Best Practices
1. Use specific filters
2. Check permissions
3. Regular monitoring
4. Document findings
5. Compare states

## Security Considerations
1. Port exposure
2. Connection states
3. Process verification
4. Network mapping
5. Information leakage

## Troubleshooting
1. Connection issues
2. Port conflicts
3. Process problems
4. Routing errors
5. Interface status

## Common Output Fields
1. Protocol
2. Local address
3. Foreign address
4. State
5. PID/Program name
