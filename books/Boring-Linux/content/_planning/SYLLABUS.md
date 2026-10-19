# Boring Linux: Master Reference Architecture & Curriculum Syllabus
## 16-Module Encyclopedia of Modern Linux Systems, Kernel Internals, and Cloud-Native Infrastructure
### Anchored on Ubuntu 26.04 LTS ("Resolute Raccoon") and Linux Kernel 7.0

> **Reference Platform**: Ubuntu 26.04 LTS ("Resolute Raccoon")
> **Kernel Version**: Linux 7.0+ (pure cgroup v2, Maple Tree, MGLRU, PREEMPT_RT, eBPF CO-RE)
> **Userspace**: Oxidized baseline (rust-uutils coreutils, sudo-rs, ntpd-rs, Glibc 2.43)
> **Security & Boot**: Unified Kernel Images (UKI), TPM 2.0 systemd-pcrlock FDE, OpenSSH 10.2 Post-Quantum (ML-KEM), AppArmor 4.0

---

## Curriculum Structure Overview

This encyclopedia is organized into 5 major divisions spanning 16 comprehensive modules and 230 detailed chapters:

1. **Part I: Silicon & Kernel Internals** (Modules 01–04)
   - Module 01: Hardware Architecture & Modern Userspace
   - Module 02: Kernel Internals I — Core, Scheduling & Locking
   - Module 03: Kernel Internals II — Memory, VFS & I/O
   - Module 04: Kernel Internals III — Isolation, Security & eBPF
2. **Part II: Systems Engineering & Core Infrastructure** (Modules 05–07)
   - Module 05: Systems Programming & Automation
   - Module 06: Systems Administration & Immutable Linux
   - Module 07: Storage, Filesystems & Encryption
3. **Part III: Networking, Security & High-Performance AI** (Modules 08–10)
   - Module 08: Network Engineering & Software-Defined Networking
   - Module 09: Security, Cryptography & Compliance
   - Module 10: High-Performance, Real-Time & AI Infrastructure
4. **Part IV: Virtualization, Containers & Platform Engineering** (Modules 11–13)
   - Module 11: Virtualization & Private Cloud
   - Module 12: Containers & Kubernetes Orchestration
   - Module 13: DevOps, IaC & Platform Engineering
5. **Part V: Observability, GitOps & Production Blueprints** (Modules 14–16)
   - Module 14: Observability, SRE & Performance Engineering
   - Module 15: GitOps & Cloud-Native Control Planes
   - Module 16: Appendices, Runbooks & Reference Blueprints

---

## Part II: Exhaustive Module-by-Module Technical Depth
Below is the granular breakdown of what each module covers, focusing especially on the newly expanded Hardware, Kernel Internals, High-Performance/AI, and Cloud-Native tracks.
Module 01: Hardware Architecture & the Modern "Oxidized" Userspace
Before touching kernel code, a systems engineer must understand how the silicon executes instructions and how userspace binaries cross the ABI boundary.
Silicon & Interconnects (01-silicon-and-system-architecture):
Multi-ISA Engineering: Comparing x86-64-v3 (AVX2/BMI2 baseline), ARM64 (ARMv9, SVE2, GICv4), and RISC-V (rva23 profile, Vector extensions)—all first-class citizens in Ubuntu 26.04.
CPU Microarchitecture & Memory Hierarchy: L1/L2/L3 cache lines, MESI/MOESI cache coherency protocols, false sharing, store buffers, Translation Lookaside Buffers (TLB), and hardware prefetchers.
NUMA & CXL 3.0: Non-Uniform Memory Access node topologies (numactl, hwloc/lstopo), PCIe Gen 5/6 lanes, and Compute Express Link (CXL) memory pooling/tiering (Type 1, 2, and 3 devices exposed as CPU-less NUMA nodes).
The Oxidized Ubuntu 26.04 Userspace (03-oxidized-userspace-and-binary-abi):
Rust Coreutils (uutils) & sudo-rs: Architectural comparison between GNU coreutils and Ubuntu 26.04's default Rust replacements (coreutils, findutils, diffutils, sudo-rs, ntpd-rs), locale/UTF-8 handling, and binary size/security profiles.
ELF & Dynamic Linking (glibc 2.43): Dissecting ELF64 headers, Program Headers vs Section Headers, Procedure Linkage Table (PLT) and Global Offset Table (GOT), lazy vs immediate binding (BIND_NOW), LD_PRELOAD hooking, rpath/runpath, and DWARF debug symbol resolution via debuginfod.
Module 02: Linux Kernel Internals I — Core, Scheduling, Interrupts & Locking
A deep dive into execution contexts, scheduling algorithms, and concurrency primitives inside Linux Kernel 7.0.
Kernel Core & Rust-for-Linux (01-kernel-core-and-rust-for-linux):
Boot & Init: From architecture-specific head.S to start_kernel(), early boot allocators (memblock), initcall levels, and transitioning to PID 1.
Rust in the Kernel: How the kernel compiles Rust (rustc + bindgen), safe wrappers around unsafe C structures (ARef<T>, LockedBy), custom kernel allocators (KBox, KVec with GFP_KERNEL flags), and the Nova Rust-based GPU driver architecture.
Core Data Structures: Doubly linked intrusive lists (struct list_head), Red-Black trees (rbtree), XArray, and the Maple Tree (a cache-efficient B-tree that replaced red-black trees for Virtual Memory Areas).
Syscall Boundary & Interrupt Handling (02-syscall-boundary-and-interrupts):
Ring Transitions: SYSCALL/SYSRET instructions, Model-Specific Registers (MSR_LSTAR), kernel stack switching, pt_regs, KPTI (Kernel Page Table Isolation), and how vDSO + vvar map kernel time/CPU state directly into userspace to avoid ring transitions for clock_gettime() and getcpu().
Top-Halves & Bottom-Halves: Local APIC and I/O APIC, MSI/MSI-X PCIe message-signaled interrupts, softirqs (NET_RX_SOFTIRQ, BLOCK_SOFTIRQ), ksoftirqd threads, threaded IRQs, and Concurrency-Managed Workqueues (cmwq / kworker).
Process Management & Scheduling (03-process-lifecycle-and-cpu-scheduling):
task_struct & Creation: Memory layout of task_struct, thread groups (tgid vs pid), kernel threads (kthreadd), and unified process/thread creation via clone3() (struct clone_args, CLONE_PIDFD).
The EEVDF Scheduler: How Earliest Eligible Virtual Deadline First replaced CFS: calculating virtual runtime (vruntime), virtual lag (lag 
i
	
 =S−s 
i
	
 ), eligible timestamps (v 
e
	
 ), virtual deadlines (v 
d
	
 =v 
e
	
 + 
w 
i
	
 
r 
i
	
 
	
 ), and latency-nice (SCHED_ATTR) tuning for latency-sensitive workloads without boosting CPU share.
sched_ext (BPF Extensible Scheduler): Writing and loading custom CPU schedulers dynamically in eBPF (struct sched_ext_ops: scx_rusty, scx_lavd, scx_bpfland) with automatic kernel watchdog fallback if a BPF scheduler stalls.
Synchronization & Concurrency (04-kernel-synchronization-and-locking):
Locking Hierarchy: Queued spinlocks (qspinlock using MCS lock queues to avoid cache-line bouncing across 100+ cores), sleeping mutex with optimistic spinning, reader-writer semaphores (rw_semaphore), and sequence locks (seqlock used in timekeeping).
RCU (Read-Copy-Update): Publish-subscribe pointers (rcu_assign_pointer, rcu_dereference), quiescent states, grace period detection, synchronize_rcu() vs call_rcu(), and Sleepable RCU (SRCU).
Module 03: Linux Kernel Internals II — Memory Management, VFS & I/O
How the kernel manages physical RAM, virtual address spaces, filesystems, and high-speed asynchronous I/O.
Virtual Memory & Paging (01-virtual-memory-and-page-tables):
Address Space Layout: mm_struct, managing vm_area_struct (VMAs) with lockless per-VMA locks and Maple Trees (eliminating mmap_lock contention during multithreaded page faults).
Multi-Level Page Tables: 4-level (48-bit, 256 TB) and 5-level (PGD → P4D → PUD → PMD → PTE, 57-bit, 128 PB) page walks, PCID (Process Context Identifiers) to avoid TLB flushes on context switches, and IPI-driven TLB shootdowns.
Physical Memory, Folios & Reclaim (02-physical-memory-folios-and-reclaim):
Memory Folios: Why the kernel replaced raw struct page pointers with struct folio—representing contiguous power-of-two physical pages as a single unit to slash page table overhead, speed up page cache lookups, and enable multi-size Transparent HugePages (mTHP).
SLUB Allocator: Per-CPU slabs, partial slab lists, object poisoning, SLAB_VIRTUAL (mitigating cross-cache heap exploitation), and inspecting slab caches via /proc/slabinfo and slabtop.
Multi-Gen LRU (MGLRU) & DAMON: How MGLRU uses multiple generations, page table aging scans, and Bloom filters to make superior eviction choices compared to classic active/inactive LRU lists, plus DAMON (Data Access Monitor) for proactive memory tiering across DRAM and CXL/swap.
VFS, Page Cache & io_uring (03-vfs-page-cache-and-async-io):
VFS Internals: The four core objects (super_block, inode, dentry, file), RCU-walk vs REF-walk path resolution (path_lookupat), and how the Page Cache unifies read()/write() and mmap() via struct address_space radix/XArray trees.
io_uring Deep Dive: Shared memory Submission Queue (SQ) and Completion Queue (CQ) ring buffers, Submission Queue Entries (SQEs), fixed/registered files and buffers, kernel-side submission polling (IORING_SETUP_SQPOLL for zero-syscall I/O), and io_uring multishot network accept/recv.
Module 04: Linux Kernel Internals III — Isolation, Security & eBPF
The kernel mechanisms that make containers, sandboxes, zero-trust enforcement, and kernel programmability possible.
Namespaces & Mounts (01-namespaces-and-container-primitives):
The 8 Namespaces: Deep dive into mnt, pid, net, ipc, uts, user, cgroup, and time (timens for monotonic/boot clock offsets during container checkpoint/restore).
Idmapped Mounts & New Syscalls: How mount_setattr() with MOUNT_ATTR_IDMAP shifts UID/GID ownership at the VFS mount layer without recursive chown, and inspecting namespaces/mounts directly without /proc via the listns(), statmount(), and listmount() syscalls.
cgroups v2 & Device Memory (02-cgroups-v2-and-resource-accounting):
Unified Hierarchy Rules: Why Ubuntu 26.04 completely drops cgroup v1; enforcing the "no internal processes" constraint, subtree controllers (cgroup.subtree_control), PSI (memory.pressure, cpu.pressure, io.pressure), and the dmem controller for enforcing hard limits and low/min protection on GPU VRAM and accelerator memory regions.
eBPF Virtual Machine & Live Updates (04-ebpf-subsystem-and-live-updates):
Verifier & CO-RE: The 11-register 64-bit eBPF ISA, abstract interpretation and path pruning in the in-kernel Verifier, BTF (BPF Type Format), and CO-RE (Compile Once – Run Everywhere) relocations.
Attach Points: kprobes/kretprobes, fentry/fexit (zero-overhead trampolines replacing kprobes), tracepoints, uprobes, LSM hooks, struct_ops, and Live Update Orchestrator (LUO) for sub-second kexec kernel upgrades that keep VMs and PCIe devices alive in memory.
Modules 05–09: Systems Programming, Administration, Storage, Networking & Security
These modules bridge kernel primitives with production infrastructure engineering:
Module 05 (Systems Programming): Writing production daemons in Go and Rust that use raw Linux syscalls (clone3, pidfd_open, io_uring, fanotify), integrate natively with systemd via Varlink (the lightweight JSON IPC replacing D-Bus for critical early-boot systemd services), and embed Aya (Rust) / cilium-ebpf (Go) bytecode directly into a single static binary.
Module 06 (Systems Admin & Immutable Linux): Complete coverage of Unified Kernel Images (UKI), TPM 2.0 PCR policies (systemd-pcrlock), Ubuntu 26.04's authd OIDC authentication broker, systemd-oomd, run0 (systemd's privilege elevation replacement), Ubuntu Core 26, and composing immutable runtime layers with systemd-sysext and systemd-confext verified by dm-verity.
Module 07 (Storage, Filesystems & Encryption): Covering NVMe ZNS (Zoned Namespaces), Ubuntu 26.04's hardware-backed TPM 2.0 Full Disk Encryption (fde), headless unlocking via Clevis/Tang (NBDE), Ext4 large folios, XFS online autonomous self-healing, deep OpenZFS engineering (dRAID, ARC/L2ARC, ZIL/SLOG, native encryption, zfs send --raw), and multi-node MicroCeph / Ceph BlueStore.
Module 08 (Network Engineering & SDN): Tracing sk_buff and NAPI through to BBRv3, Multipath TCP (MPTCP), Netplan, VRF routing, eBPF netkit devices (replacing veth pairs for container networking to eliminate backlog queue latency), Open vSwitch / OVN, and spine-leaf BGP EVPN fabrics using FRRouting (FRR).
Module 09 (Security, Cryptography & Compliance): Mastering AppArmor 4.0 (including Ubuntu 26.04's interactive Security Center prompting daemon), Landlock LSM, OpenSSH Certificate Authorities with FIDO2 ed25519-sk hardware keys, advanced nftables verdict maps and flowtables, Post-Quantum Cryptography (ML-KEM / ML-DSA) in OpenSSL 3.x, private ACME PKI with step-ca, and Ubuntu Pro USG (CIS / DISA-STIG) auditing.
Module 10: High-Performance, Real-Time & AI Infrastructure
This dedicated module makes the book indispensable for engineers building AI training/inference clusters, quantitative trading platforms, and telecom/edge systems:
Mainline Real-Time Linux (01-deterministic-and-realtime-linux):
Configuring PREEMPT_RT (now fully mainlined in the Linux kernel), converting spinlocks to sleeping rt_mutex with Priority Inheritance, isolating CPU cores (isolcpus, nohz_full, rcu_nocbs), pinning hardware interrupts, and validating sub-10-microsecond worst-case jitter using rtla osnoise, rtla timerlat, and cyclictest.
Kernel Bypass & RDMA (02-kernel-bypass-and-ultra-fast-networking):
Writing high-speed packet filters in XDP (eBPF Express Data Path) at the NIC driver before sk_buff allocation, zero-copy userspace packet processing via AF_XDP sockets, DPDK Poll Mode Drivers, and RDMA over Converged Ethernet (RoCEv2) with Priority Flow Control (PFC) and ECN.
GPU & AI Cluster Engineering (03-gpu-compute-and-ai-cluster-engineering):
Installing and managing NVIDIA Open Kernel Modules + CUDA and Ubuntu 26.04's native AMD ROCm stack; hardware partitioning via NVIDIA MIG (Multi-Instance GPU) and SR-IOV; multi-node collective communications over NVLink / NCCL / RCCL with GPUDirect RDMA and GPUDirect Storage (GDS); and deploying high-throughput inference servers (vLLM, SGLang, Triton) managed by systemd and Kubernetes.
Modules 11–16: Virtualization, Cloud-Native, DevOps, Observability, GitOps & Blueprints
Your original core modules (09–13 in your first prompt, now 11–16) are expanded to match the rest of the encyclopedia:
Module 11 (Virtualization & Private Cloud): Adds low-level Intel VT-x / AMD-V VMCS/EPT walk-throughs, vhost-user / virtiofs, Confidential Computing (AMD SEV-SNP, Intel TDX, and PCIe IDE/TSM link encryption), Cloud Hypervisor / Firecracker, Incus / LXD, Canonical MAAS, MicroCloud, Proxmox VE, and OpenStack Sunbeam.
Module 12 (Containers & Kubernetes): Covers building a container runtime in ~200 lines of Go/Rust (clone3 + pivot_root + cgroups v2), low-level OCI runtimes (runc, crun, Rust-based youki), Podman Quadlet, Chiseled Ubuntu (rockcraft), Supply Chain Security (cosign, SBOMs), Kubernetes Dynamic Resource Allocation (DRA) for GPUs, Cilium eBPF CNI (with netkit and Envoy Gateway API), and Kata Containers.
Module 13 (DevOps, IaC & Platform Engineering): Covers Git plumbing internals, Dagger programmable CI pipelines, OpenTofu, Pulumi, building OS images with Packer and mkosi, bootable OCI containers (bootc), Ansible Execution Environments, Canonical Juju, and reproducible toolchains with Nix Flakes.
Module 14 (Observability, SRE & Performance): Full-stack OpenTelemetry (OTel) collector pipelines, zero-code eBPF auto-instrumentation (Grafana Beyla / OBI), the LGTM stack (Loki, Grafana, Tempo, Mimir/VictoriaMetrics), continuous eBPF flamegraph profiling (Pyroscope / Parca), BCC / bpftrace kernel one-liners, and Chaos Engineering.
Module 15 (GitOps & Cloud-Native Control Planes): Deep mastery of Argo CD & Flux CD, manifest engineering with Helm, Kustomize, and CUE (Timoni), secrets management with SOPS + Age, External Secrets Operator, and OpenBao, progressive delivery (Argo Rollouts), and managing bare-metal/VMs/cloud infrastructure via KubeVirt, Cluster API (CAPI), and Crossplane / KRO.
Module 16 (Appendices, Runbooks & Blueprints): Cross-distro translation matrices, 5 Battle-Tested Emergency Runbooks (Boot/LUKS recovery, D-state/OOM kernel deadlocks, ZFS/Ceph storage recovery, BGP/MTU/conntrack blackholes, and live eBPF breach containment), plus 3 Complete Reference Architecture Blueprints (Sovereign Homelab, Production HA Kubernetes Platform, and Multi-Node AI Inference/Training Cluster).

---

## Part III: Standardized Chapter & Workbook Architecture
To keep a 210+ chapter project cohesive, every .qmd file can follow a strict architectural pattern:
Conceptual Chapter Pattern (01-*.qmd to 06-*.qmd):
First-Principles Mental Model: ASCII/Mermaid architecture diagram showing kernel structs, ring boundaries, or network packet flows.
Under the Hood (Kernel / Source Reference): Exact kernel struct names, /proc or /sys knobs, syscalls, and config paths in Ubuntu 26.04.
Production Configuration & CLI Craft: Copy-pasteable, idempotent commands, systemd units, Netplan YAML, or eBPF scripts.
Verification & Observability: How to prove it works and measure its performance (perf, bpftool, ss, iotop, resolvectl).
Failure Modes & Pitfalls: Common production footguns and how to avoid them.
Workbook Pattern (0X-workbook/01-*-workbook.qmd):
Declarative Lab Bootstrap: An incus launch or virsh script that spins up isolated Ubuntu 26.04 VMs/containers in 30 seconds.
Guided Build Labs (3 per module): End-to-end engineering tasks combining all sections of the module.
Chaos & Break/Fix Scenarios (3 per module): A pre-broken script that injects a realistic production fault (e.g., slab leak, broken PAM stack, asymmetric VRF routing, failing CNI plugin) that the reader must diagnose and fix without hints.

---

## Complete Directory and Chapter Index (230 Chapters)


### Module 01-hardware-architecture-and-modern-userspace

#### Section: Silicon & System Architecture (`01-silicon-and-system-architecture`)

- [ ] `01-isa-landscapes-x86-64-v3-arm64-and-riscv64.qmd`
- [ ] `02-cpu-microarchitecture-caches-branch-prediction-and-simd.qmd`
- [ ] `03-numa-topologies-interconnects-and-cache-coherency.qmd`
- [ ] `04-pcie-gen6-cxl-compute-express-link-and-iommu-dmar.qmd`

#### Section: OS Architecture & Filesystem (`02-os-architecture-and-filesystem-layout`)

- [ ] `01-ubuntu-2604-resolute-raccoon-architecture-and-abi.qmd`
- [ ] `02-fhs-30-usr-merge-and-stateless-system-design.qmd`
- [ ] `03-pseudo-filesystems-procfs-sysfs-debugfs-tracefs-configfs.qmd`
- [ ] `04-hardware-abstraction-udev-devtmpfs-and-hwdb.qmd`

#### Section: Oxidized Userspace & ABI (`03-oxidized-userspace-and-binary-abi`)

- [ ] `01-uutils-rust-coreutils-findutils-and-diffutils-internals.qmd`
- [ ] `02-sudo-rs-ntp-rs-and-memory-safe-system-daemons.qmd`
- [ ] `03-elf-binary-format-plt-got-and-dwarf-debugging-data.qmd`
- [ ] `04-glibc-243-musl-dynamic-linking-ld-so-and-vdso.qmd`
- [ ] `05-modern-terminal-engineering-ptyxis-ghostty-and-shell-craft.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-hardware-userspace-abi-workbook.qmd`


### Module 02-linux-kernel-internals-core-scheduling-and-locking

#### Section: Kernel Core & Rust-for-Linux (`01-kernel-core-and-rust-for-linux`)

- [ ] `01-linux-70-source-tree-kbuild-kconfig-and-boot-init.qmd`
- [ ] `02-monolithic-core-loadable-kernel-modules-dkms-and-btf.qmd`
- [ ] `03-rust-for-linux-abstractions-bindings-and-nova-driver-model.qmd`
- [ ] `04-kernel-data-structures-linked-lists-rbtrees-xarray-maple-tree.qmd`

#### Section: Syscalls & Interrupts (`02-syscall-boundary-and-interrupts`)

- [ ] `01-ring-transitions-syscall-entry-exit-kpti-and-vdso.qmd`
- [ ] `02-hardware-interrupts-apic-msi-x-and-irq-affinity.qmd`
- [ ] `03-bottom-halves-softirqs-tasklets-threaded-irqs-and-workqueues.qmd`

#### Section: Process & CPU Scheduling (`03-process-lifecycle-and-cpu-scheduling`)

- [ ] `01-task-struct-anatomy-pid-hashtables-and-process-states.qmd`
- [ ] `02-process-and-thread-creation-fork-vfork-clone3-and-execve.qmd`
- [ ] `03-eevdf-scheduler-virtual-deadlines-lag-and-slice-mechanics.qmd`
- [ ] `04-hybrid-cpu-scheduling-p-cores-e-cores-and-energy-aware-eas.qmd`
- [ ] `05-extensible-scheduler-class-sched-ext-and-bpf-schedulers.qmd`
- [ ] `06-realtime-scheduling-sched-fifo-rr-deadline-and-preempt-rt.qmd`

#### Section: Synchronization & Locking (`04-kernel-synchronization-and-locking`)

- [ ] `01-atomic-operations-memory-barriers-and-lockless-algorithms.qmd`
- [ ] `02-spinlocks-qspinlock-mutexes-rt-mutex-and-rwsems.qmd`
- [ ] `03-read-copy-update-rcu-grace-periods-and-srcu.qmd`
- [ ] `04-lockdep-Concurrency-sanitizer-kcsan-and-deadlock-debugging.qmd`

#### Section: Workbook (`05-workbook`)

- [ ] `01-kernel-scheduling-locking-workbook.qmd`


### Module 03-linux-kernel-internals-memory-vfs-and-io

#### Section: Virtual Memory & Page Tables (`01-virtual-memory-and-page-tables`)

- [ ] `01-mm-struct-vm-area-struct-and-maple-tree-vma-management.qmd`
- [ ] `02-4-level-and-5-level-paging-tlb-shootdowns-and-pcid-asid.qmd`
- [ ] `03-page-fault-handling-anonymous-memory-cow-and-demand-paging.qmd`
- [ ] `04-transparent-hugepages-thp-hugetlbfs-and-dynamic-hugetlb.qmd`

#### Section: Physical Memory & Reclaim (`02-physical-memory-folios-and-reclaim`)

- [ ] `01-numa-zones-nodes-buddy-allocator-and-per-cpu-pagesets.qmd`
- [ ] `02-memory-folios-migration-from-struct-page-and-large-folios.qmd`
- [ ] `03-slub-allocator-internals-kmem-cache-and-kmalloc-buckets.qmd`
- [ ] `04-multi-gen-lru-mglru-kswapd-direct-reclaim-and-damon.qmd`
- [ ] `05-memory-compaction-cma-zswap-zram-and-psi-oom-killer.qmd`

#### Section: VFS, Page Cache & Async I/O (`03-vfs-page-cache-and-async-io`)

- [ ] `01-vfs-object-model-superblock-inode-dentry-and-file.qmd`
- [ ] `02-page-cache-address-space-writeback-dirty-throttling-and-pdflush.qmd`
- [ ] `03-synchronous-vs-nonblocking-io-epoll-internallock-and-splice.qmd`
- [ ] `04-io-uring-submission-completion-rings-sqpoll-and-zero-copy.qmd`

#### Section: Block Layer & Drivers (`04-block-layer-and-device-drivers`)

- [ ] `01-bio-structures-request-queues-and-blk-mq-multi-queue.qmd`
- [ ] `02-io-schedulers-kyber-bfq-mq-deadline-and-none.qmd`
- [ ] `03-char-block-net-driver-models-dma-engine-and-iommu-mapping.qmd`

#### Section: Workbook (`05-workbook`)

- [ ] `01-kernel-memory-vfs-io-workbook.qmd`


### Module 04-linux-kernel-internals-isolation-security-and-ebpf

#### Section: Namespaces & Primitives (`01-namespaces-and-container-primitives`)

- [ ] `01-nsproxy-and-the-8-namespaces-mnt-pid-net-ipc-uts-user-cgroup-time.qmd`
- [ ] `02-user-namespaces-uid-gid-mappings-and-idmapped-mounts.qmd`
- [ ] `03-mount-propagation-shared-subtrees-pivot-root-and-overlayfs.qmd`
- [ ] `04-namespace-introspection-unshare-nsenter-statmount-and-listns.qmd`

#### Section: cgroups v2 & Accounting (`02-cgroups-v2-and-resource-accounting`)

- [ ] `01-cgroups-v2-unified-hierarchy-subtree-control-and-no-internal-procs.qmd`
- [ ] `02-cpu-memory-and-io-controllers-weights-max-and-qos.qmd`
- [ ] `03-pids-cpuset-hugetlb-rdma-and-misc-controllers.qmd`
- [ ] `04-dmem-gpu-device-memory-cgroup-controller-and-bpf-cgroups.qmd`

#### Section: Kernel Security Subsystems (`03-kernel-security-subsystems`)

- [ ] `01-posix-capabilities-bounding-ambient-inheritable-and-effective-sets.qmd`
- [ ] `02-seccomp-bpf-syscall-filtering-and-seccomp-unotify.qmd`
- [ ] `03-linux-security-modules-lsm-stacking-apparmor-selinux-landlock-bpf.qmd`
- [ ] `04-kernel-keyrings-ima-evm-integrity-and-kernel-lockdown-mode.qmd`

#### Section: eBPF & Live Updates (`04-ebpf-subsystem-and-live-updates`)

- [ ] `01-ebpf-isa-jit-compiler-verifier-state-pruning-and-btf-co-re.qmd`
- [ ] `02-ebpf-maps-ringbuffers-kprobes-uprobes-tracepoints-and-fentry.qmd`
- [ ] `03-kexec-live-update-orchestrator-luo-and-canonical-livepatch.qmd`

#### Section: Workbook (`05-workbook`)

- [ ] `01-kernel-isolation-ebpf-workbook.qmd`


### Module 05-systems-programming-and-automation

#### Section: Shell & Stream Engineering (`01-shell-and-stream-engineering`)

- [ ] `01-defensive-bash-posix-sh-set-euo-pipefail-and-trap-handling.qmd`
- [ ] `02-structured-data-pipelines-jq-yq-miller-awk-sed-and-ripgrep.qmd`
- [ ] `03-modern-shells-nushell-fish-zsh-and-cli-ergonomics.qmd`

#### Section: Go & Rust Systems Programming (`02-systems-software-in-go-and-rust`)

- [ ] `01-raw-syscalls-nix-rustix-crates-and-golang-x-sys-unix.qmd`
- [ ] `02-writing-async-daemons-tokio-io-uring-and-go-netpoll.qmd`
- [ ] `03-systemd-ipc-integration-sd-notify-socket-activation-dbus-varlink.qmd`
- [ ] `04-writing-ebpf-programs-in-rust-aya-and-go-cilium-ebpf.qmd`

#### Section: Debugging, Tracing & Profiling (`03-debugging-tracing-and-profiling`)

- [ ] `01-syscall-and-library-tracing-strace-ltrace-and-sysdig.qmd`
- [ ] `02-interactive-debugging-gdb-lldb-coredumpctl-and-debuginfod.qmd`
- [ ] `03-hardware-performance-counters-perf-ftrace-bpftrace-and-flamegraphs.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-systems-programming-debugging-workbook.qmd`


### Module 06-systems-administration-and-immutable-linux

#### Section: Boot, Firmware & Trusted Compute (`01-boot-firmware-and-trusted-compute`)

- [ ] `01-uefi-internals-secure-boot-custom-keys-db-kek-pk-and-sbctl.qmd`
- [ ] `02-tpm-20-architecture-pcr-banks-measured-boot-and-attestation.qmd`
- [ ] `03-unified-kernel-images-uki-ukify-systemd-boot-and-grub2.qmd`
- [ ] `04-initramfs-engineering-dracut-initramfs-tools-and-systemd-initrd.qmd`

#### Section: Provisioning & Lifecycle (`02-provisioning-and-lifecycle`)

- [ ] `01-ubuntu-autoinstall-subiquity-curtin-and-cloud-init-nocloud.qmd`
- [ ] `02-network-booting-ipxe-uefi-http-boot-and-netboot-xyz.qmd`
- [ ] `03-factory-reset-systemd-firstboot-repart-and-sysupdate.qmd`

#### Section: Identity & Privilege (`03-identity-authentication-and-privilege`)

- [ ] `01-nss-pam-stack-architecture-and-local-account-cryptography.qmd`
- [ ] `02-enterprise-directory-integration-sssd-freeipa-active-directory.qmd`
- [ ] `03-ubuntu-authd-oidc-entra-id-google-cloud-identity-and-fido2-pam.qmd`
- [ ] `04-privilege-elevation-sudo-rs-polkit-and-run0-systemd-run.qmd`

#### Section: Packaging & systemd (`04-packaging-and-systemd-mastery`)

- [ ] `01-apt-30-solver3-deb822-sources-dpkg-and-local-apt-repos.qmd`
- [ ] `02-snapd-squashfs-apparmor-interfaces-and-modular-kernel-firmware.qmd`
- [ ] `03-systemd-unit-types-dependencies-targets-timers-and-paths.qmd`
- [ ] `04-systemd-resource-control-slices-scopes-and-oomd.qmd`
- [ ] `05-systemd-service-hardening-sandboxing-directives-and-dynamicuser.qmd`

#### Section: Immutable & Image-Based Linux (`05-immutable-and-image-based-os`)

- [ ] `01-ubuntu-core-uc26-snaps-gadgets-and-transactional-updates.qmd`
- [ ] `02-systemd-sysext-confext-portable-services-and-verity-dm-verity.qmd`
- [ ] `03-time-and-crash-diagnostics-chrony-nts-ptp-journald-and-kdump.qmd`

#### Section: Workbook (`06-workbook`)

- [ ] `01-systems-administration-workbook.qmd`


### Module 07-storage-filesystems-and-encryption

#### Section: Block Devices & Volumes (`01-block-devices-and-volume-management`)

- [ ] `01-nvme-architecture-namespaces-zns-and-multipath-io-dm-multipath.qmd`
- [ ] `02-gpt-partitioning-udev-persistent-naming-and-systemd-repart.qmd`
- [ ] `03-device-mapper-lvm2-thin-provisioning-vdo-and-dm-cache.qmd`
- [ ] `04-software-raid-mdadm-raid-levels-write-holes-and-scrubbing.qmd`

#### Section: Cryptographic Storage (`02-cryptographic-storage`)

- [ ] `01-dm-crypt-luks2-argon2id-kdf-and-authenticated-disk-encryption.qmd`
- [ ] `02-ubuntu-2604-tpm-backed-fde-passphrase-pin-and-recovery-keys.qmd`
- [ ] `03-systemd-cryptenroll-tpm2-fido2-pkcs11-and-pcrlock.qmd`
- [ ] `04-network-bound-disk-encryption-nbde-clevis-tang-and-fscrypt.qmd`

#### Section: Local & CoW Filesystems (`03-local-and-copy-on-write-filesystems`)

- [ ] `01-ext4-internals-journaling-modes-large-folios-and-fsverity.qmd`
- [ ] `02-xfs-allocation-groups-reflinks-and-online-autonomous-self-healing.qmd`
- [ ] `03-openzfs-zpools-draid-arc-l2arc-zil-slog-and-native-encryption.qmd`
- [ ] `04-openzfs-administration-datasets-zvols-snapshots-and-zfs-send-recv.qmd`
- [ ] `05-btrfs-subvolumes-qgroups-raid-profiles-and-bcachefs-overview.qmd`

#### Section: Networked & Distributed Storage (`04-networked-and-distributed-storage`)

- [ ] `01-nfsv42-pNFS-rpcsec-gss-kerberos-smb3-multichannel-and-autofs.qmd`
- [ ] `02-san-protocols-iscsi-targetcli-nvme-over-fabrics-tcp-and-rdma.qmd`
- [ ] `03-ceph-architecture-rados-bluestore-crush-maps-and-microceph.qmd`
- [ ] `04-ceph-interfaces-rbd-block-cephfs-posix-and-radosgw-s3.qmd`

#### Section: Benchmarking & Recovery (`05-storage-benchmarking-and-recovery`)

- [ ] `01-fio-workload-modeling-iops-latency-percentiles-and-biolatency.qmd`
- [ ] `02-smartmontools-nvme-cli-badblocks-testdisk-and-fs-forensics.qmd`

#### Section: Workbook (`06-workbook`)

- [ ] `01-storage-filesystems-encryption-workbook.qmd`


### Module 08-network-engineering-and-software-defined-networking

#### Section: Network Stack & Configuration (`01-linux-network-stack-and-configuration`)

- [ ] `01-packet-journey-nic-ring-buffers-dma-napi-gro-gso-and-sk-buff.qmd`
- [ ] `02-netplan-declarative-yaml-systemd-networkd-and-networkmanager.qmd`
- [ ] `03-iproute2-advanced-routing-policy-tables-rules-vrfs-and-ecmp.qmd`
- [ ] `04-tcp-congestion-control-bbrv3-cubic-mptcp-and-quic-offloads.qmd`

#### Section: Switching, Bridging & Overlays (`02-switching-bridging-and-overlays`)

- [ ] `01-layer2-linux-bridging-8021q-vlans-qinq-and-8023ad-lacp-bonding.qmd`
- [ ] `02-virtual-interfaces-veth-macvlan-ipvlan-tun-tap-and-netkit-ebpf.qmd`
- [ ] `03-open-vswitch-ovs-ovsdb-openflow-pipelines-and-ovn-architecture.qmd`
- [ ] `04-datacenter-fabrics-vxlan-geneve-and-bgp-evpn-with-frrouting-bird.qmd`

#### Section: DNS, Load Balancing & Edge HA (`03-dns-load-balancing-and-edge-ha`)

- [ ] `01-systemd-resolved-split-dns-mdns-dnssec-and-dns-over-tls-https.qmd`
- [ ] `03-vrrp-high-availability-keepalived-ipvs-lvs-and-anycast-bgp.qmd`
- [ ] `04-l4-l7-reverse-proxies-haproxy-envoy-nginx-and-caddy.qmd`

#### Section: VPNs & Packet Diagnostics (`04-vpns-and-packet-diagnostics`)

- [ ] `01-wireguard-cryptokey-routing-and-zero-trust-meshes-tailscale-netbird.qmd`
- [ ] `02-enterprise-ipsec-strongswan-ikev2-and-xfrm-interfaces.qmd`

#### Section: Workbook (`05-workbook`)

- [ ] `01-network-engineering-workbook.qmd`


### Module 09-security-cryptography-and-compliance

#### Section: Access Control & Sandboxing (`01-mandatory-access-control-and-sandboxing`)

- [ ] `01-posix-dac-acls-xattrs-chattr-immutable-bits-and-file-capabilities.qmd`
- [ ] `02-apparmor-40-architecture-profile-authoring-aa-logprof-and-prompting.qmd`
- [ ] `03-selinux-vs-apparmor-type-enforcement-mcs-and-cross-distro-contexts.qmd`
- [ ] `04-unprivileged-sandboxing-landlock-lsm-bubblewrap-and-seccomp-filters.qmd`

#### Section: Network Security & SSH (`02-network-security-and-ssh-architecture`)

- [ ] `01-openssh-zero-trust-ca-signed-certificates-fido2-sk-and-bastions.qmd`
- [ ] `02-nftables-deep-dive-families-hooks-verdict-maps-sets-and-flowtables.qmd`
- [ ] `03-ufw-firewalld-and-dynamic-threat-blocking-with-crowdsec-fail2ban.qmd`
- [ ] `04-network-intrusion-detection-suricata-zeek-and-ebpf-tetragonsensors.qmd`

#### Section: Cryptography, PKI & PQC (`03-cryptography-pki-and-post-quantum`)

- [ ] `01-openssl-3x-architecture-providers-fips-140-3-and-gnutls.qmd`
- [ ] `02-post-quantum-cryptography-ml-kem-ml-dsa-hybrid-tls-and-ssh.qmd`
- [ ] `03-private-pki-engineering-smallstep-step-ca-acme-pkcs11-and-hsm.qmd`

#### Section: Auditing & Compliance (`04-auditing-compliance-and-vulnerability`)

- [ ] `01-linux-audit-subsystem-auditd-rules-ausearch-and-ebpf-auditing.qmd`
- [ ] `02-fleet-telemetry-osquery-wazuh-aide-and-ima-evm-attestation.qmd`
- [ ] `03-ubuntu-pro-usg-cis-disa-stig-openscap-and-cve-livepatching.qmd`

#### Section: Workbook (`05-workbook`)

- [ ] `01-security-cryptography-compliance-workbook.qmd`


### Module 10-high-performance-realtime-and-ai-infrastructure

#### Section: Real-Time & Low-Latency Linux (`01-deterministic-and-realtime-linux`)

- [ ] `01-mainline-preempt-rt-threaded-irqs-priority-inheritance-and-locking.qmd`
- [ ] `02-cpu-isolation-isolcpus-nohz-full-rcu-nocbs-and-irqbalance.qmd`
- [ ] `03-latency-measurement-cyclictest-rtla-osnoise-and-timerlat.qmd`

#### Section: Kernel Bypass & Ultra-Fast Net (`02-kernel-bypass-and-ultra-fast-networking`)

- [ ] `01-xdp-express-data-path-native-offload-and-af-xdp-zero-copy-sockets.qmd`
- [ ] `02-dpdk-data-plane-development-kit-vfio-pmd-and-hugepage-memory.qmd`
- [ ] `03-rdma-architecture-infiniband-rocev2-libibverbs-and-gpudirect-rdma.qmd`

#### Section: GPU & AI Cluster Engineering (`03-gpu-compute-and-ai-cluster-engineering`)

- [ ] `01-gpu-driver-stacks-nvidia-open-kernel-modules-cuda-and-amd-rocm.qmd`
- [ ] `02-gpu-partitioning-nvidia-mig-mps-sriov-and-dmem-cgroups.qmd`
- [ ] `03-ai-interconnects-nvlink-nvswitch-nccl-rccl-and-gpudirect-storage.qmd`
- [ ] `04-production-llm-inference-engines-vllm-sglang-triton-and-llama-cpp.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-hpc-realtime-ai-infrastructure-workbook.qmd`


### Module 11-virtualization-and-private-cloud

#### Section: Hypervisor Internals & KVM (`01-hypervisor-internals-and-kvm`)

- [ ] `01-hardware-virtualization-intel-vt-x-amd-v-ept-npt-and-vmcs.qmd`
- [ ] `02-kvm-kernel-module-ioctl-api-vcpu-loops-and-qemu-device-emulation.qmd`
- [ ] `03-virtio-architecture-vhost-net-vhost-user-and-virtiofs.qmd`
- [ ] `04-libvirt-daemon-architecture-virsh-xml-domains-and-storage-pools.qmd`

#### Section: Passthrough, MicroVMs & CoCo (`02-hardware-passthrough-and-microvms`)

- [ ] `01-iommu-groups-vfio-pci-sriov-virtual-functions-and-gpu-passthrough.qmd`
- [ ] `02-confidential-computing-amd-sev-snp-intel-tdx-and-pcie-ide-tsm.qmd`
- [ ] `03-modern-vmms-rust-cloud-hypervisor-firecracker-and-crosvm.qmd`
- [ ] `04-lxd-and-incus-unified-system-containers-and-kvm-virtual-machines.qmd`

#### Section: Private Cloud & Bare-Metal (`03-private-cloud-and-bare-metal`)

- [ ] `01-bare-metal-cloud-provisioning-canonical-maas-ipmi-redfish.qmd`
- [ ] `02-cloud-init-architecture-datasources-modules-and-image-bakery.qmd`
- [ ] `03-turnkey-private-clouds-canonical-microcloud-and-proxmox-ve.qmd`
- [ ] `04-enterprise-openstack-sunbeam-microstack-nova-neutron-cinder.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-virtualization-private-cloud-workbook.qmd`


### Module 12-containers-and-kubernetes-orchestration

#### Section: Container Runtimes & Images (`01-container-runtimes-and-image-craft`)

- [ ] `01-building-containers-from-scratch-in-c-go-rust-without-docker.qmd`
- [ ] `02-oci-runtime-and-image-specs-runc-crun-youki-containerd-and-cri-o.qmd`
- [ ] `03-docker-engine-rootless-podman-buildah-skopeo-and-systemd-quadlet.qmd`
- [ ] `04-developer-containers-ptyxis-distrobox-toolbx-and-devcontainers.qmd`
- [ ] `05-production-minimal-images-chiseled-ubuntu-rockcraft-and-distroless.qmd`
- [ ] `06-oci-registries-harbor-zot-cosign-sigstore-sboms-and-trivy.qmd`

#### Section: Kubernetes Architecture (`02-kubernetes-architecture-and-platform`)

- [ ] `01-kubernetes-control-plane-internals-apiserver-etcd-raft-scheduler.qmd`
- [ ] `02-kubelet-cri-cni-csi-and-ubuntu-2604-node-tuning-canonical-k8s.qmd`
- [ ] `03-workload-controllers-deployments-statefulsets-daemonsets-and-jobs.qmd`
- [ ] `04-advanced-scheduling-taints-affinities-topologies-kueue-and-dra.qmd`

#### Section: K8s Net, Storage & Security (`03-kubernetes-networking-storage-security`)

- [ ] `01-ebpf-cni-architecture-cilium-kube-proxy-replacement-and-netkit.qmd`
- [ ] `02-ingress-to-gateway-api-envoy-gateway-and-sidecarless-ambient-mesh.qmd`
- [ ] `03-cloud-native-storage-csi-drivers-rook-ceph-longhorn-and-openebs.qmd`
- [ ] `04-k8s-hardening-pss-cel-validatingadmissionpolicy-kyverno-and-kata.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-containers-kubernetes-workbook.qmd`


### Module 13-devops-iac-and-platform-engineering

#### Section: Version Control & CI/CD (`01-version-control-and-ci-cd-pipelines`)

- [ ] `01-git-internals-object-graph-packfiles-worktrees-and-monorepos.qmd`
- [ ] `02-self-hosted-git-platforms-gitlab-gitea-forgejo-and-runner-fleets.qmd`
- [ ] `03-modern-ci-cd-engineering-github-actions-gitlab-ci-and-dagger.qmd`
- [ ] `04-artifact-and-package-lifecycle-nexus-artifactory-and-pulp.qmd`

#### Section: IaC & Immutable Images (`02-infrastructure-as-code-and-immutable`)

- [ ] `01-declarative-provisioning-opentofu-terraform-state-and-providers.qmd`
- [ ] `02-infrastructure-as-software-pulumi-and-cdk-for-systems.qmd`
- [ ] `03-golden-image-pipelines-hashicorp-packer-mkosi-and-ubuntu-image.qmd`
- [ ] `04-bootable-containers-bootc-ostree-and-transactional-host-updates.qmd`

#### Section: Config & Model-Driven Ops (`03-configuration-and-model-driven-ops`)

- [ ] `01-ansible-architecture-playbooks-roles-collections-and-execution-envs.qmd`
- [ ] `02-canonical-juju-charmed-operators-relations-and-model-driven-ops.qmd`
- [ ] `03-reproducible-builds-and-environments-nix-flakes-and-guix-on-ubuntu.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-devops-iac-platform-workbook.qmd`


### Module 14-observability-sre-and-performance-engineering

#### Section: Telemetry & OpenTelemetry (`01-telemetry-pipelines-and-opentelemetry`)

- [ ] `01-three-pillars-to-unified-telemetry-red-use-methods-and-golden-signals.qmd`
- [ ] `02-opentelemetry-architecture-sdk-otlp-and-otel-collector-pipelines.qmd`
- [ ] `03-zero-code-ebpf-auto-instrumentation-grafana-beyla-and-obi.qmd`

#### Section: Metrics, Logs, Traces & Profiling (`02-metrics-logs-traces-and-profiling`)

- [ ] `01-metrics-at-scale-prometheus-promql-thanos-mimir-and-victoriametrics.qmd`
- [ ] `02-log-aggregation-grafana-loki-logql-vector-fluentbit-and-clickhouse.qmd`
- [ ] `03-distributed-tracing-grafana-tempo-jaeger-and-tail-based-sampling.qmd`
- [ ] `04-continuous-ebpf-profiling-grafana-pyroscope-parca-and-off-cpu-analysis.qmd`

#### Section: Kernel Tracing & SRE (`03-kernel-tracing-and-sre-practices`)

- [ ] `01-deep-kernel-performance-bcc-tools-bpftrace-one-liners-and-perf-spe.qmd`
- [ ] `02-sli-slo-engineering-error-budgets-burn-rate-alerts-and-oncall.qmd`
- [ ] `03-chaos-engineering-fault-injection-tc-netem-stress-ng-and-chaos-mesh.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-observability-sre-performance-workbook.qmd`


### Module 15-gitops-and-cloud-native-control-planes

#### Section: GitOps & Packaging (`01-gitops-architecture-and-packaging`)

- [ ] `01-gitops-principles-reconciliation-loops-and-repo-topologies.qmd`
- [ ] `02-manifest-engineering-helm-kustomize-cue-timoni-and-jsonnet.qmd`
- [ ] `03-argo-cd-architecture-applicationsets-sync-waves-and-app-of-apps.qmd`
- [ ] `04-flux-cd-architecture-source-kustomize-helm-controllers-and-oci-sync.qmd`

#### Section: Secrets & Progressive Delivery (`02-secrets-and-progressive-delivery`)

- [ ] `01-gitops-secrets-sops-age-sealed-secrets-and-external-secrets-operator.qmd`
- [ ] `02-identity-backed-vaults-openbao-hashicorp-vault-and-spiffe-spire.qmd`
- [ ] `03-progressive-delivery-argo-rollouts-flagger-canary-and-blue-green.qmd`

#### Section: Cloud-Native Control Planes (`03-cloud-native-infrastructure-control`)

- [ ] `01-virtual-machines-on-kubernetes-kubevirt-cdi-and-multus-networking.qmd`
- [ ] `02-declarative-kubernetes-lifecycle-cluster-api-capi-metal3-and-k0smotron.qmd`
- [ ] `03-universal-control-planes-crossplane-compositions-and-kro.qmd`
- [ ] `04-internal-developer-platforms-backstage-port-and-golden-paths.qmd`

#### Section: Workbook (`04-workbook`)

- [ ] `01-gitops-cloud-native-workbook.qmd`


### Module 16-appendices-runbooks-and-reference-blueprints

#### Section: Migrations & Interop (`01-migrations-and-interoperability`)

- [ ] `01-ubuntu-2204-2404-to-2604-lts-upgrade-cgroupv1-and-rust-migration.qmd`
- [ ] `02-enterprise-linux-rosetta-stone-rhel-10-debian-13-suse-to-ubuntu-2604.qmd`
- [ ] `03-posix-to-modern-cli-and-legacy-net-tools-to-iproute2-nftables-map.qmd`

#### Section: Emergency Runbooks (`02-production-emergency-runbooks`)

- [ ] `01-unbootable-node-uki-secure-boot-luks2-tpm-and-initramfs-rescue.qmd`
- [ ] `02-kernel-panics-hung-tasks-d-state-io-deadlocks-and-oom-storms.qmd`
- [ ] `03-storage-catastrophes-zfs-pool-recovery-mdadm-rebuild-and-ceph-pg-repair.qmd`
- [ ] `04-network-blackholes-bgp-flaps-mtu-mismatch-conntrack-exhaustion-dns.qmd`
- [ ] `05-active-breach-response-host-isolation-memory-dump-and-ebpf-containment.qmd`

#### Section: Reference Blueprints (`03-end-to-end-reference-blueprints`)

- [ ] `01-sovereign-homelab-and-edge-datacenter-maas-incus-microceph-ovn.qmd`
- [ ] `02-production-ha-kubernetes-platform-capi-cilium-rook-argo-otel.qmd`
- [ ] `03-multi-node-ai-training-and-inference-cluster-rocm-cuda-rdma-vllm.qmd`

