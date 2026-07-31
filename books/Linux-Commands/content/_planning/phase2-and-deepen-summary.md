# Phase 2 + content deepen summary

## Phase 2 — renumber

Sequential parts:

- `00-help-and-docs`
- `01-files-and-paths`
- `02-archives-and-compression`
- `03-system-information`
- `04-processes-and-jobs`
- `05-system-monitoring`
- `06-users-and-groups`
- `07-networking`
- `08-scheduling`
- `09-logging`
- `10-hardware`
- `11-storage-and-filesystems`
- `12-terminals-and-mux`
- `13-text-and-pipes`
- `14-packages`
- `15-services-and-runtime`
- `16-printing`
- `99-appendices`

Also: moved `nmap` into networking; removed appendix `stat` duplicate; help `README.md` → `index.md`; rewrote root `index.qmd`.

## New command pages

`jq`, `zstd`, `nmcli`, `ufw`, `sudo`, `pgrep`/`pkill`, `lsof`, `umount`, `paste`, `column`, `last`, `getent`, `resolvectl`, `fuser`, `install`, `comm`

## Deepened pillars

`find`, `ip`, `ss`, `grep`, `systemctl`, `journalctl`, `curl`, `ssh`, `chmod`, `rm`, `tar`, `ps`, `awk`, `sed`, `apt`, `mount`, `ls`, `df`, `du`, `rsync`, `dig`, `kill`, `top`, `tcpdump`, `wget`, `xargs`

Plus **Additional Examples** sections on many thinner pages.

## Follow-ups

- Optional: drop or rewrite `99-appendices/02-nmap-granite-llm.md`
- Optional: expand printing (`lpq`, `lpstat`), hardware, and remaining legacy pages
- Optional: numeric prefixes on chapter filenames for pedagogical order

## Deepen pass 2 (continued)

Further rewrites/expansions:

- Storage: `lsblk`, `fsck`, `fdisk`, `mkfs`, `blkid`, `findmnt`
- Monitoring: `vmstat`, `iostat`, `sar`, `mpstat`, `strace`
- Network: `nc`, `scp`, `iptables`, `ping`, `traceroute`, `host`
- Process: `htop`, `nohup`, `timeout`, `watch`, `nice`, `ionice`, `killall`
- Users/packages: `usermod`, `useradd`, `groupadd`, `dnf`
- Docs/hardware/print/sched: `man`, `help`, `whatis`, `apropos`, `lshw`, `dmidecode`, `lspci`, `lsusb`, `lp`, `at`, `logrotate`, `screen`, `tmux`
- Files/text: `chown`, `locate`, `cp`, `mv`, `ln`, `alias`, `tree`, `less`, `sort`, `uniq`, `tee`, `gzip`, `xz`
- System: `free`, `date`, `timedatectl`, `shutdown`

New pages added in this pass include: `strace`, `timedatectl`, `ionice`, `host`, `findmnt` (and strengthened `blkid`).
