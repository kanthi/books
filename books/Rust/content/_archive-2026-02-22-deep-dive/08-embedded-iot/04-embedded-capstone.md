# Embedded and IoT Capstone

## Objective

Deliver a firmware-oriented Rust project with deterministic behavior and clear operational limits.

## Suggested Projects

- sensor collector with serial uplink
- smart relay controller
- low-power telemetry node
- watchdog-supervised actuator loop

## Required Deliverables

- hardware and pin map documentation
- timing and memory budget table
- fault handling plan (brownout/reset/retry)
- test strategy for host + hardware-in-loop

## Validation Checklist

- no uncontrolled panics in normal operation
- bounded memory usage in critical loops
- deterministic recovery behavior after fault

## Extended Capstone Deliverables

- boot and recovery sequence diagram
- timing traces under normal and fault conditions
- memory map and static allocation report
