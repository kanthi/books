# systemctl

## Overview
The `systemctl` command controls the systemd system and service manager. It's used to manage system services, check system status, and change system state.

## Syntax
```bash
systemctl [options] command [name]
```

## Common Commands
| Command | Description |
|---------|-------------|
| `start` | Start service |
| `stop` | Stop service |
| `restart` | Restart service |
| `reload` | Reload configuration |
| `status` | Check status |
| `enable` | Enable at boot |
| `disable` | Disable at boot |
| `is-active` | Check if active |
| `is-enabled` | Check if enabled |
| `list-units` | List units |
| `list-unit-files` | List unit files |
| `daemon-reload` | Reload systemd |

## Common Options
| Option | Description |
|--------|-------------|
| `-H HOST` | Remote host |
| `-M CONTAINER` | Container name |
| `-t TYPE` | List specific type |
| `-a, --all` | Show all units |
| `-l, --full` | Don't ellipsize |
| `--failed` | Show failed units |
| `--user` | User service manager |
| `--system` | System service manager |

## Key Use Cases
1. Service management
2. System state control
3. Boot configuration
4. Service monitoring
5. System troubleshooting

## Examples with Explanations
### Example 1: Service Status
```bash
systemctl status nginx
```
Check nginx service status

### Example 2: Start Service
```bash
systemctl start mysql
```
Start MySQL service

### Example 3: Enable Service
```bash
systemctl enable ssh
```
Enable SSH at boot

## Common Usage Patterns
1. Service control:
   ```bash
   systemctl restart service
   ```
2. Boot management:
   ```bash
   systemctl enable --now service
   ```
3. Status check:
   ```bash
   systemctl is-active service
   ```

## Service States
- active (running)
- active (exited)
- active (waiting)
- inactive (dead)
- failed
- activating
- deactivating

## Related Commands
- `service` - Init service control
- `chkconfig` - Update runlevels
- `init` - Process control
- `shutdown` - System shutdown
- `journalctl` - View logs

## Additional Resources
- [Systemctl Manual](https://man7.org/linux/man-pages/man1/systemctl.1.html)
- [Systemd Guide](https://www.freedesktop.org/wiki/Software/systemd/)
- [Service Management](https://www.digitalocean.com/community/tutorials/how-to-use-systemctl-to-manage-systemd-services-and-units)

## Best Practices
1. Regular status checks
2. Enable required services
3. Monitor failed units
4. Document changes
5. Security considerations

## Troubleshooting
1. Failed services
2. Boot problems
3. Dependencies
4. Configuration errors
5. Resource issues

## Unit Types
1. service
2. socket
3. device
4. mount
5. target
