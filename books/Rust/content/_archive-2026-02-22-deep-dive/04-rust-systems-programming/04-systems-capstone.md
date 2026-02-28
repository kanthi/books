# Systems Capstone

## Objective

Build a production-style Rust system service that is observable, testable, and resilient.

## Recommended Project Ideas

- log shipping daemon
- file integrity monitor
- local service supervisor
- network health collector

## Minimum Deliverables

- CLI or HTTP interface
- config loading + validation
- structured logging + basic metrics
- graceful shutdown behavior
- integration tests

## Architecture Template

```text
src/
  main.rs
  config.rs
  service.rs
  io.rs
  errors.rs
tests/
  smoke.rs
```

## Acceptance Criteria

- Handles invalid config without panic.
- Survives transient I/O errors with retries.
- Exposes operational signals for debugging.
- Includes README with runbook section.

## Stretch Goals

1. Add tracing + OpenTelemetry export.
2. Add load test results and tuning notes.
3. Add systemd service unit sample.

## Detailed Milestones

1. Architecture and threat/risk assumptions.
2. Core functionality and acceptance tests.
3. Reliability controls (timeouts/retries/shutdown).
4. Observability and runbook completion.
5. Load/failure validation and final report.

## Example Runbook Outline

```text
- Service purpose and dependencies
- Startup checks
- Common alerts and first actions
- Safe restart/rollback steps
- Contact and escalation rules
```

## Demonstration Checklist

- show normal workload behavior
- simulate one dependency failure
- show logs/metrics/traces during incident
- show recovery and post-incident notes

## Review Questions

1. Which design tradeoff had highest impact on reliability?
2. What was your biggest operational blind spot initially?
3. What would you refactor for v2?
