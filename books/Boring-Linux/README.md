# Boring Linux

A progressive Linux systems and operations book in the multi-book Quarto monorepo.

- Reader introduction and curriculum map: [index.qmd](index.qmd)
- Authoring progress and next chapters: [INDEX.md](INDEX.md)
- Canonical detailed syllabus: [content/_planning/SYLLABUS.md](content/_planning/SYLLABUS.md)
- Monorepo workflow: [root README](../../README.md)
- Diagram style: [shared standard](../../includes/diagrams/STANDARD.md)

## Content structure

Written chapters use `content/NN-part/NN-section/NN-chapter.qmd`. Parts 01–05 are complete, and Part 06 has started; future coverage is maintained in the syllabus rather than placeholder pages.

The opening section contains six chapters: the Linux system model; hardware, firmware and virtual machines; CPU, memory, storage and network resources; paths, configuration and state; processes, services and sessions; and distributions, releases and documentation. A second section adds the first-VM lab and inventory/evidence/troubleshooting practice, bringing Part 01 to eight chapters. Part 02 now has four Installation Foundations chapters covering media trust, installation planning, guided installation, and manual storage/encryption/swap choices. First Boot and Device Readiness covers administrator access, updates, service inventory, and hardware and virtual-device discovery. Provisioning and Recovery covers image-based and unattended installation, then reinstallation and selective host-configuration recovery. Part 03 covers firmware and boot selection, kernel artifacts and early userspace, systemd startup, shutdown, and the Secure Boot and measured-boot model. Rescue environments and offline repair complete Part 03. Part 04 covers local identities, account lifecycle, homes, passwords, PAM, sudo delegation and service identities. Sessions, polkit and central identity foundations complete Part 04. Part 05 begins with package state, APT transactions, source trust, version selection and configuration ownership. Updates and Kernel Lifecycle covers security updates and kernel reboot decisions. Other Formats and Software Supply covers Snap, Flatpak, local packages and disconnected software supply. Interrupted transaction recovery completes Part 05. Part 06 begins with service supervision, execution context, readiness and dependency relationships. The next pass covers unit configuration and drop-ins.

The prior chapter tree was removed for the accepted syllabus restart. Historical planning is under `content/_planning/archive/` and is excluded from chapter discovery.

## Build ownership

After every content update batch, render Boring-Linux with the repository scripts and refresh the local library portal once. Run these commands from the repository's `books/` directory. Proceed with artifact copying and portal regeneration only after the render succeeds:

```bash
bash indipub.sh Boring-Linux
rsync -a --delete Boring-Linux/_book/ published_books/html/Boring-Linux/
cp Boring-Linux/_book/Boring-Linux.pdf published_books/pdf/Boring-Linux.pdf
cp Boring-Linux/_book/Boring-Linux.epub published_books/epub/Boring-Linux.epub
bash scripts/gen-portal.sh
```

The render script generates `_quarto.yml`; never edit that file by hand. The scoped sync removes retired chapters from this book's local published output. Keep `_book/` and `published_books/` untracked. This updates the local portal; public deployment remains the responsibility of CI.
