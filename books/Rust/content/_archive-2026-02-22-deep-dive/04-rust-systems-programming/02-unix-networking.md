# Unix Tooling and Networking

## Unix-Style CLI Tooling

Good Unix tools:

- read from stdin
- write to stdout
- return meaningful exit codes

```rust
use std::io::{self, Read};

fn main() -> io::Result<()> {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input)?;
    println!("lines={}", input.lines().count());
    Ok(())
}
```

## TCP Server Example

```rust
use std::io::{Read, Write};
use std::net::TcpListener;

fn main() -> std::io::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:9000")?;
    for stream in listener.incoming() {
        let mut stream = stream?;
        let mut buf = [0_u8; 1024];
        let n = stream.read(&mut buf)?;
        stream.write_all(&buf[..n])?;
    }
    Ok(())
}
```

## Handling Long-Running Services

- Add timeouts.
- Bound resource use.
- Handle OS signals for graceful stop.

## Practice

1. Build an echo server with line-based protocol.
2. Add max frame size to avoid memory abuse.
3. Add basic metrics counters.

## Deep Dive: Stream Framing

Network reads can return partial frames. Always decode incrementally.

```rust
fn split_lines(buf: &mut Vec<u8>) -> Vec<String> {
    let mut out = Vec::new();
    while let Some(pos) = buf.iter().position(|b| *b == b'\n') {
        let line = buf.drain(..=pos).collect::<Vec<_>>();
        out.push(String::from_utf8_lossy(&line).trim().to_string());
    }
    out
}
```

## Socket Options Worth Knowing

- `set_nodelay(true)` for low-latency small writes
- read/write timeouts for stuck peers
- keepalive for dead connection detection

## CLI Filter Example

```rust
use std::io::{self, BufRead};

fn main() {
    let stdin = io::stdin();
    for line in stdin.lock().lines().map_while(Result::ok) {
        if line.contains("ERROR") {
            println!("{line}");
        }
    }
}
```

## Review Questions

1. Why is newline framing useful but limited?
2. When should you disable Nagle (`TCP_NODELAY`)?
3. What is the simplest way to make a CLI Unix-friendly?
