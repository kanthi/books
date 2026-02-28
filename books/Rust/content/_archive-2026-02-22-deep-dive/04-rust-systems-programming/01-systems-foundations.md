# Systems Programming Foundations in Rust

## Files and Paths

```rust
use std::fs;
use std::path::Path;

fn read_config(path: &Path) -> std::io::Result<String> {
    fs::read_to_string(path)
}
```

## Process Management

```rust
use std::process::Command;

fn main() {
    let output = Command::new("echo")
        .arg("hello")
        .output()
        .expect("process failed");

    println!("{}", String::from_utf8_lossy(&output.stdout));
}
```

## Error Propagation in System Tools

```rust
fn load() -> Result<String, Box<dyn std::error::Error>> {
    Ok(std::fs::read_to_string("settings.toml")?)
}
```

## Resource Lifecycle

Rust RAII makes cleanup predictable: file handles and sockets close when values leave scope.

## Practice

1. Build `cat-lite` that prints a file safely.
2. Build `run-and-log` wrapper for shell commands.
3. Add structured errors for missing files and invalid args.

## Deep Dive: Robust File Handling

Use atomic write patterns for config/state files.

```rust
use std::fs;
use std::io::Write;

fn atomic_write(path: &str, content: &str) -> std::io::Result<()> {
    let tmp = format!("{path}.tmp");
    let mut f = fs::File::create(&tmp)?;
    f.write_all(content.as_bytes())?;
    f.sync_all()?;
    fs::rename(tmp, path)?;
    Ok(())
}
```

## Process Exit Status Handling

```rust
use std::process::Command;

fn run_checked(cmd: &str, arg: &str) -> anyhow::Result<String> {
    let out = Command::new(cmd).arg(arg).output()?;
    if !out.status.success() {
        anyhow::bail!("command failed: {}", out.status);
    }
    Ok(String::from_utf8_lossy(&out.stdout).to_string())
}
```

## Filesystem Safety Checklist

- validate user-supplied paths
- avoid symlink traversal risks
- preserve permissions intentionally

## Review Questions

1. Why prefer atomic file writes for state?
2. Why inspect exit status before parsing stdout?
3. What risks come from trusting raw user path input?
