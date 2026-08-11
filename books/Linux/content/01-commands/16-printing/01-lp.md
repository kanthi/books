# lp

## Overview

`lp` submits print jobs to a **CUPS** (or compatible) printing system. It is the System V-style print command; `lpr` is the BSD-style counterpart. Use `lpstat`, `cancel`/`lprm`, and `lpoptions` for queue management. On headless servers without CUPS, these tools may be absent.

## Syntax

```bash
lp [options] [file...]
lp [options] -
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d printer` | Destination printer/queue |
| `-n copies` | Number of copies |
| `-o option=value` | Printer options (media, sides, …) |
| `-q priority` | Job priority (1–100) |
| `-t title` | Job title |
| `-y` | Content type options (implementation) |
| `-H HH:MM` | Hold until time |
| `-P pages` | Page ranges |
| `-s` | Silent (no job id message) |
| `-E` | Encrypt when connecting to CUPS (when supported) |

## Examples with Explanations

### Print files

```bash
lp file.pdf
lp -d Office_Laser report.pdf
echo 'hello' | lp -d printername
```

### Copies and options

```bash
lp -n 2 -o sides=two-sided-long-edge file.pdf
lp -o media=A4 -o fit-to-page poster.pdf
lp -o media=Letter -o ColorModel=Gray file.pdf
```

### Page ranges

```bash
lp -P 1-4,7 file.pdf
```

### List printers and status

```bash
lpstat -p -d
lpstat -t
lpoptions -l
```

### Cancel jobs

```bash
lpstat -o
cancel job-id
# or
lprm job-id
```

### Default printer

```bash
lpoptions -d Office_Laser
echo $PRINTER
```

### CUPS service

```bash
systemctl status cups
# web UI often http://localhost:631
```

## Notes / Pitfalls

- Option names depend on the printer’s PPD/driver — `lpoptions -l` is authoritative.
- PDF/image handling may pass through filters; broken drivers show as filter errors in CUPS logs.
- Network printers: queue exists even when device is offline — jobs may sit pending.
- Permissions: users must be allowed on the CUPS share.
- No CUPS → install `cups` / `cups-client` or use vendor tools.

## 2026-relevant notes

- IPP Everywhere and driverless printing reduce proprietary driver pain on modern distros.
- Headless CI machines rarely need `lp`; keep docs for workstation/admin hosts.
- For raw JetDirect hacks, still prefer CUPS queues over unauthenticated TCP 9100 when possible.

## Related Commands

- `lpr` — BSD-style submit
- `lpstat` — status
- `cancel` / `lprm` — remove jobs
- `lpoptions` — defaults/options
- `cupsaccept` / `cupsenable` — admin queue control

## Additional Resources

- `man lp`, `man lpoptions`
- CUPS documentation at cups.org / local `/usr/share/doc/cups`
