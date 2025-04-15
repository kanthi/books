# useradd

## Overview
The `useradd` command creates new users or updates default new user information. It is a low-level utility for adding users.

## Syntax
```bash
useradd [options] login
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c comment` | Comment field |
| `-d home_dir` | Home directory |
| `-e expire_date` | Account expiry |
| `-f inactive` | Inactivity period |
| `-g group` | Primary group |
| `-G groups` | Secondary groups |
| `-m` | Create home |
| `-M` | No home directory |
| `-N` | No user group |
| `-p password` | Encrypted password |
| `-r` | System account |
| `-s shell` | Login shell |
| `-u uid` | User ID |

## Configuration Files
| File | Description |
|------|-------------|
| /etc/passwd | User accounts |
| /etc/shadow | Secure accounts |
| /etc/group | Group accounts |
| /etc/default/useradd | Defaults |
| /etc/login.defs | System defaults |
| /etc/skel/ | Skeleton files |

## Key Use Cases
1. User creation
2. Account setup
3. System accounts
4. Group management
5. Security setup

## Examples with Explanations
### Example 1: Basic User
```bash
useradd username
```
Create basic user

### Example 2: Full Setup
```bash
useradd -m -G wheel -s /bin/bash username
```
Create with home and group

### Example 3: System User
```bash
useradd -r -s /sbin/nologin sysuser
```
Create system account

## Common Usage Patterns
1. Standard user:
   ```bash
   useradd -m -s /bin/bash user
   ```
2. System account:
   ```bash
   useradd -r service
   ```
3. Group member:
   ```bash
   useradd -G group1,group2 user
   ```

## Security Considerations
1. Password policy
2. Group access
3. Shell restrictions
4. Home directory
5. File permissions

## Related Commands
- `usermod` - Modify user
- `userdel` - Delete user
- `passwd` - Set password
- `groupadd` - Add group
- `chage` - Age information

## Additional Resources
- [Useradd Manual](https://man7.org/linux/man-pages/man8/useradd.8.html)
- [User Guide](https://www.cyberciti.biz/faq/linux-useradd-command-examples-syntax-usage/)
- [System Administration](https://www.tecmint.com/linux-useradd-command-examples/)

## Best Practices
1. Strong passwords
2. Proper groups
3. Shell security
4. Directory permissions
5. Documentation

## User Management
1. Account creation
2. Group assignment
3. Home directories
4. Shell setup
5. Password policy

## Troubleshooting
1. Permission denied
2. Group issues
3. Home directory
4. Shell problems
5. Password errors

## Common Issues
1. UID conflicts
2. Group access
3. Directory rights
4. Shell access
5. Password setup
