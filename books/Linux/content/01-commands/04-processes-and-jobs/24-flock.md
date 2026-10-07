# flock

## Overview

**Thesis:** if two copies of a job must never run at once, take a lock. Do not rely on timing, PID files, or "it usually finishes in time". `flock` (util-linux) is the shell's interface to the kernel's `flock(2)` advisory locks. It wraps a command, or a block of a script, in a lock that the kernel releases **automatically** when the holder exits, even after `kill -9`, a crash, or a reboot. Nothing stale is left behind to clean up.

Typical operator jobs:

- Stop a cron job from piling up when a run takes longer than the interval.
- Make a deploy, backup, or sync script refuse to run twice.
- Serialize jobs that touch the same resource, such as a backup and a prune of the same repository.
- Let many readers proceed together while a writer waits for exclusive access.

```bash
# Debian/Ubuntu/Fedora: part of util-linux, installed by default
flock --version
```

```text
flock from util-linux 2.41.5
```

## Mental model

```text
 process A                        kernel                      process B
 ─────────                        ──────                      ─────────
 open("job.lock")  ──► open file description ─┐
 flock(fd, LOCK_EX) ─► lock on that description│◄── flock(fd, LOCK_EX|LOCK_NB) → EWOULDBLOCK
                                               │      (flock -n exits 1)
 fork() child ──── inherits fd ── same lock ───┘
 exit / crash  ──► last fd closed ─► lock released ──► B's blocking flock() returns
```

| Fact | Consequence |
|------|-------------|
| The lock belongs to an **open file description**, not to a PID or a file name | Every child that inherits the fd also "holds" it. The lock ends when the **last** copy of the fd closes |
| Locks are **advisory** | Only programs that also call `flock` are excluded. `cat`, `echo >>`, and editors can still write the file |
| The file's **contents are irrelevant** | An empty file is fine. The lock lives on the inode |
| Release is automatic on close or exit | No stale-lock cleanup, unlike PID files and `mkdir` locks |
| `flock(2)` and `fcntl(2)` locks are separate | `flock` and `flock --fcntl` (or Python `fcntl.lockf`, SQLite, …) do **not** exclude each other |

## Syntax

```bash
flock [options] FILE|DIR COMMAND [ARG...]    # lock, run COMMAND, unlock
flock [options] FILE|DIR -c 'SHELL STRING'   # same, through $SHELL -c (default /bin/sh)
flock [options] FD                           # lock an fd the calling shell already opened
```

| Option | Meaning |
|--------|---------|
| `-x`, `-e`, `--exclusive` | Exclusive (write) lock. **Default** |
| `-s`, `--shared` | Shared (read) lock. Many holders, but no exclusive holder at the same time |
| `-n`, `--nonblock` | Do not wait: exit at once if the lock is busy |
| `-w SECS`, `--timeout SECS` | Wait at most SECS (fractions allowed; `-w 0` = `-n`) |
| `-E N`, `--conflict-exit-code N` | Exit status for "busy" with `-n` or `-w` (default `1`) |
| `-o`, `--close` | Close the lock fd before running COMMAND, so children do **not** inherit the lock |
| `-F`, `--no-fork` | `exec` COMMAND instead of forking; COMMAND itself holds the lock (incompatible with `-o`) |
| `-u`, `--unlock` | Drop the lock on FD early (the third form) |
| `--verbose` | Report how long acquiring took, or why it failed |
| `--fcntl` | Use an OFD `fcntl(2)` lock instead of `flock(2)` (util-linux 2.41+, kernel 3.15+) |
| `--start N` / `--length N` | Lock only a byte range (implies `--fcntl`, util-linux 2.42+) |

Exit status: in the wrapping forms, the **command's** status. With `-n`/`-w`, a busy lock gives the `-E` value (default `1`). flock's own errors use `<sysexits.h>` codes (for example `64` for bad usage).

## Safety

- **Put lock files where other users cannot pre-create them.** Use `/run/lock/<name>.lock` for root jobs and `$XDG_RUNTIME_DIR/<name>.lock` for user jobs. In world-writable `/tmp` on a shared host, another user can create your lock file first and hold it forever (a denial of service).
- **Never delete the lock file "to clean up".** That breaks mutual exclusion (see Notes & Pitfalls). Leave it in place. It costs one inode.
- **Do not lock on NFS or CIFS** unless you have verified that it works there. `flock` may always fail on those filesystems, or lock only locally, depending on mount options.
- **A lock is not a timeout.** A hung holder blocks everyone forever. Pair `flock` with `-w` on the waiting side, and with `timeout` on the holding side.

## Examples with Explanations

All examples run as an ordinary user in a scratch directory:

```bash
mkdir -p /tmp/fl && cd /tmp/fl
```

### 1. Wait, fail fast, or wait a bounded time

```bash
L=/tmp/fl/demo.lock
(flock "$L" sleep 3 &) ; sleep 0.3                 # holder: keeps the lock for 3 s

flock -n "$L" echo "got it";            echo "exit=$?"
flock --verbose -n "$L" true;           echo "exit=$?"
flock --verbose -w 1.5 "$L" true;       echo "exit=$?"
flock --verbose "$L" echo "waited, then ran"; echo "exit=$?"
```

```text
exit=1
flock: failed to get lock
exit=1
flock: timeout while waiting to get lock
exit=1
waited, then ran
flock: getting lock took 1.195380 seconds
flock: executing echo
exit=0
```

By default `flock` blocks, which is what you want for "queue behind the other run". Use `-n` for "skip this run". Use `-w` for "wait a little, then give up". `--verbose` writes to stderr, so it is safe to leave on in cron jobs that mail you their output.

### 2. Tell "skipped" apart from "failed" with `-E`

```bash
(flock "$L" sleep 2 &) ; sleep 0.3
flock -n -E 75 "$L" true;      echo "exit=$?"      # busy → 75 (EX_TEMPFAIL)
flock "$L" sh -c 'exit 3';     echo "exit=$?"      # ran → command's own status
```

```text
exit=75
exit=3
```

Without `-E`, a busy lock and a command that failed with status `1` look the same to your monitoring. Pick a code the job never uses itself. `75` (`EX_TEMPFAIL`) is the conventional choice, or `0` if a skipped run should count as success.

### 3. cron: no overlapping runs

```bash
# /etc/cron.d/poll — every 5 minutes; skip quietly if the last run is still going
*/5 * * * * root flock -n -E 0 /run/lock/poll.lock /usr/local/bin/poll.sh >>/var/log/poll.log 2>&1
```

`-n -E 0` means a skipped run is not an error, so cron sends no mail. Drop `-n` if runs should **queue** instead. Watch out, though: a job that is always slower than its interval then builds an ever-growing queue of waiting `flock` processes.

Under a **systemd timer** you do not need `flock` to stop a job overlapping *itself*. systemd will not start a unit that is still active. You still need it for **cross-job** exclusion, such as a backup and a prune of the same repository, or a timer run and a manual run.

### 4. Lock a whole script from the inside (file-descriptor form)

```bash
#!/usr/bin/env bash
# nightly-sync.sh — refuses to run twice; lock lives as long as this shell
set -euo pipefail
LOCK="${XDG_RUNTIME_DIR:-/tmp}/nightly-sync.lock"

exec 9>"$LOCK"                       # open (create) the lock file on fd 9
if ! flock -n 9; then
  echo "nightly-sync: another run holds $LOCK, skipping" >&2
  exit 0                             # a skipped run is not a failure
fi

echo "nightly-sync: started as PID $$"
sleep "${1:-5}"                      # stand-in for the real work
echo "nightly-sync: done"
```

```bash
chmod +x nightly-sync.sh
./nightly-sync.sh 4 & sleep 0.5
./nightly-sync.sh 1; echo "exit=$?"
wait
```

```text
nightly-sync: started as PID 343505
nightly-sync: another run holds /tmp/nightly-sync.lock, skipping
exit=0
nightly-sync: done
```

`exec 9>FILE` opens the file in the current shell. `flock -n 9` locks that open description and exits, but the **shell** keeps fd 9 open, so the lock lasts until the script ends. Open the file with `>` or `>>` so it is created if missing (that needs write permission), or with `<` when it already exists and you only have read access. Release early with `flock -u 9` if the tail of the script does not need the lock.

To lock only a critical section, use a subshell, and the lock ends when the subshell ends:

```bash
(
  flock -w 10 9 || { echo "busy" >&2; exit 1; }
  # ... commands that must not run concurrently ...
) 9>/run/lock/critical.lock
```

### 5. Self-locking script boilerplate

```bash
#!/usr/bin/env bash
# selflock.sh — locks itself on first run (boilerplate from flock(1))
[ "${FLOCKER:-}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :
echo "selflock: working as PID $$"
sleep 2
```

```bash
chmod +x selflock.sh
./selflock.sh & sleep 0.3; ./selflock.sh; echo "second exit=$?"; wait
```

```text
selflock: working as PID 345323
second exit=1
```

On the first run, `FLOCKER` is unset, so the script re-executes itself under `flock -en`, using **its own file** as the lock. The second copy finds the lock busy and exits `1` silently. This form needs no lock path, but anyone who can read the script can also hold its lock. Keep it for scripts you own.

### 6. Many readers, one writer

```bash
flock -s rw.lock sh -c 'echo "reader 1 in"; sleep 2' &
flock -s rw.lock sh -c 'echo "reader 2 in"; sleep 2' &
sleep 0.3
flock -n -x rw.lock echo "writer in"; echo "writer -n exit=$?"
flock --verbose -x rw.lock echo "writer in"
wait
```

```text
reader 2 in
reader 1 in
writer -n exit=1
writer in
flock: getting lock took 1.699388 seconds
flock: executing echo
```

Both shared holders run together. The exclusive writer waits until the last reader leaves. A typical use: report jobs take `-s` on a data directory, and the nightly rebuild takes `-x` on the same lock file.

### 7. Who is holding the lock?

In the wrapping form, the long-lived `flock` process owns the lock, and `lslocks` shows it:

```bash
flock /tmp/fl/demo.lock sleep 3 & sleep 0.3
lslocks -o COMMAND,PID,TYPE,MODE,PATH | awk 'NR==1 || /demo.lock/'
```

```text
COMMAND            PID  TYPE MODE  PATH
flock           344271 FLOCK WRITE /tmp/fl/demo.lock
```

In the fd form (example 4), the `flock` process that took the lock has already exited. Ask instead which processes have the **file open**. That is every holder, including inherited children:

```bash
./nightly-sync.sh 3 >/dev/null & sleep 0.3
fuser -v /tmp/nightly-sync.lock
```

```text
                     USER        PID ACCESS COMMAND
/tmp/nightly-sync.lock:
                     box       344275 F.... bash
                     box       344278 F.... sleep
```

The `sleep` child appears too: it inherited fd 9. That matters for the trap below.

### 8. `-F`, directories, and `-c`

```bash
mkdir -p state && flock -n state echo "locked a directory"
flock -F -n f.lock sh -c 'echo "PID $$ holds the lock itself"; ls -l /proc/$$/fd | grep f.lock | sed "s/.*-> //"'
```

```text
locked a directory
PID 345416 holds the lock itself
/tmp/fl/f.lock
```

A directory works as a lock target, because `flock` opens it read-only. That is handy for "lock the data dir" conventions. `-F` replaces `flock` with the command, so no extra process sits in the tree, and signals go straight to the command. That suits supervisors that track the main PID.

### 9. `--fcntl` locks are a different lock

```bash
flock x.lock sleep 2 & sleep 0.2
flock -n --fcntl x.lock echo "fcntl lock acquired despite flock(2) holder"; echo "exit=$?"
flock -n x.lock echo nope; echo "exit=$?"
wait
```

```text
fcntl lock acquired despite flock(2) holder
exit=0
exit=1
```

Use `--fcntl` only when you must interoperate with programs that use `fcntl`/`lockf` locks on the same file, such as a Python or C daemon. Every participant must use the **same** lock family. util-linux 2.42 adds `--start`/`--length` for byte-range locks of this kind.

## The trap

**A background child inherits the lock, and keeps it after `flock` has exited.**

```bash
#!/bin/sh
# start-worker.sh — launches a long-lived background worker, then returns
sleep 30 &                      # stand-in for a daemon that outlives this script
echo "worker started as PID $!"
```

```bash
chmod +x start-worker.sh
flock -n app.lock ./start-worker.sh; echo "exit=$?"
flock -n app.lock echo "second run"; echo "exit=$?"
fuser -v app.lock
```

```text
worker started as PID 344748
exit=0
exit=1
                     USER        PID ACCESS COMMAND
/tmp/fl/app.lock:    box       344748 f.... sleep
```

The wrapped script returned, and `flock` exited `0`, yet every later run is "busy" for as long as the worker lives. The worker inherited the lock fd. In a cron job this looks like "the job silently stopped running". With `-o`, the fd is closed before the command runs:

```bash
fuser -k app.lock >/dev/null 2>&1           # kill the stray worker from the first run
flock -n -o app.lock ./start-worker.sh; echo "exit=$?"
flock -n app.lock echo "second run";    echo "exit=$?"
```

```text
worker started as PID 344757
exit=0
second run
exit=0
```

Choose deliberately:

- `-o`: the lock covers only the **launch**. The worker runs unprotected.
- No `-o`: the lock lasts as long as the **worker**. The worker should be the one that takes the lock (`flock -F`, or the fd form inside it).
- In the fd form, start background helpers with the fd closed: `helper 9>&- &`.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| Deleting the lock file while it is held | A new run creates a **new inode** and gets its own "exclusive" lock alongside the old holder. Demo: holder A runs, `rm job.lock`, then `flock -n job.lock …` succeeds. Never `rm` lock files; use `/run/lock`, which is cleared at boot |
| Expecting the lock to stop writes | Locks are advisory. `echo x >> job.lock` succeeds while it is held. Every cooperating program must call `flock` |
| Lock file in shared `/tmp` | Another user can pre-create and hold it. Use `/run/lock` or `$XDG_RUNTIME_DIR` |
| `flock -n 9` but forgot `exec 9>file` | `flock: 9: Bad file descriptor` (exit `65`). Open the fd first, in the **same** shell (not a pipeline subshell) |
| Busy and failed both exit `1` | Add `-E 75` (or `-E 0` for silent skips) |
| Blocking `flock` in a fast cron interval | Waiting `flock` processes pile up behind a slow run. Use `-n` or `-w` |
| NFS/CIFS home directories | Locks fail or are local-only. Keep lock files on local disk or tmpfs |
| Mixing `flock` with `--fcntl`/`lockf` users | No mutual exclusion. Standardize on one family per lock file |
| `-o` with `-F` | `flock: the --no-fork and --close options are incompatible` (exit `64`): nothing would be left holding the lock |
| Stuck holder | Find it with `lslocks` (wrapper form) or `fuser -v FILE` (fd form), then decide whether to kill it |

## The boring rule

> One job, one lock file under `/run/lock` (or `$XDG_RUNTIME_DIR`), never deleted. Cron jobs use `flock -n -E 0` (or `-E 75` if skips should page). Scripts lock themselves with `exec 9>…; flock -n 9`. Anything that backgrounds a child either uses `-o` or makes the child the lock holder. Diagnose with `lslocks` and `fuser -v`, never by guessing.

## Related Commands

| Command | Role |
|---------|------|
| `lslocks` | List file locks held on the system, with the holder's command and PID |
| `fuser -v FILE` | Show every process with the lock file open, including inherited fds |
| `timeout` | Bound how long a lock holder may run (`flock L timeout 30m job`) |
| `systemd-run --on-calendar` / timers | Scheduled units that never overlap themselves |
| `cron`, `crontab` | Classic scheduler; pair with `flock -n` |
| `lsof FILE` | Alternative to `fuser` for open-file inspection |

## Try this

1. Add `flock -n -E 0 /run/lock/<job>.lock` in front of your longest-running cron job. Run it twice by hand at the same moment and confirm the second run exits `0` without doing any work.
2. Convert a script that writes a PID file into the fd form (`exec 9>…; flock -n 9`). Kill it with `kill -9` and confirm the next run starts immediately, with no stale-file cleanup.
3. Reproduce the trap with `start-worker.sh`, then fix it twice: once with `-o`, and once by making the worker take the lock itself with `flock -F`.
4. Build a reader/writer pair: two `flock -s` report loops and one `flock -x` rebuild with `-w 30`. Watch `lslocks` while they contend.
5. Show yourself why deleting lock files is unsafe: start a holder, `rm` the lock file, take the lock again, and list both holders with `lslocks`.

## Sources

- [flock(1)](https://man7.org/linux/man-pages/man1/flock.1.html): util-linux manual (options, exit status, `FLOCKER` boilerplate, NFS/CIFS notes)
- [flock(2)](https://man7.org/linux/man-pages/man2/flock.2.html): kernel semantics (open file descriptions, inheritance across `fork`, advisory locking)
- [util-linux v2.41 release notes](https://www.kernel.org/pub/linux/utils/util-linux/v2.41/v2.41-ReleaseNotes) (`--fcntl`) and [v2.42 release notes](https://www.kernel.org/pub/linux/utils/util-linux/v2.42/v2.42-ReleaseNotes) (byte-range `--start`/`--length`)
- [lslocks(8)](https://man7.org/linux/man-pages/man8/lslocks.8.html), [fuser(1)](https://man7.org/linux/man-pages/man1/fuser.1.html)
