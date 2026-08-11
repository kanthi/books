---
title: Intro
---

# Intro

List, prioritize, signal, and background work. Covers classic job control in the shell as well as system-wide process tools (`ps`, `top` family, `pgrep`/`pkill`).

## Commands in this part

| Command | Role |
|---------|------|
| `ps` | ps snapshots processes. |
| `pstree` | pstree shows running processes as a tree, making parent/child relationships obvious — ideal for seeing what a… |
| `top` | top is the classic interactive process monitor: CPU, memory, and a live-sorted process table. |
| `htop` | htop is an interactive process viewer with a clearer UI than classic top: mouse support, tree view, easy… |
| `procs` | procs is a modern replacement for ps written in Rust, with colorized output, tree views, keyword highlighting, and… |
| `pgrep` | pgrep lists process IDs matching selection criteria (name, full command line, user, terminal, etc.). |
| `pidof` | pidof prints the PIDs of running programs matched by name. |
| `kill` | kill sends a signal to one or more processes by PID. |
| `killall` | killall sends a signal to all processes matching a command name. |
| `jobs` | jobs lists active jobs of the current shell: running background tasks, stopped jobs, and their job IDs. |
| `fg` | fg resumes a job in the foreground, giving it the terminal again (stdin/stdout/signals). |
| `bg` | bg resumes a stopped job in the background so it continues running without occupying the terminal. |
| `nohup` | nohup runs a command immune to SIGHUP, so it keeps running after you log out of a terminal session. |
| `timeout` | timeout runs a command and sends a signal if it still runs after a duration. |
| `watch` | watch runs a command repeatedly, showing fullscreen output so you can see changes over time. |
| `sleep` | sleep suspends execution for a specified time. |
| `nice` | nice starts a command with a modified CPU niceness — a soft priority bias for the scheduler. |
| `renice` | The renice command alters the scheduling priority of running processes. |
| `ionice` | ionice sets or queries the I/O scheduling class and priority of a process (Linux CFQ/BFQ-oriented interface;… |
| `fuser` | fuser lists PIDs using a file, mount point, or network port. |
| `ulimit` | ulimit is a shell builtin (bash/zsh/etc.) that shows or sets resource limits for the current shell and its child… |
| `ipcs` | ipcs lists System V IPC objects: message queues, shared memory segments, and semaphore arrays. |
| `ipcrm` | ipcrm removes System V IPC objects: shared memory segments, semaphore arrays, and message queues. |


## Suggested starting points

1. Inventory: `ps`, `pstree`, then interactive `top`/`htop`/`btop`.
2. Select by name: `pgrep` / `pidof` before `kill`/`killall`.
3. Job control in one shell: `jobs`, `fg`, `bg`, `nohup`.
4. Priority and I/O class: `nice`, `renice`, `ionice`.
5. Limits and IPC: `ulimit`, `ipcs`/`ipcrm`, `fuser`.

## Related parts

- System monitoring — deeper CPU/I/O tracing
- Services and runtime — prefer `systemctl` for daemons
- Shell commands — `time` while iterating

Continue with the individual command pages in this part.
