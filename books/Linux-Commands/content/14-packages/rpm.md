# rpm

## Overview
The `rpm` (RPM Package Manager) command is a low-level package manager for RPM-based Linux distributions. It handles individual package operations without managing dependencies.

## Syntax
```bash
rpm [options] [package...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Install package |
| `-U` | Upgrade package |
| `-e` | Erase package |
| `-q` | Query package |
| `-V` | Verify package |
| `-F` | Freshen package |
| `--nodeps` | Ignore dependencies |
| `--force` | Force operation |
| `--test` | Test only |
| `--rebuild` | Rebuild package |
| `--rebuilddb` | Rebuild database |
| `--checksig` | Check signature |

## Query Options
| Option | Description |
|--------|-------------|
| `-qa` | Query all |
| `-qi` | Package info |
| `-ql` | List files |
| `-qf` | File owner |
| `-qp` | Query package file |
| `-qR` | Requirements |
| `-qc` | Config files |
| `-qd` | Documentation |

## Key Use Cases
1. Package installation
2. Package queries
3. Package verification
4. Database maintenance
5. System verification

## Examples with Explanations
### Example 1: Install Package
```bash
rpm -ivh package.rpm
```
Install with verbose and hash progress

### Example 2: Query Package
```bash
rpm -qi package_name
```
Show package information

### Example 3: Verify Package
```bash
rpm -V package_name
```
Verify package files

## Common Usage Patterns
1. List installed:
   ```bash
   rpm -qa
   ```
2. Find owner:
   ```bash
   rpm -qf /path/to/file
   ```
3. Show dependencies:
   ```bash
   rpm -qR package_name
   ```

## Security Considerations
1. Package verification
2. GPG signatures
3. Root privileges
4. System integrity
5. Dependencies

## Related Commands
- `yum` - High-level manager
- `dnf` - Next-gen manager
- `rpmbuild` - Build packages
- `rpm2cpio` - Convert package
- `rpmsign` - Sign package

## Additional Resources
- [RPM Manual](https://rpm.org/documentation.html)
- [Package Management Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-rpm)
- [System Administration](https://www.tecmint.com/20-practical-examples-of-rpm-commands-in-linux/)

## Best Practices
1. Verify packages
2. Check signatures
3. Backup database
4. Document changes
5. Test installation

## Package Information
1. Version
2. Release
3. Architecture
4. Dependencies
5. Changelog

## Troubleshooting
1. Dependencies
2. Database issues
3. Conflicts
4. Space problems
5. Verification errors
