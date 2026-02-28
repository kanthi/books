# OpenTelemetry and Instrumentation Patterns

## Context Propagation

When one service calls another, propagate trace context headers.

## Span Example

```rust
use tracing::{info_span, Instrument};

async fn do_work() {
    let span = info_span!("job", job_id = 42);
    async {
        // work here
    }
    .instrument(span)
    .await;
}
```

## Instrumentation Principles

- Instrument business boundaries, not every line.
- Prefer stable semantic names.
- Keep attribute cardinality controlled.

## Dashboard Design

Start with service-level views:

- request rate
- error rate
- p95 latency
- dependency health

## Practice

1. Add spans for handler, service, and repository layers.
2. Add dashboard for golden signals.
3. Add trace-to-log correlation in one incident workflow.

## Deep Dive: Span Taxonomy

Adopt consistent span names:

- `http.request`
- `db.query`
- `cache.get`
- `queue.publish`

Consistency improves cross-team debugging.

## Review Questions

1. Why standard span naming matters in large organizations?
2. What causes trace noise and how do you reduce it?
