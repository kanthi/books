# whoami

## Overview
The `whoami` command prints the effective username of the current user. It's a simple but essential command for user identification in scripts and system administration.

## Syntax
```bash
whoami
```

## Key Use Cases
1. User identification in scripts
2. Security verification
3. System administration
4. Access control checks
5. Logging and auditing

## Examples with Explanations
### Example 1: Basic Usage
```bash
whoami
```
Returns the current username

### Example 2: Script Usage
```bash
if [ "$(whoami)" != "root" ]; then
    echo "This script must be run as root"
    exit 1
fi
```

## Common Usage Patterns
1. Root check:
   ```bash
   [ "$(whoami)" = "root" ] && echo "Running as root"
   ```
2. User-specific paths:
   ```bash
   USER=$(whoami)
   CONFIG_DIR="/home/$USER/.config"
   ```
3. Logging:
   ```bash
   echo "$(date): $(whoami) executed script" >> audit.log
   ```

## Related Commands
- `id` - Show user and group IDs
- `who` - Show logged-in users
- `w` - Show who is logged on
- `logname` - Print login name
- `users` - Show current users

## Best Practices
1. Use in security-sensitive scripts
2. Combine with conditional statements
3. Consider using `id -u` for numeric UID
4. Use for user-specific configurations
5. Include in audit trails

## Integration Examples
1. Backup script:
   ```bash
   BACKUP_DIR="/backups/$(whoami)"
   mkdir -p "$BACKUP_DIR"
   ```
2. Temporary files:
   ```bash
   TEMP_FILE="/tmp/$(whoami)_$$_temp"
   ```
3. Permission check:
   ```bash
   if [ "$(whoami)" != "admin" ]; then
       echo "Access denied"
       exit 1
   fi
   ```

## Security Considerations
- Shows effective user, not real user
- Can be different in sudo context
- Use `logname` for original login name
- Consider `id` for more detailed info