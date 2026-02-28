# Reliability Patterns for Services

## Circuit Breaker State Machine

- `Closed`: normal traffic
- `Open`: fail fast after repeated failures
- `HalfOpen`: probe recovery with limited requests

## Semaphore for Load Shedding

```rust
use tokio::sync::Semaphore;

#[tokio::main]
async fn main() {
    let sem = Semaphore::new(100);
    let permit = sem.acquire().await.unwrap();
    drop(permit);
}
```

## Health Endpoints

- `/health/live`: process is alive
- `/health/ready`: dependencies acceptable
- `/health/startup`: initialization complete

## Retry Guardrails

- retry only transient failures
- apply max attempts and max elapsed duration
- add jitter to avoid synchronized retry storms

## Practice

1. Add readiness endpoint that checks one dependency.
2. Add semaphore guard to expensive path.
3. Add retry classification by error type.

## Deep Dive: Hedged Requests (Carefully)

Send backup request after short delay when latency spikes.

Use cautiously to avoid doubling load during incidents.

## Review Questions

1. When are hedged requests helpful?
2. Why can they worsen outage conditions?
