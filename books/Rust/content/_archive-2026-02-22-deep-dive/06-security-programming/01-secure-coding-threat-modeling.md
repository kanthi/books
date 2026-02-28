# Secure Coding and Threat Modeling

## Threat Modeling Workflow

1. Identify assets (credentials, personal data, control plane).
2. Map trust boundaries.
3. Enumerate attacker goals.
4. Define mitigations and detection.

## Typical Rust Service Risks

- insecure deserialization
- unbounded input memory growth
- weak authentication logic
- sensitive data leaked in logs

## Input Validation Example

```rust
fn validate_username(s: &str) -> Result<(), &'static str> {
    if s.len() < 3 || s.len() > 32 {
        return Err("invalid length");
    }
    if !s.chars().all(|c| c.is_ascii_alphanumeric() || c == '_') {
        return Err("invalid characters");
    }
    Ok(())
}
```

## Principle: Deny by Default

Prefer explicit allowlists over broad acceptance.

## Practice

1. Draw a trust-boundary diagram for your service.
2. Add validation wrappers for all external inputs.
3. Add redaction for password-like fields in logs.

## Deep Dive: STRIDE-Lite Threat Sweep

For each component, ask:

- Spoofing: can identity be forged?
- Tampering: can data be modified silently?
- Repudiation: is audit evidence present?
- Information disclosure: are secrets exposed?
- Denial of service: can resources be exhausted?
- Elevation of privilege: can permissions be bypassed?

## Review Questions

1. Why should threat modeling happen before coding?
2. Which threat category is most relevant for public APIs?
