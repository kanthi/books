---
title: Intro
---

# Intro

SELinux mode and file labels (Fedora/RHEL-family), Linux file capabilities, OpenPGP (`gpg`) for encrypt/sign/verify, and modern file encryption with `age`. On Ubuntu, AppArmor is more common for MAC — still useful to recognize SELinux tools on mixed fleets. Use `age` for operator file encryption (small keys, pipes, multi-recipient); use `gpg` when you need OpenPGP signatures or verifying signed checksum lists before trusting downloads.

## Commands in this part

| Command | Role |
|---------|------|
| `getenforce` | Prints the current SELinux mode: Enforcing, Permissive, or Disabled. |
| `setenforce` | Switches SELinux between Enforcing (1) and Permissive (0) until reboot (or until changed again). |
| `restorecon` | Restores the default SELinux file contexts for paths based on policy file-context rules. |
| `getcap` / `setcap` | Linux file capabilities grant subsets of root privilege to executables. |
| `gpg` | OpenPGP encrypt, decrypt, sign, and verify — keys, armored files, and signed checksum workflows. |
| `age` | Simple modern file encryption — native or SSH recipients, armor, passphrase, tar pipes. |

## Suggested starting points

1. Mode: `getenforce` / `setenforce` (temporary permissive for triage only).
2. Labels after copy/mv: `restorecon`.
3. Selective privilege on binaries: `getcap` / `setcap`.
4. Download authenticity: `gpg --verify` on signed `SHA256SUMS`, then `sha256sum -c`.
5. Encrypt a backup tarball: `age-keygen`, then `tar … \| age -r …`.

## Related parts

- Users and groups — `sudo` and accounts
- Files and paths — DAC permissions, ACLs, and `sha256sum`
- Networking — host firewalls; `openssl` for TLS cert triage

Continue with the individual command pages in this part.
