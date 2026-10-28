# Boring Linux — Syllabus (v2, rewrite)

Status: **writing in progress**. Part 04 is written in full: five Machine and Kernel Model chapters, four Firmware and Bootloaders chapters, and two Init Handoff and Recovery chapters. The final section includes boot-transaction and timing diagrams, a three-unit systemd lab, stage-based diagnosis, an emergency-shell mount repair, and external-media/chroot initramfs recovery. Part 05 has twelve existing chapters. The next writing section is Part 06, Block Devices and Filesystems. Replaces the v1 16-module / 230-chapter plan (still in git history).

## Purpose

A single point of reference for Linux administration and operations, written so it can be used as a **memory palace**: every chapter has the same shape, so the reader always knows where a fact lives. Boring-Linux is a temporary fast-iteration workspace. When complete it is copied into `Linux` as parts `04`–`19` (existing Linux parts: `01-commands`, `02-editors`, `03-scripting`), so part numbers here are final.

- **Reference platform:** Ubuntu 26.04 LTS ("Resolute Raccoon"), Linux 7.0, systemd. Other distros appear only as a one-line "elsewhere" note where behaviour differs.
- **Depth:** commands and config, plus the kernel/userspace mechanism underneath ("Under the hood") wherever it explains behaviour.
- **Independence:** read standalone. No links to other books in the library; give the minimum host fact inline.
- **Written in full:** no stub chapters. Existing pages titled `Overview` remain authoring notes and are excluded from the generated book. Sections and parts appear in navigation only when they contain written chapters.

## Chapter template (every chapter, same order)

1. **Map** — one diagram (illustrated standard for topology; mono `diagram-concept-*` for models) and a one-paragraph mental model.
2. **Commands and config** — what you run and edit, with named worked examples (input / output / why).
3. **Under the hood** — the kernel or userspace mechanism behind it (syscalls, data structures, `/proc` and `/sys` views).
4. **Files and paths** — where state, config and logs live.
5. **Break/fix** — one realistic failure: symptom, diagnosis path, fix.
6. **Recall card** — 5–8 lines from which the chapter can be rebuilt.

Chapter files: `content/NN-part/NN-section/NN-chapter.qmd` (parts → sections → chapters, a three-level sidebar).

## Parts

Generated structure: each published part has sections (second menu level) and chapters inside sections. The local generator omits overview notes and groups containing no written chapters; the full future curriculum remains listed here.

### 04 — Foundations, Boot and Platform
Goal: The shared vocabulary of a Linux machine, then everything from power-on to the first userspace process.

**The Machine and Kernel Model**
- The machine model: CPU, memory, devices, NUMA
- Kernel and userspace: syscalls, processes, threads, signals
- Virtual memory and the page cache
- VFS, inodes, file descriptors
- Devices, udev, /proc, /sys, /dev

**Firmware and Bootloaders**
- UEFI firmware, GPT, the ESP
- Bootloaders: GRUB and systemd-boot
- Kernel image, initramfs, early userspace
- Unified Kernel Images, Secure Boot, TPM measured boot

**Init Handoff and Recovery**
- Handoff to systemd: targets, systemd-analyze
- Boot recovery: rescue, emergency, chroot repair


### 05 — System Administration
Goal: Run a single Ubuntu host: people, packages, services, scheduling, memory, time and updates.

**Identity and Access**
- Users, groups, nss, home directories
- Authentication: PAM, sudo, run0

**Packages and Updates**
- Packages: dpkg, apt, repositories, pinning, snaps
- Unattended upgrades, kernel updates, livepatch

**Services and Scheduling**
- systemd units, dependencies, drop-ins
- Timers, cron, at
- journald and log management, logrotate

**Resources and Kernel Tuning**
- Processes, scheduling (EEVDF), priorities, nice and ionice
- Memory: swap, zram, OOM killer, overcommit
- Kernel modules, sysctl, kernel command line
- Time: chrony, NTP, timezones
- Locale, hostnames, hostnamectl, system identity


### 06 — Storage Administration
Goal: From raw block devices to filesystems, volumes, encryption, network storage and backups.

**Block Devices and Filesystems**
- Block layer: devices, schedulers, blk-mq
- Partitioning and filesystem creation
- ext4 and XFS: layout, tuning, repair
- Btrfs: subvolumes, snapshots, send/receive
- ZFS on Ubuntu

**Volumes and Encryption**
- LVM: PV/VG/LV, snapshots, thin pools
- Software RAID with mdadm
- Encryption: LUKS2, TPM2 unlock
- Mounting: fstab, systemd mount units, automount

**Network Storage and Protection**
- Network storage: NFS, SMB, iSCSI, NVMe-oF
- Quotas, fstrim, SMART and health
- Backup and restore: rsync, restic, borg, snapshots


### 07 — Network Administration
Goal: Configure, secure and diagnose Linux networking from interface to VPN.

**Stack and Addressing**
- The stack: interfaces, sockets, sk_buff, the packet path
- Addressing and ip: links, addresses, routes, neighbours
- Netplan, systemd-networkd, NetworkManager

**Routing and Switching**
- Routing: tables, policy routing, forwarding
- Bridges, VLANs, bonding, teaming
- Network namespaces and virtual devices (veth, macvlan)

**Name Services, Firewall and Tunnels**
- DNS: systemd-resolved, unbound, bind
- DHCP and IPv6 RA
- nftables: tables, chains, sets, NAT
- VPN: WireGuard, IPsec

**Performance and Diagnosis**
- Traffic control: tc, qdiscs, BBR
- Diagnosing the network: ss, tcpdump, mtr, ethtool


### 08 — Security Administration
Goal: Harden and audit a Linux host, and manage the keys, certificates and secrets it depends on.

**Host Access Control**
- Threat model for a single host; defaults on Ubuntu
- DAC, ACLs, capabilities
- AppArmor profiles
- seccomp and syscall filtering

**Remote Access and Cryptography**
- SSH: keys, certificates, hardening, bastions
- PKI and TLS: openssl, ACME, internal CA
- Secrets management on hosts

**Hardening and Assurance**
- auditd and auditing
- Kernel hardening: lockdown, sysctl, module signing
- Hardening baselines: CIS and USG
- Vulnerability management and patch SLAs
- Intrusion and integrity: AIDE, fail2ban, forensics basics


### 09 — Virtualization Administration
Goal: Run virtual machines on Linux with KVM, QEMU and libvirt, and tune them.

**KVM, QEMU and libvirt**
- How hardware virtualization works: VT-x/AMD-V, EPT, the KVM ioctl interface
- QEMU and libvirt: domains, XML, virsh
- virtio devices and performance tuning

**Guest Storage, Network and Images**
- Storage for guests: qcow2, LVM, ZFS zvols
- Networking for guests: bridges, macvtap, SR-IOV
- cloud-init and image building

**Advanced Topics**
- Passthrough: VFIO, IOMMU, GPUs
- Live migration and snapshots
- Incus: system containers and VMs
- Confidential computing overview (SEV-SNP, TDX)


### 10 — Container Administration
Goal: Understand containers as kernel features, run them with Podman and containerd, and operate a Kubernetes node.

**Kernel Primitives**
- Containers are processes: namespaces, the seven types
- cgroups v2: controllers, delegation, pressure stall info

**Images, Runtimes and Tools**
- OCI: images, layers, overlayfs, registries
- Runtimes: runc, crun, containerd
- Podman, rootless containers, Quadlet
- systemd-nspawn and portable services

**Networking and Security**
- Container networking: CNI basics, port publishing
- Container security: user namespaces, seccomp, AppArmor, rootless

**Kubernetes from the Node**
- Kubernetes from the node: kubelet, CRI, pods as cgroups
- Cluster bring-up with kubeadm and k3s
- Cluster networking: kube-proxy, Cilium, eBPF dataplane


### 11 — Service Administration
Goal: Operate the common server software that runs on Linux hosts.

**Web and Proxy**
- Web serving: nginx internals, TLS termination, tuning
- Reverse proxy and load balancing: HAProxy

**Data Services**
- PostgreSQL operations: install, config, backup, replication
- MySQL/MariaDB operations
- Caching: Redis, Memcached

**Availability and Infrastructure Services**
- High availability: keepalived, VRRP, fencing
- DNS and mail servers (operational essentials)
- File services and object storage (MinIO, Ceph at node level)
- Capacity planning for services


### 12 — Observability
Goal: Understand a running system from the outside in, down to the kernel.

**Signals and Host Tools**
- Signals: metrics, logs, traces, profiles; the USE and RED methods
- /proc, /sys and what the kernel exposes
- Host tools: sar, vmstat, iostat, pidstat, perf

**Kernel Tracing and Profiling**
- Tracing: ftrace, trace-cmd, tracepoints, kprobes
- eBPF: bpftrace, BCC, CO-RE, the verifier and safety model
- Flame graphs and continuous profiling

**Telemetry Pipelines**
- OpenTelemetry: instrumentation, collector, context propagation
- Distributed tracing in practice
- Logging pipelines: journald to Loki / OTel logs
- Cardinality, cost and retention


### 13 — Monitoring and Alerting
Goal: Know when something is wrong, before users do.

**Metrics with Prometheus**
- Monitoring vs observability: what to watch and why
- Prometheus: data model, scraping, exporters
- PromQL by example
- Node, process and service exporters; textfile collector

**Dashboards and Alerts**
- Grafana dashboards: design for readability
- Alertmanager: routing, grouping, silencing, inhibition
- Alert design: symptoms vs causes, paging policy

**Coverage and Resilience**
- Synthetic checks and blackbox probes
- Log-based and event-based alerts
- Monitoring the monitors: HA, federation, long-term storage


### 14 — DevOps
Goal: The delivery pipeline and the host requirements behind it.

**Automation and Builds**
- DevOps on Linux: the delivery pipeline end to end
- Shell at scale and idempotency
- Build systems and reproducible builds

**CI and Artifacts**
- CI runners: ephemeral, cached, isolated
- Artifact repositories, SBOMs and signing
- Secrets in pipelines

**Delivery and Measurement**
- CD strategies: rolling, blue/green, canary on hosts
- Testing infrastructure and pipelines: VM-based tests, linting
- Pipeline observability and DORA metrics


### 15 — Infrastructure as Code
Goal: Declare machines and networks, then keep reality equal to the declaration.

**Principles and Configuration Management**
- IaC principles: declarative vs imperative, state, drift
- Configuration management: Ansible fundamentals
- Ansible roles, inventories, and testing (molecule)

**Provisioning**
- Provisioning with OpenTofu / Terraform: providers, state, modules
- Remote state, locking and workspaces

**Images and First Boot**
- Image building: Packer, mkosi, cloud images
- Immutable and image-based systems: bootc, ostree concepts
- cloud-init and first-boot configuration
- Nix as an IaC tool

**Quality**
- Testing and policy for IaC


### 16 — GitOps
Goal: Git as the control plane for desired state.

**Principles and Repositories**
- GitOps principles: pull vs push, reconciliation, drift
- Git as source of truth (host facts only: branches, tags, hooks)
- Repository layouts for environments and fleets

**Controllers and Secrets**
- Argo CD: applications, sync, health
- Flux: sources, kustomizations, Helm
- Secrets in GitOps: SOPS, sealed secrets, external secrets

**Delivery, Policy and Scale**
- Progressive delivery: Argo Rollouts
- Policy as code: admission control, OPA, Kyverno
- Multi-cluster and fleet GitOps
- Operating GitOps: failure modes and recovery


### 17 — Platform Engineering
Goal: Build the internal platform other engineers consume.

**Platform as Product**
- What a platform is: users, product thinking, golden paths
- Developer portals and service catalogs
- Paved-road pipelines and defaults

**Platform Foundations**
- Cluster lifecycle: Cluster API, upgrades, node rotation
- Self-service provisioning and templates
- Multi-tenancy: namespaces, quotas, isolation
- Platform APIs: CRDs and controllers (operator pattern)

**Running the Platform**
- Cost and capacity visibility
- Platform reliability, support and versioning


### 18 — Site Reliability Engineering
Goal: Run services to a reliability target.

**Targets and Toil**
- SRE fundamentals: SLIs, SLOs, error budgets
- Toil and automation

**Incidents and Learning**
- Incident response: roles, comms, timelines
- Troubleshooting method: hypothesis-driven, with decision trees
- Runbooks: boot failure, OOM, disk full, network down, kernel panic, clock drift
- Postmortems and blameless reviews

**Resilience**
- Capacity planning and load testing
- Reliability patterns: timeouts, retries, backpressure, graceful degradation
- Disaster recovery: RPO/RTO, tested backups, game days
- Chaos engineering and failure injection
- On-call health


### 19 — Forward-Deployed Engineering
Goal: Deliver and operate systems inside a customer's environment.

**Role and Discovery**
- The FDE role: scope, expectations, ownership
- Discovery: inventory, constraints, stakeholders

**Working Under Constraint**
- Hostile environments: air-gapped, locked-down, legacy hosts
- Customer-site toolkit: portable diagnostics, offline packages
- Evidence collection and sanitized log bundles
- Deployment under constraints: change windows, rollback plans

**Integration and Communication**
- Integrating with the customer's identity, network and security policies
- Communication: status, escalation, handover docs
- Feeding field learnings back into the product


### 99 — Appendices
Goal: Quick reference material that spans every part.

**Reference**
- Command cheat sheets by role
- File and path atlas
- Ports and protocols
- Kernel parameters worth knowing
- Error codes and signals
- Glossary

**Palace Index**
- All recall cards on one page


## Counts

16 parts + appendices, 174 chapters. Target: each chapter 600–1,500 words plus figure(s).

## Open items

- Part 04 absorbs the old "Part 00" primer (decided by numbering).
- Pilot chapter first (proposed: 05 / 05 "systemd units, dependencies, drop-ins") to lock tone and depth before the rest.
- Git material in part 14 stays host-facts-only (book-independence rule).
