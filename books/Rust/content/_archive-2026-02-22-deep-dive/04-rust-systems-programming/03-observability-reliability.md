# Observability and Reliability

## Structured Logging

```rust
use tracing::{error, info};

fn process(id: u64) {
    info!(request_id = id, "starting request");
    // business logic
    error!(request_id = id, "example error event");
}
```

## Metrics You Should Start With

- request count
- error count
- latency histogram
- queue depth

## Graceful Shutdown Sketch

```rust
use tokio::signal;

#[tokio::main]
async fn main() {
    println!("service started");
    signal::ctrl_c().await.unwrap();
    println!("shutdown signal received");
}
```

## Reliability Patterns

- Timeouts for external calls.
- Retries with exponential backoff and jitter.
- Circuit breakers for persistent downstream failures.

## Practice

1. Add correlation IDs to logs.
2. Add latency measurement around one endpoint.
3. Implement graceful shutdown with timeout budget.

## Deep Dive: Retry Classification

Not every failure should be retried.

Retry candidates:

- timeout
- temporary network reset
- 503/overloaded downstream

Do not retry:

- validation failures
- auth/authz errors
- malformed request payloads

## Example: Bounded Retry Loop

```rust
async fn retry_n<F, Fut, T, E>(mut f: F, attempts: usize) -> Result<T, E>
where
    F: FnMut() -> Fut,
    Fut: std::future::Future<Output = Result<T, E>>,
{
    let mut last = None;
    for _ in 0..attempts {
        match f().await {
            Ok(v) => return Ok(v),
            Err(e) => last = Some(e),
        }
    }
    Err(last.expect("attempts must be > 0"))
}
```

## Reliability Readiness Checklist

- startup dependency checks
- graceful shutdown budget
- overload behavior documented
- failure metrics and alerts present

## Review Questions

1. What makes retry logic dangerous if unchecked?
2. Why should shutdown have a fixed deadline?
3. What telemetry is needed to detect silent degradation?
