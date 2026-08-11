# netstat

## Overview

`netstat` displays network connections, listening sockets, routing tables, and interface statistics from the legacy **net-tools** suite. On modern Linux, prefer **`ss`** (sockets) and **`ip`** (routes/links). `netstat` remains useful when reading older documentation or working on systems that still ship it.

## Syntax

```bash
netstat [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t` / `-u` | TCP / UDP |
| `-l` | Listening sockets |
| `-a` | All sockets |
| `-n` | Numeric addresses (no DNS) |
| `-p` | Process PID/name (may need root) |
| `-r` | Routing table |
| `-i` | Interfaces |
| `-s` | Statistics |
| `-c` | Continuous refresh |
| `-w` | RAW sockets |
| `-x` | Unix sockets |
| `-e` | Extended |
| `-4` / `-6` | Address family |

Classic combo: `netstat -tulpn` for listening TCP/UDP with PIDs.

## Examples with Explanations

### Listening services

```bash
netstat -tulpn
netstat -tlnp
# modern:
ss -tulpn
```

### Established connections

```bash
netstat -tn
netstat -tp
ss -tp
```

### Routing

```bash
netstat -rn
ip route
```

### Interfaces / stats

```bash
netstat -i
netstat -s | less
ip -s link
```

### Continuous

```bash
netstat -ct
watch -n1 'ss -tnp'
```

### Translate old → new

| Old | New |
|-----|-----|
| `netstat -tulpn` | `ss -tulpn` |
| `netstat -tn` | `ss -tn` |
| `netstat -rn` | `ip route` |
| `netstat -i` | `ip -s link` / `ip -br link` |
| `netstat -s` | `nstat` / `ss -s` / `/proc/net` |

## Notes / Pitfalls

- Not installed by default on many minimal distros (`net-tools` package).
- DNS reverse lookups without `-n` make output slow — prefer `-n`.
- `-p` requires privileges for others’ processes.
- Output format is for humans; parse carefully or use `ss -H`/`ip -j`.
- Namespace-aware debugging needs `ip netns exec` + `ss`.

## 2026-relevant notes

- Muscle memory migration to `ss`/`ip` is complete for most ops teams; learn netstat only for translation.
- eBPF-based tools (`bpftool`, Pixie, etc.) go deeper than either for advanced tracing.
- Containers: check sockets **inside** the correct network namespace.

## Related Commands

- `ss` — modern socket statistics
- `ip` — routes and links
- `lsof -i` — files/sockets by process
- `nstat` — network counters
- `nmap` — external port scans (authorized)

## Additional Resources

- `man netstat` (if installed), `man ss`, `man ip`
