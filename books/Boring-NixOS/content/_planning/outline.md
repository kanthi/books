# Boring NixOS — Complete Detailed Curriculum & Syllabus

**Title:** Boring NixOS  
**Subtitle:** From Zero to Production — Reproducible Systems at Scale  
**Target Toolchain:** Nix 2.35+ / NixOS 26.05 “Yarara” / Flakes Enabled

---

## Part 00: Introduction — The Reproducibility Crisis

- **`00-introduction/01-the-reproducibility-crisis.qmd`**: *The Reproducibility Crisis*
  - The Heisenbugs That Cost Teams
  - Why Traditional Tooling Fails (Ambient host pollution, implicit path lookups)
  - A Different Approach: Declarative, Immutable Infrastructure
  - What This Book Will Teach You & How to Read It
- **`00-introduction/02-installing-nix.qmd`**: *Installing Nix*
  - Multi-user daemon install, flakes in the daemon `nix.conf`
  - First substitute: `nix run nixpkgs#hello`
  - Pin nixpkgs in a flake lock; do not stack installers
- **`00-introduction/03-installing-nixos.qmd`**: *Installing NixOS*
  - Disposable UEFI VM, partition, `nixos-generate-config`
  - Tiny `configuration.nix`, `stateVersion`, first `nixos-rebuild switch`
  - Rollback via `--rollback` and the bootloader menu

---

## Part 01: Nix Fundamentals — How It Actually Works

- **`01-nix-fundamentals/01-the-store-model.qmd`**: *The Store Model and Content-Addressable Paths*
  - The `/nix/store` anatomy: hashes, package names, outputs
  - Read-only file systems, chroots, and build isolation
  - Content-addressed paths vs input-addressed derivations
- **`01-nix-fundamentals/02-hashes-and-dependencies.qmd`**: *How Hashes Create Deterministic Dependencies*
  - Cryptographic hashing of inputs (sources, patches, build scripts, toolchains)
  - Eliminating dependency hell and ABI drift
  - Purity guarantees: why builds cannot access `/usr` or the open network
- **`01-nix-fundamentals/03-dependency-graphs-and-nix-db.qmd`**: *Dependency Graphs and the Nix Database*
  - Runtime vs build-time dependency closures (`nix-store -q --references`, `--requisites`)
  - The SQLite database (`/nix/var/nix/db/db.sqlite`) tracking references and registration
  - Visualizing closures with `nix-store --graph` and ASCII trees
- **`01-nix-fundamentals/04-garbage-collection.qmd`**: *Garbage Collection and Space Management*
  - Garbage collector roots (`/nix/var/nix/gcroots/` and local `result` symlinks)
  - Cleaning profiles and disk space safely (`nix-collect-garbage -d`)
  - Optimizing the store via hard-link deduplication (`nix-store --optimise`)
- **`01-nix-fundamentals/05-first-nix-expressions.qmd`**: *Your First Nix Expressions*
  - Low-level `derivation` primitive
  - Writing raw `.nix` recipes and evaluating with `nix-instantiate`
  - Building your first standalone store artifact with `nix-build`
- **`01-nix-fundamentals/06-inspecting-the-store/01-why-depends-and-nix-tree.qmd`**: *Inspecting Closures*
  - `nix path-info -Shr`, `nix why-depends`, `nix-store --tree`, `nix-tree`, `nom`

---

## Part 02: The Nix Language — From Basics to Advanced Patterns

- **`02-nix-language/01-expressions-and-evaluation.qmd`**: *Nix Expressions and Evaluation*
  - Pure expression tree model vs imperative scripting
  - Evaluating expressions with `nix eval --expr`
  - Laziness in practice: why unqueried branches never evaluate
- **`02-nix-language/02-values-and-immutability.qmd`**: *Values and Immutability*
  - Deep immutability of data structures
  - Transformations yield new values (`//`, `++`)
  - Deterministic evaluation and thread-safe memoization
- **`02-nix-language/03-data-types-and-strings.qmd`**: *Data Types and String Interpolation*
  - Primitive types: int, float, bool, string, path, null
  - Single-line (`"..."`) and multi-line (`''...''`) strings with indentation stripping
  - String interpolation with `${...}` and path importing into `/nix/store`
- **`02-nix-language/04-let-in-bindings.qmd`**: *Let-In Blocks and Local Bindings*
  - Defining local variables with `let ... in ...`
  - Scope rules and lexical shadowing
  - Pure evaluation: order of bindings does not matter
- **`02-nix-language/05-functions-and-defaults.qmd`**: *Functions and Argument Defaults*
  - Single-argument functions, currying, and lambda syntax (`x: y: ...`)
  - Attribute set pattern matching and destructuring (`{ x, y, ... }`)
  - Default arguments (`{ port ? 3000, debug ? false }`) and `@args` capture
- **`02-nix-language/06-attribute-sets-and-rec.qmd`**: *Attribute Sets and Recursive Definitions*
  - Attribute set syntax, nesting (`a.b.c = 1;`), and merging (`//`)
  - The `rec` keyword and sibling references
  - Avoiding infinite recursion traps and circular definitions
- **`02-nix-language/07-conditionals-and-lists.qmd`**: *Conditionals, Lists, and Built-in Operations*
  - `if ... then ... else ...` expressions
  - Lists, indexing, and concatenation (`++`)
  - Built-in functions: `builtins.map`, `builtins.filter`, `builtins.elem`
  - Writing pure data transformations
- **`02-nix-language/08-imports-and-abstractions.qmd`**: *Importing Files and Building Abstractions*
  - The `import` operator and passing arguments (`import ./config.nix { inherit pkgs; }`)
  - Organizing modular Nix codebases across files
  - Standard library (`pkgs.lib`) utility functions (`lib.mkDefault`, `lib.mkIf`, `lib.optional`)
- **`02-nix-language/09-nix-repl-and-debugging.qmd`**: *The Nix REPL and Debugging Expressions* ← new
  - Interactive evaluation: `:t`, `:e`, `:b`, `:r`, `:?` meta-commands
  - Loading nixpkgs and flakes (`nix repl 'nixpkgs'`, `nix repl .#`)
  - Printf debugging with `builtins.trace`, eval-time vs build-time errors

---

## Part 03: Reproducible Development Environments

- **`03-dev-environments/01-nix-shells-and-devshell.qmd`**: *Nix Shells and the devShell Concept*
  - Ephemeral environments: what `nix-shell` and `nix develop` actually do
  - `pkgs.mkShell` anatomy: `packages`, `buildInputs`, `nativeBuildInputs`
  - `shellHook` for environment variables, prompts, and startup checks
- **`03-dev-environments/02-multi-language-toolchains.qmd`**: *Multi-Language Development Environments*
  - Polyglot stacks: co-locating Go, Rust, Python, Node, and C libraries
  - Managing C headers, `pkg-config`, and shared libraries (`LD_LIBRARY_PATH`)
  - Python isolated environments (`python3.withPackages`) vs traditional virtualenvs
- **`03-dev-environments/03-flakes-for-dev-environments.qmd`**: *Flakes for Reproducible Dev Environments*
  - `flake.nix` structure: `inputs`, `outputs`, and `devShells.${system}.default`
  - `flake.lock`: cryptographic hash pinning of dependencies across the entire team
  - Cross-platform support (`eachDefaultSystem` with `flake-utils`)
- **`03-dev-environments/04-environment-management-home-manager.qmd`**: *Environment Management with Home Manager*
  - Per-user tool suites vs project-specific devShells
  - Installing user utilities declaratively with `home.packages`
  - Integrating project shells with personal shell configurations
- **`03-dev-environments/05-migrating-from-docker-desktop.qmd`**: *Migrating from Docker Desktop to Nix DevShells*
  - Overhead comparison: native Linux/macOS processes vs VM-backed Docker daemons
  - Direct IDE and language server integration (`gopls`, `rust-analyzer`, `pyright`)
  - Fast startup, instant caching, and eliminating file permission / volume mount latency
- **`03-dev-environments/06-direnv-and-automatic-shells.qmd`**: *Automatic Dev Shells with direnv* ← new
  - `direnv` + `nix-direnv`: auto-loading devShell on `cd`, GC-safe caching
  - `use flake` in `.envrc`, polyglot named shells, `.direnv/` gcroot
- **`03-dev-environments/07-nix-darwin-macos.qmd`**: *nix-darwin: Declarative macOS Configuration* ← new
  - `darwinConfigurations` + `darwin-rebuild switch`
  - Shared `commonPackages` across Linux + macOS in one flake, `nix-homebrew`, `system.defaults`
- **`03-dev-environments/08-nix-on-linux.qmd`**: *Nix on a Foreign Linux*
  - Daemon + Home Manager + direnv on Ubuntu/Fedora/Arch; distro keeps the OS
- **`03-dev-environments/09-nix-ld-and-fhs.qmd`**: *Vendor Binaries with nix-ld and FHS Envs*
  - `programs.nix-ld`, `buildFHSEnv` / `steam-run`, no global `LD_LIBRARY_PATH`

---

## Part 04: Package Management and Overlays

- **`04-packages-and-overlays/01-nix-package-manager.qmd`**: The Nix Package Manager in Practice
- **`04-packages-and-overlays/02-flakes-inputs-system.qmd`**: Understanding the Flakes Input System
- **`04-packages-and-overlays/03-creating-composing-overlays.qmd`**: Creating and Composing Overlays
- **`04-packages-and-overlays/04-custom-package-definitions.qmd`**: Custom Package Definitions
- **`04-packages-and-overlays/05-managing-dependencies-across-projects.qmd`**: Managing Dependencies Across Projects
- **`04-packages-and-overlays/06-fetchers-and-fixed-outputs.qmd`**: Fetchers and Fixed-Output Derivations
- **`04-packages-and-overlays/07-nix-path-and-pinning.qmd`**: NIX_PATH, Channels, and Pinning Inputs (`<nixpkgs>`, npins, flake.lock)

---

## Part 05: Building Packages from Source

- **`05-building-from-source/01-derivation-build-process.qmd`**: The Derivation Build Process
- **`05-building-from-source/02-c-cpp-cmake.qmd`**: Building C and C++ Projects with CMake
- **`05-building-from-source/03-rust-cargo.qmd`**: Rust Packages with Cargo (`buildRustPackage`, `crane`)
- **`05-building-from-source/04-python-pip-setuptools.qmd`**: Python Packages with Pip and Setuptools
- **`05-building-from-source/05-go-modules.qmd`**: Go Modules with `buildGoModule` (`vendorHash`, CGO, toolchain pin)
- **`05-building-from-source/06-cross-compilation.qmd`**: Cross-Compilation for Multiple Platforms (`pkgsCross`)
- **`05-building-from-source/07-trivial-builders.qmd`**: Trivial Builders (`writeShellApplication`, `runCommand`, `symlinkJoin`)
- **`05-building-from-source/08-source-filtering.qmd`**: Source Filtering (`fileset`, `cleanSource`)
- **`05-building-from-source/09-patching-packages.qmd`**: Patching Packages (`patches`, `fetchpatch2`, `overrideAttrs`)
- **`05-building-from-source/10-nodejs-packages.qmd`**: Node.js Packages (`buildNpmPackage`, pnpm)
- **`05-building-from-source/11-go-toolchains-gomod2nix.qmd`**: Go Toolchains and gomod2nix (Crane analogue; pin `go`)
- **`05-building-from-source/12-go-devshells.qmd`**: Go Development Environments (`gopls`, `GOTOOLCHAIN=local`)
- **`05-building-from-source/13-go-cross-compilation.qmd`**: Cross-Compiling Go (`GOOS`/`GOARCH`, CGO off)
- **`05-building-from-source/14-packaging-anti-patterns.qmd`**: Packaging Anti-Patterns

---

## Part 06: NixOS — Declarative System Configuration

- **`06-nixos-system/01-module-system-architecture.qmd`**: The NixOS Module System Architecture
- **`06-nixos-system/02-first-nixos-machine.qmd`**: Configuring Your First NixOS Machine
- **`06-nixos-system/03-service-management-systemd.qmd`**: Service Management with systemd
- **`06-nixos-system/04-networking-firewall-security.qmd`**: Networking, Firewall, and Security
- **`06-nixos-system/05-users-groups-ssh.qmd`**: Users, Groups, and SSH Configuration
- **`06-nixos-system/06-hardware-drivers.qmd`**: Hardware Configuration and Drivers
- **`06-nixos-system/07-disko-declarative-disk-partitioning.qmd`**: Declarative Disk Partitioning with Disko
- **`06-nixos-system/08-ephemeral-roots-and-impermanence.qmd`**: Ephemeral Roots and Impermanence
- **`06-nixos-system/09-nixos-generators.qmd`**: Image Generation with nixos-generators ← new
  - `nixosGenerate` for ISO, QEMU qcow2, Raspberry Pi SD card, cloud images
  - Shared module pattern between live systems and image pipelines
- **`06-nixos-system/10-backups-and-generation-hygiene.qmd`**: Backups and Generation Hygiene
  - Restic of `/persist` and service state; restore drills; GC windows; ESP `configurationLimit`

---

## Part 07: Home Manager — User-Level Declarative Configuration

- **`07-home-manager/01-module-system-user-space.qmd`**: Home Manager and the Module System
- **`07-home-manager/02-declarative-dotfiles.qmd`**: Managing Dotfiles Declaratively
- **`07-home-manager/03-shell-and-editor.qmd`**: Shell and Editor Configuration
- **`07-home-manager/04-application-settings.qmd`**: Application Settings and Preferences
- **`07-home-manager/05-combining-nixos-and-home-manager.qmd`**: Combining NixOS and Home Manager

---

## Part 08: CI/CD with Nix — Build Pipelines That Actually Work

- **`08-cicd/01-binary-caches.qmd`**: Setting Up Binary Caches (Cachix, Attic, Harmonia)
- **`08-cicd/02-github-actions-with-nix.qmd`**: GitHub Actions with Nix
- **`08-cicd/03-gitlab-ci.qmd`**: GitLab CI Integration
- **`08-cicd/04-build-caching-strategies.qmd`**: Build Caching Strategies
- **`08-cicd/05-testing-in-ci-pipelines.qmd`**: Testing in CI Pipelines
- **`08-cicd/06-secrets-management-in-ci.qmd`**: Secrets Management in CI
- **`08-cicd/07-remote-builders.qmd`**: Remote Builders
  - `nix.buildMachines`, `ssh-ng`, `builders-use-substitutes`, Darwin→Linux, KVM features

---

## Part 09: Containers and Kubernetes with Nix

- **`09-containers-k8s/01-container-images-with-nix.qmd`**: Creating Container Images with Nix (`dockerTools`)
- **`09-containers-k8s/02-kubernetes-manifests-as-modules.qmd`**: Kubernetes Manifests as Nix Modules
- **`09-containers-k8s/03-helm-charts-from-nix.qmd`**: Helm Charts Generated from Nix
- **`09-containers-k8s/04-gitops-argo-flux.qmd`**: GitOps with Argo CD and Flux
- **`09-containers-k8s/05-service-mesh-observability.qmd`**: Service Mesh and Observability

---

## Part 10: Infrastructure as Code — Terraform, OpenTofu, and Beyond

- **`10-iac/01-terraform-providers-with-nix.qmd`**: Managing Terraform Providers with Nix
- **`10-iac/02-opentofu-integration.qmd`**: OpenTofu Integration
- **`10-iac/03-ansible-provisioning.qmd`**: Ansible Provisioning with Nix
- **`10-iac/04-cloud-provider-config.qmd`**: Cloud Provider Configuration
- **`10-iac/05-multi-cloud-deployment.qmd`**: Multi-Cloud Deployment Patterns

---

## Part 11: Secrets Management and Security

- **`11-secrets-security/01-why-secrets-are-hard.qmd`**: Why Secrets Are Hard with Declarative Config
- **`11-secrets-security/02-sops-nix.qmd`**: Using SOPS for Encrypted Configuration (`sops-nix`)
- **`11-secrets-security/03-vault-integration.qmd`**: HashiCorp Vault Integration
- **`11-secrets-security/04-age-encryption.qmd`**: Age Encryption for Simple Secrets
- **`11-secrets-security/05-security-hardening.qmd`**: Security Hardening Patterns

---

## Part 12: Platform Engineering at Scale

- **`12-platform-engineering/01-internal-developer-platform.qmd`**: The Internal Developer Platform Pattern
- **`12-platform-engineering/02-monorepo-strategies.qmd`**: Monorepo Strategies with Nix
- **`12-platform-engineering/03-multi-platform-distribution.qmd`**: Multi-Platform Development and Distribution
- **`12-platform-engineering/04-build-optimization-tuning.qmd`**: Build Optimization and Performance Tuning
- **`12-platform-engineering/05-debugging-troubleshooting.qmd`**: Debugging and Troubleshooting Production Issues
- **`12-platform-engineering/06-testing-strategies.qmd`**: Testing Strategies for Nix Configurations
- **`12-platform-engineering/07-maintenance-upgrades-migration.qmd`**: Maintenance, Upgrades, and Migration
- **`12-platform-engineering/08-enterprise-operational-checklists.qmd`**: Enterprise Operational Checklists
- **`12-platform-engineering/09-fleet-deployments-colmena.qmd`**: Fleet Deployments with Colmena
- **`12-platform-engineering/10-microvms-and-virtualisation.qmd`**: MicroVMs and Virtualisation
- **`12-platform-engineering/11-content-addressed-nix-internals.qmd`**: Content-Addressed Nix Internals

---

## Part 13: Production Capstone — Zero-Trust Fleet

- **`13-production-capstone/01-enterprise-architecture-and-threat-model.qmd`**: Enterprise Architecture and Threat Model
- **`13-production-capstone/02-disko-storage-and-ephemeral-base.qmd`**: Disko Storage and Ephemeral Base
- **`13-production-capstone/03-hardened-network-and-vpn-mesh.qmd`**: Hardened Network and VPN Mesh
- **`13-production-capstone/04-distributed-application-stack.qmd`**: Distributed Application Stack
- **`13-production-capstone/05-automated-fleet-rollout-and-disaster-recovery.qmd`**: Automated Fleet Rollout and Disaster Recovery

---

## Appendices

- **`99-appendices/01-glossary.qmd`**: Glossary of Nix and NixOS Terms
- **`99-appendices/02-command-cheat-sheet.qmd`**: Command Cheat Sheet
- **`99-appendices/03-nix-version-reference.qmd`**: Nix and NixOS Version Reference ← new
  - Nix CLI 2.18–2.35 feature additions and reproducible examples
  - NixOS 23.05–26.05 system changes and module configurations

