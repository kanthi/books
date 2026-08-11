---
title: Intro
---

# Intro

Install and maintain software with distro package managers used on servers. Ubuntu/Debian: `apt`/`dpkg`; Fedora/RHEL: `dnf`/`rpm` (and legacy `yum`); optional Ubuntu `snap` for selected server tools. Desktop app stores (Flatpak, GUI software centers) are out of scope.

## Commands in this part

| Command | Role |
|---------|------|
| `apt` | apt is the friendly package manager front-end on Debian and Ubuntu. |
| `dpkg` | The dpkg (Debian Package) command is a low-level package manager for Debian-based systems. |
| `dnf` | dnf (Dandified YUM) is the primary high-level package manager on Fedora, RHEL 8+, CentOS Stream, Rocky, AlmaLinux,… |
| `rpm` | The rpm (RPM Package Manager) command is a low-level package manager for RPM-based Linux distributions. |
| `yum` | yum (Yellowdog Updater Modified) is the classic RPM package manager front-end for older RHEL/CentOS/Scientific Linux… |
| `snap` | snap installs Snap packages from the Snap Store. |

## Suggested starting points

1. Debian/Ubuntu day-to-day: `apt` (low-level: `dpkg`).
2. Fedora/RHEL: `dnf` (low-level: `rpm`; legacy: `yum`).
3. Optional on Ubuntu: `snap` only when a server tool requires snapd.

## Related parts

- Services and runtime — restart units after library upgrades
- Security — trust and third-party repos
- Files and paths — where binaries land (`which`, `dpkg -L`)

Continue with the individual command pages in this part.
