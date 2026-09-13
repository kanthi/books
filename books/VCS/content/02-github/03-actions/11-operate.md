---
title: "Operate runs"
---

# Operate runs

A green workflow you cannot inspect, cancel, or pay for is not production. This chapter is concurrency, minutes, and `gh run`.

## Concurrency

```yaml
concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

Same group → GitHub cancels (or queues) the older run. Use this on PR CI. Do **not** set `cancel-in-progress: true` on a production deploy group; you want the in-flight deploy to finish.

```yaml
concurrency:
  group: deploy-production
  cancel-in-progress: false
```

## Minutes and logs

- **Public** repos: GitHub-hosted minutes are free within GitHub’s published limits; storage and artifacts still exist.
- **Private** repos: Linux is cheapest; macOS is the expensive one. A 3×3 matrix of `macos-latest` is how bills happen.
- Job logs and artifacts have retention. `retention-days` on artifacts (Cache and artifacts chapter) is the lever you own.

`timeout-minutes` on the job caps a stuck pytest. Default job timeout is long enough to waste a morning.

## `gh run`

```bash
gh run list --workflow=ci.yml --limit 10
gh run watch
gh run view <id> --log-failed
gh run rerun <id> --failed
gh run download <id> --name tickets-dist
```

`rerun --failed` retries only red jobs; matrix siblings that passed stay passed.

Debug logging for one run: **Re-run jobs → Enable debug logging**, or set repository secrets `ACTIONS_STEP_DEBUG=true` and `ACTIONS_RUNNER_DEBUG=true` briefly. They print env and runner internals. Turn them off; they can leak.

`nektos/act` runs a subset of workflows on your laptop. It is not GitHub. Use it to parse YAML locally; trust `gh run` for the real runner.

## Failed jobs

1. Open the red step. The last 50 lines are usually enough.
2. `gh run view --log-failed` if the UI truncated.
3. Re-run **failed** jobs only after you understand the flake. Re-running without a fix trains you to ignore red.
4. If it is a flake (network, PyPI), pin the dependency and add a retry **in the test tool**, not `continue-on-error: true` on the whole job.

Annotations (`::error file=src/tickets/__init__.py,line=2::msg`) show up on the PR files tab. `ruff` and `pytest` plugins can emit them; do not hand-roll a parser until the default output is unreadable.

## Status and merge

Required checks look at the **job name** as shown in the UI. If you set `name: Test ${{ matrix.python }}`, the required check is that string, not `test`. Changing `name:` breaks the ruleset. Prefer a stable `name:` or require the job id.

`if: github.event_name == 'pull_request'` jobs do not run on `push` to `main`. Do not mark those as required on `main`.

## Try this

1. Push three commits quickly to a PR. Confirm only the latest CI run stays active.
2. `gh run view --log-failed` on a deliberately red job. Find the assert without the UI.
3. Add `timeout-minutes: 5` to `test`. Sleep 6 minutes in a step; confirm the job is cancelled, not billed for an hour.
