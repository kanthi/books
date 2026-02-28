# SRE Practices for Rust Services

## SLO Framework

Define Service Level Objectives with explicit user impact.

Example:

- Availability SLO: 99.9 percent monthly.
- Latency SLO: 95 percent requests under 250ms.

## Alerting Rules

Alert on symptoms, not internal noise.

Bad alert: CPU > 70 percent for 5 minutes.
Good alert: error budget burn rate exceeded.

## Incident Workflow

1. detect
2. contain
3. mitigate
4. communicate
5. review and improve

## Example Runbook Sections

- service purpose
- dependencies
- common failure signatures
- first-response commands
- rollback procedure

## Practice

1. Write one SLO and one burn-rate alert.
2. Create runbook for your top endpoint.
3. Perform a game-day simulation.

## Deep Dive: Error Budget Policy

When budget burn is high:

- pause risky releases
- prioritize reliability backlog
- increase instrumentation for top incidents

## Review Questions

1. Why is error budget a product decision tool, not only ops metric?
2. What action should follow sustained burn-rate alerts?
