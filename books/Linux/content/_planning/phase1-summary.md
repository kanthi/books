# Phase 1 — Dedupe summary

**Goal:** Collapse the dual taxonomy (parts `00–11` vs parallel `13–28`) into a single command home per basename.

## Removed parts

| Removed | Merged into |
|---------|-------------|
| `08-filesystem-management` | `13-filesystem` |
| `14-archive` | `02-archiving-compression` |
| `15-documentation` | `00-help-documentation` |
| `18-network` | `07-networking` (+ moved `curl`, `tcpdump`) |
| `19-process` | `04-process-management` |
| `20-performance` | `05-system-monitoring` / `03-system-information` |
| `21-system-info` | `03-system-information` (+ moved `lsb_release`) |
| `22-user-management` | `06-user-group-management` |
| `25-scheduling` | `09-scheduling` |
| `26-logging` | `10-logging` |

## Internal dedupes (same basename, two primaries)

- `df` / `du` → keep `01-file-directory-management`
- `head` / `tail` → keep `17-text-processing`
- `top` → keep `04-process-management` (dropped from `05`)
- `free` → keep `03-system-information`
- `iostat` / `mpstat` / `sar` / `vmstat` → keep `05-system-monitoring`
- `lspci` → keep `11-hardware-management`
- Thin `18-network/nmap.md` dropped in favor of `99-miscellaneous/01-nmap.qmd`

## Housekeeping

- `content/template.md` → `content/_planning/command-page-template.md` (not a chapter)

## Result

- **Before:** ~195 chapter files, ~28 parts, 40+ duplicate basenames  
- **After:** 152 chapter files, 18 parts, **0** basename duplicates  
- Full action log: `phase1-dedupe.log`

## Not in Phase 1 (later)

- Renumber parts (gap at `08`/`12`/`14–22`/…)  
- Rewrite `index.qmd` category map  
- Content depth / modern CLI gaps  
