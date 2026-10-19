# Linux Engineering & Administration
## Master Index & Learning Roadmap

> **Reference platform:** Ubuntu 26.04 LTS ("Resolute Raccoon"). This index covers general Linux engineering plus Ubuntu-specific administration. Newer releases and non-Ubuntu distributions are compatibility targets—not assumed to have identical packages, defaults, paths, or commands.
>
> **Version policy:** Ubuntu 26.04 introduced Linux 7.0 on its generic kernel track, made `sudo-rs` the default sudo provider, and uses `rust-coreutils` as the default core-utilities provider. OpenSSH 10.2 includes hybrid post-quantum key-exchange support. Treat every package version, default, and configuration path below as something to verify against the installed point release and the official documentation before publishing a procedure.

---

## How to Use This Index

- The checkboxes are authoring / completion markers, not a claim that the topic is already documented.
- **Build knowledge in order:** foundations (01–04), core host administration (05–08), virtualization and containers (09–10), then automation and platform operations (11–12). Use appendices (13) as reference material.
- For every chapter, aim to include: purpose and mental model, prerequisites, safe inspection commands, a minimal working example, failure modes, recovery steps, security considerations, and source links.
- Keep portable Linux behavior separate from Ubuntu 26.04-specific behavior. Label distro-specific, desktop-only, cloud-provider-specific, optional, and experimental features explicitly.
- Run destructive exercises only in disposable VMs or lab hardware with snapshots/backups. Never test disk, boot, firewall, identity, encryption, or cluster recovery procedures on production systems.

---

## Quick Navigation

| Section | Focus | Path / status |
|---------|-------|---------------|
| [01. Introduction](./01-Introduction/README.md) | Linux concepts, architecture, terminal and learning workflow | Existing foundation |
| [02. Commands](./02-Commands/README.md) | Files, processes, networking, text processing and command reference | Existing foundation |
| [03. Editors](./03-Editors/README.md) | Vim/Neovim, tmux, terminal workflow and tooling | Existing foundation |
| [04. Scripting](./04-Scripting/README.md) | Shell fundamentals and automation | Existing foundation |
| 05. Systems Administration | Boot, identity, packages, systemd, logging and diagnostics | Planned |
| 06. Storage & Encryption | Block devices, filesystems, LVM/RAID, encryption and recovery | Planned |
| 07. Network Administration | TCP/IP, Netplan, DNS, edge services, VPNs and diagnostics | Planned |
| 08. Security & Hardening | Access control, SSH, firewalls, PKI, auditing and compliance | Planned |
| 09. Virtualization & Bare-Metal Cloud | KVM/libvirt, PCI passthrough, system containers and provisioning | Planned |
| 10. Containers & Kubernetes | Container internals, OCI, Podman/Docker and Kubernetes | Planned |
| 11. DevOps, IaC & Observability | Git, Ansible, OpenTofu, CI/CD, metrics, logs and traces | Planned |
| 12. GitOps & Cloud-Native Operations | Argo CD, Flux, secrets, progressive delivery and infra GitOps | Planned |
| 13. Appendices & Runbooks | Migration notes, incident runbooks and homelab blueprint | Planned |

---

## Existing Foundation Sections

- **[01. Introduction](./01-Introduction/README.md)**
- **[02. Commands](./02-Commands/README.md)** (files, processes, networking, text processing and command-by-command reference)
- **[03. Editors](./03-Editors/README.md)** (Vim/Neovim, tmux, terminal tools and editing workflows)
- **[04. Scripting](./04-Scripting/README.md)**
  - **[Bash](./04-Scripting/Bash/README.md)** (shell fundamentals, variables, control flow, functions, error handling and workbook)

---

## 05. Systems Administration (Ubuntu 26.04 LTS Reference)

### 5.1 Boot Architecture, UEFI & Firmware
- [ ] **UEFI, Secure Boot & Shim:** BootROM, EFI System Partition (`/boot/efi`), MOK (Machine Owner Keys), `mokutil`, `sbctl`, Custom Secure Boot signing
- [ ] **TPM 2.0 & Measured Boot:** Platform Configuration Registers (PCRs 0–15), `tpm2-tools`, `systemd-cryptenroll`, PCR policy binding & attestation
- [ ] **GRUB 2 and alternative boot managers:** `/etc/default/grub`, `/etc/grub.d/*`, `update-grub`, `grub-mkconfig`, boot entries, kernel command-line parameters and serial-console redirection; cover `systemd-boot` where actually deployed
- [ ] **Initramfs Internals & Recovery:** identify the active generator (`initramfs-tools` or Dracut), inspect images with `lsinitramfs` / `unmkinitramfs`, understand early-userspace hooks, and recover from an emergency shell
- [ ] **Modular Firmware & Microcode:** Ubuntu firmware package layout (confirm package names for the installed release), `intel-microcode`, `amd64-microcode`, `fwupd` & `fwupdmgr` LVFS updates

### 5.2 Automated Provisioning & Installation
- [ ] **Subiquity & Autoinstall:** Ubuntu Server installer architecture, `autoinstall.yaml` schema, `interactive-sections`, `late-commands`, storage layouts
- [ ] **Cloud-Init Deep Dive:** Datasources (`NoCloud`, `MAAS`, `AWS`, `Azure`), stages (`init-local`, `init`, `config`, `final`), `cloud-config` YAML modules, `cloud-init status/analyze`
- [ ] **PXE, HTTP Boot & Netboot:** UEFI HTTP Boot vs TFTP/iPXE, `dnsmasq` / ISC Kea boot options, serving Ubuntu 26.04 live-server ISOs over network

### 5.3 Identity, Privilege & Authentication
- [ ] **Local Identity Databases:** `/etc/passwd`, `/etc/shadow` (`yescrypt` hashing), `/etc/group`, `/etc/gshadow`, `/etc/login.defs`, `/etc/skel`, `useradd`/`usermod`/`chage`
- [ ] **sudo-rs and privilege policy:** Ubuntu 26.04 default-provider behavior, `/etc/sudoers`, `/etc/sudoers.d/*`, `visudo`, `sudoedit`, command aliases, compatibility checks, and migration from removed `sudo-ldap` integrations to supported PAM/LDAP approaches
- [ ] **Pluggable Auth Modules (PAM):** `/etc/pam.d/common-*`, `pam_unix`, `pam_faillock` (account lockout), `pam_limits` (`/etc/security/limits.d/`), `pam_env`, `pam_systemd`
- [ ] **Cloud identity with authd (where supported):** broker architecture, supported identity providers, OIDC/device authorization flows, MFA, NSS integration and provider-specific limitations
- [ ] **Enterprise Directory (SSSD):** FreeIPA & Active Directory integration, `realmd`, `sssd.conf`, Kerberos (`krb5.conf`, `kinit`, keytabs), offline credential caching

### 5.4 Package Management: APT, DEB & Snap
- [ ] **APT dependency resolution and diagnostics:** verify the installed APT version; cover dependency explanations where supported, `apt-patterns(7)`, `/etc/apt/apt.conf.d/*`, and pinning (`/etc/apt/preferences.d/`)
- [ ] **DEB822 Repository Architecture:** `/etc/apt/sources.list.d/ubuntu.sources`, Suites (`resolute`, `resolute-updates`, `resolute-security`), Components (`main`, `restricted`, `universe`, `multiverse`), `Signed-By` GPG keyrings (`/etc/apt/keyrings/`)
- [ ] **Low-Level dpkg & Deb Creation:** `/var/lib/dpkg/{status,info}`, `dpkg-query`, `dpkg-divert`, `dpkg-reconfigure`, building `.deb` packages (`debian/control`, `rules`, `debhelper`, `dpkg-buildpackage`)
- [ ] **Unattended upgrades & Ubuntu Pro:** `unattended-upgrades`, `needrestart`, the `pro` client, ESM, Ubuntu Security Guide (USG) and Livepatch; distinguish free defaults from subscription-enabled services
- [ ] **Snapd & XDG Portals:** SquashFS snap mounts (`/snap`), `snapd` assertions, interfaces/plugs/slots, strict vs classic confinement, XDG Desktop Portals, building snaps with `snapcraft.yaml`

### 5.5 systemd & Unified cgroup v2 Resource Control
- [ ] **Systemd Architecture & Units:** PID 1 lifecycle, unit load paths (`/usr/lib/systemd/system` vs `/etc/systemd/system`), unit types (`.service`, `.socket`, `.timer`, `.mount`, `.path`, `.target`, `.slice`)
- [ ] **Writing Hardened Service Units:** `[Unit]`, `[Service]`, `[Install]` directives, `Type=notify/exec/simple`, `DynamicUser=yes`, `ProtectSystem=strict`, `PrivateTmp=`, `SystemCallFilter=`, `CapabilityBoundingSet=`
- [ ] **Systemd Timers & Socket Activation:** Monotonic vs Realtime (`OnCalendar`) timers, `Persistent=true`, replacing `cron`/`anacron`, on-demand socket activation (`.socket` → `.service`)
- [ ] **cgroup v2 resource control:** inspect the active hierarchy and controllers under `/sys/fs/cgroup`; understand `system.slice` / `user.slice` / `machine.slice`, `CPUWeight`, `MemoryHigh`, `MemoryMax`, `IOWeight`, `systemd-cgtop` and transient `systemd-run` units

### 5.6 Time, Logging & Kernel Diagnostics
- [ ] **Chrony 4.8 and Network Time Security (NTS):** NTS configuration and verification, `/etc/chrony/chrony.conf`, release-provided source files, `chronyc tracking / sources / ntsdata`, and hardware timestamping (PTP); verify effective settings and network requirements
- [ ] **Systemd Journal & Rsyslog:** `systemd-journald`, `/etc/systemd/journald.conf`, `ForwardToSyslog`, structured `journalctl` queries (`-u`, `-b`, `-p`, `-o json`, `--grep`), `journalctl --verify`, `rsyslog` remote forwarding, `logrotate`
- [ ] **Kernel modules & tuning (kernel version varies by track and updates):** `lsmod`, `modinfo`, `modprobe` (`/etc/modprobe.d/`), `depmod`, DKMS, runtime kernel parameters (`/etc/sysctl.d/*.conf`), `sysctl --system`, `udev` rules (`/etc/udev/rules.d/`, `udevadm`)
- [ ] **GPU / AI accelerator stacks:** supported driver and accelerator installation paths, `ubuntu-drivers`, `nvidia-smi`, `rocm-smi`, hardware-specific NPU interfaces and the Resources desktop monitor; distinguish Ubuntu archive packages from vendor repositories
- [ ] **Crash Dumps & Profiling:** `kdump-tools`, `crashkernel` reservation, analyzing `vmcore` with `crash`, `Sysprof` system-wide CPU/callgraph profiling, `pstore`

### 5.7 Systems Administration Workbook
- [ ] **Lab 01: Boot & Initramfs Rescue:** Intentionally breaking GRUB/initramfs in a disposable VM, booting via UEFI Shell/Live ISO, chrooting with bind mounts, rebuilding dracut/initramfs
- [ ] **Lab 02: Identity & sudo-rs:** Setting up `authd` OIDC login alongside granular `sudo-rs` policies and PAM `faillock` rules
- [ ] **Lab 03: Cgroup v2 & Systemd:** Writing a sandboxed systemd service with strict syscall filtering and hard `MemoryMax`/`CPUQuota` cgroup v2 ceilings

---

## 06. Storage, Filesystems & Encryption

### 6.1 Block Layer, NVMe & Partitioning
- [ ] **Linux Block Subsystem:** `/sys/block/*`, I/O schedulers (`none`, `mq-deadline`, `bfq`, `kyber`), queue depth, `read_ahead_kb`, `lsblk`, `blkid`, `udev` persistent naming (`/dev/disk/by-id`, `by-uuid`, `by-path`)
- [ ] **Partitioning Schemes:** GPT (GUID Partition Table) header & backup structures, protective MBR, `parted`, `sgdisk` (scripted partitioning), `gdisk`, `partprobe`, `blockdev`
- [ ] **NVMe & SCSI Management:** `nvme-cli` (`nvme list`, `smart-log`, `id-ctrl`, `format`, `sanitize`, namespaces), SCSI generic (`sg3-utils`), `multipath-tools` (DM-Multipath for SANs)

### 6.2 Hardware-Backed Disk Encryption (FDE & LUKS2)
- [ ] **TPM-backed full-disk encryption:** Ubuntu Desktop 26.04 hardware-backed FDE, TPM/PCR trust measurements, PIN/passphrase options and recovery-key handling; the current Desktop documentation labels this feature Beta, so verify its status and hardware limitations before writing a procedure. Distinguish it from server LUKS/Clevis setups
- [ ] **LUKS2 & Cryptsetup Internals:** LUKS2 header JSON metadata, Argon2id PBKDF, keyslots (0–31), `cryptsetup luksFormat/luksOpen/luksDump/luksHeaderBackup`, `/etc/crypttab`
- [ ] **Automated Decryption:** `systemd-cryptenroll` with TPM2, FIDO2 hardware keys (YubiKey), and PKCS#11 tokens; Tang & Clevis network-bound disk encryption (NBDE)

### 6.3 Filesystems Deep Dive
- [ ] **Ext4 Internals & Tuning:** Superblocks, block groups, inode tables, extents, journaling modes (`data=ordered`, `journal`, `writeback`), `mkfs.ext4`, `tune2fs`, `e2fsck`, `debugfs`
- [ ] **XFS High-Performance FS:** Allocation groups, B+ trees, delayed allocation, `mkfs.xfs`, `xfs_info`, `xfs_growfs`, `xfs_repair`, `xfs_fsr`, `xfsdump`/`xfsrestore`, Reflink copies
- [ ] **Btrfs Copy-on-Write:** Subvolumes (`@`, `@home`), atomic snapshots, `send`/`receive` replication, compression (`zstd`), `scrub`, `balance`, `btrfs filesystem du`
- [ ] **OpenZFS on Ubuntu:** VDEVs (`mirror`, `raidz1/2/3`, `special`, `draid`), `zpool` creation/import/scrub, ZFS datasets, ZVOLs, ARC/L2ARC/SLOG tuning, native ZFS encryption, `zfs send/receive`, Sanoid/Syncoid

### 6.4 Logical Volume Management (LVM2) & Software RAID
- [ ] **LVM2 Architecture:** Physical Volumes (`pvcreate`, `pvs`), Volume Groups (`vgcreate`, `vgextend`), Logical Volumes (`lvcreate`, `lvextend`, `lvreduce`), PE/LE mapping
- [ ] **Advanced LVM:** LVM Thin Provisioning (thin pools, overprovisioning alerts), LVM Cache / Writecache (NVMe caching slow HDDs), LVM RAID, `pvmove` online disk migration
- [ ] **Software RAID (mdadm):** RAID levels (0, 1, 4, 5, 6, 10), superblock formats (1.2), `mdadm --create/--detail/--assemble`, `/proc/mdstat`, write-intent bitmaps, scrubbing, replacing faulted drives

### 6.5 Mounting, Automount & Swap Architecture
- [ ] **VFS Mounting & `/etc/fstab`:** Mount options (`noatime`, `nodiratime`, `nosuid`, `nodev`, `noexec`, `_netdev`, `x-systemd.automount`), `systemd-fstab-generator`, native `.mount` and `.automount` units
- [ ] **Swap, Zram & OOM Management:** Swapfiles on modern filesystems, `zram-config` (compressed RAM block devices), `zswap`, `vm.swappiness`, `vm.vfs_cache_pressure`, `vm.overcommit_memory`, `systemd-oomd` configuration

### 6.6 Networked, Clustered & Object Storage
- [ ] **NFSv4.2 Server & Client:** `nfs-kernel-server`, `/etc/exports`, pseudo-root filesystem, `idmapd`, Kerberos NFS (`sec=krb5p`), client mount tuning (`rsize`, `wsize`, `hard`, `nconnect`), `autofs`
- [ ] **SMB/CIFS & Samba:** Samba server (`/etc/samba/smb.conf`), `smbpasswd`, POSIX ACL mapping, multi-channel SMB3, `cifs-utils` client mounts with credential files
- [ ] **iSCSI Block SANs:** `targetcli-fb` (backstores, IQNs, TPGs, ACLs, portals), `open-iscsi` initiator (`iscsiadm` discovery, login, multipath integration)
- [ ] **Distributed Storage (MicroCeph):** Canonical MicroCeph architecture, MONs, MGRs, OSDs, RADOS, RBD (Ceph Block Devices), CephFS, RGW (S3-compatible object gateway)

### 6.7 Performance, Health, Backup & Recovery
- [ ] **Disk Diagnostics & Recovery:** `smartmontools` (`smartctl`, `smartd` alerts), `badblocks`, `ddrescue` for failing media, `testdisk`, `photorec`, `fstrim.timer` for SSDs
- [ ] **I/O Benchmarking with FIO:** Flexible I/O Tester (`fio`), testing random vs sequential IOPS, latency percentiles (p99, p99.9), `iostat -xz`, `iotop-c`, `blktrace`
- [ ] **OS tuning for databases:** PostgreSQL, MySQL and Valkey/Redis; evaluate Transparent Huge Pages (THP), explicit huge pages, dirty-page thresholds, `fs.aio-max-nr` and `io_uring` with workload-specific benchmarks and current upstream guidance
- [ ] **Backup & restore engineering:** distinguish snapshots from backups; cover 3-2-1-style strategies, encrypted/off-site/immutable copies, tools such as `restic` or `borg`, application-consistent database backups, recovery-point/recovery-time objectives (RPO/RTO), and scheduled restore drills

### 6.8 Storage Administration Workbook
- [ ] **Lab 01: ZFS & LUKS2:** Building a ZFS RAIDZ2 pool on dedicated lab devices with native encryption, automated snapshots and remote `zfs send/receive` replication
- [ ] **Lab 02: Zero-Downtime LVM:** Migrating an active production ext4/XFS database volume across physical disks online using `pvmove` and expanding LVM thin pools
- [ ] **Lab 03: 3-Node MicroCeph:** Deploying a 3-node MicroCeph cluster and mounting replicated RBD block devices and CephFS across Ubuntu hosts

---

## 07. Network Administration

### 7.1 Linux Network Stack & TCP/IP Internals
- [ ] **Kernel Networking Path:** Ring buffers, NAPI, `sk_buff` (Socket Buffers), Netfilter hooks, XDP (eXpress Data Path), `ethtool` (offloads, ring sizes, queues, speeds)
- [ ] **IPv4 & IPv6 Addressing:** Subnetting, CIDR, VLSM, IPv6 SLAAC, DHCPv6, EUI-64, link-local vs global unicast, neighbour discovery (`ip neigh`, ARP vs NDP)
- [ ] **Routing & Policy Routing:** Primary routing table (`ip route`), multiple routing tables (`/etc/iproute2/rt_tables`), `ip rule` (source-based & `fwmark` policy routing), ECMP (Equal-Cost Multi-Path), MPTCP (Multipath TCP)

### 7.2 Ubuntu Netplan & Network Managers
- [ ] **Netplan Architecture on 26.04:** `/etc/netplan/*.yaml` hierarchy, `netplan generate/try/apply/status/get/set`, renderer differences (`systemd-networkd` for servers vs `NetworkManager` for desktops)
- [ ] **Complex Netplan Topologies:** Configuring static routes, multiple IPs, 802.1Q VLANs, LACP bonds (`802.3ad`, `active-backup`), network bridges, VRF (Virtual Routing and Forwarding), and SR-IOV virtual functions in YAML
- [ ] **systemd-networkd & nmcli:** Inspecting generated `/run/systemd/network/*.network` files, `networkctl status/lldp`, `nmcli` connection/device management, Wi-Fi WPA3 Enterprise

### 7.3 DNS Architecture & Name Resolution
- [ ] **Local Resolution Pipeline:** `/etc/nsswitch.conf`, `getent`, `systemd-resolved` stub listener (`127.0.0.53`), `/etc/systemd/resolved.conf`, split-DNS per interface, DNS-over-TLS (DoT), DNSSEC validation, `resolvectl`
- [ ] **Authoritative DNS (BIND9):** `named.conf.*`, forward & reverse zone files (`SOA`, `NS`, `A`, `AAAA`, `CNAME`, `MX`, `TXT`, `SRV`, `CAA`), views (split-horizon), TSIG zone transfers, DNSSEC zone signing
- [ ] **Recursive & Caching Resolvers:** Unbound (DNS-over-HTTPS/TLS caching, root hints), CoreDNS (`Corefile` plugins, etcd/K8s integration), `dnsmasq` (lightweight local DNS + TFTP)

### 7.4 Core Infrastructure & Edge Services
- [ ] **Modern DHCP (ISC Kea):** Migrating from legacy `isc-dhcp-server` to ISC Kea (`kea-dhcp4`, `kea-dhcp6`), JSON config, subnet pools, host reservations, HA active-standby, Stork dashboard
- [ ] **Reverse Proxies & Web Servers:** Nginx (worker tuning, `epoll`, upstream load balancing, `proxy_cache`, HTTP/3 QUIC, rate limiting), Caddy (automatic HTTPS), Apache2 (MPM event/worker)
- [ ] **L4/L7 Load Balancing & HA:** HAProxy (ACLs, stick-tables, health checks, SSL termination, Prometheus exporter) + Keepalived (VRRP protocol, virtual router IDs, health scripts, floating VIP failover)

### 7.5 Virtual Networking, SDN & Routing Daemons
- [ ] **Linux Virtual Interfaces:** Network Namespaces (`ip netns`), `veth` pairs, Linux bridges (`ip link add type bridge`, `bridge vlan`), MACVLAN (`bridge`/`vepa`/`passthru`), IPVLAN (L2/L3), VXLAN overlays, WireGuard interfaces
- [ ] **Open vSwitch & MicroOVN:** OVS architecture (`ovsdb-server`, `ovs-vswitchd`), `ovs-vsctl`, OpenFlow rules, Canonical MicroOVN distributed SDN for virtual clusters
- [ ] **Dynamic Routing (FRRouting):** FRR daemon suite (`zebra`, `bgpd`, `ospfd`), `vtysh` CLI, configuring BGP peering (eBGP/iBGP, ASNs, route-maps, BFD) for bare-metal load balancers (MetalLB/Cilium BGP)

### 7.6 VPNs & Zero-Trust Mesh Networks
- [ ] **WireGuard Cryptography & Setup:** Curve25519 keys, ChaCha20-Poly1305, `wg`, `wg-quick`, `/etc/wireguard/wg0.conf`, native Netplan WireGuard tunnels, hub-and-spoke vs point-to-point routing
- [ ] **Mesh Overlays:** Tailscale & self-hosted Headscale control server, DERP relays, subnet routers, exit nodes, Tailscale SSH
- [ ] **Enterprise IPSec & OpenVPN:** strongSwan (IKEv2 site-to-site IPSec tunnels, `swanctl.conf`) and OpenVPN `tls-crypt` setups

### 7.7 Packet Capture & Network Diagnostics
- [ ] **Socket & Flow Inspection:** `ss` (`-tulpn`, `-o`, TCP state machine timers), `lsof -i`, `conntrack-tools` (inspecting Netfilter connection tracking tables), `mtr`, `iperf3` throughput testing
- [ ] **Deep Packet Inspection:** `tcpdump` (BPF capture filters, TCP flag bitmasks, ring buffer rotation), `tshark` (Wireshark CLI dissectors, extracting TLS SNI & HTTP streams), `termshark`, `dropwatch` (locating kernel packet drops)

### 7.8 Network Administration Workbook
- [ ] **Lab 01: Enterprise Netplan:** Building a bonded LACP trunk with 3 isolated VLANs, a VM bridge, and source-based policy routing in a single Netplan configuration
- [ ] **Lab 02: HA Edge Load Balancer:** Deploying a dual-node Keepalived + HAProxy active/passive cluster with VRRP failover and automated TLS termination
- [ ] **Lab 03: BGP & WireGuard Mesh:** Connecting 3 isolated Ubuntu subnets over WireGuard tunnels with dynamic failover routing powered by FRRouting (OSPF/BGP)

---

## 08. Security, Cryptography & Hardening

### 8.1 Discretionary Access, ACLs & Capabilities
- [ ] **Standard & Special Permissions:** Mode bits, `umask` calculation, SUID (`4000`), SGID (`2000`), Sticky Bit (`1000`), hunting rogue SUID binaries with `find`
- [ ] **POSIX ACLs & Extended Attributes:** `getfacl`, `setfacl` (default vs access ACLs, mask recalculation), extended attributes (`getfattr`, `setfattr`), ext4/XFS file attributes (`chattr +i` immutable, `+a` append-only, `lsattr`)
- [ ] **Linux Capabilities:** Breaking root into 40+ capabilities (`CAP_NET_BIND_SERVICE`, `CAP_SYS_ADMIN`, `CAP_NET_RAW`), `getcap`, `setcap`, `capsh`, ambient vs bounding sets

### 8.2 Mandatory Access Control: AppArmor
- [ ] **AppArmor architecture and policy operations:** Linux Security Modules (LSM), path-based mandatory access control, `/etc/apparmor.d/*`, policy caches, `aa-status` and profile lifecycle tools; confirm tool availability for the installed AppArmor version
- [ ] **Profile Engineering:** Writing and profiling rules (file permissions `rwkmlix`, network rules, capability rules, mount/dbus/signal mediation, abstractions), `aa-genprof`, `aa-logprof`, `aa-complain`, `aa-enforce`
- [ ] **Ubuntu Security Center & Snaps:** AppArmor prompting in Ubuntu 26.04, XDG portal mediation, debugging denials in `journalctl` / `auditd` (`apparmor="DENIED"`)

### 8.3 OpenSSH Hardening & Post-Quantum Key Exchange
- [ ] **OpenSSH 10.2 hardening on Ubuntu 26.04 (check updates and client compatibility):** `/etc/ssh/sshd_config.d/*.conf`, Post-Quantum Key Exchange (`mlkem768x25519-sha256`), Ed25519 & FIDO2 hardware keys (`ed25519-sk`), disabling password & root auth, `sshd.service` alias
- [ ] **Brute-Force & Connection Defense:** OpenSSH native `PerSourcePenalties` (crash/auth failure throttling), `MaxStartups`, `LoginGraceTime`, `AllowUsers`/`AllowGroups`, `Match` blocks
- [ ] **SSH Certificate Authority (CA):** Eliminating TOFU & `authorized_keys` sprawl: `ssh-keygen` CA creation, signing user & host keys with principals and TTLs, `TrustedUserCAKeys`, `RevokedKeys` (KRL)
- [ ] **Bastions, Tunnels & Multiplexing:** `ProxyJump` (`-J`), local (`-L`), remote (`-R`), and dynamic SOCKS (`-D`) port forwarding, Unix domain socket forwarding, `ControlMaster` multiplexing, `sftp` chroot jails

### 8.4 Host Firewalls: UFW, Nftables & CrowdSec
- [ ] **nftables ruleset design and native Netfilter engine:** Netfilter hooks (`ingress`, `prerouting`, `input`, `forward`, `output`, `postrouting`), tables (`inet`, `ip`, `ip6`, `netdev`), chains, sets, maps, verdict maps, `/etc/nftables.conf`, `nft` CLI
- [ ] **UFW (Uncomplicated Firewall):** `ufw` rules, application profiles (`/etc/ufw/applications.d/`), rate limiting (`ufw limit`), logging levels, customizing `/etc/ufw/before.rules`
- [ ] **Active Intrusion Prevention:** CrowdSec (log parsing, scenarios, local API, `nftables` bouncer, community blocklists) & Fail2ban (jails, filters, actions)

### 8.5 Cryptography, PKI & Secret Primitives
- [ ] **System Crypto Libraries:** OpenSSL 3.x providers (FIPS provider), `Rustls` memory-safe TLS adoption in Ubuntu 26.04, `/etc/ssl/openssl.cnf`
- [ ] **Internal PKI (step-ca / CFSSL):** Designing a Root + Intermediate CA hierarchy, running `smallstep` `step-ca` with automated ACME server for internal Linux hosts, mTLS authentication
- [ ] **Public TLS & Let's Encrypt:** ACME protocol (`HTTP-01`, `DNS-01`, `TLS-ALPN-01` challenges), Certbot, `acme.sh`, automated renewal hooks
- [ ] **File & Key Encryption:** GnuPG (GPG keyrings, subkeys, signing, encryption), modern `age` encryption (`age`, `age-keygen`, SSH key recipients)

### 8.6 Kernel Hardening, Auditing & Compliance
- [ ] **Kernel Self-Protection:** Kernel lockdown mode (`integrity` vs `confidentiality`), `sysctl` security hardening (`kptr_restrict`, `dmesg_restrict`, `unprivileged_bpf_disabled`, `yama.ptrace_scope`, `rp_filter`, `tcp_syncookies`)
- [ ] **Linux Audit Daemon (auditd):** `/etc/audit/rules.d/*.rules`, watching sensitive files (`-w /etc/shadow -p wa`), auditing syscalls (`-a always,exit -F arch=b64 -S execve`), `ausearch`, `aureport`, `auditctl`
- [ ] **File Integrity & Hardware Lock:** AIDE (Advanced Intrusion Detection Environment database & daily checks), USBGuard (blocking rogue BadUSB devices via policy)
- [ ] **CIS Benchmarks & USG:** Ubuntu Security Guide (USG) via Ubuntu Pro, tailoring CIS Level 1 & Level 2 profiles, OpenSCAP scanning, Lynis security auditing, Canonical Livepatch kernel patching

### 8.7 Security & Hardening Workbook
- [ ] **Lab 01: Post-Quantum SSH CA:** Deploying a zero-trust SSH Certificate Authority with FIDO2 hardware keys, short-lived certificates, and a locked-down `ProxyJump` bastion
- [ ] **Lab 02: Custom AppArmor & Nftables:** Writing a strict AppArmor profile for a custom network daemon and isolating it with a stateful `nftables` ruleset + CrowdSec bouncer
- [ ] **Lab 03: CIS Level 2 Audit:** Auditing an Ubuntu 26.04 server with Lynis & USG, applying kernel `sysctl`/`auditd` rules, and achieving a hardened compliance score

---

## 09. Virtualization (VMs) & Bare-Metal Cloud

### 9.1 KVM, QEMU & Hypervisor Internals
- [ ] **Hardware Virtualization:** Intel VT-x / AMD-V, EPT / RVI shadow page tables, `/dev/kvm` ioctl interface, `kvm` & `kvm_intel`/`kvm_amd` modules, nested virtualization
- [ ] **Ubuntu 26.04 Virt Tracks:** Choosing between Ubuntu 26.04 LTS baseline virtualization stack vs Canonical's opt-in Rolling Virtualization stack (latest QEMU/libvirt)
- [ ] **QEMU Architecture:** `qemu-system-x86_64` machine types (`q35` vs `i440fx`), OVMF UEFI firmware + emulated TPM2 (`swtpm`), `virtio-blk`/`virtio-scsi`, `virtio-net` (`vhost-net`), `virtiofs` shared directories

### 9.2 Libvirt Ecosystem & Image Engineering
- [ ] **Libvirt Daemon & virsh CLI:** Modular libvirt daemons (`virtqemud`, `virtnetworkd`, `virtstoraged`), `virsh` lifecycle commands, `virsh console`, domain XML anatomy, CPU pinning & NUMA tuning
- [ ] **Storage Pools & VM Snapshots:** Directory, LVM, ZFS, and RBD libvirt storage pools; `qemu-img` (creating `qcow2`, backing files, compression, converting `raw`/`vmdk`/`qcow2`); external live snapshots (`virsh snapshot-create-as`, `blockcommit`)
- [ ] **Libvirt Networking:** Default NAT network (`virbr0`), routed networks, bridged networks, `macvtap`, Open vSwitch integration
- [ ] **Instant Cloud VMs:** Canonical Multipass (`multipass launch`, `mount`, `exec`, `cloud-init` blueprints), `cloud-localds`, `virt-install` unattended cloud image provisioning, `virt-customize` (`libguestfs`)

### 9.3 PCIe, GPU & AI Accelerator Passthrough
- [ ] **IOMMU & VFIO Isolation:** Enabling `intel_iommu` / `amd_iommu`, inspecting IOMMU groups, binding devices to `vfio-pci`, ACS override caveats
- [ ] **GPU & NPU Passthrough:** Passing discrete NVIDIA/AMD GPUs and AI NPUs into Ubuntu VMs for native CUDA/ROCm workloads, Looking Glass shared-memory framebuffers
- [ ] **SR-IOV (Network & GPU):** Creating PCIe Virtual Functions (VFs) on enterprise NICs and GPUs, assigning VFs directly to KVM guests for near-zero overhead I/O

### 9.4 LXD & Incus (Unified Containers & VMs)
- [ ] **Architecture & Storage:** Daemon REST API, CLI workflow, initializing ZFS/Btrfs/LVM/Ceph storage pools, profiles, projects (multi-tenancy)
- [ ] **System Containers vs KVM VMs:** Launching full OS system containers vs `--vm` hardware virtual machines with identical syntax, resource limits (CPU, RAM, disk IOPS), device hotplugging
- [ ] **Clustering & OVN Networking:** Joining 3+ Ubuntu nodes into a fault-tolerant LXD/Incus cluster, live migration, distributed MicroOVN virtual networks, BGP ingress

### 9.5 Private Cloud Stacks (MicroCloud, Proxmox, OpenStack)
- [ ] **Canonical MicroCloud:** Zero-ops HA private cloud combining LXD, MicroCeph, and MicroOVN (`microcloud init`), self-healing storage and workloads
- [ ] **Proxmox VE for Ubuntu Admins:** Debian/Ubuntu kernel lineage, `pve-cluster` (Corosync), managing Ubuntu 26.04 `cloud-init` VM templates, Proxmox Backup Server (PBS)
- [ ] **OpenStack Sunbeam:** Deploying Canonical OpenStack (Sunbeam) on Ubuntu 26.04 using Kubernetes & Juju operators (Nova, Neutron, Cinder, Glance, Keystone)

### 9.6 Bare-Metal Cloud Provisioning (Canonical MAAS)
- [ ] **MAAS Architecture:** Region Controller vs Rack Controller, PostgreSQL backend, DHCP/DNS/PXE/HTTP boot orchestration
- [ ] **Hardware Lifecycle:** Out-of-band BMC management (IPMI, Redfish), automatic hardware discovery, commissioning scripts, hardware testing (CPU/RAM/Storage burn-in)
- [ ] **Zero-Touch OS Deployment:** Curtailing storage layouts (LVM/RAID/ZFS), network bond/VLAN pre-configuration, deploying Ubuntu 26.04 LTS to physical rack servers in minutes via API/CLI

### 9.7 Virtualization & Cloud Workbook
- [ ] **Lab 01: Headless KVM & Cloud-Init:** Building an Ubuntu 26.04 KVM hypervisor with bridged Netplan networking, ZFS storage pool, and automated `cloud-init` `qcow2` template deployment
- [ ] **Lab 02: GPU/PCIe Passthrough:** Isolating a PCIe device via VFIO and attaching it to a UEFI + `swtpm` KVM virtual machine
- [ ] **Lab 03: 3-Node MicroCloud:** Bootstrapping a 3-node HA cluster with distributed Ceph storage, OVN networking, and live VM migration

---

## 10. Containers & Kubernetes (cgroup v2 Native)

### 10.1 Linux Container Internals (Building from Scratch)
- [ ] **The 7 Linux Namespaces:** Isolating PID, Network, Mount, UTS, IPC, User (UID/GID mapping), and Cgroup namespaces using `unshare` and `nsenter`
- [ ] **cgroup v2 isolation mechanics:** unified-hierarchy concepts, CPU/memory/I/O/PID controllers, PSI (Pressure Stall Information), and delegating cgroup subtrees to unprivileged rootless users; verify active controllers and delegation rules on the target host
- [ ] **Union Filesystems & Rootfs:** OverlayFS (`lowerdir`, `upperdir`, `workdir`, `merged`), `pivot_root` vs `chroot`, building a container from scratch using only `bash`, `unshare`, `mount`, and `cgroups`
- [ ] **Container Security Primitives:** Dropping capabilities, `seccomp-bpf` syscall filtering profiles, AppArmor container profiles, `no_new_privileges` flag

### 10.2 Developer Environments: Ptyxis, Distrobox & Toolbx
- [ ] **Ptyxis Container Terminal:** Ubuntu 26.04's default terminal architecture, native container profile detection, spawning isolated shell tabs directly inside containers
- [ ] **Distrobox & Toolbx:** Running mutable development environments (Arch, Fedora, older Ubuntu releases) seamlessly integrated with the host home directory and Wayland display

### 10.3 Docker & Rootless Podman Engineering
- [ ] **Runtime Architecture:** OCI (Open Container Initiative) runtime spec, `runc` vs `crun` (fast C runtime), `containerd`, Docker daemon vs daemonless fork/exec Podman
- [ ] **Rootless Podman Mastery:** `subuid`/`subgid` (`/etc/subuid`), `newuidmap`, and rootless networking with `pasta` and/or `slirp4netns` according to the installed version and configuration; cover rootless storage drivers and OverlayFS requirements
- [ ] **Podman Quadlets (Systemd):** Writing `.container`, `.volume`, `.network`, and `.kube` Quadlet files in `/etc/containers/systemd/` and `~/.config/containers/systemd/` for systemd-managed containers
- [ ] **Docker Compose & Podman Pods:** Multi-container orchestration with `compose.yaml`, healthchecks, dependency ordering, secrets, and Podman native Kubernetes Pod YAML generation (`podman kube generate/play`)

### 10.4 Production Image Engineering & Chiseled Ubuntu
- [ ] **Advanced Containerfiles:** BuildKit architecture, multi-stage builds, cache mounts (`--mount=type=cache`), secret mounts (`--mount=type=secret`), layer optimization, multi-arch builds (`buildx`)
- [ ] **Chiseled Ubuntu & Chisel:** create minimal, application-specific root-filesystem slices with `chisel cut`; document trade-offs for debugging, certificates, locale data and runtime dependencies
- [ ] **Rockcraft & OCI Rocks:** author `rockcraft.yaml`, package Chiseled Ubuntu slices with Pebble, and measure image size, startup behavior and vulnerability findings without promising a fixed size or zero-CVE result

### 10.5 Registry Operations & Supply Chain Security
- [ ] **Private OCI Registries:** Deploying CNCF Harbor (projects, RBAC, replication policies, pull-through proxy cache, garbage collection) and Zot registry
- [ ] **Vulnerability, SBOM & Signing:** Generating Software Bills of Materials with Syft (SPDX/CycloneDX), scanning images with Trivy/Grype, keyless OIDC image signing & attestation with Sigstore Cosign

### 10.6 Kubernetes Architecture on Ubuntu 26.04
- [ ] **Control Plane & Node Internals:** `kube-apiserver`, `etcd` (Raft consensus, snapshot backup/restore), `kube-scheduler`, `kube-controller-manager`, `kubelet` (configured with `systemd` cgroup v2 driver), `containerd` CRI
- [ ] **Canonical Kubernetes & MicroK8s:** Deploying production Kubernetes on Ubuntu 26.04, high-availability `dqlite`/`etcd` control planes, cluster upgrades, CIS-hardening addons
- [ ] **Kubeadm & k3s:** Bootstrapping bare-metal clusters with `kubeadm`, `kube-vip` control plane HA, lightweight edge Kubernetes with `k3s`

### 10.7 Kubernetes Workloads, eBPF Networking & Storage
- [ ] **Core & Stateful Workloads:** Pods, Deployments, ReplicaSets, StatefulSets, DaemonSets, Jobs/CronJobs, Init/Sidecar containers, Probes (liveness, readiness, startup), Pod Disruption Budgets
- [ ] **Scheduling & Autoscaling:** Resource requests/limits, QoS classes, Taints & Tolerations, Node Affinity, Topology Spread Constraints, HPA, VPA, Karpenter
- [ ] **Cilium (eBPF CNI) & Gateway API:** Replacing `kube-proxy` completely with Cilium eBPF, L3/L4/L7 `NetworkPolicies`, Cilium BGP Control Plane + L2 announcements, Kubernetes Gateway API (`HTTPRoute`, `GRPCRoute`, `TLSRoute`)
- [ ] **Persistent Storage (CSI):** `StorageClasses`, PVCs/PVs, `VolumeSnapshots`, deploying Rook-Ceph, Longhorn, or OpenEBS ZFS LocalPV on Ubuntu nodes
- [ ] **Kubernetes security:** RBAC (`Roles`, `ClusterRoles`, `Bindings`), `ServiceAccounts`, Pod Security Admission (`Baseline` / `Restricted`), Kyverno / OPA Gatekeeper, and runtime detection with Falco or Tetragon; verify component support and deployment-specific requirements

### 10.8 Containers & Kubernetes Workbook
- [ ] **Lab 01: Rootless Quadlets:** Migrating a multi-container Compose stack (App + Postgres + Valkey + Caddy) into rootless Podman Quadlet systemd units with auto-updates
- [ ] **Lab 02: Chiseled Ubuntu Rock:** Crafting a shell-less Chiseled Ubuntu container image with Rockcraft, generating an SBOM with Syft, scanning with Trivy, and signing with Cosign
- [ ] **Lab 03: HA K8s with Cilium:** Deploying a 3-node Kubernetes cluster on Ubuntu 26.04 with `kube-proxy` disabled, Cilium eBPF CNI + Gateway API, and Rook-Ceph persistent block storage

---

## 11. DevOps Engineering, IaC & Observability

### 11.1 Git Internals & Enterprise Version Control
- [ ] **Git Plumbing & Object Model:** Blobs, trees, commits, annotated tags, content-addressable `.git/objects`, packfiles, reflog recovery (`git reflog`, `git fsck`)
- [ ] **Advanced Workflows:** Trunk-based development vs GitFlow, interactive rebase (`git rebase -i`, `autosquash`), `git bisect` automated bug hunting, `git worktree`, submodules vs subtrees
- [ ] **Cryptographic Commit Signing:** Signing commits and tags with SSH keys (OpenSSH `allowed_signers`) or GPG keys, enforcing verified signatures in branch protection rules
- [ ] **Self-Hosted Git Platforms:** Deploying and operating Forgejo / Gitea and GitLab CE on Ubuntu 26.04 (PostgreSQL tuning, Redis/Valkey, Gitaly, object storage backends)

### 11.2 Configuration Management: Ansible & Juju
- [ ] **Ansible Core Architecture:** Agentless SSH execution, `ansible.cfg` optimization (pipelining, SSH multiplexing), static & dynamic inventories (Cloud, LXD, MAAS, Proxmox plugins)
- [ ] **Playbooks, Roles & Collections:** Idempotency, tasks, handlers, Jinja2 templating, variables & precedence, writing reusable Roles, Ansible Galaxy Collections (`ansible-galaxy`), Ansible Vault encryption
- [ ] **Testing & Execution Environments:** `ansible-lint`, Molecule (testing roles against Ubuntu 26.04 Podman containers), Execution Environments (`ansible-builder`, `ansible-navigator`), AWX / Semaphore UI
- [ ] **Canonical Juju & Charms:** Model-driven operations: Juju controllers, models, deploying Charmed Operators on VM clouds and Kubernetes, relations/integrations, writing Python Charms with `ops` library

### 11.3 Infrastructure as Code: OpenTofu, Packer & Bootc
- [ ] **OpenTofu / Terraform Core:** HCL syntax, providers (AWS, GCP, Azure, LXD/Incus, Proxmox, MAAS, Kubernetes), resources, data sources, variables, outputs, `for_each` / `count`, dynamic blocks
- [ ] **State & Module Engineering:** Remote state backends (S3/RadosGW with locking, PostgreSQL), state encryption (OpenTofu native state encryption), state manipulation (`tofu state mv/import`), writing composable modules, Terragrunt
- [ ] **Golden Image Factory (Packer):** HashiCorp Packer HCL templates, automating Ubuntu 26.04 Subiquity Autoinstall builds, running Ansible provisioners during build, outputting `qcow2`, AMI, and Proxmox templates
- [ ] **Immutable Linux (Ubuntu Core & bootc):** Image-based OS management: Ubuntu Core (all-snap transactional OS, gadget/kernel/base snaps) and bootable OCI containers (`bootc` / OSTree) where OS updates are container pulls

### 11.4 CI/CD Pipelines & Private Artifact Repositories
- [ ] **CI/CD Pipeline Architecture:** Designing build, lint, test, security-scan, package, and deploy stages in GitHub Actions, GitLab CI (`.gitlab-ci.yml`), and Woodpecker CI
- [ ] **Self-Hosted Ubuntu 26.04 Runners:** Deploying ephemeral self-hosted runners (GitHub Actions Runner Scale Sets on K8s / ephemeral LXD VMs) to prevent build-state pollution
- [ ] **Private APT & Package Repos:** Hosting internal DEB822 APT repositories on Ubuntu 26.04 using `Debarchive`, `aptly`, or `reprepro`; GPG repository signing; Nexus / Artifactory caching proxies

### 11.5 Full-Stack Observability (Metrics, Logs, Traces)
- [ ] **Metrics: Prometheus & VictoriaMetrics:** Pull vs Push models, Prometheus TSDB architecture, PromQL (`rate`, `irate`, `histogram_quantile`, aggregations), `node_exporter` (Linux host metrics), `systemd_exporter`, Alertmanager routing
- [ ] **Visualization: Grafana:** Provisioning datasources and dashboards as code (JSON/Grafonnet), Golden Signals (Latency, Traffic, Errors, Saturation), USE & RED methodologies
- [ ] **Logging: Grafana Loki & Alloy:** label-based log aggregation with Loki, LogQL, and Grafana Alloy pipelines for `systemd-journald` and container logs; treat collector migration as a planned compatibility task
- [ ] **Distributed Tracing (OpenTelemetry):** OpenTelemetry Collector architecture (receivers, processors, exporters), auto-instrumentation, Grafana Tempo trace storage, correlating logs, metrics, and traces (Exemplars)

### 11.6 eBPF & Deep Kernel Performance Engineering
- [ ] **Modern Linux eBPF Architecture:** eBPF virtual machine, verifier, JIT compiler, eBPF maps, `kprobes`/`uprobes`, tracepoints, `fentry`/`fexit`, BTF (BPF Type Format), CO-RE (Compile Once – Run Everywhere), and kernel-version-dependent feature checks
- [ ] **BCC Tools & bpftrace:** Live production diagnostics without overhead: `execsnoop`, `opensnoop`, `biolatency`, `tcplife`, `runqlat`, writing custom `bpftrace` one-liners and scripts
- [ ] **CPU & Memory Profiling:** `perf` (hardware performance counters, `perf record/report`), generating FlameGraphs, Ubuntu 26.04 `Sysprof` continuous profiling
- [ ] **eBPF Security & Network Tracing:** Cilium Hubble (network flow visibility), Tetragon (eBPF runtime security enforcement & process lineage tracking)

### 11.7 DevOps & Observability Workbook
- [ ] **Lab 01: Automated Image Factory:** Using Packer + Autoinstall + Ansible to build a hardened Ubuntu 26.04 golden image, then deploying a 5-node environment with OpenTofu
- [ ] **Lab 02: Full LGTM Stack:** Deploying Prometheus, Grafana, Loki, Tempo, and Grafana Alloy to monitor host systemd services, ZFS pools, and container workloads
- [ ] **Lab 03: eBPF Production Triage:** Finding a hidden disk I/O bottleneck, a memory leak, and an unauthorized outbound connection using `bpftrace`, `perf` FlameGraphs, and Tetragon

---

## 12. GitOps & Cloud-Native Operations

### 12.1 GitOps Architecture & Repository Topologies
- [ ] **The OpenGitOps principles:** declarative desired state, versioned and immutable storage, automatic pull, and continuous reconciliation
- [ ] **Push CI vs pull-based GitOps:** reduce long-lived cluster credentials in CI; separate CI (build / test / scan / publish) from CD (reconcile reviewed desired state to clusters and infrastructure)
- [ ] **Repository Structuring:** Monorepo vs Polyrepo vs Repo-per-Team; separating Application Source Repos from Environment Configuration Repos; directory layouts (`base/`, `overlays/dev`, `overlays/prod`, `clusters/`)

### 12.2 Declarative Manifest Packaging
- [ ] **Kustomize Mastery:** Template-free customization: `kustomization.yaml`, bases, overlays, strategic merge patches vs JSON6902 patches, `replacements`, `configMapGenerator` & `secretGenerator` with hash suffixes
- [ ] **Helm Engineering:** Chart anatomy (`Chart.yaml`, `values.yaml`, `templates/`), Go templating functions, named templates (`_helpers.tpl`), library charts, OCI Helm registry publishing, Helm hooks
- [ ] **Next-Gen Config Languages:** Type-safe Kubernetes configuration with CUE (Timoni), Jsonnet (Tanka), and KCL

### 12.3 Argo CD Mastery
- [ ] **Argo CD Architecture:** API Server, Repository Server, Application Controller, Redis/Valkey cache, Dex OIDC SSO integration, high-availability installation
- [ ] **Application & AppProject CRDs:** Declarative `Application` manifests, automated sync policies (`prune: true`, `selfHeal: true`), sync options (`ServerSideApply=true`, `CreateNamespace=true`), RBAC & multi-tenancy with `AppProjects`
- [ ] **Scale Patterns: App-of-Apps:** Bootstrapping entire clusters with the App-of-Apps pattern, ordering deployments with Sync Waves (`argocd.argoproj.io/sync-wave`) and Resource Hooks (`PreSync`, `Sync`, `PostSync`, `SyncFail`)
- [ ] **ApplicationSets & Generators:** Automating multi-cluster and multi-tenant deployments using Git Directory/File generators, List generators, Matrix/Merge generators, and Pull Request generators (ephemeral preview environments)

### 12.4 Flux CD Mastery
- [ ] **Flux Modular Controllers:** Source Controller (`GitRepository`, `OCIRepository`, `HelmRepository`), Kustomize Controller (`Kustomization`), Helm Controller (`HelmRelease`), Notification Controller
- [ ] **Bootstrapping & Dependencies:** `flux bootstrap`, dependency ordering (`dependsOn`), health checks, drift detection with server-side dry runs
- [ ] **Automated Image Updates:** Image Reflector Controller (`ImageRepository`, `ImagePolicy` semver filtering) + Image Automation Controller (`ImageUpdateAutomation` committing new image digests back to Git)

### 12.5 GitOps Secrets Management (Keep Secret Values Out of Plaintext Git)
- [ ] **SOPS + age / KMS:** encrypt selected secret data while retaining useful diffs, define `.sops.yaml` rules, and configure supported decryption for Flux or Argo CD; ensure no secret fields or generated artifacts remain exposed in plaintext
- [ ] **Bitnami Sealed Secrets:** Asymmetric cluster-side encryption (`kubeseal` CLI + controller private key), key rotation, scope modes (`strict`, `namespace-wide`, `cluster-wide`)
- [ ] **External Secrets Operator (ESO):** Decoupling secrets from Git completely: syncing secrets dynamically from OpenBao / HashiCorp Vault, AWS/GCP Secret Managers, or 1Password/Bitwarden into Kubernetes `Secret` objects via `ExternalSecret` CRDs

### 12.6 Progressive Delivery & Automated Rollbacks
- [ ] **Deployment Strategies:** `RollingUpdate` limitations vs Blue/Green (instant traffic cutover) vs Canary (gradual percentage weight shifting + header/cookie routing)
- [ ] **Argo Rollouts:** Replacing standard `Deployment` with `Rollout` CRD, integrating with Kubernetes Gateway API / Cilium / Nginx / Istio for fine-grained traffic splitting
- [ ] **Automated Metric Analysis:** `AnalysisTemplate` and `AnalysisRun` CRDs: querying Prometheus for HTTP 5xx error rates and p99 latency during a canary rollout and triggering automatic instant rollback on threshold breach

### 12.7 GitOps Beyond Containers (Bare-Metal, VMs & Cloud Infra)
- [ ] **Crossplane (Cloud via CRDs):** Turning Kubernetes into a universal control plane: Providers, Managed Resources, Compositions (`CompositeResourceDefinition`), provisioning cloud databases/buckets/networks alongside app manifests
- [ ] **KubeVirt (Ubuntu VMs in GitOps):** managing KVM-backed Ubuntu `VirtualMachine` resources through Argo CD / Flux; document prerequisites and constraints for live migration, shared storage, networking and CPU compatibility
- [ ] **Cluster API (CAPI):** Declarative Kubernetes cluster lifecycle management on MAAS, OpenStack, Proxmox, and public clouds
- [ ] **Git-Driven OpenTofu & Ansible:** Pull-request automation with Atlantis / Digger, Flux `tf-controller` (reconciling OpenTofu modules continuously), and AWX/Semaphore Git webhook triggers for bare-metal Ubuntu fleets

### 12.8 GitOps Workbook
- [ ] **Lab 01: Single-Commit Cluster:** Bootstrapping a bare Kubernetes cluster on Ubuntu 26.04 where a single `flux bootstrap` or `argocd` root application deploys Cilium Gateway API, Cert-Manager, SOPS secrets, Monitoring, and apps automatically
- [ ] **Lab 02: Self-Healing Canary:** Deploying a microservice with Argo Rollouts and Prometheus `AnalysisTemplate`, injecting artificial latency, and watching GitOps automatically abort and roll back the release
- [ ] **Lab 03: VM & Infra GitOps:** Managing Ubuntu 26.04 virtual machines via KubeVirt and provisioning S3 storage via Crossplane purely through Git pull requests

---

## 13. Appendices & Production Runbooks

### 13.1 Appendix A: Ubuntu 26.04 LTS Migration & Compatibility Matrix
- [ ] **rust-coreutils & sudo-rs:** compatibility matrix, auditing scripts for flag/behavior assumptions, testing fallback to GNU utilities when needed, and validating privilege-policy differences
- [ ] **cgroup v2 compatibility checklist:** detect legacy JVM, container and monitoring software that assumes cgroup v1 paths or controllers
- [ ] **Network, time and APT transitions:** evaluate `systemd-timesyncd` to Chrony/NTS migration and convert legacy APT entries to DEB822 `.sources` after checking the existing configuration

### 13.2 Appendix B: Emergency Incident Response Runbooks
- [ ] **Runbook 01: Server Won't Boot:** Diagnosing UEFI/Shim failures, TPM PCR mismatch recovery key entry, repairing broken `initramfs`/GRUB from Live ISO chroot
- [ ] **Runbook 02: Storage 100% Full:** Resolving 100% disk or 100% inode exhaustion, finding deleted-but-open files (`lsof +L1`), emergency online LVM/ZFS expansion
- [ ] **Runbook 03: CPU / Load Spike:** 60-second Linux triage (`uptime`, `dmesg -T`, `vmstat 1`, `mpstat -P ALL 1`, `pidstat 1`, `iostat -xz 1`, `sar`, `bpftrace`)
- [ ] **Runbook 04: Security Breach:** Isolating a host with `nftables`, capturing volatile memory/processes, inspecting `auditd`/`journalctl` trails, rotating SSH CA & LUKS keys

### 13.3 Appendix C: The Reference Homelab Blueprint
- [ ] **Three-node mini-PC architecture:** hardware bill of materials, VLAN layout, provisioning layer, and a staged path toward Kubernetes, Cilium, distributed storage and GitOps; document resource minima, failure domains, recovery tests and cost/complexity trade-offs

---

## Editorial Standards for Each Chapter

Before marking a topic complete, verify that its documentation:
- states the target release and whether each feature is default, optional, desktop-only, server-only, subscription-gated or experimental;
- distinguishes inspection commands from commands that mutate state, and explains required privileges;
- includes expected output or a verification command, rollback/recovery guidance, and likely failure modes;
- avoids absolute performance, security, availability or image-size claims unless they are measurable and reproducible;
- cites primary documentation and records the last-verified date for version-sensitive behavior.
