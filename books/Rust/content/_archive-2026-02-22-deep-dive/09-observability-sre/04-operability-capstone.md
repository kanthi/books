# Operability Capstone

## Goal

Upgrade an existing Rust service so it is genuinely operable by an on-call engineer.

## Required Improvements

- structured logs with correlation IDs
- endpoint latency and error metrics
- distributed traces for critical path
- runbook with failure playbooks

## Delivery Artifacts

- observability architecture diagram
- dashboard screenshots and interpretations
- alert policy and escalation path
- postmortem template with sample incident

## Success Criteria

- on-call can identify root cause quickly
- alerts are actionable and low-noise
- incident response steps are reproducible

## Demo Script for Final Review

1. show baseline dashboard
2. trigger controlled failure
3. identify alert and root cause
4. apply mitigation
5. verify recovery metrics
