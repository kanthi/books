# Book diagrams (`images/`)

## Monorepo standard (read this)

**All books use one illustrated-diagram system.** Canonical docs and exemplars live at:

| Doc / asset | Path (from monorepo root) |
|-------------|---------------------------|
| **Standard** | `includes/diagrams/STANDARD.md` |
| **Light reference** | `includes/diagrams/reference/diagram-reference-topology.svg` |
| **Dark reference** | `includes/diagrams/reference/diagram-reference-topology-dark.svg` |
| **Theme-swap fragment** | `includes/diagrams/theme-swap.fragment.html` |

This Template ships copies of the reference SVGs for local preview:

- `diagram-reference-topology.svg`
- `diagram-reference-topology-dark.svg`

## Rules (short)

1. **Illustrated topology** → dual files: `diagram-<topic>.svg` + `diagram-<topic>-dark.svg`, CSS variables, self-contained card. Match reference tokens.
2. **Conceptual mono** → `diagram-concept-<topic>.svg`, transparent, `#7a8fa6` strokes only; no dark sibling.
3. Embed the **light** path only in markdown.
4. Keep `images/*-dark.svg` in `scripts/update-index.sh` `project.resources` (Template already does).
5. Theme swap runs from `styles/reader-mode-body.html` (Template already includes the monorepo fragment).

Do **not** invent a new palette per book.
