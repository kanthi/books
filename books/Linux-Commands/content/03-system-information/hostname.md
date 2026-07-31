# hostname

## Overview
The `hostname` command shows or sets the system's host name. It displays the name by which the system is known on a network.

## Syntax
```bash
hostname [options] [hostname]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Alias names |
| `-A` | All FQDNs |
| `-d` | DNS domain |
| `-f` | FQDN name |
| `-i` | IP addresses |
| `-I` | All addresses |
| `-s` | Short name |
| `-y` | NIS domain |
| `--help` | Show help |
| `--version` | Show version |

## Output Types
| Type | Description |
|------|-------------|
| Short | Simple hostname |
| FQDN | Full domain name |
| Domain | DNS domain |
| IP | IP addresses |
| Alias | Alternative names |

## Key Use Cases
1. System identification
2. Network configuration
3. DNS setup
4. Host verification
5. Network troubleshooting

## Examples with Explanations
### Example 1: Show Name
```bash
hostname
```
Display hostname

### Example 2: Show FQDN
```bash
hostname -f
```
Full domain name

### Example 3: Show IPs
```bash
hostname -I
```
All IP addresses

## Common Usage Patterns
1. Basic check:
   ```bash
   hostname
   ```
2. Network info:
   ```bash
   hostname -i
   ```
3. Domain name:
   ```bash
   hostname -d
   ```

## Network Information
1. Host name
2. Domain name
3. IP addresses
4. Alias names
5. Network identity

## Related Commands
- `uname` - System info
- `domainname` - NIS domain
- `dnsdomainname` - DNS domain
- `hostnamectl` - Control hostname
- `host` - DNS lookup

## Additional Resources
- [Hostname Manual](https://man7.org/linux/man-pages/man1/hostname.1.html)
- [Network Guide](https://www.cyberciti.biz/faq/linux-hostname-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-hostname-command-examples/)

## Best Practices
1. Proper naming
2. DNS alignment
3. Network consistency
4. Documentation
5. Regular verification

## Network Analysis
1. Name resolution
2. IP configuration
3. Domain setup
4. Network identity
5. System naming

## Troubleshooting
1. Name resolution
2. DNS issues
3. Network problems
4. Configuration errors
5. Identity conflicts

## Common Uses
1. System setup
2. Network config
3. DNS management
4. Identity verification
5. Documentation
