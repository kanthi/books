# Mastering Nix & NixOS: From Zero to Enterprise Production Architecture

### A Comprehensive, Certification-Grade Curriculum (Nix Fundamentals → NixOS System Administration → Fleet/Production Engineering → Enterprise Systems Architecture)

*Unified and expanded in July 2026 from official documentation (`nix.dev`, NixOS Manuals), `zero-to-nix`, the NixOS & Flakes Book, NixOS Discourse, Determinate Systems engineering publications, Lix releases, NixCon proceedings, and current production SRE best practices.*

---

## 0. Curriculum Architecture & Executive Summary

### Paradigm Shift & Vision
Transitioning from traditional, imperative Linux administration (e.g., RHEL, Ubuntu, Debian, Arch) to the purely functional, declarative paradigm of Nix and NixOS requires a fundamental shift in mindset. Traditional systems rely on mutable state changes in global directories (`/usr/lib`, `/etc`, `/var`), leading to dependency hell, "snowflake" servers, and non-reproducible deployments. Nix treats software compilation and operating system configuration as **pure, lazy, side-effect-free mathematical functions**.

This syllabus is the definitive, single-source-of-truth curriculum designed to bridge the gap between initial curiosity and enterprise-scale production engineering. It synthesizes theoretical computer science principles (lazy evaluation, content-addressing, fixed points) with hard-nosed production operations (fleet management, secret injection, binary caching, kernel hardening, and zero-touch bare-metal provisioning).

### Professional Certification Alignment
Structured in the spirit of enterprise certification tracks (such as Red Hat's **RHCSA → RHCE → RHCA**, or Linux Foundation's **LFCS → LFCE → CKA**), this curriculum defines three formal competency tiers and eight progressive learning levels:

| Tier | Informal Designation | Target Level | Industry Benchmark Equivalent | Core Outcome & Competency Bar |
|---|---|---|---|---|
| **Tier 1 — Foundation** | **NCA** (Nix Certified Associate) | Levels 100–200 | RHCSA / LFCS | Fluent in the Nix expression language, store mechanics, devShells, and single-machine NixOS administration. |
| **Tier 2 — Professional** | **NCP** (Nix Certified Professional) | Levels 300–500 | RHCE / LFCE / CKA | Able to package polyglot software, write custom typed NixOS modules, structure Flakes workspaces, manage user environments with Home Manager, and encrypt runtime secrets. |
| **Tier 3 — Expert & Architect** | **NCE** (Nix Certified Expert) | Levels 600–800 | RHCA / Senior SRE / Principal Architect | Capable of orchestrating distributed server fleets, operating private binary cache build farms, hardening systems to security compliance standards, generating SBOMs, and debugging evaluator internals. |

### Enterprise Competency Matrix (Levels 100–800)

```
Level 100: Foundations, Architecture & Language Semantics
 │
Level 200: Package Management, Store Engine & Standard Library (Nixpkgs)
 │
Level 300: Modern Workspaces, Nix Flakes & Developer Environments
 │
Level 400: NixOS System Administration, Storage (Disko) & OS Core Engine
 │
Level 500: Advanced NixOS Module System, Home Manager & Secrets Management
 │
Level 600: Distributed Infrastructure, Zero-Touch Provisioning & Fleet Orchestration
 │
Level 700: Enterprise CI/CD, Binary Caches, Containers & Security Compliance
 │
Level 800: Custom Derivations, Cross-Compilation, Evaluator Internals & Research
```

---

## TIER 1 — FOUNDATION (NCA)

---

## Module 0: Linux Architecture & Operating System Foundations

> **Level:** 000 | **Focus:** Core Linux Mechanics Prerequisite

### 1. Learning Objectives
- Master the fundamental Linux subsystems required to understand NixOS abstractions.
- Articulate how standard Linux distributions manage state, processes, networking, and storage versus NixOS's declarative model.

### 2. Core Topics
- **Linux Kernel vs. Userspace:** System calls, process creation (`fork`/`exec`), virtual file systems (`/proc`, `/sys`, `/dev`).
- **Init Systems & systemd:** Target units, service lifecycle, socket activation, journald logging, cgroups v2 resource control, and Linux namespaces (PID, mount, net, IPC, user, UTS).
- **Filesystem Hierarchy Standard (FHS):** Traditional layout (`/bin`, `/lib`, `/etc`, `/usr`) and why it creates mutable state collisions.
- **Storage Mechanics:** Block devices, partition tables (GPT/MBR), loop devices, mount points, and file system basics (Ext4, Btrfs, ZFS).
- **Security & Access Control:** POSIX file permissions, ACLs, PAM (Pluggable Authentication Modules), and capabilities (`CAP_NET_BIND_SERVICE`, `CAP_SYS_ADMIN`).

### 3. Why It Matters in Production
Without a clear grasp of standard Linux internals, NixOS abstractions look like magic. When systemd units fail or network namespaces misbehave, an engineer must diagnose the underlying Linux kernel reality, not just the Nix code.

### 4. Milestone Project / Practical Labs
- **Lab 0.1:** Manually inspect Linux cgroups and mount namespaces of a running process using `lsns` and `cgroupfs`.
- **Lab 0.2:** Write a raw systemd unit file from scratch and trace its execution through `journalctl` and `systemctl`.
- **Milestone 0:** Build a minimal Linux VM using QEMU, format disk partitions, and manually install a working userspace.

### 5. Curated 2026 Resources
- *The Linux Programming Interface* (Michael Kerrisk)
- systemd documentation (`systemd.direct`)

---

## Module 1: Orientation, Philosophy & Architecture of Nix

> **Level:** 100 | **Focus:** Paradigm Shift & Architectural Triad

### 1. Learning Objectives
- Articulate the operational differences between *imperative* package managers (`apt`, `dnf`, `pacman`, `brew`) and Nix's *purely functional, content-addressed* model.
- Deconstruct the three-layer mental model: **The Nix Language**, **The Nix Package Manager/Store**, and **NixOS**.
- Understand ecosystem dynamics: Classic Nix vs. **Determinate Nix** (Determinate Systems downstream distribution, parallel evaluation, Lazy Trees, FlakeHub) vs. **Lix** (community fork focusing on incremental C++ modernization and flake stabilization).
- Understand the NixOS release cadence: **NixOS 26.05 "Yarara"** (introducing systemd in Stage 1 initrd by default) vs. prior stable releases (**25.11 "Xantusia"**).

### 2. Core Topics
- **The Problem:** Dependency hell, DLL collision, "works on my machine", mutable global state, and snowflake servers.
- **The Solution:** Purely functional package management. Software builds modeled as mathematical functions without side effects.
- **The Nix Store (`/nix/store`):** Cryptographic hashes (`/nix/store/<hash>-<name>-<version>`), input-addressed paths vs. content-addressed storage (CA Store).
- **Derivations (`.drv`):** The unit of build instruction. Separating *evaluation phase* (Nix code → `.drv` file) from *realization/build phase* (`.drv` file → output store path).
- **Generations & Atomic Operations:** Transactional upgrades and instant zero-downtime rollbacks.
- **Hermetic Build Sandbox:** Isolating builds from network, un-declared local files, and host environment variables.

### 3. Why It Matters in Production
Every incident response narrative on NixOS concludes: *"We rolled back to the previous generation in 2 seconds."* Understanding the store path hashing scheme makes this operational guarantee transparent and trustworthy.

### 4. Milestone Project / Practical Labs
- **Lab 1.1:** Inspect the `/nix/store` directory structure and trace output paths back to their `.drv` files using `nix-store -q --tree`.
- **Lab 1.2:** Benchmark installation of Nix on a fresh Linux VM using the official installer script versus the Determinate Nix installer.
- **Milestone 1:** Write a 2-page architectural "mental model" document explaining content-addressing, store paths, and atomic generations to an onboarding DevOps team.

### 5. Curated 2026 Resources
- [nix.dev](https://nix.dev) — Official Nix documentation portal.
- [Zero to Nix](https://zero-to-nix.com) — Guided path by Determinate Systems.
- *Nix Pills* (Pills 1–3) — Historical deep-dive on store mechanics.

---

## Module 2: The Nix Expression Language & Functional Mechanics

> **Level:** 100–200 | **Focus:** Language Fluency & Functional Concepts

### 1. Learning Objectives
- Read and write idiomatic Nix expressions fluently without relying on copy-pasting.
- Understand lazy evaluation semantics, thunks, call-by-need, and how to debug infinite recursion loops.
- Master the `builtins` functions and `nixpkgs.lib` standard library.

### 2. Core Topics
- **Data Types:** Primitives (strings, integers, floats, booleans, paths, `null`), Collections (Lists `[ ... ]`, Attribute Sets `{ a = 1; b = 2; }`).
- **String Manipulation:** Indented multiline strings (`''...''`), string interpolation (`"${var}"`), string context (tracking store path dependencies through strings), path coercion.
- **Functions:** Single argument, curried functions (`x: y: x + y`), attribute set destructuring (`{ a, b, ... }@args:`), default values, `@` bindings.
- **Scoping & Bindings:** `let ... in` expressions, `inherit` statements, `rec` attrsets (and why `rec` is an anti-pattern in large codebases), `with` statements (and why `with` causes static analysis pollution).
- **Control Flow & Recursion:** `if ... then ... else`, recursive function definitions, fixed points (`lib.fix`).
- **Lazy Evaluation Dynamics:** Thunks, call-by-need, evaluation vs. execution, avoiding eager evaluation traps with `builtins.seq` and `builtins.deepSeq`.
- **The Standard Libraries:**
  - `builtins`: `readFile`, `readDir`, `fromJSON`, `toJSON`, `elem`, `filter`, `map`, `foldl'`, `trace`.
  - `nixpkgs.lib`: `lib.attrsets` (`mapAttrs`, `filterAttrs`, `recursiveUpdate`), `lib.lists` (`flatten`, `unique`), `lib.strings` (`concatStringsSep`, `splitString`), logic combinators (`lib.mkIf`, `lib.mkMerge`, `lib.mkDefault`, `lib.mkForce`).

### 3. Why It Matters in Production
Every NixOS module, flake output, and package derivation is composed entirely of Nix functions and attribute sets. Rushing language basics leads to cargo-culting configuration snippets that break under complex evaluation logic.

### 4. Milestone Project / Practical Labs
- **Lab 2.1:** Write pure Nix functions to manipulate complex nested attribute sets using `nix repl`.
- **Lab 2.2:** Demonstrate lazy evaluation by constructing an infinite list in Nix and retrieving the 100th element without crashing the evaluator.
- **Milestone 2:** Author a standalone arithmetic and text template evaluator written purely in Nix using only `builtins` and recursion, containing zero external dependencies.

### 5. Curated 2026 Resources
- [Nix Language Tutorial — nix.dev](https://nix.dev/tutorials/nix-language)
- *Nix Pills* (Pills 4–7: Functions, Laziness, & Attrsets)

---

## Module 3: Nix Package Manager, Store Engine & CLI Mechanics

> **Level:** 200 | **Focus:** Package Management & Dual-CLI Mechanics

### 1. Learning Objectives
- Operate the Nix package manager as a daily driver for searching, installing, and managing software.
- Master the CLI transition: Legacy commands (`nix-env`, `nix-build`, `nix-shell`, `nix-channel`) vs. Modern unified CLI (`nix build`, `nix develop`, `nix run`, `nix profile`, `nix search`).
- Configure garbage collection (GC) and store optimization safely without destroying required dependencies.

### 2. Core Topics
- **The Dual-CLI Landscape:**
  - *Legacy:* `nix-env` (and why it introduces imperative state anti-patterns), `nix-build` (producing `result` symlinks), `nix-shell` (ephemeral dev environments), `nix-channel` (tracking nixpkgs release branches).
  - *Modern Unified CLI:* `nix search nixpkgs <query>`, `nix run nixpkgs#tool`, `nix shell nixpkgs#tool`, `nix develop`, `nix profile`.
- **Configuration (`nix.conf`):** `experimental-features = nix-command flakes`, `trusted-users`, `substituters`, `trusted-public-keys`, `max-jobs`, `cores`.
- **Nix Daemon Architecture:** Single-user vs. Multi-user installations, socket activation, `/nix/var/nix/daemon-socket/socket`.
- **Garbage Collection & GC Roots:** `/nix/var/nix/gcroots`, indirect GC roots, `nix-collect-garbage -d`, `nix-store --gc`, store optimization (`nix-store --optimise` / hardlinking identical store paths).
- **Nix vs. Pragmatic Alternatives:** Understanding Nix's hermetic isolation model compared to lightweight tool managers like `mise` or `asdf`.

### 3. Why It Matters in Production
Improperly configured garbage collection in CI or production servers can delete active build dependencies or leave disk partitions at 100% usage. Managing GC roots is a mandatory operational skill.

### 4. Milestone Project / Practical Labs
- **Lab 3.1:** Create ad-hoc ephemeral dev environments using `nix shell` and `nix-shell` to execute version-pinned CLIs without root privileges.
- **Lab 3.2:** Perform a full garbage collection run, inspect GC roots, and optimize store disk space using `nix-store --optimise`.
- **Milestone 3:** Write a shell script that audits a multi-user machine, identifies imperative `nix-env` profiles, and migrates those packages to declarative devShells.

### 5. Curated 2026 Resources
- Nix Manual — Command Line Reference
- *Determinate Systems Blog* — "Understanding the Differences Between Classic Nix, Determinate Nix, and Lix"

---

## Module 4: Single-Machine NixOS System Administration

> **Level:** 400 | **Focus:** Single-Node Operating System Management

### 1. Learning Objectives
- Declaratively install, configure, and administer a single NixOS machine.
- Navigate `/etc/nixos/configuration.nix` and `hardware-configuration.nix`.
- Master rebuild strategies and generation rollbacks.

### 2. Core Topics
- **Installation Lifecycle:** Booting NixOS ISO, manual disk formatting, `nixos-generate-config`, `nixos-install`.
- **Core Configuration Files:**
  - `configuration.nix`: Main declarative system specification.
  - `hardware-configuration.nix`: Auto-generated kernel modules, file system mounts, and CPU flags.
- **Rebuild Operations (`nixos-rebuild`):**
  - `switch`: Build, activate immediately, and set as default boot generation.
  - `boot`: Build and set as default boot generation without changing running state.
  - `test`: Build and activate immediately, but do not add to boot menu.
  - `dry-activate`: Build and simulate activation steps to preview changes.
- **Systemd Integration:** Declarative system services (`systemd.services.<name>`), socket units, timers (`systemd.timers.<name>`), and journald logging.
- **User & Access Management:** Declarative user accounts (`users.users.<name>`), groups, SSH authorized keys, and sudoer permissions.
- **Networking & Firewall:** `networking.hostName`, `systemd-networkd` vs. `NetworkManager`, declarative nftables/iptables (`networking.firewall`), sysctl kernel parameters.
- **Bootloader & Generations:** `boot.loader.systemd-boot.enable` vs. GRUB, kernel package selection (`boot.kernelPackages`), switching generations at GRUB/systemd-boot menu.
- **Rollback Best Practices:** Why booting directly into a prior generation and executing `switch-to-configuration boot` is safer than `nixos-rebuild --rollback`.

### 3. Why It Matters in Production
NixOS replaces manual configuration editing in `/etc` with a central compiled specification. System administrators gain total auditability and zero-risk OS upgrades.

### 4. Milestone Project / Practical Labs
- **Lab 4.1:** Install NixOS inside a QEMU/KVM VM, configure custom static networking, users, and an SSH daemon.
- **Lab 4.2:** Push a breaking configuration change (e.g., misconfigured firewall or broken service), reboot the system, and recover via systemd-boot menu generation rollback.
- **Milestone 4:** Stand up a standalone NixOS server running Nginx, PostgreSQL, and Prometheus, fully declared within a single `configuration.nix` file.

### 5. Curated 2026 Resources
- *NixOS Official Manual* (nixos.org/manual/nixos)
- "Mastering NixOS: Immutable Linux in Production" (2026 Walkthrough)

---

### ▶ Tier 1 (NCA) Checkpoint & Competency Bar
At this milestone, the candidate can fluently write Nix language expressions, manage store paths and devShells, install and configure single NixOS hosts, and recover from broken OS states using atomic rollbacks.

---

## TIER 2 — PROFESSIONAL (NCP)

---

## Module 5: Modern Workspaces, Nix Flakes & Flake Architectures

> **Level:** 300 | **Focus:** Reproducible Flake Ecosystem & Project Layout

### 1. Learning Objectives
- Design composable, pinned, and shareable Nix projects using Flakes.
- Understand flake locking mechanics (`flake.lock`) and input resolution rules.
- Evaluate flake framework choices (`flake-parts` vs. `flake-utils`).

### 2. Core Topics
- **Flake Anatomy (`flake.nix`):** `description`, `inputs` (dependencies), and `outputs` (produced artifacts).
- **Flake Inputs & Locking:**
  - Input schemas: `github:owner/repo`, `git+ssh://...`, `path:./subfolder`.
  - Input overrides (`inputs.nixpkgs.follows = "nixpkgs"` to prevent duplicate nixpkgs instances).
  - Updating locks: `nix flake update`, `nix flake lock --update-input nixpkgs`.
- **Standard Flake Outputs Schema:**
  - `packages.<system>.<name>`: Package derivations.
  - `devShells.<system>.<name>`: Project dev environments (`nix develop`).
  - `nixosConfigurations.<hostname>`: System configurations (`nixos-rebuild switch --flake .#hostname`).
  - `homeConfigurations.<username>`: User dotfile configurations.
  - `overlays.<name>`: Exported package overrides.
  - `checks.<system>.<name>`: Automated test suites executed via `nix flake check`.
  - `formatter.<system>`: Code formatters (`nix fmt`).
- **Flake Frameworks:** Modularizing complex repositories with `flake-parts` (module system for flakes) vs. legacy `flake-utils`.
- **Flake Alternatives & Pinning Utilities:** `npins` and `niv` (for non-flake or flake-agnostic workflows).

### 3. Why It Matters in Production
Flakes guarantee bit-for-bit build reproducibility across time, team members, CI runners, and production servers by eliminating reliance on implicit system channels (`NIX_PATH`).

### 4. Milestone Project / Practical Labs
- **Lab 5.1:** Author a `flake.nix` for a polyglot application providing `packages`, `devShells`, and `checks`.
- **Lab 5.2:** Refactor a monolithic `flake.nix` into modular files using `flake-parts`.
- **Milestone 5:** Combine a project's devShell, custom package derivation, and NixOS system configuration into a single multi-output flake repository with locked inputs.

### 5. Curated 2026 Resources
- [nix.dev Flakes Concept Guide](https://nix.dev/concepts/flakes)
- *NixOS & Flakes Book* (thiscute.world)

---

## Module 6: Declarative User Environments with Home Manager & nix-darwin

> **Level:** 500 | **Focus:** User-Space Declarative Management & Cross-Platform Synergy

### 1. Learning Objectives
- Declaratively manage user home directories, dotfiles, and user-level packages across Linux and macOS.
- Compare standalone Home Manager deployments with NixOS module integration.
- Leverage `nix-darwin` to unify macOS workstations with NixOS server configurations.

### 2. Core Topics
- **Home Manager Architecture:**
  - *Standalone:* Installed into user profile (`home-manager switch`).
  - *NixOS Module:* Integrated into system rebuild (`home-manager.nixosModules.home-manager`).
- **Configuration Structure (`home.nix`):**
  - `home.packages`: User-level software binaries.
  - `programs.<name>.enable`: High-level service and program modules (e.g., `programs.git`, `programs.neovim`, `programs.zsh`, `programs.ghostty`).
  - `home.file` & `xdg.configFile`: Direct declarative file symlinking into `$HOME` and `$XDG_CONFIG_HOME`.
  - `home.activation`: Custom activation scripts executed during environment switching.
- **Cross-Platform Workstation Synergy:**
  - Combining `nix-darwin` (macOS system settings, brew integration, launchd services) with Home Manager.
  - Sharing identical shell configurations, aliases, and editor configs across macOS daily drivers and NixOS lab VMs.

### 3. Why It Matters in Production
Developer onboarding time drops to zero: a new employee clones the dotfile flake, runs one activation command, and receives an identical, fully configured shell, editor, and toolchain on macOS or Linux.

### 4. Milestone Project / Practical Labs
- **Lab 6.1:** Author a `home.nix` module configuring Git, Zsh, Neovim, and Starship prompt declaratively.
- **Lab 6.2:** Configure user-level systemd user services via Home Manager (`systemd.user.services`).
- **Milestone 6:** Create a unified flake managing dotfiles for macOS (`nix-darwin` + Home Manager) and NixOS servers using shared module files.

### 5. Curated 2026 Resources
- Home Manager Official Manual (nix-community/home-manager)
- nix-darwin GitHub Documentation

---

## Module 7: Derivation Construction, Packaging & Nixpkgs Engine

> **Level:** 200–600 | **Focus:** Packaging Software from Source & Derivation Lifecycles

### 1. Learning Objectives
- Write correct, production-grade derivations for software built from source.
- Master `stdenv.mkDerivation` phases, hooks, and build environments.
- Package applications across major language ecosystems (Go, Rust, Python, Node.js).

### 2. Core Topics
- **Anatomy of `stdenv.mkDerivation` Phase Lifecycle:**
  1. `unpackPhase`: Extracting tarballs/sources (`src = fetchFromGitHub { ... }`).
  2. `patchPhase`: Applying custom patch files (`patches = [ ./fix-build.patch ]`).
  3. `configurePhase`: Running `./configure` or CMake generation.
  4. `buildPhase`: Executing compilation (`make`, `cargo build`).
  5. `checkPhase`: Running test suites (`doCheck = true`).
  6. `installPhase`: Copying built artifacts into `$out` (`/nix/store/...`).
  7. `fixupPhase`: Binary stripping, ELF interpreter patching (`patchelf`), RPATH rewriting, `makeWrapper` execution.
- **Dependency Classification:**
  - `nativeBuildInputs`: Tools executed on the *build platform* (compilers, CMake, pkg-config).
  - `buildInputs`: Libraries compiled for the *host platform* (OpenSSL, zlib).
  - `propagatedBuildInputs` / `propagatedNativeBuildInputs`: Exported dependencies passed down to downstream packages.
- **Source Fetchers:** `fetchurl`, `fetchFromGitHub`, `fetchgit`, `fetchpatch`, `fetchzip`.
- **Language-Specific Packaging Ecosystems:**
  - *Go:* `buildGoModule` (`vendorHash` / `vendorGhes`).
  - *Rust:* `buildRustPackage` (`cargoHash`), `crane` (fine-grained incremental build caching), `naersk`.
  - *Python:* `buildPythonPackage`, `python3.withPackages`, `poetry2nix`, **`uv2nix`** (modern high-performance Python lockfile packaging).
  - *Node.js / Web:* `buildNpmPackage`, `pnpm.fetchDeps`.
- **Binary Patching & Wrappers:** `patchelf --set-interpreter`, `wrapProgram` from `makeWrapper` to inject environment variables (`LD_LIBRARY_PATH`, `PATH`).

### 3. Why It Matters in Production
Enterprise environments depend on internal, proprietary, or unpackaged open-source tools. Knowing how to write derivations turns an engineer into an autonomous platform builder.

### 4. Milestone Project / Practical Labs
- **Lab 7.1:** Package a simple C/C++ project using `stdenv.mkDerivation`, inspect its `$out` folder, and verify RPATH binary headers using `readelf`.
- **Lab 7.2:** Package a Go CLI tool using `buildGoModule` and a Rust binary using `crane`.
- **Milestone 7:** Identify an unpackaged tool on GitHub, write a submit-quality derivation with complete `meta` attributes (license, maintainers, description), and pass `nix flake check`.

### 5. Curated 2026 Resources
- Nixpkgs Manual — "Language Support & Frameworks"
- *nix.dev* — Packaging Existing Software Tutorial Series

---

## Module 8: Overlays, Custom Repositories & Nixpkgs Contributions

> **Level:** 600 | **Focus:** Package Set Extensibility & Upstream Workflows

### 1. Learning Objectives
- Extend and modify Nixpkgs without forking the repository using Overlays.
- Structure custom internal package repositories.
- Navigate the Nixpkgs contribution and PR review workflow.

### 2. Core Topics
- **Dependency Injection via `callPackage`:** Automatic argument matching from package sets (`pkgs.callPackage ./package.nix { }`).
- **Overlays Mechanics (`final: prev: { ... }`):**
  - `final` (or `self`): Refers to the fully evaluated, final package set (used for resolving cross-dependencies).
  - `prev` (or `super`): Refers to the un-modified package set prior to this overlay (used for calling `.override` or `.overrideAttrs`).
  - Overlay composition rules and avoiding infinite recursion loops.
- **Overriding Packages:**
  - `pkg.override { ... }`: Modifying function arguments passed to `callPackage`.
  - `pkg.overrideAttrs (oldAttrs: { ... })`: Modifying derivation arguments passed to `stdenv.mkDerivation`.
- **Nixpkgs Contribution Architecture:**
  - Repository structure (`pkgs/by-name` directory standard).
  - Pull Request workflow, commit naming conventions (`pkgname: init at 1.0.0`).
  - Automated CI evaluation with OfBorg and `nixpkgs-review` CLI tool.

### 3. Why It Matters in Production
Overlays allow platform teams to inject enterprise patches or security fixes across thousands of software packages instantly across their entire fleet without waiting for upstream releases.

### 4. Milestone Project / Practical Labs
- **Lab 8.1:** Write an overlay that replaces the OpenSSL library across all packages in a nixpkgs instantiation with a custom-compiled version.
- **Lab 8.2:** Use `nixpkgs-review` to build and test a local nixpkgs PR submission.
- **Milestone 8:** Author a pull request to `nixpkgs` adding a new package or bumping an outdated package, adhering strictly to the `pkgs/by-name` standard and passing OfBorg checks.

### 5. Curated 2026 Resources
- Nixpkgs Manual — "Overriding Packages" & "Contributing to Nixpkgs"
- `nixpkgs-review` Repository (GitHub: Mic92/nixpkgs-review)

---

## Module 9: The NixOS Module System Engine & Authoring Custom Modules

> **Level:** 500–600 | **Focus:** Module Evaluation Mechanics & Custom DSLs

### 1. Learning Objectives
- Master the underlying NixOS module evaluation engine (`lib.evalModules`).
- Author reusable custom modules with strongly-typed options interfaces.
- Implement complex option merging, priority rules, and validation assertions.

### 2. Core Topics
- **Module Engine Architecture (`imports`, `options`, `config`):**
  - How NixOS evaluates hundreds of `.nix` files into a single unified `config` attribute set.
- **Option Declarations (`lib.mkOption`):**
  - Specifying option attributes: `type`, `default`, `description`, `example`.
  - Type System (`lib.types`): `types.bool`, `types.str`, `types.int`, `types.listOf`, `types.attrsOf`, `types.enum`, `types.submodule` (nested option structures).
- **Option Precedence & Priority Mechanics:**
  - `lib.mkIf`: Conditional options application based on boolean flags.
  - `lib.mkMerge`: Merging multiple configuration blocks.
  - `lib.mkDefault` (priority 1000): Default value overrideable by standard config.
  - `lib.mkForce` (priority 50): High-priority override enforcing options.
  - Priority numeric values and collision resolution.
- **Validation & Health Checks:** `assertions = [ { assertion = ...; message = "..."; } ]` and `warnings`.
- **Authoring Enterprise Service Modules:** Exposing options like `services.myCompanyApp.enable`, `.port`, and `.secretPath` that automatically generate systemd service units, create declarative service users, and configure firewall rules.

### 3. Why It Matters in Production
The module system is the abstraction engine of NixOS. Writing clean, typed modules enables platform teams to expose simple, safe configuration interfaces to product developers.

### 4. Milestone Project / Practical Labs
- **Lab 9.1:** Write a standalone script using `lib.evalModules` to evaluate custom module schema outside of NixOS.
- **Lab 9.2:** Implement a nested submodule type (`types.submodule`) for defining dynamic virtual host configurations.
- **Milestone 9:** Author a custom NixOS module (`modules/services/internal-api.nix`) exposing typed options that provisions a Go web service with systemd sandboxing options, user creation, and firewall toggles.

### 5. Curated 2026 Resources
- Nixpkgs Manual — "Writing NixOS Modules"
- Existing NixOS Modules Source Tree (`nixos/modules/services/`)

---

## Module 10: Declarative Storage, Filesystems & Disk Management with Disko

> **Level:** 400–500 | **Focus:** Storage Automation & File System Engine

### 1. Learning Objectives
- Declaratively format, partition, and mount disk layouts using **Disko**.
- Architect advanced storage configurations incorporating Btrfs subvolumes, ZFS pools, and LUKS encryption.
- Automate disk layout provisioning for cloud instances and bare-metal servers.

### 2. Core Topics
- **The Storage Pain Point:** Traditional manual disk partitioning (`fdisk`, `mkfs`, `/etc/fstab`) breaks declarative zero-touch automation.
- **Disko Framework (by Numtide):** Defining disk partitioning, table types (GPT/MBR), partitions, and filesystems directly in Nix code.
- **File System Architectures & NixOS Synergies:**
  - *Ext4:* Standard, simple, reliable block layout.
  - *Btrfs:* Declarative subvolume layouts (`@root`, `@home`, `@nix`), transparent zstd compression, copy-on-write (CoW) snapshots, and impermanence patterns.
  - *ZFS:* Enterprise zpools, datasets, ARC cache tuning, native encryption, and atomic snapshot replication.
- **Storage Virtualization & Security:**
  - LVM (Logical Volume Manager) volume groups and thin pools configured via Disko.
  - Software RAID (`mdadm`) volume management.
  - LUKS (Linux Unified Key Setup) disk encryption paired with TPM2 key unlocking (`boot.initrd.luks`).
  - Ephemeral Root on Tmpfs (Impermanence / Erase-your-darlings pattern): Mounting `/` on RAM (`tmpfs`) so un-declared state vanishes on reboot, keeping only `/nix` and persisted paths.

### 3. Why It Matters in Production
Disko enables total declarative disk provisioning. A single Nix file specifies disk partition tables, file systems, mount flags, and encryption keys, eliminating manual installer steps forever.

### 4. Milestone Project / Practical Labs
- **Lab 10.1:** Write a Disko configuration splitting a virtual disk into GPT partitions (ESP boot, swap, and Ext4 root).
- **Lab 10.2:** Configure a Btrfs Disko layout with subvolumes for `/nix`, `/etc`, and `/var/log`, testing zstd compression.
- **Milestone 10:** Create a production Disko specification implementing LUKS full-disk encryption with a Btrfs subvolume layout and automated swap management, tested on a raw QEMU disk.

### 5. Curated 2026 Resources
- Disko Repository Documentation (GitHub: numtide/disko)
- *Impermanence Guide* (GitHub: nix-community/impermanence)

---

## Module 11: Production Secret Management & Runtime Secret Injection

> **Level:** 500–600 | **Focus:** Secret Decryption Engines & Store Security

### 1. Learning Objectives
- Protect sensitive credentials from leaking into the world-readable `/nix/store`.
- Compare and deploy **sops-nix** and **agenix** secret management frameworks.
- Implement systemd runtime secret injection patterns (`LoadCredential`).

### 2. Core Topics
- **The Secret Problem in Nix:** The `/nix/store` is world-readable by design (`chmod -R a+r`). Plaintext secrets in Nix expressions or store paths represent catastrophic security vulnerabilities.
- **Secret Decryption Engines:**
  - **sops-nix:** Mozilla SOPS integration using Age or GPG keys. Encrypts YAML/JSON secret files in Git repos; decrypts at boot to RAM (`/run/secrets/`, tmpfs). Supports multi-key access and secret templates.
  - **agenix:** Lightweight Age encryption using SSH host keys (`/etc/ssh/ssh_host_ed25519_key`). Pure Nix workflow using `secrets.nix`. Decrypts during early boot stage 2.
- **Post-Quantum Security Considerations:** Leveraging Age v1.3.0+ post-quantum-safe keys (`age-keygen -pq`) within secret workflows.
- **Runtime Secret Injection Patterns:**
  - Systemd `LoadCredential` and `SetCredential` directives to inject secrets directly into service process environments without writing files to disk.
  - Managing permissions (`owner`, `group`, `mode`) of decrypted secret symlinks.
  - The SSH-agent root gotcha during remote `nixos-rebuild switch` deployments.

### 3. Why It Matters in Production
Zero-trust security requires keeping API tokens, database passwords, and TLS private keys out of version control and out of the Nix store, while making them seamlessly available to runtime daemons.

### 4. Milestone Project / Practical Labs
- **Lab 11.1:** Encrypt a secret payload using `age` and SSH host keys, and decrypt it inside a NixOS VM using `agenix`.
- **Lab 11.2:** Configure `sops-nix` with a `.sops.yaml` key distribution matrix for multi-node deployments.
- **Milestone 11:** Integrate `sops-nix` into your Module 9 custom NixOS service module so that database passwords decrypt into a RAM-backed `/run/secrets/` directory and are consumed safely via systemd `LoadCredential`.

### 5. Curated 2026 Resources
- sops-nix GitHub Documentation (nix-community/sops-nix)
- agenix GitHub Documentation (ryantm/agenix)

---

### ▶ Tier 2 (NCP) Checkpoint & Competency Bar
At this milestone, the candidate can author Flakes-based workspace architectures, manage portable user dotfiles with Home Manager, package complex polyglot applications from source, write custom typed NixOS modules, automate disk layouts with Disko, and securely manage production secrets.

---

## TIER 3 — EXPERT & ARCHITECT (NCE)

---

## Module 12: Zero-Touch Provisioning, Cloud & Fleet Orchestration

> **Level:** 600 | **Focus:** Multi-Node Deployments & Bare-Metal Provisioning

### 1. Learning Objectives
- Provision bare-metal servers and cloud VMs remotely using **nixos-anywhere**.
- Generate custom cloud images, AMIs, and installer ISOs with **nixos-generators**.
- Orchestrate parallel fleet deployments using **Colmena** and **deploy-rs**.

### 2. Core Topics
- **Zero-Touch Remote Provisioning:**
  - **`nixos-anywhere`:** Remote automated installation over SSH onto *any* running Linux distribution (Ubuntu, Debian, RHEL) by kexec-ing a NixOS installer in memory, running Disko, and executing `nixos-install`.
- **Cloud & Artifact Generation:**
  - **`nixos-generators`:** Compiling a single NixOS configuration into diverse output formats: AWS AMI, Azure VHD, GCP image, Proxmox LXC/VMA, QCOW2, Cloud-Init ISO, and Raspberry Pi SD card images.
- **Fleet Deployment Engines:**
  - **Colmena:** Fast, parallel, hive-based deployment CLI. Tag-based target selection (`colmena apply --on @production`), local vs. remote evaluation, and secret integration.
  - **deploy-rs:** Flake-native, stateless, Rust-based deployment engine featuring automatic rollbacks if activation verification checks fail.
  - Native `nixos-rebuild switch --target-host` for simple multi-node tasks.
- **Cross-Architecture Build Infrastructure:**
  - Offloading builds to remote builders (`nix.buildMachines`).
  - Emulating foreign CPU architectures (e.g., ARM64 on x86_64) via QEMU `binfmt_misc` vs. pure cross-compilation (`pkgsCross`).

### 3. Why It Matters in Production
An SRE must manage fleets of tens or thousands of servers efficiently. Zero-touch provisioning turns bare metal into declarative, disposable infrastructure.

### 4. Milestone Project / Practical Labs
- **Lab 12.1:** Generate an AWS AMI image and a Proxmox QCOW2 image from a single NixOS flake configuration using `nixos-generators`.
- **Lab 12.2:** Execute `nixos-anywhere` to convert a vanilla Ubuntu lab VM into a fully declared NixOS node remotely over SSH.
- **Milestone 12:** Configure a Colmena deployment hive managing 3 NixOS nodes (1 Controller, 2 Workers), execute parallel deployments using tags, and demonstrate automatic rollback on a simulated deployment failure.

### 5. Curated 2026 Resources
- Colmena Official Documentation (nix-community/colmena)
- nixos-anywhere GitHub (numtide/nixos-anywhere)

---

## Module 13: Enterprise CI/CD, Private Binary Caches & Build Farms

> **Level:** 700 | **Focus:** Build Acceleration & Continuous Integration Infrastructure

### 1. Learning Objectives
- Establish and operate enterprise private binary caches to eliminate redundant source builds.
- Integrate Nix build pipelines into self-hosted CI engines (Gitea Actions, Woodpecker, GitHub Actions).
- Build distributed build farms using Hydra or remote builders.

### 2. Core Topics
- **Binary Cache Mechanics:**
  - How substitution works: Store path signatures, cryptographic signing key pairs, trusted public keys (`trusted-public-keys`), and substituter prioritization.
- **Binary Cache Implementations:**
  - *SaaS:* **Cachix** (hosted cache-as-a-service).
  - *Self-Hosted:* **Attic** (high-performance Rust-based binary cache server backed by S3/MinIO), **Harmonia** (lightweight Nix cache server written in C++), `nix-serve`.
- **CI/CD Integration Pipelines:**
  - Configuring CI runners (GitHub Actions via `DeterminateSystems/nix-installer` & `magic-nix-cache`, GitLab CI, Woodpecker CI).
  - Parallel evaluation optimization with `nix-eval-jobs`.
  - Pipeline stages: `nix flake check` → `nix build` → push outputs to Attic cache → trigger Colmena fleet deploy.
- **Hydra Continuous Integration:**
  - The canonical NixOS build farm engine. Jobsets, evaluation polling, build distribution, and channel generation.

### 3. Why It Matters in Production
Without binary caching, every server in a fleet compiles software from source, resulting in massive build times and resource consumption. Binary caches make Nix deployments blazingly fast.

### 4. Milestone Project / Practical Labs
- **Lab 13.1:** Deploy a self-hosted Attic binary cache backed by MinIO S3 storage, generate signing keys, and configure a Nix client to push build paths.
- **Lab 13.2:** Optimize a multi-stage CI build pipeline using `nix-eval-jobs` for parallel evaluation.
- **Milestone 13:** Connect a self-hosted Woodpecker CI / Gitea Actions runner to build your Module 5 flake, push built system closures to a self-hosted Attic cache, and authorize production servers to substitute binaries cleanly.

### 5. Curated 2026 Resources
- Attic Repository Documentation (zhaofengli/attic)
- Harmonia Repository Documentation (nix-community/harmonia)

---

## Module 14: Containers, MicroVMs & Immutable Cloud Artifacts

> **Level:** 700 | **Focus:** Artifact Generation & Container Ecosystem Synergies

### 1. Learning Objectives
- Build minimal, reproducible OCI/Docker container images using `dockerTools` without Docker daemons.
- Deploy hypervisor-isolated micro-VMs using **MicroVM.nix**.
- Compare Nix-built container artifacts with traditional Dockerfile workflows.

### 2. Core Topics
- **Nix-Native Container Generation:**
  - `pkgs.dockerTools.buildImage` and `pkgs.dockerTools.buildLayeredImage`: Creating byte-for-byte reproducible, minimal (distroless) OCI container images directly from Nix store closures without running a Docker daemon.
  - Layer optimization: Automatically splitting runtime dependencies into optimized image layers for maximum Docker registry cache efficiency.
  - **Nixery:** On-the-fly container image server generating ad-hoc images from Nix expressions upon image pull requests.
- **NixOS Native Containers:**
  - Light-weight `systemd-nspawn` containers defined declaratively within NixOS configuration (`containers.<name>`).
- **MicroVM.nix Framework:**
  - Running ultra-lightweight, hypervisor-isolated NixOS micro-VMs using Cloud-Hypervisor, QEMU, or Firecracker.
  - Micro-VM interfaces, virtio-fs file sharing, and tap networking.
- **Kubernetes & Cloud-Native Ecosystem:**
  - `kubenix` (authoring Kubernetes manifests using the NixOS module system), Arion (Docker Compose wrapper powered by Nix), running lightweight k3s on NixOS nodes.

### 3. Why It Matters in Production
Traditional Dockerfiles suffer from non-deterministic base images and floating apt upgrades. `dockerTools` produces bit-identical container images with zero CVE bloat.

### 4. Milestone Project / Practical Labs
- **Lab 14.1:** Build a multi-layered OCI container image for a Go application using `dockerTools.buildLayeredImage` and measure layer caching efficiency.
- **Lab 14.2:** Launch a declarative `systemd-nspawn` container on NixOS with dedicated network namespaces.
- **Milestone 14:** Deploy a MicroVM.nix cluster running Firecracker micro-VMs on a single NixOS host, sharing host storage via virtiofs.

### 5. Curated 2026 Resources
- Nixpkgs Manual — `dockerTools` Reference
- MicroVM.nix Repository (astro/microvm.nix)

---

## Module 15: Security Hardening, Compliance, SBOM & Vulnerability Management

> **Level:** 700–800 | **Focus:** Enterprise Hardening, Compliance & Supply Chain Security

### 1. Learning Objectives
- Harden NixOS system services to enterprise security standards.
- Implement Secure Boot with **Lanzaboote** and LUKS TPM2 auto-unlock.
- Audit software supply chain integrity through automated SBOM generation and CVE scanning.

### 2. Core Topics
- **Systemd Service Sandboxing:**
  - Applying strict security attributes to custom services: `DynamicUser = true`, `ProtectSystem = "strict"`, `ProtectHome = true`, `NoNewPrivileges = true`, `PrivateTmp = true`, `CapabilityBoundingSet = "CAP_NET_BIND_SERVICE"`.
- **Hardware-Level Security:**
  - **Lanzaboote:** Secure Boot implementation for NixOS replacing standard systemd-boot with a signed stub loader.
  - LUKS full-disk encryption with TPM2 key binding (`systemd-cryptsetup` / Clevis) for hands-free secure booting.
- **Mandatory Access Control & Isolation:**
  - AppArmor profile enforcement, SELinux status, `nixpak` (flatpak-style sandboxing for desktop apps), `bubblewrap` (`bwrap`).
- **Supply Chain Security & Software Bill of Materials (SBOM):**
  - Reproducible builds as a supply-chain defense property.
  - Generating SBOMs directly from dependency graphs using `nix-sbom`, CycloneDX, or SPDX standards.
  - **FlakeBOM** and enterprise vulnerability management.
- **Vulnerability Audit & CVE Scanning:**
  - Auditing store closures for known vulnerabilities using `vulnix` and `grype`.
  - Understanding the security release lifecycle of NixOS stable channels versus `nixpkgs-unstable`.

### 3. Why It Matters in Production
Deploying Linux in enterprise financial, medical, or government infrastructure requires passing compliance audits (SOC2, HIPAA, GDPR, ISO27001). Security hardening turns NixOS into a fortress.

### 4. Milestone Project / Practical Labs
- **Lab 15.1:** Apply full systemd sandboxing options to an unhardened service and verify restricted access using `systemd-analyze security`.
- **Lab 15.2:** Generate a SPDX Software Bill of Materials (SBOM) for a production flake application output.
- **Milestone 15:** Configure a NixOS system featuring Lanzaboote Secure Boot signing, TPM2-backed LUKS disk encryption, hardened systemd services, and an automated vulnerability scan step in CI.

### 5. Curated 2026 Resources
- Lanzaboote Repository (nix-community/lanzaboote)
- NixOS Manual — Security Hardening Chapter

---

## Module 16: Advanced Internals, Evaluator Debugging & Ecosystem Research

> **Level:** 800 | **Focus:** Core Internals, Performance Optimization & Future Roadmap

### 1. Learning Objectives
- Trace and profile performance bottlenecks in complex Nix evaluator expressions.
- Understand Content-Addressed (CA) derivations and evaluator internals.
- Evaluate emerging ecosystem forks, alternative evaluators, and research projects.

### 2. Core Topics
- **Content-Addressed (CA) Derivations:**
  - The architectural evolution from input-addressed store paths (`/nix/store/<input-hash>-name`) to content-addressed store paths (`/nix/store/<content-hash>-name`).
  - Early cutoff optimizations: Preventing catastrophic rebuild cascades when minor upstream comments change without altering built output bytes.
- **Evaluator Performance Profiling:**
  - Profiling memory usage and evaluation speed using `nix eval --json`, `builtins.trace`, and memory heap analysis.
  - Mitigating slow evaluation in giant flakes: Determinate Nix Lazy Trees, parallel evaluation engines (`nix-eval-jobs`).
- **Nix Core Internals:**
  - How `nix-instantiate` constructs abstract syntax trees (ASTs) and serializes them into `.drv` files.
- **Ecosystem Forks & Future Research Directions:**
  - **Determinate Nix:** Downstream distribution, Lazy Trees architecture, FlakeHub integration.
  - **Lix:** Community fork of C++ Nix focusing on code modernization, refactoring legacy codebase debt, and stable flake interfaces.
  - **Tvix:** Re-implementation of Nix in Rust by TVL (The Virus Lounge), featuring decoupled evaluator, store, and builder daemons.
  - **NixBSD:** Projects adapting the NixOS module system to FreeBSD/OpenBSD kernels.

### 3. Why It Matters in Production
At the principal engineer / architect level, when evaluation memory spikes to 32GB or complex overlays stall CI pipelines, you must debug the evaluator engine itself rather than treating Nix as a black box.

### 4. Milestone Project / Practical Labs
- **Lab 16.1:** Profile a complex Nix evaluation using `nix-instantiate --trace-function-calls` and identify expensive function calls.
- **Lab 16.2:** Compare build behavior between input-addressed derivations and content-addressed derivations in a local test store.
- **Milestone 16:** Author a comprehensive technical RFC or research paper analyzing evaluator performance bottlenecks in a multi-thousand node enterprise flake monorepo, demonstrating optimization mitigations.

### 5. Curated 2026 Resources
- Tvix Project Architecture Documentation (tvix.dev)
- Lix Project Announcements & Blog (lix.systems)

---

## MASTER CAPSTONE PROJECTS FRAMEWORK

The curriculum culminates in four comprehensive, production-grade Capstone Projects. Each capstone synthesizes skills across multiple modules into a verified portfolio deliverable.

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          MASTER CAPSTONE SUITE                              │
├──────────────────────────────┬──────────────────────────────────────────────┤
│ CAPSTONE 1: WORKSTATION      │ Portable Developer Workstation Flake         │
│                              │ (NixOS + macOS + HM + Secrets)               │
├──────────────────────────────┼──────────────────────────────────────────────┤
│ CAPSTONE 2: APPLICATION      │ Hermetic Polyglot Stack & CI Pipeline         │
│                              │ (Go/Rust/Node + Attic + OCI Images)          │
├──────────────────────────────┼──────────────────────────────────────────────┤
│ CAPSTONE 3: INFRASTRUCTURE   │ HA Enterprise Production Fleet               │
│                              │ (Disko + Lanzaboote + Colmena + sops-nix)    │
├──────────────────────────────┼──────────────────────────────────────────────┤
│ CAPSTONE 4: ARCHITECTURE     │ Enterprise Monorepo & Upstream Contribution  │
│                              │ (flake-parts + Custom Modules + Nixpkgs PR)  │
└──────────────────────────────┴──────────────────────────────────────────────┘
```

---

### Capstone Project 1: The Ultimate Reproducible Developer Workstation
- **Objective:** Architect a single git repository containing a Flake that declaratively manages a daily-driver workstation across both Linux (NixOS) and macOS (`nix-darwin`).
- **Requirements:**
  1. Full Home Manager integration managing shell (Zsh/Fish), terminal (Ghostty/Alacritty), editor (Neovim/VSCode), and Git configurations.
  2. Integration with `direnv` and `nix-direnv` for instant shell hook activation.
  3. Secret management via `agenix` or `sops-nix` protecting SSH private keys and API tokens.
  4. Single command bootstrap (`nix run .#bootstrap`) on a fresh OS installation.

### Capstone Project 2: Hermetic Polyglot Application Stack & CI/CD Pipeline
- **Objective:** Package a complex multi-service application (Go API server, Rust background worker, Node.js frontend, PostgreSQL database) into a fully hermetic build and deployment pipeline.
- **Requirements:**
  1. Pin all toolchains using a top-level `flake.nix` and lockfile.
  2. Author submit-quality derivations for un-packaged services using `buildGoModule`, `crane`, and `buildNpmPackage`.
  3. Generate minimal, zero-CVE OCI container images using `dockerTools.buildLayeredImage`.
  4. Configure a Woodpecker CI / Gitea Actions pipeline that builds artifacts, pushes binaries to a self-hosted Attic binary cache, and runs automated `checks`.

### Capstone Project 3: High-Availability Enterprise Production Fleet
- **Objective:** Provision, deploy, and operationalize a 3-node NixOS server fleet (1 Controller, 2 Worker nodes) from bare metal to hardened production status.
- **Requirements:**
  1. Automated zero-touch remote provisioning using `nixos-anywhere` and `disko` (Btrfs subvolumes + LUKS encryption + TPM2 unlock).
  2. Hardware security via Lanzaboote signed Secure Boot.
  3. Secret injection via `sops-nix` using Systemd `LoadCredential` for runtime secrets.
  4. Parallel fleet orchestration configured via Colmena with tag-based deployment controls.
  5. Full observability stack (Prometheus node-exporter, Grafana dashboard, Loki log aggregation) deployed declaratively across the cluster.
  6. Demonstrated zero-downtime atomic rollback procedure during a simulated production incident.

### Capstone Project 4: Enterprise Monorepo & Upstream Nixpkgs Contribution
- **Objective:** Design an enterprise-grade monorepo capable of managing 100+ simulated server configurations, authoring internal service modules, and contributing back to open-source upstream Nixpkgs.
- **Requirements:**
  1. Structure the monorepo using `flake-parts` for clean multi-file modularization.
  2. Author custom NixOS service modules complete with strongly-typed options, assertion checks, and systemd sandboxing.
  3. Generate software supply-chain artifacts (SPDX SBOMs) and conduct automated vulnerability scanning (`vulnix`/`grype`) in CI.
  4. Write a comprehensive Disaster Recovery (DR) Runbook detailing recovery procedures, RTO/RPO expectations, and state persistence boundaries.
  5. Submit a real, merged (or review-ready) Pull Request to the upstream `nixpkgs` repository adding a package or fixing an issue according to `pkgs/by-name` standards.

---

## PRACTICAL WORKBOOK & HANDS-ON LAB INDEX

To operationalize this theoretical syllabus, a companion workbook organizes **200+ hands-on practical labs** across 5 progressive lab tiers:

| Lab Tier | Title | Lab Count | Core Focus & Lab Exercises |
|---|---|---|---|
| **Tier L1** | **Fundamentals & Language** | 40 Labs | Installing Nix/Determinate/Lix, REPL evaluation, writing pure functions, debugging thunks, managing store paths, `nix shell` ephemeral environments. |
| **Tier L2** | **NixOS System Administration** | 50 Labs | Partitioning disks, writing `configuration.nix`, configuring systemd services, managing networking/nftables, user management, generation switching, bootloader recovery. |
| **Tier L3** | **Packaging & Custom Modules** | 50 Labs | Writing derivations (`stdenv.mkDerivation`), language builders (`buildGoModule`, `crane`, `poetry2nix`), authoring overlays, building typed NixOS modules with assertions. |
| **Tier L4** | **Enterprise Infrastructure & Fleet** | 40 Labs | Disko layouts, `sops-nix`/`agenix` secret injection, `nixos-anywhere` bare-metal installs, Colmena fleet deploys, setting up Attic private binary caches, building OCI images with `dockerTools`. |
| **Tier L5** | **Failure, Recovery & Hardening** | 20+ Labs | Intentionally breaking store paths, corrupting configuration modules, recovery from failed rollouts, Lanzaboote Secure Boot setup, systemd sandboxing audits, profiling evaluator memory usage. |

---

## APPENDIX A: CANONICAL RESOURCE LIBRARY (2026 EDITION)

### Official Documentation & Primary Sources
- **[nix.dev](https://nix.dev)** — Official documentation portal maintained by the NixOS Foundation.
- **[NixOS Manual](https://nixos.org/manual/nixos/stable/)** — Official system administration reference guide.
- **[Nix Reference Manual](https://nixos.org/manual/nix/stable/)** — Low-level CLI and expression language reference.
- **[Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/)** — Standard library, builder functions, and packaging guidelines.
- **[search.nixos.org](https://search.nixos.org)** — Search index for 100k+ Nix packages and tens of thousands of NixOS module options.

### Comprehensive Guides & Community Books
- **[Zero to Nix](https://zero-to-nix.com)** — Guided onboarding path by Determinate Systems.
- **[NixOS & Flakes Book](https://thiscute.world/nixos-and-flakes-book/)** — Comprehensive, highly-regarded community book on Flakes-era infrastructure.
- **Nix Pills** — Classic step-by-step deep-dive into Nix internals and language mechanics.

### Tooling Repositories & Utilities Reference
- **Provisioning & Storage:** `disko` (numtide/disko), `nixos-anywhere` (numtide/nixos-anywhere), `nixos-generators` (nix-community/nixos-generators).
- **Fleet Orchestration:** `colmena` (zhaofengli/colmena), `deploy-rs` (serokell/deploy-rs).
- **Secrets Management:** `sops-nix` (Mic92/sops-nix), `agenix` (ryantm/agenix).
- **Binary Caching:** `attic` (zhaofengli/attic), `harmonia` (nix-community/harmonia), `cachix` (cachix/cacli).
- **Development & Packaging:** `flake-parts` (hercules-ci/flake-parts), `home-manager` (nix-community/home-manager), `crane` (ipetkov/crane), `microvm.nix` (astro/microvm.nix), `lanzaboote` (nix-community/lanzaboote).

---

## APPENDIX B: DELIBERATE EXCLUSIONS & SCOPE BOUNDARIES

To maintain laser focus on enterprise production infrastructure, the following topics are explicitly out of primary scope:

1. **Legacy Deployment Tools (`NixOps`):** Superseded in current professional practice by Colmena and deploy-rs.
2. **Desktop Gaming & Rice Workstations:** While desktop NixOS (Wayland, Hyprland, audio drivers) is popular, desktop cosmetic customization is orthogonal to server SRE engineering.
3. **Deep Specialized GPU/CUDA Packaging Tracks:** GPU acceleration and CUDA drivers represent a specialized AI/ML infrastructure track that can be taken as an optional post-graduate module.
