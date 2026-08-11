# Illustrated diagram standard (all books)

**Canonical style reference** for hand-written SVGs across this monorepo (every book + `Template/`).

| Role | Path |
|------|------|
| **This standard** | `includes/diagrams/STANDARD.md` |
| **Visual exemplar (light)** | `includes/diagrams/reference/diagram-reference-topology.svg` |
| **Visual exemplar (dark)** | `includes/diagrams/reference/diagram-reference-topology-dark.svg` |
| **First production use** | `books/Networking/images/diagram-dist-switch-multihome.svg` (+ `-dark`) |
| **New-book scaffold** | `Template/images/` (copies of the reference + local README) |

Agents: **open the light reference SVG** before drawing a new topology figure. Match tokens, card, type, and dual-file pattern—do not invent a new palette per book.

---

## When to use which style

| Kind | Use for | Style |
|------|---------|--------|
| **Illustrated topology** | Racks, switches, fabrics, lab topologies, addressing | Self-contained dual-theme **card** (this standard) |
| **Conceptual mono** | Abstract models, loops, planes, learning paths | Transparent bg, stroke/text `#7a8fa6` only — no filled card, **no** `-dark` sibling |

Prefer illustrated topology over Mermaid for anything with devices, links, or CIDRs.

---

## Dual-theme contract (required for illustrated figures)

External SVGs loaded as `<img>` **cannot** see Quarto’s `body.quarto-dark` class. Therefore:

1. **`diagram-<topic>.svg`** — light tokens (PDF, EPUB, Quarto light).
2. **`diagram-<topic>-dark.svg`** — dark tokens (Quarto dark HTML).
3. Markdown embeds **always** point at the **light** path.
4. HTML theme swap (in `styles/reader-mode-body.html`) rewrites `src` to `*-dark.svg` when `body.quarto-dark` is set.
5. Book `scripts/update-index.sh` must declare project resources so dark files are copied into `_book/`:

```yaml
project:
  resources:
    - images/*-dark.svg
```

6. Conceptual mono figures: use `diagram-concept-<topic>.svg` (or an explicit mono denylist in the swap script) so they are **not** rewritten.

---

## Light tokens (`diagram-*.svg`)

| Token | CSS var | Value | Use |
|-------|---------|--------|-----|
| Canvas | `--canvas` | `#eef2f7` | Full figure card |
| Grid | `--grid` | `#cfd8e6` | 16–20px subtle lines |
| Frame | `--frame` | `#d0d9e4` | Inner rounded border |
| Ink | `--ink` | `#2a3542` | Titles, primary labels |
| Muted | `--muted` | `#5c6b7a` | Subtitles, host names |
| IP / mono text | `--ip` | `#3d4f5f` | Addresses, code-like labels |
| Link | `--link` | `#3b82c4` | Cables / uplinks |
| Node fill | `--node` | `#f7fafc` | Switch / router body |
| Node stroke | `--node-stroke` | `#7d8fa3` | Device outline |
| Slot | `--slot` | `#dfe7f0` | Port rows inside devices |
| Bubble fill | `--bubble` | `#ebe0f4` | IP / interface chips |
| Bubble stroke | `--bubble-stroke` | `#b39bc9` | Chip outline |
| Rack face | `--rack` | `#dce5ef` | Server chassis |
| Rack edge | `--rack-edge` | `#8fa0b3` | Chassis outline |
| Bay | `--bay` | `#f7fafc` | Drive / unit slots |
| Bay stroke | `--bay-stroke` | `#a8b7c8` | Slot outline |
| Rack 3D | `--rack-3d` | `#b8c4d2` | Side extrusion (low opacity) |
| Shadow | `--shadow` | `#1a2330` | Soft drop shadow flood |

## Dark tokens (`diagram-*-dark.svg`)

| Token | CSS var | Value |
|-------|---------|--------|
| Canvas | `--canvas` | `#1c2129` (slightly above page `#1a1a1a`) |
| Grid | `--grid` | `#2c3440` |
| Frame | `--frame` | `#3a4452` |
| Ink | `--ink` | `#e8eef5` |
| Muted | `--muted` | `#9aa8b8` |
| IP | `--ip` | `#c5d0dc` |
| Link | `--link` | `#60a5fa` |
| Node | `--node` | `#2a3140` |
| Node stroke | `--node-stroke` | `#6b7c90` |
| Slot | `--slot` | `#363d4a` |
| Bubble | `--bubble` | `#332a42` |
| Bubble stroke | `--bubble-stroke` | `#8b7aa8` |
| Rack | `--rack` | `#2a3140` |
| Rack edge | `--rack-edge` | `#6b7c90` |
| Bay | `--bay` | `#363d4a` |
| Bay stroke | `--bay-stroke` | `#5a6b7d` |
| Rack 3D | `--rack-3d` | `#151a22` |
| Shadow | `--shadow` | `#000000` |

Implement tokens as **literal hex colors** inside a `<style>` block (classes `.canvas`, `.node`, `.link`, …). Light and dark files should share structure; only the hex values in the style block differ.

### PDF / rsvg critical rules

Quarto PDF converts SVG → PDF with:

```bash
rsvg-convert -f pdf -a -o out.pdf in.svg
```

Two failure modes:

| Problem | Cause | Fix |
|---------|--------|-----|
| **Solid black figure** | CSS `var(--token)` unsupported by librsvg | Use **literal hex** in `<style>` classes |
| **Blurry / soft figure** | `filter` / `feDropShadow` (and similar) force **raster** XObjects at ~96 DPI | **No SVG filters** on illustrated diagrams — pure strokes/fills only |

| Do | Don't |
|----|--------|
| `.canvas { fill: #eef2f7; }` | `fill: var(--canvas)` |
| Hard edges, subtle stroke contrast | `filter="url(#soft)"` / `feDropShadow` |
| Dual light/dark files | One file that relies only on `prefers-color-scheme` + vars |

Smoke-tests after editing:

```bash
# Not black
rsvg-convert -f png -o /tmp/check.png images/diagram-<topic>.svg

# Pure vector PDF (must report 0 Image XObjects)
rsvg-convert -f pdf -a -o /tmp/check.pdf images/diagram-<topic>.svg
# python: open bytes and assert b.count(b"/Image") == 0
```

---

## Structure checklist

- [ ] Root: `xmlns`, `viewBox`, `role="img"`, `aria-label="…"`, `color-scheme="light"` or `"dark"`
- [ ] Self-contained **rounded card** (`rx≈16`) — never rely on page background for contrast
- [ ] Subtle grid pattern + soft drop shadow optional
- [ ] Titles: `ui-sans-serif, system-ui, sans-serif`
- [ ] IPs / CIDRs: `ui-monospace, SFMono-Regular, Menlo, monospace`
- [ ] Stroke widths ≥ ~1.4 for print/PDF
- [ ] No external fonts, images, or network URLs
- [ ] Filename: `diagram-<topic>.svg` under that book’s `images/`
- [ ] Dark sibling: `diagram-<topic>-dark.svg` for every illustrated figure
- [ ] Embed (markdown always light path):

```markdown
![Short caption](../../images/diagram-<topic>.svg){fig-alt="Longer accessible description"}
```

From `index.qmd` use `images/...` (no `../../`).

---

## Theme-swap script (HTML)

Every book that ships dual-theme diagrams should include the swap logic in `styles/reader-mode-body.html` (already wired via `include-after-body` in generated `_quarto.yml`).

Canonical fragment: `includes/diagrams/theme-swap.fragment.html`

Behavior:

- If `body.quarto-dark` → rewrite `diagram-foo.svg` → `diagram-foo-dark.svg`
- Else → rewrite `*-dark.svg` → light
- Skip mono/concept diagrams (`diagram-concept-*`, `diagram-mono-*`, plus known legacy mono stems)

---

## Agent workflow (new diagram)

1. Read **this file** and open **`reference/diagram-reference-topology.svg`**.
2. Copy light + dark reference (or an existing illustrated figure) as a starting point.
3. Redraw geometry/labels for the topic; **keep token names and card treatment**.
4. Place both files in `books/<Book>/images/`.
5. Ensure that book’s `update-index.sh` includes `images/*-dark.svg` resources and `reader-mode-body.html` includes the theme-swap fragment.
6. Embed the **light** path only in `.qmd`.
7. Spot-check HTML light + dark toggle and PDF once.

---

## Do not

- Invent per-book color systems for topology figures.
- Use pure white `#ffffff` full-bleed figures that glare on dark pages without a dark sibling.
- Hand-edit `_quarto.yml` for resources — edit `scripts/update-index.sh` instead.
- Point markdown at `*-dark.svg` (breaks PDF/EPUB and light mode).
