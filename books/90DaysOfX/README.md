# 90DaysOfX

Multi-volume **learning series** (Quarto book). Each volume is **independent**—readers pick one path at a time; there is no required joint schedule.

| Part | Path | Role |
|------|------|------|
| Program | `content/00-program/` | Series rules, pacing, how to add volumes |
| **Go** | `content/01-go/` | Volume 1 — Days 1–90 + **TinyGo elective** (`92`–`96`) |
| **NixOS** | `content/02-nixos/` | Volume 2 — Lab 0 + Days 1–90 |
| **Maths** | `content/03-maths/` | Volume 3 — scratch → discrete math for CS (Days 1–90) |

Future volumes: add `content/03-<name>/` with the same overview + syllabus pattern, then `bash scripts/update-index.sh`.

**Baselines (as of mid-2026):** Go 1.26.x · NixOS 26.05 “Yarara”.

Standalone monorepo books `Go` and `NixOS` remain deeper libraries; this book is the **series container** for volume spines.

## Diagrams

`images/*.svg` — transparent background, stroke/text `#7a8fa6` (theme-agnostic for light/dark Quarto HTML; not `currentColor`).

Includes: Go artifacts/toolchain/slices/GMP/channels/HTTP middleware/TinyGo stack; Nix lab host/store/eval/GC/flake-layout/sops/module-merge/deploy/disko.

## Commands

```bash
bash scripts/update-index.sh
quarto preview
# from books/:
./indipub.sh 90DaysOfX
```
