# Boring Python

Linear, example-heavy Python book: write clear, explicit, maintainable programs.

- **Baseline:** Python 3.14
- **Toolchain:** `uv`, `ruff`, `pytest`
- **Examples:** complete runnable listings **inline in each chapter** — no separate `.py` tree

Do not hand-edit `_quarto.yml`. After adding or renaming chapters:

```bash
cd Boring-Python
bash scripts/update-index.sh
```
