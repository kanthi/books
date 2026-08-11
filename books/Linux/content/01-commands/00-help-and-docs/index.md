---
title: Intro
---

# Intro

This part covers how to find answers **on the system itself** before searching the web. Offline docs match the versions you actually installed — critical when flags change between releases.

## Commands in this part

| Command | Role |
|---------|------|
| `man` | man displays the system manual. |
| help (shell builtin) | help shows documentation for shell builtins — commands implemented inside the shell itself (cd, export, read, [[,… |
| `info` | info reads documentation in Info (Texinfo) format. |
| `apropos` | apropos searches man page names and short descriptions for keywords. |
| `whatis` | whatis prints single-line descriptions from the man-db whatis index. |


## Suggested starting points

1. Quick hint: `whatis cmd` or `cmd --help`.
2. Full story: `man cmd` (try section 5 for configs, 8 for admin tools).
3. Forgot the name: `apropos keyword`, then open the best hit with `man`.
4. Shell builtin: `type cmd`, then `help cmd` if it is a builtin.
5. GNU deep dive: `info` for coreutils, bash, and related tools.

## Related parts

- `type` / `command -v` (Shell commands) — resolve names
- Book introduction — how pages are structured

Continue with the individual command pages in this part.
