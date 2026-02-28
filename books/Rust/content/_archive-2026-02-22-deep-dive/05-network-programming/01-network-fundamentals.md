# Network Programming Fundamentals in Rust

## Core Concepts

- Transport choices: TCP (reliable stream) vs UDP (datagram, low overhead).
- Connection lifecycle: accept, read, write, close.
- Throughput and latency are both design constraints.

## TCP Echo Client

```rust
use std::io::{Read, Write};
use std::net::TcpStream;

fn main() -> std::io::Result<()> {
    let mut stream = TcpStream::connect("127.0.0.1:9000")?;
    stream.write_all(b"ping\n")?;

    let mut buf = [0_u8; 64];
    let n = stream.read(&mut buf)?;
    println!("{}", String::from_utf8_lossy(&buf[..n]));
    Ok(())
}
```

## UDP Example

```rust
use std::net::UdpSocket;

fn main() -> std::io::Result<()> {
    let socket = UdpSocket::bind("127.0.0.1:0")?;
    socket.send_to(b"hello", "127.0.0.1:7001")?;
    Ok(())
}
```

## Frame Parsing Pattern

Avoid assuming one read equals one message. For stream protocols, add framing:

- length-prefix
- delimiter (`\n`)
- fixed-size records

## Practice

1. Build TCP line echo server.
2. Add client inactivity timeout.
3. Add request counter metric.

## Deep Dive: Connection State and Resource Limits

Track connection lifecycle explicitly:

- accepted
- authenticated
- active
- draining
- closed

Set limits for each stage to avoid overload.

## Async TCP Accept Loop Sketch

```rust
use tokio::net::TcpListener;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let listener = TcpListener::bind("127.0.0.1:9100").await?;
    loop {
        let (_socket, addr) = listener.accept().await?;
        println!("accepted from {addr}");
    }
}
```

## Review Questions

1. Why must services define connection limits?
2. What happens if per-connection buffers are unbounded?
