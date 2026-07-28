# Mastering Nix & NixOS: From Zero to Enterprise Production Architecture

### The Definitive Certification-Grade Curriculum  
**Nix Fundamentals → NixOS Administration → Fleet Engineering → Principal Platform Architecture**

*Unified and substantially expanded (July 2026) from official documentation (`nix.dev`, Nix/NixOS/Nixpkgs manuals), Zero to Nix, the NixOS & Flakes Book, NixOS Discourse & Wiki, Determinate Systems engineering publications, Lix and Tvix project materials, NixCon proceedings, production SRE practice, and community skill-tree discussions — plus an original **Expert Production Lab Catalog** (timed incidents, fleet war games, cache/secrets/ops patterns) authored for this track.*

---

## Table of Contents

1. [Vision & Curriculum Architecture](#0-vision--curriculum-architecture)
2. [Competency Tiers & Level Matrix](#1-competency-tiers--level-matrix)
3. [How Each Module Is Structured](#2-how-each-module-is-structured)
4. [Part 0 — Linux Foundations (Prerequisite)](#part-0--linux-foundations-prerequisite)
5. [Tier 1 — Foundation (NCA)](#tier-1--foundation-nca)
6. [Tier 2 — Professional (NCP)](#tier-2--professional-ncp)
7. [Tier 3 — Expert & Architect (NCE)](#tier-3--expert--architect-nce)
8. [Master Capstone Suite](#master-capstone-suite)
9. [Practical Workbook & Lab Index](#practical-workbook--lab-index)
10. [Expert Production Lab Catalog (Grok)](#expert-production-lab-catalog-grok)
11. [Live Ops Drills & Incident Simulations](#live-ops-drills--incident-simulations)
12. [Reference Lab Environment Blueprint](#reference-lab-environment-blueprint)
13. [Assessment & Certification-Style Checkpoints](#assessment--certification-style-checkpoints)
14. [Optional Specialization Tracks](#optional-specialization-tracks)
15. [Appendix A — Canonical Resource Library](#appendix-a--canonical-resource-library-2026)
16. [Appendix B — Scope Boundaries & Deliberate Exclusions](#appendix-b--scope-boundaries--deliberate-exclusions)
17. [Appendix C — Ecosystem Map (2026)](#appendix-c--ecosystem-map-mid-2026)
18. [Appendix D — Suggested Study Cadence](#appendix-d--suggested-study-cadence)
19. [Appendix E — Production Patterns Cheat Sheet](#appendix-e--production-patterns-cheat-sheet-expert)

---

## 0. Vision & Curriculum Architecture

### The Problem This Course Solves

The Nix ecosystem’s learning material is powerful but scattered: half-finished wiki pages, Discourse threads, personal flake repos, and blogs that stop at “here are my dotfiles.” Almost nobody teaches **why** Nix works internally at the store/evaluator level, and there is no single path comparable to RHCSA → RHCE → RHCA, LFCS → LFCE, or CKA for production Nix/NixOS engineering.

This curriculum is that path.

### Paradigm Shift

Traditional Linux administration mutates global state (`/usr/lib`, `/etc`, `/var`). Builds are impure; machines become snowflakes; rollbacks are archaeology. Nix models software and system configuration as **pure, lazy, side-effect-free functions** over a content-addressed store. NixOS elevates that model to the entire OS: one evaluated configuration, atomic generations, and a bootloader-level rollback story.

You do not “install packages and edit configs.” You **describe desired closed systems**, evaluate them to derivations, realize store paths, and activate profiles.

### Outcome Statement

> Become a Production Nix Infrastructure Engineer capable of designing, building, operating, hardening, and debugging enterprise infrastructure with Nix and NixOS — from a single laptop to a multi-region fleet with private binary caches, secrets, and supply-chain controls.

### Design Principles

| Principle | Meaning in this course |
|---|---|
| **Language first** | Fluency in the Nix language before cargo-culting modules |
| **Why before how** | Store, derivations, evaluation vs realization before CLI muscle memory |
| **Flakes as de facto standard** | Teach channels/legacy CLI honestly, practice on flakes |
| **Production bias** | Every advanced module answers “what breaks in prod and how do you recover?” |
| **Hands-on proof** | Milestone projects and labs, not passive reading |
| **Informed ecosystem stance** | Classic Nix vs Determinate Nix vs Lix — opinions earned, not copied |
| **Linux remains real** | When systemd fails, you still debug Linux — NixOS is not magic |

### Target Audience

- System administrators and DevOps/SRE engineers moving from apt/dnf/pacman/Ansible worlds  
- Software developers who need hermetic, reproducible toolchains and CI  
- Infrastructure architects implementing immutable IaC and GitOps  
- Platform engineers packaging internal software and owning internal Nix modules  

### Prerequisites (honest)

- Comfortable on a Unix shell; basic networking and processes  
- Optional but strongly recommended: prior Linux admin (users, systemd, packages)  
- Part 0 exists so that missing Linux fundamentals do not become a silent failure mode later  

### Duration (planning guide)

| Pace | Wall time | Hours (approx.) |
|---|---|---|
| Serious part-time (evenings/weekends) | 6–9 months | 300–500 |
| Intensive (full-time immersion) | 10–14 weeks | 300–400 |
| Tier 1 only (daily driver + single box) | 6–10 weeks | 80–120 |
| + Production lab catalog (L6 / INC / ARCs) | +4–8 weeks | +80–150 |

**Environment assumption:** Prefer disposable VMs/containers (QEMU/KVM, LXD, cloud) for destructive experiments. Keep a personal daily-driver Nix install separate from lab breakage. Allocate ≥50 GB for `/nix/store` on any serious lab host.

---

## 1. Competency Tiers & Level Matrix

### Three formal tiers (informal cert designations)

| Tier | Codename | Levels | Industry analogue | Competency bar |
|---|---|---|---|---|
| **Tier 1 — Foundation** | **NCA** (Nix Certified Associate) | 000–200 | RHCSA / LFCS | Language fluency, store mechanics, devShells, single-machine NixOS install/admin/rollback |
| **Tier 2 — Professional** | **NCP** (Nix Certified Professional) | 300–500 | RHCE / LFCE / CKA | Flakes workspaces, packaging, overlays, custom modules, Home Manager, Disko, secrets |
| **Tier 3 — Expert & Architect** | **NCE** (Nix Certified Expert) | 600–800 | RHCA / Senior SRE / Principal Platform | Fleet provisioning, binary caches, CI/CD, containers/images, hardening/SBOM, evaluator internals, upstream contribution |

### Progressive level spine

```
Level 000: Linux architecture & OS mechanics (prerequisite)
Level 100: Philosophy, store model, language semantics
Level 200: Package manager, Nixpkgs consumer skills, stdenv awareness
Level 300: Flakes, modern CLI, hermetic developer environments
Level 400: Single-host NixOS administration, storage (Disko)
Level 500: Module system, Home Manager, secrets
Level 600: Zero-touch provisioning, fleet orchestration, overlays at scale
Level 700: CI/CD, binary caches, containers/images, security & compliance
Level 800: Evaluator internals, CA derivations, ecosystem research, monorepo architecture
```

### Learning path diagram

```
Part 0 (Linux) ──► Tier 1 (NCA) ──► Tier 2 (NCP) ──► Tier 3 (NCE) ──► Capstones
                      │                  │                  │
                      │                  │                  ├── Fleet + Cache + CI
                      │                  ├── Modules + Secrets + Disko
                      └── Language + Store + One NixOS box
```

Optional tracks (desktop, GPU/ML, NixBSD research) attach after Tier 2 without blocking the main spine.

---

## 2. How Each Module Is Structured

Every module below follows the same professional course shape:

1. **Level & focus** — where it sits on the spine  
2. **Learning objectives** — measurable outcomes  
3. **Core topics** — multi-level topic tree (L1 → L2 → L3 depth)  
4. **Why it matters in production** — operational justification  
5. **Practical labs** — skill drills  
6. **Milestone project** — proof of competency  
7. **Curated resources** — living docs only (2024–2026 relevant)  
8. **Anti-patterns & gotchas** — what experts watch for  

Cross-module **production war games** live in [Expert Production Lab Catalog](#expert-production-lab-catalog-grok) and [Live Ops Drills](#live-ops-drills--incident-simulations) (`PROD-LAB-*`, `PROD-ARC-*`, `INC-*`). After NCP, schedule at least one incident drill per week.  

---

# PART 0 — Linux Foundations (Prerequisite)

> **Level:** 000 | **Focus:** Core Linux mechanics required to understand NixOS abstractions  
> Skip only if you already debug systemd, namespaces, storage, and permissions confidently.

---

## Module 0: Linux Architecture & Operating System Foundations

### Learning Objectives

- Explain kernel vs userspace, process lifecycle, and how init systems supervise services  
- Navigate FHS and articulate why mutable global state creates dependency collisions  
- Manage disks, filesystems, mounts, and basic networking without a GUI  
- Use permissions, capabilities, and namespaces as the ground truth beneath containers and Nix sandboxes  

### Core Topics

#### 0.1 Kernel, userspace, and boot

- System calls; `fork` / `exec`; process trees  
- Virtual filesystems: `/proc`, `/sys`, `/dev`  
- Boot chain: firmware → bootloader → kernel → initrd → init (systemd)  
- Stage 1 / Stage 2 concepts (foreshadowing NixOS initrd evolution, e.g. systemd-in-initrd defaults on modern releases)

#### 0.2 systemd deeply enough to survive NixOS

- Units: service, socket, timer, target, mount, path  
- Lifecycle: start/stop/reload/restart; dependency ordering (`After=`, `Requires=`, `Wants=`)  
- journald; `systemctl status` / `journalctl -u`  
- cgroups v2 resource control; Linux namespaces (PID, mount, net, IPC, user, UTS)  
- Capabilities (`CAP_NET_BIND_SERVICE`, `CAP_SYS_ADMIN`, …)

#### 0.3 Filesystem Hierarchy Standard (FHS)

- `/bin`, `/lib`, `/usr`, `/etc`, `/var`, `/home`  
- Why shared mutable libraries and config directories create “DLL hell” / snowflake hosts  
- Contrast later with `/nix/store` and the `/etc` symlink farm on NixOS

#### 0.4 Storage mechanics

- Block devices, GPT/MBR, loop devices, mount points  
- Ext4, Btrfs (subvolumes, CoW, snapshots), ZFS (pools, datasets) at conceptual level  
- LVM, software RAID overview  
- LUKS encryption concepts; TPM2 unlock (later production modules deepen this)

#### 0.5 Security & access control

- POSIX permissions, ACLs, ownership  
- PAM basics  
- Capabilities vs setuid; least privilege  

#### 0.6 Networking & process tooling

- Addressing, routes, DNS, firewall primitives (iptables/nftables mental model)  
- Debugging tools: `ss`, `ip`, `lsns`, `lsof`, `strace` (light touch)

### Why It Matters in Production

Without Linux ground truth, NixOS module options look like magic. When activation fails, a service is sandboxed incorrectly, or networking is wrong, you diagnose **Linux**, not only Nix expressions.

### Labs

- **Lab 0.1:** Inspect cgroups and namespaces of a running process (`lsns`, cgroupfs)  
- **Lab 0.2:** Author a raw systemd unit; trace execution with `journalctl` / `systemctl`  
- **Lab 0.3:** Partition a disk, create filesystems, mount, recover from a deliberately broken fstab in a VM  

### Milestone 0

Build a minimal Linux VM (QEMU): partition disk, install a working userspace, run a custom systemd service, document boot and service failure recovery.

### Resources

- *The Linux Programming Interface* (Kerrisk) — selective chapters  
- systemd documentation (`systemd.unit`, `systemd.service`, `systemd.exec`)  
- Arch Wiki / distribution docs for storage and networking (tooling practice)

### Anti-patterns

- Treating “NixOS will abstract this away” as a reason to skip Linux  
- Memorizing unit syntax without understanding process and mount namespaces  

---

# TIER 1 — FOUNDATION (NCA)

*Outcome: unsupervised competence on a single system — language, store, daily Nix usage, one NixOS machine you can break and recover.*

---

## Module 1: Orientation — Philosophy, Architecture & Ecosystem

> **Level:** 100 | **Focus:** Paradigm shift & the three-layer mental model

### Learning Objectives

- Articulate imperative vs declarative vs purely functional package management  
- Separate cleanly: **Nix language**, **Nix package manager / store**, **NixOS**  
- Explain content-addressed store paths, derivations, generations, and hermetic builds  
- Map the 2026 ecosystem: Classic Nix, Determinate Nix, Lix; release cadence  

### Core Topics

#### 1.1 The problem Nix solves

- Dependency hell, version collisions, “works on my machine”  
- Snowflake servers; mutable global state  
- Non-reproducible builds; floating base images; configuration drift  

#### 1.2 The solution model

- Builds as pure functions of inputs → outputs  
- Declarative desired state vs imperative mutation sequences  
- Reproducibility as an operational property (same inputs → same store paths)

#### 1.3 The Nix store

- `/nix/store/<hash>-<name>-<version>`  
- Input-addressed paths vs content-addressed (CA) store evolution (preview)  
- Immutability of store paths; references and closures  
- Symlink farms and profiles as “live” views into the store  

#### 1.4 Derivations and the two-phase model

- Evaluation: Nix expression → `.drv`  
- Realization: `.drv` → output store path(s)  
- Builders, sandbox, fixed-output derivations (FOD) for network fetches  
- Trust model: signatures, substituters, binary caches (preview)

#### 1.5 Generations & atomicity

- User profiles and system profiles  
- Atomic switch; bootloader generation entries  
- Rollback as first-class ops, not disaster recovery theater  

#### 1.6 Three-layer mental model

| Layer | What it is | What it is not |
|---|---|---|
| Nix language | Lazy pure functional DSL | “Just JSON with functions” |
| Nix (pkg mgr + store) | Build engine + store | “Just another apt” |
| NixOS | Linux distro driven by the module system | “Linux + Nix packages” only |

#### 1.7 Ecosystem map (mid-2026)

- **Classic Nix** (NixOS Foundation)  
- **Determinate Nix** — Lazy Trees, parallel evaluation, FlakeHub, installer defaults  
- **Lix** — community fork; modernization and flake stabilization stance  
- **Tvix** (research) — Rust reimplementation (deeper in Level 800)  
- Release cadence: ~May/November stables (e.g. 26.05 “Yarara”, prior 25.11 “Xantusia”); ~7 months support  

### Why It Matters in Production

Incident narratives often end with: *“We rolled back to the previous generation.”* That guarantee is only trustworthy when store hashing, profiles, and activation are understood.

### Labs

- **Lab 1.1:** Trace store paths to `.drv` files; `nix-store -q --tree` / `nix path-info`  
- **Lab 1.2:** Compare official installer vs Determinate installer on a clean VM (defaults, daemon, uninstall)  
- **Lab 1.3:** Build the same package twice; inspect path identity and closure  

### Milestone 1

Write a 1–2 page “mental model” document for a new hire: store, derivations, evaluation vs realization, generations, and why secrets must never land in the store as plaintext.

### Resources

- [nix.dev](https://nix.dev)  
- [Zero to Nix](https://zero-to-nix.com)  
- Nix Pills 1–3  
- nixos.org blog/announcements; Determinate Systems blog ecosystem pieces  

### Anti-patterns

- Conflating “Nix” with “NixOS” or “flakes”  
- Treating rollbacks as a substitute for understanding what was activated  

---

## Module 2: The Nix Expression Language

> **Level:** 100–200 | **Focus:** Language fluency — highest leverage phase of the entire track

### Learning Objectives

- Read and write idiomatic Nix without template cargo-culting  
- Reason about lazy evaluation, thunks, and error locality  
- Use essential `builtins` and navigate `nixpkgs.lib`  
- Debug evaluation with `trace`, `seq`, `deepSeq`, and the REPL  

### Core Topics

#### 2.1 Types & literals

- Primitives: string, int, float, bool, path, `null`  
- Lists `[ ... ]`; attribute sets `{ a = 1; }`  
- Path literals vs strings; string context (store dependency tracking through strings)  
- Indented multi-line strings `'' ... ''`; interpolation `"${...}"`  

#### 2.2 Functions

- Single-argument functions; currying (`x: y: x + y`)  
- Attrset patterns `{ a, b ? default, ... }@args:`  
- `@`-bindings; default values; ellipsis for open sets  

#### 2.3 Scoping & composition

- `let ... in`; `inherit`; `rec` (and why large codebases often avoid `rec`)  
- `with` (and static analysis / scoping pollution costs)  
- `import`; multi-file composition patterns  
- Operators, conditionals, assertions  

#### 2.4 Laziness & evaluation dynamics

- Call-by-need; thunks  
- Infinite structures; why `let x = throw "boom"; in "hi"` is fine  
- Forcing evaluation: `builtins.seq`, `builtins.deepSeq`  
- Why errors often surface far from the root cause  

#### 2.5 Functional programming tools (Nix-shaped)

- Immutability, purity, higher-order functions  
- `map`, `filter`, `foldl'`, composition patterns  
- Fixed points (`lib.fix`) as groundwork for overlays and module system  
- Simplified Y combinator intuition (optional depth)  

#### 2.6 Standard libraries

**builtins (essential subset)**  
`toString`, `toJSON`/`fromJSON`, `readFile`/`readDir`, `map`, `filter`, `foldl'`, `attrNames`, `attrValues`, `hasAttr`, `elem`, `functionArgs`, `trace`, `seq`, `deepSeq`, `typeOf`, `isAttrs`, `isFunction`, …

**nixpkgs.lib (where real code lives)**  
- `lib.attrsets`: `mapAttrs`, `filterAttrs`, `recursiveUpdate`, `nameValuePair`  
- `lib.lists`: `flatten`, `unique`, `optional`, `optionals`  
- `lib.strings`: `concatStringsSep`, `splitString`, `hasPrefix`  
- Module combinators (preview): `mkIf`, `mkMerge`, `mkDefault`, `mkForce`, `mkOption`  

#### 2.7 Debugging & performance (language layer)

- `nix repl`, `nix eval`, `nix-instantiate`  
- Reading evaluation errors; common footguns  
- When evaluation is “slow” vs when builds are slow (separate later)

### Why It Matters in Production

Every module option, overlay, flake output, and package is functions + attrsets. Weak language skills produce fragile copy-paste infrastructure.

### Labs

- **Lab 2.1:** Nested attrset surgery in `nix repl`  
- **Lab 2.2:** Infinite list; take the 100th element without stack death  
- **Lab 2.3:** Force evaluation deliberately; observe trace output  
- **Lab 2.4:** Rewrite a messy nested config with `lib` helpers  

### Milestone 2

Implement a pure-Nix toy interpreter or template evaluator (arithmetic expressions or simple string templates) using only `builtins` + recursion — no packaging helpers.

### Resources

- [Nix Language — nix.dev](https://nix.dev/tutorials/nix-language)  
- Nix Pills 4–7  
- `nixpkgs/lib` source as living documentation  

### Anti-patterns

- Overusing `with pkgs;` in large files  
- Preferring `rec` and deep self-reference over `lib.fix` / explicit arguments  
- Debugging builds when the failure is pure evaluation  

---

## Module 3: Nix Package Manager, Store Engine & CLI

> **Level:** 200 | **Focus:** Daily operations, dual CLI, GC, daemon, consumer Nixpkgs

### Learning Objectives

- Operate Nix as a daily package manager and tool runner  
- Navigate legacy vs modern CLI with intent  
- Configure `nix.conf`, multi-user daemon, substituters, and GC safely  
- Use Nixpkgs as a consumer: search, pin, override lightly, dev shells  

### Core Topics

#### 3.1 Dual CLI landscape

| Legacy | Modern unified | Role |
|---|---|---|
| `nix-env` | `nix profile` | User profiles (prefer declarative) |
| `nix-build` | `nix build` | Realize derivations |
| `nix-shell` | `nix develop` / `nix shell` | Dev / ad-hoc envs |
| `nix-channel` | flake inputs / pins | Input locking |
| `nix-collect-garbage` | `nix store gc` / same family | GC |

**Professional guidance:** Avoid imperative `nix-env` for long-lived state — it reintroduces mutable profile drift.

#### 3.2 Installation models

- Single-user vs multi-user; `nix-daemon` socket activation  
- Official installer vs Determinate installer tradeoffs  
- macOS, Linux, WSL notes; uninstall cleanliness  

#### 3.3 Configuration (`nix.conf` / declarative NixOS options)

- `experimental-features = nix-command flakes`  
- `trusted-users`, `allowed-users`  
- `substituters`, `extra-substituters`, `trusted-public-keys`  
- `max-jobs`, `cores`, sandbox settings  
- Remote builders (preview for Tier 3)

#### 3.4 Profiles, generations, GC roots

- Direct and indirect GC roots; `/nix/var/nix/gcroots`  
- `result` symlinks as roots  
- `nix-collect-garbage -d` risks on multi-user and CI hosts  
- Store optimization / hardlinking (`nix-store --optimise`)  

#### 3.5 Nixpkgs as consumer

- [search.nixos.org](https://search.nixos.org); `nix search`  
- Attribute paths; top-level vs nested package sets  
- Pinning: channel branches vs flake lock vs `npins`/`niv`  
- Stable release vs `nixpkgs-unstable`  
- Light overrides: `override` vs `overrideAttrs` (when each applies)  

#### 3.6 Ad-hoc and project environments

- `nix run nixpkgs#tool`, `nix shell nixpkgs#a nixpkgs#b`  
- Legacy `shell.nix` / `mkShell`  
- Comparison with `mise`/`asdf` (when lightweight managers still win)

### Why It Matters in Production

Wrong GC policy deletes live roots or fills disks. CLI/installer choices become team architecture (CI, cache, docs). Reproducible shells are the highest immediate ROI of Nix independent of NixOS.

### Labs

- **Lab 3.1:** Ephemeral tool use with `nix shell` / `nix run`  
- **Lab 3.2:** Full GC cycle; inspect roots; optimize store  
- **Lab 3.3:** Pin nixpkgs two ways (channel + flake) and compare  
- **Lab 3.4:** Apply `overrideAttrs` to change a package version or patch  

### Milestone 3

Convert a real project toolchain (e.g. Go + kubectl + OpenTofu/Terraform) into a pinned, reproducible `nix develop` environment; document onboarding as one command.

### Resources

- Nix Reference Manual — CLI & configuration  
- nix.dev — ad-hoc envs / reproducible scripts  
- Determinate Systems — Classic Nix vs Determinate vs Lix comparisons  

### Anti-patterns

- Long-lived imperative profiles as “the” environment  
- Disabling the sandbox “to make builds work” without understanding purity loss  
- Running aggressive GC on shared build machines without root inventory  

---

## Module 4: Single-Machine NixOS System Administration

> **Level:** 400 | **Focus:** RHCSA-equivalent single host — install, configure, break, recover  
> **Tier 1 capstone module**

### Learning Objectives

- Install NixOS end-to-end and administer it declaratively  
- Use `nixos-rebuild` modes correctly under operational constraints  
- Configure users, networking, firewall, and systemd services the NixOS way  
- Recover from bad configs via generations and bootloader  

### Core Topics

#### 4.1 Installation lifecycle

- Minimal/graphical ISO; UEFI vs BIOS  
- Manual partitioning vs guided; `nixos-generate-config`, `nixos-install`  
- Disk layout choices: Ext4 vs Btrfs vs ZFS (depth in Disko module)  
- Bootloader: systemd-boot vs GRUB  

#### 4.2 Configuration anatomy

- `/etc/nixos/configuration.nix` — owned by you  
- `hardware-configuration.nix` — generated: modules, filesystems, initrd hooks  
- Imports pattern; splitting config early without flakes (prep for flakes)

#### 4.3 Rebuild operations (operational nuance)

| Command | Build | Activate now | Persist as default boot |
|---|---|---|---|
| `switch` | ✓ | ✓ | ✓ |
| `boot` | ✓ | | ✓ |
| `test` | ✓ | ✓ | |
| `dry-activate` | ✓ | simulate | |
| `build` | ✓ | | |

- Safer recovery narratives: boot prior generation → fix → `switch` vs blind `--rollback`  
- Generation listing and boot menu selection  

#### 4.4 Users, access, localization

- `users.users.<name>`, groups, SSH keys, sudo  
- Timezone, locale, console, keyboard  

#### 4.5 Networking & firewall

- `networking.hostName`, NetworkManager vs `systemd-networkd`  
- Static vs DHCP; wireless (iwd/wpa_supplicant)  
- `networking.firewall` / nftables; opening ports for services  
- SSH hardening basics  

#### 4.6 systemd the NixOS way

- `systemd.services.<name>` instead of hand-dropped unit files  
- Timers; journald; logrotate patterns  
- Declarative service enablement via modules (`services.nginx.enable`, etc.)

#### 4.7 Kernel, boot, sysctl

- `boot.kernelPackages`, kernel modules, sysctl  
- Initrd and stage concepts at admin level  

#### 4.8 Garbage collection for systems

- System profile generations vs store GC  
- Disk budgeting for `/nix/store`  
- Keeping N generations for safe rollback windows  

### Why It Matters in Production

This is where atomic upgrades become personal muscle memory: break a firewall rule, reboot, select previous generation, recover in minutes with a documented RTO.

### Labs

- **Lab 4.1:** Install NixOS in KVM/QEMU; SSH, static net, non-root user  
- **Lab 4.2:** Deploy Nginx + simple reverse proxy; open firewall correctly  
- **Lab 4.3:** Push a breaking change; recover via bootloader generation  
- **Lab 4.4:** Compare `test` vs `switch` operational risk  

### Milestone 4

Single NixOS VM with declarative users, networking, firewall, and ≥2 services (e.g. Nginx + PostgreSQL or Prometheus). Deliberately break and recover; document recovery time and procedure.

### Resources

- Official NixOS Manual  
- NixOS Wiki install/hardware pages  
- Practical 2025–2026 walkthroughs on immutable/production NixOS  

### Anti-patterns

- Editing `/etc` by hand and expecting persistence  
- Always using `switch` on remote machines without console/IPMI recovery plan  
- Zero generation retention on production hosts  

### ▶ NCA (Tier 1) Checkpoint

You can: explain store/derivation/generation; write real Nix without templates; run daily Nixpkgs tooling and devShells; install, configure, break, and recover a single NixOS host. **Unsupervised single-system competence.**

---

# TIER 2 — PROFESSIONAL (NCP)

*Outcome: independent delivery of non-trivial Nix/NixOS solutions — flakes, packaging, modules, portable environments, disks, secrets.*

---

## Module 5: Flakes — Modern Project Structure

> **Level:** 300 | **Focus:** Locked, composable, multi-output workspaces

### Learning Objectives

- Design flake-based projects with clear inputs/outputs and lock discipline  
- Structure multi-system packages, devShells, NixOS configs, checks, and formatters  
- Choose frameworks (`flake-parts` vs `flake-utils`) with eyes open  
- Hold an informed stance on the experimental-vs-de-facto flakes situation  

### Core Topics

#### 5.1 Flake anatomy

- `description`, `inputs`, `outputs`  
- Systems and `eachDefaultSystem` patterns  
- `flake.lock` contents; partial vs full updates  
- `nix flake show`, `nix flake check`, `nix flake metadata`

#### 5.2 Inputs

- URLs: `github:`, `git+ssh://`, `path:`, tarball, registries  
- `follows` for deduplicating nixpkgs across inputs  
- Input overrides; private git sources  

#### 5.3 Standard outputs schema

| Output | Purpose |
|---|---|
| `packages.<system>.<name>` | Buildable packages |
| `apps.<system>.<name>` | `nix run` entrypoints |
| `devShells.<system>.<name>` | `nix develop` |
| `nixosConfigurations.<host>` | System configs |
| `homeConfigurations.<user>` | Home Manager |
| `darwinConfigurations.<host>` | nix-darwin |
| `overlays.<name>` | Exported overlays |
| `checks.<system>.<name>` | CI via `nix flake check` |
| `formatter.<system>` | `nix fmt` |
| `templates` | `nix flake init` |

#### 5.4 Frameworks & modularization

- `flake-utils` — boilerplate reduction  
- `flake-parts` — module system for flakes (preferred for large repos)  
- Splitting outputs into modules/files without spaghetti  

#### 5.5 Ecosystem reality check (professional literacy)

- Flakes still “experimental” upstream; Nixpkgs internal non-use of flakes historically  
- Determinate Systems: treat flakes as stable + proprietary extensions  
- Lix: independent stabilization path  
- Alternatives still seen in production: `npins`, `niv`, channels  

#### 5.6 Team workflows

- Lockfile review as code review  
- Updating single inputs; security bumps  
- Templates for enterprise monorepos (preview of Capstone 4)

### Why It Matters in Production

Flakes (or equivalent locking) are the difference between “works on my laptop” and “works in CI, on the server, and for the next engineer in eight months.”

### Labs

- **Lab 5.1:** Multi-output flake: package + devShell + check  
- **Lab 5.2:** Deduplicate nixpkgs with `follows`  
- **Lab 5.3:** Refactor to `flake-parts`  
- **Lab 5.4:** Private input over SSH; document CI auth pattern  

### Milestone 5

Unify Phase 3 devShell + Phase 4 NixOS config into one flake with locked inputs, `follows`, and `nix flake check` green.

### Resources

- nix.dev Flakes concept pages  
- Zero to Nix — flakes  
- *NixOS & Flakes Book* (thiscute.world)  
- Determinate — flakes explainers (2025–2026)

### Anti-patterns

- Multiple nixpkgs instances without `follows` (eval bloat, version skew)  
- Committing secrets “because the flake is private”  
- Giant single-file `flake.nix` with no modular structure  

---

## Module 6: Hermetic Development Environments

> **Level:** 300 | **Focus:** Replacing “works on my machine” for polyglot teams

### Learning Objectives

- Build reliable `mkShell` / flake `devShells` for real projects  
- Integrate direnv / nix-direnv for automatic environment loading  
- Apply language-specific shell patterns (Python, Rust, Go, Node, C/C++)  
- Know editor integrations and FHS-compat escape hatches  

### Core Topics

#### 6.1 Shell construction

- `mkShell`, `mkShellNoCC`  
- `buildInputs` vs `nativeBuildInputs` in shells  
- `shellHook`, env vars, `LD_LIBRARY_PATH` / `PKG_CONFIG_PATH` discipline  
- Layered shells (base tooling + language + project)

#### 6.2 Automation & UX

- direnv + nix-direnv  
- devenv, lorri (landscape awareness)  
- VS Code / Neovim / JetBrains integration patterns  
- FHS user envs when proprietary tools demand FHS  

#### 6.3 Language ecosystems (dev side)

- Python: `python3.withPackages`, venv hooks, poetry/uv tooling  
- Rust: rust-overlay, crane-aware shells  
- Go: `buildGoModule` companion shells  
- Node: npm/pnpm/yarn lock-aware approaches  
- C/C++: compilers, cmake, pkg-config in shells  

#### 6.4 Monorepo shells

- Per-package shells vs umbrella shell  
- Caching evaluation; avoiding 30s direnv loads  

### Why It Matters in Production

Onboarding time collapses: clone, `direnv allow` / `nix develop`, identical tool versions. CI can reuse the same definitions.

### Labs

- **Lab 6.1:** Polyglot shell for a multi-language mini-repo  
- **Lab 6.2:** direnv integration with flake  
- **Lab 6.3:** Compare FHS env vs pure shell for a stubborn binary  

### Milestone 6A (dev)

Hermetic shell for a real multi-tool project used in daily work; teammate clone-and-run test.

### Resources

- nix.dev shell tutorials  
- Language-specific nixpkgs manual chapters  

### Anti-patterns

- Putting runtime production dependencies only in the shell  
- Unpinned tool versions in “reproducible” shells  
- 5-minute pure eval on every `cd` without caching strategy  

---

## Module 7: Home Manager & Cross-Platform Workstations

> **Level:** 500 | **Focus:** Declarative user environments on NixOS and macOS

### Learning Objectives

- Manage dotfiles, user packages, and program modules declaratively  
- Choose standalone vs NixOS-integrated Home Manager  
- Unify Linux + macOS via nix-darwin + Home Manager shared modules  

### Core Topics

#### 7.1 Architecture choices

- Standalone (`home-manager switch`)  
- NixOS module integration  
- nix-darwin for macOS system settings, launchd, Homebrew interop  

#### 7.2 Configuration surface

- `home.packages`  
- `programs.<name>.enable` (git, zsh/fish, neovim, ghostty/alacritty, starship, …)  
- `home.file`, `xdg.configFile`  
- `home.activation` scripts  
- `systemd.user.services`  

#### 7.3 Desktop-adjacent modules (professional awareness)

- Fonts, GTK/Qt, GNOME/KDE snippets  
- Wayland compositors (Hyprland, etc.) as optional depth — not core SRE track  
- Secrets at user level (ties to Module 11)

#### 7.4 Portability patterns

- Shared modules across hosts  
- Host-specific specializations  
- Bootstrap story: one command on a new machine  

### Why It Matters in Production

Developer workstations become reproducible infrastructure. New hires and replacement laptops stop being multi-day projects.

### Labs

- **Lab 7.1:** Declarative git + shell + editor  
- **Lab 7.2:** User systemd timer/service via HM  
- **Lab 7.3:** Shared module applied on NixOS VM and (optional) macOS  

### Milestone 7

Portable workstation flake: Home Manager (+ optional nix-darwin) with secrets-ready structure and bootstrap documentation.

### Resources

- Home Manager manual  
- nix-darwin docs  
- Public reference configs (study structure; do not copy blindly)

### Anti-patterns

- Duplicating entire configs per host instead of shared modules  
- Managing secrets as plaintext home files  
- Fighting HM modules by always using raw `home.file` for everything  

---

## Module 8: Derivations Deep Dive — Packaging Real Software

> **Level:** 200–600 | **Focus:** From consumer to producer of packages

### Learning Objectives

- Write correct `stdenv.mkDerivation` packages from source  
- Classify dependencies correctly for purity and cross  
- Package across major language ecosystems  
- Debug failed builds with professional tooling  

### Core Topics

#### 8.1 Anatomy of a derivation

- `.drv` structure; builder; environment; inputs; outputs  
- Dependency graph; runtime closure; store references  
- Fixed-output derivations; multi-output packages (`dev`, `lib`, `bin`, `doc`)  

#### 8.2 `stdenv.mkDerivation` phases

1. `unpackPhase`  
2. `patchPhase`  
3. `configurePhase`  
4. `buildPhase`  
5. `checkPhase` (`doCheck`)  
6. `installPhase`  
7. `fixupPhase` (strip, patchelf, wrap)

Phase hooks (`preBuild`, `postInstall`, …); overriding phases cleanly.

#### 8.3 Dependency classification

| Attribute | Meaning |
|---|---|
| `nativeBuildInputs` | Build platform tools (compilers, cmake, pkg-config) |
| `buildInputs` | Host platform libraries |
| `propagatedBuildInputs` | Downstream inheritance (use sparingly, knowingly) |

#### 8.4 Fetchers & hashing workflow

- `fetchurl`, `fetchFromGitHub`, `fetchgit`, `fetchpatch`, `fetchzip`  
- Hash mismatch iteration; `nix-prefetch-*` tools  
- Vendor hashes for language ecosystems  

#### 8.5 Language packaging

- **Go:** `buildGoModule` (`vendorHash`)  
- **Rust:** `buildRustPackage`, **crane**, naersk  
- **Python:** `buildPythonPackage`, poetry2nix, **uv2nix**  
- **Node:** `buildNpmPackage`, `pnpm.fetchDeps`  
- **C/C++:** autotools/cmake patterns  
- Awareness: Java, PHP, Ruby, Haskell, OCaml, Android, CUDA (specialization tracks)

#### 8.6 Binary repair & wrapping

- `patchelf`, interpreter paths, RPATH  
- `wrapProgram` / `makeWrapper`  
- `patchShebangs`  

#### 8.7 Meta & quality bar

- `meta`: description, license, maintainers, platforms, homepage  
- `nix flake check`; ofborg-minded quality  

#### 8.8 Debugging builds

- `nix log`, `--keep-failed`, `--show-trace`  
- Dropping into failed build directories  
- `nix-shell` / `nix develop` around a derivation  
- Common failure classes: missing deps, impure network, wrong phases  

### Why It Matters in Production

Internal CLIs, forks, and unpackaged tools appear constantly. Packaging is how platform teams remove “install from random binary” from the org.

### Labs

- **Lab 8.1:** Package a simple C program; inspect `$out` and ELF headers  
- **Lab 8.2:** Go module + Rust package (crane optional)  
- **Lab 8.3:** Force a failure; use `--keep-failed` and fix  
- **Lab 8.4:** Multi-output derivation  

### Milestone 8

Submit-quality package for software **without** an existing nixpkgs derivation: correct meta, builds, checks pass.

### Resources

- Nixpkgs Manual — languages & frameworks  
- nix.dev packaging series  
- Nix Pills (stdenv sections)  
- Real nixpkgs PR review comments  

### Anti-patterns

- Network access in non-FOD builds  
- `vendorHash = ""` permanently  
- Propagating dependencies to silence link errors without understanding  

---

## Module 9: Overlays, Package Sets & Extending Nixpkgs

> **Level:** 600 | **Focus:** Organizational package control without reckless forks

### Learning Objectives

- Use `callPackage` dependency injection idiomatically  
- Compose overlays safely (`final: prev:`)  
- Structure internal package sets / overlays repos  
- Navigate nixpkgs contribution workflow  

### Core Topics

#### 9.1 `callPackage`

- Automatic argument filling from package set  
- Explicit overrides at call sites  

#### 9.2 Overlays

- `final` (self) vs `prev` (super)  
- Composition order; infinite recursion pitfalls  
- Overlay vs `packageOverrides` historical notes  

#### 9.3 Override family

- `pkg.override` — change `callPackage` arguments  
- `pkg.overrideAttrs` — change derivation attributes  
- `lib.extend` / package set extension patterns  

#### 9.4 Repository structure

- `pkgs/by-name` conventions  
- Internal overlay monorepos  
- Version pinning of nixpkgs for enterprise patches  

#### 9.5 Upstream contribution

- PR conventions; commit titles (`pkgname: init at 1.0.0`)  
- ofborg / CI; `nixpkgs-review`  
- Review culture; maintainer responsibilities  

### Why It Matters in Production

Overlays let platform teams inject security patches or internal versions fleet-wide without waiting on upstream — or prepare clean upstream PRs when possible.

### Labs

- **Lab 9.1:** Overlay that patches or replaces a library  
- **Lab 9.2:** Internal package set composed with `callPackage`  
- **Lab 9.3:** Run `nixpkgs-review` on a local change  

### Milestone 9

Review-ready nixpkgs PR (new package, version bump, or fix) following `pkgs/by-name` and contribution docs — submit if possible.

### Resources

- Nixpkgs Manual — overriding & contributing  
- Mic92/nixpkgs-review  

### Anti-patterns

- Overlay that rewrites half of nixpkgs blindly  
- Forking nixpkgs for a one-line change  
- Override that “doesn’t apply” due to priority/evaluation order — fix with understanding, not more force  

---

## Module 10: The NixOS Module System (Authoring)

> **Level:** 500–600 | **Focus:** The abstraction engine of NixOS — typed options & merge semantics

### Learning Objectives

- Explain `lib.evalModules` merge behavior  
- Author reusable modules with typed options, assertions, and sane defaults  
- Apply priority combinators correctly under conflict  

### Core Topics

#### 10.1 Module anatomy

- `imports`, `options`, `config`  
- How hundreds of modules become one evaluated config  

#### 10.2 Options & types

- `lib.mkOption`, `mkEnableOption`  
- `types.bool`, `str`, `int`, `port`, `listOf`, `attrsOf`, `enum`, `submodule`, `nullOr`, `path`, `package`  
- Defaults, examples, descriptions as documentation  

#### 10.3 Merge & priority

| Combinator | Role |
|---|---|
| `mkIf` | Conditional config |
| `mkMerge` | Merge lists of config |
| `mkDefault` | Low-priority default (~1000) |
| `mkForce` | High-priority force (~50) |
| `mkOverride n` | Explicit priority |

- Conflict resolution; debugging “why didn’t my option stick?”  

#### 10.4 Validation UX

- `assertions` and `warnings`  
- Fail early with human-readable messages  

#### 10.5 Enterprise service module pattern

- `services.myApp.enable`, `.package`, `.port`, `.openFirewall`, `.user`, `.environmentFile`  
- Create system user, systemd unit with hardening defaults, firewall, state dirs  
- `specialArgs` / flake-passing patterns for injecting inputs  

#### 10.6 Testing modules

- `nixos-test` / NixOS VM tests (intro)  
- Evaluating modules outside full NixOS with `lib.evalModules`  

### Why It Matters in Production

Platform teams ship **interfaces**, not copy-pasted systemd blobs. Modules are the product surface for internal infrastructure.

### Labs

- **Lab 10.1:** `lib.evalModules` mini DSL outside NixOS  
- **Lab 10.2:** Nested `types.submodule` virtual hosts  
- **Lab 10.3:** Priority battle: default vs force vs user config  
- **Lab 10.4:** Assertions that catch invalid port/user combos  

### Milestone 10

Custom module `modules/services/internal-api.nix` provisioning a real toy HTTP service (Go/Python) with typed options, systemd hardening defaults, user, and firewall toggle.

### Resources

- Nixpkgs Manual — Writing NixOS Modules  
- `nixos/modules/services/**` exemplars  
- NixCon module system talks  

### Anti-patterns

- Untyped freeform attrsets for everything  
- Silent wrong merges without assertions  
- Putting secrets in option defaults  

---

## Module 11: Declarative Storage with Disko & Filesystem Strategy

> **Level:** 400–500 | **Focus:** Disks as code — prerequisite for zero-touch provisioning

### Learning Objectives

- Express partition tables, filesystems, and mounts in Nix via Disko  
- Design Btrfs/ZFS/LUKS layouts appropriate to workload  
- Understand impermanence / erase-your-darlings patterns  

### Core Topics

#### 11.1 Why Disko exists

- Manual `fdisk`/`mkfs`/`fstab` breaks automation  
- Pairing with nixos-anywhere for bare-metal/VPS installs  

#### 11.2 Disko schemas

- GPT/MBR; ESP; swap; root; data partitions  
- Filesystem options and mount flags  

#### 11.3 Filesystem architectures on NixOS

- **Ext4** — simple reliability  
- **Btrfs** — subvolumes (`@`, `@nix`, `@home`, `@log`), zstd, snapshots  
- **ZFS** — pools, datasets, ARC, native encryption, replication story  
- LVM thin pools; mdadm RAID via Disko  

#### 11.4 Encryption & trust

- LUKS; TPM2 unlock / Clevis patterns (deepen in security module)  
- Key management operational concerns  

#### 11.5 Impermanence

- Root on tmpfs; persist only declared paths  
- `impermanence` module patterns  
- State inventory: what is data vs what is config  

### Why It Matters in Production

Disk layout is often the last non-declarative step. Disko makes machines disposable and rebuildable.

### Labs

- **Lab 11.1:** GPT + ESP + Ext4 Disko on QEMU disk  
- **Lab 11.2:** Btrfs subvolume layout with compression  
- **Lab 11.3:** LUKS + Btrfs lab (password or keyfile)  

### Milestone 11

Production-shaped Disko spec: LUKS + Btrfs subvolumes + swap; tested on raw QEMU disk; documented recovery assumptions.

### Resources

- numtide/disko  
- nix-community/impermanence  

### Anti-patterns

- Encrypting without key escrow/recovery plan  
- Putting `/nix` on undersized partitions  
- Impermanence without a clear persistence allowlist  

---

## Module 12: Production Secrets Management

> **Level:** 500–600 | **Focus:** Never put secrets in the world-readable store

### Learning Objectives

- Explain why the store cannot hold plaintext secrets  
- Deploy **sops-nix** and **agenix** and choose appropriately  
- Inject secrets at runtime via tmpfs paths and systemd credentials  

### Core Topics

#### 12.1 The threat model

- `/nix/store` world-readable by design  
- Flake evaluation and NAR closures can leak secrets  
- git-crypt alone is insufficient for NixOS activation semantics  

#### 12.2 sops-nix

- SOPS + age/PGP; YAML/JSON workflows  
- Multi-key access matrices (`.sops.yaml`)  
- Decrypt to `/run/secrets` (tmpfs)  
- Templates; multi-host scaling  

#### 12.3 agenix

- Age + SSH host keys  
- One file per secret; `secrets.nix` access control  
- Simpler mental model for small fleets  

#### 12.4 Selection guidance (2026 practical)

| Situation | Lean toward |
|---|---|
| Few secrets, simple hosts | agenix |
| Many secrets, multi-team, structured files | sops-nix |
| Post-quantum key material | Track age PQ support + tool readiness |

#### 12.5 Runtime injection

- systemd `LoadCredential` / `SetCredential`  
- Ownership/mode of decrypted files  
- Remote deploy gotcha: root SSH agent / host key availability during switch  

#### 12.6 Operational practices

- Secret rotation; machine rekeying  
- CI access to encrypted secrets (limited decryption identities)  
- Never logging secret values in activation scripts  

### Why It Matters in Production

Without this, “production NixOS” is theater. API keys, TLS keys, DB passwords, and Wi-Fi credentials need a real design.

### Labs

- **Lab 12.1:** agenix secret decrypt on a VM  
- **Lab 12.2:** sops-nix multi-key matrix  
- **Lab 12.3:** Service consumes secret via `LoadCredential`  

### Milestone 12

Wire sops-nix or agenix into the Module 10 service so a real encrypted credential is used at runtime and never appears plaintext in the store.

### Resources

- NixOS Wiki — comparison of secret schemes  
- sops-nix, agenix READMEs  
- Discourse overview threads; recent 2026 comparison posts  

### Anti-patterns

- `builtins.readFile ./secret` in a flake  
- Committing age private keys  
- Decrypting secrets into `/nix/store` “temporarily”  

### ▶ NCP (Tier 2) Checkpoint

You can: structure flake workspaces; manage portable Home Manager environments; package software; write typed modules; automate disks with Disko; manage secrets correctly. **Independent professional delivery.**

---

# TIER 3 — EXPERT & ARCHITECT (NCE)

*Outcome: fleet-scale design, build infrastructure, hardened production systems, and evaluator-level debugging.*

---

## Module 13: Zero-Touch Provisioning & Fleet Orchestration

> **Level:** 600 | **Focus:** From one box to many — bare metal to parallel deploys

### Learning Objectives

- Provision remote machines with nixos-anywhere + Disko  
- Generate cloud/VM/ISO artifacts with nixos-generators  
- Orchestrate fleets with Colmena and/or deploy-rs  
- Design tag-based, rollback-safe deployment workflows  

### Core Topics

#### 13.1 Provisioning

- **nixos-anywhere:** kexec installer onto any Linux; remote NixOS install  
- Disko integration; secrets bootstrap chicken-and-egg  
- Hardware quirks; console access contingency  

#### 13.2 Image generation

- **nixos-generators:** AMI, Azure, GCE, Proxmox, qcow2, ISO, SD images  
- Single config → many artifacts  

#### 13.3 Deployment engines

| Tool | Character |
|---|---|
| `nixos-rebuild --target-host` | Fine for 1–2 hosts |
| **Colmena** | Parallel hive deploys, tags, local/remote eval |
| **deploy-rs** | Flake-native; magic rollback on health check failure |
| Morph / Nixus / lollypops / Bento | Landscape awareness |

- Evaluation locality: build on CI vs on target  
- Cross-arch: remote builders, `binfmt`, `pkgsCross`  

#### 13.4 GitOps pattern

- git push → CI build/check → cache push → Colmena/deploy-rs  
- Approval gates; progressive delivery (canaries via tags)

#### 13.5 Multi-node topology patterns

- Controller/worker; edge; bastion  
- Per-node specialization vs shared modules  
- Inventory as code  

### Why It Matters in Production

This is the SRE leap: disposable infrastructure, parallel deploys, and rollback as a practiced drill — not a hope.

### Labs

- **Lab 13.1:** nixos-anywhere convert Ubuntu VM → NixOS  
- **Lab 13.2:** nixos-generators qcow2 + cloud image  
- **Lab 13.3:** Colmena three-node hive with tags  
- **Lab 13.4:** Simulate failed activation; demonstrate rollback path  

### Milestone 13

Provision 2–3 NixOS nodes from zero (nixos-anywhere + Disko); deploy a change in parallel via Colmena/deploy-rs; prove rollback.

### Resources

- colmena, deploy-rs, nixos-anywhere, disko, nixos-generators docs  
- NixOS & Flakes Book — remote deployment chapters  

### Anti-patterns

- Serial SSH snowflake deploys as the long-term model  
- No health checks with deploy-rs/Colmena  
- Building world on every tiny laptop for multi-GB system closures  

---

## Module 14: CI/CD, Binary Caches & Build Farms

> **Level:** 700 | **Focus:** Build once, substitute everywhere

### Learning Objectives

- Operate substituters and signing keys correctly  
- Run self-hosted caches (Attic/Harmonia) or SaaS (Cachix)  
- Wire Nix into GitHub Actions, GitLab CI, Woodpecker, Gitea Actions  
- Understand Hydra’s role as the canonical build farm model  

### Core Topics

#### 14.1 Substitution mechanics

- How Nix decides to substitute vs build  
- Signatures; `trusted-public-keys`; priority of substituters  
- Cache.nixos.org trust defaults  

#### 14.2 Cache implementations

| Option | Fit |
|---|---|
| **Cachix** | Fast path for teams; SaaS |
| **Attic** | Self-hosted, S3/MinIO backend |
| **Harmonia** | Lightweight self-hosted |
| nix-serve | Legacy/simple |
| **Hydra** | Full jobsets, channels, org-scale |

#### 14.3 CI pipelines

- Stages: `nix flake check` → build packages/closures → push cache → deploy  
- `nix-eval-jobs` for parallel evaluation  
- Determinate Nix installer + magic-nix-cache patterns on GHA  
- Secrets for cache write credentials  

#### 14.4 Remote builders

- `nix.buildMachines`  
- Distributed builds; arch fan-out  
- Fairness and machine trust  

#### 14.5 Performance

- Evaluation cost vs build cost  
- Lazy Trees / parallel eval (ecosystem-dependent)  
- Avoiding rebuild storms; input hygiene  

### Why It Matters in Production

Without caches, fleets recompile the world. With caches + CI, NixOS ops becomes fast and centralized.

### Labs

- **Lab 14.1:** Stand up Attic (or Cachix) and push/pull a path  
- **Lab 14.2:** CI pipeline that checks + builds + pushes  
- **Lab 14.3:** Configure a remote builder  

### Milestone 14

Self-hosted or SaaS cache integrated with CI for your fleet flake; production nodes substitute successfully; document key management.

### Resources

- Cachix, Attic, Harmonia docs  
- Hydra manual (conceptual)  
- nix.dev CI tutorials (adapt to your forge)

### Anti-patterns

- Unsigned caches on untrusted networks  
- CI that builds but never pushes  
- Developers all building system closures locally with no shared cache  

---

## Module 15: Containers, MicroVMs & Cloud Artifacts

> **Level:** 700 | **Focus:** Where Nix meets OCI, nspawn, Firecracker, and K8s-adjacent tooling

### Learning Objectives

- Build reproducible OCI images with `dockerTools` without Dockerfiles when it pays off  
- Use NixOS containers and MicroVM.nix appropriately  
- Compare Nix artifacts honestly against Dockerfile/Helm workflows  

### Core Topics

#### 15.1 dockerTools

- `buildImage` vs `buildLayeredImage`  
- Layer caching strategy; distroless-like minimalism  
- Reproducibility and base-image drift avoidance  
- **Nixery** — on-demand images from nixpkgs  

#### 15.2 NixOS containers

- `containers.<name>` / systemd-nspawn  
- Network namespaces; host sharing  
- Comparison with LXD/Docker/Podman  

#### 15.3 MicroVM.nix

- Cloud-Hypervisor, QEMU, Firecracker backends  
- virtio-fs; tap networking; density use cases  

#### 15.4 Kubernetes & composition

- NixOS as k3s/K8s node  
- kubenix, Arion — when Nix-shaped K8s/Compose helps vs hurts  
- Helm/kustomize coexistence strategies  

#### 15.5 Decision framework

| Prefer Nix images when… | Prefer Dockerfiles when… |
|---|---|
| Bit-identical layers matter | Team fluency is Docker-only |
| Supply chain / SBOM from Nix graph | Existing mature Dockerfile pipeline |
| Same flake builds host + image | Marginal gain not worth training cost |

### Why It Matters in Production

Real infra is heterogeneous. Experts know **where** Nix-built artifacts win without religion.

### Labs

- **Lab 15.1:** Layered OCI image for a Go service; measure size  
- **Lab 15.2:** Declarative nspawn container  
- **Lab 15.3 (stretch):** MicroVM.nix single host multi-VM  

### Milestone 15

Same flake produces: OCI image, NixOS container definition, and (optional) cloud VM image via nixos-generators; compare size and rebuild behavior.

### Resources

- Nixpkgs `dockerTools`  
- microvm.nix; nixos-generators; Nixery  

### Anti-patterns

- Rewriting every Dockerfile at once  
- Giant fat images that defeat layer caching  
- Forgetting runtime config/secrets still need a story inside containers  

---

## Module 16: Security Hardening, Compliance, SBOM & DR

> **Level:** 700–800 | **Focus:** Making NixOS defensible in real audits

### Learning Objectives

- Harden services with systemd sandboxing and verify with `systemd-analyze security`  
- Implement Secure Boot (Lanzaboote) and disk encryption with TPM2 where appropriate  
- Generate SBOMs and scan for CVEs in closures  
- Write DR runbooks that distinguish config reproducibility from data  

### Core Topics

#### 16.1 Service hardening

- `DynamicUser`, `ProtectSystem`, `ProtectHome`, `NoNewPrivileges`, `PrivateTmp`  
- `CapabilityBoundingSet`, `SystemCallFilter`, `RestrictAddressFamilies`  
- How nixpkgs modules increasingly ship hardened defaults  

#### 16.2 Host immutability posture

- What is mutable: `/nix/var`, state dirs, persisted paths  
- Read-only root / impermanence  
- Activation scripts as controlled mutation  

#### 16.3 Boot & disk trust chain

- **Lanzaboote** Secure Boot  
- LUKS + TPM2  
- Measured boot awareness  

#### 16.4 MAC & sandboxing

- AppArmor; SELinux status in ecosystem  
- nixpak, bubblewrap for desktop/apps  

#### 16.5 Supply chain

- Reproducible builds as security property  
- SBOM: SPDX/CycloneDX; nix-sbom / FlakeBOM-class tooling  
- `vulnix`, grype on closures  
- Channel security backports vs unstable velocity  

#### 16.6 Compliance narratives

- CIS-inspired hardening  
- SOC2/HIPAA/GDPR *evidence* angles (logging, access, change control via git)  
- Zero trust network placement still required — NixOS is not a firewall substitute  

#### 16.7 Disaster recovery

- What flake + Disko + secrets system restore **does** give you  
- What it does **not**: databases, object storage, external SaaS state  
- RTO/RPO documentation; backup tools (Borg, Restic, ZFS snapshots) as Nix services  

### Why It Matters in Production

Security teams sign off on evidence and controls, not aesthetics. This module turns declarative Linux into audit-ready infrastructure.

### Labs

- **Lab 16.1:** Harden a service; score with `systemd-analyze security`  
- **Lab 16.2:** Generate SBOM for a flake output  
- **Lab 16.3:** CVE scan a system closure  
- **Lab 16.4:** Write and tabletop a DR runbook  

### Milestone 16

Hardening pass on fleet services + Lanzaboote/LUKS lab (or documented hardware limits) + SBOM/CVE step in CI + one-page DR runbook with RTO.

### Resources

- Lanzaboote; NixOS security chapters  
- Determinate supply-chain / FlakeBOM materials  
- nixpkgs security advisories  

### Anti-patterns

- Secure Boot without recovery keys  
- Claiming “immutable” while persisting everything ad hoc  
- SBOM generation without a vulnerability response process  

---

## Module 17: Observability, Networking Services & Production Stacks

> **Level:** 600–700 | **Focus:** Running real services declaratively

### Learning Objectives

- Deploy common production stacks as NixOS modules  
- Build observability (metrics, logs, traces) as code  
- Apply sane networking services (reverse proxy, VPN, DNS)  

### Core Topics

#### 17.1 Web & data

- Nginx, Caddy, Apache  
- PostgreSQL, MySQL/MariaDB, Redis  
- Object storage companions (MinIO)  

#### 17.2 Observability

- Prometheus + node exporter; Grafana; Loki; Tempo/Jaeger awareness  
- Alerting hooks  
- Journald shipping patterns  

#### 17.3 Networking services

- WireGuard / Tailscale modules  
- DNS (CoreDNS, unbound, bind)  
- HAProxy / load balancing patterns  
- NixOS as router (awareness)

#### 17.4 HA patterns (pragmatic)

- Active/passive with failover  
- DB clustering realities (what NixOS declares vs what operators still run)  
- Distributed storage landscape (Ceph, etc.) — know cost of complexity  

### Why It Matters in Production

Fleet tools without workloads are empty. This module grounds orchestration in services you actually page on.

### Labs

- **Lab 17.1:** Caddy/Nginx + TLS termination pattern (secrets from Module 12)  
- **Lab 17.2:** Prometheus + Grafana declarative stack  
- **Lab 17.3:** WireGuard mesh between lab nodes  

### Milestone 17

Observability + one HA-aware application path on the fleet from Module 13.

### Resources

- NixOS options search for each service  
- Vendor best practices adapted into modules  

---

## Module 18: Debugging, Performance & Anti-Patterns

> **Level:** 600–800 | **Focus:** Professional troubleshooting under pressure

### Learning Objectives

- Separate evaluation failures, build failures, and activation failures  
- Debug NixOS boot and service issues with Linux tooling  
- Optimize store, builds, and boot  
- Recognize and eliminate common anti-patterns  

### Core Topics

#### 18.1 Debugging Nix builds

- Log interpretation; phase isolation  
- `nix-instantiate` dry evaluation  
- Sandbox impurities; fixed-output issues  
- Diffing closures (`nix store diff-closures`)  

#### 18.2 Debugging NixOS

- Boot failures; emergency generation selection  
- `journalctl`, `systemctl`, activation script logs  
- Networking: `ip`, `ss`, nmtui  
- Storage: `lsblk`, `blkid`, mount storms  

#### 18.3 Performance

- Store optimization; parallel builds  
- Boot time: generations bloat, initrd size  
- Evaluation memory/time profiling (links to Module 19)  

#### 18.4 Anti-patterns catalog

- Imperative configuration drift  
- Secrets in store  
- Unbounded `with` / untyped modules  
- Channel/flake dual authority  
- Monolithic flake without checks  
- No cache in CI  
- Forever-growing store without GC policy  

### Why It Matters in Production

Experts are measured when systems fail at 2 a.m. This module is the incident-response curriculum.

### Labs

- **Lab 18.1:** Debug a failed package build end-to-end  
- **Lab 18.2:** Repair a non-booting VM via generation rollback  
- **Lab 18.3:** Profile and speed up a slow rebuild  
- **Lab 18.4:** Find and fix three anti-patterns in a messy sample repo  

### Milestone 18

“Break glass” runbook: evaluation failure, build failure, activation failure, boot failure — each with tools, signals, and recovery.

---

## Module 19: Advanced Internals, Evaluator & Ecosystem Research

> **Level:** 800 | **Focus:** Principal-engineer depth

### Learning Objectives

- Explain input-addressed vs content-addressed derivations and early cutoff  
- Profile and optimize pathological evaluation  
- Compare Classic Nix / Determinate / Lix / Tvix technical directions  
- Contribute meaningfully upstream and write internal RFCs  

### Core Topics

#### 19.1 Store & derivation evolution

- CA derivations; early cutoff; content-addressed paths  
- Dynamic derivations (awareness)  
- Incremental builds  

#### 19.2 Evaluator internals

- Parse → AST → evaluation → `.drv`  
- Thunk graphs; memory blowups  
- `nix-instantiate --trace-function-calls` and related profiling  
- Lazy Trees, parallel evaluation as industry responses  

#### 19.3 Cross-compilation depth

- `buildPlatform` / `hostPlatform` / `targetPlatform`  
- `pkgsCross.*`  
- Native remote builders vs QEMU binfmt  

#### 19.4 Overlay/module debugging at scale

- Why overrides “don’t apply”  
- Merge order archaeology  
- Monorepo evaluation strategies  

#### 19.5 Research & forks

- **Determinate Nix** roadmap items  
- **Lix** modernization goals  
- **Tvix** architecture (evaluator/store/builder split)  
- **NixBSD** and non-Linux experiments  

#### 19.6 Staying current

- Discourse; NixCon; nixpkgs PR pulse  
- Security mailing lists  
- Writing internal RFCs and ADRs  

### Why It Matters in Production

When eval hits 32 GB RAM or CI stalls on a monorepo, someone must treat Nix as an engineered system — not a black box.

### Labs

- **Lab 19.1:** Profile a heavy evaluation; identify hot functions  
- **Lab 19.2:** CA vs input-addressed experiment in a lab store  
- **Lab 19.3:** Cross-build a simple package for another arch  

### Milestone 19

Technical write-up or internal RFC: evaluate monorepo performance issues and propose mitigations (structure, tooling, cache, Nix distribution choice). Optional: merged nixpkgs contribution if not done in Module 9.

### Resources

- Tvix docs; Lix blog; Determinate engineering blog  
- NixCon internals talks  
- nixpkgs contribution guides  

---

## Module 20: Real-World Practice, Case Studies & Comparative Landscape

> **Level:** 700–800 | **Focus:** Judgment — when Nix is the right tool

### Learning Objectives

- Learn from published production adopters  
- Compare NixOS to adjacent paradigms honestly  
- Situate Nix in cloud-native, WASM, and AI/ML trajectories  

### Core Topics

#### 20.1 Case studies (study & critique)

- Tweag (Haskell/FP engineering culture)  
- IOHK / Cardano infrastructure narratives  
- Target and other large-org stories  
- Academic reproducible research environments  

#### 20.2 Comparisons

| Domain | Alternatives | Nix/NixOS angle |
|---|---|---|
| Immutable OS | Fedora Silverblue, Vanilla OS | Declarative whole-system eval + generations |
| Reproducible builds | Docker, Bazel | Store + language; different UX tradeoffs |
| Config management | Ansible, Puppet, Chef | Desired system closure vs converging scripts |
| Dev envs | asdf, mise, devcontainers | Hermetic closures vs shims |

#### 20.3 Community & contribution surfaces

- Discourse, Matrix, GitHub/GitLab  
- Wiki norms; conference/meetup culture  

#### 20.4 Futures awareness

- Cloud-native integration paths  
- WASM  
- AI/ML packaging (leads to optional GPU track)  

### Labs

- **Lab 20.1:** Replicate a simplified public production pattern (e.g. web service flake)  
- **Lab 20.2:** Written comparison: NixOS vs Silverblue for a given use case  
- **Lab 20.3:** Package contribution or issue triage on nixpkgs  

### Milestone 20

Architecture decision record: for a realistic org scenario, recommend adopt / hybrid / don’t-adopt with cost, risk, and staffing implications.

---

# MASTER CAPSTONE SUITE

Four portfolio-grade projects. Completing Capstones 1–3 is NCE-complete in spirit; Capstone 4 is principal-level.

```
┌────────────────────────────────────────────────────────────────────────────┐
│ CAPSTONE 1 — Workstation   │ Portable flake: NixOS + macOS + HM + secrets  │
│ CAPSTONE 2 — Application   │ Polyglot hermetic stack + CI + OCI + cache    │
│ CAPSTONE 3 — Infrastructure│ HA fleet: Disko + provision + Colmena + obs   │
│ CAPSTONE 4 — Architecture  │ Enterprise monorepo + modules + nixpkgs PR    │
└────────────────────────────────────────────────────────────────────────────┘
```

### Capstone 1: Ultimate Reproducible Developer Workstation

**Requirements**

1. Single flake for NixOS and/or macOS (nix-darwin)  
2. Home Manager: shell, terminal, editor, git  
3. direnv + nix-direnv  
4. Secrets via agenix or sops-nix  
5. Bootstrap path documented (`nix run .#bootstrap` or equivalent)  
6. README a new hire can follow without tribal knowledge  

### Capstone 2: Hermetic Polyglot Application Stack & CI

**Requirements**

1. Multi-service app (e.g. Go API, Rust worker, Node frontend, Postgres)  
2. Locked flake toolchains; submit-quality derivations where needed  
3. `dockerTools` images  
4. CI: check → build → push to Attic/Cachix  
5. Automated `checks` and basic tests  

### Capstone 3: High-Availability Production Fleet

**Requirements**

1. ≥3 nodes provisioned via nixos-anywhere + Disko (LUKS + sensible FS layout)  
2. Secure Boot (Lanzaboote) where hardware allows — otherwise document limitation  
3. sops-nix/agenix for runtime secrets  
4. Colmena or deploy-rs with tags and demonstrated rollback  
5. Observability stack (Prometheus/Grafana/Loki or equivalent)  
6. DR runbook with RTO/RPO  

### Capstone 4: Enterprise Monorepo & Upstream Contribution

**Requirements**

1. `flake-parts` monorepo structure for many hosts  
2. Custom typed modules with assertions and hardening  
3. SBOM + vulnerability scan in CI  
4. Full architecture diagram + onboarding + ops runbooks  
5. Real nixpkgs PR (merged or review-ready)  

### Unified Capstone Lab (classic single-project alternative)

If preferred as one mega-project: “Immutable Homelab/Cloud Cluster” combining Capstones 1–3 into one repository and presentation.

### Capstone ops gate (Grok requirement)

Regardless of which capstone path you choose, portfolio completeness for **NCE** also requires:

1. Lab fabric matching [Reference Lab Environment Blueprint](#reference-lab-environment-blueprint) (or a justified subset)  
2. Evidence from **≥5** `PROD-LAB-*` exercises (including at least one of 40–45 fleet/cache)  
3. **≥3** completed `INC-*` drills with postmortems  
4. **≥1** full `PROD-ARC-*` (A–E) with timestamps and a follow-up flake PR  

This is what separates “I read the modules” from “I can run NixOS in anger.”

---

# PRACTICAL WORKBOOK & LAB INDEX

Companion workbook target: **220–260+ labs** across six lab tiers (skill drills + production war games).

| Lab Tier | Title | ~Labs | Focus |
|---|---|---|---|
| **L1** | Fundamentals & Language | 40 | Installers, REPL, pure functions, thunks, store, ephemeral shells |
| **L2** | NixOS Administration | 50 | Install, networking, systemd, users, generations, recovery |
| **L3** | Packaging & Modules | 50 | stdenv, language builders, overlays, typed modules, assertions |
| **L4** | Fleet & Enterprise | 40 | Disko, secrets, nixos-anywhere, Colmena, Attic, dockerTools |
| **L5** | Failure, Recovery & Hardening | 25 | Intentional breakage, Secure Boot, sandbox audits, eval profiling |
| **L6** | Production War Games (Grok) | 30+ | Real-time SRE drills, incidents, capacity, multi-party ops |

### Lab design principles

- Exact commands + expected signals + failure signatures  
- “Break it on purpose” before “build it pretty”  
- Time-boxed ops drills (RTO targets)  
- Scenario labs with business context, not toy hostnames only  
- Postmortems required for L5–L6 (blameless, technical)  
- Community challenges (package something new for nixpkgs)

### Lab difficulty legend

| Tag | Meaning |
|---|---|
| `T` | Tutorial — guided, hard to fail |
| `S` | Skill drill — independent, single competency |
| `P` | Production scenario — multi-step, realistic constraints |
| `I` | Incident / war game — timed, partial information |
| `R` | Research / open-ended — no single correct answer |

---

# EXPERT PRODUCTION LAB CATALOG (GROK)

> **Author note:** These labs are *not* restated beginner tutorials. They encode failure modes, operational tradeoffs, and workflows that show up repeatedly when NixOS is run as real infrastructure: shared caches, multi-operator fleets, secret rotation, bad deploys at 02:00, full disks, and “eval ate the CI runner.”  
> Each lab lists **setup**, **task**, **success criteria**, **failure injects**, and **production notes**.

---

## P0 — Lab Environment Contract (do this once)

### PROD-LAB-00 — Disposable Lab Fabric

| Field | Spec |
|---|---|
| **Difficulty** | `S` |
| **Maps to** | Modules 0–4, 13 |
| **Time** | 2–4 h |

**Setup**

- Hypervisor host (or cloud account) with ≥32 GB RAM, ≥200 GB free disk  
- Nested virt enabled if building KVM labs inside a VM  
- Network: isolated lab VLAN or Tailscale/WireGuard lab tailnet  

**Task**

1. Create a lab inventory as code (even a simple `hosts.toml` / Nix attrset):
   - `bastion` (Ubuntu or NixOS) — jump host, never experimental  
   - `nix-builder` — multi-user Nix, big store, optional remote builder role  
   - `edge-01`, `app-01`, `app-02`, `db-01` — NixOS targets (can start as cloud images)  
   - `ci-runner` — Gitea Actions / Woodpecker / Forgejo runner  
2. Snapshot every machine *before* first destructive lab.  
3. Document console access path (VNC/serial/cloud console) for when SSH dies.

**Success criteria**

- From bastion: SSH to all nodes by inventory name  
- Each NixOS node has ≥50 GB on the filesystem holding `/nix`  
- Written “if I brick SSH” recovery path tested once  

**Production notes**

- Real fleets always need out-of-band console. Labs that only practice happy-path SSH create false confidence.  
- Separate **bastion** from **experiment** hosts the way you separate prod break-glass from app servers.

---

## P1 — Store, Evaluation & Daily Ops (production-shaped)

### PROD-LAB-01 — Closure Forensics: “Why is this 4 GB?”

| Field | Spec |
|---|---|
| **Difficulty** | `S`/`P` |
| **Maps to** | Modules 1, 3, 8 |
| **Time** | 60–90 min |

**Task**

1. Build a system or package: `nix build .#nixosConfigurations.edge-01.config.system.build.toplevel` (or a large package).  
2. Produce:
   - closure size (`nix path-info -Sh`)  
   - why-depends for the heaviest path (`nix why-depends`)  
   - a ranked list of top 15 store paths by size  
3. Remove or optionalize one dependency (docs, unused feature flag, `withDocs = false`, etc.) and re-measure.

**Success criteria**

- Before/after sizes documented with path evidence  
- You can explain *which reference* pulled the bloat into the closure  

**Failure inject**

- Instructor adds an accidental `buildInputs` vs `nativeBuildInputs` swap that pulls a compiler into runtime closure.

**Production notes**

- Closure bloat is a deploy-time and cache-cost problem. Platform teams that never measure closures pay in minutes per node and dollars per cache.

---

### PROD-LAB-02 — GC Roots Crime Scene

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 3 |
| **Time** | 45–75 min |

**Task**

On `nix-builder` with a dirty store:

1. Inventory GC roots (`nix-store --gc --print-roots` or modern equivalents).  
2. Identify: old `result` symlinks, abandoned profiles, CI leftovers, dangling roots.  
3. Write a **safe** GC policy:
   - What to delete automatically  
   - What never to delete without human review  
   - How many system generations to keep on servers vs laptops  
4. Run GC; prove a live profile still works.

**Success criteria**

- Disk reclaimed without breaking: current system generation, active user profile, running CI job’s roots  
- Policy one-pager suitable for an internal wiki  

**Failure inject**

- A `result` symlink in `/tmp` or a home directory is the only root for a critical path — learner must find it before GC.

**Production notes**

- CI runners that GC mid-build or delete shared roots cause “works locally, flaky in CI.” Treat GC as capacity management, not superstition.

---

### PROD-LAB-03 — Dual CLI Migration Under Team Constraint

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 3 |
| **Time** | 60 min |

**Scenario:** Half the team uses channels + `nix-env`; half uses flakes. Onboarding is chaos.

**Task**

1. Audit a simulated “legacy” user profile.  
2. Migrate packages to a flake `devShell` + optional `nix profile` declarative pin.  
3. Produce a team ADR: **channels frozen for servers, flakes for all new work** (or your justified alternative).

**Success criteria**

- One-command env for the project  
- ADR lists migration risks (CI, binary cache keys, docs)

---

### PROD-LAB-04 — Realtime: Eval Storm on a Shared Runner

| Field | Spec |
|---|---|
| **Difficulty** | `I` |
| **Maps to** | Modules 5, 14, 19 |
| **Time** | 90 min timed |

**Scenario:** CI runner OOM-kills during `nix flake check` after monorepo growth.

**Task (partial information)**

1. Reproduce high memory eval (large flake with many `nixosConfigurations` or heavy `import` graphs).  
2. Mitigations (implement ≥2):
   - Split checks / use `nix-eval-jobs`  
   - Deduplicate inputs with `follows`  
   - Lazy tree / parallel eval distribution (if available)  
   - Don’t evaluate every host on every PR (path filters, tags)  
3. Report peak RSS before/after.

**Success criteria**

- Stable CI green under memory cap you set (e.g. 8 GB cgroup)  
- Written decision: what still evaluates on every PR vs nightly  

**Production notes**

- Eval cost dominates large NixOS monorepos. Experts design **what not to evaluate**, not only what to build.

---

## P2 — Single Host Production Realism

### PROD-LAB-10 — Remote Switch Without Console Heroics

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 4 |
| **Time** | 75 min |

**Task**

1. From bastion, deploy a change to `edge-01` with a **safe** remote strategy:
   - Prefer `boot` + controlled reboot, or deploy-rs magic rollback, or `test` then verify then `switch`  
2. Deliberately push a config that breaks SSH (firewall or `sshd` misconfig) **only after** you have a recovery plan.  
3. Recover within target RTO (e.g. 15 minutes) via console/generation.

**Success criteria**

- Bad config recovered without disk reimage  
- Runbook step list with timestamps (simulate on-call notes)

**Production notes**

- Never `switch` a firewall/sshd change on a remote-only host without console or automatic rollback. This is the #1 NixOS self-own.

---

### PROD-LAB-11 — Generation Hygiene for Always-On Servers

| Field | Spec |
|---|---|
| **Difficulty** | `S`/`P` |
| **Maps to** | Module 4 |
| **Time** | 40 min |

**Task**

1. Create 10+ system generations with trivial changes.  
2. Configure generation retention (`boot.loader.systemd-boot.configurationLimit` or GRUB equivalent + nix GC settings).  
3. Prove: can still roll back N-2; disk no longer grows unbounded.

**Production notes**

- Unlimited generations fill ESP or `/boot` and brick upgrades. Cap generations; keep enough for a weekend of bad deploys.

---

### PROD-LAB-12 — “Immutable Root” Light: State Inventory

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 11, 16 |
| **Time** | 2 h |

**Task**

1. Run a normal app host for a day of simulated use (logs, postgres data dir, ssh host keys, lexe caches).  
2. Classify every path under `/var` and `/etc` as: **config (declarable)**, **secret**, **state/data**, **cache**, **trash**.  
3. Design a persistence allowlist for an impermanence-style setup (even if you only document it).  
4. Optional: implement tmpfs root + persist for `/var/lib/postgresql` and `/etc/ssh`.

**Success criteria**

- Written state inventory table  
- Rebuild machine from flake + restore **only** listed state; app works  

**Production notes**

- Impermanence without inventory is data loss with extra steps. Production teams start with inventory, not with `tmpfs` memes.

---

### PROD-LAB-13 — ZFS/Btrfs Snapshot + NixOS Upgrade Rehearsal

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 4, 11 |
| **Time** | 2–3 h |

**Task**

1. Disko layout with Btrfs or ZFS snapshots enabled.  
2. Snapshot before `nixos-rebuild`.  
3. Upgrade nixpkgs input (or simulated major jump).  
4. On failure: rollback generation **and** demonstrate dataset snapshot rollback for data dir.

**Success criteria**

- Two recovery layers documented: generation vs dataset  
- Clear statement of what each layer does *not* cover  

---

## P3 — Flakes, Modules, Packaging Under Org Constraints

### PROD-LAB-20 — Enterprise Flake Layout (multi-team)

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 5, 10, Capstone 4 |
| **Time** | 3 h |

**Scenario:** Platform team owns modules; app teams own service options; SRE owns host inventories.

**Task**

Structure a monorepo:

```text
flake.nix
modules/platform/     # hardening, logging, users baseline
modules/services/     # typed app modules
hosts/                # per-host configs only
lib/                  # pure functions, no side effects
overlays/
secrets/              # encrypted only
```

Rules:

- App teams cannot `mkForce` platform firewall without assertion/warning  
- Platform module sets defaults via `mkDefault`  
- Hosts only set hostname, roles, and service enablement  

**Success criteria**

- `nix flake check`  
- Two hosts share platform module; diverge only on role  
- CODEOWNERS (or equivalent) map for paths  

---

### PROD-LAB-21 — Internal Package + Overlay Pin Discipline

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 8–9 |
| **Time** | 2 h |

**Task**

1. Package an internal CLI (your script is fine).  
2. Expose via overlay; consume from NixOS module.  
3. Pin critical dependency versions intentionally; document upgrade procedure.  
4. Simulate CVE: bump dependency, rebuild only affected closure, push cache.

**Success criteria**

- Single input change path for security bumps  
- Cache hit rate measured on second host  

---

### PROD-LAB-22 — Module Contract Testing (NixOS VM tests)

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 10 |
| **Time** | 2–3 h |

**Task**

1. Write a NixOS VM test for your custom service module:
   - Service starts  
   - Port listens  
   - Health endpoint or simple probe  
2. Run under `nix flake check` / `nixosTest`.  
3. Add a negative test: invalid config fails evaluation via assertion.

**Success criteria**

- Green test in CI locally  
- Assertion fails with a human-readable message  

**Production notes**

- Untested modules are how fleets ship silent footguns. VM tests are the NixOS-native unit/integration layer.

---

### PROD-LAB-23 — Cross-Team Override Dispute

| Field | Spec |
|---|---|
| **Difficulty** | `I`/`R` |
| **Maps to** | Modules 9–10 |
| **Time** | 60 min |

**Scenario:** App team’s config “doesn’t apply”; they blame the module system.

**Task**

Given a broken flake (instructor-prepared or self-made) where `mkForce`/`mkDefault`/import order fight:

1. Find the winning definition with evaluation tooling.  
2. Fix with correct priority and documentation.  
3. Add assertion or warning to prevent recurrence.

---

## P4 — Secrets, Identity, Rotation (live production friction)

### PROD-LAB-30 — Secrets Bootstrap Chicken-and-Egg

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 12–13 |
| **Time** | 2 h |

**Scenario:** New bare metal has no host key yet; secrets need host key; install needs secrets.

**Task**

1. Document and execute a bootstrap:
   - Install with temporary password/console  
   - Enroll host age/SSH key into sops/agenix  
   - Re-deploy with real secrets  
2. Rotate a DB password end-to-end (encrypt → deploy → app reconnect).

**Success criteria**

- No plaintext secret in git or store (`nix path-info` / grep discipline)  
- Rotation runbook with dual-key grace period strategy  

---

### PROD-LAB-31 — Multi-Operator Secret Access Matrix

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 12 |
| **Time** | 90 min |

**Task**

With sops-nix:

1. Keys for: platform lead, on-call shared, CI bot (write-limited), each host.  
2. Rules: CI can decrypt only build-time secrets if any; runtime secrets host-only.  
3. Remove a departing human key; prove re-encryption works.

**Production notes**

- Secret systems fail at **people lifecycle**, not AES. Practice offboarding.

---

### PROD-LAB-32 — Realtime: Secret Decryption Failure Mid-Deploy

| Field | Spec |
|---|---|
| **Difficulty** | `I` |
| **Maps to** | Modules 12–13, 18 |
| **Time** | 45 min timed |

**Inject:** Wrong host key in `secrets.nix` / `.sops.yaml` after reprovision.

**Task**

1. Diagnose activation failure from logs.  
2. Recover service without re-imaging.  
3. Add a pre-deploy check that validates decrypt identity for target host.

---

## P5 — Fleet, GitOps, Caches (multi-node realtime)

### PROD-LAB-40 — nixos-anywhere Factory Line

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 13 |
| **Time** | 3 h |

**Task**

1. From one control machine, image **two** fresh Linux VMs into NixOS with Disko.  
2. Zero manual partitioning.  
3. Post-install: automatic join to monitoring + user baseline module.

**Success criteria**

- Second machine install time ≤ first (scripts/docs work)  
- Idempotent enough to re-run without panic  

---

### PROD-LAB-41 — Colmena Canary Pipeline

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 13–14 |
| **Time** | 2 h |

**Task**

1. Tags: `@canary`, `@prod`.  
2. Deploy risky change to canary only; synthetic health check.  
3. Promote to prod tags.  
4. On canary health fail: stop pipeline; rollback canary.

**Success criteria**

- Written progressive delivery notes  
- Prod untouched when canary fails (prove with config evidence)

---

### PROD-LAB-42 — deploy-rs Magic Rollback Proof

| Field | Spec |
|---|---|
| **Difficulty** | `P`/`I` |
| **Maps to** | Module 13 |
| **Time** | 90 min |

**Task**

1. Configure deploy-rs profile with activation success checks (e.g. curl health, systemctl is-active).  
2. Deploy a change that activates but fails health check.  
3. Prove automatic rollback; capture logs for postmortem.

---

### PROD-LAB-43 — Private Cache as a Product

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 14 |
| **Time** | 3–4 h |

**Task**

1. Stand up Attic (or Harmonia) + object storage (MinIO).  
2. Sign paths; configure trusted keys on fleet.  
3. CI pushes on main; developers and servers pull.  
4. Metrics: cache hit ratio on cold host vs warm host.  
5. Chaos: revoke signing key scenario (document emergency rebuild).

**Success criteria**

- Cold host deploy measurably faster with cache  
- Runbook for “cache down” (fail open to build vs fail closed)

**Production notes**

- Binary cache availability is now part of your production dependency graph. Budget SLO for the cache itself.

---

### PROD-LAB-44 — Realtime: Cache Poisoning / Trust Drill

| Field | Spec |
|---|---|
| **Difficulty** | `I`/`R` |
| **Maps to** | Modules 14, 16 |
| **Time** | 60 min |

**Task**

1. Discuss and simulate (in lab only) an untrusted substituter.  
2. Verify signature checking prevents unsigned paths.  
3. Document org policy: who may add substituters (`nix.conf` / NixOS options controlled by platform module only).

---

### PROD-LAB-45 — Multi-Arch Edge Node

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 13–15, 19 |
| **Time** | 3 h |

**Task**

1. Build aarch64 (or other foreign) system or package from x86_64 using remote builder **or** binfmt **or** pure cross.  
2. Deploy to edge-class VM if available.  
3. Compare wall time: cross vs remote native.

**Success criteria**

- Documented choice for the org’s edge strategy  

---

## P6 — Workloads, Data, Observability

### PROD-LAB-50 — Declarative App Stack with Migration Hook

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 10, 12, 17 |
| **Time** | 3 h |

**Task**

Deploy:

- App service (custom module)  
- PostgreSQL  
- Reverse proxy with TLS (internal CA or public ACME if network allows)  
- Secrets for DB URL  

Add:

- Oneshot systemd migration unit ordered before app  
- Backup unit (restic/borg) to MinIO  

**Success criteria**

- Destroy app container/service; redeploy; migrations safe  
- Restore DB from backup into fresh Postgres; app healthy  

---

### PROD-LAB-51 — Observability That Pages You

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 17 |
| **Time** | 2–3 h |

**Task**

1. Prometheus + node exporter + Grafana on fleet.  
2. Alert rules: disk `/nix` > 85%, unit failed, TLS expiry (if applicable).  
3. Trigger a real alert (fill disk safely in lab); walk the response using generation/GC runbooks.

**Success criteria**

- Alert → diagnose → remediate → postmortem notes  

---

### PROD-LAB-52 — Nix-Built OCI vs Dockerfile A/B

| Field | Spec |
|---|---|
| **Difficulty** | `P`/`R` |
| **Maps to** | Module 15 |
| **Time** | 2 h |

**Task**

1. Same app: Dockerfile image vs `dockerTools.buildLayeredImage`.  
2. Compare: image size, rebuild time with one-line code change, SBOM ease, CVE scan noise.  
3. ADR: where the org uses which.

---

### PROD-LAB-53 — MicroVM Density Experiment

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 15 |
| **Time** | 3 h |

**Task**

1. Host runs N MicroVMs (start with 3) via microvm.nix.  
2. Measure boot time, memory overhead, network isolation.  
3. Kill host NIC path; observe failure domains.

**Production notes**

- MicroVMs shine for strong isolation with near-container density; they are not free. Measure before promising density in design docs.

---

## P7 — Security, Compliance, Supply Chain (auditor-facing)

### PROD-LAB-60 — systemd-analyze Score Climb

| Field | Spec |
|---|---|
| **Difficulty** | `S`/`P` |
| **Maps to** | Module 16 |
| **Time** | 90 min |

**Task**

1. Score an unhardened service.  
2. Apply sandboxing until score improves materially without breaking function.  
3. Document each capability you *kept* and why.

---

### PROD-LAB-61 — SBOM + CVE Gate in CI

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 14, 16 |
| **Time** | 2 h |

**Task**

1. Generate SBOM for app closure.  
2. Scan with vulnix/grype.  
3. Policy: fail CI on CRITICAL with exceptions file reviewed weekly.  
4. Intentionally introduce a known old package; prove gate fails.

---

### PROD-LAB-62 — Secure Boot + LUKS Lab (hardware-dependent)

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 16 |
| **Time** | 3–5 h |

**Task**

1. Lanzaboote enrollment in VM if supported, or document exact gap.  
2. LUKS with recovery key escrow procedure (password manager / paper / HSM story).  
3. Tabletop: lost TPM, still boot with recovery.

**Success criteria**

- Recovery key tested once (lab)  
- Written escrow owners  

---

### PROD-LAB-63 — Compliance Evidence Pack

| Field | Spec |
|---|---|
| **Difficulty** | `R` |
| **Maps to** | Modules 16, 20 |
| **Time** | 2 h |

**Task**

Produce an evidence pack an auditor could sample:

- Change control = git history + PR reviews for flake  
- Access control = declared users + SSO/bastion notes  
- Vulnerability process = CI scan logs  
- DR test = last restore timestamp  

No roleplay fluff — real artifacts from your lab.

---

## P8 — Expert Internals & Platform Engineering

### PROD-LAB-70 — Why-Depends Driven Slimming Sprint

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 8, 19 |
| **Time** | 2 h |

**Task**

Take a bloated system closure; cut ≥15% size **or** ≥20% build time with evidence. No cheating by deleting required features without documentation.

---

### PROD-LAB-71 — Overlay Composition Torture Test

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 9 |
| **Time** | 90 min |

**Task**

Stack 3 overlays from different “teams.” Introduce an infinite recursion; fix. Introduce override that silently doesn’t apply; fix with tests.

---

### PROD-LAB-72 — Remote Builder Mesh

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Module 14 |
| **Time** | 2–3 h |

**Task**

1. Laptop/CI offloads builds to `nix-builder`.  
2. SSH trust / Nix store signing correctly configured.  
3. Demonstrate big package build without cooking the laptop.

---

### PROD-LAB-73 — nixpkgs Contribution Under Review Pressure

| Field | Spec |
|---|---|
| **Difficulty** | `P` |
| **Maps to** | Modules 8–9, 19 |
| **Time** | 1–2 days wall |

**Task**

1. Real PR: package init, version bump, or fix.  
2. Use `nixpkgs-review`.  
3. Respond to review comments professionally.  
4. Record lessons for internal packaging standards.

---

## P9 — Full-Stack Production Scenarios (multi-lab arcs)

### PROD-ARC-A — “Friday Deploy”

**Duration:** 4–6 h continuous  
**Roles (solo or pair):** Deployer, Reviewer  

1. Feature module change + secret + canary deploy  
2. Metrics green  
3. Prod promote  
4. Inject failure at promote; rollback  
5. Postmortem within 30 minutes  

### PROD-ARC-B — “Disk Full at 2am”

**Duration:** 90 min timed `I`  

1. `/nix` fills during build  
2. Emergency GC without killing current generation  
3. Resize story or relocating store (document-only if not practical)  
4. Alerting gap analysis  

### PROD-ARC-C — “nixpkgs Security Advisory Day”

**Duration:** 3 h  

1. Identify affected package in your closure (simulated advisory list)  
2. Bump/overlay pin  
3. Rebuild, push cache, staged fleet deploy  
4. Communicate blast radius to “app teams”  

### PROD-ARC-D — “New Region Bring-Up”

**Duration:** 1 day  

1. New VLAN/VPC inventory  
2. Image or nixos-anywhere bootstrap  
3. Cache endpoint reachability  
4. Latency-aware deploy (eval local vs remote)  
5. DR: lose region A, restore services in region B from flake + backups  

### PROD-ARC-E — “Platform Product Launch”

**Duration:** multi-day  

Ship an internal platform module as a product:

- Versioned interface (`services.companyX`)  
- Docs + examples  
- CI tests  
- Deprecation policy for options  
- Office-hours FAQ from real failure injects  

---

# LIVE OPS DRILLS & INCIDENT SIMULATIONS

Timed drills. Use a stopwatch. Partial information is intentional.

| ID | Incident title | Max time | Inject | Expected competencies |
|---|---|---|---|---|
| INC-01 | SSH locked out after firewall change | 15m | `networking.firewall` dropped port 22 | Generation boot, console, safe remote patterns |
| INC-02 | Activation failed: secret decrypt | 20m | Wrong age key | sops/agenix diagnostics, host rekey |
| INC-03 | Deploy succeeded, app 502 | 25m | Bad proxy upstream | journalctl, module config, rollback decision |
| INC-04 | CI red: hash mismatch | 20m | Upstream tarball changed | FOD, prefetch, pin strategy |
| INC-05 | Eval OOM on PR | 30m | Monorepo explosion | eval split, follows, CI design |
| INC-06 | Binary cache 403/timeout | 20m | Stop Attic | fail-open policy, local build budget |
| INC-07 | Boot loop after kernel bump | 25m | Bad kernel module | previous generation, pin kernel |
| INC-08 | Store corruption suspicion | 30m | Bit-flip simulation / bad copy | `nix-store --verify`, repair, rebuild |
| INC-09 | Time skew breaks TLS/ACME | 20m | Fake NTP fail | chrony/systemd-timesyncd, cert renew |
| INC-10 | Emergency CVE on shared lib | 40m | Overlay force rebuild | mass rebuild, staged rollout |
| INC-11 | Disk full mid-switch | 20m | Fill `/nix` | abort, GC, capacity |
| INC-12 | Split-brain Colmena tags | 25m | Wrong tag selector | inventory discipline, dry-run |
| INC-13 | Impermenance wiped state | 30m | Missing persist path | restore backup, fix allowlist |
| INC-14 | Cross-host secret leakage test | 30m | Secret in world-readable store path | prove absence; fix module |
| INC-15 | On-call handoff drill | 45m | Half-finished deploy | communication, freeze/rollback |

### Incident response template (required write-up)

```markdown
## Incident
- ID / start / end / severity
## Impact
- Users, hosts, data
## Timeline
- Detection → mitigation → resolution
## Technical root cause
- Eval / build / activate / runtime / human process
## Nix-specific factors
- Generation, closure, cache, secrets, module merge
## Action items
- Prevent / detect / recover improvements
```

### On-call game rules

- No reimaging unless RTO exceeded and documented  
- Prefer rollback first, fix forward second (unless security requires forward)  
- Every drill ends with one platform improvement PR to the lab flake  

---

# REFERENCE LAB ENVIRONMENT BLUEPRINT

### Topology (recommended)

```text
                         ┌──────────────┐
                         │  operator    │
                         │  laptop      │
                         └──────┬───────┘
                                │ VPN/tailnet
                         ┌──────▼───────┐
                         │   bastion    │
                         └──────┬───────┘
              ┌─────────────────┼─────────────────┐
              │                 │                 │
       ┌──────▼──────┐   ┌──────▼──────┐   ┌──────▼──────┐
       │ nix-builder │   │  ci-runner  │   │    attic    │
       │  + big /nix │   │             │   │  + minio    │
       └──────┬──────┘   └─────────────┘   └─────────────┘
              │
     ┌────────┼────────┬─────────┐
     │        │        │         │
 ┌───▼──┐ ┌───▼──┐ ┌───▼──┐ ┌───▼──┐
 │edge-01│ │app-01│ │app-02│ │db-01 │
 └───┬───┘ └───┬──┘ └───┬──┘ └───┬──┘
     │         │        │        │
     └─────────┴────┬───┴────────┘
                    │
              observability
            (prom/grafana/loki)
```

### Sizing guide

| Node | vCPU | RAM | Disk | Notes |
|---|---|---|---|---|
| bastion | 2 | 2 GB | 20 GB | Stable, snapshots |
| nix-builder | 8 | 16–32 GB | 200+ GB | Remote builder, heavy eval |
| ci-runner | 4 | 8–16 GB | 100 GB | Ephemeral workdirs |
| attic+minio | 2 | 4 GB | 100+ GB | Cache + objects |
| app/edge | 2 | 2–4 GB | 40–80 GB | ≥50 GB for Nix if possible |
| db-01 | 2 | 4 GB | 60 GB | Separate data disk ideal |

### Network & identity

- Unique SSH host keys; enrolled into agenix/sops  
- Deploy user with explicit sudo/NOPASSWD only if you accept that risk in lab  
- Prefer `deploy-rs`/`colmena` with least privilege  
- Optional: Tailscale ACLs mimicking prod prod/nonprod split  

### Snapshot & reset protocol

1. Golden snapshot: OS installed, SSH works, empty flake applied  
2. After each L6/incident: reset to golden **or** commit repairs back into flake (prefer the latter for learning)  
3. Weekly: destroy one node and rebuild from flake + backups (DR muscle memory)

### Tooling pinned in the lab flake itself

The lab fabric should be described by a flake:

- `devShells.ops` — colmena, deploy-rs, sops, age, jq, ssh helpers  
- `nixosConfigurations.*` — all lab hosts  
- `checks.*` — eval + VM tests for platform modules  
- `apps.bootstrap` — documented entrypoint  

**Dogfood rule:** if you manage lab hosts imperatively “just this once,” open an incident against yourself.

---

# ASSESSMENT & CERTIFICATION-STYLE CHECKPOINTS

| Gate | Evidence |
|---|---|
| **NCA** | Mental model doc; pure-Nix milestone; devShell project; NixOS break/recover write-up; **INC-01 drill** |
| **NCP** | Multi-output flake; HM workstation; custom package; custom module; Disko + secrets; **PROD-LAB-20 + PROD-LAB-30** |
| **NCE** | Fleet provision + deploy + rollback; CI + binary cache; hardened services; SBOM/CVE; **≥3 incidents from INC table**; **one PROD-ARC** |
| **Portfolio** | Capstones 1–3 (minimum) with public or private-but-reviewable git history |
| **Staff+/Principal signal** | Capstone 4 + PROD-ARC-E + nixpkgs PR + internal RFC (Module 19) |

### Suggested rubric dimensions

- Correctness of evaluation and activation  
- Purity and reproducibility (lockfiles, FODs, no secret leakage)  
- Operational safety (rollback, GC, remote deploy)  
- Code quality (modules typed, assertions, structure)  
- Documentation (runbooks, onboarding, ADRs)  
- **Incident performance** (RTO, communication, blameless technical depth)  
- **Measurable improvement** (closure size, cache hit, eval memory)  

### Practical exam formats

| Format | Duration | Use |
|---|---|---|
| Open-book lab exam | 3–4 h | NCA/NCP gates |
| Sealed incident bag | 60–90 m | NCE on-call readiness |
| Design + defend ADR | 90 m | Architecture judgment |
| Pair deploy review | 60 m | Team norms, CODEOWNERS |

---

# OPTIONAL SPECIALIZATION TRACKS

Attach after Tier 2 without blocking the main spine.

### Track S1 — Desktop & Creative Workstation

- Wayland compositors (Hyprland, Sway), PipeWire, GPU drivers  
- Flatpak/nixpak coexistence  
- Gaming (Steam, Proton) realities on NixOS  
- **Labs:** dual-boot risk drill; GPU driver rollback generation; HM-only vs NixOS desktop split  

### Track S2 — GPU, CUDA & AI/ML Infrastructure

- Nixpkgs CUDA/ROCm packaging patterns  
- Reproducible ML environments; caching large artifacts  
- GPU passthrough to MicroVMs/containers  
- **Labs:** CUDA closure size control; model cache outside store; multi-user GPU node scheduling honesty  

### Track S3 — Edge, ARM & Embedded

- Raspberry Pi / aarch64 images via nixos-generators  
- Cross vs native builders  
- IoT gateway patterns; read-only devices  
- **Labs:** SD image flip without brick; A/B generation mindset on small disks; offline/airgap substituter  

### Track S4 — Advanced Networking & Homelab ISP

- NixOS router; BGP awareness; policy routing  
- Full mesh VPN designs  
- **Labs:** break DNS on purpose; policy route canary; firewall change with automatic rollback  

### Track S5 — Research Implementations

- Tvix components; alternative evaluators  
- NixBSD experiments  
- **Labs:** compare eval traces Classic vs Lix/Determinate if available; document behavioral deltas  

### Track S6 — Platform Engineering as a Product (Grok)

- Internal module versioning & deprecation  
- Self-service golden paths (`nix flake init` templates)  
- SLOs for eval time, cache hit ratio, deploy duration  
- **Labs:** PROD-ARC-E; developer satisfaction interview; break-glass admin path  

---

# APPENDIX A — Canonical Resource Library (2026)

### Official

- [nix.dev](https://nix.dev)  
- [Nix Manual](https://nixos.org/manual/nix/stable/)  
- [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)  
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)  
- [search.nixos.org](https://search.nixos.org)  
- [wiki.nixos.org](https://wiki.nixos.org)  
- [discourse.nixos.org](https://discourse.nixos.org)  

### Guided / books

- [Zero to Nix](https://zero-to-nix.com)  
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)  
- Nix Pills  

### Tooling (actively maintained landscape)

| Domain | Tools |
|---|---|
| Structure | flake-parts, flake-utils |
| User env | home-manager, nix-darwin |
| Disks / install | disko, nixos-anywhere, nixos-generators |
| Deploy | colmena, deploy-rs |
| Secrets | sops-nix, agenix |
| Cache | cachix, attic, harmonia, hydra |
| Packaging | crane, uv2nix, poetry2nix, … |
| Security | lanzaboote, impermanence |
| Isolation | microvm.nix, dockerTools |

### Voices to track

- Determinate Systems engineering blog  
- Lix project announcements  
- NixCon talk archives  
- nixpkgs PR/issue traffic  

### Expert production reading (practice-oriented)

- NixOS Wiki: comparison of secret managing schemes  
- Colmena / deploy-rs / nixos-anywhere operational READMEs (re-read before every prod design)  
- Discourse threads on remote deploy SSH agent / root gotchas  
- Blog posts on impermanence, lanzaboote, Attic at scale — verify dates; prefer 2024–2026  

---

# APPENDIX B — Scope Boundaries & Deliberate Exclusions

Primary curriculum excludes deep dives into:

1. **NixOps as primary deploy tool** — historically important; superseded in practice by Colmena/deploy-rs  
2. **Desktop ricing as core path** — available as Track S1; not required for NCE  
3. **Deep GPU/CUDA** — Track S2  
4. **Non-Nix config management mastery** — comparisons only  
5. **General Kubernetes admin (CKA-equivalent)** — only Nix-touchpoints unless you expand Track  

These exclusions keep the spine production-clear while optional tracks remain available.

---

# APPENDIX C — Ecosystem Map (mid-2026)

```
                    ┌─────────────────────┐
                    │   Nix language +    │
                    │   evaluator/store   │
                    └─────────┬───────────┘
           ┌──────────────────┼──────────────────┐
           ▼                  ▼                  ▼
    Classic Nix         Determinate Nix          Lix
    (Foundation)        (Lazy Trees,             (community fork,
                         FlakeHub, …)             modernization)
           │                  │                  │
           └──────────────────┼──────────────────┘
                              ▼
                         Nixpkgs (packages)
                              ▼
                    ┌─────────────────────┐
                    │  NixOS modules +    │
                    │  system activation  │
                    └─────────┬───────────┘
                              ▼
              Home Manager / nix-darwin / flakes tooling
                              ▼
         disko · sops/agenix · colmena · attic · lanzaboote · …
```

**Release habit:** track stable NixOS releases (~6 months) and security backports separately from `nixpkgs-unstable` velocity.

---

# APPENDIX D — Suggested Study Cadence

### 8-month part-time sketch

| Months | Focus |
|---|---|
| 0–1 | Part 0 + Modules 1–3 (language + CLI + store) + PROD-LAB-00–03 |
| 2 | Module 4 NixOS single host → **NCA** + INC-01 |
| 3 | Modules 5–7 flakes, shells, Home Manager + PROD-LAB-20 light |
| 4 | Modules 8–10 packaging, overlays, modules + PROD-LAB-21–22 |
| 5 | Modules 11–12 Disko + secrets → **NCP** + PROD-LAB-30–32 |
| 6 | Modules 13–15 fleet, CI/cache, containers + PROD-LAB-40–45 |
| 7 | Modules 16–18 hardening, services, debugging + INC-02–11 |
| 8 | Module 19–20 + Capstones + **≥1 PROD-ARC** → **NCE portfolio** |

### Front-load warning

Phases covering **language + mental model** are the steepest. Do not rush Modules 2–3; every later module becomes easier when they stick.

### Weekly production rhythm (recommended after NCP)

| Day | Habit |
|---|---|
| Mon | `nix flake update` in lab; read closure diff |
| Wed | One INC drill (rotate table) |
| Fri | Canary deploy of a real change; optional promote |
| Monthly | Full node rebuild from flake + backup restore |

---

# APPENDIX E — Production Patterns Cheat Sheet (Expert)

Condensed patterns that show up in healthy NixOS orgs. Use as a grading lens for labs.

### Evaluation & structure

- **One nixpkgs per flake graph** via `follows` — no accidental multi-version eval  
- **Hosts are thin; modules are thick** — hosts select roles, modules implement  
- **Assertions over tribal knowledge** — invalid configs fail at eval  
- **Checks on every PR** — at least `nix flake check` subset that fits RAM  

### Deploy & rollback

- **Console before cleverness** on network/SSH changes  
- **Canary tags before prod tags**  
- **Health-checked deploys** (deploy-rs or external probes)  
- **Generation limit on servers** to protect `/boot`  

### Secrets

- **Encrypt at rest in git; decrypt to tmpfs/credentials**  
- **Host identity enrollment is a runbook**, not a hope  
- **Rotate people keys as seriously as app secrets**  

### Capacity

- **Budget `/nix` like a database disk**  
- **GC policy with roots inventory**  
- **Cache SLO** — treat Attic/Cachix as prod dependency  

### Security

- **Sandbox services by default; document exceptions**  
- **SBOM + CVE gate with exception expiry dates**  
- **Pin and bump intentionally; record who owns the pin**  

### Social / platform

- **CODEOWNERS for `modules/platform`**  
- **Deprecation windows for module options**  
- **Every incident ends in a flake PR**  

### Anti-patterns (instant lab fail if intentional)

- Plaintext secrets in store  
- `nix-env` as long-term prod config  
- Untagged fleet-wide deploy of untested change  
- Disabling sandbox “to fix the build” permanently  
- No GC roots story on CI runners  

---

## Closing

This syllabus is a **spine plus a war-game layer**: progressive modules, production rationale, milestones, and an expert lab catalog that forces real operational skills — remote recovery, secrets lifecycle, cache dependence, canary deploys, closure forensics, and timed incidents.

It synthesizes community and professional outlines, then adds **Grok expert production labs (PROD-LAB-*, PROD-ARC-*, INC-*)**, a **reference lab fabric**, and a **production patterns cheat sheet** suitable for running an internal academy or self-paced mastery path.

**Recommended next deliverables**

1. Workbook L1 (Modules 0–3) with exact lab scripts for QEMU/LXD  
2. Instructor “failure inject packs” for INC-01–INC-15 (broken flakes + expected diagnoses)  
3. Reference solution flakes for Milestones 3–5 and PROD-LAB-20 (hidden if used as a course)  
4. Assessment rubrics scoring incident RTO + postmortem quality  
5. Automated lab reset tooling (`apps.reset-lab` in the fabric flake)

---

*Document: `syllabus-grok.md` — comprehensive expert expansion + production lab catalog for the Nix/NixOS professional track (July 2026).*
