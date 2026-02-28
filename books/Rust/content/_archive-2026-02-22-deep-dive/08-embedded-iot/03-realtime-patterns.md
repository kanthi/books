# Real-Time Patterns and Reliability

## Real-Time Thinking

- deterministic latency matters more than average throughput
- avoid unbounded allocations in critical paths
- keep interrupt handlers short

## Lock-Free or Bounded Communication

```rust
use heapless::spsc::Queue;

fn demo() {
    let mut q: Queue<u8, 8> = Queue::new();
    let _ = q.enqueue(1);
    let _ = q.dequeue();
}
```

## Priority Inversion Risk

If low-priority task holds shared resource, high-priority tasks may stall.

Mitigations:

- avoid long critical sections
- design ownership to minimize shared mutable state
- use priority-aware RTOS primitives when available

## Practice

1. Split ISR work into fast capture + deferred processing.
2. Replace dynamic `Vec` in hot path with bounded buffer.
3. Measure worst-case processing time per cycle.

## Deep Dive: Timing Budget Table

Track per-cycle timing:

- sensor read: 300us
- filter step: 500us
- control output: 200us
- margin: 200us

Total 1.2ms loop budget.

## Review Questions

1. Why track worst-case not average timing in control loops?
2. What is the first fix when loop budget is exceeded?
