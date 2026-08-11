---
title: Intro
---

# Intro

Identify the host, kernel, time zone, logged-in users, environment, and high-level hardware inventory. Start here when answering “what machine is this?” and “who is on it?”.

## Commands in this part

| Command | Role |
|---------|------|
| `uname` | uname prints system information: kernel name, hostname/nodename, kernel release/version, machine hardware name, and… |
| `hostname` | hostname prints or sets the system hostname. |
| `hostnamectl` | hostnamectl queries and changes the system hostname and related machine identity fields on systemd systems. |
| `lsb_release` | lsb_release prints distribution identification claimed via the Linux Standard Base (LSB) interfaces and… |
| `uptime` | uptime shows how long the system has been running, how many users are logged in, and the load average (1, 5, and 15… |
| `date` | date prints or sets the system date and time. |
| `timedatectl` | timedatectl views and changes the system clock, timezone, RTC settings, and NTP synchronization on systemd systems. |
| `cal` | cal displays a calendar in the terminal — current month by default, or a specific month/year. |
| `whoami` | whoami prints the effective username of the current user. |
| `id` | id prints the real and effective user and group IDs for a process (by default, yours), plus supplementary groups. |
| `who` | who shows who is logged in, with terminal, login time, and sometimes host/remote info from utmp/wtmp accounting. |
| `w` | w shows who is logged in and what they are doing, plus system uptime and load averages. |
| `last` | last shows a history of logins, reboots, and runlevel changes from the wtmp accounting file (typically /var/log/wtmp). |
| `env` | env runs a program in a modified environment, or prints the current environment variables when given no command. |
| `free` | free summarizes system memory usage: physical RAM and swap. |
| `lscpu` | lscpu displays CPU architecture information from sysfs and /proc/cpuinfo: sockets, cores, threads, model name,… |
| `lsmem` | The lsmem command displays information about memory ranges and their online/offline status. |
| `lsusb` | lsusb lists USB devices connected to the system (buses, IDs, vendor/product strings). |
| `lsmod` | lsmod lists loaded kernel modules (name, size, use count, dependents). |
| `hwinfo` | The hwinfo command provides comprehensive hardware information. |


## Suggested starting points

1. Kernel/OS: `uname`, `lsb_release` / os-release, `hostnamectl`.
2. Time: `date`, `timedatectl`.
3. Identity: `whoami`, `id`, `who`, `w`, `last`.
4. Resources snapshot: `free`, `lscpu`, `lsmem`, `uptime`.
5. Hardware peek: `lsusb`, `lsmod`, `hwinfo` (deeper inventory is in Hardware).

## Related parts

- Hardware — PCI/DMI/disk identity tools
- Processes and jobs — live load after identity checks
- Services and runtime — other systemd `*ctl` tools

Continue with the individual command pages in this part.
