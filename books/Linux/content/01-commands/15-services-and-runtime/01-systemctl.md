# systemctl

## Overview

`systemctl` is the primary interface to **systemd**: start/stop units, enable on boot, inspect status, and list dependencies. Ubuntu, Debian, Fedora, and RHEL-family systems all use it for service control.

## Syntax

```bash
systemctl [options] command [unit...]
```

Units use suffixes: `.service`, `.socket`, `.timer`, `.mount`, `.target`, `.path`, …

## Common Commands

| Command | Description |
|---------|-------------|
| `status UNIT` | State, PIDs, recent journal snippet |
| `start` / `stop` / `restart` / `reload` | Lifecycle |
| `enable` / `disable` | Boot linkage |
| `enable --now` | Enable and start |
| `is-active` / `is-enabled` / `is-failed` | Script-friendly checks |
| `mask` / `unmask` | Block start entirely / undo |
| `daemon-reload` | Reload unit files after edits |
| `list-units` / `list-unit-files` | Inventory |
| `list-timers` / `list-sockets` | Timers / sockets |
| `cat UNIT` | Show unit text (incl. drop-ins) |
| `edit UNIT` | Create drop-in override |
| `show UNIT` | Low-level properties |
| `reset-failed` | Clear failed state |
| `reboot` / `poweroff` / `suspend` | System actions |

## Key Use Cases

1. Operate application and infrastructure services  
2. Enable services at boot  
3. Debug failed units  
4. Override vendor unit settings safely with drop-ins  
5. Inspect timers as a cron alternative  

## Safety

- `mask` symlinks a unit to `/dev/null` — easy to forget; prefer `stop` + `disable` unless you must block activation.  
- Do not `restart` remote access (`ssh.service`) on a fleet without console/recovery.  
- `daemon-reload` after every unit file change — forgetting it is a common footgun.  
- User vs system buses: `systemctl --user` is a separate world.

## Examples with Explanations

### Status and logs peek

```bash
systemctl status nginx --no-pager -l
journalctl -u nginx -n 50 --no-pager
```

### Start / enable

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl enable --now nginx
```

### Restart vs reload

```bash
sudo systemctl reload nginx          # graceful if ExecReload defined
sudo systemctl restart nginx
sudo systemctl try-restart nginx     # only if already active
```

### Failed units

```bash
systemctl --failed
systemctl list-units --state=failed
sudo systemctl reset-failed
```

### Script checks

```bash
systemctl is-active --quiet nginx && echo running
systemctl is-enabled nginx
systemctl is-failed nginx
```

### After editing unit files

```bash
sudo systemctl daemon-reload
sudo systemctl restart myapp.service
```

### Drop-in override (preferred over editing vendor files)

```bash
sudo systemctl edit nginx.service
# creates /etc/systemd/system/nginx.service.d/override.conf
sudo systemctl cat nginx.service
```

Example override snippet:

```ini
[Service]
Environment=GOMAXPROCS=4
LimitNOFILE=65535
```

### Timers (cron alternative)

```bash
systemctl list-timers --all
systemctl status logrotate.timer
systemctl cat logrotate.timer
```

### Dependencies and reverse deps

```bash
systemctl list-dependencies nginx.service
systemctl list-dependencies --reverse nginx.service
```

### User services

```bash
systemctl --user status podman.socket
loginctl enable-linger "$USER"    # allow user services without login
```

### Isolate targets (careful)

```bash
systemctl get-default
# sudo systemctl isolate multi-user.target   # stops graphical stack, etc.
```

## Understanding Output

`status` shows load state (loaded/masked), active state (running/failed/dead), main PID, cgroup path, and a journal snippet. `is-active` / `is-enabled` exit codes are designed for shell scripts (0 = true for the asked condition).

## Notes & Pitfalls

- Unit names can be abbreviated when unique (`systemctl status nginx`).  
- `restart` is stop+start; open files/sockets may behave differently than `reload`.  
- Template units: `systemctl start getty@tty2` instantiates `getty@.service`.  
- Masked units look “disabled” but refuse start until `unmask`.  
- Containers may run without systemd — commands then fail or talk to the host via bind mounts.

## Related Commands

- `journalctl` — logs  
- `loginctl` / `hostnamectl` / `timedatectl` — other systemd tools  
- `systemd-analyze` — boot and unit blame  
- `systemd-run` — ephemeral units / transient timers  
- `service` — legacy wrapper  

## Additional Resources

- `man systemctl`  
- `man systemd.service`  
- `man systemd.timer`
