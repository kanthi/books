---
title: Intro
---

# Intro

Create and modify accounts, password aging, groups, and privilege elevation. Prefer `sudo` for policy-controlled admin work; use account tools carefully on production identity stores.

## Commands in this part

| Command | Role |
|---------|------|
| `sudo` | sudo runs a command as another user (default: root) according to policy in /etc/sudoers and /etc/sudoers.d/*. |
| `visudo` | visudo safely edits the sudoers configuration (/etc/sudoers and files under /etc/sudoers.d/). |
| `useradd` | useradd creates a new user account and related system entries (/etc/passwd, /etc/shadow, /etc/group as needed). |
| `usermod` | usermod modifies an existing user account: shell, home, groups, UID, lock state, expiry, and more. |
| `userdel` | userdel deletes a user account from the system. |
| `passwd` | passwd sets or changes user passwords and can lock/unlock accounts or expire passwords. |
| `chage` | chage (change age) views and modifies password aging policy for a user: last change date, minimum/maximum days… |
| `groupadd` | groupadd creates a new group entry in the local group database (/etc/group, and /etc/gshadow when used). |
| `groupmod` | groupmod modifies an existing group: rename it, change its GID, or adjust related attributes depending on the… |
| `groupdel` | groupdel deletes a group from the system group database (typically /etc/group and /etc/gshadow). |
| `getent` | getent queries Name Service Switch (NSS) databases—the same view applications get via glibc: local files, LDAP/SSSD,… |
| `su` | su (“substitute user”) starts a shell or runs a command as another user. |


## Suggested starting points

1. Elevation: `sudo`, `visudo`, `su`.
2. Accounts: `useradd`/`usermod`/`userdel`, `passwd`, `chage`.
3. Groups: `groupadd`/`groupmod`/`groupdel`.
4. Lookups: `getent` (works with NSS/LDAP backends, not only local files).

## Related parts

- Security — SELinux contexts when access still fails
- Files and paths — ownership and modes
- Services and runtime — run daemons as dedicated users

Continue with the individual command pages in this part.
