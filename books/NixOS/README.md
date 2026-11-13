# NixOS

Personal **journey notes** on Nix & NixOS as a **topic-oriented book** (parts and chapters), not a day calendar or certification track.

**Baseline:** Nix **2.35** (upstream **2.35.6**; 26.05 packages **2.35.3**), NixOS **26.05 “Yarara”** (checked 13 November 2026). 26.11 “Zokor” is scheduled, not the pin.

Parts are numbered uniquely (`01-concepts`, `02-nix-on-linux`, `03-nixos-host`, … `09-capstone`, `99-projects`). Fedora dual-stack learners start with Concepts → Nix on Linux.



## Canonical syllabus

| Path | Role |
|------|------|
| `content/00-front-matter/00-syllabus.qmd` | **Published** expert-path syllabus (source of truth) |
| `content/00-front-matter/01a`–`01e-lab-*.qmd` | **Lab 0**: single-server KVM lab, dev machine, Elitebook 2570p profile |
| `content/99-projects/` | Hands-on: derivations + custom distro (branding, ISO, themes) |
| `content/_planning/SOURCES.md` | How research notes were used (and what was rejected) |
| `content/_planning/_archive-pre-scratch/` | Pre-scratch multi-syllabus exploration (not published) |

Narrative chapters follow the syllabus; **projects** are optional deep end-to-end builds.

## Commands

```bash
bash scripts/update-index.sh
quarto preview
# from books/:
./indipub.sh NixOS
```
