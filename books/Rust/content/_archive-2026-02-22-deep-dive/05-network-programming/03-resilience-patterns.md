# Resilience Patterns for Network Services

## Timeouts Everywhere

Every outbound call needs timeout boundaries.

```rust
use tokio::time::{timeout, Duration};

async fn fetch_with_timeout<F, T>(fut: F) -> Result<T, &'static str>
where
    F: std::future::Future<Output = T>,
{
    timeout(Duration::from_millis(200), fut)
        .await
        .map_err(|_| "timeout")
}
```

## Retry with Jitter

```rust
use rand::{thread_rng, Rng};
use tokio::time::{sleep, Duration};

async fn backoff(attempt: u32) {
    let base = 20_u64 * (2_u64.pow(attempt.min(6)));
    let jitter = thread_rng().gen_range(0..25_u64);
    sleep(Duration::from_millis(base + jitter)).await;
}
```

## Circuit Breaker Rules

- Open after N consecutive failures.
- Half-open after cooldown.
- Close on successful probe.

## Bulkheads and Limits

- Separate worker pools for critical paths.
- Limit concurrency with semaphore.
- Drop low-priority work under overload.

## Practice

1. Add timeout + retry wrapper to one client call.
2. Add max in-flight request limit.
3. Add failure-rate logging every 10 seconds.

## Deep Dive: Load Shedding Policy

When saturated:

1. reject low-priority requests quickly
2. protect core critical paths
3. emit clear overload metrics

## Token Bucket Sketch

```rust
struct TokenBucket {
    tokens: u32,
    max: u32,
}

impl TokenBucket {
    fn allow(&mut self) -> bool {
        if self.tokens == 0 {
            return false;
        }
        self.tokens -= 1;
        true
    }
}
```

## Review Questions

1. Why is fail-fast often better than queue growth?
2. What signals should trigger load shedding?
