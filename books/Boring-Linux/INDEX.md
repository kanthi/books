# Boring Linux: Master Reference Architecture
## Ubuntu 26.04 LTS ("Resolute Raccoon") & Linux Kernel 7.0

Fast-iteration development workspace for authoring the modern 16-Module Encyclopedia of Linux Systems Engineering, Kernel Internals, and Cloud-Native Infrastructure.

### Architecture Overview

| Part | Modules | Focus Areas |
|---|---|---|
| **Part I: Silicon & Kernel Internals** | 01–04 | Hardware/NUMA/CXL, EEVDF/sched_ext, Folios/MGLRU/io_uring, Namespaces/cgroups v2/eBPF |
| **Part II: Systems Engineering** | 05–07 | Rust/Go systems daemons, UKI/TPM2/run0/immutable OS, NVMe ZNS/LUKS2/ZFS/Ceph |
| **Part III: Networks, Security & AI** | 08–10 | BBRv3/EVPN/netkit, AppArmor 4/PQC-SSH/nftables, PREEMPT_RT/DPDK/RDMA/ROCm/vLLM |
| **Part IV: Virtualization & Platforms** | 11–13 | KVM/CoCo/Firecracker/MAAS, OCI runtimes/K8s/Cilium, Dagger/OpenTofu/bootc/Nix |
| **Part V: Observability & Production** | 14–16 | OTel/LGTM/continuous profiling, Argo CD/Flux/Crossplane, 5 Runbooks + 3 Blueprints |

### Chapter Inventory
- **Total Modules**: 16 modules
- **Total Sections**: 74 structured sections
- **Total Chapters**: 230 chapters (`.qmd`) with dedicated workbooks, build labs, and break/fix chaos scenarios.

Refer to [`content/_planning/SYLLABUS.md`](content/_planning/SYLLABUS.md) for the complete chapter breakdown.
