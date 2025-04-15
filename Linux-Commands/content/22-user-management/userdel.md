# userdel

## Overview
The `userdel` command deletes a user account and related files. It removes the user from the system, optionally including their home directory and mail spool.

## Syntax
```bash
userdel [options] login
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f` | Force removal |
| `-r` | Remove home dir |
| `-Z` | Remove SELinux |
| `--help` | Show help |
| `--version` | Show version |

## Affected Files
| File | Description |
|------|-------------|
| /etc/passwd | User accounts |
| /etc/shadow | Secure accounts |
| /etc/group | Group accounts |
| /home/user | Home directory |
| /var/mail/user | Mail spool |
| /var/spool/mail/user | Mail directory |

## Key Use Cases
1. Account removal
2. System cleanup
3. Security management
4. Directory cleanup
5. User management

## Examples with Explanations
### Example 1: Basic Remove
```bash
userdel username
```
Remove user account

### Example 2: Full Remove
```bash
userdel -r username
```
Remove with home directory

### Example 3: Force Remove
```bash
userdel -f username
```
Force user removal

## Common Usage Patterns
1. Simple delete:
   ```bash
   userdel user
   ```
2. Complete removal:
   ```bash
   userdel -r user
   ```
3. Force cleanup:
   ```bash
   userdel -f -r user
   ```

## Security Considerations
1. Data removal
2. File ownership
3. Group access
4. System security
5. Backup importance

## Related Commands
- `useradd` - Add user
- `usermod` - Modify user
- `groupdel` - Delete group
- `passwd` - Password
- `chage` - Account aging

## Additional Resources
- [Userdel Manual](https://man7.org/linux/man-pages/man8/userdel.8.html)
- [User Guide](https://www.cyberciti.biz/faq/linux-userdel-command-examples-syntax-usage/)
- [System Administration](https://www.tecmint.com/linux-userdel-command-examples/)

## Best Practices
1. Backup data
2. Check processes
3. Verify ownership
4. Document removal
5. Test completion

## User Management
1. Account removal
2. Data cleanup
3. Group handling
4. Security update
5. System cleanup

## Troubleshooting
1. Permission denied
2. Process running
3. File ownership
4. Group membership
5. Directory issues

## Common Issues
1. Active processes
2. File permissions
3. Group ownership
4. System files
5. Mail spools
