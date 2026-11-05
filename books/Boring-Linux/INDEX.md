# Boring Linux — Authoring Roadmap

Canonical curriculum: [content/_planning/SYLLABUS.md](content/_planning/SYLLABUS.md). The syllabus owns scope, prerequisites, reading routes, milestones and section outlines. This file owns writing status and the next batch.

## Current content

Inventory checked against the content tree on **2026-11-03**. A complete chapter sequence is a writing status; it does not imply that every command, lab and output has been reverified on the reference image.

| Part | Chapter files | Writing status |
|---|---:|---|
| 01 — The Linux Machine and the Administration Lab | 8 | Complete sequence |
| 02 — Installing and Provisioning Linux | 8 | Complete sequence |
| 03 — Boot, Shutdown and Recovery | 10 | Complete sequence |
| 04 — Users, Identity and Administrative Access | 10 | Complete sequence; review the early permission/task prerequisites |
| 05 — Packages, Software and Updates | 11 | Complete sequence |
| 06 — Services, systemd and Scheduled Work | 9 | Briefs 1–9 present; briefs 10–12 next |
| 07–32 | 0 | Planned; no placeholder chapters |
| 33–38 | 119 | Existing optional depth-track pages, including introductions and part indexes; technical review pending |

The core has **56 chapter files** across Parts 01–06. Part 06 already covers vendor/local units and drop-ins; socket/path/device activation; timers/cron/anacron; mount/automount/swap units; and service cgroups with an initial sandbox. Do not rewrite these as missing chapters.

## Next writing pass

Complete Part 06 in a new section, `04-lifecycle-and-recovery`, with:

1. `01-reloads-restarts-and-graceful-shutdown.qmd` — distinguish reload, restart and daemon-reload; validate configuration; prove graceful shutdown and the behavior of in-flight work.
2. `02-user-services-lingering-and-session-lifecycle.qmd` — system versus user manager, login environment, lingering, logout/reboot behavior and cleanup.
3. `03-service-failures-diagnosis-and-recovery.qmd` — dependency cycles, start-rate limits, restart storms, timeouts and a controlled repair with client-visible verification.

Carry forward `bl06-service-lab` and `labapp`. Reuse the current configuration and scheduled work; end with a documented baseline for Part 07. Each new chapter supplies mechanism, worked evidence, a bounded failure, recovery, observable acceptance criteria and cleanup.

Before beginning Part 07:

- Review basic permissions and directory traversal in Part 04, including the small `chmod`/`chown`/`umask` workflow needed by service labs. The existing identity chapter already introduces access checks; extend only what the exercises need.
- Verify that service labs teach their own endpoint, log and health checks without requiring the unwritten observability part.
- Record which VM is active and which copies must remain off. Teach unique host identities before clones run together in the later multi-host lab.

Use the syllabus section map for Part 07 onward. Create a section only when it has written chapters. Keep the first implementation bounded; expand alternative technologies as selectable sequences rather than one mixed survey chapter.

## Depth-track review queue

Existing Parts 33–38 stay at their current paths. Review them against the syllabus contracts before treating them as a continuation of the core:

| Part | Review focus |
|---|---|
| 33 | Distinguish KVM guest kernels, `kexec` handoff and actual hardware partitioning; separate the basic lab from NUMA/VFIO/SR-IOV extensions |
| 34 | Build on 24 and 30; concentrate on reproducible subsystem experiments, raw data and regression decisions |
| 35 | Build on 14–18; use integrated threat/control/recovery cases rather than a second general security course |
| 36 | Pin filesystem features and source; inspect disposable images and verify recovery |
| 37 | Pin kernel/source/configuration; distinguish current SLUB from historical allocators and user-space allocation from `vmalloc` |
| 38 | Verify release defaults, compatibility, support entitlements and installed versions; turn repeated foundations into Ubuntu-specific integration cases |

These are scoped follow-up authoring tasks, not a claim that the existing track prose has been repaired by the syllabus review.

## Authoring boundaries

- Keep the book independently usable; explain command and protocol details needed by the present task.
- Keep numeric part identities and current chapter paths stable. A later reorganization needs an explicit link-checked mapping.
- Use part → section → chapter for new core writing. Do not create empty planned parts or placeholder overviews.
- Follow the monorepo illustrated-diagram standard.
- After a reader-facing content batch, render and refresh local published artifacts once using [README.md](README.md). Never hand-edit `_quarto.yml` or commit build artifacts.
- Any future integration into another book requires its own mapping. Historical fixed 05–13 and 04–19 arrangements do not describe this curriculum.

## Full progression

Parts 01–32 contain the progressive foundations, workload branches, production operation, investigation and projects. Parts 33–38 are optional depth tracks with explicit prerequisites. The reading-route and milestone tables in the syllabus explain which parts to select and when to attempt projects.

| Part | Subject |
|---|---|
| 01 | The Linux Machine and the Administration Lab |
| 02 | Installing and Provisioning Linux |
| 03 | Boot, Shutdown and Recovery |
| 04 | Users, Identity and Administrative Access |
| 05 | Packages, Software and Updates |
| 06 | Services, systemd and Scheduled Work |
| 07 | Processes, Memory and Resource Administration |
| 08 | Configuration, Devices, Time and Local Logs |
| 09 | Disks, Partitions and Filesystems |
| 10 | Volumes, RAID, Encryption and Storage Health |
| 11 | Backup, Restore and Data Lifecycle |
| 12 | Linux Host Networking |
| 13 | DNS, Address Assignment and Time Services |
| 14 | Remote Access, Certificates and Trust Services |
| 15 | Linux Gateways, Firewalls and Virtual Networks |
| 16 | File, Storage and Messaging Services |
| 17 | Linux Access Control and Isolation |
| 18 | Hardening, Secrets, Audit and Security Response |
| 19 | Web, Application and Data Services |
| 20 | Virtualization and Virtual Machine Operations |
| 21 | Containers and System Containers |
| 22 | Kubernetes and Linux Cluster Workloads |
| 23 | Troubleshooting and Observability |
| 24 | Performance and Capacity Engineering |
| 25 | Provisioning and Configuration Automation |
| 26 | Fleet Maintenance and Software Delivery |
| 27 | High Availability and Shared Infrastructure |
| 28 | Reliability, Incidents and Disaster Recovery |
| 29 | Advanced Linux Architecture and Kernel Internals |
| 30 | Tracing, eBPF and Failure Analysis |
| 31 | Specialist Linux Systems |
| 32 | Integrated Systems Engineering Projects |
| 33 | Running Multiple Kernels on One Bare-Metal Server |
| 34 | Linux Performance Engineering & Server Benchmarking |
| 35 | A Practical Guide to Securing Linux from Kernel to Cloud |
| 36 | The ext4 Filesystem: Architecture, Internals, and Implementation |
| 37 | A Complete Guide to Virtual Memory, Allocators, Paging, and Performance in the Modern Linux Kernel |
| 38 | Ubuntu 26.04 LTS: From Desktop to Enterprise Cloud |
