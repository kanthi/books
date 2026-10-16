---
title: "AlphaProof Nexus: Lean-Verified Erdős Problems"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# AlphaProof Nexus: Lean-Verified Erdős Problems

Paul Erdős left hundreds of open questions — many elementary to *state*, stubborn to *settle*. In October 2026, Tsoukalas et al. reported in *Science* that an agent framework called **AlphaProof Nexus** autonomously resolved **9 of 353** Lean-formalized open Erdős problems (and 44 of 492 OEIS conjectures), with proofs checked by the **Lean 4** kernel rather than by informal review alone. This chapter is the mathematical reading of that result: what "formal proof search" means, why Lean’s `sorry` is the right hole to fill, what kinds of Erdős statements yielded, and how to look at a public Lean artifact without treating the AI as an oracle.

## Learning goals

By the end of this chapter you can:

- Contrast informal LLM proofs with Lean-checked proofs
- Outline the AlphaProof Nexus loop: sketch → LLM edit → Lean feedback → (optional) evolution / AlphaProof tool
- State the headline Erdős evaluation numbers from the *Science* / arXiv paper
- Sketch the *shape* of one solved problem (density / construction) without claiming a hand proof
- Know where the Lean sources live and what human validation still covers

## Thesis

An LLM can write a wrong proof that looks right. A **proof assistant** accepts a proof only when every tactic closes goals under a fixed logical foundation. AlphaProof Nexus’s contribution is not "AI vibes about number theory" — it is **search in the space of Lean scripts**, grounded by compiler errors, at research-problem scale.

## Mental model — formal vs informal

```text
Informal path                         Formal path (AlphaProof Nexus)
-------------                         ------------------------------
LLM writes English proof              Start from Lean theorem with `sorry`
  → human must re-check every step      → agent edits only marked regions
                                        → Lean compiles; errors steer next edit
                                        → success ≡ sorry-free + type-correct
```

Lean 4 (Moura & Ullrich) treats definitions and proofs as code. The special tactic `sorry` closes goals unsoundly for scaffolding; a finished proof must not rely on `sorry` (or `sorryAx`). Mathlib supplies the library of already-checked lemmas the agent may import.

### Agent shapes (from the paper)

| Agent | Idea |
|-------|------|
| **Basic** | Independent "Ralph loops": multi-turn LLM edits + Lean feedback each episode |
| **+ AlphaProof** | Same, but can call AlphaProof (RL olympiad prover) on stubborn subgoals |
| **Evolutionary** | Shared population of sketches; Elo-style LLM ratings; P-UCB sampling |
| **Full-featured** | Evolution + AlphaProof tool — used for the large Erdős / OEIS sweeps |

Post-hoc analysis: the **basic** agent could also solve the same nine Erdős problems, often at higher cost on the hardest ones; the full agent helped more on problems such as #125 and #138.

## Worked examples

### Case 1: Headline evaluation

From *Advancing Mathematics Research with AI-Driven Formal Proof Search* (Science 394, 8 Oct 2026; arXiv:2605.22763):

| Corpus | Attempted | Solved by full agent |
|--------|-----------|----------------------|
| Lean Erdős formalizations (Formal Conjectures snapshot) | 353 | **9** |
| Autoformalized OEIS open conjectures | 492 | **44** |

Additional deployments claimed in the paper (outside the Erdős table): algebraic geometry (Hilbert / pure $O$-sequences), optimization (anchored GDA rate), graph theory collaborations, quantum optics constructions. After each Erdős solve, the authors report **expert checks that the Lean statement matched the intended conjecture** — formal success does not auto-fix misformalization.

Public artifacts: [google-deepmind/alphaproof-nexus-results](https://github.com/google-deepmind/alphaproof-nexus-results) (Lean under `APNOutputs/ErdosProblems/`, prose under `NaturalLanguageProofs/`).

### Case 2: What an Erdős solve looks like (problem #125, density)

**Informal statement (shape).** Let $A$ be the integers whose base-3 digits are only $0,1$, and $B$ the analogous set in base $4$. Does the sumset $A+B$ have positive **lower** density?

**Result reported.** The agent proved that the **lower density is zero**, using an inductive thinning argument that exploits Diophantine proximity $3^{m}\approx 4^{k}$ (irrational $\log 4/\log 3$). Human discussion afterward noted remaining questions about **upper** density.

You do not need the full Lean file to see the pattern: many Erdős wins are **constructions** or **density upper bounds** that decompose into lemmas Mathlib can check, not deep new axiomatic foundations.

### Case 3: Construction flavour (problem #12(i), 1970)

Erdős–Sárközy-type question: infinite $A\subseteq\mathbb{Z}^{+}$ with a divisibility restriction (no $a$ divides $b+c$ for distinct larger $b,c$) yet

$$
\liminf_{N\to\infty}\frac{|A\cap[1,N]|}{\sqrt{N}}>0.
$$

The published deformalized proof builds $A$ as a union of **blocks** separated by rapid growth, using the Chinese Remainder Theorem and a 3-AP-free digit map (base-2 → base-3) so same-block violations collapse to forbidden arithmetic progressions. Two of the nine solves had been open on the order of **56 years**.

### Case 4: Opening a Lean artifact

A typical successful file (conceptually):

```lean
-- illustrative shape — see alphaproof-nexus-results for real files
import Mathlib

namespace Erdos125
-- definitions of A, B, lower density …
theorem lower_density_zero : … := by
  -- EVOLVE-BLOCK region: lemmas + tactics, no sorry left
  …
end Erdos125
```

Reading tips:

1. Check imports and the **theorem statement** against ErdosProblems.com / Formal Conjectures — that is where misformalization hides.
2. Search for `sorry` — should be absent in `APNOutputs` successes.
3. Prefer the paired **natural-language** write-up when learning the idea; use Lean when you need machine certainty.

## The trap

- Treating a Lean proof of a **wrong formalization** as a proof of Erdős’s intended question (the paper itself found density-vs-lower/upper-density ambiguities).
- Assuming every open Erdős problem is now in reach — **9/353** with a large search budget; most remain open.
- Confusing **AlphaProof** (olympiad RL prover used as a tool) with **AlphaProof Nexus** (the agent framework around Lean + LLMs).
- Citing X/news summaries instead of the Science paper, arXiv text, or the GitHub Lean sources.

## The boring rule

For research claims that matter: **formalize the statement carefully**, search with a Lean-checked loop, then have a human confirm the formal statement matches the mathematics you care about.

## Try this

1. Read the Science abstract / arXiv §§1–3 (<https://arxiv.org/html/2605.22763> or <https://www.science.org/doi/10.1126/science.aej2213>).
2. Browse one Lean file under `APNOutputs/ErdosProblems/` and its prose twin if present.
3. On ErdosProblems.com, open problem #125 or #12 and compare the informal wording to the Lean theorem type.
4. If you use Lean 4 locally, `#check` a Mathlib density or sumset lemma to feel the library the agent stands on (no new installs required for reading proofs on GitHub).

## Sources

- G. Tsoukalas et al., *Advancing mathematics research with AI-driven formal proof search*, Science (8 Oct 2026). DOI: [10.1126/science.aej2213](https://www.science.org/doi/10.1126/science.aej2213)
- arXiv:2605.22763 — <https://arxiv.org/abs/2605.22763> / <https://arxiv.org/html/2605.22763>
- Results repo: <https://github.com/google-deepmind/alphaproof-nexus-results>
- Lean 4: Moura & Ullrich, CADE 2021; Mathlib community
- Erdős catalog: <https://www.erdosproblems.com>
