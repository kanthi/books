# systemctl

## Overview
`systemctl` is the primary interface to **systemd**: start/stop units, enable on boot, inspect status, and list dependencies. Most modern distros (including Ubuntu) manage services this way.

## Syntax
```bash
systemctl [options] command [unit...]
```

Units end in suffixes: `.service`, `.socket`, `.timer`, `.mount`, `.target`, …

## Common Commands
| Command | Description |
|---------|-------------|
| `status UNIT` | State, PIDs, recent logs |
| `start` / `stop` / `restart` | Lifecycle |
| `reload` | Reload config if supported |
| `enable` / `disable` | Boot linkage |
| `is-active` / `is-enabled` | Script-friendly checks |
| `mask` / `unmask` | Prevent start entirely |
| `daemon-reload` | Reload unit files after edit |
| `list-units` | Active units |
| `list-unit-files` | Installed unit files |
| `cat UNIT` | Show unit text |
| `edit UNIT` | Drop-in override |
| `reboot` / `poweroff` | System actions (also `shutdown`) |

## Key Use Cases
1. Operate application services  
2. Enable services at boot  
3. Debug failed units  
4. Override vendor unit settings safely  

## Safety
`mask` makes a unit impossible to start (symlink to `/dev/null`) — easy to forget. Prefer `stop` + `disable` unless you must block activation. Do not `restart` critical remote access (`sshd`) without a recovery path.

## Examples with Explanations
### Status and logs peek
```bash
systemctl status nginx
systemctl status nginx --no-pager -l
```

### Start / enable
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl enable --now nginx   # enable + start
```

### Restart / reload
```bash
sudo systemctl reload nginx         # graceful if available
sudo systemctl restart nginx
```

### Failed units
```bash
systemctl --failed
systemctl list-units --state=failed
```

### Script checks
```bash
systemctl is-active --quiet nginx && echo running
systemctl is-enabled nginx
```

### After editing a unit file
```bash
sudo systemctl daemon-reload
sudo systemctl restart myapp.service
```

### Drop-in override
```bash
sudo systemctl edit nginx
# opens editor for /etc/systemd/system/nginx.service.d/override.conf
```

### List timers
```bash
systemctl list-timers --all
```

### Dependencies
```bash
systemctl list-dependencies nginx.service
```

## Understanding Output
`status` shows load state (loaded/masked), active state (running/failed/dead), main PID, cgroup, and a journal snippet. Exit codes from `is-active` / `is-enabled` are designed for shell scripts.

## Common Usage Patterns
### Follow service logs (via journalctl)
```bash
journalctl -u nginx -f
```

### Reset failed marker after fix
```bash
sudo systemctl reset-failed myapp.service
```

## Notes & Pitfalls
- User services: `systemctl --user` (lingering may be needed for background).  
- `restart` = stop+start; `try-restart` only if running.  
- Unit names can be abbreviated when unique (`systemctl status nginx`).  

## Related Commands
- `journalctl` — logs  
- `loginctl` / `hostnamectl` / `timedatectl` — other systemd tools  
- `service` — legacy wrapper on some systems  

## Additional Resources
- `man systemctl`  
- `man systemd.service`
