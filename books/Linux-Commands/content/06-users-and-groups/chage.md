# chage

## Overview
The `chage` command changes user password expiry information. It allows administrators to manage password aging and account expiration policies.

## Syntax
```bash
chage [options] LOGIN
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d, --lastday LAST_DAY` | Set last password change date |
| `-E, --expiredate EXPIRE_DATE` | Set account expiration date |
| `-I, --inactive INACTIVE` | Set password inactive days |
| `-l, --list` | Show account aging info |
| `-m, --mindays MIN_DAYS` | Set minimum days between changes |
| `-M, --maxdays MAX_DAYS` | Set maximum days between changes |
| `-W, --warndays WARN_DAYS` | Set expiry warning days |
| `-h, --help` | Display help |

## Key Use Cases
1. Password aging
2. Account expiration
3. Security policy
4. User management
5. Compliance

## Examples with Explanations
### Example 1: View Info
```bash
chage -l username
```
Show account aging information

### Example 2: Set Expiry
```bash
chage -E 2024-12-31 username
```
Set account expiration date

### Example 3: Password Age
```bash
chage -M 90 -m 7 -W 7 username
```
Set password age policy

## Understanding Output
Account aging information:
- Last password change
- Password expires
- Password inactive
- Account expires
- Minimum age
- Maximum age
- Warning period

## Common Usage Patterns
1. Force password change:
   ```bash
   chage -d 0 username
   ```
2. Set expiry policy:
   ```bash
   chage -M 60 -W 7 username
   ```
3. Remove expiration:
   ```bash
   chage -M -1 username
   ```

## Security Considerations
1. Password aging
2. Account expiration
3. Warning periods
4. Inactive accounts
5. Policy compliance

## Related Commands
- `passwd` - Change password
- `usermod` - Modify users
- `useradd` - Create users
- `shadow` - Shadow passwords
- `pwck` - Password checks

## Additional Resources
- [Chage Manual](https://man7.org/linux/man-pages/man1/chage.1.html)
- [Password Policy Guide](https://www.cyberciti.biz/tips/linux-security.html)
- [User Management](https://www.tecmint.com/usermod-command-examples/)

## Best Practices
1. Regular review
2. Policy documentation
3. Compliance checks
4. User notification
5. Audit logging

## Policy Management
1. Password lifetime
2. Account validity
3. Warning periods
4. Inactivity rules
5. Expiry dates

## Common Tasks
1. Password aging
2. Account expiry
3. Policy updates
4. User notifications
5. Compliance checks
