# useradd

## Overview
The `useradd` command creates new user accounts on Linux systems. It sets up the user's home directory, shell, and initial group memberships according to system defaults or specified parameters.

## Syntax
```bash
useradd [options] username
```

## Common Options
| Option | Description |
|--------|-------------|
| `-m` | Create home directory |
| `-d path` | Specify home directory path |
| `-s shell` | Specify login shell |
| `-g group` | Specify primary group |
| `-G groups` | Specify supplementary groups |
| `-c comment` | Add comment/full name |
| `-e date` | Set account expiry date |
| `-f days` | Set password expiry |
| `-r` | Create system account |

## Key Use Cases
1. Create new user accounts
2. Set up system service accounts
3. Batch user creation
4. Create users with specific requirements
5. Set up development environment accounts

## Examples with Explanations
### Example 1: Create Basic User
```bash
useradd -m -s /bin/bash username
```
Creates user with home directory and bash shell

### Example 2: Create System User
```bash
useradd -r -s /sbin/nologin systemuser
```
Creates system user without login ability

### Example 3: Create User with Groups
```bash
useradd -m -G wheel,developers username
```
Creates user and adds to specified groups

## Understanding Output
- No output on success
- Error messages for:
  - Duplicate username
  - Invalid parameters
  - Insufficient permissions
  - Resource constraints

## Common Usage Patterns
1. Create standard user:
   ```bash
   useradd -m -s /bin/bash -c "Full Name" username
   ```
2. Create service account:
   ```bash
   useradd -r -s /sbin/nologin -c "Service Account" svcuser
   ```
3. Create user with specific UID:
   ```bash
   useradd -u 1500 -m username
   ```

## Performance Analysis
- Minimal system impact
- Consider using batch creation for multiple users
- Use templates (-k) for consistent setup
- Monitor disk space for home directories

## Related Commands
- `usermod` - Modify user accounts
- `userdel` - Delete user accounts
- `passwd` - Set user password
- `chage` - Change user password expiry
- `groups` - Show group memberships

## Additional Resources
- [Linux useradd manual](https://man7.org/linux/man-pages/man8/useradd.8.html)
- [User Management Guide](https://www.tecmint.com/add-users-in-linux/)
