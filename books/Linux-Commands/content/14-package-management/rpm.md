# rpm

## Overview
The `rpm` (RPM Package Manager) command is used to install, uninstall, verify, query, and update software packages in Linux systems that use the RPM package management system.

## Syntax
```bash
rpm [options] [package]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Install package |
| `-U` | Upgrade package |
| `-e` | Erase (uninstall) package |
| `-q` | Query package |
| `-V` | Verify package |
| `-h` | Print hash marks during install |
| `-v` | Verbose mode |
| `--force` | Force install |
| `--nodeps` | Skip dependency checks |
| `--test` | Test run only |

## Key Use Cases
1. Install software packages
2. Upgrade existing packages
3. Remove packages
4. Query package information
5. Verify package integrity

## Examples with Explanations
### Example 1: Install Package
```bash
rpm -ivh package.rpm
```
Install package with progress hash marks

### Example 2: Query Package
```bash
rpm -qa | grep package
```
List all installed packages, filter for specific one

### Example 3: Verify Package
```bash
rpm -V package
```
Verify installed package files

## Understanding Output
Query format (-qa):
- Package name
- Version
- Release
- Architecture

Verify output symbols:
- S: File size differs
- M: Mode differs
- 5: MD5 sum differs
- D: Device major/minor number mismatch
- L: ReadLink path mismatch
- U: User ownership differs
- G: Group ownership differs
- T: Modification time differs

## Common Usage Patterns
1. Install with dependencies:
   ```bash
   rpm -ivh --aid package.rpm
   ```
2. List package contents:
   ```bash
   rpm -qlp package.rpm
   ```
3. Show package info:
   ```bash
   rpm -qip package.rpm
   ```

## Performance Analysis
- Use --test for dry runs
- Consider dependencies
- Check disk space
- Verify package signatures
- Monitor installation logs

## Related Commands
- `yum` - RPM package manager front-end
- `dnf` - Next generation package manager
- `rpmbuild` - Build RPM packages
- `rpm2cpio` - Convert RPM to cpio archive
- `rpmquery` - Query RPM packages

## Additional Resources
- [RPM Package Manager](https://rpm.org/)
- [RPM Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-rpm)
- [RPM Best Practices](https://docs.fedoraproject.org/en-US/packaging-guidelines/)
