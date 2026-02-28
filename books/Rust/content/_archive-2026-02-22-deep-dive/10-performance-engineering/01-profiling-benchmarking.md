# Profiling and Benchmarking Workflow

## Performance Engineering Process

1. define objective metric
2. baseline current performance
3. profile bottlenecks
4. optimize one change at a time
5. verify no regression

## Criterion Benchmark Example

```rust
fn sum_loop(v: &[u64]) -> u64 {
    let mut total = 0;
    for n in v {
        total += n;
    }
    total
}
```

Benchmark both naive and optimized versions.

## Profiling Targets

- CPU hotspots
- allocation-heavy paths
- lock contention
- syscall overhead

## Practice

1. Write two benchmarks for critical function.
2. Capture baseline p95 latency.
3. Add regression threshold in CI.

## Deep Dive: Benchmark Hygiene

- isolate noisy background processes
- pin consistent input sizes
- include warm and cold cache scenarios

## Review Questions

1. Why should benchmarks run in controlled environments?
2. What invalidates before/after performance comparison?
