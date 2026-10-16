# Python for Scientific Computing (Python4College)

A practical, hands-on guide to programming, numerical analysis, data visualization, and reliable code engineering for college and university students using Python, the Anaconda Distribution (2026 release), and the Spyder 6 IDE.

## Overview

This book is designed for students with zero prior programming experience. It emphasizes:
- Hands-on, runnable examples for every topic
- Direct problem-solving with Python lists, functions, and modules
- Vectorized numerical computing and linear algebra with **NumPy**
- Publication-quality scientific figures and dashboards with **Matplotlib**
- Real-world file handling, data logging, and clean text formatting
- Defensive programming, debugging with Spyder's visual tools, and exception handling
- Four Milestone Projects and a comprehensive Capstone Data Analysis Pipeline

## Book Structure

```text
content/
├── 00-getting-started/
│   └── 01-setting-up-anaconda-and-spyder.qmd
├── 01-core-data-structures-and-functions/
│   ├── 01-lists.qmd
│   ├── 02-functions.qmd
│   ├── 03-modules.qmd
│   └── 04-milestone-project-1.qmd
├── 02-numerical-computing-with-numpy/
│   ├── 01-numpy-arrays.qmd
│   ├── 02-array-methods-and-operations.qmd
│   ├── 03-random-numbers.qmd
│   ├── 04-linear-algebra.qmd
│   └── 05-milestone-project-2.qmd
├── 03-visualization-with-matplotlib/
│   ├── 01-basic-plotting.qmd
│   ├── 02-figures-axes-and-subplots.qmd
│   └── 03-milestone-project-3.qmd
├── 04-files-and-text-formatting/
│   ├── 01-file-handling-and-io.qmd
│   ├── 02-string-formatting.qmd
│   └── 03-milestone-project-4.qmd
├── 05-reliable-code/
│   ├── 01-testing-and-debugging.qmd
│   ├── 02-exceptions.qmd
│   └── 03-capstone-project.qmd
└── 99-appendices/
    ├── 01-appendix-a-spyder-shortcuts.qmd
    ├── 02-appendix-b-numpy-quick-reference.qmd
    ├── 03-appendix-c-matplotlib-properties.qmd
    ├── 04-appendix-d-fstring-formatting.qmd
    ├── 05-appendix-e-common-errors.qmd
    ├── 06-appendix-f-managing-packages.qmd
    ├── 07-appendix-g-suggested-reading.qmd
    └── 08-appendix-h-solutions-to-selected-exercises.qmd
```

## Building Locally

To build HTML, PDF, or EPUB formats:

```bash
# Regenerate configuration from content structure:
bash scripts/update-index.sh

# Render to HTML:
quarto render --to html
```
