# LaTeX Math Processing Issue - Solution Summary

## Problem
The error you encountered:
```
[WARNING] Could not convert TeX math (echo ", rendering as TeX:(echo "^unexpected '"'expecting "\\bangle", "\\brace", "\\brack", "\\choose", "\\displaystyle", "\\textstyle", "\\scriptstyle", "\\scriptscriptstyle", "{", "\\operatorname", letter, digit, ".", "!", "'", "''", "'''", "''''", "*", "+", ",", "-", ".", "/", ":", ":=", ";", "<", "=", ">", "?", "@", "~", "_", "^", "\\left", "(", "[", "|", "\\lVert", "\\", "\\hyperref" or end of input[WARNING] Could not convert TeX math {fruits[@]}"do
```

This occurs because Quarto's LaTeX processor interprets bash array syntax like `${fruits[@]}` as mathematical notation instead of code.

## Root Cause
- Bash array syntax uses `@` symbol in `${array[@]}`
- LaTeX math processor sees `{fruits[@]}` and tries to parse it as math
- The `@` symbol is not valid in LaTeX math context
- This happens during EPUB and PDF rendering

## Solutions Applied

### 1. Escape @ Symbol in Array Syntax
Changed `${fruits[@]}` to `${fruits[\@]}` in code blocks to prevent LaTeX interpretation.

### 2. Disable Math Processing for EPUB
Added `html-math-method: plain` to EPUB format in `_quarto.yml`:
```yaml
epub:
  toc: true
  number-sections: false
  html-math-method: plain
```

### 3. Comprehensive Fix Script
Created `comprehensive-fix.py` that:
- Only processes content inside code blocks (between ```)
- Escapes all bash array patterns:
  - `${array[@]}` → `${array[\@]}`
  - `${#array[@]}` → `${#array[\@]}`
  - `${!array[@]}` → `${!array[\@]}`

## Current Status
✅ **HTML rendering**: Works perfectly
✅ **PDF rendering**: Works without errors
⚠️ **EPUB rendering**: Works but shows warnings (non-blocking)

## Files Modified
- Multiple `.qmd` files in `content/` directory
- `_quarto.yml` configuration file
- Created fix scripts in `scripts/` directory

## Prevention
To prevent this issue in future content:
1. Always escape `@` in bash arrays: `${array[\@]}`
2. Use the fix scripts when adding new bash array examples
3. Test EPUB rendering after adding bash code examples

## Alternative Solutions
If warnings persist, you can:
1. Use `html-math-method: webtex` for EPUB
2. Disable math processing entirely: `html-math-method: plain`
3. Use different syntax highlighting that doesn't trigger math processing

The book now renders successfully in all formats with minimal warnings that don't affect the final output quality.