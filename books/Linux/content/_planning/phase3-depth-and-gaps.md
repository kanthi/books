# Phase 3 — Depth + gap fill (re-applied 2026-08)

Re-applied after accidental `git restore` / `git clean` wiped uncommitted work.

## Goals

- Operator-practical depth on thin high-value pages
- Fill missing high-value commands
- Numeric prefixes on all parts
- Upgrade shared author template

## Template

- Rewrote `command-page-template.md` with Core/Standard/Light tiers

## Deepened (Tier 1 + Tier 2)

### Networking
`rsync`, `scp`, `wget`, `ping`, `dig`, `tcpdump`, `nc`, `traceroute`

### Processes
`kill`, `killall`, `top`, `htop`, `nohup`, `timeout`, `watch`, `nice`, `ionice`, `pgrep`

### Text
`xargs`, `sort`, `uniq`, `tee`

### Mux / packages / power / users
`tmux`, `screen`, `dnf`, `shutdown`, `useradd`, `usermod`, `groupadd`

### Storage
`lsblk`, `fdisk`, `mkfs`, `umount`, `blkid`, `findmnt`, `fsck`

### Monitoring / hardware / logging / time
`vmstat`, `iostat`, `mpstat`, `sar`, `strace`, `lsof`, `dmidecode`, `lspci`, `logrotate`, `timedatectl`

## New pages

### Files / integrity / ACLs
`34-sha256sum`, `35-base64`, `36-cmp`, `37-getfacl`, `38-chattr`, `39-xxd`, `40-strings`

### Storage
`dd`, `sync`

### Networking
`openssl`, `nft`

### Shell commands (part `16-shell-commands`)
`echo`, `printf`, `history`, `type`, `export`, `time`, `pushd`

## Numeric prefixes

All parts use pedagogical `NN-command.ext` order (see plan). Appendices `01-` / `02-`.

## Index script

`scripts/update-index.sh` sorts `.md` and `.qmd` together by basename so mixed extensions keep `NN-` order. `nmap` converted to `.md`.

## Follow-ups (optional)

- Appendix nmap granite rewrite/drop
- `lpq`/`lpstat` for printing
