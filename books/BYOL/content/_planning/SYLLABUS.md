# BYOL — Master Syllabus & Engineering Roadmap

> **Book Title:** BYOL: Build Your Own Linux  
> **Subtitle:** A Complete Step-by-Step Guide to Designing, Building, and Publishing a Custom Linux Operating System  
> **Author:** K19G  
> **Format:** Multi-format Quarto Book (HTML, PDF, EPUB)  
> **Target Audience:** Systems engineers, kernel enthusiasts, DevOps/SREs, infrastructure architects, and curious developers.

---

## Curriculum Overview

This curriculum guides the reader through every layer of operating system distribution engineering: from cross-compiling the GNU/musl toolchain from source, configuring and compiling the Linux kernel, constructing an initramfs, mastering system initialization (systemd, OpenRC, s6, runit, BusyBox), creating a custom package management ecosystem with SAT-based dependency resolution, building desktop environments, hardening the OS with modern security mechanisms (LUKS, SELinux/AppArmor, eBPF, Secure Boot), to automated ISO mastering and packaging build pipelines.

The book culminates in an end-to-end Capstone Project where the reader builds, tests, brands, and publishes a bootable, modern Linux distribution from scratch.

---

## Detailed Table of Contents

### Introduction: Why Build Your Own Distribution?
- `01-what-from-scratch-really-means.qmd` — What “From Scratch” Really Means
- `02-who-should-build-a-distribution.qmd` — Who Should Build a Distribution?
- `03-how-to-read-this-book.qmd` — How to Read This Book

### Chapter 1: The Anatomy of a Linux System
- `01-what-makes-a-distribution.qmd` — What Makes a Distribution a Distribution
- `02-filesystem-hierarchy-standard.qmd` — The Filesystem Hierarchy Standard and Its Variants
- `03-essential-components.qmd` — Essential Components Every Distro Needs
- `04-case-study-comparing-layouts.qmd` — Case Study: Comparing Debian, Arch, Alpine, and Fedora Layouts

### Chapter 2: Understanding the Linux Kernel
- `01-monolithic-architecture.qmd` — Monolithic Architecture with Modular Extensions
- `02-key-subsystems.qmd` — Key Subsystems: Process Management, Memory, VFS, Networking
- `03-kernel-configuration-and-dotconfig.qmd` — Kernel Configuration and the .config Workflow
- `04-troubleshooting-kernel-panics.qmd` — Troubleshooting: Diagnosing Kernel Panics

### Chapter 3: The Toolchain: Building the Compiler Stack
- `01-what-a-toolchain-is.qmd` — What a Toolchain Is and Why It Matters
- `02-the-bootstrap-process.qmd` — The Bootstrap Process: Pass One and Pass Two
- `03-glibc-vs-musl.qmd` — glibc vs. musl: Choosing Your C Standard Library
- `04-case-study-alpine-musl-toolchain.qmd` — Case Study: Alpine’s musl-Based Hardened Toolchain
- `05-troubleshooting-toolchain-builds.qmd` — Troubleshooting: Toolchain Build Failures

### Chapter 4: Boot Process and Bootloaders
- `01-power-on-to-shell.qmd` — From Power-On to Shell: The Full Boot Chain
- `02-bios-uefi-and-esp.qmd` — BIOS, UEFI, and the EFI System Partition
- `03-grub-systemd-boot-and-bootloaders.qmd` — GRUB, systemd-boot, and Other Bootloaders
- `04-creating-custom-initramfs.qmd` — Creating a Custom Initramfs
- `05-troubleshooting-boot-chain-failures.qmd` — Troubleshooting: Boot Chain Failures

### Chapter 5: System Initialization
- `01-history-of-init-systems.qmd` — A Brief History of Init Systems
- `02-deep-dive-systemd.qmd` — Deep Dive: systemd Targets, Units, and Dependencies
- `03-openrc-dependency-management.qmd` — OpenRC: Dependency-Based Service Management
- `04-s6-and-runit-minimalist-init.qmd` — s6 and runit: The Minimalist Approach
- `05-busybox-init-for-bare-minimum.qmd` — BusyBox Init for Bare-Minimum Systems
- `06-case-study-openrc-vs-systemd.qmd` — Case Study: Alpine’s OpenRC vs. Debian’s systemd
- `07-troubleshooting-init-failures.qmd` — Troubleshooting: Init System Failures

### Chapter 6: Package Management: The Heart of Distribution Identity
- `01-packaging-formats-compared.qmd` — Packaging Formats Compared: .deb, .rpm, .pkg.tar.zst, .apk
- `02-repository-structure-and-metadata.qmd` — Repository Structure and Metadata
- `03-dependency-resolution-algorithms.qmd` — Dependency Resolution Algorithms
- `04-creating-a-custom-repository.qmd` — Creating a Custom Repository
- `05-case-study-debian-solver.qmd` — Case Study: How Debian’s Solver Works
- `06-troubleshooting-repository-package-managers.qmd` — Troubleshooting: Repository and Package Manager Issues

### Chapter 7: The Package Build Pipeline
- `01-specifying-sources-and-patches.qmd` — Specifying Sources, Dependencies, and Patches
- `02-build-systems-autotools-meson-cmake.qmd` — Build Systems: autotools, meson, cmake, meson+ninja
- `03-cross-compilation-of-packages.qmd` — Cross-Compilation of Packages
- `04-reproducible-builds-and-determinism.qmd` — Reproducible Builds and Determinism
- `05-qa-testing-and-linting.qmd` — Quality Assurance: Testing and Linting
- `06-troubleshooting-build-pipeline-issues.qmd` — Troubleshooting: Build Pipeline Issues

### Chapter 8: Desktop Environments, Window Managers, and the User Experience
- `01-x11-vs-wayland.qmd` — X11 vs. Wayland: Architecture and Trade-offs
- `02-display-managers-and-session-management.qmd` — Display Managers and Session Management
- `03-popular-des-and-wms.qmd` — Popular DEs and WMs: GNOME, KDE Plasma, i3, sway
- `04-building-minimal-desktop-from-source.qmd` — Building a Minimal Desktop from Source Components
- `05-theming-fonts-and-localization.qmd` — Theming, Fonts, and Localization
- `06-troubleshooting-desktop-environment-issues.qmd` — Troubleshooting: Desktop Environment Issues

### Chapter 9: Security Foundations for Your Distribution
- `01-permissions-capabilities-namespaces-cgroups.qmd` — User Permissions, Capabilities, Namespaces, cgroups
- `02-mac-selinux-vs-apparmor.qmd` — Mandatory Access Control: SELinux vs. AppArmor
- `03-secure-boot-and-chain-of-trust.qmd` — Secure Boot and the Chain of Trust
- `04-full-disk-encryption-luks.qmd` — Full Disk Encryption with LUKS
- `05-network-security-nftables-ebpf.qmd` — Network Security: nftables and eBPF
- `06-hardening-the-build-process.qmd` — Hardening the Build Process
- `07-troubleshooting-security-issues.qmd` — Troubleshooting: Security Issues

### Chapter 10: ISO Creation and Installation Systems
- `01-bootable-isos-with-xorriso.qmd` — Creating Bootable ISOs with xorriso
- `02-embedding-bootloader-kernel-squashfs.qmd` — Embedding the Bootloader, Kernel, and SquashFS Filesystem
- `03-anaconda-installer-architecture.qmd` — Anaconda: The Fedora/RHEL Installer Architecture
- `04-calamares-independent-installer.qmd` — Calamares: A Distribution-Independent Installer
- `05-network-installation-and-netbooting.qmd` — Network Installation and Netbooting
- `06-live-vs-minimal-iso-strategies.qmd` — Live vs. Minimal ISO Strategies
- `07-troubleshooting-iso-installation-issues.qmd` — Troubleshooting: ISO and Installation Issues

### Chapter 11: Automation, CI/CD, and Build Infrastructure
- `01-containers-and-nspawn-build-environments.qmd` — Docker, LXC, and systemd-nspawn for Build Environments
- `02-ci-pipelines-for-distro-building.qmd` — CI Pipelines for Distro Building
- `03-debian-buildd-network.qmd` — Debian’s buildd Network
- `04-fedora-koji-build-system.qmd` — Fedora’s Koji Build System
- `05-reproducible-builds-at-scale.qmd` — Reproducible Build Infrastructure at Scale
- `06-troubleshooting-build-infrastructure-issues.qmd` — Troubleshooting: Build Infrastructure Issues

### Chapter 12: Distribution Maintenance and Release Engineering
- `01-versioning-strategies.qmd` — Versioning Strategies: Rolling, Point Releases, LTS
- `02-debian-release-process.qmd` — Debian’s Release Process
- `03-arch-linux-rolling-model.qmd` — Arch Linux and the Rolling Model
- `04-fedora-six-month-cycle.qmd` — Fedora’s Six-Month Cycle
- `05-community-management-and-contributions.qmd` — Community Management and Contribution Workflows
- `06-backporting-security-patches.qmd` — Backporting Security Patches
- `07-troubleshooting-release-engineering-issues.qmd` — Troubleshooting: Release Engineering Issues

### Chapter 13: Capstone Project: Building Your Own Distribution
- `01-defining-goals-and-components.qmd` — Defining Goals and Choosing Components
- `02-setting-up-build-environment.qmd` — Setting Up the Build Environment
- `03-cross-compilation-toolchain-setup.qmd` — Cross-Compilation Toolchain Setup
- `04-kernel-and-initramfs-construction.qmd` — Kernel and Initramfs Construction
- `05-core-packages-into-target-rootfs.qmd` — Core Package Installation into Target RootFS
- `06-bootloader-configuration.qmd` — Bootloader Configuration
- `07-iso-creation-and-testing.qmd` — ISO Creation and Testing
- `08-documentation-branding-publishing.qmd` — Documentation, Branding, and Publishing
- `09-troubleshooting-capstone-project-issues.qmd` — Troubleshooting: Capstone Project Issues

### Conclusion & References
- `01-conclusion-the-road-ahead.qmd` — Conclusion: The Road Ahead
- `02-references.qmd` — References
