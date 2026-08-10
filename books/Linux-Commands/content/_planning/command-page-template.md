# Command Name

> Author guide (not published): operator-practical pages for Ubuntu-first admins.
> Prefer workflows and explained examples over man-page dumps.
> Depth tiers: **Core** (daily ops) · **Standard** · **Light** (tiny utilities).

## Overview

One or two sentences: what the command does, the job it solves, and when *not* to use it (point at a better tool if relevant).

## Syntax

```bash
command [options] [arguments]
```

## Common Options

Curated flags only (what operators actually use). Not exhaustive.

| Option | Description |
|--------|-------------|
| `-a` | … |
| `-b` | … |

## Safety

Include when the command can delete data, kill processes, change firewalls, format disks, overwrite remotes, or needs root. Skip for pure read-only tools.

## Key Use Cases

Optional short numbered list (3–5) for Core pages.

1. …
2. …

## Examples with Explanations

Use **named** `###` subsections. After each code block, 1–3 sentences: what it does and when to use it.

### Example: basic usage

```bash
command arg
```

Explanation.

### Example: realistic operator workflow

```bash
command --dry-run …
command …
```

Explanation (prefer dry-run → real-run patterns for destructive tools).

### Example: script-friendly

```bash
command -q … && echo ok
```

Explanation.

## Understanding Output

When output is non-obvious (columns, exit codes, units), explain the fields that matter for triage. Optional for simple tools.

## Notes & Pitfalls

- 2–6 bullets: locale gotchas, privilege needs, footguns, distro differences that bite.
- GNU/Ubuntu defaults; mention BusyBox/macOS only when operators hit them.

## Common Usage Patterns

Optional: pipelines or multi-flag recipes that do not fit a single example.

## Related Commands

- `other-cmd` — when to reach for it instead (prefer in-book names)

## Additional Resources

Optional:

- Man page / distro docs links
- Keep short; examples in this page are the main value

---

## Depth tiers (checklist)

| Tier | Examples | Required extras |
|------|----------|-----------------|
| **Core** | 8–15 named | Safety (if risky), output notes, pitfalls |
| **Standard** | 5–10 named | Pitfalls; safety when relevant |
| **Light** | 2–4 named | Overview + related; no essay padding |

## Style rules

1. **Scope:** general Linux CLI + **server-side** administration. No desktop/GUI apps, display servers, CUPS printing queues, Flatpak/GUI stores, or end-user desktop workflows.
2. Ubuntu 22.04/24.04 **Server**-compatible GNU userland unless noted (Fedora/RHEL noted when relevant).
3. Prefer `ip`/`ss`/`systemctl` over legacy equivalents.
4. Destructive ops: always show verify/dry-run first.
5. Shell *programming* (functions, arrays, `set -euo pipefail`) belongs in **Linux-ShellScripting-Bash**; keep one-liners only.
6. Filename = command basename with numeric prefix (`15-rsync.md`); run `bash scripts/update-index.sh` after add/rename.
7. Do not hand-edit `_quarto.yml`.
8. TUI tools (`top`, `less`, `tmux`) are fine; GUI tools are not.
