# id

## Overview
The `id` command displays user and group IDs for the current user or specified user. It provides detailed identity information including real, effective, and supplementary group memberships.

## Syntax
```bash
id [options] [user]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u` | Show only user ID |
| `-g` | Show only primary group ID |
| `-G` | Show all group IDs |
| `-n` | Show names instead of numbers |
| `-r` | Show real ID instead of effective |
| `-z` | Delimit entries with NUL |

## Key Use Cases
1. User identification
2. Permission troubleshooting
3. Security auditing
4. Group membership verification
5. Script access control

## Examples with Explanations
### Example 1: Basic Usage
```bash
id
```
Shows complete user and group information

### Example 2: Specific User
```bash
id username
```
Shows information for specified user

### Example 3: Numeric User ID
```bash
id -u
```
Returns only the numeric user ID

### Example 4: Group Names
```bash
id -Gn
```
Shows all group names user belongs to

## Understanding Output
Default output format:
```
uid=1000(user) gid=1000(user) groups=1000(user),4(adm),24(cdrom),27(sudo)
```

Components:
- **uid**: User ID and name
- **gid**: Primary group ID and name
- **groups**: All group memberships

## Common Usage Patterns
1. Root check:
   ```bash
   [ "$(id -u)" -eq 0 ] && echo "Running as root"
   ```
2. Group membership check:
   ```bash
   id -Gn | grep -q sudo && echo "User has sudo access"
   ```
3. User validation:
   ```bash
   if id "$username" >/dev/null 2>&1; then
       echo "User exists"
   fi
   ```

## Advanced Usage
1. Real vs effective ID:
   ```bash
   id -ru  # Real user ID
   id -u   # Effective user ID
   ```
2. All group information:
   ```bash
   id -G | tr ' ' '\n' | sort -n
   ```
3. Formatted output:
   ```bash
   printf "User: %s (UID: %d)\n" "$(id -un)" "$(id -u)"
   ```

## Performance Analysis
- Very fast operation
- No filesystem access needed
- Minimal system resources
- Good for frequent checks
- Efficient in scripts

## Related Commands
- `whoami` - Current username
- `groups` - Show group memberships
- `getent` - Get entries from databases
- `finger` - User information
- `w` - Show logged-in users

## Best Practices
1. Use numeric IDs for reliable comparisons
2. Check both user and group permissions
3. Handle non-existent users gracefully
4. Use appropriate options for specific needs
5. Consider real vs effective IDs

## Security Applications
1. Privilege escalation check:
   ```bash
   if [ "$(id -u)" -ne "$(id -ru)" ]; then
       echo "Running with elevated privileges"
   fi
   ```
2. Group-based access:
   ```bash
   if id -Gn | grep -q "admin"; then
       echo "Administrative access granted"
   fi
   ```

## Scripting Examples
1. User directory creation:
   ```bash
   USER_ID=$(id -u)
   USER_NAME=$(id -un)
   mkdir -p "/data/$USER_NAME"
   chown "$USER_ID" "/data/$USER_NAME"
   ```
2. Conditional execution:
   ```bash
   if [ "$(id -u)" -eq 0 ]; then
       systemctl restart service
   else
       echo "Root privileges required"
   fi
   ```

## Integration Examples
1. Logging with user info:
   ```bash
   echo "$(date): User $(id -un) ($(id -u)) executed command" >> audit.log
   ```
2. Permission validation:
   ```bash
   validate_user() {
       local required_group="$1"
       id -Gn | grep -q "$required_group" || {
           echo "Access denied: $required_group membership required"
           exit 1
       }
   }
   ```

## Troubleshooting
1. User not found errors
2. Permission denied issues
3. Group membership problems
4. Effective vs real ID confusion
5. Numeric vs name resolution