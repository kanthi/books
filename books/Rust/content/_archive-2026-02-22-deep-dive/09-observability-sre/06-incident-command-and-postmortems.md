# Incident Command and Postmortems

## Incident Roles

- Incident Commander
- Communications Lead
- Operations Driver
- Subject Matter Experts

## Incident Timeline Diagram

```mermaid
sequenceDiagram
    participant A as Alerting
    participant IC as Incident Commander
    participant ENG as Engineers
    participant STK as Stakeholders
    A->>IC: page triggered
    IC->>ENG: assign responders
    ENG->>IC: mitigation status
    IC->>STK: impact update
    ENG->>IC: recovery complete
    IC->>STK: resolved + follow-up plan
```

## Postmortem Template

1. Summary and impact
2. Detection and response timeline
3. Root cause analysis
4. Corrective and preventive actions
5. Ownership and due dates

## Lab

1. Run tabletop incident drill.
2. Produce a blameless postmortem document.
3. Track action items to closure in backlog.
