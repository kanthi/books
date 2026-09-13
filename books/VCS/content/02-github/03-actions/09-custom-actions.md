---
title: "Custom actions"
---

# Custom actions

Most “we should write an action” tickets are a **composite** in `.github/actions/`. Write a published action only when another repo (or the marketplace) must call a **versioned** unit you do not want to copy.

Three `runs.using` values:

| Kind | When |
|------|------|
| `composite` | Steps you already know how to write. First choice. |
| `node24` (JavaScript) | You need npm libraries or `@actions/github`. |
| `docker` | You need a specific binary image. Slowest cold start. Last choice. |

JavaScript used to be `node16` / `node20`. New actions should use the runtime GitHub documents today (`node24` on current-hosted runners). If an old `action.yml` still says `node16`, treat it as unmaintained.

## JavaScript action (same repo)

```yaml
# .github/actions/ticket-label/action.yml
name: ticket-label
description: Echo a desk ticket label
inputs:
  ticket:
    description: Ticket id
    required: true
outputs:
  label:
    description: Normalized label
runs:
  using: node24
  main: index.js
```

```javascript
// .github/actions/ticket-label/index.js
const ticket = process.env.INPUT_TICKET || "";
const label = ticket.trim().toUpperCase();
if (!/^DESK-[0-9]+$/.test(label)) {
  console.error(`invalid ticket: ${ticket}`);
  process.exit(1);
}
const fs = require("fs");
const out = process.env.GITHUB_OUTPUT;
if (out) fs.appendFileSync(out, `label=${label}\n`);
console.log(label);
```

GitHub maps `with.ticket` to `INPUT_TICKET`. Prefer `@actions/core` in a real action; the stdlib version above has no npm install on the runner.

```yaml
steps:
  - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
  - id: lab
    uses: ./.github/actions/ticket-label
    with:
      ticket: DESK-12
  - run: test "${{ steps.lab.outputs.label }}" = "DESK-12"
```

## Docker action

`runs.using: docker` plus a `Dockerfile` in the action directory. The runner builds (or pulls) the image **every job** unless you publish it. Use this when the tool is a binary you refuse to install in composite bash. Do not use it to wrap `echo`.

## Version and publish

- **Same repo:** `uses: ./.github/actions/ticket-label` — no version. Fine for one product.
- **Other repos:** put the action at the root of a dedicated repo (or `owner/repo/path@ref`). Tag `v1.0.0`. Callers pin the **commit SHA**, not `v1`.
- Marketplace listing is optional advertising. It does not make the action safer. Review the source, then pin SHA.

Moving a tag (`v1` → new commit) is how a compromised maintainer hits everyone on `@v1`. Your pin survives that; a floating tag does not.

## Try this

1. Add `ticket-label` as a composite instead of JavaScript. Keep the same `inputs` / `outputs`. Which file went away?
2. Tag a dedicated action repo and resolve `git ls-remote`. Put the SHA in a caller. Move the tag; confirm the caller still runs the old bits.
3. Open the action’s `action.yml` on a marketplace listing you already use. If `runs.using` is `node16` or the last commit is years old, replace it or vendor the steps.
