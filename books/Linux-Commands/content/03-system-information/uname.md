# uname

## Overview
The `uname` command prints system information including kernel name, network node hostname, kernel release, version, machine hardware name, and operating system.

## Syntax
```bash
uname [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Print all information |
| `-s` | Print kernel name |
| `-n` | Print network node hostname |
| `-r` | Print kernel release |
| `-v` | Print kernel version |
| `-m` | Print machine hardware name |
| `-p` | Print processor type |
| `-i` | Print hardware platform |
| `-o` | Print operating system |

## Key Use Cases
1. System identification
2. OS version checking
3. Architecture detection
4. Kernel information
5. Platform verification

## Examples with Explanations
### Example 1: All Information
```bash
uname -a
```
Display all system information

### Example 2: Kernel Version
```bash
uname -r
```
Show kernel release version

### Example 3: Machine Hardware
```bash
uname -m
```
Display machine hardware name

## Understanding Output
Example output format:
```
Linux hostname 5.4.0-generic #1-Ubuntu x86_64 GNU/Linux
```
Components:
- Kernel name
- Host name
- Kernel release
- Kernel version
- Machine architecture
- Operating system

## Common Usage Patterns
1. Check system type:
   ```bash
   uname -s
   ```
2. Get architecture:
   ```bash
   uname -m
   ```
3. Full system info:
   ```bash
   uname -a
   ```

## Performance Analysis
- Fast execution
- Minimal system impact
- Static information
- No file system access
- Lightweight operation

## Related Commands
- `hostname` - System hostname
- `arch` - Machine architecture
- `lsb_release` - Distribution info
- `hostnamectl` - System and hostname
- `cat /etc/os-release` - OS information

## Additional Resources
- [GNU Coreutils - uname](https://www.gnu.org/software/coreutils/manual/html_node/uname-invocation.html)
- [Linux System Information](https://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/)
- [Kernel Documentation](https://www.kernel.org/doc/html/latest/)

## Use Cases
1. Script system detection
2. Compatibility checking
3. System documentation
4. Build environment setup
5. Platform verification

## Best Practices
1. Use -a for complete info
2. Check specific components
3. Combine with other commands
4. Script automation
5. Regular monitoring
## Additional Examples
```bash
uname -a
uname -r          # kernel release
uname -m          # machine arch
uname -n          # hostname
```
