# Protocol Design and Versioning

## Protocol Design Goals

- unambiguous framing
- backward-compatible evolution path
- clear error semantics

## Packet Structure Example

```text
| magic (2 bytes) | version (1) | type (1) | length (4) | payload (N) |
```

## Protocol Processing Diagram

```mermaid
flowchart LR
    A[Read bytes] --> B[Validate header]
    B --> C[Check version]
    C --> D[Parse payload]
    D --> E[Dispatch handler]
    E --> F[Serialize response]
```

## Parser Skeleton

```rust
#[derive(Debug)]
struct Frame {
    version: u8,
    kind: u8,
    payload: Vec<u8>,
}

fn parse_frame(buf: &[u8]) -> Result<Frame, &'static str> {
    if buf.len() < 8 {
        return Err("short frame");
    }
    let version = buf[2];
    let kind = buf[3];
    let len = u32::from_be_bytes([buf[4], buf[5], buf[6], buf[7]]) as usize;
    if buf.len() < 8 + len {
        return Err("incomplete payload");
    }
    Ok(Frame {
        version,
        kind,
        payload: buf[8..8 + len].to_vec(),
    })
}
```

## Versioning Rules

- reject unknown critical versions cleanly
- allow additive fields for forwards compatibility
- document deprecation windows

## Lab

1. Implement v1 parser/serializer.
2. Add v2 optional field support.
3. Validate compatibility with mixed-version tests.
