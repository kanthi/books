# netstat

## Overview
The `netstat` command displays network connections, routing tables, interface statistics, masquerade connections, and multicast memberships. It's a powerful tool for network troubleshooting and monitoring.

## Syntax
```bash
netstat [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Show all sockets |
| `-t` | Show TCP connections |
| `-u` | Show UDP connections |
| `-l` | Show only listening sockets |
| `-n` | Show numerical addresses |
| `-p` | Show process ID/name |
| `-r` | Show routing table |
| `-i` | Show interface statistics |
| `-s` | Show protocol statistics |

## Key Use Cases
1. Monitor network connections
2. Troubleshoot network issues
3. Check listening ports
4. View routing information
5. Analyze network statistics

## Examples with Explanations
### Example 1: List All Listening Ports
```bash
netstat -tuln
```
Shows TCP and UDP listening ports with numerical addresses

### Example 2: View Process Information
```bash
netstat -tulnp
```
Shows listening ports with associated processes

### Example 3: Check Routing Table
```bash
netstat -r
```
Displays kernel routing table

## Understanding Output
Connection states:
- LISTEN: Waiting for connections
- ESTABLISHED: Active connection
- TIME_WAIT: Closed but waiting
- CLOSE_WAIT: Remote end closed
- SYN_SENT: Actively connecting

Columns:
- Proto: Protocol (TCP/UDP)
- Local Address: Local end of socket
- Foreign Address: Remote end of socket
- State: Socket state
- PID/Program name: Process using socket

## Common Usage Patterns
1. Find listening services:
   ```bash
   netstat -tulnp | grep LISTEN
   ```
2. Check established connections:
   ```bash
   netstat -tun | grep ESTABLISHED
   ```
3. View interface statistics:
   ```bash
   netstat -i
   ```

## Performance Analysis
- Use `-c` for continuous output
- Combine with grep for specific info
- Consider using newer tools (ss)
- Monitor system resource usage
- Check for unusual connections

## Related Commands
- `ss` - Modern socket statistics
- `lsof` - List open files
- `tcpdump` - Packet analyzer
- `ip` - Show/manipulate routing
- `route` - Kernel routing table

## Additional Resources
- [Linux netstat manual](https://man7.org/linux/man-pages/man8/netstat.8.html)
- [Network Troubleshooting Guide](https://www.tecmint.com/20-netstat-commands-for-linux-network-management/)
