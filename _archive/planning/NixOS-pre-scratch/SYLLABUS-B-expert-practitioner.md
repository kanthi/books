# Syllabus B — Expert practitioner (spiral depth)

**Voice:** Senior NixOS operator writing the path they wish they had.  
**Does not replace:** `SYLLABUS.md` (A). Exploration only.  
**Baseline:** NixOS **26.05**.

## Thesis

Most beginners fail by **collecting modules before models**. Experts think in: **eval graph → store graph → activation → runtime Linux**. This syllabus spirals: each arc re-visits store, language, and system at higher fidelity.

## Principles (expert consensus, compressed)

- Language fluency is the highest leverage skill (repeated on Discourse / nix.dev).  
- Prefer **declarative long-lived state**; avoid `nix-env` as lifestyle.  
- **Flakes for projects**; understand non-flake pins so docs still make sense.  
- Single-host rollback competence before deploy tools.  
- Secrets never enter the store as plaintext.  
- When activation fails, debug **Linux + activation**, not only expressions.

## Spiral arcs

### Arc 0 — Orientation (1–2 sittings)

1. Three layers: language / Nix / NixOS  
2. Store path anatomy; immutability  
3. Eval vs realize (draw it once)  
4. 26.05 landscape: stage-1 systemd, release trains  

### Arc 1 — Language until dangerous

1. Attrsets & functions until reading `nixpkgs` snippets is OK  
2. Laziness + REPL as primary debugger  
3. `lib` patterns (`mapAttrs`, `optional`, `mkIf` preview)  
4. **Lab:** pure helper library (no packaging yet)

### Arc 2 — Consumer Nix

1. Modern CLI map; what not to use long-term  
2. Pinning (flake lock primary)  
3. Shells + direnv  
4. **Lab:** pin a real toolchain (`nix develop`)

### Arc 3 — One OS, operator-grade

1. Install 26.05; hardware config vs owned config  
2. Rebuild modes; generation recovery **muscle memory**  
3. Users, net, firewall, 2+ services  
4. System GC vs generation retention  
5. **Lab:** break activation; recover under time pressure  

### Arc 4 — Workspace unification

1. Flake inputs/outputs/`follows`  
2. `nixosConfigurations` + `devShells` one repo  
3. Modular flake layout / flake-parts when pain appears  
4. **Lab:** flake check green for claimed outputs  

### Arc 5 — Workstation as infrastructure

1. Home Manager integration choice  
2. Dotfiles as modules  
3. Optional nix-darwin / shared modules  
4. **Lab:** reinstall user env from git alone  

### Arc 6 — Producer skills

1. `stdenv` phases + FOD  
2. One language ecosystem end-to-end  
3. Overlay vs override discipline  
4. **Lab:** package something missing/private  

### Arc 7 — System authoring

1. Module system (options, merge, force)  
2. Disko / install reproducibility  
3. Secrets (sops-nix / agenix class)  
4. **Lab:** secret-backed service on one host  

### Arc 8 — Multi-node operator

1. Multi-host flake  
2. Deploy mechanism (SSH rebuild / deploy-rs / colmena)—pick one deep  
3. Binary cache + CI  
4. Images/containers where useful  
5. Observability + hardening basics  
6. **Lab:** two hosts, one flake, one cache story  

### Arc 9 — Internals on demand

1. `.drv`, profiles, GC root forensics  
2. CA-derivations awareness  
3. Classic vs Determinate vs Lix literacy updates  
4. **Lab:** diagnose a “mystery” store/eval issue  

## What this path deliberately de-emphasizes early

- Desktop ricing, full GPU/ML stacks  
- Every deploy tool equally  
- Full Hydra admin before personal cache  

## Expert “definition of done”

You can onboard a second machine from git, recover a bad generation, explain why a rebuild is slow (eval vs build vs download), and keep secrets out of `/nix/store`.
