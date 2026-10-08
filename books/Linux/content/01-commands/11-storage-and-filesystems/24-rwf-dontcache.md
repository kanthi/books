---
title: "RWF_DONTCACHE (uncached buffered I/O)"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# RWF_DONTCACHE (uncached buffered I/O)

## Overview

**Thesis:** a backup, a log shipper or a one-pass scan reads or writes data it will never touch again, yet ordinary buffered I/O leaves every byte in the page cache. There it pushes out the hot data your database and services actually reuse. `O_DIRECT` avoids the cache, but it imposes alignment rules and gives up readahead and write-behind. **`RWF_DONTCACHE`** is the middle path. It is a per-call flag to `preadv2(2)`/`pwritev2(2)` (and io_uring) that keeps buffered I/O's convenience but drops the pages it brought in as soon as the I/O completes, and starts writeback immediately for writes. It is a **hint**, it is **filesystem-specific**, and on an unsupported kernel or filesystem it fails loudly with `EOPNOTSUPP`. So every caller needs a fallback, and that fallback has a trap of its own.

Typical operator jobs:

- Run backups, `rsync`-style copies and checksum scans without flushing the working set of the services on the same host.
- Write large exports or logs without building up gigabytes of dirty pages and then a writeback storm.
- Benchmark "streaming" I/O with `fio --uncached=1`.
- Decide whether a tool's `--no-cache` option will actually do anything on *this* kernel and filesystem.

Kernel support, checked against mainline source:

| Kernel | What landed |
|--------|-------------|
| 6.14 | `RWF_DONTCACHE` (`0x80`) in the UAPI and the VFS/page-cache plumbing. **No filesystem opts in yet**, so every call still returns `EOPNOTSUPP` |
| 6.15 | **XFS**, the first filesystem (`xfs: flag as supporting FOP_DONTCACHE`), plus iomap buffered-write support |
| 6.17 | **ext4** (`ext4: support uncached buffered I/O`) |
| 6.18 | **NFS client** (`NFS: Enable use of the RWF_DONTCACHE flag on the NFS client`) |
| 7.2 | Writeback improvements: targeted flusher kicks and per-bdi dirty tracking for dontcache pages |
| 7.3 (in release candidates: **v7.3-rc6** at the time of writing) | **Raw block devices** (`block: enable RWF_DONTCACHE for block devices`) |
| mainline today | Still **not** supported on btrfs, f2fs, tmpfs/shmem, FUSE or overlayfs. DAX files are refused |

## Mental model

```text
                   plain buffered          RWF_DONTCACHE                O_DIRECT
read  ──▶ page cache ──▶ user buf   page cache ──▶ user buf        device ──▶ user buf
          (pages stay; LRU decides)  (pages it added are dropped     (no cache, aligned I/O,
                                      when the copy completes)        no readahead)
write ──▶ dirty pages; writeback    dirty pages + writeback started  device directly
          later (dirty_expire, ...)  now; pages dropped when clean
```

| Fact | Consequence |
|------|-------------|
| It is **buffered** I/O | No alignment rules, readahead still works, and concurrent readers of the same range still share pages |
| Only pages **this call instantiated** are dropped | Ranges that were already cached stay cached. It never evicts someone else's hot data |
| Writes **start** writeback but do not wait for it | It is not `fsync`. Durability is unchanged, but dirty memory does not pile up |
| It is a **hint**, "best effort" | No guarantee about cache state afterwards. Do not build correctness on it |
| Support is per filesystem (`FOP_DONTCACHE`) | The same binary works on XFS, gets `EOPNOTSUPP` on btrfs, and works on ext4 only from 6.17 |
| An old kernel and an unsupported filesystem fail the same way | `EOPNOTSUPP`. The man page lists both causes. You cannot tell them apart from the error |

## Syntax

```c
#include <sys/uio.h>
#ifndef RWF_DONTCACHE              /* glibc 2.41 / linux-libc-dev 6.12 headers lack it */
# define RWF_DONTCACHE 0x00000080  /* include/uapi/linux/fs.h, Linux 6.14+ */
#endif

ssize_t preadv2 (int fd, const struct iovec *iov, int iovcnt, off_t offset, int flags);
ssize_t pwritev2(int fd, const struct iovec *iov, int iovcnt, off_t offset, int flags);
/* flags = RWF_DONTCACHE; on failure: -1, errno == EOPNOTSUPP */
```

| Interface | How to ask for uncached I/O |
|-----------|-----------------------------|
| `preadv2`/`pwritev2` | `flags = RWF_DONTCACHE` (offset `-1` means "use and update the file position") |
| io_uring `READ`/`WRITE` (and `_FIXED`) | `sqe->rw_flags = RWF_DONTCACHE` |
| `fio` | `--ioengine=pvsync2` or `io_uring` with `--uncached=1` |
| Python | `os.preadv(fd, bufs, off, 0x80)` / `os.pwritev(fd, bufs, off, 0x80)`. The `os` module has no `RWF_DONTCACHE` constant (checked on 3.13 and 3.15.0rc3) |
| `dd` | **No equivalent.** `iflag=nocache` / `oflag=nocache` use `posix_fadvise(DONTNEED)`, which is the fallback described below |

## Safety

- The flag itself is harmless. Data is written exactly as with buffered I/O, and only cache retention changes.
- **The fallback is not harmless.** `posix_fadvise(POSIX_FADV_DONTNEED)` drops **every** clean cached page in the range, including pages another process is actively using (see The trap).
- Do not use it for files the same process will reread soon. You pay for the device reads again.
- Measuring page-cache effects needs a quiet host. On a busy server, `Cached:` in `/proc/meminfo` moves by itself. Use a cgroup's `memory.stat` (`file`, `file_dirty`) to isolate one job.

## Examples with Explanations

All examples run as an ordinary user. Build with `gcc -O2 -Wall -o NAME NAME.c`.

The test box for this page ran **Linux 6.12** with `/workspace` on **overlayfs**. That is two reasons for `EOPNOTSUPP`: the kernel predates the flag, and overlayfs does not support it even on new kernels. So the outputs below show the **probe and fallback paths running for real**, and the success path is described from the man page and kernel source, not measured. That is also the situation most fleets are in today, which is why the fallback matters.

```bash
uname -r; findmnt -no FSTYPE -T .
```

```text
6.12.94+
overlay
```

### 1. Probe: does this kernel and filesystem accept the flag?

```c
/* probe.c — ask the kernel whether RWF_DONTCACHE is accepted on this fd */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <linux/fs.h>
#include <stdio.h>
#include <string.h>
#include <sys/uio.h>
#include <unistd.h>

#ifndef RWF_DONTCACHE
# define RWF_DONTCACHE 0x00000080
#endif

static int try_flag(const char *path, int open_flags)
{
    int fd = open(path, open_flags, 0600);
    if (fd < 0) { perror(path); return 1; }
    char buf[4096];
    memset(buf, 'A', sizeof buf);
    struct iovec iov = { .iov_base = buf, .iov_len = sizeof buf };
    ssize_t n = pwritev2(fd, &iov, 1, 0, RWF_DONTCACHE);
    if (n < 0)
        printf("%s: pwritev2(RWF_DONTCACHE) -> %s (%d)\n",
               path, strerror(errno), errno);
    else
        printf("%s: pwritev2(RWF_DONTCACHE) wrote %zd bytes\n", path, n);
    n = preadv2(fd, &iov, 1, 0, RWF_DONTCACHE);
    if (n < 0)
        printf("%s: preadv2(RWF_DONTCACHE) -> %s (%d)\n",
               path, strerror(errno), errno);
    else
        printf("%s: preadv2(RWF_DONTCACHE) read %zd bytes\n", path, n);
    close(fd);
    return 0;
}

int main(void)
{
    printf("RWF_DONTCACHE = 0x%x\n", RWF_DONTCACHE);
    try_flag("/tmp/dc-overlay.bin", O_RDWR|O_CREAT|O_TRUNC);
    try_flag("/dev/shm/dc-tmpfs.bin", O_RDWR|O_CREAT|O_TRUNC);
    return 0;
}
```

```bash
./probe
```

```text
RWF_DONTCACHE = 0x80
/tmp/dc-overlay.bin: pwritev2(RWF_DONTCACHE) -> Operation not supported (95)
/tmp/dc-overlay.bin: preadv2(RWF_DONTCACHE) -> Operation not supported (95)
/dev/shm/dc-tmpfs.bin: pwritev2(RWF_DONTCACHE) -> Operation not supported (95)
/dev/shm/dc-tmpfs.bin: preadv2(RWF_DONTCACHE) -> Operation not supported (95)
```

**Explanation.** The `#ifndef` is needed because current distribution headers (here glibc 2.41 with 6.12 UAPI headers) do not define the constant yet. Its value is fixed by the kernel ABI. The kernel rejects the call before doing any I/O, so a failed probe has no side effects: the `pwritev2` wrote nothing. On a 6.17+ kernel, the same binary pointed at an ext4 or XFS file would print "wrote 4096 bytes", and tmpfs would still fail. **Probe per file, not per host.** Mount points on one machine differ.

### 2. Streaming read with a correct fallback

```c
/* stream_read.c — read a file once, front to back, without leaving it in
 * the page cache. Uses RWF_DONTCACHE when the kernel and filesystem accept
 * it; otherwise falls back to POSIX_FADV_DONTNEED behind the read cursor.
 *
 *   ./stream_read FILE [plain|dontcache]
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/uio.h>
#include <unistd.h>

#ifndef RWF_DONTCACHE
# define RWF_DONTCACHE 0x00000080   /* include/uapi/linux/fs.h, Linux 6.14+ */
#endif

#define CHUNK (1 << 20)             /* 1 MiB per call */

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr, "usage: %s FILE [plain|dontcache]\n", argv[0]);
        return 2;
    }
    int want_dontcache = !(argc > 2 && strcmp(argv[2], "plain") == 0);

    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) { perror("open"); return 1; }
    char *buf = malloc(CHUNK);
    struct iovec iov = { .iov_base = buf, .iov_len = CHUNK };

    int flags = want_dontcache ? RWF_DONTCACHE : 0;
    const char *how = want_dontcache ? "RWF_DONTCACHE" : "plain buffered";
    off_t off = 0;
    unsigned long long sum = 0;

    for (;;) {
        ssize_t n = preadv2(fd, &iov, 1, off, flags);
        if (n < 0 && errno == EOPNOTSUPP && (flags & RWF_DONTCACHE)) {
            /* Old kernel, or a filesystem without FOP_DONTCACHE. */
            flags &= ~RWF_DONTCACHE;
            how = "fallback: fadvise(DONTNEED)";
            continue;                       /* retry this chunk */
        }
        if (n < 0) { perror("preadv2"); return 1; }
        if (n == 0) break;
        for (ssize_t i = 0; i < n; i += 4096)
            sum += (unsigned char)buf[i];   /* touch the data */
        if (want_dontcache && !(flags & RWF_DONTCACHE))
            posix_fadvise(fd, off, n, POSIX_FADV_DONTNEED);
        off += n;
    }
    printf("read %lld MiB via %s (checksum %llu)\n",
           (long long)(off >> 20), how, sum);
    close(fd);
    free(buf);
    return 0;
}
```

A two-line helper shows the system-wide page cache:

```sh
#!/bin/sh
# pagecache.sh — print the system-wide Cached and Dirty lines from /proc/meminfo, in MiB
awk '/^(Cached|Dirty):/ {printf "%s %d MiB  ", $1, $2/1024} END {print ""}' /proc/meminfo
```

```bash
head -c 256M /dev/urandom > big.bin             # any 256 MiB file; your checksum will differ
dd if=big.bin iflag=nocache count=0 status=none   # start with big.bin uncached
./pagecache.sh
./stream_read big.bin plain;     ./pagecache.sh
dd if=big.bin iflag=nocache count=0 status=none
./pagecache.sh
./stream_read big.bin dontcache; ./pagecache.sh
```

```text
Cached: 4587 MiB  Dirty: 0 MiB  
read 256 MiB via plain buffered (checksum 8349472)
Cached: 4843 MiB  Dirty: 0 MiB  
Cached: 4587 MiB  Dirty: 0 MiB  
read 256 MiB via fallback: fadvise(DONTNEED) (checksum 8349472)
Cached: 4588 MiB  Dirty: 0 MiB  
```

**Explanation.** A plain read of a 256 MiB file grows the page cache by exactly 256 MiB, and those pages now compete with everything else on the host. The `dontcache` run got `EOPNOTSUPP` on its first chunk, switched to the fallback, and left the cache where it started. The fallback drops each chunk **behind** the cursor, after it has been consumed, so readahead still works ahead of the cursor. On a kernel and filesystem that accept the flag, the program never enters the fallback and the kernel does the dropping itself. Only the "via" line changes.

`dd if=FILE iflag=nocache count=0` is a handy way to drop **one file** from the cache without root, unlike `echo 1 > /proc/sys/vm/drop_caches`.

### 3. Streaming write: bound dirty memory

```c
/* stream_write.c — write N MiB of output without leaving it in the page cache.
 * RWF_DONTCACHE when available; otherwise start writeback per chunk, wait for
 * the previous chunk, and drop it with POSIX_FADV_DONTNEED.
 *
 *   ./stream_write FILE MIB [plain|dontcache]
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/uio.h>
#include <unistd.h>

#ifndef RWF_DONTCACHE
# define RWF_DONTCACHE 0x00000080
#endif

#define CHUNK (1 << 20)

int main(int argc, char **argv)
{
    if (argc < 3) {
        fprintf(stderr, "usage: %s FILE MIB [plain|dontcache]\n", argv[0]);
        return 2;
    }
    long mib = atol(argv[2]);
    int want_dontcache = !(argc > 3 && strcmp(argv[3], "plain") == 0);
    int fd = open(argv[1], O_WRONLY | O_CREAT | O_TRUNC, 0644);
    if (fd < 0) { perror("open"); return 1; }

    char *buf = malloc(CHUNK);
    memset(buf, 0x5a, CHUNK);
    struct iovec iov = { .iov_base = buf, .iov_len = CHUNK };
    int flags = want_dontcache ? RWF_DONTCACHE : 0;
    const char *how = want_dontcache ? "RWF_DONTCACHE" : "plain buffered";

    for (long i = 0; i < mib; i++) {
        off_t off = (off_t)i * CHUNK;
        ssize_t n = pwritev2(fd, &iov, 1, off, flags);
        if (n < 0 && errno == EOPNOTSUPP && (flags & RWF_DONTCACHE)) {
            flags &= ~RWF_DONTCACHE;
            how = "fallback: sync_file_range + fadvise(DONTNEED)";
            i--;                                /* retry this chunk */
            continue;
        }
        if (n != CHUNK) { perror("pwritev2"); return 1; }
        if (want_dontcache && !(flags & RWF_DONTCACHE)) {
            /* kick off writeback for this chunk ... */
            sync_file_range(fd, off, CHUNK, SYNC_FILE_RANGE_WRITE);
            /* ... and drop the previous one once it is on disk */
            if (i > 0) {
                sync_file_range(fd, off - CHUNK, CHUNK,
                                SYNC_FILE_RANGE_WAIT_BEFORE |
                                SYNC_FILE_RANGE_WRITE |
                                SYNC_FILE_RANGE_WAIT_AFTER);
                posix_fadvise(fd, off - CHUNK, CHUNK, POSIX_FADV_DONTNEED);
            }
        }
    }
    if (want_dontcache && !(flags & RWF_DONTCACHE)) {
        fdatasync(fd);
        posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
    }
    printf("wrote %ld MiB via %s\n", mib, how);
    close(fd);
    free(buf);
    return 0;
}
```

```bash
./pagecache.sh
./stream_write out.bin 256 plain;     ./pagecache.sh
sync; dd if=out.bin iflag=nocache count=0 status=none; rm -f out.bin
./pagecache.sh
./stream_write out.bin 256 dontcache; ./pagecache.sh; rm -f out.bin
```

```text
Cached: 4588 MiB  Dirty: 0 MiB  
wrote 256 MiB via plain buffered
Cached: 4844 MiB  Dirty: 256 MiB  
Cached: 4588 MiB  Dirty: 0 MiB  
wrote 256 MiB via fallback: sync_file_range + fadvise(DONTNEED)
Cached: 4588 MiB  Dirty: 0 MiB  
```

**Explanation.** The plain write returns with **256 MiB dirty**. The kernel will flush it later, in bulk, at a time of its choosing, and a few such jobs at once is how a host ends up stalled in `balance_dirty_pages`. The fallback keeps at most about two chunks in flight: start writeback on chunk *i*, wait for chunk *i−1*, drop it. That bounds both dirty and cached memory. `RWF_DONTCACHE` does the "start writeback" part inside the kernel on every call and drops the pages when writeback completes, with no extra syscalls.

The cost is visible with `time`:

```bash
/usr/bin/time -f "%e s elapsed" ./stream_write out.bin 256 plain
sync; dd if=out.bin iflag=nocache count=0 status=none; rm -f out.bin
/usr/bin/time -f "%e s elapsed" ./stream_write out.bin 256 dontcache; rm -f out.bin
```

```text
wrote 256 MiB via plain buffered
0.13 s elapsed
wrote 256 MiB via fallback: sync_file_range + fadvise(DONTNEED)
0.44 s elapsed
```

This is not "uncached writes are 3× slower". The plain run returned **before** writing anything to storage and left the device work to the flusher. The uncached run paid for that work inside its own runtime. Judge by end-to-end throughput and by what happens to the *other* workloads, not by how fast the writer returns.

### 4. `fio`: fails rather than falls back

```bash
fio --version
fio --name=uc --filename=big.bin --rw=read --bs=1M --size=64M \
    --ioengine=pvsync2 --uncached=1 2>&1 | grep -iE 'err' | head -3
```

```text
fio-3.39
fio: io_u error on file big.bin: Operation not supported: read offset=0, buflen=1048576
fio: pid=481977, err=95/file:io_u.c:1976, func=io_u error, error=Operation not supported
uc: (groupid=0, jobs=1): err=95 (file:io_u.c:1976, func=io_u error, error=Operation not supported): pid=481977: Thu Oct  8 19:32:32 2026
```

**Explanation.** `fio` passes the flag straight through, so on an unsupported kernel or filesystem the job errors out. That is the right behaviour for a benchmark, and a quick capability check for a target directory: if this command errors, so will your application's uncached I/O there.

## The trap

**The portable fallback evicts other people's cache.**

`RWF_DONTCACHE` only drops pages that *its own* I/O instantiated. `posix_fadvise(DONTNEED)` drops **every clean page in the range**, whoever loaded it. If a service already had the file hot, a "polite" backup using the fallback makes it cold:

```bash
cat big.bin > /dev/null; ./pagecache.sh        # another process warms the file
./stream_read big.bin dontcache; ./pagecache.sh   # our "polite" one-pass read
```

```text
Cached: 4846 MiB  Dirty: 0 MiB  
read 256 MiB via fallback: fadvise(DONTNEED) (checksum 8349472)
Cached: 4590 MiB  Dirty: 0 MiB  
```

256 MiB that someone else had cached is gone. With real `RWF_DONTCACHE` the pre-existing pages would have stayed: the man page says ranges "already in cache before this read or write … will not be pruned". The same applies to `dd iflag=nocache` and to every "nocache" option built on fadvise.

`dd` shows the same effect:

```bash
dd if=big.bin of=/dev/null bs=1M iflag=nocache status=none; ./pagecache.sh   # leaves nothing cached
cat big.bin >/dev/null; ./pagecache.sh                                       # warm it
dd if=big.bin iflag=nocache count=0 status=none; ./pagecache.sh             # and dd drops it all
```

```text
Cached: 4590 MiB  Dirty: 0 MiB  
Cached: 4846 MiB  Dirty: 0 MiB  
Cached: 4590 MiB  Dirty: 0 MiB  
```

To use the fallback safely, check residency first (with `mincore(2)` on a mapping of the file, or `fincore` where it works) and skip `DONTNEED` for ranges that were resident before you started. Or accept the collateral and run such jobs where nothing else needs that file hot.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| Header lacks `RWF_DONTCACHE` | Compile error. Use the `#ifndef … 0x80` guard, since the value is ABI |
| Treating `EOPNOTSUPP` as fatal | Your tool breaks on every pre-6.15 kernel and on btrfs/tmpfs. Retry the same chunk without the flag and use the fallback |
| Expecting "since 6.14" to mean "works on 6.14" | 6.14 has the flag but no filesystem accepts it. XFS from 6.15, ext4 from 6.17, NFS client from 6.18, block devices from 7.3 |
| Probing once per host | Support is per filesystem. `/`, `/var/lib/…` and `/tmp` can differ. Probe the fd you will use |
| `fincore` says `0B` for a file you just read | Seen on overlayfs here: `fincore big.bin` printed `0B 0 256M` right after `cat big.bin` (a tmpfs copy of the same file reported `256M`). The overlay file's mapping is not where the cached pages live. Measure with `/proc/meminfo` or cgroup `memory.stat` instead |
| Confusing it with `O_DIRECT` | No alignment rules, and it still goes through the cache (briefly). Pages already cached are used |
| Expecting durability | Writes only **start** writeback. Use `fdatasync`/`fsync` for durability, as with any buffered write |
| `POSIX_FADV_NOREUSE` as an alternative | It was suggested in review of the original patches. It is advice about how the LRU should age the pages, not an instruction to drop them when the I/O completes, so it is not a drop-in replacement |
| Mixing with `mmap` of the same file | Pages that are mapped or otherwise in use may stay cached. The hint is best-effort, and the man page promises nothing about the cache state afterwards |

## The boring rule

> One-pass bulk I/O (backups, scans, exports) uses `RWF_DONTCACHE` per call, and on `EOPNOTSUPP` retries that call without the flag and switches to a bounded fallback (`sync_file_range` + `fadvise` for writes, `fadvise` behind the cursor for reads), but only on files nobody else keeps hot. Probe per file, never trust the kernel version alone, and judge the result by the *other* workloads' cache hit rate, not by the job's own speed.

## Related Commands

| Command | Role |
|---------|------|
| `dd iflag=nocache` / `oflag=nocache` | fadvise-based cache dropping (the fallback, with its collateral) |
| `fio --uncached=1` | Benchmark real `RWF_DONTCACHE` with `pvsync2` or `io_uring` |
| `fincore` | Page-cache residency per file (unreliable on overlayfs) |
| `sync`, `fdatasync` | Durability, which `RWF_DONTCACHE` does not provide |
| `vmstat`, `/proc/meminfo` | `Cached`, `Dirty`, `Writeback` trends while a job runs |
| `findmnt -T PATH` | Which filesystem a path is actually on, before you trust a capability |

## Try this

1. Run `probe` against a file on every mount point of a host (`findmnt -rno TARGET -t ext4,xfs,btrfs,nfs4,tmpfs`) and build a table of which accept the flag on that kernel.
2. On a 6.17+ kernel with ext4 or XFS, rerun example 2 and check that the program reports `via RWF_DONTCACHE` and that `Cached:` stays flat. Then warm the file with `cat` first and confirm the cache is **not** dropped, unlike the trap.
3. Write 4 GiB with `stream_write … plain` while running `vmstat 1`, then again with the uncached path. Compare the `bo` column and how long `Dirty:` takes to return to zero.
4. Extend `stream_read.c` to call `mincore(2)` on an `mmap` of each chunk before reading, and skip `POSIX_FADV_DONTNEED` for chunks that were already resident. Verify with the trap's commands.
5. On a 7.3+ kernel, point `fio --uncached=1` at a scratch block device (never one holding data) and compare `Cached:` with and without `--uncached`.

## Sources

- [readv(2)](https://man7.org/linux/man-pages/man2/readv.2.html): `RWF_DONTCACHE` semantics (pre-existing ranges not pruned, writeback kicked off, best effort, `EOPNOTSUPP`)
- [posix_fadvise(2)](https://man7.org/linux/man-pages/man2/posix_fadvise.2.html), [sync_file_range(2)](https://man7.org/linux/man-pages/man2/sync_file_range.2.html), [mincore(2)](https://man7.org/linux/man-pages/man2/mincore.2.html)
- Kernel commits (mainline): [`fs: add RWF_DONTCACHE iocb and FOP_DONTCACHE file_operations flag`](https://github.com/torvalds/linux/commit/b9f958d4f146) (6.14), [`xfs: flag as supporting FOP_DONTCACHE`](https://github.com/torvalds/linux/commit/d47c670061b5) (6.15), [`ext4: support uncached buffered I/O`](https://github.com/torvalds/linux/commit/ae21c0c0ac56) (6.17), [`NFS: Enable use of the RWF_DONTCACHE flag on the NFS client`](https://github.com/torvalds/linux/commit/902893e39076) (6.18), [`mm: kick writeback flusher for IOCB_DONTCACHE with targeted dirty tracking`](https://github.com/torvalds/linux/commit/e1bf79628453) (7.2), [`block: enable RWF_DONTCACHE for block devices`](https://github.com/torvalds/linux/commit/8b5ffb43ae9d) (7.3)
- LWN: [The return of RWF_UNCACHED](https://lwn.net/Articles/998783/) and [Uncached buffered I/O](https://lwn.net/Articles/1003083/)
- fio documentation, [`uncached`](https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-uncached)
- GNU coreutils, [`dd` invocation](https://www.gnu.org/software/coreutils/manual/html_node/dd-invocation.html) (`nocache`)
