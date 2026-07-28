# The Complete Nix & NixOS Professional Track
### From Zero to Production — A Certification-Style Curriculum (Nix Fundamentals → NixOS Administration → Fleet/Production Engineering)
*Compiled July 2026 from official docs, nix.dev, zero-to-nix, NixOS Discourse/Wiki, nixpkgs manual, Determinate Systems engineering blog, NixCon talks, and current community practice.*

---

## 0. How This Course Is Structured

This mirrors the shape of a professional Linux certification track (think RHCSA → RHCE → RHCA), but for Nix/NixOS, because nothing like that exists officially — the ecosystem's learning material is scattered across blogs, Discourse threads, and half-finished wiki pages. This syllabus is the single consolidated spine. It is designed so we can build the **practical workbook (hands-on labs)** on top of each module next.

**Three tiers, mirroring industry cert structure:**

| Tier | Codename (informal) | Equivalent to | Outcome |
|---|---|---|---|
| Tier 1 — Foundation | **NCA** (Nix Certified Associate, informal) | RHCSA | Can use Nix daily, write basic derivations, run a single NixOS box confidently |
| Tier 2 — Professional | **NCP** (Nix Certified Professional, informal) | RHCE | Can package real software, write NixOS modules, run flakes-based multi-service systems, manage secrets |
| Tier 3 — Expert / Production | **NCE** (Nix Certified Expert, informal) | RHCA / Senior SRE | Can run a fleet, build CI/CD + binary cache infra, harden for production, contribute upstream, debug at the store/evaluator level |

**Format per phase**, exactly like a professional course module:
- Learning Objectives
- Core Topics
- Why It Matters in Production
- Milestone Project (proof of competency — this is what the lab workbook will operationalize)
- Curated Resources (only living, current, 2024–2026-relevant material)

**Estimated total duration:** 6–9 months at a serious part-time pace (your existing DevOps lab cadence), front-loaded because the Nix language + mental model (Phases 1–3) is the steepest part of the curve — everything after gets easier, not harder.

**Environment assumption:** built to run on your existing self-hosted Azure VM DevOps lab (Ubuntu 24.04, LXD, KVM). We will use LXD containers/VMs and dedicated NixOS KVM VMs inside that lab as disposable, snapshot-able practice environments — never touch your daily-driver macOS Nix install for destructive experiments.

---

## TIER 1 — FOUNDATION (NCA)

## Phase 0 — Orientation: What Nix Actually Is and Why It's Different

**Learning Objectives**
- Articulate the difference between *imperative* package managers (apt/yum/pacman) and Nix's *purely functional, content-addressed* model
- Understand the three things people conflate and must be separated mentally: **the Nix language**, **the Nix package manager/store**, and **NixOS the Linux distribution**
- Understand what "reproducible" and "declarative" actually mean operationally, not just as marketing words

**Core Topics**
- The problem Nix solves: dependency hell, "works on my machine," non-reproducible builds, mutable global state (`/usr/lib`, `/etc`)
- The Nix store (`/nix/store`) and content-addressed hashed paths
- Derivations as the unit of build — everything is a build description, not an action
- Generations and atomic upgrades/rollbacks as the payoff of the above
- Nixpkgs vs Nix vs NixOS — the three-layer mental model
- Current ecosystem map (mid-2026): classic Nix vs **Determinate Nix** (Determinate Systems' downstream distribution, adds Lazy Trees, parallel evaluation, FlakeHub) vs **Lix** (community fork) — you need to know these exist and *why* the fork/branching happened, even before choosing an installer
- Current NixOS release cadence: **26.05 "Yarara"** is the latest stable as of this writing, 25.11 "Xantusia" the prior stable now deprecated — releases every ~6 months (May/November), each supported ~7 months

**Why It Matters in Production**
Every production incident narrative in the Nix world ends the same way: "I rolled back to the previous generation and rebooted." That single sentence is the entire value proposition of running this in anger — but it only makes sense once the store/derivation model clicks.

**Milestone Project**
Write a one-page "mental model" document, in your own words, explaining the store + derivations + generations to a hypothetical new hire — you will refer back to this the day something breaks in production.

**Curated Resources**
- [nix.dev](https://nix.dev) — official onboarding docs, actively maintained
- [Zero to Nix](https://zero-to-nix.com) — Determinate Systems' beginner-friendly guided path
- [Nix Pills](https://nixos.org/guides/nix-pills/) — deep, slow, "why" focused series (read Pills 1–3 now, rest later in Phase 7)
- NixOS official [Blog/Announcements](https://nixos.org/blog/announcements/) — bookmark for release cadence
- Determinate Systems blog — "Nix flakes explained" and "Determinate Nix: the recent past and the shining future" for current ecosystem state

---

## Phase 1 — Installing Nix and Surviving the CLI Split

**Learning Objectives**
- Install Nix correctly on macOS (daily driver) and Linux (lab VMs) using both the official installer and the Determinate installer, and articulate the tradeoffs
- Navigate the "two CLIs" problem: legacy commands (`nix-env`, `nix-build`, `nix-shell`, `nix-channel`) vs the new unified `nix` CLI (`nix build`, `nix develop`, `nix run`, `nix profile`) introduced alongside flakes
- Understand experimental-features flags and why almost everyone enables `nix-command flakes` immediately

**Core Topics**
- Single-user vs multi-user install, the nix-daemon
- `nix.conf` essentials: `experimental-features`, `trusted-users`, `substituters`, `extra-substituters`
- Channels (legacy) vs flake inputs (modern) — know both, because a huge amount of existing tutorials/production systems still use channels
- `nix-env` and why professional guidance now steers away from it (imperative, mutable user profile — reintroduces the exact problem Nix was built to solve)
- Garbage collection: `nix-collect-garbage`, GC roots, why disk fills up and how to reclaim it safely

**Why It Matters in Production**
Picking an installer/CLI stance is a team-wide architectural decision, not a personal taste choice — it determines whether your CI, binary cache, and onboarding docs are consistent.

**Milestone Project**
Stand up Nix on a fresh LXD/KVM Ubuntu VM two ways — official installer, then wiped and reinstalled with the Determinate installer — and produce a short comparison note (boot time to first `nix develop`, defaults, uninstall cleanliness).

**Curated Resources**
- Official Nix manual — Installation chapter
- Determinate Systems installer docs + "Understanding the Differences Between Nix, Determinate Nix, and Lix" (Zenn, Feb 2026) — practical benchmarked comparison
- NixOS Wiki — "Flakes" page, installer/config warnings section

---

## Phase 2 — The Nix Language, Properly

This is the single highest-leverage phase in the entire syllabus. Most people who "bounce off" Nix never actually learned the language as a language — they copy-pasted configs. We're not doing that.

**Learning Objectives**
- Read and write Nix expressions fluently: it is a small, lazy, purely functional, dynamically-typed language — treat it like learning a real language (comparable rigor to when you scoped the Go roadmap)
- Understand laziness and its consequences (infinite structures, `builtins.trace` debugging, why errors appear far from their cause)

**Core Topics**
- Basic types: strings, integers, booleans, paths, lists, attribute sets (attrsets), `null`
- Functions: single-arg, curried multi-arg, attrset-pattern arguments (`{ a, b, ... }:`), default values, `@`-bindings
- `let ... in`, `with`, `inherit`, `rec` attrsets and their scoping gotchas
- Recursion, `import`, and how multi-file Nix projects actually compose
- String interpolation (`"${...}"`), multi-line strings, path literals vs strings
- `builtins` — the essential subset: `builtins.toString`, `map`, `filter`, `foldl'`, `attrNames`, `functionArgs`, `trace`
- `nixpkgs.lib` — the standard library layered on top of `builtins` (this is where 90% of real-world Nix code lives): `lib.mkIf`, `lib.mkMerge`, `lib.mkDefault`, `lib.optional(s)`, `lib.mapAttrs`, `lib.recursiveUpdate`
- Fixed points and overlays conceptually (full depth in Phase 6) — just enough now to not be confused later
- Laziness deep-dive: why `let x = throw "boom"; in "hi"` doesn't crash

**Why It Matters in Production**
Every module option, override, and overlay you'll write for the rest of your career is just... functions and attrsets. If this phase is rushed, every later phase becomes cargo-culting instead of engineering — exactly the failure mode the Lobsters "Our roadmap for Nix" post describes as Nix's notoriously steep learning curve.

**Milestone Project**
Without consulting a package's existing derivation, write a small "toy interpreter" in pure Nix (e.g., an arithmetic expression evaluator or a tiny templating function) using only `builtins` + basic recursion. This forces genuine language fluency rather than pattern recognition.

**Curated Resources**
- [Nix Language Basics — nix.dev](https://nix.dev/tutorials/nix-language) (the current official reference-quality tutorial)
- "Nix Pills" 4–7 (functions, laziness, fixed points groundwork)
- nix-community "Learn Nix in Y minutes"-style cheat references (Discourse "Nix Roadmaps (Skill Trees)" thread has several curated language-only paths)
- `nixpkgs/lib` source itself, read like documentation once basics land

---

## Phase 3 — Nixpkgs From the User Side

**Learning Objectives**
- Use Nixpkgs as a consumer: search, install, pin versions, run ad-hoc tools without installing them
- Understand the Nixpkgs repo structure well enough to navigate it (it is the largest monorepo in the FOSS world — you need a map, not memorization)

**Core Topics**
- `nix search`, [search.nixos.org](https://search.nixos.org) (100k+ packages), `nix shell nixpkgs#pkgname` for ephemeral tool use
- Package attribute paths, `pkgs.callPackage`, top-level vs nested package sets
- Version pinning strategies: pinning nixpkgs itself vs pinning individual packages, `nixpkgs-unstable` vs stable release channels/branches
- Overriding packages as a consumer: `override`, `overrideAttrs` (the two most common footguns — knowing which to use when)
- devShells for reproducible project environments (`nix develop`, `shell.nix` legacy equivalent) — direct application to your existing polyglot DevOps tooling

**Why It Matters in Production**
This is the "daily driver" competency layer — reproducible dev environments are the single most immediately useful Nix feature for a working engineer, independent of ever running NixOS.

**Milestone Project**
Convert one real project from your DevOps lab stack (pick Go, or the ContainerLab/observability tooling) into a fully reproducible `nix develop` shell that pins exact tool versions (kubectl, terraform/opentofu, etc.) — teammates get an identical environment with one command.

**Curated Resources**
- search.nixos.org
- nix.dev tutorials on "Reproducible scripts" and "Ad hoc envs with nix-shell/nix develop"
- Nixpkgs manual — "Overriding" chapter

---

## Phase 4 — NixOS as a Single-Machine OS

**Tier 1 capstone phase** — this is your "install and administer a single box competently" equivalent to RHCSA's core skill.

**Learning Objectives**
- Install and administer a single NixOS machine end-to-end declaratively
- Read and write `configuration.nix` confidently, understand what "the module system" is doing under the hood (deep dive comes Phase 8, but you need working fluency now)

**Core Topics**
- Installation: manual partitioning vs `nixos-install`, the graphical/minimal ISO, disk layout choices (ext4 vs ZFS vs Btrfs on NixOS, boot loader choice — systemd-boot vs GRUB)
- `/etc/nixos/configuration.nix` and `hardware-configuration.nix` — what's machine-generated vs what you own
- `nixos-rebuild switch|boot|test|build` — the difference matters operationally (test = try now, don't persist across reboot; boot = persist without switching yet)
- Users, groups, and `users.users.<name>` declarative accounts
- Networking basics: `networking.hostName`, NetworkManager vs `systemd-networkd`, firewall (`networking.firewall`)
- systemd services the NixOS way: `systemd.services.<name>` module blocks instead of hand-written unit files
- **Generations and rollback** — booting into a previous generation from the bootloader menu, `nix-env --list-generations` equivalent for system profiles, `nixos-rebuild --rollback`
- Garbage collection specific to NixOS system generations, keeping enough history for safe rollback vs disk usage tradeoffs (practical guidance: ≥50GB allocated for `/nix/store` in production)

**Why It Matters in Production**
This phase is where the "I once spent a weekend fixing a broken production upgrade — with NixOS I'd have fixed it by reverting one line and rebooting" story (the exact experience recent NixOS write-ups describe) becomes something you can personally reproduce and trust.

**Milestone Project**
Build a single NixOS KVM VM in your lab from scratch: manual disk partitioning, a `configuration.nix` covering users/networking/firewall/2+ systemd services, then deliberately break it (bad config) and recover via generation rollback from the boot menu — document the recovery time.

**Curated Resources**
- Official NixOS Manual (the primary reference — treat as your RHEL "Administrator's Guide" equivalent)
- "Mastering NixOS: A Guide to Immutable Linux" (2026) — practical walkthrough with a production-failure narrative very close to your own lab context
- NixOS Wiki — hardware/install pages for VM-specific quirks

---

### ▶ NCA (Tier 1) Checkpoint
You should now be able to: explain the store/derivation/generation model; write real Nix language code without copying templates; use Nixpkgs devShells daily; install, configure, break, and recover a single NixOS box. This is the equivalent bar to RHCSA — comfortable, unsupervised, single-system competence.

---

## TIER 2 — PROFESSIONAL (NCP)

## Phase 5 — Flakes: The Modern Project Structure

**Learning Objectives**
- Understand flakes as the (still technically experimental, but de facto standard) unit of composable, pinned, shareable Nix projects
- Structure real multi-output projects: packages, devShells, NixOS configurations, overlays, all from one `flake.nix`

**Core Topics**
- `flake.nix` schema: `description`, `inputs`, `outputs`
- `flake.lock` — what's pinned, how `nix flake update` works, updating a single input vs all
- Flake inputs: `github:`, `git+ssh://`, `path:`, `follows` for input deduplication
- Standard outputs: `packages`, `devShells`, `nixosConfigurations`, `homeConfigurations`, `overlays`, `apps`, `checks`
- `nix flake show`, `nix flake check`
- **The current ecosystem split you must understand as a professional**: flakes remain officially "experimental," Nixpkgs itself doesn't use them internally, and this produced real divergence — Determinate Systems declared them stable and layered proprietary extensions (Lazy Trees, FlakeHub, parallel evaluation), while **Lix** (the community fork) consolidated a de-facto stable "v1" feature set independently. You need an informed opinion here, not just usage — this is a live, actively-discussed architectural decision in 2026, not settled history
- `flake-utils` / `flake-parts` for reducing per-system boilerplate
- Alternatives worth knowing exist even if you don't adopt them: `niv`, `npins` (pre-flake and flake-agnostic pinning tools still used in some production shops)

**Why It Matters in Production**
Flakes are how you get reproducible builds *across time and across machines*, not just on one box — this is the difference between "works on my laptop" and "works in CI, in prod, and for the next engineer in 8 months."

**Milestone Project**
Convert your Phase 3 devShell project and your Phase 4 NixOS VM config into a single flake repo with `devShells`, `packages`, and `nixosConfigurations` outputs, properly using `follows` to deduplicate nixpkgs versions across inputs.

**Curated Resources**
- nix.dev — "Flakes" concept page (current, balances usage with the honest state of the controversy)
- zero-to-nix.com/concepts/flakes
- NixOS & Flakes Book (community-maintained, very current — thiscute.world) — one of the best full practical references available
- Determinate Systems — "Nix flakes explained: what they solve, why they matter, and the future" (2026)

---

## Phase 6 — Home Manager: Declarative User Environments

**Learning Objectives**
- Manage dotfiles, shell config, and user-level packages declaratively, portable across NixOS *and* your macOS daily driver

**Core Topics**
- Standalone Home Manager vs NixOS-module-integrated Home Manager — the tradeoffs
- `home.nix` structure: `home.packages`, `programs.<name>.enable`, `home.file`
- Managing your actual daily tools this way: this maps directly onto your existing Ghostty/terminal customization work — you can express that config declaratively instead of hand-maintained dotfiles
- Home Manager on macOS via `nix-darwin` + Home Manager combo (relevant since macOS is your daily driver)

**Why It Matters in Production**
This is the layer that makes "reproducible environment" personal, not just server-side — new machine, one command, identical shell/editor/terminal setup.

**Milestone Project**
Migrate your current Ghostty config + shell setup into a Home Manager flake module that applies identically on a NixOS lab VM and (optionally) on macOS via nix-darwin.

**Curated Resources**
- Home Manager official manual (nix-community/home-manager)
- nix-darwin project docs
- Community "nix-config" dotfile repos on GitHub for structure patterns (many public reference configs, e.g. chzerv/nix-config style repos, good for seeing real conventions — always adapt, don't copy blindly)

---

## Phase 7 — Packaging Real Software (Derivations Deep Dive)

**Learning Objectives**
- Write correct, idiomatic derivations for real software from source, not just consume existing packages
- Understand `stdenv.mkDerivation` deeply: phases, hooks, environment

**Core Topics**
- `stdenv.mkDerivation` anatomy: `src`, `nativeBuildInputs` vs `buildInputs`, phases (`unpackPhase`, `configurePhase`, `buildPhase`, `installPhase`, `fixupPhase`), phase hooks
- Fetchers: `fetchurl`, `fetchFromGitHub`, `fetchgit`, `fetchPypi`, `fetchCargoVendor`/`fetchCargoTarball`, and hash-mismatch-driven workflows (`nix-prefetch-*` tools, or the "build it, read the hash mismatch, paste it in" iteration loop everyone actually uses)
- Language-specific packaging helpers: `buildGoModule`, `buildPythonPackage`/`poetry2nix`, `buildRustPackage`, `buildNpmPackage` — directly relevant given your Go roadmap and general polyglot tooling
- Patching source, `patches`, `postPatch`
- Cross-compilation basics: `pkgsCross`, understanding `buildPlatform`/`hostPlatform`/`targetPlatform`
- Debugging failed builds: `nix log`, `--keep-failed`, dropping into the build sandbox

**Why It Matters in Production**
The moment you need internal/private tooling packaged reproducibly (which will happen constantly in a real DevOps org), this phase is the entire job.

**Milestone Project**
Package a real piece of software that has **no existing nixpkgs derivation** (pick something small from your own tool list, or an internal script/CLI) from source, submit-quality: correct `meta`, license, working `nix build`, and passes `nix flake check`.

**Curated Resources**
- Nixpkgs manual — "Language support and frameworks" chapters (Go/Python/Rust/Node sections)
- Nix Pills — remaining pills on stdenv and derivations
- nix.dev — "Packaging existing software" tutorial series
- nixpkgs GitHub — read real PRs and their review comments; this is where actual house style is taught

---

## Phase 8 — The Module System, Properly

**Learning Objectives**
- Write your own NixOS modules with typed options — the actual mechanism behind every `services.foo.enable` you've used so far

**Core Topics**
- `options` + `config` structure, `lib.mkOption`, the `types` library (`types.bool`, `types.str`, `types.listOf`, `types.submodule`, `types.attrsOf`)
- `lib.mkIf`, `lib.mkDefault`, `lib.mkForce`, `lib.mkMerge` and priority resolution — this is the part everyone finds confusing and where most real bugs live
- Module imports, `imports = [ ... ]`, and how NixOS assembles hundreds of modules into one evaluated config
- Writing a module with an `enable` flag that conditionally configures a systemd service, firewall rule, and user, mirroring how real nixpkgs service modules are authored
- `assertions` and `warnings` inside modules for user-facing validation errors

**Why It Matters in Production**
Every internal platform team that adopts NixOS eventually needs house modules (standard logging config, standard user provisioning, standard hardening baseline). This phase is what turns you from "NixOS user" into "NixOS platform engineer."

**Milestone Project**
Write a custom NixOS module (`modules/my-app.nix`) exposing a typed options interface (`services.myApp.enable`, `.port`, `.extraConfig`) that provisions a real toy service (e.g., a small Go/Python HTTP server) with correct systemd hardening options set as defaults.

**Curated Resources**
- Nixpkgs manual — "Writing NixOS Modules" chapter (the canonical reference)
- Existing nixpkgs `nixos/modules/services/**` tree — read 3–4 real, well-reviewed modules for house style
- NixCon talks on the module system (search NixCon YouTube channel — recurring topic every year, deep dives available)

---

### ▶ NCP (Tier 2) Checkpoint
You can now: structure real projects as flakes with an informed opinion on the flakes/Determinate/Lix landscape; manage a portable personal environment; package arbitrary software from source; author your own typed NixOS modules. This is RHCE-equivalent — you can be handed a real, non-trivial requirement and deliver a correct Nix/NixOS solution independently.

---

## TIER 3 — EXPERT / PRODUCTION (NCE)

## Phase 9 — Secrets Management

**Learning Objectives**
- Never put a secret in the Nix store (world-readable by design) or a public flake — and know the current, correct tooling to avoid it

**Core Topics**
- Why plaintext-in-config, git-crypt, and naive approaches are wrong on NixOS specifically (store world-readability)
- **sops-nix**: SOPS + age/PGP-based, YAML-friendly, scales well for many secrets, template support, decrypts to `/run/secrets/<name>` (tmpfs, never touches disk)
- **agenix**: age-encrypted, one file per secret, simpler mental model, pure-Nix `secrets.nix` access control, decrypts via SSH host keys to `/run/agenix/...`
- Current (2026) guidance: **agenix for simple/beginner setups, sops-nix for complex multi-secret production services** (e.g., mail servers) — know both well enough to choose per-project, not dogmatically
- Post-quantum note: `age` v1.3.0+ supports post-quantum-safe keys (`age-keygen -pq`) — sops-nix support for this is still catching up as of 2026, worth checking current status before assuming
- Integration pattern with flakes: `sops-nix.nixosModules.sops` / agenix module wiring, and the SSH-key-vs-sudo gotcha (root's SSH agent isn't automatically available during `nixos-rebuild switch`)

**Why It Matters in Production**
This is a hard blocker for literally every real deployment — API keys, TLS certs, DB passwords, WiFi credentials, all need a real answer before "production" is a legitimate word to use.

**Milestone Project**
Wire sops-nix (or agenix) into your Phase 8 module's toy service so it consumes a real decrypted secret (e.g., a fake API token) at runtime, with the encrypted file safely committed to your lab's git repo.

**Curated Resources**
- NixOS Wiki — "Comparison of secret managing schemes" (current, actively maintained comparison page)
- NixOS Discourse — "Handling Secrets in NixOS: An Overview" guide thread
- sops-nix and agenix upstream READMEs (both actively maintained, nix-community/Mic92 and ryantm respectively)
- "NixOS and Secrets" (isabelroses.com, 2026) — recent practical comparison including PQ-safety notes

---

## Phase 10 — Multi-Machine / Fleet Management

**Learning Objectives**
- Manage more than one NixOS machine from a single source of truth, remotely, safely, and in parallel

**Core Topics**
- Why plain `nixos-rebuild switch --target-host` doesn't scale past a couple of boxes
- **Colmena**: stateless, parallel, hive-based deployment (`hive.nix`/flake `colmena` output), per-node `deployment.targetHost`, tag-based selective deploys (`colmena apply --on @tag`)
- **deploy-rs**: flake-native, multi-profile alternative, magic rollback on activation failure
- **nixos-anywhere**: kexec-based bare-metal/VPS provisioning — install NixOS onto *any* running Linux box remotely in minutes, no physical/console access needed
- **disko**: declarative disk partitioning as Nix config, paired with nixos-anywhere for fully declarative from-bare-metal provisioning
- Fleet secrets and per-node key management (ties directly into Phase 9)
- GitOps pattern: git push → CI builds → Colmena/deploy-rs pushes to fleet (preview of Phase 11)
- Awareness of the broader tool landscape: Morph, Nixus, lollypops, Bento (for machines not always online) — know they exist, know why Colmena/deploy-rs are the current default choices

**Why It Matters in Production**
This is the actual "SRE managing a fleet" skill — the gap between "I run NixOS on my laptop" and "I run NixOS as a company's infrastructure."

**Milestone Project**
In your DevOps lab: provision 2–3 NixOS KVM VMs from zero using `nixos-anywhere` + `disko` from one flake, then deploy a config change to all of them in parallel via Colmena using tags, and prove atomic rollback works when a bad config is pushed.

**Curated Resources**
- nix-community/colmena GitHub (README + tutorial)
- deploy-rs GitHub
- nixos-anywhere + disko official docs (numtide)
- "NixOS & Flakes Book" — Remote Deployment chapter (thiscute.world, actively updated 2026)
- "Automating NixOS Deployments with OneDev and Colmena" (Dominik Pall, 2026) — recent real GitOps writeup, good structural template

---

## Phase 11 — CI/CD, Binary Caches, and Build Infrastructure

**Learning Objectives**
- Stop rebuilding from source on every machine — understand and run substituters/binary caches properly
- Wire Nix builds into CI so the fleet in Phase 10 gets automatically built and cached

**Core Topics**
- Why binary caches exist: source builds are slow/expensive; substituters let you download prebuilt store paths instead
- The official cache (`cache.nixos.org`) and how substitution decisions/trust (`trusted-public-keys`) work
- **Cachix**: hosted binary cache-as-a-service, simplest path for small teams/private caches
- **Attic** / **Harmonia**: self-hostable binary cache servers — directly relevant to your self-hosted lab philosophy (fits your Gitea/Woodpecker CI stack instead of depending on a SaaS)
- **Hydra**: the original NixOS project's own continuous build/evaluation system — heavier, but the canonical reference for "what a Nix build farm looks like at scale"
- Wiring your **existing Woodpecker CI + Gitea** lab stack to: run `nix flake check`, build packages/NixOS configs, push results to a self-hosted Attic/Harmonia cache, then trigger Colmena/deploy-rs deployment
- Remote builders: offloading builds to more powerful/different-architecture machines (`nix.buildMachines`, relevant for cross-compilation and ARM targets)
- FlakeHub (Determinate Systems' flake registry/pinning-as-a-service) as a current enterprise-adjacent option — know it exists, understand it's a proprietary layer, not required

**Why It Matters in Production**
This closes the loop from Phase 10: git push → CI builds once → cache serves binaries to the whole fleet → deploy tool activates. This is what makes NixOS ops fast at scale instead of "every machine compiles everything from scratch."

**Milestone Project**
Extend your existing Gitea + Woodpecker CI pipeline (from your DevOps lab) with a Nix build stage: on push, run `nix flake check`, build the flake's packages/NixOS system closures, push to a self-hosted Attic instance running in your lab, and have your Phase 10 fleet pull from it as a substituter.

**Curated Resources**
- Cachix docs
- Attic (zhaofengli/attic) and Harmonia GitHub READMEs
- Hydra manual (for conceptual grounding even if you don't run it directly)
- nix.dev — "Continuous integration with GitHub Actions" tutorial (adapt patterns to Woodpecker/Gitea Actions)

---

## Phase 12 — Nix for Containers, Images, and Cloud

**Learning Objectives**
- Use Nix to build container images and cloud machine images deterministically, replacing Dockerfiles where it earns its keep

**Core Topics**
- `pkgs.dockerTools.buildImage` / `buildLayeredImage` — reproducible, minimal (often distroless-equivalent) container images without a Dockerfile
- **Nixery**: ad-hoc container images generated on the fly from Nixpkgs, pulled directly by tag
- **nixos-generators**: producing cloud/VM images (AWS AMI, Azure/GCE images, Proxmox LXC/VM templates, ISOs) from the same NixOS config you already write
- NixOS containers (`systemd-nspawn`-based, `containers.<name>` option) as a lighter-weight alternative to full VMs for service isolation — directly comparable to your existing LXD usage, worth an honest comparison
- Kubernetes-adjacent tooling: `kubenix` (K8s resources from Nix), Arion (Nix-native Docker Compose equivalent) — situational, know when they add value vs added complexity over plain Helm/kustomize
- Where Nix-built containers genuinely beat Dockerfiles (byte-identical reproducible layers, no base-image drift) vs where they don't (team already fluent in Docker, marginal gain not worth the switch)

**Why It Matters in Production**
Most real infra is heterogeneous — this phase is about knowing where Nix-built artifacts slot into an existing container/cloud-native stack rather than replacing it wholesale.

**Milestone Project**
Take the toy service from Phase 8 and produce three artifacts from the *same* flake: a minimal OCI container image via `dockerTools`, a NixOS container definition, and a cloud VM image via nixos-generators — compare image sizes and build reproducibility across all three.

**Curated Resources**
- Nixpkgs manual — `dockerTools` section
- nixos-generators GitHub (nix-community)
- Nixery project docs/blog
- NixOS manual — "Container Networking" / `containers.*` options chapter

---

## Phase 13 — Production Hardening, Security, and Compliance

**Learning Objectives**
- Take a working NixOS deployment and make it defensible in an actual security review

**Core Topics**
- systemd service hardening options as first-class Nix module settings: `DynamicUser`, `ProtectSystem`, `ProtectHome`, `NoNewPrivileges`, `PrivateTmp`, capability bounding — and how nixpkgs service modules increasingly set sane hardened defaults already
- Read-only root / immutability postures on NixOS (the OS is already largely immutable by design — understanding exactly what still *is* mutable: `/nix/var`, state directories, `/etc` symlink farm)
- Kernel hardening modules in nixpkgs (`security.*` options, e.g. AppArmor integration, sandboxing of the Nix build itself)
- Supply-chain concerns: reproducible builds as a security property, SBOM generation for flakes (e.g., Determinate's FlakeBOM tooling as a current example of where this space is heading in 2026), pinning discipline and `flake.lock` review as part of code review
- Disaster recovery planning specific to NixOS: what backing up `/etc/nixos` + your flake repo actually gives you (full system reproducibility) vs what it doesn't (data disks, secrets material, external state)
- Patch/CVE response process: how `nixpkgs-unstable`/stable-channel security backports work, how fast fixes land relative to upstream Debian/RHEL security teams (useful comparison point given your Ubuntu evaluation work)

**Why It Matters in Production**
This is the phase that turns "cool declarative Linux" into "something a security team will sign off on."

**Milestone Project**
Take your Phase 8–10 fleet and produce a hardening pass: apply systemd sandboxing options to every custom service, document the immutability boundary of the system, and write a one-page DR runbook (What do we lose if this VM dies right now? What's the actual recovery procedure and RTO?).

**Curated Resources**
- NixOS manual — systemd hardening options reference (`systemd.services.<name>.serviceConfig`)
- Determinate Systems — Secure Packages / FlakeBOM blog posts (current SBOM/supply-chain direction in the ecosystem)
- NixOS security advisories mailing list / GitHub security tab on nixpkgs

---

## Phase 14 — Advanced Internals and Ecosystem Fluency

**Learning Objectives**
- Operate confidently at the "something is deeply wrong at the store/evaluator level" layer — the difference between a professional and an expert

**Core Topics**
- Content-addressed derivations (the newer, still-evolving alternative to input-addressed store paths) and why they matter for build caching/determinism
- Cross-compilation in depth: `pkgsCross.<target>`, remote/native builders for foreign architectures (e.g., building aarch64/riscv64 images from an x86_64 host, then deploying via nixos-anywhere)
- Overlays in depth: composing multiple overlays, override ordering, debugging "why did my override not take effect" (almost always a `mkForce`/priority or evaluation-order issue — ties back hard to Phase 8)
- Evaluating and debugging performance: `nix eval --json`, profiling slow evaluations, understanding why large flakes get slow to evaluate and current mitigations (Determinate's parallel evaluation and Lazy Trees as one active answer to this exact problem)
- Contributing to nixpkgs: PR conventions, `nixpkgs-review`, the review/merge process, `ofborg`/CI checks — treated as a real skill, not an afterthought
- Staying current: how to read the ecosystem going forward — NixOS Discourse, the weekly-ish "This Month in Nix"/NixCon talks, `nixpkgs` PR traffic, Determinate Systems and Lix blogs as the two "competing roadmap" voices to track

**Why It Matters in Production**
At this level you stop needing tutorials and start being the person who writes the internal ones — this is the actual "senior/expert" bar.

**Milestone Project**
Submit one real, merged (or at minimum, review-ready and submitted) pull request to nixpkgs — a new package, a version bump with a fix, or a documentation improvement. This is the single best objective proof of Tier 3 competence available, and it's genuinely achievable at this point in the curriculum.

**Curated Resources**
- nixpkgs CONTRIBUTING.md and the Nixpkgs manual's contribution chapters
- `nixpkgs-review` tool
- NixOS Discourse — "Nix Roadmaps (Skill Trees)" thread (community meta-discussion on structuring exactly this kind of deep-dive learning)
- NixCon talk archives (YouTube) — internals-focused sessions, new ones every year

---

## Phase 15 — Capstone: Production Fleet Project

**This is the synthesis phase** — everything above, combined into one real system, exactly like a capstone project in a professional cert track.

**Capstone Requirements** (this becomes the backbone of your DevOps lab's Nix layer):
1. A single flake repo as source of truth, structured with `flake-parts` or clean `flake-utils` conventions
2. 3+ NixOS machines provisioned from bare instance to fully configured via `nixos-anywhere` + `disko`, zero manual steps
3. At least one custom-authored NixOS module (typed options, assertions, sane defaults) providing a real service
4. Secrets (sops-nix or agenix) wired for at least one credential, never touching the store in plaintext
5. CI (your existing Gitea/Woodpecker) building and checking every push, publishing to a self-hosted binary cache (Attic/Harmonia)
6. Deployment to the fleet via Colmena or deploy-rs, tag-scoped, with a demonstrated rollback
7. At least one artifact exported as a container image via `dockerTools` from the same flake
8. Hardening pass applied and a written DR runbook
9. Full documentation: architecture diagram, runbooks, and an onboarding doc a hypothetical new teammate could follow start to finish

**Deliverable:** a git repository + a written report, functioning as your professional portfolio artifact — directly analogous to a capstone project you'd present after finishing an RHCE-track course, and directly extends your existing self-hosted DevOps lab architecture (Tailscale/Caddy/LXD/k3s/ArgoCD/Prometheus-Grafana-Loki) with a fully-realized Nix/NixOS layer sitting alongside it.

---

## Appendix A — Canonical Resource Library (Curated, Living Documents Only)

**Official / Living Documentation**
- nixos.org — NixOS Manual, Nix Manual, Nixpkgs Manual (the three official manuals — primary source of truth throughout)
- nix.dev — official onboarding + tutorials, actively maintained by the NixOS Foundation
- search.nixos.org — package and option search
- NixOS Wiki (wiki.nixos.org) — community-maintained, actively updated in 2026, good for "comparison of X" style pages
- NixOS Discourse (discourse.nixos.org) — the primary current community forum; search here first for anything version-specific

**Deep, Slower-Paced Learning**
- Zero to Nix (zero-to-nix.com) — Determinate Systems' guided beginner path
- Nix Pills (official) — the "why," not just the "how"
- "NixOS & Flakes Book" (nixos-and-flakes.thiscute.world) — comprehensive, actively updated community book; arguably the best single unofficial reference for flakes-era practice

**Ecosystem/Industry Voices to Follow Going Forward**
- Determinate Systems engineering blog (determinate.systems/blog) — sets a lot of the current agenda (Lazy Trees, parallel eval, FlakeHub, Secure Packages/FlakeBOM)
- Lix project blog/announcements — the community-fork counterpoint on flakes stabilization
- NixCon talks (YouTube, annual) — internals and production war-stories
- nixpkgs GitHub Issues/PRs — where the ecosystem's actual direction gets decided in public

**Tooling READMEs referenced throughout (all actively maintained as of 2026)**
Colmena, deploy-rs, nixos-anywhere, disko, sops-nix, agenix, Cachix, Attic, Harmonia, Hydra, nixos-generators, Nixery, home-manager, nix-darwin.

---

## Appendix B — What We Deliberately Did Not Deep-Dive (and Why)

- **NixOps** — the original official deployment tool; effectively superseded by Colmena/deploy-rs in current community practice. Worth knowing it existed historically, not worth learning as a primary tool today.
- **Desktop environment / daily-driver-workstation NixOS configuration** (window managers, gaming, etc.) — genuinely popular use case, but orthogonal to the professional/production track; can be a fun side-project once Tier 2 is complete, using the same skills.
- **GPU/CUDA-specific Nix packaging** — real and non-trivial, but a specialized track of its own; flag for a future add-on module if it becomes relevant to your lab's actual workloads.

---

## Next Step

This is the full spine. Once you confirm this structure (or want it reshaped — more/less weight on any phase, different ordering, added specialization tracks like GPU/ML packaging or desktop NixOS), the next deliverable is the **practical workbook**: a lab-by-lab hands-on companion with exact commands, expected output, checkpoints, and "break it on purpose" exercises for each phase above, built directly against your existing Azure DevOps lab environment.
