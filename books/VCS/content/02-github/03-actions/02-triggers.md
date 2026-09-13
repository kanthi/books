---
title: "Triggers"
---

# Triggers

`on:` decides **whether** a workflow runs. It does not decide how trusted the run is. That is the pair *(event, whose code, which token)* — covered fully in Security. This chapter is the event catalog and the filters.

## `push` vs `pull_request`

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
```

| | `push` | `pull_request` |
|--|--------|----------------|
| When | Commits land on a matching ref | PR opened / synchronized / reopened (default types) |
| Checkout default | The pushed commit | The **merge commit** GitHub synthesizes (base + head) |
| Fork PR | N/A (no push to *your* repo) | Runs **if** you allow it; **no secrets**; `GITHUB_TOKEN` is read-only |

CI on contributions should use `pull_request`, not `push` alone. `push` to `main` is what you run after merge.

Default `pull_request` types are `opened`, `synchronize`, `reopened`. Add types only when you need them (`ready_for_review`, `labeled`, …). `synchronize` fires on every new commit to the PR branch.

## Filters

```yaml
on:
  push:
    branches: [main, "release/**"]
    tags: ["v*"]
    paths: ["src/**", "pyproject.toml"]
  pull_request:
    branches: [main]
    paths: ["src/**", "tests/**", "pyproject.toml"]
```

- `branches` / `paths` **include**. `branches-ignore` / `paths-ignore` **exclude**. Do not mix include and ignore on the same event; use `!` on the include list instead.
- If both `branches` and `paths` are set, **both** must match.
- Path filters use a two-dot diff on push and a three-dot diff on pull requests. Huge pushes (>1000 commits) may skip the filter and always run.

A skipped path filter leaves PR checks in **Pending** if that check is required. Prefer a tiny always-green job, or do not mark a path-filtered workflow required.

## `workflow_dispatch`

Manual run from the Actions tab or `gh workflow run`. The file must exist on the **default branch**.

```yaml
on:
  workflow_dispatch:
    inputs:
      dry_run:
        description: "Print the plan only"
        type: boolean
        default: true
      ticket:
        description: "Ticket id"
        type: string
        required: true

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - run: echo "ticket=${{ inputs.ticket }} dry_run=${{ inputs.dry_run }}"
```

Use `inputs.<id>` (boolean stays boolean). `github.event.inputs` stringifies booleans.

## `schedule`

POSIX cron, UTC unless you set `timezone`. Shortest period is five minutes. The workflow file that runs is the one on the **default branch**.

```yaml
on:
  schedule:
    - cron: "30 5 * * 1-5"
      timezone: "America/New_York"
```

Schedules skip when the repo is inactive. Do not use cron as the only CI for pull requests.

## `workflow_call`

Another workflow’s `jobs.<id>.uses:` entry point. Inputs require `type`. Secrets are declared, not inherited by accident — see Reuse.

## Fork pull requests

For a PR from a fork of a **public** repo:

1. GitHub may require a maintainer to **approve** the first run (org/repo setting).
2. Secrets from the base repo are **not** available.
3. `GITHUB_TOKEN` is read-only.

That is the correct default for tests. If you “need secrets on a fork PR,” stop — that is the pwn-request chapter (`pull_request_target`).

Private-fork rules differ (secrets can be enabled). Treat that as an org policy, not a convenience switch.

## Do not interpolate untrusted event fields into the shell

```yaml
# Bad — title can be `"; evil; #`
- run: echo "${{ github.event.pull_request.title }}"

# Better — env assignment is not shell-evaluated the same way
- env:
    TITLE: ${{ github.event.pull_request.title }}
  run: echo "$TITLE"
```

Still do not `eval` that string.

## Try this

1. Add `paths: ["src/**"]` to `pull_request`. Change only `README.md` on a PR. Confirm CI does not start (and that a required check, if any, sits Pending).
2. Add `workflow_dispatch` and run it with `gh workflow run ci.yml -f ticket=DESK-1 -f dry_run=true`.
3. Open a PR from a **fork**. Confirm the run has no access to repository secrets.
