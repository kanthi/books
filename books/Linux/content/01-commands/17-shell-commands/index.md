---
title: Intro
---

# Intro

Everyday shell built-ins and small utilities for output, history, name resolution, environment, timing, and the directory stack. Deeper programming belongs in the ShellScripting book.

## Commands in this part

| Command | Role |
|---------|------|
| `echo` | echo writes its arguments to standard output, separated by spaces, usually followed by a newline. |
| `printf` | printf formats and prints arguments using a format string, like C’s printf. |
| `history` | history shows the shell’s command history list (bash). |
| type / command | type explains how the shell will resolve a name — alias, keyword, function, builtin, or external file. |
| `export` | export marks shell variables for the environment so child processes inherit them. |
| `time` | time runs a command and reports how long it took. |
| pushd / popd / dirs | pushd, popd, and dirs maintain a directory stack in bash. |


## Suggested starting points

1. Print: `echo`, `printf`.
2. Recall: `history`.
3. What is this name?: `type` / `command`.
4. Environment: `export` (see also `env` in System information).
5. Measure: `time`; navigate: `pushd`/`popd`/`dirs`.

## Related parts

- Help and documentation tools — `help` for builtins
- Text and pipes — consume what you print
- Linux-ShellScripting-Bash — functions, arrays, strict mode

Continue with the individual command pages in this part.
