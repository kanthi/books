# shutdown / reboot / poweroff / halt

## Overview
These commands schedule or request system power state changes. On systemd systems they talk to logind/PID 1. Prefer clear wall messages on multi-user hosts.

## Syntax
```bash
sudo shutdown [options] when [message]
sudo reboot
sudo poweroff
sudo halt
```

## `when` forms
`now`, `+minutes`, `hh:mm`.

## Common Options (`shutdown`)
| Option | Description |
|--------|-------------|
| `-h` | Halt/power off |
| `-r` | Reboot |
| `-c` | Cancel scheduled |
| `-k` | Wall only, no shutdown |

## Examples with Explanations
```bash
sudo shutdown -h now
sudo shutdown -r +15 "kernel update reboot"
sudo shutdown -r 23:30 "nightly reboot"
sudo shutdown -c
sudo reboot
sudo systemctl reboot
sudo systemctl poweroff
```

### systemd equivalents
```bash
sudo systemctl reboot
sudo systemctl poweroff
sudo systemctl suspend
```

## Safety
- Unsaved work will be lost; notify users (`wall`).  
- Remote: ensure out-of-band console if reboot fails.  
- Cloud providers may have separate stop/restart APIs.

## Related Commands
- `systemctl`  
- `loginctl`  
- `wall`  
- `last reboot`
