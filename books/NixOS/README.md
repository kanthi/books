# NixOS

Personal **journey notes** on Nix & NixOS as a **topic-oriented book** (parts and chapters), not a day calendar.

**Baseline:** NixOS **26.05 “Yarara”** (as of mid-2026).  
Not a certification course. Day-paced curriculum, if you want one, is a separate monorepo track—not this book’s structure.



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
