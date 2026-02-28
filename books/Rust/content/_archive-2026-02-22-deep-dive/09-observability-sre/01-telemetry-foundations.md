# Telemetry Foundations: Logs, Metrics, Traces

## Three Signals, Three Purposes

- Logs: detailed event context.
- Metrics: trends and alerting.
- Traces: request path across components.

## Structured Log Example

```rust
use tracing::info;

fn handle(user_id: u64, req_id: &str) {
    info!(user_id, req_id, "request accepted");
}
```

## Metric Design Tips

- Use low-cardinality labels.
- Track both success and failure counts.
- Add latency histograms per endpoint/class.

## Trace Boundary Strategy

Add spans at:

- ingress handler
- dependency calls
- critical business operations

## Practice

1. Add request ID to every log line.
2. Add one latency histogram metric.
3. Add one distributed trace from ingress to DB call.

## Deep Dive: Cardinality Control

Avoid unbounded labels such as raw user IDs in metrics.

Prefer:

- endpoint group
- status class
- region/zone

## Review Questions

1. Why can high-cardinality metrics destabilize monitoring systems?
2. Which data belongs in logs but not in metric labels?
