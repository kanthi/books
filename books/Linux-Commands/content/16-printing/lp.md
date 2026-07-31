# lp

## Overview
`lp` submits print jobs to **CUPS**. Companion tools: `lpstat`, `lpq`, `lprm`, `cancel`.

## Syntax
```bash
lp [options] [file...]
lpstat [options]
```

## Common Options (`lp`)
| Option | Description |
|--------|-------------|
| `-d printer` | Destination queue |
| `-n N` | Copies |
| `-o media=A4` | Driver options |
| `-o sides=two-sided-long-edge` | Duplex |
| `-t title` | Job title |
| `-P pages` | Page ranges |
| `-q priority` | 1–100 |

## Examples with Explanations
### Print
```bash
lp document.pdf
lp -d Office_Laser report.pdf
lp -n 2 -o sides=two-sided-long-edge slides.pdf
echo 'hello' | lp -t test
```

### Queues and jobs
```bash
lpstat -p -d          # printers + default
lpstat -o              # outstanding jobs
lpq -P Office_Laser    # BSD-style queue
cancel job-id
lprm                   # remove your jobs (BSD style)
```

### Discover printers
```bash
lpstat -a
lpinfo -v              # backends (admin)
```

## Notes
- Default printer: `lpoptions -d name` or `lpstat -d`.  
- Many desktops also use GTK/Qt print dialogs.  
- Server config: `cupsd`, `http://localhost:631`.

## Related Commands
- `lpr` — BSD-style submit  
- `cupsaccept` / `cupsenable` — admin  
- `systemctl status cups`
