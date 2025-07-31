# telnet

## Overview
The `telnet` command is a network protocol client used to connect to remote hosts via the Telnet protocol. While primarily used for remote login historically, it's now mainly used for testing network connectivity and services.

## Syntax
```bash
telnet [options] [host [port]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-4` | Force IPv4 |
| `-6` | Force IPv6 |
| `-8` | 8-bit data path |
| `-E` | Disable escape character |
| `-K` | No automatic login |
| `-L` | 8-bit data path |
| `-a` | Automatic login |
| `-d` | Debug mode |
| `-e char` | Set escape character |
| `-l user` | Automatic login username |
| `-n file` | Record network trace |
| `-r` | Rlogin-style interface |

## Key Use Cases
1. Test network connectivity
2. Debug network services
3. Test port accessibility
4. Protocol testing
5. Network troubleshooting

## Examples with Explanations
### Example 1: Test Web Server
```bash
telnet google.com 80
```
Tests HTTP port connectivity to Google

### Example 2: Test SMTP Server
```bash
telnet mail.example.com 25
```
Tests SMTP server connectivity

### Example 3: Test SSH Port
```bash
telnet server.example.com 22
```
Tests if SSH port is open

### Example 4: Local Service Test
```bash
telnet localhost 3306
```
Tests local MySQL server connectivity

## Network Testing
Common ports to test:
- **22**: SSH
- **23**: Telnet
- **25**: SMTP
- **53**: DNS
- **80**: HTTP
- **110**: POP3
- **143**: IMAP
- **443**: HTTPS
- **993**: IMAPS
- **995**: POP3S

## Interactive Commands
Once connected, telnet commands:
- `Ctrl+]`: Enter command mode
- `quit`: Exit telnet
- `close`: Close connection
- `open host port`: Open new connection
- `status`: Show connection status
- `set`: Set options
- `unset`: Unset options

## Common Usage Patterns
1. Quick connectivity test:
   ```bash
   telnet host port && echo "Port is open"
   ```
2. HTTP request test:
   ```bash
   telnet www.example.com 80
   GET / HTTP/1.1
   Host: www.example.com
   ```
3. SMTP test:
   ```bash
   telnet mail.server.com 25
   HELO test.com
   ```

## Protocol Testing
1. HTTP testing:
   ```bash
   telnet example.com 80
   GET /index.html HTTP/1.1
   Host: example.com
   Connection: close
   ```
2. SMTP testing:
   ```bash
   telnet smtp.server.com 25
   EHLO client.com
   MAIL FROM: test@client.com
   RCPT TO: user@server.com
   ```

## Security Considerations
1. Unencrypted protocol
2. Credentials sent in plain text
3. Use SSH instead for remote access
4. Only for testing purposes
5. Firewall implications

## Related Commands
- `ssh` - Secure shell
- `nc` (netcat) - Network utility
- `nmap` - Network scanner
- `curl` - HTTP client
- `wget` - Web downloader

## Best Practices
1. Use only for testing
2. Prefer SSH for remote access
3. Test specific services
4. Understand protocol basics
5. Use appropriate alternatives

## Network Troubleshooting
1. Test port accessibility:
   ```bash
   timeout 5 telnet host port
   ```
2. Check service response:
   ```bash
   echo "GET /" | telnet host 80
   ```
3. Verify firewall rules:
   ```bash
   telnet internal.server 8080
   ```

## Scripting Applications
1. Port availability check:
   ```bash
   #!/bin/bash
   check_port() {
       local host=$1
       local port=$2
       timeout 3 telnet "$host" "$port" </dev/null &>/dev/null
       if [ $? -eq 0 ]; then
           echo "Port $port on $host is open"
       else
           echo "Port $port on $host is closed"
       fi
   }
   ```
2. Service monitoring:
   ```bash
   while true; do
       if ! timeout 3 telnet localhost 80 </dev/null &>/dev/null; then
           echo "Web server down at $(date)"
           # Restart service
       fi
       sleep 60
   done
   ```

## Alternative Tools
For modern usage, consider:
- `nc` (netcat): More versatile
- `nmap`: Port scanning
- `curl`: HTTP testing
- `ssh`: Secure remote access
- `socat`: Advanced networking

## Integration Examples
1. Health check script:
   ```bash
   services=("web:80" "db:3306" "cache:6379")
   for service in "${services[@]}"; do
       host=${service%:*}
       port=${service#*:}
       timeout 2 telnet "$host" "$port" </dev/null &>/dev/null || \
           echo "Service $service is down"
   done
   ```
2. Network diagnostics:
   ```bash
   echo "Testing network connectivity..."
   telnet 8.8.8.8 53 </dev/null &>/dev/null && echo "DNS reachable"
   telnet google.com 80 </dev/null &>/dev/null && echo "HTTP reachable"
   ```

## Troubleshooting
1. Connection refused errors
2. Timeout issues
3. Firewall blocking
4. Service not running
5. Network connectivity problems

## Modern Alternatives
Instead of telnet, use:
1. `nc -zv host port` - Port testing
2. `curl -I http://host` - HTTP testing
3. `ssh user@host` - Secure remote access
4. `nmap -p port host` - Port scanning
5. `openssl s_client -connect host:port` - SSL testing