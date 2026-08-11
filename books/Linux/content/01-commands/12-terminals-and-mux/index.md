---
title: Intro
---

# Intro

Keep shells alive across disconnects, split panes, and share sessions. `tmux` is the usual default; `screen` remains common on older hosts.

## Commands in this part

| Command | Role |
|---------|------|
| `tmux` | tmux is a terminal multiplexer: multiple windows and panes inside detachable sessions that survive SSH disconnects. |
| `screen` | screen is the classic terminal multiplexer: detachable sessions that survive hangups. |
| `byobu` | The byobu command is a text-based window manager and terminal multiplexer. |
| `tmate` | tmate is a fork of tmux focused on instant terminal sharing. |
| `abduco` | abduco is a minimal session attach/detach tool: it runs a process under a controlling terminal session you can… |


## Suggested starting points

1. Daily driver: `tmux` (sessions, windows, panes).
2. Legacy hosts: `screen`.
3. Convenience wrappers: `byobu`.
4. Remote pair/share: `tmate`; minimal attach tools: `abduco`.

## Related parts

- Networking — `ssh` into the host first
- Processes and jobs — reattach instead of losing long jobs
- Shell commands — history inside each pane

Continue with the individual command pages in this part.
