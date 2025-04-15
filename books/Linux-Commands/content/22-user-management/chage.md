# chage

## Overview
The `chage` command changes user password expiry information. It modifies the number of days between password changes and checks password aging.

## Syntax
```bash
chage [options] username
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d days` | Last change |
| `-E date` | Account expiry |
| `-I days` | Inactive days |
| `-l` | List aging info |
| `-m days` | Minimum days |
| `-M days` | Maximum days |
| `-W days` | Warning days |
| `--help` | Show help |
| `--version` | Show version |

## Configuration Files
| File | Description |
|------|-------------|
| /etc/shadow | Password data |
| /etc/login.defs | Login defaults |
| /etc/pam.d/system-auth | PAM config |
| /etc/security/limits.conf | System limits |

## Key Use Cases
1. Password aging
2. Account expiry
3. Security policy
4. User management
5. Access control

## Examples with Explanations
### Example 1: List Info
```bash
chage -l username
```
Show aging info

### Example 2: Set Expiry
```bash
chage -E 2024-12-31 username
```
Set account expiry

### Example 3: Force Change
```bash
chage -d 0 username
```
Force password change

## Common Usage Patterns
1. View settings:
   ```bash
   chage -l user
   ```
2. Set maximum:
   ```bash
   chage -M 90 user
   ```
3. Set warning:
   ```bash
   chage -W 7 user
   ```

## Security Considerations
1. Password policy
2. Account access
3. Expiry control
4. Security compliance
5. User notification

## Related Commands
- `passwd` - Change password
- `usermod` - Modify user
- `useradd` - Add user
- `shadow` - Password file
- `pwck` - Check files

## Additional Resources
- [Chage Manual](https://man7.org/linux/man-pages/man1/chage.1.html)
- [Security Guide](https://www.cyberciti.biz/faq/linux-chage-command-examples-syntax-usage/)
- [System Administration](https://www.tecmint.com/linux-chage-command-examples/)

## Best Practices
1. Regular updates
2. Policy compliance
3. User notification
4. Documentation
5. Security audit

## Password Management
1. Aging control
2. Expiry settings
3. Policy enforcement
4. Access management
5. Security control

## Troubleshooting
1. Expiry issues
2. Policy conflicts
3. Access problems
4. System errors
5. User complaints

## Common Issues
1. Expired passwords
2. Account lockouts
3. Policy violations
4. System conflicts
5. User confusion
