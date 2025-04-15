# nslookup

## Overview
The `nslookup` command queries Internet name servers for DNS (Domain Name System) information. It's used for diagnosing DNS problems and verifying DNS records.

## Syntax
```bash
nslookup [options] [hostname|IP] [server]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-type=a` | Address record |
| `-type=aaaa` | IPv6 address |
| `-type=mx` | Mail server |
| `-type=ns` | Name server |
| `-type=soa` | Start of authority |
| `-type=txt` | Text record |
| `-type=ptr` | Pointer record |
| `-type=cname` | Canonical name |
| `-debug` | Debug mode |
| `-port=N` | Server port |
| `-timeout=N` | Query timeout |
| `-query=type` | Set query type |

## Key Use Cases
1. DNS troubleshooting
2. Record verification
3. Mail server lookup
4. Reverse DNS
5. Domain validation

## Examples with Explanations
### Example 1: Basic Lookup
```bash
nslookup google.com
```
Look up IP address

### Example 2: Mail Servers
```bash
nslookup -type=mx domain.com
```
Find mail servers

### Example 3: Name Servers
```bash
nslookup -type=ns domain.com
```
Find name servers

## Understanding Output
Example output:
```
Server:   192.168.1.1
Address:  192.168.1.1#53

Name:     google.com
Address:  172.217.167.78
```
Components:
- DNS server used
- Query result
- Record details

## Common Usage Patterns
1. Address lookup:
   ```bash
   nslookup hostname
   ```
2. Reverse lookup:
   ```bash
   nslookup IP_address
   ```
3. Specific server:
   ```bash
   nslookup domain.com 8.8.8.8
   ```

## Performance Analysis
- Response time
- Record availability
- Server reliability
- Cache effects
- Resolution chain

## Related Commands
- `dig` - DNS lookup
- `host` - DNS lookup
- `whois` - Domain info
- `ping` - Network test
- `traceroute` - Route trace

## Additional Resources
- [Nslookup Manual](https://man7.org/linux/man-pages/man1/nslookup.1.html)
- [DNS Guide](https://www.cyberciti.biz/faq/unix-linux-dns-lookup-command/)
- [DNS Troubleshooting](https://www.cloudflare.com/learning/dns/what-is-dns/)

## Best Practices
1. Verify multiple servers
2. Check all record types
3. Document results
4. Regular testing
5. Compare responses

## Troubleshooting
1. Resolution failures
2. Timeout issues
3. Server problems
4. Cache issues
5. Record conflicts

## Record Types
1. A (Address)
2. AAAA (IPv6)
3. MX (Mail)
4. NS (Nameserver)
5. CNAME (Alias)
