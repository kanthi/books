# Syllabus G — Homelab → production-minded

**Voice:** Self-hoster who grows into SRE habits.  
**Exploration only.** Baseline **26.05**.

## Thesis

Personal NixOS worldwide is mostly **homelab + laptop**. Production NixOS is the same primitives with **multi-node, secrets, caches, CI, and policy**. Teach by growing a lab that becomes “prod-shaped.”

## Stage 0 — Platform

- Lab hypervisor; networking; DNS name for services  
- NixOS 26.05 server ISO minimal  

## Stage 1 — Single node OS

- Declarative users, SSH, firewall  
- Automatic rebuilds from git (manual push first)  
- Rollback drill  

## Stage 2 — Ingress & certificates

- Reverse proxy module  
- ACME/DNS-01 patterns  
- **Tools:** nginx/Caddy/Traefik (pick one deep)

## Stage 3 — Data services

- PostgreSQL (or equivalent)  
- One app with state (e.g. Forgejo, Immich, Nextcloud—your choice)  
- Backup restore test (restic/borg/zfs)  

## Stage 4 — Identity

- SSO or simple auth front (Authelia/Kanidm/etc. optional)  
- Secrets via sops-nix/agenix  

## Stage 5 — Observability

- Metrics + logs + alerts for lab  
- **Tools:** Prometheus/Grafana/Loki or simpler healthchecks  

## Stage 6 — Developer platform on Nix

- Flake monorepo for all hosts  
- devShells for app development  
- CI builds host closures  

## Stage 7 — Binary cache

- Personal cache so lab rebuilds don’t hammer upstream  
- Signed paths  

## Stage 8 — Second node / HA-ish

- Second machine (replica services or split roles)  
- Deploy tool  
- Failure drill: kill node, recover  

## Stage 9 — Supply chain & hardening

- Pinning, update cadence, reboot strategy  
- SBOM/vuln scanning awareness  
- Minimal attack surface  

## Stage 10 — Optional cloud

- Image to cloud with nixos-generators  
- Remote builder  

## Mapping to “every topic eventually”

Homelab stages **force** modules, secrets, networking, storage, packaging (sometimes), flakes, and deploy—without abstract enterprise chapters first. Production chapters are **generalizations** of lab pain.

## Deliverables per stage

Each stage ends with: architecture sketch, flake paths, secrets layout, restore test note, “what broke.”
