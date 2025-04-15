# nmap

## Overview
The `nmap` (Network Mapper) command is a security scanner used to discover hosts and services on a computer network, creating a map of the network.

## Syntax
```bash
nmap [options] target
```

## Common Options
| Option | Description |
|--------|-------------|
| `-sS` | TCP SYN scan |
| `-sT` | TCP connect scan |
| `-sU` | UDP scan |
| `-sP` | Ping scan |
| `-p ports` | Port range |
| `-F` | Fast scan |
| `-v` | Verbose output |
| `-A` | Aggressive scan |
| `-O` | OS detection |
| `-sV` | Version detection |
| `-T0-5` | Timing template |
| `-oN file` | Normal output |

## Scan Types
| Type | Description |
|------|-------------|
| TCP SYN | Stealth scan |
| TCP Connect | Full connect |
| UDP | UDP ports |
| FIN | FIN flag set |
| XMAS | FIN,PSH,URG |
| NULL | No flags set |
| ACK | ACK flag only |
| Window | Window scan |
| Maimon | FIN/ACK probe |

## Key Use Cases
1. Network discovery
2. Port scanning
3. Service detection
4. OS fingerprinting
5. Security auditing

## Examples with Explanations
### Example 1: Basic Scan
```bash
nmap 192.168.1.1
```
Scan single host

### Example 2: Network Scan
```bash
nmap 192.168.1.0/24
```
Scan network range

### Example 3: Service Detection
```bash
nmap -sV target
```
Detect service versions

## Common Usage Patterns
1. Quick scan:
   ```bash
   nmap -F target
   ```
2. Comprehensive:
   ```bash
   nmap -A target
   ```
3. Port range:
   ```bash
   nmap -p 1-100 target
   ```

## Security Considerations
1. Permission requirements
2. Network impact
3. Detection risk
4. Legal implications
5. Resource usage

## Related Commands
- `netstat` - Network stats
- `ss` - Socket stats
- `ping` - Network test
- `traceroute` - Route trace
- `tcpdump` - Packet capture

## Additional Resources
- [Nmap Manual](https://nmap.org/book/man.html)
- [Security Guide](https://nmap.org/docs.html)
- [System Administration](https://www.tecmint.com/nmap-command-examples/)

## Best Practices
1. Permission check
2. Timing control
3. Output logging
4. Target verification
5. Regular audits

## Output Formats
1. Normal (-oN)
2. XML (-oX)
3. Grepable (-oG)
4. Script kiddie (-oS)
5. All formats (-oA)

## Troubleshooting
1. Access denied
2. Timeouts
3. False positives
4. Rate limiting
5. Firewall blocks

## NSE Scripts
1. Default
2. Discovery
3. Safe
4. Intrusive
5. All
