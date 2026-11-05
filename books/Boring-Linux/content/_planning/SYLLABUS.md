# Boring Linux — Progressive Systems Curriculum

Status: **accepted curriculum; structure reviewed 2026-11-03**. Parts 01–05 have complete chapter sequences; Part 06 has nine chapters. Parts 07–32 remain planned. Parts 33–38 already have separate chapter sequences and are optional depth tracks; their presence does not mean the intervening curriculum is written or that those tracks have passed technical review. See [INDEX.md](../../INDEX.md) for the writing queue. The previous plan remains under `archive/SYLLABUS-v2-before-restart.md`.

## Purpose and reader

A detailed, broad Linux systems book that takes a reader from their first administered machine to advanced systems engineering and production operations. The subject is Linux as an operating system and as a platform for services, storage, networks, security, virtual machines, containers and fleets.

The reader can open a terminal, edit a text file and run a simple command. Prior shell-programming knowledge is not required. Those abilities do not imply knowledge of boot, processes, storage, authentication or network services. Define those concepts from the beginning. Include any small command, path, shell or protocol explanation needed to complete the current task so the book is independently usable.

The core question for every subject is: **How does this Linux facility work, how do I configure and operate it, how do I prove that it works, and how do I diagnose and recover it when it fails?**

### Scope decisions

- **Progressive learning:** establish a working mental model, administer one host, add storage and services, connect systems, enforce security, run isolated workloads, then operate larger environments and investigate deeper mechanisms.
- **Operational completeness:** cover installation, configuration, daily operation, integration, security, updates, capacity, backup, diagnosis, recovery and retirement where each applies. Installing a package is only one step in operating a service.
- **Linux-centered networking:** interfaces, routes, resolvers, DNS/DHCP/NTP services, SSH, certificates, gateways, firewalls, VPNs, web proxies, file services and virtual networking. Introduce protocol theory as needed to configure or investigate these Linux systems.
- **Linux-centered security:** identity, permissions, authentication, policy enforcement, isolation, cryptographic material, patching, audit and response. Security is present throughout the practical work and receives deeper treatment after the underlying facilities are understood.
- **Wide coverage with explicit learning paths:** desktop/session infrastructure, hardware, accelerators, edge systems and constrained environments have a place as advanced branches. A reader can follow the main server path without completing every specialist branch first.
- **Reference environment:** use the existing Ubuntu 26.04 LTS reference for worked labs. Explain general Linux mechanisms separately from distribution packaging and policy. Add Debian-, RHEL-family and other distribution differences where they materially change an administrative decision. Specific package versions and defaults are verified during chapter authoring.
- **Depth without an arbitrary word limit:** split topics into teachable chapters rather than compressing whole disciplines into short pages. A filesystem family, network service or security subsystem can require several chapters.
- **Practical expert endpoint:** the reader can explain observed behavior, choose and verify a configuration, measure a bottleneck, plan a safe change and recover a failed system. Kernel programming and application programming appear in focused experiments where they illuminate operation; this is not a complete driver-development or application-development curriculum.

## Learning architecture

| Stage | Parts | Capability gained |
|---|---|---|
| A — Bring a machine to life | 01–03 | Install a lab host, understand its basic structure, follow boot and recover startup |
| B — Operate one host | 04–08 | Manage identity, software, services, resources, configuration and local evidence |
| C — Manage persistent data | 09–11 | Build storage layers, protect data and demonstrate a restore |
| D — Connect hosts and operate network services | 12–16 | Configure networking and run the access, infrastructure and sharing services hosts depend on |
| E — Enforce and verify security | 17–18 | Apply access policy, protect keys, harden systems and investigate security events |
| F — Run applications and isolated workloads | 19–22 | Operate data services, VMs, containers and clusters with understood dependencies |
| G — Operate and improve production systems | 23–28 | Observe, tune, automate, upgrade, scale and recover complete environments |
| H — Investigate deeply and integrate | 29–32 | Connect kernel mechanisms to evidence, choose a specialist branch and complete integrated projects |
| I — Optional depth tracks | 33–38 | Investigate a selected architecture, performance, security, filesystem, memory or Ubuntu-specific question |

These stages describe the main reading route. Troubleshooting, verification and security start in Stage A and recur throughout; the later dedicated parts develop the earlier habits into broader methods.

### Reading routes and scope

Part numbers are stable curriculum addresses, not a requirement to finish every branch. Parts 01–19 establish the host, data, network, security and application foundations. Parts 20–22 are workload branches; Parts 23–28 develop production operation. Parts 29–38 supply investigation, projects and optional depth. All routes stay inside this book.

| Goal | Selected progression | Completion evidence |
|---|---|---|
| Administer one recoverable host | 01–11, then the host-network and SSH/TLS essentials in 12–15, then 17–18 | A supervised service, bounded access, persistent configuration and an independent restore |
| Operate a small site and application | 01–19 → 23 → 25 → 24 → 26–28 | Rebuild, monitor, update and recover a networked application; select the relevant services in 16 and 19 |
| Operate VMs or containers | 01–19 → 20 and/or 21 → 23–28 | Preserve identity, data, network policy and recovery across workload replacement |
| Operate Kubernetes on Linux | 01–19 → 21 → 22 → 23–28 | Explain node behavior, replace a failed node and recover persistent/control-plane state |
| Investigate Linux mechanisms | Relevant foundations → 23–24 → 29–30 → selected 33–37 track | A reproducible investigation tied to a pinned kernel and measured evidence |
| Administer Ubuntu-specific systems | Relevant foundations → selected 31 branches and 38 chapters | A verified distribution-specific deployment or upgrade with a recovery path |

Part 32 projects are used at the milestones below, rather than saved for the end. A route omitting Kubernetes uses host-based delivery and recovery in 25–28; cluster controllers, Ceph and cluster-specific recovery remain optional branches.

**Bound the first implementation.** Teach one complete implementation before comparisons: ext4 before the alternative filesystems in 09; a local versioned backup before remote targets in 11; one resolver and one authoritative DNS implementation in 13; one file-sharing protocol in 16; AppArmor on the reference guest before a separate SELinux guest in 17; and one proxy plus PostgreSQL in 19. Alternatives retain operational depth when expanded, but are independently selectable. RAID, multipath, public mail delivery, distributed storage, cloud accounts and specialized devices are extensions with their own prerequisites.

### Prerequisites that must be supplied early

Later depth must never be required to finish an earlier lab. These are authoring requirements; review existing chapters against them before calling the foundations fully reviewed.

| Before the reader does this | Supply this minimum at the point of use | Deeper treatment |
|---|---|---|
| Creates service users or stores credentials | File/directory permission bits, traversal, ownership, `umask`, `chmod`, `chown` and a failed-access check in 04; build on the existing UID/GID chapter | ACLs, special bits, capabilities and policy composition in 17 |
| Installs software or starts a network listener | Existing console access, package origin, bind address, exposure check and the lab's connectivity assumptions in 02, 05 and 06 | Host networking in 12; full SSH/TLS operation in 14; packet policy in 15 |
| Changes boot, accounts, packages or storage | Identify the target, preserve required state, name the rollback boundary and rehearse recovery in the relevant lab | Independent backup design and restore in 11; full service recovery in 28 |
| Restarts or limits a service | Capture exit status, unit state, journal evidence, listening endpoint and a client-visible check in 06 | Local log policy in 08; cross-host telemetry in 23 |
| Builds a multi-host or cluster lab | Unique identities, addresses, name/time service, trust, baseline service checks and declared resources | 12–15; then the node-specific prerequisites in 20–22 |
| Tunes, automates or fails over a service | A repeatable baseline, health test, saved configuration and recovery criterion | Measurement in 24; repeatable builds in 25; failure domains in 27 |

Part 04 introduces central identity through local lookup and a dependency map only. A live directory-join lab belongs in 14, after DNS, time and certificate trust. First-VM construction uses the narrow hypervisor recipe in 01; managing a virtualization platform remains the job of 20.

### Milestones and project reuse

A milestone is an observable demonstration, not a quiz score or a promise that every chapter has been read. Keep an evidence bundle: starting state, configuration change, expected result, observed result, failure diagnosis and recovery result.

| Finish | Demonstrate | Part 32 project to attempt or extend |
|---|---|---|
| 03 | Install, inventory, follow boot and recover a broken lab boot | Begin project 1, recoverable single server |
| 08 | Run the recurring service under a dedicated identity, schedule work, bound resources and explain a failure from local evidence | Extend project 1 |
| 11 | Restore data and service configuration to a fresh guest from an independent copy; record elapsed time and data loss | Complete project 1 |
| 16 | Prove a client/server traffic matrix, name/time service, remote access and one controlled share | Project 2, small Linux site |
| 19 and 23 | Serve a TLS application with protected data; detect a failed dependency using an external probe and host evidence | Project 3, secure application; optional projects 4–6 after 20–22 |
| 25–26 | Rebuild from declared inputs and stop a failed rollout at a health gate | Project 7, reproducible fleet |
| 27–28 | Exercise failover and disaster recovery while checking authoritative data and measured recovery objectives | Projects 8 and 10 |
| 24, then selected 29–30 | Explain a measured regression and support the explanation with scoped profiling or tracing | Project 9, performance investigation |

## Chapter and lab design

Use a recognizable structure, scaled to the subject:

1. **Purpose and prerequisites:** the operational problem and what the reader already needs.
2. **System map and mechanism:** components, control/data paths, trust boundaries and relevant kernel/userspace behavior.
3. **Installation and inventory:** packages, running components, configuration ownership, existing state and defaults.
4. **Configuration and lifecycle:** a minimal working setup, realistic extensions, validation, startup, reload, restart and shutdown.
5. **Verification:** expected output, client-side tests and evidence that the intended storage, identity, endpoint or policy is actually in use.
6. **Diagnosis and recovery:** symptoms, hypotheses, evidence, corrective action, rollback and post-repair checks.
7. **Operational care:** access control, secrets, logging, monitoring, resource use, upgrades, backup and decommissioning as applicable.
8. **Practice and recall:** a reproducible lab, exercises with observable success criteria, and a compact recall card.

Do not force irrelevant headings into every page. Concept chapters can center on experiments; service chapters need a complete server/client workflow; incident chapters can follow an evidence-led investigation. Include diagrams where relationships or state transitions need to be seen. Follow the monorepo SVG standard.

### One lab that grows with the reader

- Begin with one disposable VM, a console and a known recovery path.
- Add spare virtual disks for storage work and an isolated network for multi-host exercises.
- Add a second Linux host for clients, name services, remote access and restore tests.
- Grow into an application host, infrastructure-services host, storage endpoint and observation host. Roles can share small VMs where that does not hide the behavior being taught.
- Use separate, clearly identified environments for hypervisor, clustering and destructive recovery exercises. Describe hardware and nested-virtualization requirements before those branches begin.
- Supply resource budgets, addressing plans, configuration files, expected results, cleanup and reset instructions. Separate minimum labs from resource-intensive extensions.
- Never expose an intentionally vulnerable service or turn a personal workstation into the destructive test target.

### Lab continuity and resource tiers

Use the existing names: `bl01` is the first observation guest; `bl02` is the installed baseline; `bl06-service-lab` is the service-work clone. `labapp` is the recurring supervised workload. Do not silently replace these with new names in later parts. Existing baseline clones retain copied identities and run alone; before simultaneous multi-host use, teach how to assign distinct hostname, machine identity, SSH host keys, addresses and any workload identity. Never attach the same writable disk to two independent guests.

| Tier | Intended work | Budget and limits to state in each lab |
|---|---|---|
| One active guest | 01–11 and host policy | Preserve the first lab's 2 vCPU, 4096 MiB and 32-GiB guest-disk teaching budget; reserve host resources and space for full recovery copies |
| Two to four active guests | Network services, application, monitoring and automation | Provide the sum of guest RAM, CPU assumptions, disk growth and the isolated traffic/address plan; rotate roles when the host cannot run them together |
| Dedicated extension | Nested hypervisor, multi-node cluster, distributed storage or hardware isolation | Publish a separate resource manifest and hardware checks; omit this branch without blocking the ordinary server route |

These are teaching tiers, not vendor minimums or promises of performance. Retain the first lab's roughly 100-GiB free-space allowance for the guest and full copies; later storage labs add explicitly sized disposable data disks. Add hardware-specific NUMA, SR-IOV and passthrough checks only to the branches that use them.

Carry `labapp` through durable storage in 09–11, client reachability in 12–15, access policy in 17–18, an application/database dependency in 19, optional containerization in 21, telemetry in 23 and reconstruction in 25. Each transition states what changed, what remains persistent and which client check proves continuity. Introduce the database with a supplied tiny application; application programming is not a prerequisite.

## Stage A — Bring a machine to life

### Part 01 — The Linux Machine and the Administration Lab

Outcome: identify the components of a Linux system and establish a lab that can be observed, changed and recovered.

1. What Linux consists of: kernel, userspace, distribution and installed system
2. Hardware, firmware, virtual hardware and the role of a hypervisor
3. CPU, memory, storage and network devices: the first working model
4. System paths, filesystems, configuration and persistent versus runtime state
5. Processes, services, sessions and the administrator's view of the machine
6. Distribution releases, support, repositories and documentation ownership
7. Building the first VM: console, disks, isolated networking and checkpoints
8. Inventory, change notes, evidence collection and a first troubleshooting method

Lab: build the initial VM and produce a system inventory with a tested console/recovery route. Distinguish a VM checkpoint from an independently recoverable backup.

### Part 02 — Installing and Provisioning Linux

Outcome: make and explain installation choices, verify the resulting system and reproduce it.

1. Selecting installation media and verifying authenticity and integrity
2. Installation planning: firmware mode, storage, identity and network assumptions
3. Guided installation and the resulting disk/filesystem layout
4. Manual installation choices: partitions, mounts, encryption and swap
5. First boot: administrator access, initial updates and service inventory
6. Hardware and virtual-device discovery: missing drivers and firmware
7. Image-based and unattended installation: concepts and an introductory workflow
8. Reinstallation, reprovisioning and recovering host-specific configuration

Lab: install two comparable hosts, document their differences and reproduce the essential configuration. Advanced provisioning implementations are developed in Part 25.

### Part 03 — Boot, Shutdown and Recovery

Outcome: trace startup from firmware to a usable system and repair a failure at the correct stage.

1. Firmware, UEFI variables, GPT and the EFI System Partition
2. Boot entry selection and bootloader configuration: GRUB and systemd-boot
3. Kernel images, command lines, modules and matching versioned artifacts
4. initramfs construction, early userspace and reaching the real root
5. Root handoff, PID 1 and systemd's boot transaction
6. Targets, activation, service readiness and boot timing
7. Shutdown, reboot, poweroff and services that prevent clean shutdown
8. Secure Boot, signed artifacts, UKIs and measured boot: the operational model
9. Rescue, emergency, early-shell and external-media recovery
10. Offline inspection, chroot repair and verifying the next normal boot

Lab: follow one successful boot with evidence, then recover a deliberately broken lab boot entry or noncritical required mount. Introduce basic service concepts here; authoring and managing units belongs to Part 06.

## Stage B — Operate one host

### Part 04 — Users, Identity and Administrative Access

Outcome: establish human and service identities with understandable authentication and privilege boundaries.

1. UIDs, GIDs, supplementary groups, ownership and basic file/directory access checks
2. Account databases, NSS and identity lookup
3. Account lifecycle: creation, expiration, locking, migration and removal
4. Home directories, skeleton configuration and session environments
5. Passwords, credential storage and authentication policy
6. PAM stacks, login flows and diagnosing authentication failures
7. Administrative privilege: sudo policies, root access and available alternatives
8. Service accounts, noninteractive identities and runtime credentials
9. Sessions, logind, polkit and authorization beyond the terminal
10. Central identity foundations: LDAP, Kerberos and SSSD roles, local lookup and network/time/trust dependencies; defer a live join to 14

Lab: create a small user/service-account model, delegate a bounded administrative task, and diagnose a failed login. Local accounts come first; directory integration is revisited after network services and certificates are understood.

### Part 05 — Packages, Software and Updates

Outcome: know where software came from, maintain its dependencies and recover an interrupted update.

1. Package metadata, file ownership and installed state
2. dpkg and apt: the package database and dependency resolution
3. Repositories, signatures, trust and source configuration
4. Version selection, holds, pinning and dependency conflicts
5. Configuration-file changes, alternatives and package lifecycle hooks
6. Security updates, unattended upgrades and maintenance windows
7. Kernel updates, reboot decisions, fallback entries and live patching concepts
8. Snaps, Flatpak and other delivery formats in their appropriate host roles
9. Source builds, local packages, dependency ownership and reproducibility
10. Offline repositories, mirrors, caching and disconnected installation
11. Interrupted transactions, damaged package state and rollback limits

Lab: inspect package provenance, operate a controlled update and recover an interrupted lab transaction. Distribution comparison covers equivalent package-lifecycle concepts without repeating a command encyclopedia.

### Part 06 — Services, systemd and Scheduled Work

Outcome: turn an application into a supervised service with explicit dependencies and predictable lifecycle behavior.

1. Service supervision, unit types and the system/user manager distinction
2. Service execution, environment, users, working directories and exit status
3. Startup types, readiness, watchdogs and restart policies
4. Requirements, ordering, activation and failure propagation
5. Vendor units, local units, drop-ins, generators and effective configuration
6. Socket, path and device activation
7. Timers, calendar schedules, cron, anacron and one-off work
8. Mount, automount and swap units: lifecycle and storage integration
9. Service cgroups, resource boundaries and a first sandbox
10. Reloads, restarts, configuration validation and graceful shutdown
11. User services, lingering and session-related behavior
12. Dependency cycles, restart storms, timeouts and service recovery

Lab: package a small service, add scheduled maintenance and demonstrate correct behavior when a prerequisite fails. The service remains the recurring example for storage, network, security and monitoring integration.

### Part 07 — Processes, Memory and Resource Administration

Outcome: explain a workload's resource behavior and control it without guessing at tuning knobs.

1. Process and thread lifecycle, states and parent/child relationships
2. Signals, process groups, sessions, zombies and reaping
3. CPU scheduling from the administrator's view: priorities and affinity
4. Memory accounting: virtual/resident/shared memory and working sets
5. Page cache, buffering, writeback and interpreting apparently free memory
6. Swap, zram, zswap and workload-specific tradeoffs
7. Allocation failure, overcommit, reclaim and OOM behavior
8. cgroups v2: hierarchy, controllers, delegation and accounting
9. CPU, memory, I/O and process limits through systemd
10. File descriptors, process limits and exhaustion patterns
11. PSI, contention and distinguishing pressure from utilization
12. NUMA, huge pages and latency-sensitive workloads: an operational introduction

Lab: place a service under controlled resource limits and explain its slowdown or failure from counters and logs. Detailed scheduler and memory implementation follows in Part 29.

### Part 08 — Configuration, Devices, Time and Local Logs

Outcome: distinguish persistent intent from runtime state and maintain the shared facilities of a host.

1. Configuration locations, precedence, includes and drop-in conventions
2. Hostname, machine identity, locale, encoding and environment
3. Wall clocks, monotonic clocks, RTC, timezones and synchronization status
4. Device nodes, sysfs, udev events, permissions and stable naming
5. Kernel modules, firmware loading, parameters and persistence
6. sysctl settings, kernel command-line settings and scope
7. journald: sources, fields, storage, retention and access
8. Traditional logs, syslog integration, rotation and retention
9. Temporary files, tmpfiles, runtime directories and cleanup policy
10. Configuration change records, validation, recovery copies and drift
11. Hardware power management, suspend, thermal state and watchdogs

Lab: follow a device event into persistent policy, reconstruct a service failure from local logs and verify which configuration source won. Network time servers are configured in Part 13.

## Stage C — Manage persistent data

### Part 09 — Disks, Partitions and Filesystems

Outcome: identify the correct device, build and mount a filesystem, then diagnose its capacity and integrity.

1. Storage inventory: disks, partitions, identifiers, topology and sector sizes
2. SATA/SAS/NVMe devices, queues and the block-device interface
3. GPT partitioning, alignment, labels and resizing boundaries
4. Filesystem objects, inodes, directories, links and file metadata
5. Creating filesystems and choosing features for a workload
6. Mounts, options, fstab, mount namespaces and automounting
7. ext4: layout, features, growth, checks and recovery
8. XFS: allocation, growth, quotas, inspection and recovery
9. Btrfs: subvolumes, snapshots, checksums, scrub and replication
10. OpenZFS: pools, datasets, properties, snapshots, scrub and operational care
11. Space, inodes, reserved capacity, sparse files and deleted-open files
12. Filesystem selection, compatibility and migration planning

Lab: manage several disposable data filesystems, grow one and investigate apparent disk-full conditions. Filesystem-specific repair procedures must distinguish mounted, offline, damaged and failing-media situations.

### Part 10 — Volumes, RAID, Encryption and Storage Health

Outcome: operate layered storage and locate a fault in the correct layer.

1. Mapping a complete storage stack from physical device to application path
2. Device mapper and LVM: physical volumes, groups and logical volumes
3. LVM growth, migration, snapshots, thin provisioning and pool exhaustion
4. Software RAID: layouts, mdadm metadata, degradation and rebuilds
5. Redundancy planning, fault domains, write caches and power-loss behavior
6. LUKS/dm-crypt: existing mappings, keys, slots, headers and recovery material
7. Encrypted boot, automatic unlock, TPM-backed policies and fallback access
8. Multipath devices, path failure and shared block-storage behavior
9. SMART/NVMe health, wear, errors, self-tests and alerting
10. Discard/TRIM, scheduling, queue settings and workload measurement
11. Replacing disks, expanding storage and retiring encrypted devices
12. Layered-storage failure exercises and recovery decision trees

Lab: grow a logical volume, recover a degraded disposable array and test encrypted-volume recovery. Encryption examples must make recovery keys and header backups verifiable before testing failure.

### Part 11 — Backup, Restore and Data Lifecycle

Outcome: demonstrate that data and service state can be restored within a defined recovery objective.

1. What must be protected: data, metadata, configuration, credentials and dependencies
2. Recovery point/time objectives, retention, capacity and backup independence
3. File copies, archive backups, deduplication and versioned repositories
4. Snapshots, application consistency and coordinated backup hooks
5. Local backup workflows with rsync, restic and Borg as concrete implementations
6. Remote targets, encryption, credentials and repository access policy
7. Restore workflows: files, complete hosts and service-specific state
8. Bare-metal recovery and reconstructing the boot/storage layout
9. Corruption, ransomware, deletion, repository failure and immutable/offline copies
10. Restore tests, integrity checks, monitoring, retention and expiration
11. Migration, archival, secure disposal and data ownership records

Lab: restore an independently stored backup into a fresh VM and verify ownership, permissions, contents and service behavior. Begin with local/isolated storage; add remote repositories after Stage D.

## Stage D — Connect hosts and operate network services

### Part 12 — Linux Host Networking

Outcome: configure a host's connectivity persistently and locate a failure along its actual path.

1. Network devices, link state, interface names and driver inventory
2. Ethernet, IP, prefixes and gateways through Linux-host examples
3. IPv4 configuration, ARP, duplicate addresses and neighbour state
4. IPv6 configuration, neighbour discovery, RA and address selection
5. Routing tables, route selection, source addresses and multiple interfaces
6. Netplan, systemd-networkd and NetworkManager: ownership and persistent configuration
7. DNS client configuration, resolver search policy and systemd-resolved
8. Listening sockets, bind addresses, ports and local-versus-remote reachability
9. Network startup, online policy and application reconnect behavior
10. Safe remote network changes, console recovery and persistence after reboot

Lab: connect two isolated hosts, publish a small service and diagnose address, route and resolver failures. Use only the protocol theory needed to explain each observation.

### Part 13 — DNS, Address Assignment and Time Services

Outcome: operate the infrastructure services that Linux hosts use to find names, obtain configuration and keep time.

1. A service dependency map: names, addresses, clocks and identity
2. DNS resolution and caching: clients, local stubs and recursive resolvers
3. Operating a recursive resolver: access policy, forwarding, caching and failures
4. Authoritative DNS: zones, records, serials, delegation and reverse lookup
5. DNS transfers, updates, split views and DNSSEC operations
6. DHCPv4: scopes, reservations, options, leases and server operation
7. DHCP relays, redundant service and address-conflict diagnosis
8. IPv6 RA and DHCPv6: operating the appropriate host-configuration model
9. Small-site combined services and separating responsibilities as a site grows
10. chrony/NTP client and server operation, source selection and clock faults
11. Logging, access restrictions, backup and recovery for infrastructure services

Lab: give clients working name resolution, address configuration and synchronized time. Verify service restrictions and recover from a deliberately incorrect zone, lease option or time source. Concrete implementations include BIND, Unbound, dnsmasq, Kea and chrony where appropriate to the chapter's job.

### Part 14 — Remote Access, Certificates and Trust Services

Outcome: establish authenticated administration and manage the trust material that network services require.

1. Operating OpenSSH: server configuration, host keys and client verification
2. User keys, SSH certificates, authorities and access lifecycle
3. Bastions, jump hosts, forwarding, tunnelling and file transfer
4. Restricting SSH accounts, subsystems, authentication and privilege
5. TLS operation: certificates, chains, names, trust stores and handshake diagnosis
6. Internal certificate authorities and issuing service certificates
7. ACME, renewal, deployment hooks and failed-renewal recovery
8. Certificate revocation, rotation, expiry monitoring and key replacement
9. Directory authentication in practice: LDAP/Kerberos/SSSD integration
10. Remote management continuity: out-of-band consoles and emergency access

Lab: operate certificate-backed access, issue a service certificate and rotate a key without losing the recovery route. This part supplies the trust concepts used by web, directory, storage and cluster services.

### Part 15 — Linux Gateways, Firewalls and Virtual Networks

Outcome: use Linux to connect, filter and tunnel traffic while maintaining a verifiable access policy.

1. Linux forwarding, local delivery and packet-filter hook locations
2. nftables tables, chains, rules, sets and counters
3. Stateful policy, connection tracking and diagnosing exhausted state
4. Host firewalls, persistent policy, logging and distribution frontends
5. NAT, port forwarding, masquerading and gateway service operation
6. Policy routing, multiple uplinks and asymmetric paths
7. Bridges, VLANs, bonds and loop prevention
8. Network namespaces, veth, macvlan/ipvlan and isolation experiments
9. WireGuard: peers, routes, key lifecycle and troubleshooting
10. IPsec and other tunnel deployments: policy and interoperability
11. Overlay networks, MTU, encapsulation and virtual-workload connectivity
12. Gateway capacity, traffic control, shaping and fair resource use

Lab: build an isolated router/firewall/VPN gateway with an explicit traffic matrix. Prove permitted and denied paths from clients, then recover from a bad rule without depending on the broken path.

### Part 16 — File, Storage and Messaging Services

Outcome: operate Linux services that share files, expose storage and deliver host-generated mail.

1. Service export boundaries, identity mapping and network-dependent storage
2. NFS clients and servers: exports, mounts, permissions and lifecycle
3. NFS identity/security options, stale handles, locking and diagnosis
4. Samba/SMB: standalone sharing, users, ACLs and client access
5. Samba directory integration and interoperability boundaries
6. iSCSI targets and initiators, sessions and safe block-device ownership
7. NVMe over Fabrics: subsystem, transport, discovery and host operation
8. WebDAV/SFTP and selecting a file-transfer service for a concrete need
9. Host mail delivery: local submission, queues and authenticated relays
10. Operating a mail service: SMTP, mailbox delivery, DNS, TLS and abuse controls
11. Service backup, client reconnection, monitoring and recovery drills

Lab: expose a controlled file share, mount it from another host, test identity/permission behavior and diagnose a service failure. Mail-server operation is a separate optional branch with explicit external DNS and deliverability requirements.

## Stage E — Enforce and verify security

### Part 17 — Linux Access Control and Isolation

Outcome: identify which enforcement layer allowed or denied an operation and implement an appropriate policy.

1. Threat modeling a Linux host: assets, exposure, trust and administrator access
2. Access-check composition, special bits and inheritance; build on the basic permissions and ownership taught in 04
3. POSIX ACLs, extended attributes and service data directories
4. Capabilities, privileged operations and replacing unnecessary root access
5. Linux Security Modules and stacking: locating the policy that applies
6. AppArmor: profiles, learning, enforcement, exceptions and diagnosis
7. SELinux: labels, domains, transitions, booleans and operational policy
8. seccomp: syscall restrictions, compatibility and failure investigation
9. Namespaces, user mappings, idmapped mounts and isolation limits
10. systemd service hardening: filesystem, device, privilege and network restrictions
11. Sandboxing tests, policy maintenance and upgrade-induced denials
12. Comparing access-control layers through the same failed operation

Lab: progressively restrict the recurring service and prove both its intended function and blocked operations. Use a suitable secondary VM for SELinux-specific exercises rather than pretending different distribution policies are interchangeable.

### Part 18 — Hardening, Secrets, Audit and Security Response

Outcome: maintain a defensible host configuration and respond to evidence of compromise without destroying the evidence needed for investigation.

1. Building a host baseline from its role and exposure
2. Authentication hardening, administrative separation and emergency access
3. Secrets on hosts: storage, delivery, access, rotation and accidental disclosure
4. Secure Boot, module signing, kernel lockdown and trust-policy operation
5. Kernel and network hardening settings: mechanisms, compatibility and verification
6. Patch exposure, vulnerability assessment, prioritization and maintenance records
7. Audit rules, event interpretation, audit pipeline capacity and retention
8. Integrity monitoring, unexpected persistence and suspicious process behavior
9. Security logging, detection rules, false positives and response ownership
10. Incident triage: volatile evidence, containment, credentials and trusted tooling
11. Rebuilding after compromise and validating the restored trust boundary
12. Disconnected hosts, compliance profiles, exceptions and evidence of control

Lab: audit a sensitive operation, identify a deliberate policy violation, rotate affected credentials and rebuild a disposable host from a trusted baseline. Recovery is demonstrated, not reduced to deleting a suspicious file.

## Stage F — Run applications and isolated workloads

### Part 19 — Web, Application and Data Services

Outcome: operate a complete Linux-hosted application and the server processes it depends on.

1. Service architecture: process, socket, proxy, state and dependency boundaries
2. nginx and Apache: serving content, configuration, permissions and logs
3. Reverse proxying, TLS termination, upstream discovery and request diagnosis
4. HAProxy and service load balancing: health checks, timeouts and connection behavior
5. Application deployment: users, directories, environment and supervised startup
6. PostgreSQL: installation, authentication, configuration, storage and daily operation
7. PostgreSQL protection: consistent backup, restore, replication and upgrade planning
8. MySQL/MariaDB: service configuration, access, backups, recovery and compatibility
9. Redis and Memcached: access boundaries, persistence choices and memory behavior
10. Message brokers and background work: delivery semantics translated into host operations
11. Object storage services: access, durable data, lifecycle and integration
12. Application upgrades, schema changes, rollback and dependency compatibility
13. Service health, capacity, query/request evidence and failure diagnosis

Lab: deploy a small application behind a TLS proxy with a database, bounded service identities, a backup and a tested restore. Give each substantial database/service family its own chapter sequence during expansion; one mixed chapter cannot provide complete operational coverage.

### Part 20 — Virtualization and Virtual Machine Operations

Outcome: build and operate a Linux virtualization host, then maintain guests as recoverable systems.

1. Hardware virtualization, guest/host boundaries and virtualization prerequisites
2. KVM, QEMU and libvirt: responsibilities, processes, devices and configuration
3. Host setup, permissions, management sockets and remote administration
4. Guest definition, installation, lifecycle, consoles and guest agents
5. Guest storage: raw, qcow2, volumes, backing chains and provisioning
6. Guest networking: NAT, bridges, routed networks and isolated segments
7. virtio, device models, CPU compatibility and memory allocation
8. Guest templates, cloud images, first boot and cloning identity safely
9. Snapshots, quiescing, backups and independent restore tests
10. Live migration: CPU, storage, network, trust and failure prerequisites
11. VFIO, IOMMU groups, SR-IOV and device/GPU passthrough
12. NUMA placement, pinning, huge pages, overcommit and measured tuning
13. Host upgrades, failed guests, migration failures and recovery
14. Incus VMs and other management layers: mapping features to the same primitives

Lab: operate two guests, configure their network/storage, restore one and perform a migration where the lab supports it. Mark nested-virtualization and passthrough exercises with their actual hardware requirements.

### Part 21 — Containers and System Containers

Outcome: understand a container's host resources and run containerized services with explicit data, identity and security policies.

1. Containers as Linux processes: shared kernel and isolation boundaries
2. Namespace types, process views, user namespaces and UID/GID mapping
3. cgroups v2, delegation, limits and pressure in container workloads
4. Root filesystems, overlayfs, image layers and copy-up behavior
5. OCI image/runtime specifications, registries, manifests and content identity
6. runc, crun, containerd and CRI-O: component responsibilities and inspection
7. Podman operation: images, containers, pods and rootless workflows
8. Docker Engine and Compose: daemon operation, service definitions and compatibility
9. Persistent volumes, bind mounts, ownership and data protection
10. Container networking: bridges, port publication, DNS and rootless paths
11. Capabilities, seccomp, LSM policy, secrets and supply-chain controls
12. systemd integration, Quadlet, restart behavior and host startup
13. Building and distributing images, provenance, signatures and updates
14. System containers with Incus/LXC and systemd-nspawn: lifecycle and host integration
15. Diagnosis, cleanup, storage exhaustion and upgrade/recovery procedures

Lab: migrate the recurring service into a rootless container while preserving data access, logging, startup, updates and restore behavior. Explain where a system container's administration differs from an application container.

### Part 22 — Kubernetes and Linux Cluster Workloads

Outcome: operate a small cluster while tracing pod behavior back to Linux processes, storage and networking.

1. Why orchestration changes operation: desired state, scheduling and failure handling
2. API server, controllers, scheduler, datastore and node responsibilities
3. Node prerequisites: runtime, cgroups, swap policy, networking, time and identity
4. Cluster installation, configuration ownership and a reproducible lab topology
5. Pods, controllers, configuration, secrets and service accounts
6. Requests, limits, scheduling, eviction and node pressure
7. CNI networking, pod connectivity, service traffic, DNS and network policy
8. CSI storage, persistent volumes, mount propagation and data protection
9. Workload access: ingress/gateways, certificates and external load balancing
10. RBAC, admission, workload isolation, security policy and image trust
11. Logs, metrics, events, node inspection and failed-workload diagnosis
12. Cluster upgrades, node replacement, drain, disruption and workload continuity
13. Datastore backup, certificate failure, control-plane recovery and restore tests
14. Packaging and declarative delivery: Helm, Kustomize and controller workflows

Lab: run the application with persistent state, prove restricted connectivity, replace a node and test a recoverable failure. Control-plane, networking and storage explanations remain grounded in their Linux components.

## Stage G — Operate and improve production systems

### Part 23 — Troubleshooting and Observability

Outcome: move from a reported symptom to a supported explanation using appropriately scoped evidence.

1. Troubleshooting method: scope, impact, timeline, hypotheses and falsifiable tests
2. Establishing baselines, sampling rates, intervals and counter interpretation
3. Metrics, logs, traces and profiles: what each can and cannot establish
4. Host evidence: /proc, /sys, journals, service state and hardware events
5. CPU, memory, storage and network observation with host tools
6. Application evidence: requests, queues, dependencies and saturation
7. Central log collection, transport, retention, access and missing logs
8. Prometheus exporters, scraping, metric types, labels and PromQL
9. Dashboards, service views and correlation across hosts
10. Alerting rules, routing, grouping, silencing and actionable notifications
11. OpenTelemetry collection, trace context and dependency investigation
12. Synthetic checks, independent probes and monitoring the monitoring system
13. Cardinality, privacy, cost, retention and telemetry failure modes
14. Evidence bundles, sanitization and communicating an investigation

Lab: instrument the application and diagnose several injected failures using independent signals. Record why a hypothesis was accepted or rejected, rather than selecting a familiar tuning command first.

### Part 24 — Performance and Capacity Engineering

Outcome: measure a workload, locate its limiting resource and verify a change against an explicit objective.

1. Workload models, throughput, latency distributions, concurrency and queues
2. Benchmark design, warm-up, cache state, variance and reproducibility
3. CPU saturation, scheduling delay, affinity and parallelism
4. Memory working sets, reclaim, swapping, allocation and NUMA effects
5. Filesystem/page-cache behavior, writeback and durability costs
6. Storage latency, I/O size, queue depth and competing workloads
7. Network paths, loss, retransmission, buffers, offloads and queueing
8. IRQ affinity, RSS/RPS/XPS and packet-processing placement
9. Service pools, file descriptors, connection limits and backpressure
10. Profiling, flame graphs and distinguishing CPU time from waiting
11. Resource isolation, noisy neighbours and container/VM overhead
12. Low-latency and real-time workloads: prerequisites and tradeoffs
13. Capacity forecasting, headroom, growth and cost-aware decisions
14. Performance regressions, controlled changes and rollback criteria

Lab: create and measure a bottleneck, change one relevant setting and demonstrate the result under the same workload. Detailed tracing techniques are introduced as needed here and developed further in Part 30.

### Part 25 — Provisioning and Configuration Automation

Outcome: build a host repeatedly from declared inputs and distinguish desired state from accidental configuration.

1. Inventory, desired state, idempotence, dependency order and drift
2. Automated installation, PXE/iPXE and infrastructure prerequisites
3. Cloud-init, image metadata, first-boot stages and failed provisioning
4. Configuration management with Ansible: connections, inventory, tasks and handlers
5. Roles, templates, variables, secrets and reusable host/service configuration
6. Testing automation in disposable VMs and validating changed services
7. Image construction with tools such as Packer and mkosi
8. Infrastructure provisioning with OpenTofu/Terraform: providers, plans and state
9. State locking, credentials, imports, drift and recovery
10. Immutable/image-based host models, transactional updates and rollback
11. Offline provisioning, artifact mirrors and reproducible inputs
12. Proving a rebuild from an empty host and documenting remaining manual steps

Lab: reconstruct the application environment from inventory and configuration without copying an unknown host state. Shell examples support the automation task; this part does not repeat a shell-programming course.

### Part 26 — Fleet Maintenance and Software Delivery

Outcome: change many Linux systems in controlled stages while retaining recovery and access.

1. Fleet inventory, roles, ownership, lifecycle and configuration sources
2. Repository/mirror services, package promotion and update rings
3. Remote execution, concurrency limits and partial-failure handling
4. Kernel, firmware and distribution upgrades across a fleet
5. Maintenance coordination, drain, reboot scheduling and health gates
6. Service delivery on hosts: rolling, blue/green and canary changes
7. Artifact repositories, build agents, credentials and runner isolation
8. Supply-chain evidence: SBOMs, signatures, provenance and deployment policy
9. Pull/reconciliation delivery and GitOps controllers in host/cluster contexts
10. Secrets and certificate rotation at scale
11. Fleet drift, compliance evidence and exception ownership
12. Failed rollout diagnosis, rollback and recovering unreachable nodes

Lab: roll a controlled service or package change through a small fleet, detect a bad instance and recover without repeating the failure everywhere. Teach only the repository concepts needed to operate the delivery workflow.

### Part 27 — High Availability and Shared Infrastructure

Outcome: build a redundant service and explain which failures it tolerates and which it does not.

1. Failure domains, dependencies, quorum and split-brain
2. Service discovery, health checking and distinguishing failure from slowness
3. Redundant proxies, virtual addresses and keepalived/VRRP operation
4. Cluster resource management, fencing and Pacemaker/Corosync workflows
5. Database replication, failover, recovery and consistency boundaries
6. Replicated block storage and the relationship between storage and service ownership
7. Distributed storage with Ceph: services, placement, clients and failure recovery
8. Object storage, gateways, access policy and data durability verification
9. Distributed filesystem clients, shared metadata and application constraints
10. Network partitions, degraded operation, capacity and rebuild load
11. Upgrades, maintenance and replacement in redundant systems
12. Testing failover, failback and recovery without losing authoritative data

Lab: demonstrate a defined service failure and recovery while checking data correctness. Resource-heavy distributed storage runs in a separately budgeted lab; diagrams identify quorum and failure domains before commands are introduced.

### Part 28 — Reliability, Incidents and Disaster Recovery

Outcome: turn individual repair skills into a repeatable operational practice for complete services.

1. Service objectives, user-visible indicators and error budgets
2. Operational ownership, runbooks, escalation and incident roles
3. Incident triage, communication, timestamps and preserving evidence
4. Boot failure, disk full, OOM, DNS, TLS, network and storage runbooks
5. Dependency failures, timeouts, retries, overload and graceful degradation
6. Backup architecture, recovery ordering and dependency reconstruction
7. Site loss, account/key loss and disaster-recovery planning
8. Recovery time measurement, restore verification and realistic game days
9. Fault injection, bounded experiments and abort conditions
10. Post-incident review, corrective work and preventing recurrence
11. Toil reduction, operational documentation and sustainable on-call practice
12. Service retirement, dependency removal and safe data disposal

Lab: recover the full application environment from a documented disaster scenario, measure the recovery and record missing dependencies. Compare the demonstrated recovery with the objectives set in Part 11.

## Stage H — Investigate deeply and integrate

### Part 29 — Advanced Linux Architecture and Kernel Internals

Outcome: explain important operational behavior in terms of kernel mechanisms and know where to inspect their implementation and interfaces.

1. CPU architecture, privilege, exceptions and the syscall boundary
2. Caches, memory ordering, NUMA, interconnects and hardware locality
3. Kernel source, configuration, build, modules and debug information
4. Tasks, process creation, exec, signals and lifecycle data structures
5. Scheduling classes, fairness, affinity, real-time operation and extensibility
6. Virtual address spaces, page tables, faults and copy-on-write
7. Physical allocation, slab allocation, reclaim, compaction and huge pages
8. VFS objects, pathname lookup, file descriptors and mount semantics
9. Page cache, writeback, durability and asynchronous I/O
10. Block-layer requests, multiqueue operation and device interactions
11. Interrupts, softirqs, workqueues and deferred work
12. Networking internals: sockets, packet buffers, routing and receive/transmit paths
13. Synchronization, locking, RCU and the symptoms of contention
14. Namespaces, cgroup controllers and security enforcement hooks
15. PCIe, DMA, IOMMU, driver binding and device lifecycle
16. Kernel ABI, sysfs/procfs interfaces and compatibility across updates

Lab: correlate selected source-level mechanisms with observable behavior on the lab host. Kernel-version-specific details are verified against the source and documentation used by that chapter. Introduce small programs only when an experiment benefits from an explicit syscall or allocation pattern.

### Part 30 — Tracing, eBPF and Failure Analysis

Outcome: gather deeper evidence when ordinary counters and logs cannot explain a fault.

1. Trace design: question, scope, overhead, permissions and data handling
2. strace and userspace debugging: syscall failures, hangs and process state
3. perf events, sampling, call stacks, symbols and unwinding
4. ftrace, trace-cmd, tracepoints and kernel event correlation
5. Dynamic probing, kprobes/uprobes and probe compatibility
6. eBPF programs, maps, attachment points, BTF and CO-RE
7. bpftrace/BCC investigations and interpreting their measurement boundaries
8. eBPF networking: tc/XDP and where packet policy executes
9. Continuous profiling, off-CPU time and latency investigations
10. Userspace core dumps, debug symbols and reproducible crash analysis
11. Kernel oops/panic evidence, kdump, vmcore and offline investigation
12. Hung tasks, lock contention, deadlocks and storage/network stalls
13. Tracing failures, verifier/permission constraints and measurement-induced distortion

Lab: investigate a crash and a latency fault using collected evidence. Demonstrate that the tracing method measures the suspected event and quantify or bound its overhead.

### Part 31 — Specialist Linux Systems

Outcome: transfer the core administration method to systems with different hardware, interaction models and deployment constraints.

This part contains branches. Each begins with prerequisites and a small working deployment; advanced implementation details belong in follow-on chapters within that branch.

1. Desktop system administration: display managers, sessions, Wayland/X11 and access
2. Audio, video, input and seat management: services, devices and diagnosis
3. Printing and discovery services: CUPS, queues, access policy and failures
4. Laptops and mobile hosts: power, suspend/resume, Wi-Fi, Bluetooth and recovery
5. GPU/accelerator hosts: drivers, device access, runtime stacks and workload isolation
6. High-throughput hosts: RDMA, specialized NICs, storage fabrics and observability
7. ARM and other architectures: installation, firmware, device descriptions and compatibility
8. Edge/embedded-style deployment: read-only roots, watchdogs, updates and interrupted power
9. Real-time systems: latency budgets, kernel choices, CPU isolation and measurement
10. Cloud Linux: image lifecycle, instance identity, metadata, disks and network interfaces
11. Constrained/disconnected sites: offline artifacts, local trust and remote-support evidence
12. Legacy interoperability and migrations between distributions or host models

Labs: choose branches appropriate to available hardware. Publish the required devices, firmware access, test environment and observable acceptance criteria before each exercise. Specialized accelerators, cloud resources and physical devices are optional rather than hidden requirements for the main curriculum.

### Part 32 — Integrated Systems Engineering Projects

Outcome: demonstrate independent design, operation, diagnosis and recovery across several Linux domains.

1. A recoverable single server: boot, identity, service, storage and backup
2. A small Linux site: DNS, address assignment, time, remote access and file services
3. A secure application environment: proxy, certificates, database and restricted identities
4. A virtualization host: guests, virtual networks, storage, backup and host maintenance
5. A container host: rootless services, persistent state, image updates and observability
6. A small cluster: workload networking, storage, security, upgrades and node recovery
7. A reproducible fleet: provisioning, configuration, staged updates and drift correction
8. A redundant service: explicit failure domains, health policy, failover and data checks
9. A performance investigation: workload, evidence, bottleneck, change and comparison
10. A disaster-recovery exercise: independent backups, clean hosts, credentials and measured restoration

Every project includes a design diagram, assumptions, capacity/resource budget, configuration sources, acceptance tests, monitoring, failure exercises, rollback, backup/restore and an operator handover. Give a minimum implementation and advanced extensions; do not make every project depend on completing every specialist branch.

## Stage I — Optional depth tracks

Parts 33–38 are independent selections after their prerequisites. They do not restart the introductory course. Existing chapter sequences remain in place; their next revision should follow these scope contracts and consolidate repeated explanations into the owning chapters within this book.

| Track | Prerequisites | Distinct contribution | Required evidence |
|---|---|---|---|
| 33 — Multiple kernels | 03, 07, 15, 20; selected 29–30 for internals and crash work | Compare concurrent guest kernels, sequential kernel handoff and hardware partitioning | Ownership map, isolation limits, recovery and one controlled comparison |
| 34 — Performance depth | 07, 09–10, 12, 23–24; relevant 29–30 chapters | Reproducible subsystem experiments and benchmark case studies | Raw measurements, variation, environment manifest and a regression decision |
| 35 — Security depth | 04, 14–18; 20–22 only for the selected workload | Threat-led integrated cases and evidence of enforcement across layers | Working allowed path, denied path, audit evidence and trusted recovery |
| 36 — ext4 internals | 09–11 and VFS/block topics in 29 | Connect on-disk structures, allocation and journaling to observed behavior | An inspected disposable image, integrity checks and a recovery experiment |
| 37 — Memory internals | 07, memory topics in 29 and relevant 30 tools | Source-backed allocation, reclaim and fault investigations | A bounded reproducer, accounting evidence and a pinned source/configuration |
| 38 — Ubuntu integration | Relevant core chapters; 31 for desktop/cloud branches | Release-specific defaults, packaging, compatibility, upgrades and enterprise integration | An installed-system manifest and a verified deployment or migration |

Do not repeat a general boot, networking, security or performance tutorial in each track. State the prerequisite, recap only the mechanism needed for the current experiment, and link to its owning chapter when that chapter exists. Every experiment records distribution/image, architecture, kernel package/configuration, tool versions and source tag where relevant.

### Part 33 — Running Multiple Kernels on One Bare-Metal Server

Outcome: distinguish concurrent kernels in KVM guests from sequential `kexec` handoff and platform-specific hardware partitioning, then verify isolation, lifecycle and recovery for the selected model. KVM/VFIO is a virtualization deployment, not proof of independently partitioned bare-metal kernels. Detailed chapter briefs: [SYLLABUS-RUNNING-MULTIPLE-KERNELS-ON-ONE-BARE-METAL-SERVER.md](SYLLABUS-RUNNING-MULTIPLE-KERNELS-ON-ONE-BARE-METAL-SERVER.md).

- **Introduction: The Multikernel Problem**
- **Chapter 1: Linux Kernel Fundamentals**
- **Chapter 2: The Boot Process in Depth**
- **Chapter 3: Virtualization vs True Bare-Metal Multi-Kernel**
- **Chapter 4: kexec and Kernel-to-Kernel Transitions**
- **Chapter 5: Hardware-Assisted Multi-Kernel with KVM/QEMU**
- **Chapter 6: Device Assignment and I/O Isolation**
- **Chapter 7: Networking Between Kernel Instances**
- **Chapter 8: Resource Isolation Strategies**
- **Chapter 9: Security Analysis and Threat Modeling**
- **Chapter 10: Observability and Operations**
- **Chapter 11: Performance Engineering**
- **Chapter 12: Production Operations and Lifecycle Management**
- **Chapter 13: Troubleshooting Guide**
- **Chapter 14: Architecture Comparisons and Decision Framework**
- **Chapter 15: Complete Project Plan: From Requirements to Decommissioning**
- **Conclusion**

Lab: on a suitable lab host, run two KVM guests with distinct kernels, observe host/guest resource ownership and recover a failed guest without restarting its peer. Add CPU/NUMA placement, VFIO, SR-IOV and dedicated storage only when the hardware supports the extension. Compare the same workload and document shared dependencies; measure overhead rather than promising bare-metal equivalence. A hardware-partitioning extension must name and verify the actual platform and partition manager. `kexec`/kdump exercises are separate handoff/recovery experiments, not concurrent execution. See the [kernel kdump documentation](https://docs.kernel.org/admin-guide/kdump/kdump.html).

### Part 34 — Linux Performance Engineering & Server Benchmarking

Outcome: extend the operational method in 24 through subsystem experiments, reproducible server benchmarks and performance-regression case studies. Explain which additional question each experiment answers; reuse the tool introductions in 23 and 30. Detailed syllabus: [SYLLABUS-LINUX-PERFORMANCE-ENGINEERING-AND-SERVER-BENCHMARKING.md](SYLLABUS-LINUX-PERFORMANCE-ENGINEERING-AND-SERVER-BENCHMARKING.md).

- **Introduction: The Discipline of Performance Engineering**
- **Chapter 1: The Performance Engineering Methodology**
- **Chapter 2: Linux Kernel Architecture and Performance**
- **Chapter 3: CPU Architecture and Performance Counters**
- **Chapter 4: CPU Scheduling and Process Placement**
- **Chapter 5: Memory Management: Virtual Memory and Pages**
- **Chapter 6: NUMA Architecture and Memory Placement**
- **Chapter 7: The Page Cache and Memory-Mapped Files**
- **Chapter 8: I/O Subsystems: From Block Layer to Disk**
- **Chapter 9: Storage Technologies and Performance Characteristics**
- **Chapter 10: Filesystems and Mount Options**
- **Chapter 11: The Networking Stack and Performance**
- **Chapter 12: Network Performance Tuning in Practice**
- **Chapter 13: System Call Tracing and Process Analysis**
- **Chapter 14: eBPF and BPF-Based Observability**
- **Chapter 15: Performance Analysis Tools and Flame Graphs**
- **Chapter 16: System Monitoring and Observability**
- **Chapter 17: Benchmarking: Design and Execution**
- **Chapter 18: Benchmarking Tools and Suites**
- **Chapter 19: CPU and Memory Tuning for Production**
- **Chapter 20: I/O and Filesystem Tuning for Production**
- **Chapter 21: cgroups, systemd and Resource Management**
- **Chapter 22: Containers, Virtualization and Noisy Neighbors**
- **Chapter 23: Databases and High-Performance Applications**
- **Chapter 24: Distributed Systems and Cluster Performance**
- **Chapter 25: Production Case Studies**
- **Chapter 26: Capacity Planning and Performance Regression**
- **Chapter 27: Advanced Topics and Emerging Technologies**
- **Conclusion: Putting It All Together**

### Part 35 — A Practical Guide to Securing Linux from Kernel to Cloud

Outcome: evaluate an integrated Linux deployment against an explicit threat model, prove how its controls interact and recover trust after a bounded security incident. Use the identity, trust and enforcement mechanisms established in 04 and 14–18; cloud and cluster cases are optional. Compliance evidence describes the scope of a control rather than claiming that a checklist proves security.

- **Introduction: Why Linux Security Is Not a Given**
- **Chapter 1: The State of Linux Security**
- **Chapter 2: The Linux Security Model**
- **Chapter 3: Boot, Initialization, and Runtime Environment**
- **Chapter 4: Identity, Authentication, and Access Control**
- **Chapter 5: Filesystem Security and Data Protection**
- **Chapter 6: Network Security Hardening**
- **Chapter 7: Kernel Security Mechanisms**
- **Chapter 8: Mandatory Access Control: SELinux and AppArmor**
- **Chapter 9: Auditing, Logging, and Security Monitoring**
- **Chapter 10: Secure Service and Workload Configuration**
- **Chapter 11: Container and Virtualization Security**
- **Chapter 12: Common Attack Paths and Defensive Strategies**
- **Chapter 13: Enterprise Hardening at Scale**
- **Chapter 14: Compliance, Benchmarks, and Security Standards**
- **Chapter 15: Incident Response, Troubleshooting, and Continuous Improvement**
- **Conclusion: Continuous Security Improvement**

### Part 36 — The ext4 Filesystem: Architecture, Internals, and Implementation

Outcome: inspect ext4 on-disk structures, allocation, extents, directory indexing, JBD2 journaling, metadata integrity and VFS integration on a disposable filesystem image. Pin filesystem features, tool versions and kernel source; connect each mechanism to an observation or recovery decision. C/Rust parsing implementations are optional extensions with their own programming prerequisites.

- **Introduction**
- **Chapter 1: The Story of ext**
- **Chapter 2: On-Disk Layout Fundamentals**
- **Chapter 3: The Inode – Anatomy of a File**
- **Chapter 4: Directory Formats**
- **Chapter 5: Extents – Modern Block Mapping**
- **Chapter 6: Block Allocation Algorithms**
- **Chapter 7: Journaling with JBD2**
- **Chapter 8: Extended Attributes, ACLs and Quotas**
- **Chapter 9: Advanced Features**
- **Chapter 10: Feature Flags and Compatibility**
- **Chapter 11: VFS Integration and Kernel Implementation**
- **Chapter 12: Recovery, Corruption Detection and Repair**
- **Chapter 13: Performance, Scalability and Comparisons**
- **Chapter 14: Implementation Guide**

### Part 37 — A Complete Guide to Virtual Memory, Allocators, Paging, and Performance in the Modern Linux Kernel

Outcome: connect address translation, physical allocation, current slab allocation, user-space allocation, page cache, reclaim, NUMA and memory cgroups to source-backed experiments on a pinned kernel. Separate user-space allocators from kernel `vmalloc`; treat SLAB/SLOB as historical comparisons rather than current lab choices. Use the [kernel slab allocator guide](https://docs.kernel.org/admin-guide/mm/slab.html) and documentation matching the tested source. Architecture and emerging-memory branches state their hardware and kernel requirements.

- **Introduction**
- **Chapter 1: Foundations of Memory Abstraction**
- **Chapter 2: Hardware Foundations and Address Translation**
- **Chapter 3: Linux Address Spaces and the Virtual Memory Layout**
- **Chapter 4: Physical Memory Management and the Buddy Allocator**
- **Chapter 5: Kernel Object Allocation: SLUB, with Historical SLAB/SLOB Comparisons**
- **Chapter 6: User-Space Allocation and Kernel vmalloc: Separate Interfaces and Accounting**
- **Chapter 7: Demand Paging, Page Faults, and Copy-on-Write**
- **Chapter 8: The Page Cache: Folios, XArrays, Writeback and Filesystem Interfaces**
- **Chapter 9: Swapping, Reclaim, and Page Replacement Policies**
- **Chapter 10: Memory Compaction, Defragmentation, and Huge Pages**
- **Chapter 11: NUMA, Memory Policy, and Scalability**
- **Chapter 12: Memory Cgroups, Controllers, and Resource Limits**
- **Chapter 13: Out-of-Memory Handling, Panic, and Recovery**
- **Chapter 14: Synchronization, Concurrency, and Locking in Memory Management**
- **Chapter 15: Performance Optimization, Profiling, and Debugging**
- **Chapter 16: Security Implications, Exploits, and Mitigations**
- **Chapter 17: Architecture-Specific Implementations and Source Walkthroughs**
- **Chapter 18: Conclusion: Synthesis and Future Directions**

### Part 38 — Ubuntu 26.04 LTS: From Desktop to Enterprise Cloud

Outcome: apply the core curriculum to Ubuntu 26.04 LTS, verifying the installed release, package versions, defaults, support entitlements and upgrade constraints. Organize selectable workstation, server/cloud and enterprise-management cases around what is specific to Ubuntu. Use the [official release notes](https://documentation.ubuntu.com/release-notes/26.04/) as the release baseline; record installed versions instead of turning an unverified tool-version list or support end date into a syllabus promise. TPM-backed encryption, confidential computing, accelerators and managed enterprise identity each require a separate compatibility check.

Existing introductory chapter titles are retained as migration targets. On revision, installation and command chapters become Ubuntu-specific decision/compatibility notes building on 01–08; security, network, container and performance chapters become integration cases building on their core owners. Do not add a second command-line or language-programming course.

- **Introduction: Why Ubuntu 26.04 Matters**
- **Chapter 1: What Is Ubuntu 26.04 LTS?**
- **Chapter 2: System Requirements and Installation**
- **Chapter 3: First Boot and Desktop Experience**
- **Chapter 4: Command-Line Fundamentals**
- **Chapter 5: System Administration Essentials**
- **Chapter 6: Security Hardening**
- **Chapter 7: Networking and Services**
- **Chapter 8: Virtualization and Containers**
- **Chapter 9: Cloud Infrastructure**
- **Chapter 10: Development Workflow**
- **Chapter 11: Troubleshooting and Diagnostics**
- **Chapter 12: Performance Tuning and Optimization**
- **Chapter 13: Customization and Flavors**
- **Chapter 14: Enterprise Deployment and Management**
- **Conclusion: The Road Ahead**

## Appendices and reference material

Reference material supports the progressive chapters and is not required pre-reading.

- Configuration and state-path atlas: persistent, generated and volatile locations
- Linux subsystem maps: boot, process, storage, networking, identity and isolation
- Service catalog: role, dependencies, configuration, logs, ports and verification
- Distribution differences: package/service names, policy and configuration ownership
- Error and symptom atlas with evidence-led diagnostic entry points
- Units, sizes, time bases, rates, counters and common interpretation mistakes
- Certificate, key and credential lifecycle reference
- Storage identity and layering reference
- Lab addressing, host roles, resource budgets and reset procedures
- Recovery media, rescue toolkit and offline documentation
- Recall cards and glossary, linked back to their owning chapters

## Section structure for the next writing passes

Parts 01–06 retain their existing section directories. Finish Part 06 with section `04-lifecycle-and-recovery` for briefs 10–12. For Parts 07–30, use the groups below as the outline before writing individual chapters. Ranges refer to the numbered briefs in this syllabus, not global chapter numbers. Prefix each section `01-`, `02-`, etc. in the displayed order, and number files locally within that section. Split a large brief into multiple chapters without changing its part identity.

| Part | Ordered sections and brief ranges |
|---|---|
| 07 | Process lifecycle (1–3); Memory behavior (4–7); Resource boundaries (8–10); Pressure and placement (11–12) |
| 08 | Configuration and host identity (1–3); Devices and kernel settings (4–6); Local evidence and retention (7–8); Runtime care and change records (9–11) |
| 09 | Devices and partitions (1–3); Filesystem objects and mounts (4–6); Filesystem families (7–10, selectable chapters); Capacity and migration (11–12) |
| 10 | Layering and logical volumes (1–3); Redundancy and fault domains (4–5); Encryption and recovery material (6–7); Paths, health and maintenance (8–12) |
| 11 | Recovery objectives and copy design (1–4); Backup implementations and targets (5–6); Restore workflows (7–8); Integrity, retention and retirement (9–11) |
| 12 | Links and addressing (1–4); Routes and configuration ownership (5–7); Reachability and safe changes (8–10) |
| 13 | Dependencies and DNS (1–5); Address assignment (6–9); Time and operational recovery (10–11) |
| 14 | SSH access lifecycle (1–4); Certificates and trust (5–8); Directory integration and continuity (9–10) |
| 15 | Packet paths and filtering (1–4); Gateways and virtual links (5–8); Tunnels and traffic behavior (9–12) |
| 16 | File sharing and identities (1–5); Block storage and transfer (6–8); Mail delivery (9–10, optional); Service recovery (11) |
| 17 | Access decisions and capabilities (1–4); Mandatory access policy (5–7); Isolation and service sandboxing (8–10); Policy verification (11–12) |
| 18 | Baseline, credentials and boot trust (1–4); Exposure and evidence (5–9); Response and trusted rebuild (10–12) |
| 19 | Web and application lifecycle (1–5); Databases and state (6–9); Queues and object storage (10–11, selectable); Upgrades and diagnosis (12–13) |
| 20 | Host and guest lifecycle (1–4); Guest data and connectivity (5–8); Recovery and migration (9–10); Hardware and platform extensions (11–14) |
| 21 | Kernel primitives and runtime stack (1–6); Application container workflows (7–8); State, connectivity and confinement (9–11); Integration and system containers (12–15) |
| 22 | Architecture and bootstrap (1–4); Workloads, resources and connectivity (5–9); Policy and evidence (10–11); Delivery and cluster recovery (12–14) |
| 23 | Questions, baselines and host evidence (1–5); Service telemetry and collection (6–8); Correlation and actionable alerts (9–12); Telemetry limits and handover (13–14) |
| 24 | Workloads and experiment design (1–2); Resource bottlenecks (3–8); Application limits and profiling (9–11); Latency, capacity and regressions (12–14) |
| 25 | Inventory and bootstrap (1–3); Configuration and validation (4–6); Images and provisioning state (7–10); Disconnected builds and proof (11–12) |
| 26 | Inventory and update policy (1–4); Coordinated delivery (5–6); Artifacts and trust (7–10); Drift and failed rollout recovery (11–12) |
| 27 | Failure models and service failover (1–4); Data replication and shared storage (5–9, selectable); Degraded operation and recovery (10–12) |
| 28 | Objectives and incident practice (1–4); Dependencies and disaster recovery (5–8); Exercises, improvement and retirement (9–12) |
| 29 | Execution and kernel source (1–5); Memory, files and block I/O (6–10); Events, networking and synchronization (11–13); Boundaries, devices and interfaces (14–16) |
| 30 | Questions and basic tracing (1–4); Dynamic probes and eBPF (5–8); Profiles, crashes and stalls (9–12); Measurement limits (13) |

Part 31 uses one section per selected specialist branch. Part 32 uses one section per project, expanded only when there is written material. Parts 33–38 keep their existing chapter paths during technical revision; group them into sections only in a separate move that checks links and regenerates the sidebar. No empty directories or placeholder pages are needed for this plan.

## Topic ownership and prerequisite rules

Breadth must not turn into repeated introductions or mutually dependent chapters.

| Topic | Main explanation lives in | Later use |
|---|---|---|
| Minimal process/kernel/userspace model | 01 and 03 | Services, resources, security and containers |
| Boot and recovery environments | 03 | Storage, updates, encryption and incident exercises |
| Local identities, basic permissions, NSS and PAM | 04 | SSH, shares, directory integration and service identities |
| Service lifecycle and systemd | 06 | Every later server and host agent |
| Practical resource accounting/cgroups | 07 | Databases, VMs, containers and performance |
| Local logging and configuration ownership | 08 | Service diagnosis and centralized telemetry |
| Filesystem/storage primitives | 09–10 | Backups, network storage, guest disks and cluster volumes |
| Backup design and standalone restore | 11 | Per-service backups and full disaster recovery |
| Host addressing, routing and resolver behavior | 12 | Infrastructure services, gateways and virtual networking |
| DNS, DHCP and NTP servers | 13 | Directory, mail, fleet and cluster dependencies |
| SSH, PKI and certificate operation | 14 | TLS services, secrets rotation and cluster trust |
| Packet policy, gateways and network virtualization | 15 | Hypervisors, containers and cluster networking |
| Network file/block service operation | 16 | Application state, virtualization and shared infrastructure |
| Advanced access-control composition and isolation | 17, building on 04 | Per-workload hardening and security investigations |
| Application/database lifecycle | 19 | Containers, delivery, monitoring and availability |
| Container primitives and runtimes | 21 | Kubernetes node and workload operation |
| Whole-system observability | 23 | Performance, incidents and deeper tracing |
| Source-level kernel mechanisms | 29 | Expert analysis and the focused investigations in 30 |
| Multikernel architecture and bare-metal partitioning | 33 | Advanced bare-metal isolation, low-latency virtualization, and specialized workloads |

Early chapters supply the mechanism required to understand their current task. Later chapters explicitly deepen that model. For example, practical memory accounting appears before container limits; detailed page-reclaim implementation appears after the reader has workloads to investigate. A forward reference can identify advanced follow-up but must not be required to complete the present lab.

## Authoring and review policy

- This file is the canonical curriculum. Chapter briefs are planned coverage, not a claim that unwritten chapters exist.
- Keep the progressive sequence and each part's practical outcome visible when expanding sections into individual chapter files.
- The numbered entries are chapter briefs. Split a brief when its working configuration, mechanism and recovery need several substantial pages. There is no fixed total chapter count or chapter word cap.
- Do not pre-create empty reader-facing sections or placeholder chapters to make the proposed contents appear published.
- Use part → section → chapter for new core writing, following the section map above. Existing depth-track paths remain stable until a dedicated link-checked migration.
- Keep boot, storage, networking, identity, trust and service prerequisites explicit in every integrated lab.
- Verify tool versions, project status, defaults and distribution behavior against primary sources when writing implementation-specific chapters.
- All subjects require diagnosis and recovery; the dedicated troubleshooting parts teach broader methods rather than being the first place failures appear.
- Maintain the monorepo diagram standard, accessible descriptions and light/dark variants where required.
- After every content update batch, render with `indipub.sh Boring-Linux`, refresh this book's local published artifacts, and regenerate the local portal once, following `README.md`. Repository scripts own generated configuration; never hand-edit `_quarto.yml` or commit build artifacts.

### Established curriculum decisions

1. Audience spans beginner systems administration through expert Linux operation and investigation.
2. The main organization is progressive learning.
3. Commands, editors and shell programming are not repeated as standalone courses.
4. Systems, networking, security, storage, virtualization and containers all receive operational depth.
5. Networking includes Linux networking facilities and the complete operation of Linux network services.
6. Coverage begins at the machine/installation/boot boundary and extends through advanced and specialist systems.
7. Detailed mechanisms, examples, diagrams, labs, troubleshooting and recovery are required throughout.

### Writing progress and next chapters

Progress is maintained in [INDEX.md](../../INDEX.md), using actual chapter files as evidence. Parts 01–05 have complete sequences; Part 06 has briefs 1–9 written. The next writing pass covers briefs 10–12: reload/restart and graceful shutdown; user services and lingering; service failure diagnosis and recovery. Parts 33–38 have existing chapter sequences requiring the scope and technical review described above. Presence on disk and technical verification are separate statuses.

Before expanding Part 07, review the early prerequisite requirements, complete the Part 06 service lifecycle, and verify that its lab leaves a reusable `labapp` baseline. New core chapters should follow the stage milestones; additions to depth tracks should answer a distinct question rather than repeat the foundation sequence.
