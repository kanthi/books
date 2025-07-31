# who

## Overview
The `who` command displays information about users currently logged into the system, including login time, terminal, and remote host information.

## Syntax
```bash
who [options] [file | arg1 arg2]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | All information |
| `-b` | Time of last system boot |
| `-d` | Dead processes |
| `-H` | Print column headings |
| `-l` | Login processes |
| `-q` | Quick mode (names and count only) |
| `-r` | Current runlevel |
| `-t` | System clock changes |
| `-u` | Idle time for each user |
| `-w` | User's message status |

## Key Use Cases
1. Monitor logged-in users
2. System administration
3. Security auditing
4. Session management
5. System status checking

## Examples with Explanations
### Example 1: Basic Usage
```bash
who
```
Shows currently logged-in users

### Example 2: All Information
```bash
who -a
```
Displays comprehensive system and user information

### Example 3: With Headers
```bash
who -H
```
Shows output with column headers

### Example 4: Boot Time
```bash
who -b
```
Shows when system was last booted

## Understanding Output
Default output columns:
- **Username**: Login name
- **Terminal**: TTY or pts device
- **Login time**: When user logged in
- **Remote host**: Where user connected from (if remote)

Example output:
```
user1    pts/0    2024-01-15 09:30 (192.168.1.100)
user2    tty1     2024-01-15 08:15
```

## Common Usage Patterns
1. Count logged-in users:
   ```bash
   who | wc -l
   ```
2. Check specific user:
   ```bash
   who | grep username
   ```
3. Monitor remote connections:
   ```bash
   who | grep -E '\([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+\)'
   ```

## Advanced Usage
1. Show idle time:
   ```bash
   who -u
   ```
2. Quick user count:
   ```bash
   who -q
   ```
3. System information:
   ```bash
   who -r  # Runlevel
   who -b  # Boot time
   ```

## System Information
Special options for system status:
- `-b`: Boot time
- `-r`: Current runlevel
- `-t`: Clock changes
- `-d`: Dead processes
- `-l`: Login processes

## Performance Analysis
- Fast operation
- Reads from /var/run/utmp
- Minimal resource usage
- Real-time information
- Good for monitoring scripts

## Related Commands
- `w` - More detailed user information
- `users` - Simple list of usernames
- `last` - Login history
- `finger` - User information
- `ps` - Process information

## Best Practices
1. Use for security monitoring
2. Combine with other system tools
3. Regular auditing of user sessions
4. Monitor remote connections
5. Check system boot time

## Security Applications
1. Monitor unauthorized access:
   ```bash
   who | grep -v "$(whoami)" | mail -s "Other users logged in" admin@domain.com
   ```
2. Remote connection audit:
   ```bash
   who | awk '$4 ~ /\(/ {print $1, $4}' > remote_logins.log
   ```

## Scripting Examples
1. User session monitoring:
   ```bash
   #!/bin/bash
   while true; do
       echo "$(date): $(who | wc -l) users logged in"
       sleep 300
   done
   ```
2. Alert on new logins:
   ```bash
   CURRENT_USERS=$(who | wc -l)
   if [ "$CURRENT_USERS" -gt "$EXPECTED_USERS" ]; then
       echo "Alert: More users than expected"
   fi
   ```

## Integration Examples
1. System status report:
   ```bash
   echo "System Status Report"
   echo "Boot time: $(who -b)"
   echo "Current users: $(who -q)"
   echo "Runlevel: $(who -r)"
   ```
2. Login monitoring:
   ```bash
   who -H | while read user tty time rest; do
       echo "User $user on $tty since $time"
   done
   ```

## File Sources
The `who` command reads from:
- `/var/run/utmp` - Current sessions
- `/var/log/wtmp` - Login history (with file argument)

## Output Formatting
1. Custom format with awk:
   ```bash
   who | awk '{print $1 ": " $3 " " $4}'
   ```
2. JSON-like output:
   ```bash
   who | awk '{printf "{\"user\":\"%s\",\"tty\":\"%s\",\"time\":\"%s %s\"}\n", $1, $2, $3, $4}'
   ```

## Troubleshooting
1. Empty output (no users logged in)
2. Permission issues with utmp files
3. Stale session information
4. Network connectivity for remote hosts
5. Time zone display issues