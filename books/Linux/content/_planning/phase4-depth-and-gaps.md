# Phase 4 — Depth + gap fill (2026-08)

## Goals

- Deepen thin **Core** operator pages to template tiers (named examples, safety, pitfalls)
- Rewrite list-style scheduling pages into practical workflows
- Fill high-value missing commands for day-2 admin (LVM, LUKS, SSH keys, SELinux, snaps, …)
- Keep pages Ubuntu-first; note Fedora/RHEL where tools differ

## Deepened (rewrite / major expand)

| Area | Pages |
|------|--------|
| Text | `awk`, `sed`, `jq` |
| Auth | `sudo` |
| Processes | `ps` |
| Network | `ss`, `curl` |
| Storage | `mount` |
| Packages | `apt` |
| Services | `systemctl`, `journalctl` |
| Scheduling | `cron`, `crontab` |

## New pages

### Files / paths
`lsattr`, `namei`, `umask`

### Users
`su`

### Networking
`ssh-keygen`, `ssh-copy-id`, `sftp`, `ethtool`, `firewall-cmd`

### Archives
`zcat`, `zgrep`

### Storage / filesystems
`parted`, `wipefs`, `smartctl`, `pvs`, `vgs`, `lvs`, `cryptsetup`, `resize2fs`, `tune2fs`, `ncdu`

### Monitoring
`ltrace`

### Packages
`snap` (server-oriented; flatpak removed as desktop-scoped)

### Services / runtime
`systemd-run`, `systemd-analyze`, `loginctl`, `modprobe`

### Printing
*(removed — out of server/CLI scope)*

### Text
`pv`

### Security (new part `18-security`)
`getenforce`, `setenforce`, `restorecon`, `getcap` (incl. setcap)

## Index / landing

- Regenerated `_quarto.yml` via `scripts/update-index.sh`
- Updated `index.qmd` parts table for new areas

## Explicit non-goals this pass

- Full LVM tutorial unit beyond command pages
- AppArmor deep dive (pointer only from SELinux pages)
- Shell programming (stays in Linux-ShellScripting-Bash)
- Kubernetes / cloud CLIs

## Follow-ups (optional)

- Deepen remaining Standard pages still ~100 lines that are Core-adjacent (`ip`, `find`, `grep`, `tar`, `nft`)
- Add `xfs_growfs`, `semanage`, `setsebool`, `ssh-agent`, `gpg`, `rclone`
- Expand `podman` further or split compose/quadlet
- Keep scope on general + server CLI (no new desktop/GUI pages)

## Part index consistency (2026-08)

Every part under `content/` now has `index.md` as the first sidebar entry, labeled **Intro** (YAML `title: Intro` + H1) so it does not duplicate the part name:

- Overview paragraph
- Commands table (role from page Overview)
- Suggested starting points
- Related parts

`scripts/update-index.sh` already prefers `index.md` / `index.qmd` before numbered chapters — no script change required.
