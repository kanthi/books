# Distributed Systems Capstone

## Objective

Build a small multi-service Rust platform that survives realistic failure scenarios.

## Project Blueprint

- API gateway service
- worker service
- message broker integration
- state store

## Required Scenarios

- duplicate message delivery
- slow/downstream service timeout
- partial outage in one component
- replay and recovery from backlog

## Deliverables

- architecture diagram
- failure test matrix
- SLO proposal and alerts
- runbook + rollback steps

## Evaluation Rubric

1. Correctness under retries.
2. Graceful degradation under dependency failure.
3. Observability quality during incidents.

## Extended Failure Test Matrix

- broker unavailable
- consumer lag growth
- duplicate delivery burst
- partial network partition
- stale cache and read-after-write mismatch
