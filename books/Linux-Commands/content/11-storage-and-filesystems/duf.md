# duf

## Overview
`duf` (Disk Usage/Free Utility) is a modern replacement for `df`. It displays mounted filesystem storage, inode usage, and device stats in colored visual tables.

## Syntax
```bash
duf [options] [path...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `--all` | Include pseudo, duplicate, and inaccessible filesystems |
| `--only TYPE` | Show only specific filesystem types (e.g. `local`, `network`, `fuse`) |
| `--hide TYPE` | Hide specific filesystem types |
| `--json` | Output storage metrics as JSON |
| `--sort KEY` | Sort output table by key (`mount`, `size`, `used`, `avail`, `usage`) |

## Key Use Cases
1. Checking disk usage visually with clean bar graphs.
2. Filtering out temporary (`tmpfs`) filesystems during storage audits.
3. Exporting storage metrics to JSON for script ingestion.

## Examples with Explanations
### Example 1: View Local Filesystems Only
```bash
duf --only local
```
Displays only physical local disk mounts, excluding `tmpfs` or dev mounts.

### Example 2: Export Storage Data to JSON
```bash
duf --json
```
Outputs disk space usage data in JSON format for automated monitoring scripts.

## Related Commands
- `df` - Standard filesystem disk space utility
- `du` - Summarize disk usage of set of files
- `lsblk` - List block devices
