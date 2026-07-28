# 90DaysOfX — planning notes

## Product shape

- **One Quarto book** on the portal: `90DaysOfX`
- **Volumes** = independent numbered parts under `content/` (`01-go`, `02-nixos`, …)
- Readers take **one volume at a time** by default; no prescribed joint timetable
- Future: add `03-rust`, `04-kubernetes`, etc. with the same skeleton

## Relationship to standalone books

| Standalone | Role vs 90DaysOfX |
|------------|-------------------|
| `books/Go/` | Large topic library / long-form notes |
| `books/NixOS/` | Journey notes aligned with expert Nix path |
| `books/90DaysOfX/` | **Series container** for independent volume spines/syllabi |

Avoid duplicating full chapter bodies in two places until a deliberate sync strategy exists. Syllabi may be mirrored or linked in prose.

## Source inventories (not calendars of record)

- `/Users/king/Downloads/90 Days of X.md` — Session 2 Go + NixOS day tables  
- `/Users/king/Downloads/90 Days of X Zai.md` — depth checklists  
- `/Users/king/Downloads/Nix and NixOS Syllabus.pdf` — Nix production stack bar  

Expert ordering lives in each sub-book syllabus chapter.
