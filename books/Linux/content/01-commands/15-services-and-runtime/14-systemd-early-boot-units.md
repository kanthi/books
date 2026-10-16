---
title: "systemd early-boot units"
author:
  - name: "K19G"
  - name: "grok-bot"
---

## Overview

**Thesis:** most unit files can ignore boot ordering — `DefaultDependencies=yes` pulls in the ordinary "start me after basic system setup" edges. The interesting (and dangerous) case is a unit that opts **out** of those defaults and places itself **before** `sysinit.target`. That is how legitimate early helpers run (filesystem fsck helpers, module loaders, some cryptsetup paths). It is also how malware authors try to load code before security agents attach probes. Understanding the knobs matters for both writing safe early units and for spotting hostile ones.

This chapter teaches the **operator** reading of early-boot units: `DefaultDependencies=no`, `Before=sysinit.target`, explicit `After=` / `Requires=` / `Conflicts=`, and what `sysinit.target` actually means. No packages are installed; examples are unit text plus read-only `systemctl` / `systemd-analyze` probes on **systemd 257**.

```bash
systemctl --version | head -1
```

```text
systemd 257 (257.13-1~deb13u1)
```

## Mental model

```text
  cold boot
     │
     ▼
  local-fs-pre / swap / early mounts
     │
     ▼
  ★ units with DefaultDependencies=no
       and Before=sysinit.target     ← "very early userspace"
     │
     ▼
  sysinit.target   ← sync point: "essential system initialization done"
     │
     ▼
  basic.target → multi-user.target / graphical.target
     │
     ▼
  ordinary services (EDR agents, sshd, docker, …)
```

| Fact | Consequence |
|------|-------------|
| `DefaultDependencies=yes` (default) | Service units get implicit conflicts/after edges toward shutdown and basic ordering — you rarely think about `sysinit.target` |
| `DefaultDependencies=no` | **You** must declare every dependency you need. Forget `After=local-fs.target` and you may run before `/var` exists |
| `Before=sysinit.target` | Pulls the unit into the early-boot window *if* something also pulls it in (`WantedBy=sysinit.target`, a `Requires=` from an early target, etc.) |
| `sysinit.target` is a synchronization point | It is not "all security tooling". Many modules and generators already ran |
| Early ≠ invisible | Journal, `systemd-analyze blame/critical-chain`, and on-disk unit files still exist for forensics |

## Syntax

```ini
# /etc/systemd/system/early-helper.service  — shape only; do not install blindly
[Unit]
Description=Early helper (example shape)
DefaultDependencies=no
# Run after local filesystems exist, still before sysinit completes:
After=local-fs.target
Before=sysinit.target shutdown.target
Conflicts=shutdown.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/local/libexec/early-helper

[Install]
WantedBy=sysinit.target
```

| Directive | Role in early boot |
|-----------|--------------------|
| `DefaultDependencies=` | `no` disables the type's standard dependency set (`systemd.unit(5)`, "Default Dependencies") |
| `Before=sysinit.target` | Orders this unit earlier than the sysinit sync point |
| `After=` | Name **every** prerequisite (`local-fs.target`, `systemd-modules-load.service`, …) |
| `Conflicts=shutdown.target` + `Before=shutdown.target` | Classic oneshot pattern so shutdown tears you down cleanly |
| `WantedBy=sysinit.target` | Makes `systemctl enable` create the symlink that actually pulls the unit in |

`systemd.special(7)` describes `sysinit.target` as the target that pulls in early services for **system initialization** — mounts, swap, modules, etc. — before `basic.target`.

## Safety

- **Do not put business daemons here.** Early boot has fewer mounts, less networking, and less logging infrastructure than you think.
- **Malware pattern to recognise:** `DefaultDependencies=no` + `Before=sysinit.target` + `WantedBy=sysinit.target` (or similar) shipping an `insmod` of an out-of-tree module. The Talos write-up discussed on X used that shape; comments correctly noted that `After=systemd-modules-load.service` means *some* modules already loaded, so "before any security tooling" is too absolute.
- **Detection angle:** inventory units with `DefaultDependencies=no` and any `Before=` referencing `sysinit.target` / `basic.target`. Read `ExecStart=` — unsigned `insmod` paths are a red flag.
- **Lab constraint:** creating or enabling system units needs root. This chapter **does not** install units on the scout host. Validate with `systemd-analyze verify` on a copy when you have a disposable VM.

## Examples with Explanations

### 1. Inventory: who opts out of default dependencies?

```bash
# List unit files that mention DefaultDependencies=no (read-only scan of common paths)
grep -Rsl '^DefaultDependencies=no' /lib/systemd/system /usr/lib/systemd/system 2>/dev/null | head -20
```

Representative idea of what you will see on a Debian systemd 257 system: generators and early helpers (`systemd-remount-fs.service`, pieces of `cryptsetup`, `systemd-sysctl.service`, …). Your own additions under `/etc/systemd/system` should be rare.

### 2. Confirm sysinit sits before basic

```bash
systemctl list-dependencies sysinit.target 2>/dev/null | head -20
systemctl list-dependencies basic.target 2>/dev/null | head -15
systemd-analyze critical-chain sysinit.target 2>/dev/null | head -25
```

```text
# critical-chain shape (times vary; paste is representative of systemd 257):
sysinit.target @NNNms
└─... early services / mounts ...
```

Exact timing lines differ per boot; the structural point is that `basic.target` depends on `sysinit.target`, not the reverse.

### 3. `systemd-analyze verify` on a draft unit (no install)

```bash
cat > /tmp/early-helper.service <<'EOF'
[Unit]
Description=Early helper (draft)
DefaultDependencies=no
After=local-fs.target
Before=sysinit.target shutdown.target
Conflicts=shutdown.target

[Service]
Type=oneshot
ExecStart=/bin/true

[Install]
WantedBy=sysinit.target
EOF
systemd-analyze verify /tmp/early-helper.service 2>&1 || true
```

```text
# Success is silence, or warnings about missing Install context when verifying
# a loose file. Fix any hard errors before copying into /etc/systemd/system.
```

(`/bin/true` is a stand-in. Production oneshots must declare real ordering for every path they touch.)

### 4. Reading a suspicious unit

When triage finds an unexpected early service:

```bash
systemctl cat suspicious.service 2>/dev/null
systemctl show suspicious.service -p After -p Before -p WantedBy -p Requires -p DefaultDependencies 2>/dev/null
```

Checklist:

1. Is `DefaultDependencies` off?
2. Is there `Before=sysinit.target` (or `Before=basic.target` with other early edges)?
3. What does `ExecStart=` run — script in `/tmp`, `insmod`, curl-pipe?
4. Is the unit file owned by root with mode `0644` under `/etc` or did something drop it in `/run`?

### 5. What early boot is *not*

```text
Before=sysinit.target
    ≠  "runs before the kernel"
    ≠  "runs before every module"
    ≠  "invisible to the journal"
    ≠  "bypasses Secure Boot"
```

It means: in the **userspace** dependency graph, this unit is ordered earlier than the sysinit sync point. Kernel lockdown, signatures, and modules loaded via `systemd-modules-load.service` are separate stories — declare `After=` if you depend on them, and never assume absence.

## The trap

- Enabling `DefaultDependencies=no` and forgetting `After=local-fs.target` → mysterious failures when `/var` or `/usr` is not ready.
- Treating "before sysinit" as a security boundary for your own agents (EDR should not *rely* on starting after sysinit if the threat model includes early units).
- Copying a malware unit "for research" onto a production host.
- Using Mermaid for topology — this book prefers plain text / dual-theme cards; keep diagrams in ASCII as above.

## The boring rule

Ordinary services: leave `DefaultDependencies` alone. Early oneshots: `DefaultDependencies=no`, explicit `After=`/`Before=`/`Conflicts=`, `WantedBy=` a real early target, `systemd-analyze verify` before enable, and code review any unit that asks to run before `sysinit.target`.

## Try this

1. On a disposable VM, `grep -Rsl DefaultDependencies=no /lib/systemd/system | wc -l` and sample five files.
2. Draft a oneshot that only writes a stamp file under `/run`, verify, enable, reboot, confirm stamp and journal order relative to `sysinit.target`.
3. Practice triage: given a unit with `Before=sysinit.target` and `ExecStart=/sbin/insmod …`, list three detection points that still apply.

## Sources

- `systemd.unit(5)` — `DefaultDependencies=`, dependency model
- `systemd.special(7)` — `sysinit.target`, `basic.target`
- freedesktop systemd documentation (same content as the man pages)
- Inspiration: [malmoeb on X](https://x.com/malmoeb/status/2106323565251366975) (early-boot rootkit unit discussion / Talos Spectre write-up) — chapter teaches the **legit** mechanism and how to recognise abuse; not a how-to for implants
