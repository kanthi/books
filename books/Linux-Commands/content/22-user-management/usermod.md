# usermod

## Overview
The `usermod` command modifies a user account. It changes various attributes of user accounts including group membership, home directory, and shell.

## Syntax
```bash
usermod [options] login
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Add to groups |
| `-c comment` | Comment field |
| `-d home_dir` | Home directory |
| `-e expire_date` | Account expiry |
| `-f inactive` | Inactivity period |
| `-g group` | Primary group |
| `-G groups` | Secondary groups |
| `-l login_name` | New username |
| `-L` | Lock account |
| `-m` | Move home |
| `-s shell` | Login shell |
| `-u uid` | User ID |
| `-U` | Unlock account |

## Configuration Files
| File | Description |
|------|-------------|
| /etc/passwd | User accounts |
| /etc/shadow | Secure accounts |
| /etc/group | Group accounts |
| /etc/login.defs | System defaults |
| /etc/skel/ | Skeleton files |

## Key Use Cases
1. Account modification
2. Group management
3. Security control
4. Shell changes
5. Directory management

## Examples with Explanations
### Example 1: Add Group
```bash
usermod -aG wheel username
```
Add to wheel group

### Example 2: Change Shell
```bash
usermod -s /bin/bash username
```
Change login shell

### Example 3: Lock Account
```bash
usermod -L username
```
Lock user account

## Common Usage Patterns
1. Group addition:
   ```bash
   usermod -aG group user
   ```
2. Home directory:
   ```bash
   usermod -d /new/home -m user
   ```
3. Account lock:
   ```bash
   usermod -L user
   ```

## Security Considerations
1. Account access
2. Group permissions
3. Shell security
4. Directory rights
5. Password policy

## Related Commands
- `useradd` - Add user
- `userdel` - Delete user
- `passwd` - Set password
- `groupmod` - Modify group
- `chage` - Age information

## Additional Resources
- [Usermod Manual](https://man7.org/linux/man-pages/man8/usermod.8.html)
- [User Guide](https://www.cyberciti.biz/faq/linux-usermod-command-examples-syntax-usage/)
- [System Administration](https://www.tecmint.com/linux-usermod-command-examples/)

## Best Practices
1. Backup before changes
2. Check permissions
3. Verify groups
4. Document changes
5. Test access

## User Management
1. Account updates
2. Group changes
3. Security controls
4. Shell management
5. Directory handling

## Troubleshooting
1. Permission denied
2. Group issues
3. Directory problems
4. Shell errors
5. Lock/unlock issues

## Common Issues
1. Group conflicts
2. Home directory
3. Shell access
4. Account locks
5. Permission errors
