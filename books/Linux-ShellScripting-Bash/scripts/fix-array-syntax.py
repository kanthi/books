#!/usr/bin/env python3

import os
import re
import glob

def fix_bash_arrays_in_file(filepath):
    """Fix bash array syntax that causes LaTeX math interpretation issues."""

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Track if we're inside a code block
    lines = content.split('\n')
    fixed_lines = []
    in_code_block = False

    for line in lines:
        # Check for code block markers
        if line.strip().startswith('```'):
            in_code_block = not in_code_block
            fixed_lines.append(line)
            continue

        # Only fix array syntax inside code blocks
        if in_code_block:
            # Fix common bash array patterns
            # ${array[@]} -> \${array[@]}
            line = re.sub(r'\$\{([^}]*)\[@\]([^}]*)\}', r'\\${\1[@]\2}', line)
            # ${#array[@]} -> \${#array[@]}
            line = re.sub(r'\$\{#([^}]*)\[@\]([^}]*)\}', r'\\${#\1[@]\2}', line)
            # ${!array[@]} -> \${!array[@]}
            line = re.sub(r'\$\{!([^}]*)\[@\]([^}]*)\}', r'\\${!\1[@]\2}', line)

        fixed_lines.append(line)

    # Write back the fixed content
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write('\n'.join(fixed_lines))

    print(f"Fixed: {filepath}")

def main():
    content_dir = os.path.join(os.path.dirname(__file__), '..', 'content')

    # Find all .qmd files
    qmd_files = glob.glob(os.path.join(content_dir, '**', '*.qmd'), recursive=True)

    print(f"Found {len(qmd_files)} .qmd files to process")

    for filepath in qmd_files:
        # Check if file contains problematic patterns
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            if '${' in content and '[@]' in content:
                # Create backup
                backup_path = filepath + '.bak3'
                with open(backup_path, 'w', encoding='utf-8') as backup:
                    backup.write(content)

                fix_bash_arrays_in_file(filepath)

    print("All files processed!")

if __name__ == '__main__':
    main()