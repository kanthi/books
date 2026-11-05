# Boring Linux

A progressive Linux systems and operations book in the multi-book Quarto monorepo.

- Reader introduction and curriculum map: [index.qmd](index.qmd)
- Authoring progress and next chapters: [INDEX.md](INDEX.md)
- Canonical detailed syllabus: [content/_planning/SYLLABUS.md](content/_planning/SYLLABUS.md)
- Monorepo workflow: [root README](../../README.md)
- Diagram style: [shared standard](../../includes/diagrams/STANDARD.md)

## Content structure

New core chapters use `content/NN-part/NN-section/NN-chapter.qmd`. Parts 01–05 have complete sequences; Part 06 contains nine chapters. Parts 07–32 remain planned. Parts 33–38 already have optional depth-track material at their existing paths, with technical review still pending.

The [syllabus](content/_planning/SYLLABUS.md) defines reading routes, prerequisite bridges, milestone projects, section outlines and topic ownership. The [authoring roadmap](INDEX.md) records file counts, the next three Part 06 chapters and the depth-track review queue. Update status there instead of maintaining a separate chapter log in this README. The [reader introduction](index.qmd) distinguishes available chapters from the planned curriculum.

Keep current part numbers and chapter paths stable. Add new sections only when there are written chapters, and keep historical planning under `content/_planning/archive/` out of chapter discovery. Changes to optional tracks should deepen their owning topics rather than restart the foundations.

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
