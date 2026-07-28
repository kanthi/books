# Source consolidation map (expert-curated)

The published syllabus is **not** a mechanical average of the three Downloads files.  
It is an **expert learning path** for Nix + NixOS (baseline 26.05), using those documents as topic inventories and day-level prompts.

## Inputs (topic inventory only)

| Source | Path | Used for |
|--------|------|----------|
| Personal session notes (NixOS) | private notes | Day-level prompts, 26.05 edition notes, mini-projects, tooling names (Disko, deploy-rs, Colmena, sops-nix, …) |
| Personal depth checklists | private notes | Language/store/module/HM **depth checklists**, weekly review habit, troubleshooting taxonomy |
| **Nix and NixOS Syllabus** PDF | `Nix and NixOS Syllabus.pdf` | Production stack bar, multi-node capstone, CI/cache/hardening themes |

## Expert decisions (where sources disagreed)

| Decision | Session 2 | Zai | PDF | **Book choice** |
|----------|-----------|-----|-----|-----------------|
| Language-only front load | ~12 days mixed with store/CLI | **21 days** language before OS | Modules before flakes in one outline | **~1 week** language+store+CLI with real REPL/build work — not 3 weeks theory |
| First NixOS install | Day 13 | Day 44 | Mid curriculum | **Week 2** — OS skills early |
| Flakes timing | After non-flake host | Before OS | Dedicated modern phase | **Flakes-enabled from day 1; first host is flake-based** (no long classic-only detour) |
| Classic CLI | Explicit days | Implicit | Legacy + new | Literacy **after** modern CLI, not the default workflow |
| Module type catalog | Light early | Full week mid-OS | Module system emphasis | **Just enough early; full types after 1–2 real modules** |
| Home Manager | With flakes mid | Days 78–84 | Own module | **With first flake host** (user layer soon after system layer) |
| Packaging deep dive | Phase 4 mid | Early with store | Mid–late modules | **After** you consume packages on a real host |
| App zoo (Nextcloud, Matrix, …) | Older tables | Service patterns only | Capstone ideas | **Patterns only** — proxy, DB, CI, obs — not product catalog |
| Capstone | devops-lab style | Synthesis day | Immutable multi-node | **A required; B stretch** |
| Go parallel track | Same 90-day file | Same | N/A | **Out of this book**; see syllabus note on dual-track study |

## Archive

`_archive-pre-scratch/` = pre-scratch multi-syllabus exploration — not the contract for chapters.
