# groupmod

## Overview
The `groupmod` command modifies group definition on the system. It allows administrators to change various attributes of existing groups.

## Syntax
```bash
groupmod [options] GROUP
```

## Common Options
| Option | Description |
|--------|-------------|
| `-g, --gid GID` | Change group ID |
| `-n, --new-name NEW_GROUP` | Change group name |
| `-o, --non-unique` | Allow non-unique GID |
| `-p, --password PASSWORD` | Change encrypted password |
| `-R, --root CHROOT_DIR` | Directory to chroot into |
| `-h, --help` | Display help |
| `--version` | Show version |

## Key Use Cases
1. Group management
2. Access control
3. Security maintenance
4. Resource organization
5. System administration

## Examples with Explanations
### Example 1: Rename Group
```bash
groupmod -n newname oldname
```
Change group name

### Example 2: Change GID
```bash
groupmod -g 1001 groupname
```
Change group ID

### Example 3: Non-unique GID
```bash
groupmod -o -g 1001 groupname
```
Allow duplicate GID

## Understanding Output
- No output on success
- Error messages for:
  - Group not found
  - Invalid GID
  - Permission denied
  - Name conflicts

## Common Usage Patterns
1. Group rename:
   ```bash
   groupmod -n project_2024 project_2023
   ```
2. GID modification:
   ```bash
   groupmod -g 2000 groupname
   ```
3. Password change:
   ```bash
   groupmod -p $(openssl passwd -1) groupname
   ```

## Security Considerations
1. GID uniqueness
2. Password protection
3. File permissions
4. Access control
5. System integrity

## Related Commands
- `groupadd` - Create groups
- `groupdel` - Delete groups
- `useradd` - Create users
- `usermod` - Modify users
- `gpasswd` - Administer groups

## Additional Resources
- [Groupmod Manual](https://man7.org/linux/man-pages/man8/groupmod.8.html)
- [Group Management Guide](https://www.tecmint.com/commands-to-manage-linux-groups/)
- [System Security](https://www.cyberciti.biz/tips/linux-security.html)

## Best Practices
1. Backup before changes
2. Document modifications
3. Check dependencies
4. Verify changes
5. Regular audits

## Common Tasks
1. Group renaming
2. GID changes
3. Password updates
4. Access modifications
5. System reorganization

## Impact Assessment
1. File ownership
2. User access
3. Running processes
4. System services
5. Resource permissions
