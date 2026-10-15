---
title: "io_uring and seccomp: filters per opcode"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# io_uring and seccomp: filters per opcode

## Overview

**Thesis:** classic **seccomp** sees system-call arguments on the syscall ABI. **io_uring** puts the interesting arguments in the **submission-queue entry (SQE)** shared with the kernel. A single `io_uring_enter(2)` (or a registered ring) can perform open, socket, connect, read, write, … without those operations appearing as separate syscalls. Containers that only block `io_uring_setup` therefore face a blunt choice — allow the whole ring or deny it. Linux **7.0+** adds **classic BPF (cBPF) filters per io_uring opcode**, so a policy can inspect opcode-specific fields (open flags, socket family, …) and deny with `-EACCES`. This chapter teaches that model for operators and sandbox authors. It is not an exploit guide and does not build custom kernels.

Companion chapter: `11-storage-and-filesystems/25-io-uring.md` covers rings, CQEs, and `kernel.io_uring_disabled`. Here the focus is **policy**.

## Mental model

```text
  classic syscall path                    io_uring path
  ────────────────────                    ─────────────
  openat(dfd, path, flags, mode)          SQE.opcode = IORING_OP_OPENAT
       │                                  SQE fields / PDU hold flags…
       ▼                                        │
  seccomp filter sees args ──allow/deny──▶      ▼
                                       io_uring_enter / SQ poll
                                                │
                              ┌─────────────────┴─────────────────┐
                              ▼                                   ▼
                   old: IORING_REGISTER_RESTRICTIONS      new (7.0+):
                        bitmap allow/deny opcodes         IORING_REGISTER_BPF_FILTER
                                                          cBPF on io_uring_bpf_ctx
                                                          (per-opcode payload)
```

| Mechanism | Granularity | Sees open flags / socket family? | Kernel |
|-----------|-------------|----------------------------------|--------|
| seccomp on `io_uring_setup` / `io_uring_enter` | Whole ring / enter | No (args are in the SQ, not in enter's registers) | long-standing |
| `IORING_REGISTER_RESTRICTIONS` | Opcode / register-op allowlist | No — opcode only | 5.10+ |
| `IORING_REGISTER_BPF_FILTER` | Per-opcode cBPF | Yes — via `io_uring_bpf_ctx` PDU | **7.0+** |
| `kernel.io_uring_disabled` sysctl | Host-wide kill switch | N/A | 6.6+ |

Return convention for BPF filters: **non-zero allow**, **zero deny** → completion `-EACCES`. Multiple filters for one opcode must **all** allow. Task-scoped filters inherit to children and can only be tightened.

## Syntax

### Coarse allowlist (widely available): restrictions

```c
io_uring_queue_init(entries, &ring, IORING_SETUP_R_DISABLED);
io_uring_register_restrictions(&ring, restrictions, nr);
io_uring_enable_rings(&ring);
```

`IORING_RESTRICTION_SQE_OP` entries name permitted opcodes. After enable, other opcodes fail with permission errors.

### Fine-grained (Linux 7.0+ / liburing helpers)

```c
#include <liburing.h>
#include <liburing/io_uring/bpf_filter.h>
#include <linux/filter.h>
#include <sys/prctl.h>

prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);   /* or hold CAP_SYS_ADMIN */

struct io_uring_bpf bpf = {
    .cmd_type = IO_URING_BPF_CMD_FILTER,
    .filter = {
        .opcode     = IORING_OP_SOCKET,   /* or OPENAT, NOP, … */
        .filter_len = N,
        .filter_ptr = (unsigned long) prog,  /* struct sock_filter[N] */
        .pdu_size   = 12,                 /* SOCKET: family/type/protocol */
        /* .flags = IO_URING_BPF_FILTER_DENY_REST | IO_URING_BPF_FILTER_SZ_STRICT */
    },
};
io_uring_register_bpf_filter(&ring, &bpf);       /* this ring only */
/* or */ io_uring_register_bpf_filter_task(&bpf); /* future rings + children */
```

Context the filter loads with `BPF_LD|BPF_W|BPF_ABS` (layout from `io_uring_register_bpf_filter(3)`):

| Offset | Field | Notes |
|--------|-------|-------|
| 0 | `user_data` | From the SQE |
| 8 | `opcode` / `sqe_flags` / `pdu_size` | Packed bytes |
| 16+ | PDU union | `socket.{family,type,protocol}` (12 bytes) or `open.{flags,mode,resolve}` (24 bytes) |

`pdu_size` must match (or be ≤) the kernel's expectation unless you set `IO_URING_BPF_FILTER_SZ_STRICT`. On `-EMSGSIZE` the kernel writes back the expected size so you can retry.

## Safety

- **Teaching only.** Do not use these APIs to probe or bypass production sandboxes you do not own. Registering filters requires `CAP_SYS_ADMIN` or `no_new_privs` for the same reason seccomp does: stop an unprivileged process from installing a filter and then execing a setuid helper.
- Task-level filters **cannot be removed**; children cannot loosen a parent's policy. Prefer allowlists (`IO_URING_BPF_FILTER_DENY_REST`) over "deny one bad opcode and hope."
- Restrictions and BPF filters are **complementary** to `kernel.io_uring_disabled` and LSM/container profiles — not replacements for patching the kernel attack surface.
- This chapter never presents a privilege-escalation path, a container breakout recipe, or a kernel build.

## Examples with Explanations

Tested on **Linux 6.12.94+** with **liburing 2.9** and GCC. That kernel **does not** implement `IORING_REGISTER_BPF_FILTER` (7.0+). Example 1 therefore runs for real. Examples 2–3 are **documentation listings** from the liburing manual, for hosts that have the feature.

### 1. Opcode allowlist with `IORING_REGISTER_RESTRICTIONS` (runs here)

```c
/* uring_restrict_demo.c — only IORING_OP_NOP is allowed; READ returns -EACCES */
#include <liburing.h>
#include <linux/io_uring.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void) {
    struct io_uring ring;
    int ret = io_uring_queue_init(8, &ring, IORING_SETUP_R_DISABLED);
    if (ret < 0) {
        fprintf(stderr, "queue_init: %s\n", strerror(-ret));
        return 1;
    }

    struct io_uring_restriction res[1];
    memset(res, 0, sizeof(res));
    res[0].opcode = IORING_RESTRICTION_SQE_OP;
    res[0].sqe_op = IORING_OP_NOP;

    ret = io_uring_register_restrictions(&ring, res, 1);
    if (ret < 0) {
        fprintf(stderr, "register_restrictions: %s (%d)\n", strerror(-ret), ret);
        return 1;
    }
    ret = io_uring_enable_rings(&ring);
    if (ret < 0) {
        fprintf(stderr, "enable_rings: %s (%d)\n", strerror(-ret), ret);
        return 1;
    }
    printf("restrictions locked: only IORING_OP_NOP allowed\n");

    struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
    io_uring_prep_nop(sqe);
    io_uring_sqe_set_data64(sqe, 1);
    printf("submit+wait NOP: ret=%d\n", io_uring_submit_and_wait(&ring, 1));

    struct io_uring_cqe *cqe;
    io_uring_wait_cqe(&ring, &cqe);
    printf("NOP cqe res=%d user_data=%llu\n", cqe->res,
           (unsigned long long)cqe->user_data);
    io_uring_cqe_seen(&ring, cqe);

    char buf[16];
    sqe = io_uring_get_sqe(&ring);
    io_uring_prep_read(sqe, STDIN_FILENO, buf, sizeof(buf), 0);
    io_uring_sqe_set_data64(sqe, 2);
    printf("submit+wait READ: ret=%d\n", io_uring_submit_and_wait(&ring, 1));
    io_uring_wait_cqe(&ring, &cqe);
    printf("READ cqe res=%d (%s) user_data=%llu\n", cqe->res,
           cqe->res < 0 ? strerror(-cqe->res) : "ok",
           (unsigned long long)cqe->user_data);
    io_uring_cqe_seen(&ring, cqe);

    io_uring_queue_exit(&ring);
    return 0;
}
```

```bash
gcc -O2 -o uring_restrict_demo uring_restrict_demo.c -luring
./uring_restrict_demo
```

```text
restrictions locked: only IORING_OP_NOP allowed
submit+wait NOP: ret=1
NOP cqe res=0 user_data=1
submit+wait READ: ret=1
READ cqe res=-13 (Permission denied) user_data=2
```

`-13` is `-EACCES`: the ring accepted the submit, but the restricted opcode was denied. That is the coarse ancestor of per-opcode BPF filters — still blind to *which* file a hypothetical `OPENAT` would open.

Confirm the host policy knob while you are here:

```bash
uname -r
cat /proc/sys/kernel/io_uring_disabled
```

```text
6.12.94+
0
```

`0` means rings may be created. `2` would refuse new rings entirely (existing rings keep working).

### 2. Allow only `AF_INET` sockets (docs listing — needs Linux 7.0+)

From `io_uring_register_bpf_filter(3)` — illustrative; not executed on 6.12:

```c
#define CTX_OFF_SOCKET_FAMILY  16

struct sock_filter inet_only_filter[] = {
    BPF_STMT(BPF_LD | BPF_W | BPF_ABS, CTX_OFF_SOCKET_FAMILY),
    BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, AF_INET, 0, 1),
    BPF_STMT(BPF_RET | BPF_K, 1),  /* allow */
    BPF_STMT(BPF_RET | BPF_K, 0),  /* deny  */
};

struct io_uring_bpf bpf = {
    .cmd_type = IO_URING_BPF_CMD_FILTER,
    .filter = {
        .opcode = IORING_OP_SOCKET,
        .filter_len = 4,
        .filter_ptr = (unsigned long) inet_only_filter,
        .pdu_size = 12,
    },
};
prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
io_uring_register_bpf_filter_task(&bpf);
```

An `IORING_OP_SOCKET` with another family completes with `-EACCES`. Open filters use `pdu_size = 24` and load `flags` / `resolve` at offsets 16 and 32.

### 3. Allowlist pattern: allow NOP, deny everything else

```c
struct sock_filter allow_filter[] = {
    BPF_STMT(BPF_RET | BPF_K, 1),
};
struct io_uring_bpf bpf = {
    .cmd_type = IO_URING_BPF_CMD_FILTER,
    .filter = {
        .opcode = IORING_OP_NOP,
        .flags = IO_URING_BPF_FILTER_DENY_REST,
        .filter_len = 1,
        .filter_ptr = (unsigned long) allow_filter,
    },
};
```

`DENY_REST` fills every other opcode slot with a deny stub — the BPF analogue of Example 1's single-opcode restrictions list.

## The trap

**Trap: "seccomp on `io_uring_enter` can see open flags."** Enter's arguments are the ring fd and flags for the enter call. Open flags live in the SQE. Without restrictions or BPF filters you are filtering the wrong layer.

**Trap: "block `io_uring_setup` and you are done forever."** That is a valid hard disable (and so is `io_uring_disabled=2`), but it also kills legitimate high-performance I/O. Prefer opcode allowlists when you need io_uring at all.

**Trap: "run the BPF examples on any recent kernel."** Check `uname -r` and the presence of `IORING_REGISTER_BPF_FILTER` in your `linux/io_uring.h`. On 6.12 this box, registration is unavailable; use restrictions or upgrade.

## The boring rule

If arguments matter for policy, filter **where the arguments live**. For io_uring that means opcode restrictions (coarse) or per-opcode cBPF on `io_uring_bpf_ctx` (fine, 7.0+), plus `no_new_privs` / capabilities, not a hope that seccomp saw the SQE fields on `enter`.

## Try this

1. Run Example 1; then remove the restrictions registration and confirm READ succeeds (Ctrl-D for EOF on stdin).
2. On a 7.0+ lab kernel with matching liburing, run the man-page `AF_INET`-only filter against `IORING_OP_SOCKET` and confirm non-INET families get `-EACCES`.
3. Read your container runtime's seccomp profile: does it kill `io_uring_setup`, allow it fully, or (on new stacks) expect BPF filters?

## Verification

- Example 1 compiled and run on this box: Linux **6.12.94+**, liburing **2.9**, `io_uring_disabled=0`. Output pasted above.
- BPF filter API described from `io_uring_register_bpf_filter(3)` / `io_uring_register_bpf_filter_task(3)` (liburing 2.14 docs) and the upstream `include/uapi/linux/io_uring/bpf_filter.h` (merged for 7.0).
- **No** kernel builds, **no** package installs, **no** exploit PoCs. BPF examples are documentation-only on this host.

## Sources

- man7 — [`io_uring_register_bpf_filter(3)`](https://man7.org/linux/man-pages/man3/io_uring_register_bpf_filter.3.html), [`io_uring_register_bpf_filter_task(3)`](https://man7.org/linux/man-pages/man3/io_uring_register_bpf_filter_task.3.html)
- man7 — [`io_uring_register(2)`](https://man7.org/linux/man-pages/man2/io_uring_register.2.html), [`seccomp(2)`](https://man7.org/linux/man-pages/man2/seccomp.2.html)
- Kernel docs — [Seccomp BPF](https://docs.kernel.org/userspace-api/seccomp_filter.html)
- Upstream UAPI — [`io_uring/bpf_filter.h`](https://github.com/torvalds/linux/blob/master/include/uapi/linux/io_uring/bpf_filter.h) (7.0+)
- Jens Axboe — io_uring BPF filter patch series (lore, Jan 2026)
