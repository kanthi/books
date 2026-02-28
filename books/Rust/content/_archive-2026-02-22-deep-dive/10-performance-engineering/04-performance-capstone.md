# Performance Engineering Capstone

## Goal

Deliver a measurable, repeatable performance improvement for a real Rust service.

## Required Methodology

- define baseline workload
- collect pre-change metrics
- apply targeted optimization
- collect post-change metrics
- document tradeoffs and rollback plan

## Report Template

```text
1. Baseline metrics
2. Bottleneck analysis
3. Changes made
4. Results (before vs after)
5. Side effects and risk
6. Next tuning opportunities
```

## Evaluation Criteria

- improvements are statistically meaningful
- no correctness regressions
- operational risk is understood
- future maintainers can reproduce benchmark setup

## Extended Validation Checklist

- benchmark repeatability verified
- latency percentile improvements sustained
- CPU/memory overhead tradeoffs documented
- rollback path tested before release
