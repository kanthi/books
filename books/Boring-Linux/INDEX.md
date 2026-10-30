# Boring Linux — Authoring Roadmap

Canonical curriculum: [content/_planning/SYLLABUS.md](content/_planning/SYLLABUS.md).

The accepted syllabus defines a progressive Linux systems book: beginner administration through advanced operation and investigation. It covers mechanisms, installation, configuration, lifecycle, security, verification, troubleshooting and recovery across Linux domains.

The previous reader-facing chapter and overview tree was removed at the author's request. Only newly written material is present in the live content tree. The old syllabus is retained as historical planning under `content/_planning/archive/`; it is not the current writing plan.

## Current content

Part 01, The Linux Machine and the Administration Lab, is complete, with two sections: **System Foundations** and **Building and Observing the Lab**.

1. What Linux Consists Of
2. Hardware, Firmware and Virtual Machines
3. CPU, Memory, Storage and Network Resources
4. System Paths, Configuration and State
5. Processes, Services and Sessions
6. Distributions, Releases and Documentation
7. Building the First Virtual Machine
8. Inventory, Evidence and First Troubleshooting

Each chapter includes diagrams, worked examples, an observation/practice exercise, diagnosis and a recall card. Foundation examples can be studied before lab setup and repeated on the disposable VM afterward. The lab section supplies setup, isolated networking, a recovery rehearsal and a bounded troubleshooting exercise.

Part 02, Installing and Provisioning Linux, is complete. Its **Installation Foundations** section contains:

1. Installation Media, Authenticity and Integrity
2. Planning Firmware, Storage, Identity and Networking
3. Guided Installation and the Resulting Storage Layout
4. Manual Storage Choices, Encryption and Swap

A second section, **First Boot and Device Readiness**, contains:

5. First Boot: Administrative Access, Updates and Service Inventory
6. Hardware and Virtual-Device Discovery

A third section, **Provisioning and Recovery**, contains:

7. Image-Based and Unattended Installation
8. Reinstallation and Host Configuration Recovery

The labs install `bl02` alongside `bl01`, add a disposable `bl02-manual` storage comparison (with an optional `bl02-crypt` extension), establish a verified first-boot baseline on `bl02`, use a separate `bl02-auto` guest for the local-seed installation, and restore selected state to a fresh `bl02-recovery` guest.

Part 03, Boot, Shutdown and Recovery, begins with **Firmware and Boot Selection**:

1. Firmware, UEFI Variables, GPT and the EFI System Partition
2. Bootloader Selection: GRUB and systemd-boot

The **Kernel and Early Userspace** section contains:

3. Kernel Images, Command Lines and Matching Modules
4. Initramfs and Reaching the Real Root
5. Root Handoff, PID 1 and the Boot Transaction

**Startup and Shutdown** contains:

6. Targets, Activation, Readiness and Boot Timing
7. Shutdown, Reboot and Services That Delay Shutdown

**Boot Trust and Recovery** begins with:

8. Secure Boot, Unified Images and Measured Boot
9. Rescue, Emergency and External-Media Recovery
10. Offline Inspection, Chroot Repair and the Next Normal Boot

Part 03 is complete. Part 04, Users, Identity and Administrative Access, begins with **Local Identities and Account Lifecycle**:

1. UIDs, GIDs, Groups and Ownership
2. Account Databases, NSS and Identity Lookup
3. Account Creation, Locking, Expiration and Removal
4. Home Directories, Skeletons and Session Environments

**Authentication and Privilege** contains:

5. Passwords, Credential Storage and Policy
6. PAM Stacks and Diagnosing Login Failures
7. Administrative Privilege and Bounded Delegation

**Service Identities** begins with:

8. Service Accounts and Runtime Credentials

**Sessions and Central Identity** contains:

9. Sessions, logind and Authorization Beyond the Terminal
10. Central Identity: LDAP, Kerberos and SSSD Foundations

Part 04 is complete. Part 05, Packages, Software and Updates, begins with **Package State and Transactions**:

1. Package Metadata, File Ownership and Installed State
2. dpkg, APT and Dependency Resolution

**Sources, Selection and Configuration** contains:

3. Repositories, Signatures and Source Configuration
4. Version Selection, Holds, Pinning and Dependency Conflicts
5. Configuration Files, Alternatives and Package Hooks

6. Security Updates and Maintenance Windows
7. Kernel Updates, Reboots and Livepatch

8. Snaps, Flatpak and Other Software Formats
9. Source Builds, Local Packages and Reproducibility
10. Offline Repositories, Mirrors and Disconnected Installation

11. Interrupted Package Transactions and Recovery

Part 05 is complete. Part 06 begins with **Service Supervision and Execution**:

1. Service Supervision, Units and Managers
2. Execution Environment, Identity and Exit Status

**Readiness and Dependencies** contains:

3. Startup Types, Readiness, Watchdogs and Restarts
4. Requirements, Ordering and Failure Propagation

## Next writing pass

Continue Part 06 with vendor units, local units, drop-ins, generators and effective configuration.

Add coherent sections only when they have written chapters. Keep numeric prefixes for deterministic ordering. Do not add placeholder overview pages or empty planned parts.

## Authoring boundaries

- Keep the book independently usable; include the command details needed by the current task.
- Follow the monorepo illustrated-diagram standard.
- Content and source assets are the work of the authoring pass.
- After each content update batch, use `indipub.sh Boring-Linux` to render, refresh this book's local published artifacts, and regenerate the local portal once. Follow the commands in `README.md`; never hand-edit `_quarto.yml` or commit build artifacts.
- Part numbers now describe this accepted 01–34 learning sequence, including the specialized tracks [Running Multiple Kernels on One Bare-Metal Server](content/_planning/SYLLABUS-RUNNING-MULTIPLE-KERNELS-ON-ONE-BARE-METAL-SERVER.md) and [Linux Performance Engineering & Server Benchmarking](content/_planning/SYLLABUS-LINUX-PERFORMANCE-ENGINEERING-AND-SERVER-BENCHMARKING.md). A future integration with another book requires its own deliberate mapping; the old fixed 04–19 arrangement is retired.

## Full progression

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
