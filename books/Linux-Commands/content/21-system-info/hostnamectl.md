# hostnamectl

## Overview
The `hostnamectl` command controls the system hostname. It queries and changes system hostname and related settings.

## Syntax
```bash
hostnamectl [options] [command]
```

## Common Options
| Option | Description |
|--------|-------------|
| `status` | Show status |
| `set-hostname` | Set hostname |
| `set-icon-name` | Set icon name |
| `set-chassis` | Set chassis type |
| `set-deployment` | Set deployment |
| `set-location` | Set location |
| `--pretty` | Pretty hostname |
| `--static` | Static hostname |
| `--transient` | Transient hostname |
| `--no-ask-password` | No password |

## Output Fields
| Field | Description |
|-------|-------------|
| Hostname | System name |
| Icon Name | System icon |
| Chassis | Hardware type |
| Machine ID | System ID |
| Boot ID | Boot identifier |
| Virtualization | VM technology |
| Operating System | OS details |
| Kernel | Kernel version |
| Architecture | CPU architecture |

## Key Use Cases
1. System configuration
2. Hostname management
3. System information
4. Hardware details
5. OS information

## Examples with Explanations
### Example 1: Status
```bash
hostnamectl status
```
Show system status

### Example 2: Set Name
```bash
hostnamectl set-hostname newname
```
Change hostname

### Example 3: Set Pretty
```bash
hostnamectl set-hostname "Pretty Name" --pretty
```
Set pretty hostname

## Common Usage Patterns
1. Check status:
   ```bash
   hostnamectl
   ```
2. Change name:
   ```bash
   hostnamectl set-hostname name
   ```
3. Set chassis:
   ```bash
   hostnamectl set-chassis server
   ```

## System Information
1. Host details
2. System status
3. Hardware info
4. OS details
5. Configuration

## Related Commands
- `hostname` - Show hostname
- `uname` - System info
- `systemctl` - System control
- `dnsdomainname` - DNS domain
- `domainname` - NIS domain

## Additional Resources
- [Hostnamectl Manual](https://man7.org/linux/man-pages/man1/hostnamectl.1.html)
- [System Guide](https://www.freedesktop.org/software/systemd/man/hostnamectl.html)
- [System Administration](https://www.tecmint.com/linux-hostnamectl-command-examples/)

## Best Practices
1. Proper naming
2. Documentation
3. Configuration
4. Security
5. Verification

## Configuration Management
1. Hostname setup
2. System identity
3. Network config
4. DNS settings
5. System details

## Troubleshooting
1. Name issues
2. DNS problems
3. Configuration errors
4. System identity
5. Network settings

## Common Uses
1. System setup
2. Configuration
3. Documentation
4. Network setup
5. Identity management
