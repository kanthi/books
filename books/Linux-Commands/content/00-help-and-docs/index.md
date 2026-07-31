# Help and documentation tools

This part covers how to find answers **on the system itself** before searching the web.

| Command | Role |
|---------|------|
| `man` | Full manuals by section |
| `info` | Texinfo hypertext manuals |
| `help` | Shell builtin help (`bash`/`zsh`) |
| `whatis` | One-line man summaries |
| `apropos` | Keyword search of man names/descriptions |

## Suggested workflow
1. `whatis cmd` or `cmd --help` for a quick hint.  
2. `man cmd` for the full story; try `man 5`/`man 8` for configs/admin.  
3. `apropos keyword` when you forget the command name.  
4. `info coreutils` for deep GNU tool docs.  
5. For short community examples, tools like `tldr` are optional extras.

## Shell builtins vs external commands
```bash
type ls
type cd
help cd          # builtin
man ls           # external
```

Continue with the individual command pages in this part.
