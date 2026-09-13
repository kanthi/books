---
title: "Jobs and steps"
---

# Jobs and steps

A **job** is a runner plus an ordered list of **steps**. Jobs are parallel unless `needs:` says otherwise. Steps share the job’s workspace (`$GITHUB_WORKSPACE`) and environment files (`GITHUB_ENV`, `GITHUB_PATH`, `GITHUB_OUTPUT`).

## `run:` vs `uses:`

```yaml
jobs:
  ping:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - name: Shell
        run: python -c "print('ok')"
      - name: Reusable action
        uses: actions/setup-python@5fda3b95a4ea91299a34e894583c3862153e4b97 # v7.0.0
        with:
          python-version: "3.14"
```

- `uses:` loads an action (GitHub repo `@sha`, Docker image, or local `./.github/actions/...`).
- `run:` is bash on Linux/macOS and PowerShell on Windows unless you set `shell:`.
- `working-directory:` is per step. `defaults.run.working-directory` is per job.

A step with both `uses` and `run` is invalid.

## `needs:` and outputs

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    outputs:
      version: ${{ steps.meta.outputs.version }}
    steps:
      - id: meta
        run: echo "version=0.1.0" >> "$GITHUB_OUTPUT"

  test:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - run: echo "testing ${{ needs.build.outputs.version }}"
```

`needs:` can be a list. A job with `needs: [a, b]` waits for both. If `a` fails, `b`’s dependents are skipped unless you set `if: always()` / `if: ${{ !cancelled() }}`.

## `if:` on jobs and steps

Expressions run in `${{ }}`. Common functions: `success()`, `failure()`, `always()`, `cancelled()`, `contains()`, `startsWith()`.

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
      - name: Only on main
        if: github.ref == 'refs/heads/main'
        run: echo "main"

  notify:
    needs: test
    if: failure()
    runs-on: ubuntu-latest
    steps:
      - run: echo "test failed"
```

`if:` is evaluated before the step starts. A skipped step is not a failure.

## Contexts

| Context | Typical use |
|---------|-------------|
| `github` | `github.ref`, `github.sha`, `github.event_name`, `github.repository`, `github.actor` |
| `env` | Env vars from `env:` blocks |
| `secrets` | `secrets.FOO` — never echo |
| `inputs` | `workflow_dispatch` / `workflow_call` inputs |
| `matrix` | Current matrix combination |
| `steps` | `steps.<id>.outputs` / `outcome` / `conclusion` |
| `needs` | Upstream job outputs |
| `runner` | `runner.os`, `runner.temp` |
| `vars` | Configuration variables (not secrets) |

```yaml
- name: Show event
  run: |
    echo "event=${GITHUB_EVENT_NAME}"
    echo "ref=${GITHUB_REF}"
    echo "sha=${GITHUB_SHA}"
```

Prefer the env vars GitHub already exports (`GITHUB_SHA`, `GITHUB_REF`, `GITHUB_EVENT_NAME`) in `run:` scripts. Keep `${{ }}` for `if:`, `with:`, and `env:` assignments.

## Job-level knobs

```yaml
jobs:
  test:
    name: Test ${{ matrix.python }}
    runs-on: ubuntu-latest
    timeout-minutes: 15
    continue-on-error: false
    env:
      PYTHONUNBUFFERED: "1"
    defaults:
      run:
        working-directory: src
```

`timeout-minutes` on a job beats a hung pytest. `continue-on-error: true` is for experimental matrix legs, not for hiding a red CI.

## Try this

1. Split ping into `build` (writes `GITHUB_OUTPUT`) and `test` (`needs: build`). Confirm the Actions graph shows the arrow.
2. Add a `notify` job with `if: failure()`. Make `test` fail and confirm `notify` runs.
3. Print `github.event_name` and `github.ref` on a push and on a pull request. They are not the same string.
