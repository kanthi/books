# dig

## Overview
The `dig` (Domain Information Groper) command is a flexible tool for interrogating DNS name servers. It performs DNS lookups and displays the answers from the name servers.

## Syntax
```bash
dig [@server] [name] [type] [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `+short` | Short answer |
| `+noall` | Set all display flags off |
| `+answer` | Display answer section |
| `+norecurse` | Turn off recursive processing |
| `+trace` | Trace delegation path |
| `+noquestion` | Don't show question section |
| `+nocmd` | Don't show command line |
| `+nocomments` | Don't show comment lines |
| `-t type` | Set query type |
| `-x addr` | Reverse lookup |
| `-p port` | Port number |
| `-4` | IPv4 query |
| `-6` | IPv6 query |

## Key Use Cases
1. DNS troubleshooting
2. Record verification
3. DNS propagation
4. DNSSEC validation
5. Zone transfers

## Examples with Explanations
### Example 1: Basic Query
```bash
dig google.com
```
Look up A records

### Example 2: Specific Record
```bash
dig domain.com MX
```
Look up mail servers

### Example 3: Trace Path
```bash
dig +trace domain.com
```
Show resolution path

## Understanding Output
Sections in output:
1. Header (status, flags)
2. Question section
3. Answer section
4. Authority section
5. Additional section

## Common Usage Patterns
1. Short output:
   ```bash
   dig +short domain.com
   ```
2. Reverse lookup:
   ```bash
   dig -x IP_address
   ```
3. Specific server:
   ```bash
   dig @8.8.8.8 domain.com
   ```

## Performance Analysis
- Query time
- Server response
- Resolution path
- DNSSEC validation
- Answer completeness

## Related Commands
- `nslookup` - Name server lookup
- `host` - DNS lookup
- `whois` - Domain info
- `ping` - Network test
- `traceroute` - Route trace

## Additional Resources
- [Dig Manual](https://man7.org/linux/man-pages/man1/dig.1.html)
- [DNS Tools Guide](https://www.cyberciti.biz/faq/linux-unix-dig-command-examples-usage-syntax/)
- [DNSSEC Guide](https://www.cloudflare.com/dns/dnssec/how-dnssec-works/)

## Best Practices
1. Use specific queries
2. Verify multiple servers
3. Check DNSSEC
4. Document results
5. Compare responses

## Troubleshooting
1. Resolution failures
2. DNSSEC issues
3. Propagation delays
4. Server problems
5. Zone transfers

## Query Types
1. A (IPv4 address)
2. AAAA (IPv6 address)
3. MX (Mail exchange)
4. NS (Name server)
5. SOA (Start of authority)
