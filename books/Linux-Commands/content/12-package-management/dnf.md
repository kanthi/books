# dnf

## Overview
The `dnf` (Dandified Yum) command is the next-generation package manager for RPM-based Linux distributions. It succeeds `yum` with improved dependency resolution and performance.

## Syntax
```bash
dnf [options] command [package...]
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
| `group` | Group operations |
| `history` | Transaction history |
| `repolist` | List repositories |
| `provides` | Find file provider |
| `module` | Module operations |
| `downgrade` | Downgrade package |

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
| `--best` | Best package version |
| `--allowerasing` | Allow erasing |

## Key Use Cases
1. Package management
2. System updates
3. Module management
4. Repository control
5. System maintenance

## Examples with Explanations
### Example 1: Install Package
```bash
dnf install package_name
```
Install specific package

### Example 2: Update System
```bash
dnf update
```
Update all packages

### Example 3: Module Operations
```bash
dnf module list
```
List available modules

## Common Usage Patterns
1. System update:
   ```bash
   dnf check-update && dnf update
   ```
2. Group install:
   ```bash
   dnf group install "Development Tools"
   ```
3. Module enable:
   ```bash
   dnf module enable nodejs:12
   ```

## Security Considerations
1. Repository security
2. GPG verification
3. Root privileges
4. Network security
5. Version control

## Related Commands
- `rpm` - Package manager
- `yum` - Legacy package manager
- `createrepo` - Create repository
- `dnf-automatic` - Automatic updates
- `microdnf` - Minimal DNF

## Additional Resources
- [DNF Documentation](https://dnf.readthedocs.io/)
- [Package Management Guide](https://docs.fedoraproject.org/en-US/quick-docs/dnf/)
- [System Administration](https://www.tecmint.com/dnf-commands-for-fedora-rpm-package-management/)

## Best Practices
1. Regular updates
2. Clean cache
3. Verify packages
4. Backup configuration
5. Test updates

## Module Management
1. Enable/disable
2. Install/remove
3. Switch streams
4. Reset modules
5. List profiles

## Troubleshooting
1. Dependency issues
2. Repository problems
3. Network errors
4. Space issues
5. Module conflicts
