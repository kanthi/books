---
title: Intro
---

# Intro

Control the running system under systemd: units, journals, kernel parameters, reboot/shutdown, transient jobs, sessions, modules, and container CLI (`podman`).

## Commands in this part

| Command | Role |
|---------|------|
| `systemctl` | systemctl is the primary interface to systemd: start/stop units, enable on boot, inspect status, and list dependencies. |
| `journalctl` | journalctl queries the systemd journal — structured logs from the kernel, services, and many applications. |
| `sysctl` | sysctl reads and writes kernel parameters exposed under /proc/sys/. |
| `shutdown` | shutdown schedules a system power-off, halt, or reboot and notifies logged-in users. |
| `reboot` | reboot restarts the system. |
| `podman` | podman is a daemonless OCI container engine with a CLI largely compatible with Docker. |
| `systemd-run` | systemd-run creates transient units on the fly: one-shot commands, background services, or temporary timers without… |
| `systemd-analyze` | systemd-analyze diagnoses boot performance and unit graphs: how long boot took, which units delayed it, whether unit… |
| `loginctl` | loginctl manages systemd-logind seats, sessions, and users: who is logged in, idle hints, kill sessions, and… |
| `modprobe` | modprobe loads and unloads kernel modules, resolving dependencies via modules.dep — preferred over raw insmod/rmmod… |


## Suggested starting points

1. Services: `systemctl` status/start/enable; logs: `journalctl`.
2. Kernel tunables: `sysctl`; modules: `modprobe`.
3. Power: `shutdown`/`reboot` (prefer coordinated maintenance).
4. Ad-hoc units/timers: `systemd-run`; boot analysis: `systemd-analyze`.
5. User sessions / linger: `loginctl`.
6. Containers: `podman`.

## Related parts

- Scheduling — cron vs timers
- Logging — classic log tools alongside the journal
- Processes and jobs — when a unit is really a process tree

Continue with the individual command pages in this part.
