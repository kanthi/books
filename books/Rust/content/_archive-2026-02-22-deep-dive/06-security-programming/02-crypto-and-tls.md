# Cryptography, TLS, and Secrets Hygiene

## Crypto Principles

- Use audited libraries, not custom algorithms.
- Prefer AEAD (authenticated encryption).
- Separate key management from business logic.

## Password Hashing Pattern

Use Argon2 or scrypt for password storage.

```rust
// conceptual API sketch
fn hash_password(password: &str) -> String {
    format!("argon2$...${}", password.len())
}
```

(Use real crate APIs in implementation; this example is conceptual.)

## TLS Defaults

- TLS 1.2+ only.
- Disable weak ciphers.
- Rotate certificates before expiry.
- Consider mTLS for service-to-service paths.

## Secret Handling Checklist

- Load from env or secret manager.
- Never commit secrets to VCS.
- Avoid printing secrets in panic/log output.
- Rotate and revoke on incident.

## Practice

1. Add TLS config validation startup check.
2. Add secret redaction helper.
3. Document certificate rotation process.

## Deep Dive: Certificate Lifecycle

- issue
- deploy
- monitor expiry
- rotate before expiration
- revoke on compromise

## TLS Validation Checklist

- hostname validation enabled
- certificate chain validated
- weak cipher suites disabled
- short certificate lifetimes preferred

## Review Questions

1. Why is rotation policy as important as encryption itself?
2. What failures occur if hostname verification is disabled?
