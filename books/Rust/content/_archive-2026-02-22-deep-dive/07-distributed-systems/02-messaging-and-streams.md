# Messaging and Stream Processing

## Queue Semantics

- at-most-once: possible loss, no duplicates
- at-least-once: no loss, duplicates possible
- exactly-once: expensive, context-specific

## Consumer Loop Sketch

```rust
fn handle_event(key: &str, payload: &[u8]) -> Result<(), &'static str> {
    if payload.is_empty() {
        return Err("empty payload");
    }
    println!("processing key={key} size={}", payload.len());
    Ok(())
}
```

## Ordering and Partitioning

Use stable keys to preserve per-entity ordering:

- customer ID
- order ID
- device ID

## Backpressure Tactics

- bounded queues
- slow-consumer detection
- shed non-critical work first

## Practice

1. Define event schema with version field.
2. Implement dedupe key for consumer side.
3. Add dead-letter strategy for poison events.

## Deep Dive: Event Schema Evolution

Rules:

- immutable event semantics
- additive changes preferred
- include event version and source metadata

## Example Event Envelope

```json
{
  "event_id": "evt-001",
  "event_type": "order.created",
  "version": 2,
  "occurred_at": "2026-02-22T00:00:00Z",
  "payload": {
    "order_id": "o-10"
  }
}
```

## Review Questions

1. Why separate envelope metadata from payload?
2. What causes consumer breakage during schema changes?
