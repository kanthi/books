# Syllabus E — Community consensus path (Reddit / Discourse / X signals)

**Voice:** Synthesize **what people recommend repeatedly**, not one guru.  
**Exploration only.** Baseline **26.05**.

## Recurring community advice (compressed)

Drawn from long-running r/NixOS themes, Discourse guides, and public learning chatter:

1. **Use a VM first**—don’t learn by nuking the only laptop.  
2. **Accept the learning curve**; push through language + options search.  
3. **Flakes are not strictly mandatory**, but most modern guides assume them; many say “learn enough non-flake to read old docs.”  
4. **Home Manager** is optional but ubiquitous for dotfiles; many struggle combining flakes + HM too early—either go slow or follow one full guide end-to-end.  
5. **search.nixos.org** (packages *and* options) is the real IDE.  
6. **Copy a minimal flake**, then change one thing at a time.  
7. Prefer **small working systems** over perfect abstraction.  
8. Read **module source** when options confuse you.  
9. Document **generations** that saved you.  
10. Homelab: host services you actually use; break and fix them.

X/dev chatter often adds: treat flakes as input→output functions; spend time on language basics (nix.dev language tutorial); LLM-assisted config is common but verify against manuals.

## Community-shaped path

### Week-shaped phases (flexible)

#### Phase 1 — Survive install

- NixOS install in VM (26.05)  
- SSH, user, rebuild once  
- **Avoid:** perfect flake structure day one  

#### Phase 2 — Daily mechanics

- Options search; enable 1–2 services  
- Rollback drill  
- GC awareness  

#### Phase 3 — Language enough to edit confidently

- nix.dev language tutorial  
- attrsets/functions/let/import  
- REPL practice  

#### Phase 4 — Pinning without pain

- Introduce flakes *or* solid channel/npins story  
- If flakes: single-host flake from a trusted minimal template  
- Lockfile habit  

#### Phase 5 — Dev loop

- `nix develop` / direnv on a real project  
- Stop installing compilers globally  

#### Phase 6 — Home Manager

- Integrate HM **after** system rebuild is boring  
- Dotfiles migration in slices  

#### Phase 7 — Structure

- Split configs; flake-parts only if files hurt  
- Secrets tool once you have a secret  

#### Phase 8 — Real self-hosting

- Reverse proxy + one data service + backups  
- Monitoring optional but praised  

#### Phase 9 — Multi-machine / prod curiosity

- Second host  
- Cache + CI for the flake  
- Deploy tool when SSH rebuild is annoying  

#### Phase 10 — Contribute / package

- One overlay or package  
- Optional nixpkgs PR literacy  

## Explicit “community footguns” chapter list

1. Flakes + HM + nixos-rebuild all at once on day 1  
2. Imperative `nix-env` as long-term state  
3. Secrets in git or store  
4. Blind `nix-collect-garbage -d`  
5. Giant single `configuration.nix` forever  
6. Disabling sandbox to “fix builds”  
7. Following outdated channel-only tutorials on 26.05 without checking release notes  

## Why this syllabus exists

To compare against A/B: does your book want **consensus onboarding** or **expert-optimal** ordering? Community path optimizes for **not rage-quitting**.
