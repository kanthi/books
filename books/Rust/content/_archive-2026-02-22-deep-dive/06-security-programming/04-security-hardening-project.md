# Security Hardening Project

## Goal

Take an existing Rust project and raise security maturity with measurable controls.

## Hardening Backlog

- enforce input bounds and schema validation
- tighten authz checks
- enable dependency audits in CI
- add TLS/mTLS where needed
- remove secret leakage risks

## Example Security Report Template

```text
1. Scope
2. Threat model summary
3. Findings (severity + impact)
4. Fixes shipped
5. Residual risks
6. Next iteration plan
```

## Minimum Acceptance

- no high-severity known dependency vulnerabilities
- authz tests for privileged paths
- secrets absent from logs
- documented incident rollback plan

## Stretch Goals

1. Add fuzz + property tests for parser components.
2. Add signed artifact workflow.
3. Add periodic security review automation.

## Hardening Sprint Plan

1. baseline risk assessment
2. implement highest-impact controls
3. run verification tests
4. produce signed-off hardening report

## Review Questions

1. What is the highest-value control you implemented?
2. Which risk remains and why?
