# yum

## Overview
The `yum` (Yellowdog Updater Modified) command manages packages in RPM-based Linux systems. It handles package installation, updates, and removal.

## Syntax
```bash
yum [options] command [package...]
```

## Common Commands
| Command | Description |
|---------|-------------|
| `install` | Install packages |
| `update` | Update packages |
| `remove` | Remove packages |
| `search` | Search packages |
| `info` | Show package info |
| `list` | List packages |
| `check-update` | Check updates |
| `clean` | Clean cache |
| `groupinstall` | Install group |
| `groupremove` | Remove group |
| `history` | Transaction history |
| `provides` | Find package providing file |

## Common Options
| Option | Description |
|--------|-------------|
| `-y` | Assume yes |
| `-q` | Quiet mode |
| `--nogpgcheck` | Skip GPG check |
| `--enablerepo` | Enable repository |
| `--disablerepo` | Disable repository |
| `--exclude` | Exclude packages |
| `--downloadonly` | Download only |
| `--skip-broken` | Skip broken packages |

## Key Use Cases
1. Package management
2. System updates
3. Dependency resolution
4. Repository management
5. System maintenance

## Examples with Explanations
### Example 1: Install Package
```bash
yum install package_name
```
Install specific package

### Example 2: Update System
```bash
yum update
```
Update all packages

### Example 3: Search Package
```bash
yum search keyword
```
Search for packages

## Common Usage Patterns
1. System update:
   ```bash
   yum check-update && yum update
   ```
2. Group install:
   ```bash
   yum groupinstall "Development Tools"
   ```
3. Clean cache:
   ```bash
   yum clean all
   ```

## Security Considerations
1. Repository security
2. GPG verification
3. Root privileges
4. Network security
5. Version control

## Related Commands
- `rpm` - Package manager
- `dnf` - Next-gen package manager
- `createrepo` - Create repository
- `repoquery` - Query packages
- `yumdownloader` - Download packages

## Additional Resources
- [Yum Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-yum)
- [Package Management Guide](https://www.cyberciti.biz/faq/rhel-centos-fedora-linux-yum-command-howto/)
- [System Administration](https://www.tecmint.com/20-linux-yum-yellowdog-updater-modified-commands-for-package-mangement/)

## Best Practices
1. Regular updates
2. Clean cache
3. Verify packages
4. Backup configuration
5. Test updates

## Repository Management
1. Configuration
2. Priorities
3. GPG keys
4. Mirrors
5. Custom repos

## Troubleshooting
1. Dependency issues
2. Repository problems
3. Network errors
4. Space issues
5. Lock files
