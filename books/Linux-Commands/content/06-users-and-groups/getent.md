# getent

## Overview

`getent` queries **Name Service Switch (NSS)** databases—the same view applications get via glibc: local files, LDAP/SSSD, mDNS, DNS for hosts, and more. Prefer it over `cat /etc/passwd` when directory services or nsswitch plugins are in play.

## Syntax

```bash
getent [options] database [key ...]
```

## Common Databases

| Database | Purpose |
|----------|---------|
| `passwd` | Users |
| `group` | Groups |
| `shadow` | Shadow passwords (privileged) |
| `hosts` | Host lookup |
| `ahosts` / `ahostsv4` / `ahostsv6` | getaddrinfo-style |
| `services` | Service name ↔ port |
| `protocols` | Protocol names |
| `networks` | Network names |
| `aliases` | Mail aliases (if used) |
| `ethers` | Hardware addresses (rare) |

## Common Options

| Option | Description |
|--------|-------------|
| `-s SERVICE` | Force NSS service |
| `-i` | Case insensitive where supported |

## Key Use Cases

1. Confirm a user exists in LDAP/SSSD, not only locally
2. Script portable account lookups
3. Debug host resolution order (files/dns)
4. Map service names to ports

## Examples with Explanations

### Users and groups

```bash
getent passwd alice
getent passwd 1000
getent group sudo
getent group 27
```

### Hosts

```bash
getent hosts example.com
getent ahosts example.com
getent hosts 1.1.1.1
```

### Services

```bash
getent services ssh
getent services 443/tcp
```

### One-liner recipes

```bash
# Does this UID resolve?
getent passwd 1001 || echo 'unknown uid'

# Members visible via NSS
getent group developers

# Compare file vs NSS
getent passwd alice; grep '^alice:' /etc/passwd || true

# nsswitch insight
cat /etc/nsswitch.conf
```

## Notes & Pitfalls

- Empty result means “not found in any configured source,” not necessarily “query error.”
- `shadow` access is restricted; applications should use proper auth APIs.
- Host lookups follow `nsswitch.conf`—may never touch DNS if `files` hits first.
- Enumerating all LDAP users with bare `getent passwd` can be huge or disabled—don’t DoS your directory.

## 2026-relevant notes

- SSSD/FreeIPA/Azure AD-ish integrations still show up through NSS; `getent` is the smoke test.
- For DNS-only questions use `dig`/`resolvectl`; `getent hosts` includes non-DNS sources.
- Containers often have minimal passwd; UIDs from the host may not resolve by name inside.

## Related Commands

- `id` — UIDs/GIDs for a user
- `passwd` / `usermod` — local account changes
- `dig` / `resolvectl` — pure DNS
- `getent` vs `cat /etc/passwd` — NSS is authoritative for apps

## Additional Resources

- `man getent`, `man nsswitch.conf`
