# reboot

## Overview

`reboot` restarts the system. On modern systemd systems it is typically a symlink or wrapper around **`systemctl reboot`**. Prefer explicit `systemctl` forms in scripts for clarity and options (wall messages, force flags). Always ensure workloads can stop cleanly.

## Syntax

```bash
reboot [options]
systemctl reboot
systemctl reboot --message="..."
```

## Common Options

| Option / form | Description |
|---------------|-------------|
| *(none)* | Normal reboot via init/systemd |
| `--help` | Help |
| `systemctl reboot -i` | Ignore inhibitors (careful) |
| `systemctl reboot --force` | Forceful (see man) |
| `systemctl reboot --firmware-setup` | Reboot to firmware setup (UEFI) when supported |
| `shutdown -r now` | Equivalent classic form |
| `shutdown -r +15 "msg"` | Scheduled reboot |

## Examples with Explanations

### Normal reboot

```bash
sudo reboot
sudo systemctl reboot
sudo shutdown -r now
```

### Scheduled

```bash
sudo shutdown -r +30 "Reboot for kernel update"
sudo shutdown -c                     # cancel
```

### With broadcast message

```bash
sudo systemctl reboot --message="Kernel update; back in 5 minutes"
```

### Inhibitors

```bash
systemd-inhibit --list
sudo systemctl reboot -i             # ignore inhibitors if stuck
```

### Firmware setup (UEFI)

```bash
sudo systemctl reboot --firmware-setup
```

### After kernel install

```bash
# apply new kernel
sudo reboot
uname -r                             # after boot
```

### Containers / hosts

```bash
# inside a container, reboot may be blocked or reboot the host depending on privileges —
# almost always wrong. Restart the container instead:
podman restart myctr
systemctl restart myapp.service
```

## Notes / Pitfalls

- Unsaved work dies; notify users (`wall`, tickets) on multi-user systems.
- Force flags can skip clean unmounts — risk filesystem recovery work.
- Cloud VMs: reboot vs stop/start may change ephemeral networking or public IPs depending on provider.
- Serial/console access ready before remote reboot of network-critical hosts.
- `reboot` during package transactions can leave broken state — finish `apt`/`dnf` first.

## 2026-relevant notes

- Live kernel patching reduces some reboot urgency; still needed for many updates.
- Immutable OS / image-based systems reboot into new deployments more often — treat as normal.
- Prefer orchestration drain (k8s) before node reboot.

## Related Commands

- `shutdown` / `poweroff` / `halt`
- `systemctl reboot` / `poweroff`
- `timedatectl` / `hostnamectl` — post-boot identity
- `journalctl -b` — logs for current boot
- `who` / `w` — who is logged in before reboot

## Additional Resources

- `man reboot`, `man systemctl`, `man shutdown`
