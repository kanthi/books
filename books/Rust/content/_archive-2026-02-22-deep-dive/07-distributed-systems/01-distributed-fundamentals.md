# Distributed Systems Fundamentals

## Core Realities

- Networks fail.
- Clocks drift.
- Retries cause duplicates.
- Partial success is common.

## Idempotency Pattern

```rust
use std::collections::HashSet;

fn apply_payment(op_id: &str, processed: &mut HashSet<String>) -> bool {
    if processed.contains(op_id) {
        return false; // duplicate
    }
    processed.insert(op_id.to_string());
    true
}
```

## Consistency Choices

- Strong consistency: simpler reasoning, higher coordination cost.
- Eventual consistency: better availability, requires reconciliation.

## Timeout Budgeting

```text
Client timeout 1000ms
  Service A budget 800ms
    Downstream B budget 300ms
    Downstream C budget 300ms
```

## Practice

1. Add idempotency key support to one write endpoint.
2. Define timeout budgets for every dependency.
3. Document which operations are eventually consistent.

## Deep Dive: Exactly-Once Myth

In practice, systems usually implement at-least-once delivery with idempotent consumers.

## Idempotency Storage Example

```rust
use std::collections::HashMap;

fn remember(map: &mut HashMap<String, String>, key: &str, result: &str) -> String {
    if let Some(existing) = map.get(key) {
        return existing.clone();
    }
    map.insert(key.to_string(), result.to_string());
    result.to_string()
}
```

## Review Questions

1. Why is idempotency essential with retries?
2. What is the tradeoff of storing idempotency keys?
