# Async Rust and Performance Engineering

## Async Mental Model

`async fn` returns a future. Work runs when the future is polled by a runtime (for example Tokio).

## Tokio Example

```rust
use tokio::time::{sleep, Duration};

#[tokio::main]
async fn main() {
    let a = task("a", 100);
    let b = task("b", 50);
    let (ra, rb) = tokio::join!(a, b);
    println!("{ra} {rb}");
}

async fn task(name: &str, ms: u64) -> String {
    sleep(Duration::from_millis(ms)).await;
    format!("done-{name}")
}
```

## Bounded Concurrency

```rust
use futures::{stream, StreamExt};

async fn run_jobs(ids: Vec<u32>) {
    stream::iter(ids)
        .for_each_concurrent(8, |id| async move {
            println!("processing {id}");
        })
        .await;
}
```

## Performance Baseline

- Measure first, then optimize.
- Track p50, p95, p99 latency.
- Inspect allocation counts.

## Benchmark Example

```rust
// benches/sum.rs (criterion)
fn sum(v: &[u64]) -> u64 { v.iter().sum() }
```

Use `criterion` for statistically meaningful benches.

## Practice

1. Convert a sync downloader to async.
2. Add bounded concurrency and timeout handling.
3. Benchmark before/after throughput.

## Deep Dive: Cancellation and Structured Concurrency

Cancellation is a normal control path in async systems.

```rust
use tokio::time::{sleep, Duration};

async fn do_unit(id: u32) -> Result<u32, &'static str> {
    sleep(Duration::from_millis(50)).await;
    Ok(id * 2)
}

#[tokio::main]
async fn main() {
    let h = tokio::spawn(async { do_unit(7).await });
    let out = h.await.unwrap().unwrap();
    println!("{out}");
}
```

Use `JoinSet` or task groups to keep child task lifecycle explicit.

## Deep Dive: Latency Budgeting

Example request budget:

- ingress validation: 5ms
- DB read: 40ms
- downstream API: 80ms
- serialization/egress: 10ms

Total target: 135ms p95

## Benchmark Design Checklist

- fixed input corpus
- warmup stage
- independent repetitions
- report variance, not just mean

## Review Questions

1. Why is cancellation handling required for correctness?
2. What metric should guide API performance optimization first?
3. Why benchmark at p95/p99 and not only average latency?
