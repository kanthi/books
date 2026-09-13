---
title: "Matrix"
---

# Matrix

A **matrix** expands one job into many, one runner per combination. Use it for versions and OSes. Do not use it as a for-loop over deploy targets (that is usually `strategy.max-parallel: 1` plus a list you will regret).

## Cartesian product

```yaml
jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        python: ["3.13", "3.14"]
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: ${{ matrix.python }}
      - run: python -c "import sys; print(sys.version)"
```

That is four jobs: `(3.13, ubuntu)`, `(3.13, macos)`, `(3.14, ubuntu)`, `(3.14, macos)`.

`runs-on: ${{ matrix.os }}` — if you leave `ubuntu-latest` hard-coded, the OS axis does nothing.

## `include` and `exclude`

```yaml
strategy:
  fail-fast: false
  matrix:
    python: ["3.13", "3.14"]
    os: [ubuntu-latest, windows-latest]
    exclude:
      - os: windows-latest
        python: "3.13"
    include:
      - os: ubuntu-latest
        python: "3.14"
        extra: coverage
```

- `exclude` removes a combination the cartesian product would have built.
- `include` **adds** a row (and can add extra keys like `extra`). It does not mean “only these.”

## `fail-fast`

Default is `true`: one red matrix leg cancels the siblings. For CI you usually want `fail-fast: false` so 3.13-on-Windows still reports after 3.14-on-Linux failed.

`continue-on-error: true` on the job marks that leg allowed-to-fail (experimental). The workflow can still be green. Do not hide required versions this way.

## Cost

Each cell is a billed runner minute (private repos) or a concurrency slot (public). Two Pythons × three OSes × a 10-minute install is an hour of runners per push. Cap with:

```yaml
strategy:
  max-parallel: 4
  matrix: ...
```

Prefer `ubuntu-latest` plus one other OS, not a full cube, until something is OS-specific.

## Try this

1. Run the four-cell matrix. Cancel one job in the UI. With `fail-fast: true`, watch the others stop; with `false`, watch them finish.
2. `exclude` the cell you do not care about. Count the jobs in the Actions graph.
3. Add `include` with `extra: coverage` and an `if: matrix.extra == 'coverage'` step. Confirm it runs on one cell only.
