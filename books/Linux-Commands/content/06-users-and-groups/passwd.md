# passwd

## Overview
The `passwd` command changes user account passwords. It's used to change passwords, update password expiry information, and manage account locking.

## Syntax
```bash
passwd [options] [LOGIN]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d, --delete` | Delete password |
| `-e, --expire` | Force password expiration |
| `-i, --inactive DAYS` | Set password inactive days |
| `-l, --lock` | Lock password |
| `-n, --minimum DAYS` | Set minimum days |
| `-S, --status` | Password status report |
| `-u, --unlock` | Unlock password |
| `-w, --warning DAYS` | Set expiry warning |
| `-x, --maximum DAYS` | Set maximum days |
| `-h, --help` | Display help |

## Key Use Cases
1. Password management
2. Account security
3. Access control
4. Security maintenance
5. User administration

## Examples with Explanations
### Example 1: Change Password
```bash
passwd
```
Change own password

### Example 2: User Password
```bash
sudo passwd username
```
Change specific user's password

### Example 3: Account Status
```bash
passwd -S username
```
Show password status

## Understanding Output
Password status format:
```
username Status Last_Change Min_Days Max_Days Warn_Days Inactive Lock_Date
```
Status codes:
- P: usable password
- L: locked password
- NP: no password

## Common Usage Patterns
1. Force password change:
   ```bash
   passwd -e username
   ```
2. Lock account:
   ```bash
   passwd -l username
   ```
3. Set expiry:
   ```bash
   passwd -x 90 -w 7 username
   ```

## Security Considerations
1. Password complexity
2. Expiry policies
3. Account locking
4. Access control
5. Audit logging

## Related Commands
- `chage` - Change age info
- `usermod` - Modify users
- `shadow` - Shadow passwords
- `gpasswd` - Group passwords
- `pwck` - Password checks

## Additional Resources
- [Passwd Manual](https://man7.org/linux/man-pages/man1/passwd.1.html)
- [Password Security Guide](https://www.cyberciti.biz/tips/linux-security.html)
- [User Management](https://www.tecmint.com/usermod-command-examples/)

## Best Practices
1. Regular changes
2. Strong policies
3. Expiry management
4. Access monitoring
5. Security audits

## Password Policies
1. Minimum length
2. Complexity rules
3. History control
4. Expiry periods
5. Failed attempts

## Troubleshooting
1. Password errors
2. Account lockouts
3. Expiry issues
4. Permission problems
5. Policy conflicts
## Additional Examples
```bash
passwd                    # change own password
sudo passwd alice
sudo passwd -l alice      # lock
sudo passwd -u alice      # unlock
sudo passwd -S alice      # status
```
