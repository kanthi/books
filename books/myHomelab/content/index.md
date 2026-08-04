# Welcome to My Homelab

An **Ubuntu-first** handbook for building and operating a practical hybrid homelab: Proxmox at the edge, Ubuntu 24.04 LTS as the standard guest OS, and an Azure Ubuntu VPS as a cloud companion.

This is not a catalog of every self-hosted app. It is an **operating model**: charter → architecture → baseline OS → network → identity → runtimes → storage → hybrid connectivity → DNS/TLS → automation → observability → backup/DR → hardening → incidents → CI → service catalog → growth decisions → capstone evidence.

## Who this is for

- Operators with at least one machine that can run Proxmox (even an old laptop) and optional cloud budget for a small VPS.
- Readers who want **repeatable Ubuntu 24.04** practices (`cloud-init`, `systemd`, `netplan`, `apt`, `ufw`) rather than one-off GUI clicks.
- Solo or family labs that still care about backup drills, least privilege, and honest scope.

## How the book is organized

| Part | Focus |
|------|--------|
| **01 Foundations** | Vision, reference architectures, Ubuntu baseline, netplan networking, identity/secrets |
| **02 Platform and hybrid** | Runtimes, storage, Proxmox VM lifecycle, Azure Ubuntu patterns, secure overlay connectivity |
| **03 Automation and operations** | DNS/PKI/ingress, IaC/config management, observability, backup/DR, hardening/patches |
| **04 Reliability and growth** | Incidents, CI/GitOps, service catalog, scale triggers, capstone + living docs |
| **Appendices** | Distro mapping, templates, validation checklists, diagram/screenshot shotlist |

Planning depth and the original manuscript skeleton live under `content/_planning/` (not part of the published chapter spine).

## Two lab tracks

Every chapter includes:

1. **MVP track** — old laptop with Proxmox + one Azure Ubuntu VPS; smallest path that still teaches production-like habits.
2. **Advanced track** — deeper automation, drills, and scale decisions without requiring them for MVP success.

## Canonical technical path (mid-2026)

- **Guest OS:** Ubuntu **24.04 LTS** (baseline LTS for this book; treat newer LTS as optional later).
- **Edge hypervisor:** Proxmox VE current practices for Ubuntu VM templates and clones.
- **Cloud:** Azure Ubuntu VPS patterns (NSG, cloud-init, parity with edge).
- **Networking:** netplan-first guests; WireGuard-style hybrid overlay.
- **Ops core:** systemd, apt/unattended-upgrades, UFW, journald, restic-style backups.

## How to use this book

1. Write the **charter** (Chapter 01) before installing a zoo of apps.
2. Implement chapters in order for the MVP path; skip Advanced worksheets until the baseline is boringly reliable.
3. Keep a **docs git repo** alongside the lab; tag releases when capstone checks pass.
4. Prefer **rollback and restore tests** over perfect uptime theater.
5. Read HTML online, or use PDF/EPUB from the library portal when published.

## Prerequisites

- Comfortable with Linux command line and SSH.
- Willingness to use the hypervisor/cloud **console** when networking breaks.
- Budget awareness: electricity, optional domain, optional Azure VPS.

## Outcomes you should leave with

- A versioned homelab charter and architecture ADR.
- Reproducible Ubuntu 24.04 hosts on Proxmox and Azure.
- Private hybrid connectivity and a sane public ingress/TLS pattern.
- Automated config baseline, monitoring, backups with proven restore, and an incident habit.
- A service catalog and a criteria-driven growth path (including when *not* to run Kubernetes).
