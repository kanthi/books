# hostnamectl

## Overview
The `hostnamectl` command is used to query and change the system hostname and related settings. It provides a unified interface for hostname management in systemd-based systems.

## Syntax
```bash
hostnamectl [options] {status|set-hostname|set-icon-name|set-chassis|set-deployment|set-location} [value]
```

## Common Options
| Option | Description |
|--------|-------------|
| `--no-ask-password` | Don't prompt for password |
| `--static` | Change static hostname |
| `--transient` | Change transient hostname |
| `--pretty` | Change pretty hostname |
| `-H, --host` | Operate on remote host |
| `-M, --machine` | Operate on local container |
| `--json=` | Generate JSON output |
| `--help` | Show help message |

## Key Use Cases
1. System identification
2. Hostname management
3. System information display
4. Remote host configuration
5. Container management

## Examples with Explanations
### Example 1: Show Status
```bash
hostnamectl status
```
Display system and hostname information

### Example 2: Set Hostname
```bash
hostnamectl set-hostname newname
```
Change system hostname

### Example 3: Set Pretty Name
```bash
hostnamectl set-hostname "My Server" --pretty
```
Set descriptive hostname

## Understanding Output
Status output includes:
- Static hostname
- Pretty hostname
- Machine ID
- Boot ID
- Virtualization
- Operating System
- Architecture
- Kernel

## Common Usage Patterns
1. Check system info:
   ```bash
   hostnamectl
   ```
2. Change hostname:
   ```bash
   hostnamectl set-hostname server1
   ```
3. Set location:
   ```bash
   hostnamectl set-location "Data Center 1"
   ```

## Performance Analysis
- Systemd integration
- Configuration persistence
- Multiple hostname types
- Network impact
- Service notifications

## Related Commands
- `hostname` - Show/set hostname
- `systemctl` - Control systemd
- `uname` - System information
- `dnsdomainname` - Show domain
- `domainname` - NIS domain name

## Additional Resources
- [Systemd Documentation](https://www.freedesktop.org/software/systemd/man/hostnamectl.html)
- [System Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-configuring_basic_system_settings#sect-Configuring_Basic_System_Settings-Configuring_the_System_Hostname)
- [Hostname Management](https://www.tecmint.com/set-hostname-permanently-in-linux/)

## Configuration
1. Static vs Transient
2. Pretty hostname
3. Deployment environment
4. Chassis type
5. System location

## Best Practices
1. Use meaningful names
2. Document changes
3. Consider DNS impact
4. Update related services
5. Verify changes properly
