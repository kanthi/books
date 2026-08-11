# Networking diagrams

**Style is monorepo-wide.** Do not invent a Networking-only palette.

| Doc | Path |
|-----|------|
| **Standard** | `includes/diagrams/STANDARD.md` |
| **Visual reference** | `includes/diagrams/reference/diagram-reference-topology.svg` (+ `-dark`) |

The hero figure `diagram-dist-switch-multihome.svg` (+ `-dark`) is the **first production exemplar** of that standard (same look as the monorepo reference).

## Inventory (this book)

| File | Chapter use | Dark sibling |
|------|-------------|--------------|
| `diagram-dist-switch-multihome.svg` | Index hero, L2 Ethernet, syllabus | yes |
| `diagram-mac-learning.svg` | Ethernet & MAC | pending |
| `diagram-vlan-trunk.svg` | VLANs & trunks | pending |
| `diagram-lab-triangle.svg` | Containerlab, statics | pending |
| `diagram-leaf-spine.svg` | Clos leaf-spine | pending |
| `diagram-encapsulation.svg` etc. (mono) | Models / habits | n/a |

When adding illustrated figures: dual files + reference tokens + theme-swap (already in `styles/reader-mode-body.html`). Embed light path only.
