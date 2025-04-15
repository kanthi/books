# traceroute

## Overview
The `traceroute` command prints the route packets trace to a network host. It shows the path and measuring transit delays of packets.

## Syntax
```bash
traceroute [options] host [packetlen]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-4` | IPv4 only |
| `-6` | IPv6 only |
| `-f first_ttl` | Start from hop |
| `-m max_ttl` | Maximum hops |
| `-n` | Don't resolve names |
| `-p port` | Destination port |
| `-w waittime` | Wait time for response |
| `-q nqueries` | Number of probes |
| `-I` | Use ICMP probes |
| `-T` | Use TCP probes |
| `-U` | Use UDP probes |

## Key Use Cases
1. Route discovery
2. Network troubleshooting
3. Latency analysis
4. Path verification
5. Network mapping

## Examples with Explanations
### Example 1: Basic Usage
```bash
traceroute google.com
```
Trace route to Google

### Example 2: No DNS
```bash
traceroute -n 8.8.8.8
```
Numeric output only

### Example 3: TCP Mode
```bash
traceroute -T -p 80 website.com
```
TCP traceroute to port 80

## Understanding Output
Example output:
```
 1  192.168.1.1  1.123 ms  0.893 ms  0.932 ms
 2  10.0.0.1     5.342 ms  5.876 ms  5.123 ms
```
Components:
- Hop number
- Router address
- Response times (3 probes)

## Common Usage Patterns
1. Basic trace:
   ```bash
   traceroute hostname
   ```
2. Maximum hops:
   ```bash
   traceroute -m 15 hostname
   ```
3. Fast trace:
   ```bash
   traceroute -n -q 1 hostname
   ```

## Performance Analysis
- Path length
- Response times
- Packet loss
- Route stability
- Network bottlenecks

## Related Commands
- `ping` - Test connectivity
- `mtr` - Network diagnostic
- `route` - Route table
- `ip route` - IP routing
- `netstat` - Network statistics

## Additional Resources
- [Traceroute Manual](https://man7.org/linux/man-pages/man8/traceroute.8.html)
- [Network Troubleshooting](https://www.cyberciti.biz/faq/unix-linux-traceroute-command-examples/)
- [Route Analysis](https://www.networkworld.com/article/2696448/network-security-traceroute-tutorial.html)

## Best Practices
1. Use appropriate protocol
2. Consider timeouts
3. Document results
4. Regular testing
5. Compare paths

## Troubleshooting
1. Timeouts
2. Path changes
3. High latency
4. Packet loss
5. Route loops

## Protocol Options
1. UDP (default)
2. ICMP
3. TCP
4. Custom ports
5. Packet sizes
