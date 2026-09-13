---
title: "Reusable workflows and composite actions"
---

# Reusable workflows and composite actions

Copy-paste YAML across repos dies in a week. GitHub gives two reuse tools:

| | **Composite action** | **Reusable workflow** |
|--|----------------------|------------------------|
| Lives | `action.yml` (`runs.using: composite`) | `.github/workflows/*.yml` with `on.workflow_call` |
| Called as | a **step** (`uses:`) | a **job** (`jobs.<id>.uses:`) |
| Own runner | No — runs inside the caller’s job | Yes — its jobs have `runs-on` |
| Best for | A handful of steps (install + ruff) | A whole CI graph you want identical in many repos |

Write a **composite** first. Promote to `workflow_call` when you need multiple jobs or a different runner.

## Composite action (same repo)

```yaml
# .github/actions/python-ci/action.yml
name: python-ci
description: Install desk-tickets dev extras, ruff, pytest
inputs:
  python-version:
    description: CPython version
    required: false
    default: "3.14"
runs:
  using: composite
  steps:
    - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
      with:
        python-version: ${{ inputs.python-version }}
        cache: pip
        cache-dependency-path: pyproject.toml
    - shell: bash
      run: pip install -e ".[dev]"
    - shell: bash
      run: ruff check src tests
    - shell: bash
      run: pytest -q
```

Caller still checks out:

```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
  push:
    branches: [main]
permissions:
  contents: read
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - uses: ./.github/actions/python-ci
        with:
          python-version: "3.14"
```

Every composite `run:` step needs `shell:`. Nested `uses:` of other actions is allowed; pin those inner actions to SHAs too.

## Reusable workflow

Callee (in this repo or an org `.github` repo):

```yaml
# .github/workflows/python-ci.yml
name: python-ci
on:
  workflow_call:
    inputs:
      python-version:
        type: string
        default: "3.14"
    secrets:
      optional_token:
        required: false

jobs:
  test:
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: ${{ inputs.python-version }}
      - run: pip install -e ".[dev]"
      - run: pytest -q
```

Caller:

```yaml
# .github/workflows/ci.yml
name: CI
on:
  pull_request:
jobs:
  test:
    uses: ./.github/workflows/python-ci.yml
    with:
      python-version: "3.14"
    secrets:
      optional_token: ${{ secrets.TICKET_TOKEN }}
    permissions:
      contents: read
```

- `with:` maps to `inputs`. Types are required on `workflow_call` inputs.
- Secrets are **explicit**. `secrets: inherit` passes everything; use it only inside one org you control, never toward a third-party reusable workflow.
- The caller must grant `permissions` the callee needs. OIDC `id-token: write` on a reusable workflow outside your org must be set on the **caller**.

Pin a cross-repo callee the same way as an action: `uses: my-org/workflows/.github/workflows/python-ci.yml@<sha>`.

## Try this

1. Move install/lint/test into `.github/actions/python-ci` and call it from `ci.yml`. Confirm one job, four steps (checkout + three composite).
2. Convert that to `workflow_call`. Confirm the Actions graph now shows a called workflow node.
3. Call it from a second repo at `@<full-sha>`. Change `main` on the callee; confirm the caller does not move until you bump the SHA.
