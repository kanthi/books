# tcpdump

## Overview
The `tcpdump` command is a packet analyzer that captures and displays the contents of network packets on a network interface.

## Syntax
```bash
tcpdump [options] [expression]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i interface` | Interface |
| `-n` | Don't resolve |
| `-nn` | Don't resolve (more) |
| `-v` | Verbose output |
| `-vv` | More verbose |
| `-c count` | Packet count |
| `-w file` | Write to file |
| `-r file` | Read from file |
| `-A` | ASCII output |
| `-X` | Hex and ASCII |
| `-s snaplen` | Packet length |
| `-q` | Quick output |
| `-t` | No timestamps |

## Expression Primitives
| Type | Example |
|------|---------|
| Type | host, net, port |
| Dir | src, dst |
| Proto | tcp, udp, icmp |
| Operators | and, or, not |

## Key Use Cases
1. Network debugging
2. Traffic analysis
3. Security monitoring
4. Protocol inspection
5. Performance tuning

## Examples with Explanations
### Example 1: Basic Capture
```bash
tcpdump -i eth0
```
Capture on interface

### Example 2: Write to File
```bash
tcpdump -w capture.pcap
```
Save capture to file

### Example 3: Filter Traffic
```bash
tcpdump port 80
```
Capture HTTP traffic

## Common Usage Patterns
1. Host traffic:
   ```bash
   tcpdump host 192.168.1.1
   ```
2. Port traffic:
   ```bash
   tcpdump port 443
   ```
3. Protocol:
   ```bash
   tcpdump tcp
   ```

## Output Fields
1. Timestamp
2. Protocol
3. Source address
4. Destination address
5. Flags and data

## Related Commands
- `wireshark` - GUI analyzer
- `nmap` - Port scanner
- `netstat` - Network stats
- `ss` - Socket stats
- `iftop` - Bandwidth usage

## Additional Resources
- [Tcpdump Manual](https://www.tcpdump.org/manpages/tcpdump.1.html)
- [Packet Analysis](https://danielmiessler.com/study/tcpdump/)
- [System Administration](https://www.tecmint.com/linux-tcpdump-command/)

## Best Practices
1. Use snaplen
2. Filter traffic
3. Write to file
4. Check permissions
5. Monitor impact

## Security Considerations
1. Root access
2. Data exposure
3. Network impact
4. Storage space
5. Sensitive data

## Troubleshooting
1. Permission denied
2. Interface issues
3. Filter syntax
4. File size
5. Performance impact

## Filter Examples
1. TCP flags:
   ```bash
   tcpdump 'tcp[tcpflags] & tcp-syn != 0'
   ```
2. IP range:
   ```bash
   tcpdump net 192.168.1.0/24
   ```
3. Port range:
   ```bash
   tcpdump portrange 21-23
   ```
