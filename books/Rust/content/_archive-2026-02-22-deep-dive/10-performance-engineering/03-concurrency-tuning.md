# Concurrency and Throughput Tuning

## Tuning Levers

- worker count
- queue size
- batch size
- lock granularity

## Bounded Concurrency Example

```rust
use tokio::sync::Semaphore;
use std::sync::Arc;

#[tokio::main]
async fn main() {
    let sem = Arc::new(Semaphore::new(32));
    let permit = sem.acquire().await.unwrap();
    drop(permit);
}
```

## Contention Reduction Ideas

- shard shared maps by key hash
- prefer message passing where practical
- move blocking work off async runtime threads

## Throughput vs Latency

High batching increases throughput but may increase tail latency. Tune against your service objective, not synthetic maxima.

## Practice

1. Sweep worker counts and plot throughput vs p95 latency.
2. Reduce one lock hotspot with sharding or queue model.
3. Add backpressure behavior when queue is full.

## Deep Dive: Queue Backpressure Policies

When queue is full choose one:

- reject newest
- drop oldest
- block producer
- route to dead-letter channel

Policy depends on correctness and latency goals.

## Review Questions

1. Why is unlimited queue growth dangerous?
2. Which policy fits latency-sensitive APIs best?
