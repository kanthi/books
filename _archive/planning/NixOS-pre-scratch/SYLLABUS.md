# NixOS Journey Notes — Comprehensive Syllabus

**Working title:** Notes on Nix & NixOS: From Scratch to Production-Minded Practice  

**Baseline version (as of 2026-07-23):** **NixOS / nixpkgs 26.05 “Yarara”** (released 2026-05-30; security/bugfix support through 2026-12-31).  
**Upgrade-from line:** 25.11 “Xantusia” (EOL after 2026-06-30).  
**Next named train to watch:** 26.11 “Zokor”.

This is a **personal notebook syllabus**, not a certification track. It is a multi-level index of everything I intend to learn and write down about Nix and NixOS—from first install through packaging, multi-host ops, and optional internals.

**Informed by:** planning merges under this folder (`syllabus-grok.md`, `syllabs-agy.md`, `nix-nixos-professional-syllabus.md`); official docs (Nix/NixOS/nixpkgs manuals, nix.dev, wiki); Zero to Nix; *NixOS & Flakes Book* (ryan4yin / thiscute.world); community practice (Home Manager, Disko, sops-nix/agenix, deploy-rs/colmena); 26.05 release notes (systemd stage-1 default, x86_64-darwin sunset path, toolchain bumps).

**Published form:** `content/00-front-matter/00-syllabus.qmd`  
**Status:** Syllabus only—chapter prose comes later, one chapter at a time.

---

## 0. Contract

### 0.1 Intent

1. Enough **why** to stop cargo-culting expressions and modules  
2. Enough **how** to run a real machine and recover when activation fails  
3. Enough **structure** to grow into packaging, multi-host configs, caches, and production-shaped habits  

### 0.2 Done looks like

- Explain store, derivations, evaluation vs realization, generations, and GC roots  
- Install and administer **one** NixOS 26.05 host; break it and recover via generations  
- Pin work with **flakes** + lockfiles; shareable `devShell`s  
- Package something real; write a small NixOS module  
- Keep secrets out of the store; deploy/rebuild more than one machine  
- Debug eval vs build failures; use binary caches and basic CI without cargo-cult  

### 0.3 Principles

| Principle | Meaning |
|-----------|---------|
| Why before how | Store mechanics before muscle memory |
| Language early | Attrsets and functions beat endless copy-paste |
| Flakes as default practice | Channels/legacy taught honestly; work in locks |
| One machine first | Atomic rebuild/rollback before fleet tools |
| Production-minded later | Secrets, caches, deploy, CI after single-host competence |
| Linux remains real | systemd, mounts, network, permissions under the abstractions |
| Version-aware notes | Prefer 26.05 options/behaviors; call out upgrades |

### 0.4 Lab ground rules

- Disposable VMs/containers for destructive experiments  
- Separate daily-driver from lab breakage  
- Budget disk for `/nix/store` (often tens of GB)  
- Snapshot VMs and retain multiple NixOS generations on purpose  

### 0.5 Out of scope (main path)

- Exam / certification mapping  
- Full general Linux textbook (only Linux needed for NixOS)  
- Exhaustive nixpkgs language coverage  
- Desktop ricing as a primary track (optional appendix later)  
- Mandatory enterprise war-game catalog (raw material may stay in `_planning/` only)

### 0.6 26.05 landscape notes to carry through the book

- **Stage 1 / initrd:** systemd-based stage 1 is **default**; scripted stage 1 deprecated (removal aimed at 26.11)—install and recovery notes must reflect this  
- **Darwin:** 26.05 is the **last** nixpkgs line building **x86_64-darwin**; plan notes if Apple hardware is part of the journey  
- **Toolchain:** GCC 15; LLVM remains at 21 in this release train  
- **Desktop (if relevant):** GNOME 50 on this train  
- **Flakes:** still experimental upstream; de-facto for projects—document both  
- **Implementations:** Classic Nix (NixOS Foundation), Determinate Nix, Lix—literacy without brand loyalty  

### 0.7 Primary references (living)

| Resource | Use for |
|----------|---------|
| [nix.dev](https://nix.dev) | Tutorials, language, flakes concepts |
| [NixOS Manual (stable)](https://nixos.org/manual/nixos/stable/) | Modules, install, upgrade |
| [Nixpkgs Manual](https://nixos.org/manual/nixpkgs/stable/) | Packaging, languages, lib |
| [Nix Reference Manual](https://nix.dev/manual/nix/stable/) | CLI, store, conf |
| [wiki.nixos.org](https://wiki.nixos.org) | Community how-tos (verify against manuals) |
| [search.nixos.org](https://search.nixos.org) | Packages & options |
| [Zero to Nix](https://zero-to-nix.com) | Flakes-forward beginner path |
| [*NixOS & Flakes Book*](https://nixos-and-flakes.thiscute.world/) | Opinionated beginner/intermediate flakes path |
| Home Manager manual | User environments |
| Discourse / release notes | Breaking changes, 26.05 migration |

---

## Journey map (top level)

```
00 Front matter
01 First steps — install Nix, store, day-one CLI
02 Nix language
03 Nixpkgs as a user
04 NixOS on one machine (26.05)
05 Flakes as the workspace
06 Home Manager & workstation
07 Packaging (producer)
08 Modules, disks, secrets
09 Beyond one box — deploy, cache, CI, images, hardening
10 Internals & living landscape
99 Appendices
```

---

# Part 00 — Front matter

### Ch 00 — Syllabus (this document)

### Ch 01 — How I use this book

- Reading order vs skip rules  
- Lab VM vs daily driver  
- Note-taking: commands, failures, generations that saved me  
- When to stop and boot a previous generation  
- How chapters map to real projects  

### Ch 02 — Mental map of the ecosystem

#### 02.1 Three layers

- Nix language (lazy pure expressions)  
- Nix package manager + store (build engine)  
- NixOS (module system + Linux distro)  

#### 02.2 Core objects

- Store paths, closures, profiles, generations  
- Evaluation vs realization  
- Derivations and fixed-output derivations (preview)  

#### 02.3 Implementations & installers (2026 literacy)

- Classic Nix  
- Determinate Nix (installer defaults, flakes-forward posture)  
- Lix (community fork; modernization stance)  
- Research awareness: Tvix (later depth)  

#### 02.4 Releases & channels

- `nixos-26.05` / `nixpkgs-unstable` mental model  
- Why pin locks; upgrade windows (25.11 → 26.05 → 26.11)  
- 26.05 highlights that affect operators (systemd stage 1, darwin sunset)  

#### 02.5 Where truth lives

- Manuals vs wiki vs blogs; when Discourse is primary  

**Checkpoint:** place any new tool or post in the right layer.

---

# Part 01 — First steps (scratch → working Nix)

### Ch 01 — Why I moved toward Nix

#### 01.1 Problems

- Dependency collisions; “works on my machine”  
- Snowflake servers; mutable global state  
- Non-reproducible builds and config drift  

#### 01.2 Solution intuition

- Builds as pure functions of inputs → outputs  
- Describe closed systems instead of mutating hosts  
- Reproducibility as an operational property  

### Ch 02 — Install Nix and survive the CLI

#### 02.1 Installation models

- Multi-user daemon vs single-user  
- Official installer vs Determinate installer (defaults, uninstall cleanliness)  
- Linux / macOS / WSL notes (version-aware)  

#### 02.2 Dual CLI landscape

| Legacy | Modern | Role |
|--------|--------|------|
| `nix-env` | `nix profile` | User profiles (prefer declarative long-term) |
| `nix-build` | `nix build` | Realize derivations |
| `nix-shell` | `nix develop` / `nix shell` | Dev / ad-hoc |
| `nix-channel` | flake inputs / pins | Input locking |
| `nix-collect-garbage` | `nix store gc` family | GC |

#### 02.3 Early configuration

- `nix.conf` / declarative NixOS options for Nix  
- `experimental-features = nix-command flakes`  
- `trusted-users`, substituters, sandbox, `max-jobs`  

### Ch 03 — The store without magic

#### 03.1 Paths and immutability

- `/nix/store/<hash>-<name>-<version>`  
- Input-addressed vs content-addressed evolution (preview)  

#### 03.2 Derivations and two-phase model

- Eval → `.drv` → build outputs  
- Builders, sandbox, FODs for network fetches  
- Trust: signatures, substituters (preview)  

#### 03.3 Profiles, generations, GC roots

- Direct/indirect roots; `result` symlinks  
- Atomic switch; rollback as first-class ops  
- GC risks on multi-user and CI hosts  
- Store optimisation / hardlinking  

### Ch 04 — Day-one package use

#### 04.1 Discovery

- search.nixos.org; `nix search`  
- Attribute paths; nested package sets  

#### 04.2 Ephemeral tools

- `nix shell`, `nix run`  
- When not to use long-lived imperative profiles  

#### 04.3 Light pinning before full flakes

- Channel branches vs early flake lock  
- GC cycle walkthrough  

**Part 01 checkpoint:** Nix installed; tools run cleanly; store/generation vocabulary solid.

---

# Part 02 — The Nix language

### Ch 01 — Types, strings, paths, attrsets

#### 01.1 Primitives and containers

- string, int, float, bool, path, null  
- lists; attribute sets  

#### 01.2 Strings and paths

- Path literals vs strings  
- String context (store dependency tracking)  
- Indented strings `''…''`; interpolation  

### Ch 02 — Functions and composition

#### 02.1 Functions

- Single argument; currying  
- Attrset patterns, defaults, `@args`, ellipsis  

#### 02.2 Scoping

- `let … in`, `inherit`  
- `rec` (and why large codebases limit it)  
- `with` costs; `import`; multi-file layout  
- Operators, conditionals, assertions  

### Ch 03 — Laziness, errors, and the REPL

#### 03.1 Evaluation dynamics

- Call-by-need; thunks  
- Infinite structures; forcing with `seq` / `deepSeq`  

#### 03.2 Debugging

- `nix repl`, `nix eval`, `nix-instantiate`  
- `builtins.trace`; reading distant errors  
- Eval slowness vs build slowness  

### Ch 04 — `builtins` and `lib` I reach for

#### 04.1 Essential builtins

- attr/list ops, `readFile`/`readDir`, JSON, `typeOf`, `functionArgs`, …  

#### 04.2 nixpkgs.lib

- attrsets, lists, strings helpers  
- Preview module combinators: `mkIf`, `mkMerge`, `mkDefault`, `mkForce`, `mkOption`  

#### 04.3 FP patterns in Nix

- map/filter/foldl'; fixed points (`lib.fix`) as overlay/module groundwork  

**Part 02 checkpoint:** read real configs; write small pure helpers without templates.

---

# Part 03 — Nixpkgs as a user

### Ch 01 — Finding and pinning packages

#### 01.1 Consumer workflow

- Search; attribute paths; top-level vs nested sets  
- Stable 26.05 vs `nixpkgs-unstable`  

#### 01.2 Pinning strategies

- Flake lock (preferred practice)  
- Channels / `npins` / `niv` awareness  
- Partial vs full lock updates  

### Ch 02 — Overrides without fear

#### 02.1 Override family

- `override` (callPackage arguments)  
- `overrideAttrs` (derivation attributes)  
- Light patches and version bumps  

### Ch 03 — Project shells

#### 03.1 Construction

- `mkShell` / `mkShellNoCC`  
- `buildInputs` vs `nativeBuildInputs` in shells  
- `shellHook`, env vars, library path discipline  

#### 03.2 UX

- direnv + nix-direnv  
- devenv/lorri awareness  
- Editor integration patterns  
- FHS user envs when proprietary tools demand FHS  

#### 03.3 Language shells (as needed)

- Python, Rust, Go, Node, C/C++ companion patterns  
- Monorepo: per-package vs umbrella shells; eval caching  

**Part 03 checkpoint:** a real project’s toolchain is pinned and one-command onboarding works.

---

# Part 04 — NixOS on one machine (26.05)

### Ch 01 — Install path

#### 01.1 Media and hardware

- Minimal/graphical ISO; UEFI vs BIOS  
- Partitioning: manual vs guided  
- Filesystem choices (Ext4 / Btrfs / ZFS conceptual)  

#### 01.2 Install flow

- `nixos-generate-config`, `nixos-install`  
- Bootloader: systemd-boot vs GRUB  
- **Stage 1 / initrd:** systemd stage 1 default on 26.05; migration notes if something still expects scripted stage 1  

### Ch 02 — Configuration anatomy

#### 02.1 Files I own

- `configuration.nix` (or flake host module)  
- `hardware-configuration.nix` (generated)  
- Imports; early splits without flakes  

#### 02.2 Mental model of activation

- Evaluation of the system derivation  
- Activation scripts; `/etc` as managed tree  
- Why hand-editing `/etc` does not persist  

### Ch 03 — Rebuild modes I actually use

#### 03.1 Modes

| Mode | Build | Activate now | Default boot |
|------|-------|--------------|--------------|
| `switch` | ✓ | ✓ | ✓ |
| `boot` | ✓ | | ✓ |
| `test` | ✓ | ✓ | |
| dry-run / dry-activate | ✓ | simulate | |
| `build` | ✓ | | |

#### 03.2 Recovery

- Generation listing; boot menu selection  
- Safer narratives than blind `--rollback`  
- Remote rebuild caution (console/IPMI story)  

### Ch 04 — Users, SSH, networking, firewall

#### 04.1 Identity

- `users.users`, groups, SSH keys, sudo  
- Locale, timezone, console, keyboard  

#### 04.2 Networking

- hostname; NetworkManager vs `systemd-networkd`  
- Static vs DHCP; wireless (iwd/wpa)  
- `networking.firewall` / nftables; opening ports  
- SSH hardening basics  

### Ch 05 — Services the NixOS way

#### 05.1 Modules

- `services.<name>.enable` patterns  
- Options search; reading module source  

#### 05.2 systemd under NixOS

- `systemd.services`, timers, journald  
- Custom units when modules are not enough  
- cgroups/namespaces only as deep as debugging needs  

#### 05.3 Kernel and boot (admin level)

- `boot.kernelPackages`, modules, sysctl  
- Initrd knobs relevant on 26.05  

#### 05.4 System GC and disk budget

- System profile generations vs store GC  
- Keeping N generations for rollback windows  

#### 05.5 Deliberate break & recover lab

- Break firewall or service; recover; timed postmortem  

**Part 04 checkpoint:** one 26.05 host I can rebuild, break, and recover without reinstalling.

---

# Part 05 — Flakes as the workspace

### Ch 01 — Flake anatomy and lock discipline

#### 01.1 Structure

- `description`, `inputs`, `outputs`  
- Systems / `eachDefaultSystem` patterns  
- `flake.lock`; partial updates; security bumps  

#### 01.2 Inputs

- `github:`, `git+ssh://`, `path:`, tarballs, registries  
- `follows` for nixpkgs dedup  
- Private git sources; CI auth patterns  

#### 01.3 Status & ecosystem stance

- Experimental flag vs de-facto practice  
- Determinate “stable flakes” posture vs upstream  
- Alternatives still seen: channels, `npins`/`niv`  

### Ch 02 — Standard outputs I use

#### 02.1 Schema

- `packages`, `apps`, `devShells`  
- `nixosConfigurations`, `homeConfigurations`  
- `darwinConfigurations` (optional)  
- `overlays`, `checks`, `formatter`, `templates`  

#### 02.2 Merge shell + system

- Unify Part 03 + Part 04 into one flake  
- `nix flake show` / `check` / `metadata`  

### Ch 03 — Structure as repos grow

#### 03.1 Modular layout

- Split outputs into modules/files  
- `flake-utils` vs `flake-parts` (when boilerplate hurts)  

#### 03.2 Team habits

- Lockfile review as code review  
- Templates for personal monorepos  

**Part 05 checkpoint:** host + dev environment share one locked flake; `nix flake check` is green for what I claim.

---

# Part 06 — Home Manager & workstation

### Ch 01 — Home Manager choices

#### 01.1 Architectures

- Standalone `home-manager switch`  
- NixOS module integration  
- nix-darwin for macOS (optional track)  

### Ch 02 — Dotfiles and programs I care about

#### 02.1 Surface

- `home.packages`  
- `programs.*` (git, shell, editor, terminal)  
- `home.file` / `xdg.configFile`  
- `home.activation`; user systemd  

#### 02.2 Desktop-adjacent (optional)

- Fonts, GTK/Qt snippets  
- Wayland compositors only if daily driver needs them  

### Ch 03 — Portability patterns

#### 03.1 Sharing

- Shared modules across hosts  
- Host specializations  
- Bootstrap: one command on a new machine  
- Secrets-ready structure (ties to Part 08)  

**Part 06 checkpoint:** user environment reinstallable without archaeology.

---

# Part 07 — Packaging (producer side)

### Ch 01 — `stdenv.mkDerivation` in practice

#### 01.1 Anatomy

- `.drv` fields; builder env; inputs/outputs  
- Runtime closure; multi-output (`bin`/`lib`/`dev`/`doc`)  

#### 01.2 Phases

- unpack → patch → configure → build → check → install → fixup  
- Hooks; clean overrides  

#### 01.3 Dependency classification

- `nativeBuildInputs` vs `buildInputs` vs `propagatedBuildInputs`  

#### 01.4 Fetchers & hashes

- `fetchurl`, `fetchFromGitHub`, `fetchgit`, `fetchpatch`  
- Hash mismatch workflow; prefetch tools  

### Ch 02 — Language ecosystems I hit

#### 02.1 Common families

- Go: `buildGoModule` / vendor hashes (26.05 API notes if relevant)  
- Rust: `buildRustPackage`, crane awareness  
- Python: `buildPythonPackage`, poetry/uv tooling awareness  
- Node: `buildNpmPackage` / pnpm patterns  
- C/C++: autotools/cmake  

#### 02.2 Binary repair & wrapping

- `patchelf`, RPATH, `wrapProgram`, `patchShebangs`  

### Ch 03 — Debug failed builds

#### 03.1 Tooling

- `nix log`, `--keep-failed`, `--show-trace`  
- Drop into failed build dirs; `nix develop` around a drv  

#### 03.2 Quality bar

- `meta`, platforms, licenses  
- `nix flake check` habits  

**Part 07 checkpoint:** something I use is packaged cleanly (even if only internal).

---

# Part 08 — Modules, disks, secrets

### Ch 01 — Writing NixOS modules

#### 01.1 Module system engine

- Options; types; defaults  
- `mkIf`, `mkMerge`, `mkDefault`, `mkForce`, `mkOrder`  
- Imports and composition  

#### 01.2 Authoring practice

- Small module for a service I run  
- Reading nixpkgs module source as docs  

### Ch 02 — Disko & filesystem strategy

#### 02.1 Declarative disks

- Disko for repeatable installs  
- GPT, LUKS, Btrfs subvolumes / ZFS pools at install depth  
- Impermanence patterns (optional depth)  

### Ch 03 — Secrets that never land in the store

#### 03.1 Threat model

- Why secrets in store paths are fatal  
- Eval-time vs deploy-time injection  

#### 03.2 Tooling patterns

- sops-nix / agenix (or successors I adopt)  
- Age/SOPS keys; host vs user secrets  
- Rotation and failure modes  

**Part 08 checkpoint:** modular host config; secrets stay out of store paths.

---

# Part 09 — Beyond one box (production-minded)

### Ch 01 — Multi-host flakes and deploy

#### 01.1 Second host from one flake

- Host modules; shared vs specializations  
- Network and identity assumptions  

#### 01.2 Deploy mechanisms (pick and justify)

- `nixos-rebuild --target-host`  
- deploy-rs / colmena / other  
- Git as control plane; push vs pull models  

### Ch 02 — Binary caches and CI

#### 02.1 Substituters

- Trust model; public cache vs private  
- Cachix / Attic / self-hosted awareness  
- Signing keys  

#### 02.2 CI

- `nix flake check` / build matrix  
- Remote builders preview  
- Cache poisoning and trust discipline  

### Ch 03 — Containers, microVMs, images

#### 03.1 Image builds

- `dockerTools` / nix2container / OCI notes  
- When containers help vs full NixOS hosts  
- MicroVM awareness (optional)  

### Ch 04 — Hardening and observability

#### 04.1 Hardening

- SSH posture, firewall, updates  
- Minimal service surface  
- SBOM / vulnerability awareness (practical level)  

#### 04.2 Observability

- journald; basic metrics/alerts for services I run  
- Logs as first recovery tool  

### Ch 05 — Debugging and anti-patterns

#### 05.1 Failure classes

- Eval vs build vs activation  
- Network, sandbox, permission, disk-full  
- GC deleting live roots  

#### 05.2 Habits to avoid

- Disabling sandbox “to make it work” without understanding  
- Hand-editing `/etc`  
- Zero generation retention on important hosts  
- Unpinned “reproducible” shells  

**Part 09 checkpoint:** reason about ≥2 machines, CI/cache, and recovery under change.

---

# Part 10 — Internals & living landscape (optional depth)

### Ch 01 — Evaluator and store deeper

#### 01.1 Under the hood

- Reading `.drv`; profiles; GC root graphs under stress  
- CA derivations awareness as the ecosystem evolves  
- Performance: eval time vs build time  

### Ch 02 — Ecosystem notes (living chapter)

#### 02.1 Releases

- Lessons from 25.11 → 26.05 upgrades  
- Watch items for 26.11 (scripted stage 1 removal target; darwin x86_64 end)  

#### 02.2 Implementations

- Classic Nix / Determinate / Lix updates worth tracking  

#### 02.3 Contribution literacy

- nixpkgs PR conventions; `nixpkgs-review` awareness  
- When to overlay vs upstream  

**Part 10 checkpoint:** know where to dig when abstractions leak.

---

# Part 99 — Appendices

### A — Living resource list

- Official manuals, nix.dev, wiki, search, Zero to Nix  
- *NixOS & Flakes Book*, Discourse, release blogs  
- Hand-picked deep dives I actually used  

### B — Deliberate exclusions

- Full desktop ricing tracks; GPU/ML specialization as core  
- Cert prep and vendor exam mapping  
- Every language ecosystem in nixpkgs  
- Full enterprise war-game catalog (unless promoted later from `_planning/`)  

### C — Lab environment blueprint

- QEMU/KVM (or preferred) layout  
- Disk and store sizing  
- Snapshot / generation retention habit  
- Separate daily-driver policy  

### D — Personal project backlog

- Homelab services to Nix-ify next  
- Ideas that may become chapters  

### E — 26.05 operator cheatsheet (living)

- Upgrade commands  
- Stage-1 systemd default implications  
- Common option renames I hit  
- Darwin x86_64 sunset reminder (if relevant)  

---

## Suggested writing order

1. Front matter 01–02  
2. Part 01 complete  
3. Part 02 language  
4. Part 04 single NixOS host (core of the journey)  
5. Part 05 flakes  
6. Parts 03 & 06 with real projects  
7. Parts 07–09 as needs appear  
8. Part 10 + appendices  

---

## Future chapter path layout (when implementing content)

```text
content/
  00-front-matter/
  01-first-steps/
  02-nix-language/
  03-nixpkgs-user/
  04-nixos-one-machine/
  05-flakes/
  06-home-workstation/
  07-packaging/
  08-modules-disks-secrets/
  09-beyond-one-box/
  10-internals-landscape/
  99-appendices/
  _planning/   # this file + archived source merges
```

---

## Changelog

| Date | Note |
|------|------|
| 2026-07-23 | Initial journey syllabus (no cert framing) |
| 2026-07-23 | Comprehensive multi-level expansion; baseline **NixOS 26.05 Yarara**; systemd stage-1 default; darwin x86_64 sunset; expanded topics from manuals/community books/planning merges |
