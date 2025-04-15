# passwd

## Overview
The `passwd` command changes user password. It modifies the password for user accounts and can also change account information.

## Syntax
```bash
passwd [options] [username]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Delete password |
| `-e` | Expire password |
| `-i days` | Inactive days |
| `-l` | Lock account |
| `-n days` | Minimum days |
| `-S` | Status report |
| `-u` | Unlock account |
| `-w days` | Warning days |
| `-x days` | Maximum days |
| `--stdin` | Read from stdin |

## Configuration Files
| File | Description |
|------|-------------|
| /etc/passwd | User accounts |
| /etc/shadow | Password data |
| /etc/pam.d/passwd | PAM config |
| /etc/login.defs | Login defaults |
| /etc/security/pwquality.conf | Password quality |

## Key Use Cases
1. Password changes
2. Account security
3. Password policy
4. Account locking
5. Security management

## Examples with Explanations
### Example 1: Change Password
```bash
passwd
```
Change own password

### Example 2: User Password
```bash
passwd username
```
Change user's password

### Example 3: Lock Account
```bash
passwd -l username
```
Lock user account

## Common Usage Patterns
1. Self change:
   ```bash
   passwd
   ```
2. User change:
   ```bash
   passwd user
   ```
3. Account status:
   ```bash
   passwd -S user
   ```

## Security Considerations
1. Password strength
2. Account access
3. Expiry policy
4. Lock control
5. Password history

## Related Commands
- `chage` - Age information
- `usermod` - Modify user
- `useradd` - Add user
- `shadow` - Password file
- `pwck` - Check files

## Additional Resources
- [Passwd Manual](https://man7.org/linux/man-pages/man1/passwd.1.html)
- [Security Guide](https://www.cyberciti.biz/faq/linux-passwd-command-examples-syntax-usage/)
- [System Administration](https://www.tecmint.com/linux-passwd-command-examples/)

## Best Practices
1. Strong passwords
2. Regular changes
3. Policy compliance
4. Access control
5. Documentation

## Password Management
1. Password changes
2. Account security
3. Policy enforcement
4. Access control
5. Security audit

## Troubleshooting
1. Password errors
2. Lock issues
3. Policy conflicts
4. Access problems
5. System errors

## Common Issues
1. Weak passwords
2. Policy violations
3. Lock problems
4. Access denied
5. System conflicts
