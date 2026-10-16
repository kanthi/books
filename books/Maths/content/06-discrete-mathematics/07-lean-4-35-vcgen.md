---
title: "Lean 4.35: vcgen and lake check"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Lean 4.35: `vcgen` and `lake check`

## Thesis

**Lean 4.35.0** (12 October 2026) replaces the monadic verification-condition tactic `mvcgen` with **`vcgen`**: faster, more general, and aimed at both `do`-programs and deeply embedded languages. The same release folds external kernel checking into Lake via **`lake check`** and **`lake comparator`**, optionally running every bundled checker with `--paranoid`.

This chapter is a discrete-math / verification user's guide to those two headlines. Lean is **not** installed on this scout host, so listings are taken from the [official 4.35.0 release notes](https://lean-lang.org/doc/reference/latest/releases/v4.35.0/) and neighbouring reference pages. When you have `elan` + 4.35 locally, re-run them and paste real output.

## Mental model

```text
  Imperative / monadic program  +  Hoare-style contract
                 │
                 ▼
            vcgen          ← weakest-precondition / VC generation (Std.WP)
                 │
                 ▼
        verification conditions
                 │
                 ▼
     discharge with grind / finish / manual tactics
                 │
                 ▼
        lake check [--paranoid]   ← rebuild + replay through kernel(s)
```

| Concept | Role in 4.35 |
|---------|----------------|
| `mvcgen` | Previous tactic; **deprecated** — emits deprecation warnings |
| `vcgen` | Successor; enable experimental ack with `set_option experimental.vcgen true` |
| `Std.WP` | Weakest-precondition framework behind `vcgen` (not only monads) |
| `lake check` | Build default targets, export, replay through Lean's kernel; fail on non-standard axioms |
| `lake check --paranoid` | Also run `lean4lean`, `nanoda`, `con-leche`, `con-ron`, `leanchecker-paranoid` |
| `lake comparator` | Check solution theorems against a challenge module (competition / homework shape) |

## Worked examples

### Case 1: Swap `mvcgen` for `vcgen`

Release notes: `mvcgen` / `mvcgen?` are deprecated in favour of `vcgen` (PR #14874). New code should open the WP namespace and use `vcgen`:

```lean
-- VcgenHello.lean — shape from the 4.35 notes / reference (not executed here)
import Std.Tactic.Do   -- legacy mvcgen path lived here; follow current vcgen imports in the manual

set_option experimental.vcgen true

-- Sketch: a trivial Id program with a contract, discharged by vcgen
-- (exact import paths: see "Verifying Imperative Programs Using vcgen" in the reference.)
--
-- def addOne (n : Nat) : Id Nat
--     ensures r => r = n + 1 := do
--   return n + 1
--
-- example : True := by
--   -- vcgen on goals arising from intrinsic contracts / WP goals
--   trivial
```

Honest status: **not elaborated on this host** (no `lean` / `lake` binary). Treat the sketch as a pointer to the reference tutorial; copy a full worked file from the Lean reference once the toolchain is present.

Why the rename matters:

1. **Deep embeddings.** `vcgen` applies to any program type with a WP interpretation — `do` in a monad, but also embedded ISAs (the notes mention x64 / Wasm-style languages).
2. **Richer assertions.** Assertions may live in complete lattices (separation logic, probabilistic logics), with a generalized frame rule.
3. **Performance.** On the AddSubCancel benchmark (stateful loop body × 2200), notes report **`vcgen` ≈ 0.32 s** vs **`mvcgen` ≈ 66 s**, and kernel checking **0.53 s** vs **246 s**, with roughly linear growth (~0.14 ms per loop iteration).

### Case 2: Intrinsic contracts on `def` (loop with invariant)

Also new around WP work in 4.35: loops can carry the annotations `vcgen` needs:

```lean
-- from the release highlights (countDown) — docs excerpt
def countDown (n : Nat) : Id Nat
    ensures r => r = 0 := do
  let mut i := n
  while i > 0
      invariant exit => if exit then i = 0 else True
      decreasing i
    do
    i := i - 1
  return i
```

`invariant` / `decreasing` / `assert` / `requires` / `ensures` report as experimental unless you acknowledge with the documented `experimental.*` options. Prefer the reference chapter over blog paraphrases when proof mode details matter.

### Case 3: `lake check` and `--paranoid`

```bash
# In a Lake project on Lean 4.35+ (not run on this scout box):
lake check              # official kernel, standard axioms only
lake check --paranoid   # + lean4lean, nanoda, con-leche, con-ron, leanchecker-paranoid
```

Behaviour (from the notes):

- Builds default targets inside a **bubblewrap** sandbox (Linux), exports, replays through the kernel in a separate process.
- Fails if the export uses axioms outside the permitted set.
- `--from-export` checks an NDJSON export produced elsewhere (CI VM, third party).
- Sandbox can be disabled only with an explicitly inadvisable flag — do not use that in production review.

Leonardo de Moura's 15 Oct 2026 note frames the motivation: AI agents find kernel bugs; multiple independent checkers raise confidence. Scalability of external checking for multi-million-line developments remains an open FRO problem — still run `--paranoid` on *your* project size today.

### Case 4: `lake comparator` for challenge / solution pairs

```json
{
  "challenge_module": "Challenge",
  "solution_module": "Solution",
  "theorem_names": ["imo2024_p1"],
  "permitted_axioms": ["propext", "Quot.sound", "Classical.choice"]
}
```

```bash
lake comparator   # reads comparator.json by default
```

Checks: same statement as the challenge, only permitted axioms, kernel accepts. Same `--paranoid` / export flags family as `lake check`.

### Case 5: Cache / build packaging tweak

```bash
lake build -o --package <pkg>
lake cache put --package=<pkg>
# lake cache put-staged now requires an explicit revision:
lake cache put-staged --rev="$(git rev-parse HEAD)"
```

Unrelated to VC generation, but part of the same 4.35 Lake surface you will hit in CI.

## The trap

- Leaving `mvcgen` in new proofs — noisy deprecations and missing deep-embedding features.
- Forgetting `set_option experimental.vcgen true` and treating the warning as failure.
- Running `lake check --inadvisably-no-sandbox` on untrusted formalisations.
- Assuming `--paranoid` scales unchanged to 10⁸-line developments — the FRO post is explicit that it does not yet.
- Inventing tactic syntax beyond the release notes / reference.

## The boring rule

On Lean **≥ 4.35**: write new imperative proofs with **`vcgen`**, acknowledge the experimental flag, and gate merges with **`lake check`** (add `--paranoid` when the project fits in the checkers' comfort zone). Retire `mvcgen` on touch.

## Try this

1. `elan install leanprover/lean4:v4.35.0` on a workstation and open the reference tutorial *Verifying Imperative Programs Using vcgen*.
2. Replace one `mvcgen` proof with `vcgen … with finish` and compare wall time.
3. Run `lake check` on a small library; then `lake check --paranoid` and record which checkers ran.
4. Add a `comparator.json` for a homework theorem and break it on purpose (wrong statement) to see the failure mode.

## Sources

- [Lean 4.35.0 release notes](https://lean-lang.org/doc/reference/latest/releases/v4.35.0/)
- Reference: `mvcgen` superseded by `vcgen`; tutorial *Verifying Imperative Programs Using vcgen*
- [Lean now ships with verified kernels](https://leodemoura.github.io/blog/2026-10-15-lean-now-ships-with-verified-kernels/) (Leonardo de Moura, 2026-10-15)
- Inspiration: [leanprover on X — 4.35.0 / vcgen](https://x.com/leanprover/status/2110035485385175091)
