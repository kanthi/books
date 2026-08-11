# sleep

## Overview

`sleep` suspends execution for a specified time. Used in shell scripts for pacing, simple retries, and demos. For precise timers, event-driven waits, or jittered backoff, higher-level tools may be better — but `sleep` remains the universal delay primitive.

## Syntax

```bash
sleep NUMBER[SUFFIX]...
```

GNU sleep accepts floating point and multiple arguments (sums them).

## Time suffixes (GNU)

| Suffix | Unit |
|--------|------|
| `s` | Seconds (default) |
| `m` | Minutes |
| `h` | Hours |
| `d` | Days |

## Examples with Explanations

### Basics

```bash
sleep 5
sleep 0.5
sleep 2m
sleep 1h
sleep 1m 30s            # GNU: 90 seconds total
```

### Simple retry loop

```bash
until ping -c1 -W1 gateway >/dev/null; do
  sleep 2
done
```

### Exponential backoff (bash)

```bash
delay=1
for i in 1 2 3 4 5; do
  curl -fsS https://example.com/ && break
  sleep "$delay"
  delay=$((delay * 2))
done
```

### Rate limiting

```bash
while read -r host; do
  ssh "$host" 'uname -r'
  sleep 0.2
done < hosts.txt
```

### Background heartbeat

```bash
while true; do
  date -Is >> /tmp/heartbeat
  sleep 60
done &
```

Prefer systemd timers for production heartbeats.

### Interruptible

```bash
sleep 300
# Ctrl-C sends SIGINT to foreground sleep
```

### Portable note

```bash
# POSIX: integer seconds only on some platforms
sleep 5
# fractional may require GNU coreutils
```

## Notes / Pitfalls

- Busy loops without sleep burn CPU — always throttle polls.
- `sleep infinity` works on GNU; not portable — use large numbers or `tail -f /dev/null`.
- Sleep drift: not a real-time scheduler; long loops accumulate error.
- Don’t use sleep as the only readiness check for services — probe health endpoints.
- In pipelines, know which process sleeps.

## 2026-relevant notes

- Prefer `systemd-run` timers / cron / `watch` for periodic work.
- Kubernetes readiness/liveness already handle waits — avoid crude sleep in hot paths.
- `timeout` pairs with commands that must not hang forever.

## Related Commands

- `timeout` — bound a command’s runtime
- `watch` — run a command repeatedly
- `usleep` — legacy microseconds (often gone; use `sleep 0.001`)
- `at` / `systemd-run` — schedule future work
- `wait` — wait for jobs, not wall clock alone

## Additional Resources

- `man sleep`
