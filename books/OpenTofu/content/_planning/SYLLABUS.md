# OpenTofu

**Subtitle:** Infrastructure as Code for Modern Cloud and On-Premises Environments  
**Path:** `books/OpenTofu/`  
**Pin:** OpenTofu 1.13.2 (series supported until 1 August 2027)  
**Arc:** first principles → language → providers and state → composition → confidence → enterprise

The landing page states the contract. These chapters are the reader-facing book, not a pile of empty headings. Cloud snippets are sketches. The runnable example is `random_pet`.

| Part | Dir | Chapters |
|------|-----|----------|
| First principles | `content/01-first-principles/` | 1–3 |
| Language | `content/02-language/` | 4–5 |
| Providers and state | `content/03-providers-and-state/` | 6–7 |
| Composition | `content/04-composition/` | 8–10 |
| Confidence | `content/05-confidence/` | 11–12 |
| Enterprise | `content/06-enterprise/` | 13–14 and the conclusion |

Sentinel is named in the source syllabus and rejected in chapter 11: it does not run on OpenTofu. Policy in this book is Open Policy Agent. tfsec is named as history; the scanners to run are Trivy and Checkov.

Do not cross-link other books in this library. Linux is the worked command path. Chapter 3 still records macOS, Windows, and the container image because the syllabus requires those installs.
