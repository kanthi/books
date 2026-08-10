---
title: Intro
---

# Intro

SELinux mode and file labels (Fedora/RHEL-family) plus Linux file capabilities. On Ubuntu, AppArmor is more common — still useful to recognize SELinux tools on mixed fleets.

## Commands in this part

| Command | Role |
|---------|------|
| `getenforce` | getenforce prints the current SELinux mode: Enforcing, Permissive, or Disabled. |
| `setenforce` | setenforce switches SELinux between Enforcing (1) and Permissive (0) until reboot (or until changed again). |
| `restorecon` | restorecon restores the default SELinux file contexts for paths based on policy file-context rules. |
| getcap / setcap | Linux file capabilities grant subsets of root privilege to executables (e.g. |


## Suggested starting points

1. Mode: `getenforce` / `setenforce` (temporary permissive for triage only).
2. Labels after copy/mv: `restorecon`.
3. Selective privilege on binaries: `getcap` / `setcap`.

## Related parts

- Users and groups — `sudo` and accounts
- Files and paths — DAC permissions and ACLs
- Networking — host firewalls

Continue with the individual command pages in this part.
