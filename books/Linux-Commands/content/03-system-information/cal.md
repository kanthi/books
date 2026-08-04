# cal

## Overview

`cal` displays a calendar in the terminal — current month by default, or a specific month/year. Handy for quick date context, scripting reminders, and verifying week boundaries. Some systems ship `ncal` with alternate layouts.

## Syntax

```bash
cal [options] [[[day] month] year]
cal [options] [[month] year]
cal [options] -y [year]
```

Exact syntax variants exist between util-linux `cal` and BSD-style `cal`/`ncal`.

## Common Options (util-linux / common)

| Option | Description |
|--------|-------------|
| `-1` / `-3` | One month / three months |
| `-y` | Whole year |
| `-m` | Monday as first day of week |
| `-s` | Sunday first (when supported) |
| `-w` | Week numbers |
| `-j` | Julian day numbers |
| `-A n` / `-B n` | Months after / before |
| `-h` | Highlight off (or help, depending on version) |
| `--color` | Colorize today (newer) |

Check `cal --help` on your host.

## Examples with Explanations

### Current month

```bash
cal
cal -3
cal -m
cal -w
```

### Specific month / year

```bash
cal 12 2026
cal 2026
cal -y 2026
```

### Week numbers for planning

```bash
cal -w
cal -mw 9 2026
```

### Surrounding months

```bash
cal -A 1 -B 1
cal -3
```

### Historical curiosity

```bash
cal 9 1752                 # UK calendar reform month (implementation-dependent)
```

### Scripts: parse carefully

```bash
# better for machine dates:
date +%F
date +%V                   # ISO week
# use cal for human display only
```

### ncal alternative

```bash
ncal
ncal -b
ncal -w
```

## Notes / Pitfalls

- Highlighting “today” depends on terminal and build options.
- Week-start Monday/Sunday differs by locale and flags — be explicit with `-m` when it matters.
- Do not parse `cal` output for business logic; use `date` and proper libraries.
- Year range limits differ; very ancient/future years may error.
- BusyBox `cal` is minimal.

## 2026-relevant notes

- ISO week numbers (`date +%V`, `cal -w`) still matter for release trains and on-call rotations.
- Prefer `date` for automation; keep `cal` as a human aid over SSH.
- Terminal Unicode width issues can misalign rare locales.

## Related Commands

- `date` — current date/time formatting
- `ncal` — alternate calendar view
- `timedatectl` — timezone/NTP status
- `calendar` — reminder file tool (if installed)
- `hwclock` — hardware clock

## Additional Resources

- `man cal`, `man ncal`
