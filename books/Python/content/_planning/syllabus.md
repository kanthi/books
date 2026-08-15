# Python book — unpublished syllabus

Directories under `content/` that start with `_` are ignored by `scripts/update-index.sh`.

**Baseline:** Python 3.14. Toolchain: `uv` + venv. Type hints after the first syntax pass.

**Independence:** this book is meant to be read **alone**. It does not overlap other titles and does not require them. Domains appear as **Python + X** (a small experiment in this book). Do not reteach Maths, Linux, or Networking; do not send the reader there.

## Source map (topics and sequence only)

### Language (Part 01)

| Source | Use for |
|--------|---------|
| Official Python 3.14 Tutorial | Spine: interpreter, control flow (`match`), data structures, modules, I/O, exceptions, classes, stdlib tour, venv |
| Sweigart, *Automate the Boring Stuff* 3e (2025) | Early practical projects |
| Matthes, *Python Crash Course* | Project-shaped chapters |
| Downey, *Think Python* 3e | CS-flavored beginner path |
| Lutz, *Learning Python* | Language-mechanism reference |
| CS50P, Helsinki MOOC.fi, MIT 6.100L / 6.0001 | Exercise cadence |
| Slatkin, *Effective Python* 2e | Idioms, testing, collaboration |
| Ramalho, *Fluent Python* 2e | Data model, protocols, typing, iterators, concurrency |
| Beazley, *Python Distilled* + *Python Cookbook* | Tight examples |
| Viafore, *Robust Python* | Typing and maintainability |
| Percival & Gregory, *Architecture Patterns with Python* | Parked — see `later-parts.md` |

### Internals (`01-language/14-internals/`)

| Source | Use for |
|--------|---------|
| Shaw, *CPython Internals* | Parse → compile → eval |
| CPython devguide internals; Real Python CPython source guide | Object header, bytecode, frames |
| PEP 703 / PEP 779 | Free-threading official in 3.14 |
| PEP 734 | Multiple interpreters |
| 3.13+ specializing interpreter + experimental JIT; 3.14 tail-call interpreter | Performance model |
| Ramalho data model | Language-level internals before C |

### Parked (not in the sidebar)

See `later-parts.md`. Sources for CS, maths-through-Python, data/AI, ops, and apps stay there until we organize those parts.

### 2026 tooling (appear early)

`uv`, Ruff, ty / Pyright / mypy, pytest + hypothesis, `pyproject.toml`, PEP 649/749 deferred annotations, Pydantic v2 at API boundaries.

## Part map

See `index.qmd` for reader paths. Tree:

```text
01-language/     intro → internals (published)
98-stdlib/       reference tour (published)
99-projects/     labs (published)
```

Parked tree: `later-parts.md`.

## Status

- Real chapters: Language intro, getting started, syntax–data, internals.
- Orientation: remaining Language sections, stdlib, projects.

Path A leaves (getting started → data structures) were deepened for beginners (named examples, terms on first use). Getting started now includes editors/fonts (macOS/Linux, VS Code family, Zed, Sublime, …) and a CLI-only page. Next: remaining Language leaves (modules → concurrency). Do not restore parked parts until we decide the shape.
