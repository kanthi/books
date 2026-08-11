# shutdown

## Overview

`shutdown` schedules a system power-off, halt, or reboot and notifies logged-in users. On Ubuntu (systemd), it cooperates with **logind/PID 1** rather than implementing an old SysV path alone. Cousins: `reboot`, `poweroff`, `halt`, and `systemctl reboot|poweroff`. Use clear wall messages on multi-user hosts; cancel with `shutdown -c` when you abort a maintenance window.

## Syntax

```bash
sudo shutdown [options] [time] [wall-message]
sudo reboot [options]
sudo poweroff [options]
sudo halt [options]
```

## Time forms

| Form | Meaning |
|------|---------|
| `now` | Immediately |
| `+M` | M minutes from now (`+15`) |
| `hh:mm` | Clock time today (or tomorrow if past) on many implementations |

## Common options (`shutdown`)

| Option | Description |
|--------|-------------|
| `-r` | Reboot after shutdown sequence |
| `-h` | Halt/power off (historically “halt”; with systemd often powers off) |
| `-H` | Halt (may leave power on — hardware dependent) |
| `-P` | Power off |
| `-c` | Cancel a pending shutdown |
| `-k` | Send wall messages only (**no** real shutdown) |
| `--no-wall` | Skip wall broadcast (where supported) |
| `-f` / `-F` | Legacy fsck flags — often ignored under systemd |

## systemd / loginctl cousins

| Command | Effect |
|---------|--------|
| `systemctl reboot` | Reboot |
| `systemctl poweroff` | Power off |
| `systemctl halt` | Halt |
| `systemctl kexec` | kexec reboot when configured |
| `systemctl suspend` / `hibernate` | Sleep states |
| `loginctl reboot` / `poweroff` | Session manager entry points |

## Safety

- Unsaved work is lost; broadcast intent early (`wall`, chat, tickets).
- Remote reboot without **out-of-band console** (iLO, serial, cloud console) risks lockout if network/boot fails.
- Cloud VMs: provider APIs may force-stop differently from graceful ACPI/systemd shutdown — prefer guest-clean shutdown first.
- Cancelling (`-c`) only works if the schedule is still pending — not after the machine is already going down.
- Avoid `reboot -f` / immediate forced paths unless the system is already wedged.

## Key Use Cases

1. Graceful reboot after kernel/package updates
2. Timed maintenance windows with user notification
3. Cancel a mistaken schedule
4. Dry-run messaging with `-k`

## Examples with Explanations

### Example: power off now

```bash
sudo shutdown -h now
sudo poweroff
sudo systemctl poweroff
```

Equivalent intents on modern Ubuntu; prefer one style and stay consistent in runbooks.

### Example: reboot now

```bash
sudo shutdown -r now
sudo reboot
sudo systemctl reboot
```

### Example: delayed reboot with message

```bash
sudo shutdown -r +15 "kernel update reboot in 15 minutes — save work"
```

Users get wall notifications; new logins may be blocked as the time approaches (systemd/login semantics).

### Example: wall-clock schedule

```bash
sudo shutdown -r 23:30 "nightly maintenance reboot"
```

Handy for agreed maintenance slots. Confirm timezone with `timedatectl`.

### Example: cancel

```bash
sudo shutdown -c
sudo shutdown -c "reboot cancelled — window postponed"
```

Always cancel explicitly if the change is aborted so users are not left expecting downtime.

### Example: message only (drill)

```bash
sudo shutdown -k +10 "DRILL only — no reboot will occur"
```

Tests communication without risking the host.

### Example: systemd reboot with wall message

```bash
sudo systemctl reboot
# scheduled style often still via shutdown(8):
sudo shutdown -r +5 "applying HA failover test"
```

### Example: check last reboots

```bash
last reboot | head
who -b
journalctl --list-boots | tail
```

Forensics after unexpected restarts.

### Example: inhibit shutdown (awareness)

```bash
systemd-inhibit --list
# apps can delay sleep/shutdown for a reason — check during "why won't it reboot?"
```

### Example: forced paths (last resort)

```bash
sudo systemctl reboot -i          # ignore inhibitors (systemd)
# magic SysRq (if enabled) is an emergency tool — not routine ops
```

Use only when orderly shutdown is impossible and data risk is accepted.

## Understanding Output

- `shutdown` typically prints confirmation of the scheduled time.
- Broadcast messages appear on terminals of logged-in users.
- Journal will show shutdown targets activating (`shutdown.target`, `reboot.target`).

## Notes & Pitfalls

- On systemd, many binaries are related; `reboot` may be a symlink into systemctl machinery — behavior is unified.
- Containers: `shutdown` inside a container usually does **not** mean what you want for the host; use the orchestrator.
- Virt guests: clean shutdown lets the hypervisor mark the VM stopped cleanly.
- UPS scripts and cloud metadata “maintenance events” may call these tools for you — know who owns the action.
- `shutdown -h` vs `-P` vs `poweroff` nuances matter on bare metal with odd firmware; test in the lab once.

## Related Commands

- `systemctl` — reboot/poweroff targets and inhibitors
- `reboot` / `poweroff` / `halt` — short forms
- `wall` — manual broadcast
- `timedatectl` — confirm clock before `hh:mm` schedules
- `last` / `journalctl` — reboot history
- `loginctl` — session-layer power commands

## Additional Resources

- `man shutdown`
- `man systemd-shutdownd.service` / `man logind.conf`
