# usermod

## Overview
The `usermod` command modifies user account settings. It allows system administrators to modify various attributes of existing user accounts.

## Syntax
```bash
usermod [options] LOGIN
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a, --append` | Add to supplementary groups |
| `-c, --comment` | Change comment field |
| `-d, --home` | Change home directory |
| `-e, --expiredate` | Set account expiration date |
| `-g, --gid` | Change primary group |
| `-G, --groups` | Set supplementary groups |
| `-l, --login` | Change login name |
| `-L, --lock` | Lock password |
| `-m, --move-home` | Move home directory |
| `-s, --shell` | Change login shell |
| `-U, --unlock` | Unlock password |
| `-u, --uid` | Change user ID |

## Key Use Cases
1. User management
2. Access control
3. Security maintenance
4. Account modification
5. Group management

## Examples with Explanations
### Example 1: Change Shell
```bash
usermod -s /bin/bash username
```
Change user's login shell

### Example 2: Add to Group
```bash
usermod -aG sudo username
```
Add user to sudo group

### Example 3: Lock Account
```bash
usermod -L username
```
Lock user account

## Understanding Output
- No output on success
- Error messages for:
  - Invalid options
  - User not found
  - Permission denied
  - Resource conflicts

## Common Usage Patterns
1. Group management:
   ```bash
   usermod -aG group1,group2 user
   ```
2. Home directory:
   ```bash
   usermod -d /newhome -m user
   ```
3. Account expiry:
   ```bash
   usermod -e 2024-12-31 user
   ```

## Security Considerations
1. Password management
2. Group permissions
3. Shell restrictions
4. Account locking
5. Access control

## Related Commands
- `useradd` - Create users
- `userdel` - Delete users
- `passwd` - Change password
- `chage` - Change age info
- `groups` - Show group membership

## Additional Resources
- [Usermod Manual](https://man7.org/linux/man-pages/man8/usermod.8.html)
- [User Management Guide](https://www.tecmint.com/usermod-command-examples/)
- [Linux Security](https://www.cyberciti.biz/tips/linux-security.html)

## Best Practices
1. Backup before changes
2. Document modifications
3. Check permissions
4. Verify changes
5. Regular audits

## Common Tasks
1. Group management
2. Shell changes
3. Home directory moves
4. Account locking
5. Permission updates
