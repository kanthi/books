# Application Protocols: HTTP, gRPC, and QUIC

## Choosing a Protocol

- HTTP/JSON: best for broad interoperability.
- gRPC: contract-first, strong typing, efficient binary encoding.
- QUIC: low latency, multiplexed streams over UDP.

## HTTP with Axum Example

```rust
use axum::{routing::get, Router};

async fn health() -> &'static str {
    "ok"
}

#[tokio::main]
async fn main() {
    let app = Router::new().route("/health", get(health));
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}
```

## gRPC Design Tips

- Keep messages small and explicit.
- Version service contracts.
- Handle deadlines and cancellation.

## QUIC Use Cases

- Real-time collaboration tools.
- High-latency and mobile networks.
- Multi-stream transfer with reduced head-of-line blocking.

## Practice

1. Implement `/health` and `/version` HTTP endpoints.
2. Define one gRPC service with request/response types.
3. Document why you chose HTTP or gRPC for your project.

## Deep Dive: API Contract Evolution

Versioning rules:

- add optional fields safely
- avoid removing existing fields abruptly
- deprecate with explicit migration window

## JSON Contract Example

```json
{
  "version": 1,
  "request_id": "abc-123",
  "payload": {
    "user_id": 42
  }
}
```

## Review Questions

1. Why is explicit versioning critical in distributed APIs?
2. What breaks clients most often during API evolution?
