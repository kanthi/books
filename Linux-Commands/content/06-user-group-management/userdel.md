# userdel

## Overview
The `userdel` command deletes a user account and related files. It removes the user from the system, optionally including their home directory and mail spool.

## Syntax
```bash
userdel [options] LOGIN
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f, --force` | Force removal |
| `-r, --remove` | Remove home directory and mail spool |
| `-Z, --selinux-user` | Remove SELinux user mapping |
| `-h, --help` | Display help |
| `--version` | Show version |

## Key Use Cases
1. User removal
2. System cleanup
3. Security maintenance
4. Account management
5. Resource recovery

## Examples with Explanations
### Example 1: Basic Usage
```bash
userdel username
```
Delete user account

### Example 2: Remove Home
```bash
userdel -r username
```
Delete user and home directory

### Example 3: Force Removal
```bash
userdel -f username
```
Force user deletion

## Understanding Output
- No output on success
- Error messages for:
  - User not found
  - Permission denied
  - Process running
  - Resource busy

## Common Usage Patterns
1. Safe removal:
   ```bash
   userdel -r username
   ```
2. Force deletion:
   ```bash
   userdel -f -r username
   ```
3. Check before delete:
   ```bash
   id username && userdel username
   ```

## Security Considerations
1. Data backup
2. Process termination
3. File ownership
4. Group membership
5. Access removal

## Related Commands
- `useradd` - Create users
- `usermod` - Modify users
- `passwd` - Change password
- `groupdel` - Delete groups
- `chage` - Change age info

## Additional Resources
- [Userdel Manual](https://man7.org/linux/man-pages/man8/userdel.8.html)
- [User Management Guide](https://www.tecmint.com/userdel-command-examples/)
- [System Security](https://www.cyberciti.biz/tips/linux-security.html)

## Best Practices
1. Backup user data
2. Check running processes
3. Verify group memberships
4. Document removal
5. Regular audits

## Cleanup Tasks
1. Home directory
2. Mail spool
3. Cron jobs
4. Print jobs
5. System files

## Safety Checks
1. Active processes
2. Owned files
3. Running services
4. Scheduled tasks
5. System dependencies
