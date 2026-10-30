# Running Multiple Kernels on One Bare-Metal Server — Syllabus & Curriculum

> **Track:** Advanced Linux Systems Engineering & Bare-Metal Specialization  
> **Target Platform:** Ubuntu 26.04 LTS ("Resolute Raccoon"), Modern x86_64 / ARM64 Server Hardware  
> **Status:** Accepted Syllabus & Planning Brief

---

## Purpose and Scope

This syllabus defines an advanced curriculum for systems architects, kernel engineers, and infrastructure operators who need to run multiple operating system kernels concurrently or transitionally on a single physical bare-metal server. It moves systematically from kernel-level resource fundamentals through hardware partitioning, virtualization boundaries, device assignment (VFIO/SR-IOV), CPU/memory isolation, secure multi-tenant boundaries, performance benchmarking, and production operations.

The core question for every chapter: **How do we isolate, assign, observe, and recover distinct kernel execution environments on unified physical hardware without sacrificing bare-metal performance guarantees?**

---

## Detailed Table of Contents

### Introduction: The Multikernel Problem
- **Why You Want Multiple Kernels:** Workload consolidation without hypervisor sprawl, mixed-criticality execution (real-time alongside general purpose), distinct kernel version requirements, driver compatibility constraints, fault isolation, and specialized OS runtimes.
- **What Multikernel Actually Means:** Monolithic shared-kernel vs. distributed/asymmetric multikernel models (e.g., Barrelfish principles applied to Linux), co-located hypervisor partitions, and isolated bare-metal domains.
- **The Landscape of Approaches:** Hardware partitioning (LPAR/BPAR), hardware-assisted Type-1 hypervisors (KVM, Xen, ESXi), microVMs (Cloud-Hypervisor, Firecracker), kernel-to-kernel execution (`kexec`), and container/cgroup boundaries.
- **How to Use This Curriculum:** Reading routes, hardware prerequisites (IOMMU, SR-IOV, NUMA topology), and the progressive lab environment.

### Chapter 1: Linux Kernel Fundamentals
- **The Kernel as Resource Monopolist:** Monolithic address spaces, hardware ownership, interrupt management, and kernel privilege boundaries.
- **Boot and Initialization Sequence:** From firmware reset vector to `start_kernel()`, architecture setup, SMP bringup, and userspace spawning.
- **Hardware Discovery and Enumeration:** ACPI tables, PCIe bus scanning, device tree (ARM64), baseboard management controller (BMC) interactions, and driver binding.
- **CPU Topology and NUMA Architecture:** Sockets, NUMA nodes, Core Complex (CCX/CCD), SMT/hyperthreading threads, interconnects (UPI/Infinity Fabric), and memory access latency penalties.
- **Memory Management Fundamentals:** Physical memory allocation (Buddy allocator, zones, folios), page tables, TLB caches, and address translation overhead.

### Chapter 2: The Boot Process in Depth
- **Firmware and the EFI Environment:** UEFI architecture, EFI system partition (ESP), NVRAM variables, boot manager entries, and handover protocols.
- **Bootloaders: GRUB, systemd-boot, and Others:** Bootloader stages, configuration mechanics, device trees, and EFI stub execution (`systemd-boot`, UKIs).
- **Kernel Command-Line Parameters:** Critical boot parameters for hardware isolation, memory carving, console routing, and scheduler behavior (`isolcpus`, `nohz_full`, `memmap`, `iommu=pt`).
- **Initramfs Construction and Role:** Early userspace responsibilities, module loading, root filesystem discovery, LUKS decryption, and pivot-root mechanics.
- **The Handoff to Userspace:** PID 1 initialization, systemd boot transactions, device readiness waiting, and target activation.

### Chapter 3: Virtualization vs True Bare-Metal Multi-Kernel
- **Type-1 Hypervisors: ESXi, Xen, KVM in Bare-Metal Mode:** Hypervisor topologies, privilege rings (Ring -1 / VMX root mode), control plane footprints, and CPU scheduling models.
- **KVM Architecture Deep Dive:** `/dev/kvm` ioctls, vCPU threads, memory mapping (`EPT` / `NPT`), exit handling, and vmexit performance costs.
- **Linux Containers and Shared-Kernel Architectures:** Namespaces, cgroups v2, shared page caches, and why shared-kernel isolation fails multi-kernel and kernel-fault isolation requirements.
- **MicroVMs and Lightweight Virtualization:** Minimal device models, virtio-over-MMIO, rapid boot (<50ms), and constrained guest footprints (Firecracker, Cloud-Hypervisor).
- **True Bare-Metal Partitioning Concepts:** Hardware-enforced domain partitioning, PCIe fabric partitioning, physical memory segment carving, and firmware-level multikernels.

### Chapter 4: kexec and Kernel-to-Kernel Transitions
- **How kexec Works:** Bypassing BIOS/UEFI firmware reinitialization, memory image staging, machine shutdown sequence, and direct jump to entry point.
- **kexec-tools Configuration and Usage:** Preparing images (`vmlinuz`, initramfs, command line), loading with `kexec -l`, and triggering warm reboots with `kexec -e`.
- **kdump for Crash Dumping:** Crash kernel memory reservation (`crashkernel=`), NMI generation, capturing `/proc/vmcore`, and makedumpfile optimization.
- **Limitations of kexec for Multi-Kernel Goals:** Sequential execution vs. concurrent multi-kernel execution; state leakage and hardware cleanup challenges.
- **Production Use Cases for kexec:** Zero-downtime micro-updates, hypervisor live patching, crash analytics pipelines, and fast cluster node recovery.

### Chapter 5: Hardware-Assisted Multi-Kernel with KVM/QEMU
- **KVM Setup and Kernel Module Configuration:** CPU virtualization flags (`vmx`/`svm`), loading `kvm_intel`/`kvm_amd`, nested virtualization parameters, and device permissions.
- **Guest Kernel Installation and Configuration:** Building stripped production guest kernels, selecting kernel features, and minimizing boot bloat.
- **CPU Pinning and NUMA-Aware VM Placement:** Dedicated vCPU-to-pCPU affinity pinning, vhost thread isolation, memory node binding, and eliminating cross-socket memory traffic.
- **Memory Ballooning vs Static Allocation:** Hugepages allocation (`1G` / `2M`), zero-overcommit policies, pre-faulting memory, and ballooning trade-offs.
- **Complete Working Deployment Example:** Full scriptable configuration deploying two independent, NUMA-isolated Linux kernels on a multi-socket host.

### Chapter 6: Device Assignment and I/O Isolation
- **PCI Passthrough (VFIO) Fundamentals:** VFIO architecture, safe userspace drivers, IOMMU groups, device unbinding from host drivers, and binding to `vfio-pci`.
- **SR-IOV and Virtual Functions:** Single Root I/O Virtualization architecture, Physical Functions (PF) vs. Virtual Functions (VF), provisioning VFs, and MAC/VLAN assignment.
- **Network Interface Assignment:** Direct VF assignment to isolated guest kernels, kernel-bypass interfaces, and avoiding hypervisor vswitch bottlenecks.
- **Storage Device Partitioning:** Direct NVMe controller passthrough, NVMe namespaces assignment, raw block device delegation, and avoiding storage hypervisor overhead.
- **Specialized Hardware: GPUs, FPGAs, Accelerators:** Assigning PCIe AI accelerators, GPU compute slices, PCIe bifurcation, and interrupt delivery considerations.

### Chapter 7: Networking Between Kernel Instances
- **Internal Networking Architectures:** Linux bridges, Open vSwitch (OVS), Macvtap interfaces, and internal point-to-point tap links.
- **External Network Configuration:** Dedicated physical uplink partitioning, VLAN trunking to virtual functions, and BGP/EVPN routed host networks.
- **Network Performance Optimization:** Virtio-net multi-queue tuning, vhost-net kernel acceleration, offloads (TSO, GSO, GRO), and MTU sizing.
- **Inter-Kernel Communication Patterns:** Shared memory mechanisms (IVSHMEM), virtio-vsock for low-latency host-guest IPC, and high-speed network queues.
- **Complete Networking Configuration Example:** End-to-end topology connecting two bare-metal kernel instances with sub-microsecond internal latency and redundant external uplinks.

### Chapter 8: Resource Isolation Strategies
- **CPU Isolation: isolcpus, nohz_full, rcu_nocbs:** Removing cores from CFS scheduler balancing, tickless single-task execution, and offloading RCU callbacks to housekeeping cores.
- **Cpusets and Cgroup-Based CPU Management:** Hierarchical cpuset controllers, strict partition enforcement, and dynamic rebalancing controls.
- **Memory Isolation and NUMA Policies:** `numactl`, `mbind()`, interleaved vs. node-local allocation, avoiding remote NUMA node memory access latency.
- **Interrupt Routing and IRQ Affinity:** Directing hardware IRQs away from dedicated isolated cores, configuring `smp_affinity`, and disabling `irqbalance` on real-time cores.
- **I/O Scheduling and Storage Contention:** BFQ vs. mq-deadline vs. none (passthrough) schedulers, storage bandwidth throttling, and writeback cache starvation prevention.
- **What Can and Cannot Be Safely Shared:** Last-level cache (LLC) contention, Intel CAT / AMD QoS cache allocation, memory bus bandwidth limits, and power management throttling.

### Chapter 9: Security Analysis and Threat Modeling
- **Attack Surfaces in Multi-Kernel Architectures:** Hypervisor interfaces, VFIO boundaries, shared CPU microarchitectural buffers, and firmware trust boundaries.
- **VM Escape Vulnerabilities and Recent CVEs:** Review of historic QEMU/KVM escapes, virtio driver bugs, and boundary exploitation vectors.
- **Secure Boot and Kernel Trust:** Chained UEFI Secure Boot, shim loader, signing custom guest kernels, and verifying integrity via TPM measurements.
- **DMA Protection and IOMMU Security:** Direct Memory Access attacks, preventing rogue DMA via hardware IOMMU translation units, and interrupt remapping security.
- **Secrets and Credential Isolation:** Isolating encryption keys, guest memory encryption (AMD SEV-SNP, Intel TDX), and hardware-backed attestation.
- **Comparing Multi-Kernel vs VM Security Posture:** Formal threat model comparison between containers, traditional VMs, and partitioned multi-kernel deployments.

### Chapter 10: Observability and Operations
- **Metrics and Monitoring Architecture:** Collecting hardware counters, host telemetry, guest telemetry, and unified dashboarding.
- **Logging Strategy Across Kernel Instances:** Centralized syslog/journald forwarding over isolated internal links, serial console multiplexing, and IPMI SoL logs.
- **Crash Diagnostics and kdump Integration:** Independent crash dumping per kernel instance, avoiding host lockups on guest kernel panics, and analyzing vmcore dumps.
- **Performance Profiling Methodology:** Hardware performance monitoring units (PMU), `perf kvm`, profiling vmexits, and tracing I/O latency distributions.
- **Health Checks and Alerting Design:** Watchdog hardware integration, heartbeat sockets, automated reboot triggers, and failover signaling.

### Chapter 11: Performance Engineering
- **Boot Time Analysis:** Measuring and optimizing firmware phase, bootloader handoff, kernel initialization, and userspace service startup.
- **CPU Overhead and Virtualization Tax:** Measuring cycle cost of vmexits, TLB flushes, CPU frequency scaling penalties, and instruction virtualization tax.
- **Cache Effects and NUMA Locality:** Quantifying L1/L2/L3 cache misses across co-located kernels, memory bandwidth saturation, and cache partitioning verification.
- **I/O Performance: Virtio vs Passthrough:** Empirical throughput and latency benchmarks: emulated devices vs. virtio vs. VFIO PCI passthrough vs. SR-IOV.
- **Benchmarking Methodology for Multi-Kernel Systems:** Designing reproducible synthetic and application-level workloads, eliminating test harness noise, and statistical validation.

### Chapter 12: Production Operations and Lifecycle Management
- **Kernel Upgrade Strategies:** Rolling restarts across partitioned instances, live kernel patching with kpatch/livepatch, and zero-downtime workload migration.
- **Configuration Management at Scale:** Declarative host and kernel provisioning, syncing systemd units and VFIO configurations via IaC.
- **Disaster Recovery Architecture:** Backup strategies for partitioned host configurations, guest state snapshots, and bare-metal recovery plans.
- **Maintenance Windows and Change Management:** Draining traffic, isolating nodes, updating host firmware/BIOS, and validating kernel security patches.
- **Decommissioning and Migration Procedures:** Reclaiming physical hardware, re-provisioning to standard OS roles, and wiping non-volatile memory safely.

### Chapter 13: Troubleshooting Guide
- **Boot Failures and Recovery:** Diagnosing early kernel boot hangs, command-line syntax errors, missing initramfs drivers, and serial console debugging.
- **Device Assignment and VFIO Issues:** Resolving bad IOMMU grouping, PCIe device reset failures (`FLR`), missing firmware blobs, and VF allocation errors.
- **Networking Problems:** Diagnosing asymmetric routing, MTU mismatches, dropped packet rings, and virtio driver stalls.
- **Performance Degradation Diagnosis:** Identifying noisy neighbours, unexpected vmexits, CPU throttling, and cache contention via eBPF and perf.
- **Kernel Panics and Crashes:** Tracing oops stack traces, out-of-memory (OOM) killer invocations across kernel boundaries, and hardware machine check exceptions (MCE).
- **Resource Exhaustion:** Tracking hugepage leaks, file descriptor starvation, and interrupt storm mitigation.

### Chapter 14: Architecture Comparisons and Decision Framework
- **Multi-Kernel vs Multiple Physical Servers:** Capital expenditure (CapEx), operational complexity (OpEx), power/cooling, and hardware utilization trade-offs.
- **KVM vs Xen vs ESXi for Multi-Kernel Workloads:** Comparing hypervisor architectures, overheads, ecosystem compatibility, and licensing.
- **Containers vs VMs vs Multi-Kernel: When to Use What:** Workload suitability matrix: latency sensitivity, isolation guarantees, dependency conflicts, and scaling speed.
- **MicroVMs and Unikernels as Alternatives:** Evaluating unikernels (OSv, MirageOS) and microVMs for extreme density and rapid startup.
- **Hardware Partitioning Approaches:** Comparing software-driven virtualization with proprietary hardware partitioning (HP nPars, IBM PowerVM).
- **A Decision Matrix for Architecture Selection:** Step-by-step evaluation framework to choose the optimal architecture for specific enterprise workloads.

### Chapter 15: Complete Project Plan: From Requirements to Decommissioning
- **Phase 1: Requirements Gathering and Hardware Assessment:** CPU feature auditing, NUMA mapping, PCIe slot topology discovery, and storage IOPS profiling.
- **Phase 2: Architecture Selection and Lab Validation:** Proving the selected approach in a staging lab, validating hardware isolation boundaries, and security review.
- **Phase 3: Kernel Preparation and Configuration:** Compiling custom production kernels, tuning boot command lines, building minimal initramfs images, and configuring host isolation.
- **Phase 4: Deployment and Verification:** Automated provisioning, smoke testing, running stress benchmarks, and validating failover and monitoring alerts.
- **Phase 5: Operations, Maintenance, and Decommissioning:** Production handover, runbook creation, operator training, ongoing patch management, and lifecycle retirement.

### Conclusion
- **Summary of Multi-Kernel Architecture:** Core trade-offs between isolation, complexity, and performance.
- **The Future of Multikernel Systems:** CXL (Compute Express Link), heterogeneous compute kernels, hardware disaggregation, and evolving Linux kernel primitives.
- **Operational Synthesis:** Key principles for sustained production success on bare-metal systems.

---

## Lab Architecture: Two Independent Kernels on One Physical Host

```
┌─────────────────────────────────────────────────────────────────────────┐
│                     PHYSICAL BARE-METAL SERVER                          │
│                                                                         │
│   Socket 0 / NUMA Node 0                     Socket 1 / NUMA Node 1     │
│   ┌──────────────────────────────┐          ┌─────────────────────────┐ │
│   │ Cores 0-15 (Housekeeping)    │          │ Cores 16-31 (Isolated)  │ │
│   │ Memory: 64 GB Local          │          │ Memory: 64 GB Local     │ │
│   └──────────────┬───────────────┘          └────────────┬────────────┘ │
│                  │                                       │              │
│                  ▼                                       ▼              │
│   ┌──────────────────────────────┐          ┌─────────────────────────┐ │
│   │ Primary Host Kernel (v6.x)   │          │ Secondary Kernel (v6.x) │ │
│   │ - OS: Ubuntu 26.04 Server    │          │ - Dedicated RT / App OS │ │
│   │ - Role: Management & Infra   │          │ - Static Hugepages (1G) │ │
│   │ - Management NIC (PF)        │          │ - SR-IOV VF Assignment  │ │
│   │ - System NVMe 0              │          │ - Direct Passthrough    │ │
│   └──────────────┬───────────────┘          └────────────┬────────────┘ │
│                  │                                       │              │
│                  └──────────── Inter-Kernel Link ────────┘              │
│                                (ivshmem / vsock)                        │
└─────────────────────────────────────────────────────────────────────────┘
```
