# getent

## Overview
`getent` queries Name Service Switch databases (passwd, group, hosts, services, …) so you see the same view applications get — including LDAP/SSSD — not only local files.

## Syntax
```bash
getent [options] database [key ...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `passwd` | User accounts |
| `group` | Groups |
| `hosts` | Host name lookups |
| `services` | Service name/port map |
| `shadow` | Shadow passwords (root; if permitted) |
| `aliases / networks / protocols` | Other NSS DBs |

## Key Use Cases
1. Resolve users beyond /etc/passwd
2. Debug NSS/LDAP identity
3. Script portable account lookups
4. Check host resolution order

## Examples with Explanations
### User record
```bash
getent passwd alice
getent passwd 1000
```
Works for local and directory-backed users.

### Group membership list
```bash
getent group sudo
```
See group line as NSS returns it.

### Host lookup
```bash
getent hosts example.com
getent ahosts example.com
```
Reflects nsswitch/DNS configuration.

### Service port
```bash
getent services ssh
```
Name↔port mapping from services DB.

## Related Commands
- `id` — UIDs/GIDs for a user
- `getent` vs `cat /etc/passwd` — NSS is authoritative for apps
- `hostnamectl` / `resolvectl` — host/DNS stack
