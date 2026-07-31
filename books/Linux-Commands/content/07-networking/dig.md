# dig

## Overview
`dig` (Domain Information Groper) queries DNS servers. Preferred over `nslookup` for scripting and clear output.

## Syntax
```bash
dig [@server] [name] [type] [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `@server` | Query specific resolver |
| `A`/`AAAA`/`MX`/`TXT`/`NS`/`CNAME`/`SOA` | Record types |
| `+short` | Minimal answer |
| `+trace` | Path from root |
| `+noall +answer` | Only answer section |
| `-x addr` | Reverse lookup |
| `+time=s` / `+tries=n` | Timeouts |

## Examples with Explanations
### Basic A record
```bash
dig example.com
dig +short example.com
```

### Specific types
```bash
dig example.com MX
dig example.com TXT +short
dig example.com AAAA
```

### Chosen resolver
```bash
dig @1.1.1.1 example.com
dig @8.8.8.8 example.com +short
```

### Reverse DNS
```bash
dig -x 1.1.1.1 +short
```

### Trace delegation
```bash
dig +trace example.com
```

### Batch
```bash
dig +noall +answer example.com google.com
```

## Related Commands
- `host` — simpler CLI  
- `nslookup` — interactive legacy  
- `resolvectl query` — systemd-resolved  
- `getent hosts` — NSS path
