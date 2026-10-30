# BYOL — Build Your Own Linux

**A Complete Step-by-Step Guide to Designing, Building, and Publishing a Custom Linux Operating System**

A systematic, production-grade guide to engineering a Linux operating system from bare source code to a bootable, modern, reproducible distribution.

---

## What This Book Covers

- **Foundations & Architecture:** The anatomy of distributions, FHS & Usr-Merge, Linux monolithic architecture, key kernel subsystems, and `.config` workflows.
- **Toolchain Engineering:** Multi-pass bootstrapping, binutils, GCC/Clang, `glibc` vs `musl-libc`, and hardened toolchain flags.
- **Boot Chain & Initialization:** UEFI/BIOS firmware, GRUB & systemd-boot, custom initramfs authoring, init systems (`systemd`, `OpenRC`, `s6`, `runit`, `BusyBox`).
- **Package Management:** Packaging formats (`.deb`, `.rpm`, `.pkg.tar.zst`, `.apk`), custom binary repositories, and SAT-based dependency solvers (`libsolv`).
- **Build Pipelines & Desktop:** Declarative recipes (`BYOLBUILD`), autotools/cmake/meson+ninja, cross-compilation, reproducible builds, Wayland vs X11, Sway/wlroots desktop stack.
- **Security & ISO Mastering:** Capabilities, namespaces, cgroups v2, SELinux/AppArmor MAC, Secure Boot trust chains, LUKS full-disk encryption, nftables, eBPF/XDP, hybrid bootable ISO authoring with `xorriso` and SquashFS.
- **CI/CD & Maintenance:** Container buildroots (`systemd-nspawn`), Koji/buildd build farms, rolling vs LTS release engineering, and CVE patch backporting.
- **Capstone Project:** Full end-to-end laboratory building, verifying, and publishing the BYOL distribution.

---

## Directory Layout

```text
books/BYOL/
├── index.qmd                 # Book preface and introduction
├── content/
│   ├── 00-introduction/      # Why build your own distribution?
│   ├── 01-anatomy-of-a-linux-system/
│   ├── 02-understanding-the-linux-kernel/
│   ├── 03-the-toolchain/
│   ├── 04-boot-process-and-bootloaders/
│   ├── 05-system-initialization/
│   ├── 06-package-management/
│   ├── 07-package-build-pipeline/
│   ├── 08-desktop-environments/
│   ├── 09-security-foundations/
│   ├── 10-iso-creation-and-installation/
│   ├── 11-automation-cicd-build-infrastructure/
│   ├── 12-maintenance-and-release-engineering/
│   ├── 13-capstone-project/  # End-to-end distribution build lab
│   ├── 99-afterword/         # Conclusion and references
│   └── _planning/            # SYLLABUS.md
├── images/                   # Illustrated SVGs and diagrams
├── scripts/
│   └── update-index.sh       # Regenerates _quarto.yml
├── styles/                   # Light/dark SCSS & epub CSS
└── _quarto.yml               # Generated Quarto config
```

---

## Rendering and Preview

From the repository root or `books/`:

```bash
# Refresh Quarto index
cd books/BYOL && bash scripts/update-index.sh

# Single-book render (HTML, PDF, EPUB)
cd ../ && ./indipub.sh BYOL

# Local preview in Safari
./indiprev.sh BYOL
```
