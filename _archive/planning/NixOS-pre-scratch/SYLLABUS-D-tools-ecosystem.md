# Syllabus D — Tools & ecosystem map (personal + production)

**Voice:** Catalog of **what people actually run**, then map learning order onto tools.  
**Not a path alone**—use with A/B/C. Exploration only.  
**Baseline:** ecosystem as of **2026**, NixOS **26.05**.

## Thesis

A “complete” NixOS book must eventually cover **core platform + adjacent tools** that dominate configs worldwide. This syllabus is organized by **tool domains**, not chapters of narrative.

---

## 1. Core platform (must cover)

| Tool / concept | Personal | Production | Notes |
|----------------|----------|------------|--------|
| **Nix** (package manager + store) | ✓ | ✓ | Foundation |
| **Nix language** | ✓ | ✓ | |
| **nixpkgs** | ✓ | ✓ | pin strategy |
| **NixOS module system** | ✓ | ✓ | |
| **nixos-rebuild** / system activation | ✓ | ✓ | |
| **Channels** (literacy) | ✓ | ✓ | legacy but still appears |
| **Flakes** + `flake.lock` | ✓ | ✓ | de-facto project structure |
| **nix-command** modern CLI | ✓ | ✓ | |
| **Binary cache** (cache.nixos.org) | ✓ | ✓ | trust model |

## 2. Config & UX tooling

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| **Home Manager** | ✓✓ | ✓ | workstations + server users |
| **nix-darwin** | ✓ | ~ | macOS fleet |
| **direnv** + **nix-direnv** | ✓✓ | ✓ | dev UX |
| **devenv** | ✓ | ~ | higher-level shells |
| **flake-parts** | ✓ | ✓ | large flakes |
| **flake-utils** | ✓ | ✓ | still common |
| **nh** / **nvd** / rebuild helpers | ✓ | ~ | nicer rebuild UX |
| **nixos-generators** | ✓ | ✓ | images/ISOs |
| **disko** | ✓ | ✓ | declarative disks |
| **impermanence** | ✓ | ✓ | tmpfs root patterns |
| **stylix** / theming modules | ✓ | | optional desktop |
| **lanzaboote** / secure boot | ✓ | ✓ | modern boots |

## 3. Secrets & identity

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| **sops-nix** | ✓ | ✓✓ | very common |
| **agenix** / **ragenix** | ✓ | ✓ | age-based |
| **vault / OIDC** integration patterns | | ✓ | org-scale |
| **SSH CA / ssh-keys in config** | ✓ | ✓ | |

## 4. Deploy & multi-host

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| `nixos-rebuild --target-host` | ✓ | ✓ | simplest |
| **deploy-rs** | ✓ | ✓ | popular |
| **colmena** | ✓ | ✓ | hive-style |
| **clan** / inventory frameworks | ~ | ✓ | emerging |
| **Morph** / others | | ~ | awareness |
| **GitOps** (push flake, CI build, pull) | ✓ | ✓✓ | pattern > product |

## 5. CI / caches / builders

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| **GitHub Actions** + Nix | ✓ | ✓ | |
| **Forgejo/Gitea Actions**, GitLab CI | ✓ | ✓ | |
| **Cachix** | ✓ | ✓ | easy private/public |
| **Attic** | ✓ | ✓ | self-host cache |
| **Harmonia** / nix-serve family | | ✓ | self-host substituter |
| **Hydra** | | ✓ | org CI/cache (heavy) |
| **Remote builders** | ✓ | ✓ | |
| **nix flake check** | ✓ | ✓ | |
| **nixpkgs-review** | ✓ | ✓ | contrib |

## 6. Containers, VMs, cloud artifacts

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| **dockerTools** / **nix2container** | ✓ | ✓ | OCI images |
| **podman** on NixOS | ✓ | ✓ | |
| **microvm.nix** | ✓ | ✓ | light VMs |
| **nixos-generators** cloud images | | ✓ | AWS/GCP/Azure images |
| **Kubernetes** + Nix | | ✓ | optional deep track |
| **terraform/opentofu** + Nix | ✓ | ✓ | companion, not Nix-only |

## 7. Packaging & development

| Tool | Personal | Production | Notes |
|------|----------|------------|--------|
| **stdenv** / language builders | ✓ | ✓ | |
| **crane** (Rust) | ✓ | ✓ | |
| **uv2nix / poetry2nix** etc. | ✓ | ✓ | Python |
| **buildGoModule** | ✓ | ✓ | |
| **overlays** / private package sets | ✓ | ✓ | |
| **npins** / **niv** | ✓ | ✓ | non-flake pins |

## 8. Homelab / self-host popular stack (illustrative)

Not mandatory products—**categories** to eventually cover via *your* choices:

- Reverse proxy: nginx, Caddy, Traefik  
- Auth: Authelia, Kanidm, Keycloak (prod)  
- Media/data: Immich, Nextcloud, Jellyfin, Postgres  
- Monitoring: Prometheus, Grafana, Loki, VictoriaMetrics  
- Git: Forgejo, Gitea, GitLab  
- DNS/VPN: AdGuard/Unbound, Tailscale/Headscale, WireGuard  
- Backup: restic, borg, zfs snapshots  

Each service chapter: **NixOS module options + secrets + backup + upgrade notes**.

## 9. Desktop / laptop (personal worldwide)

- Display managers / compositors (GNOME 50 on 26.05 train, KDE, Sway/Hyprland)  
- GPU (NVIDIA open modules saga—document carefully, version-sensitive)  
- Audio (PipeWire)  
- Flatpak coexistence patterns  
- Secure Boot (lanzaboote)  

## 10. Suggested learning order *through* tools

1. Nix CLI + store  
2. NixOS module options + rebuild  
3. Flakes  
4. Home Manager + direnv  
5. Disko  
6. sops-nix **or** agenix  
7. Second host + deploy-rs **or** colmena **or** SSH rebuild  
8. Cachix/Attic + CI  
9. dockerTools / generators  
10. Homelab service modules as needed  
11. Overlays/private pkgs  
12. Hydra / remote builders (if org needs)

## 11. Coverage metric for the book

For each tool row: **Not started / Conceptual / Hands-on notes / Production story**.  
Goal: no “everyone uses this” blank forever—either cover or list under exclusions with reason.
