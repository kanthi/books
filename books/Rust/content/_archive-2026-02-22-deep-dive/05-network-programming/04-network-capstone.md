# Network Programming Capstone

## Objective

Build a resilient network service with clear protocol boundaries and operational controls.

## Suggested Projects

- rate-limited API gateway
- TCP event collector
- gRPC task dispatcher
- QUIC-based telemetry forwarder

## Required Deliverables

- protocol documentation
- timeout/retry policy
- load test summary
- failure-mode test cases
- runbook for on-call debugging

## Example Milestone Plan

1. Week 1: protocol + schema design.
2. Week 2: core request handling.
3. Week 3: resilience and observability.
4. Week 4: load tests and tuning.

## Review Questions

- What happens when downstream is slow?
- What happens when clients send malformed frames?
- How do you detect saturation quickly?

## Extended Evaluation Rubric

- Protocol correctness under malformed input.
- Throughput behavior at 50%, 75%, 90% saturation.
- Recovery time after downstream outage.
- Operator usability from logs and metrics.
