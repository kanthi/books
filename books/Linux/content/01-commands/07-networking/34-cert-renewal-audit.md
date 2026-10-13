---
title: "Certificate renewal audit (64-day and 45-day certificates)"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Certificate renewal audit (64-day and 45-day certificates)

## Overview

**Thesis:** for ten years a 90-day Let's Encrypt certificate forgave a lot. A cron job that renewed "every two months", an alert at "21 days left", a renewal that wrote a new file but never reloaded nginx: all of these worked because 90 days left plenty of room. That room is going away. Let's Encrypt switches its default profile to **64-day** certificates on **10 February 2027** (staging on **14 October 2026**), and to **45 days** in February 2028. The industry rules cap every public TLS certificate at 47 days from March 2029. Any renewal logic that counts in **fixed days** breaks somewhere on that path. Renewal logic that works in **fractions of the lifetime**, or asks the CA when to renew (ARI), keeps working.

This page is an audit you can run today:

- Read what lifetime your certificates actually have, and which ACME profiles your CA offers.
- Ask the CA when it wants each certificate renewed, with one unauthenticated `curl` (ACME Renewal Information, RFC 9773).
- Find the cron lines, renewal configs and monitoring thresholds that hard-code a lifetime.
- Check that the certificate you **serve** is the one you renewed.

Everything here uses `openssl`, `curl`, `jq`, `grep` and coreutils. No ACME client is needed to run the listings, and none of them requests a certificate.

## Mental model

```text
        notBefore                                           notAfter
            │◀──────────────────── lifetime L ─────────────────▶│
            │                                ▲        ▲          │
            │                         renew at ≈ 2/3 L │          │
            │                         (ARI window)     alert if    │
            │                                          still not   │
            │                                          renewed at  │
            │                                          ≈ 3/4 L     │
   slack = time left for retries after the first attempt = L − renewal point
```

| Lifetime | Who issues it | Renew at 2/3 | Slack after first attempt |
|---|---|---|---|
| 90 days | Let's Encrypt `classic` until 2027-02-10 | day 60 | 30 days |
| 64 days | `classic` from 2027-02-10 | day 42.7 | 21.3 days |
| 45 days | `tlsserver` since 2026-05-13, `classic` from 2028-02-16 | day 30 | 15 days |
| 160 hours | `shortlived` (opt-in) | day 4.4 | 2.2 days |

| Fact | Consequence |
|---|---|
| The lifetime is chosen by the **CA and profile**, not by you | Your scripts must read it from the certificate, never assume it |
| Let's Encrypt asks clients to renew at about **2/3** of the lifetime | A rule written as a fraction survives every change above |
| ARI lets the CA move the window (load spreading, mass revocation) | An ARI-aware client renews early when told to, and you do nothing |
| A renewed file is not a renewed service | Daemons keep the certificate they loaded until they reload |
| Authorization reuse drops from 30 days to 10 days on 2027-02-10, and to 7 hours in 2028 | "Validate once a month, issue later" designs stop working |

## Syntax

The pieces of the audit:

```bash
openssl x509 -noout -startdate -enddate -in cert.pem        # lifetime from the certificate itself
openssl x509 -noout -ext authorityKeyIdentifier -serial      # the two halves of an ARI certificate ID
openssl x509 -noout -checkend SECONDS                        # absolute "expires within N s" (see the trap)
curl -s https://acme-v02.api.letsencrypt.org/directory       # profiles and the renewalInfo URL
curl -s  <renewalInfo>/<AKI-keyid-b64url>.<serial-b64url>     # ARI: suggested renewal window
```

Certbot behaviour you are auditing (from the upstream changelog and user guide):

| Certbot | When `certbot renew` considers a certificate due |
|---|---|
| before 4.0 | fixed: 30 days before expiry |
| 4.0.0 (2025-04-07) | less than 1/3 of the lifetime left (1/2 for lifetimes of 10 days or less). Adds `--preferred-profile` / `--required-profile` |
| 4.1.0 (2025-06-10) | as 4.0, plus ARI: an early ARI window overrides a later `renew_before_expiry` |
| 5.0.0 (2025-09-02) | stores ARI's `Retry-After` between runs. Current upstream is 5.8.0 (2026-09-01) |

What distributions ship, checked against the Debian and Ubuntu archives in October 2026:

| Distribution | Packaged certbot | Renewal rule | ARI |
|---|---|---|---|
| Debian 12 (bookworm) | 2.1.0 | fixed 30 days | no |
| Debian 13 (trixie) | 4.0.0 | 1/3 left | no |
| Ubuntu 24.04 LTS | 2.9.0 | fixed 30 days | no |
| Ubuntu 26.04 LTS | 4.0.0 | 1/3 left | no |

No stable distribution package has ARI yet. The upstream snap, the Docker image and `pip` installs do.

## Safety

Every listing on this page is read-only against the outside world. The ARI endpoint is a public, unauthenticated `GET` by design (RFC 9773 §6), and the TLS probes only complete a handshake. The test certificates are self-signed, live in a temporary directory, and are useless outside the lab. The audit script only reads files. Run it with `sudo` on a real host so it can see `/etc/letsencrypt`, and review what it prints before you change anything.

## Examples with Explanations

Tested on Debian 13 with OpenSSL 3.5.7, curl, jq 1.7 and GNU coreutils 9.7, on 13 October 2026 (IST). The probes went to public hosts and the live Let's Encrypt API, so your dates and serials will differ.

### 1. What does your CA offer, and what do certificates live today?

The ACME directory is the canonical list of profiles:

```bash
curl -s https://acme-v02.api.letsencrypt.org/directory | jq .meta.profiles
```

```text
{
  "classic": "https://letsencrypt.org/docs/profiles#classic",
  "shortlived": "https://letsencrypt.org/docs/profiles#shortlived",
  "tlsserver": "https://letsencrypt.org/docs/profiles#tlsserver"
}
```

Read the lifetime from the certificate itself:

```bash
#!/usr/bin/env bash
# cert-life.sh HOST... — issuer and total validity period of each host's leaf certificate
for h in "$@"; do
  pem=$(openssl s_client -connect "$h:443" -servername "$h" </dev/null 2>/dev/null | openssl x509)
  iss=$(openssl x509 -noout -issuer <<<"$pem" | sed 's/.*CN=//')
  nb=$(date -d "$(openssl x509 -noout -startdate <<<"$pem" | cut -d= -f2)" +%s)
  na=$(date -d "$(openssl x509 -noout -enddate <<<"$pem" | cut -d= -f2)" +%s)
  printf '%-15s %-40s %3d days\n' "$h" "$iss" $(( (na - nb + 1) / 86400 ))
done
```

```bash
./cert-life.sh git.kernel.org lwn.net www.kernel.org
```

```text
git.kernel.org  YE1                                       90 days
lwn.net         YE2                                       90 days
www.kernel.org  GlobalSign Atlas R46 DV TLS CA 2026 Q3   198 days
```

The `+ 1` is there because `notAfter` is inclusive. A 90-day certificate ends one second before `notBefore + 90 days`. The third line shows the other half of the story. Since 15 March 2026 the CA/Browser Forum Baseline Requirements cap public certificates at 200 days, so even a commercial CA now issues a 198-day certificate. The cap falls to 100 days on 15 March 2027 and to 47 days on 15 March 2029.

### 2. Compute an ARI certificate ID and check it against the RFC

ARI identifies a certificate by two values it already carries. The first is the `keyIdentifier` from the Authority Key Identifier extension. The second is the serial number as DER INTEGER content bytes. Both are base64url-encoded with the `=` padding stripped and joined by a dot:

```bash
#!/usr/bin/env bash
# ari-id.sh — print the RFC 9773 certificate ID (AKI keyIdentifier "." serial) of a PEM certificate on stdin
set -euo pipefail
cert=$(openssl x509)
b64url() { tr -d ':\n' | basenc -d --base16 | basenc --base64url | tr -d '=\n'; }   # hex in, base64url out
aki=$(openssl x509 -noout -ext authorityKeyIdentifier <<<"$cert" | grep -oE '([0-9A-F]{2}:){19}[0-9A-F]{2}')   # 20-byte key ID, as Let's Encrypt uses
ser=$(openssl x509 -noout -serial <<<"$cert" | cut -d= -f2)
(( ${#ser} % 2 )) && ser=0$ser            # whole bytes
[[ $ser == [89A-F]* ]] && ser=00$ser       # DER INTEGER: keep it positive
echo "$(b64url <<<"$aki").$(b64url <<<"$ser")"
```

RFC 9773 Appendix A prints an example certificate and its expected ID, `aYhba4dGQEHhs3uEe6CuLN4ByNQ.AIdlQyE`. Save the PEM from the RFC as `rfc9773-example.pem` and test the script against it:

```bash
openssl x509 -in rfc9773-example.pem -noout -serial -ext authorityKeyIdentifier
./ari-id.sh < rfc9773-example.pem
```

```text
serial=87654321
X509v3 Authority Key Identifier: 
    69:88:5B:6B:87:46:40:41:E1:B3:7B:84:7B:A0:AE:2C:DE:01:C8:D4
aYhba4dGQEHhs3uEe6CuLN4ByNQ.AIdlQyE
```

The serial `87…` has its top bit set, so DER needs a leading `00` byte to keep it positive. That is why the second half is `AIdlQyE` and not `h2VDIQ`. Get this wrong and the CA answers 404 for every certificate whose serial starts with `8`–`F`.

### 3. Ask the CA when to renew

```bash
#!/usr/bin/env bash
# ari-check.sh HOST — ask the issuing ACME CA when HOST's current certificate should be renewed
set -euo pipefail
host=$1
dir=${ACME_DIR:-https://acme-v02.api.letsencrypt.org/directory}
here=$(dirname "$0")
cert=$(openssl s_client -connect "$host:443" -servername "$host" </dev/null 2>/dev/null | openssl x509)
id=$("$here/ari-id.sh" <<<"$cert")

epoch() { date -d "$1" +%s; }
nb=$(epoch "$(openssl x509 -noout -startdate <<<"$cert" | cut -d= -f2)")
na=$(epoch "$(openssl x509 -noout -enddate <<<"$cert" | cut -d= -f2)")
life=$(( na - nb + 1 ))                   # notAfter is inclusive: 90 days = 7776000 s

hdr=$(mktemp); trap 'rm -f "$hdr"' EXIT
ari=$(curl -fsS "$dir" | jq -r .renewalInfo)
resp=$(curl -fsS -D "$hdr" "$ari/$id")
ws=$(epoch "$(jq -r .suggestedWindow.start <<<"$resp")")
we=$(epoch "$(jq -r .suggestedWindow.end <<<"$resp")")

echo "host:      $host"
echo "lifetime:  $(( life / 86400 )) days ($(date -ud @"$nb" +%F) .. $(date -ud @"$na" +%F))"
echo "cert ID:   $id"
echo "ARI:       $(jq -c . <<<"$resp")"
echo "window:    $(( (ws - nb) * 100 / life ))% .. $(( (we - nb) * 100 / life ))% of the lifetime"
echo "re-check:  in $(sed -n 's/^[Rr]etry-[Aa]fter: *\([0-9]*\).*/\1/p' "$hdr") s (Retry-After)"
```

```bash
./ari-check.sh git.kernel.org; echo; ./ari-check.sh lwn.net
```

```text
host:      git.kernel.org
lifetime:  90 days (2026-08-14 .. 2026-11-12)
cert ID:   uyDKRwv-1-Wc-Y8JKqOMN0WxvNg.BaF78x8x9qWdG1GW5dVwbT4j
ARI:       {"suggestedWindow":{"start":"2026-10-12T23:32:36Z","end":"2026-10-14T18:43:26Z"}}
window:    65% .. 67% of the lifetime
re-check:  in 22184 s (Retry-After)

host:      lwn.net
lifetime:  90 days (2026-08-29 .. 2026-11-27)
cert ID:   uVnyjs8i8IbTN0j_dhQYuoLYVYc.Bdz9qYoc56M9jE8dBhwiBLEn
ARI:       {"suggestedWindow":{"start":"2026-10-27T03:29:03Z","end":"2026-10-28T22:39:53Z"}}
window:    65% .. 67% of the lifetime
re-check:  in 18632 s (Retry-After)
```

Read it like this:

- The window sits at **65–67 %** of the lifetime. That is the "about two-thirds" Let's Encrypt asks for, chosen per certificate so that renewals do not all arrive at once.
- The `git.kernel.org` window opened at 05:02 IST on the day of the run. A well-behaved client renews that certificate within the next day and a half.
- `Retry-After` (about five to seven hours here) is how often the CA wants you to ask again. RFC 9773 treats it as both the minimum and the maximum. A CA that needs certificates replaced before a mass revocation moves the window into the past, and clients that poll on schedule renew at once.
- The client picks a uniformly random moment inside the window. A cron-driven client that wakes up only once a day may need to wake up more often to honour it (RFC 9773 §4.2).

### 4. What each renewal policy does as lifetimes shrink

```bash
#!/usr/bin/env bash
# renew-margin.sh — when does each renewal policy fire, and how much slack is left, per certificate lifetime?
awk 'BEGIN {
  n = split("90 64 45 6.67", life, " ")
  split("90d 64d 45d 160h", name, " ")
  printf "%-26s", "policy \\ lifetime"
  for (i = 1; i <= n; i++) printf "%14s", name[i]
  print ""
  np = split("fixed:30-days-left|fraction:1/3-left|interval:every-60-days|fraction:2/3-elapsed", pol, "|")
  for (p = 1; p <= np; p++) {
    printf "%-26s", pol[p]
    for (i = 1; i <= n; i++) {
      L = life[i]
      if (pol[p] ~ /30-days-left/)    at = L - 30
      if (pol[p] ~ /1\/3-left/)       at = (L <= 10) ? L / 2 : L * 2 / 3
      if (pol[p] ~ /every-60-days/)   at = 60
      if (pol[p] ~ /2\/3-elapsed/)    at = L * 2 / 3
      if (at < 0) at = 0
      slack = L - at
      if (slack < 0)       cell = sprintf("EXPIRED %.0fd", -slack)
      else if (at == 0)    cell = "every run"
      else                 cell = sprintf("d%.1f +%.1fd", at, slack)
      printf "%14s", cell
    }
    print ""
  }
}'
```

```text
policy \ lifetime                    90d           64d           45d          160h
fixed:30-days-left          d60.0 +30.0d  d34.0 +30.0d  d15.0 +30.0d     every run
fraction:1/3-left           d60.0 +30.0d  d42.7 +21.3d  d30.0 +15.0d    d3.3 +3.3d
interval:every-60-days      d60.0 +30.0d   d60.0 +4.0d   EXPIRED 15d   EXPIRED 53d
fraction:2/3-elapsed        d60.0 +30.0d  d42.7 +21.3d  d30.0 +15.0d    d4.4 +2.2d
```

`dN +Sd` means "first attempt on day N, S days of slack left for retries". The first column is why nobody noticed: every policy agrees on a 90-day certificate. The rows explain what Let's Encrypt is warning about:

- **Fixed 30 days left** (certbot before 4.0, still the packaged version on Debian 12 and Ubuntu 24.04) survives 64- and 45-day certificates. It just renews earlier than needed. On a 160-hour certificate it is due on every run, which means twice a day with the stock timer, forever.
- **Fixed interval** is the one that fails. "Renew every two months" leaves four days of slack on a 64-day certificate. On a 45-day certificate the site sits expired for 15 days of every cycle. This is the `60` in Let's Encrypt's "grep for 83, 80 or 60".
- **Fractions** (certbot 4.0+, ARI) keep the same *shape* at every lifetime. The slack shrinks with the lifetime, so your alerting has to shrink with it too.

### 5. Monitor by fraction used, not days left

```bash
#!/usr/bin/env bash
# make-test-certs.sh — self-signed certificates at chosen points in their lives: NAME LIFETIME_DAYS AGE_DAYS
set -euo pipefail
mkdir -p certs
ts() { date -u -d "@$1" +%Y%m%d%H%M%SZ; }
now=$(date +%s)
while read -r name life age; do
  nb=$(( now - age * 86400 )); na=$(( nb + life * 86400 - 1 ))
  openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes -keyout /dev/null \
    -subj "/CN=$name.example" -not_before "$(ts $nb)" -not_after "$(ts $na)" -out "certs/$name.pem" 2>/dev/null
done <<'LIST'
web-90d-healthy  90 50
api-45d-healthy  45 26
cdn-90d-stuck    90 68
mail-64d-stuck   64 55
LIST
ls certs
```

```bash
#!/usr/bin/env bash
# cert-due.sh CERT.pem... — judge renewal health by fraction of lifetime used, not by days left
# exit 0 = all fine, 1 = renewal overdue (>= 75% used), 2 = critical (>= 90% used or expired)
set -uo pipefail
warn=${WARN_PCT:-75} crit=${CRIT_PCT:-90} now=$(date +%s) worst=0
for f in "$@"; do
  nb=$(date -d "$(openssl x509 -in "$f" -noout -startdate | cut -d= -f2)" +%s)
  na=$(date -d "$(openssl x509 -in "$f" -noout -enddate | cut -d= -f2)" +%s)
  life=$(( na - nb + 1 )) used=$(( (now - nb) * 100 / life )) left=$(( (na - now) / 86400 ))
  if   (( used >= crit )); then st=CRIT rc=2
  elif (( used >= warn )); then st=WARN rc=1
  else st=OK rc=0; fi
  (( rc > worst )) && worst=$rc
  printf '%-4s %-26s life=%3dd used=%3d%% left=%3dd\n' "$st" "$(basename "$f")" $(( life / 86400 )) "$used" "$left"
done
exit $worst
```

`openssl req -not_before/-not_after` (OpenSSL 3.4 and later) lets you back-date the test certificates, so you can test monitoring without waiting weeks:

```bash
./make-test-certs.sh
./cert-due.sh certs/*.pem; echo "exit=$?"
for f in certs/*.pem; do printf '%-22s ' "$(basename "$f")"; openssl x509 -in "$f" -noout -checkend $((21*86400)); done
```

```text
api-45d-healthy.pem
cdn-90d-stuck.pem
mail-64d-stuck.pem
web-90d-healthy.pem
OK   api-45d-healthy.pem        life= 45d used= 57% left= 18d
WARN cdn-90d-stuck.pem          life= 90d used= 75% left= 21d
WARN mail-64d-stuck.pem         life= 64d used= 85% left=  8d
OK   web-90d-healthy.pem        life= 90d used= 55% left= 39d
exit=1
api-45d-healthy.pem    Certificate will expire
cdn-90d-stuck.pem      Certificate will not expire
mail-64d-stuck.pem     Certificate will expire
web-90d-healthy.pem    Certificate will not expire
```

Compare the two verdicts. The classic "alert at 21 days left" check (`-checkend` with 21 days) gets two of four wrong. It pages for `api-45d-healthy`, which is only 57 % through its life and not even due for renewal. It stays silent for `cdn-90d-stuck`, whose renewal should have happened eight days ago. The fraction check gets both right with one threshold for every lifetime. 75 % is a choice, not a standard. It sits one-twelfth of the lifetime after the 2/3 renewal point, which is about five days on a 64-day certificate and four on a 45-day one: enough for a few failed attempts, early enough to fix by hand.

Point the same check at the **served** certificate, not only the file on disk (see the trap):

```bash
openssl s_client -connect shop.example:443 -servername shop.example </dev/null 2>/dev/null | openssl x509 > served.pem
./cert-due.sh served.pem
```

### 6. Audit a host for hard-coded lifetimes

```bash
#!/usr/bin/env bash
# renewal-audit.sh [ROOT...] — find renewal logic that assumes a fixed certificate lifetime
set -uo pipefail
roots=("$@"); (( $# )) || roots=(/etc /usr/local/bin /opt)
hit() { grep -rnIE -e "$2" "${roots[@]}" 2>/dev/null | sed "s|^|[$1] |"; }

hit fixed-threshold 'renew_before_expiry *= *[0-9]+ *days?'
hit forced-interval '--force-renewal|--renew-by-default'
hit forced-interval '^[^#]*[0-9*]+ +[0-9*]+ +[0-9*]+ +\*/[0-9]+ +'     # cron: every N months
hit absolute-alert  '-checkend +[0-9$]|check_http.* -C *[0-9]+|check_ssl_cert.* -[wc] *[0-9]+'
hit magic-number    '\b(30|60|80|83|89|90) *days?\b|is within [0-9]+ days'

if command -v certbot >/dev/null; then
  v=$(certbot --version 2>&1 | awk '{print $2}')
  printf '[client] certbot %s: ' "$v"
  if   dpkg --compare-versions "$v" lt 4.0; then echo "fixed 30-day threshold, no ARI"
  elif dpkg --compare-versions "$v" lt 4.1; then echo "renews at 1/3 lifetime left, no ARI"
  else echo "ARI-aware"; fi
else
  echo "[client] certbot not on PATH here (check the hosts that renew)"
fi
```

To see it work without touching a real host, build a small fake `/etc` with the habits this page warns about. The `cron.d/certbot` and `certbot.timer` contents are taken (abridged) from Debian 13's own certbot 4.0.0 package:

```bash
#!/usr/bin/env bash
# make-fixture.sh — a fake /etc with the renewal habits this chapter warns about
set -euo pipefail
r=fixture/etc; rm -rf fixture; mkdir -p $r/cron.d $r/systemd/system $r/letsencrypt/renewal $r/nagios/conf.d fixture/usr/local/bin

# shipped by Debian 13's certbot 4.0.0 package (abridged): note the stale comment
cat > $r/cron.d/certbot <<'X'
# Renewal will only occur if expiration
# is within 30 days.
0 */12 * * * root test -x /usr/bin/certbot -a \! -d /run/systemd/system && perl -e 'sleep int(rand(43200))' && certbot -q renew --no-random-sleep-on-renew
X
cat > $r/systemd/system/certbot.timer <<'X'
[Timer]
OnCalendar=*-*-* 00,12:00:00
RandomizedDelaySec=43200
Persistent=true
X
# a lineage someone pinned years ago
cat > $r/letsencrypt/renewal/shop.example.conf <<'X'
version = 2.9.0
renew_before_expiry = 30 days
[renewalparams]
authenticator = webroot
server = https://acme-v02.api.letsencrypt.org/directory
X
# a hand-rolled "renew every two months" job
cat > $r/cron.d/legacy-tls <<'X'
15 3 1 */2 * root /usr/local/bin/renew-all.sh
X
cat > fixture/usr/local/bin/renew-all.sh <<'X'
#!/bin/sh
certbot renew --force-renewal --quiet && systemctl reload nginx
X
# a monitoring check with an absolute threshold
cat > $r/nagios/conf.d/tls.cfg <<'X'
command_line  /usr/lib/nagios/plugins/check_http -H $HOSTADDRESS$ -C 21,7
X
find fixture -type f | sort
```

```bash
./make-fixture.sh && ./renewal-audit.sh fixture
```

```text
fixture/etc/cron.d/certbot
fixture/etc/cron.d/legacy-tls
fixture/etc/letsencrypt/renewal/shop.example.conf
fixture/etc/nagios/conf.d/tls.cfg
fixture/etc/systemd/system/certbot.timer
fixture/usr/local/bin/renew-all.sh
[fixed-threshold] fixture/etc/letsencrypt/renewal/shop.example.conf:2:renew_before_expiry = 30 days
[forced-interval] fixture/usr/local/bin/renew-all.sh:2:certbot renew --force-renewal --quiet && systemctl reload nginx
[forced-interval] fixture/etc/cron.d/legacy-tls:1:15 3 1 */2 * root /usr/local/bin/renew-all.sh
[absolute-alert] fixture/etc/nagios/conf.d/tls.cfg:1:command_line  /usr/lib/nagios/plugins/check_http -H $HOSTADDRESS$ -C 21,7
[magic-number] fixture/etc/cron.d/certbot:2:# is within 30 days.
[magic-number] fixture/etc/letsencrypt/renewal/shop.example.conf:2:renew_before_expiry = 30 days
[client] certbot not on PATH here (check the hosts that renew)
```

How to act on each class of finding:

| Finding | What to do |
|---|---|
| `fixed-threshold` | Delete `renew_before_expiry` from the lineage and let certbot 4.0+ use 1/3 (and ARI on 4.1+). Keep it only if you have a reason, written down next to it |
| `forced-interval` | Replace with plain `certbot renew` run at least twice a day. `renew` is idempotent: it does nothing until a certificate is due |
| `absolute-alert` | Rewrite as a fraction of lifetime (`cert-due.sh`), or derive the days from the actual lifetime |
| `magic-number` | Read each one. The Debian comment above is harmless but stale: the packaged 4.0.0 renews at 1/3, not 30 days. Stale runbooks cause bad 3 a.m. decisions |
| `[client]` older than 4.1 | Plan the move to an ARI-aware client before 2027-02-10, through the upstream snap, a backport, or another ACME client that documents ARI support |

The stock timer (`00,12:00` plus up to 12 hours of random delay, `Persistent=true`) is already right for every lifetime on this page. Leave it alone. Fix the things that override it.

## The trap

**The certificate was renewed. The service is still serving the old one.**

`certbot renew` writes new files under `/etc/letsencrypt/live/`. nginx, HAProxy, Postfix and most other daemons read the certificate once at start or reload. Without a deploy hook nothing tells them, and the success shows only in the renewal log:

```bash
#!/usr/bin/env bash
# stale-serve.sh — the certificate on disk is renewed; the one being served is not
set -euo pipefail
d=$(mktemp -d); trap 'kill $srv 2>/dev/null; rm -rf "$d"' EXIT
issue() {  # issue SERIAL: write a fresh 45-day cert and key to $d/live/
  mkdir -p "$d/live"
  openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:P-256 -nodes -days 45 -set_serial "$1" \
    -subj /CN=shop.example -keyout "$d/live/privkey.pem" -out "$d/live/fullchain.pem" 2>/dev/null
}
served() { openssl s_client -connect 127.0.0.1:8443 </dev/null 2>/dev/null | openssl x509 -noout -serial; }

issue 0x1001
openssl s_server -quiet -accept 8443 -cert "$d/live/fullchain.pem" -key "$d/live/privkey.pem" -www & srv=$!
sleep 1
echo "on disk: $(openssl x509 -in "$d/live/fullchain.pem" -noout -serial)   served: $(served)"

issue 0x1002                                   # "certbot renew" succeeded
echo "on disk: $(openssl x509 -in "$d/live/fullchain.pem" -noout -serial)   served: $(served)"

kill $srv; wait $srv 2>/dev/null || true       # the reload a deploy hook would have done
openssl s_server -quiet -accept 8443 -cert "$d/live/fullchain.pem" -key "$d/live/privkey.pem" -www & srv=$!
sleep 1
echo "on disk: $(openssl x509 -in "$d/live/fullchain.pem" -noout -serial)   served: $(served)"
```

```text
on disk: serial=1001   served: serial=1001
on disk: serial=1002   served: serial=1001
on disk: serial=1002   served: serial=1002
```

With 90-day certificates this bug hid behind routine work. Renewal at day 60 left 30 days, and some unrelated deploy, package upgrade or reboot almost always restarted the daemon in time. With a 45-day certificate renewed at day 30, the old certificate in memory has 15 days left. A host that reloads only on a monthly patch night serves an expired certificate in about half of all cycles, while every file-based check reports green.

The fix is a **deploy hook**, which runs only after a successful renewal. Put an executable in `/etc/letsencrypt/renewal-hooks/deploy/` (for example one that runs `systemctl reload nginx`), or pass `--deploy-hook` once so certbot stores it in the lineage. Then monitor the served certificate as in example 5. Probe from outside the host and against every name and port that terminates TLS, including the load balancer and the mail server on 465 and 993.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---|---|
| Hard-coded `--days 60` style intervals | Fine on 90-day certificates. Four days of slack on 64-day ones, outages on 45-day ones. Use the client's due-check instead |
| Alert thresholds in absolute days | Pages for healthy short certificates, silent for stuck long ones. Alert on fraction used |
| Watching the file, not the socket | Green dashboards, browser errors. Probe the served certificate |
| `--required-profile` without a fallback plan | Renewal *fails* if the CA stops offering that profile. `--preferred-profile` falls back to the default. Choose deliberately |
| Relying on authorization reuse | From 2027-02-10 a validation is reusable for 10 days, not 30. Pre-validating once a month and issuing later no longer works |
| Expecting OCSP to tell you about revocation | Let's Encrypt turned off its OCSP responders on 2025-08-06. ARI is how the CA tells your client to replace a certificate early |
| ARI 404s on some certificates | Serial encoding: DER needs a leading `00` when the top bit is set (example 2) |
| Testing against production | Use the staging directory. It switches to 64-day certificates on 2026-10-14, four months before production |

## The boring rule

> Renew with a client that decides for itself when a certificate is due, preferably via ARI, and run it twice a day. Never schedule renewals by calendar or by days-before-expiry you typed yourself. Reload every consumer from a deploy hook. Alert on the **fraction of lifetime used by the certificate actually served**. Then the CA can shorten lifetimes again without you changing anything.

## Related Commands

| Command | Role |
|---|---|
| `openssl x509 -noout -dates -serial -ext authorityKeyIdentifier` | Lifetime and ARI identity of a certificate |
| `openssl s_client -connect host:443 -servername host` | Fetch the served certificate |
| `curl` + `jq` | ACME directory, profiles, ARI `renewalInfo` |
| `systemctl list-timers certbot.timer` | When renewal next runs |
| `journalctl -u certbot.service` | What the last renewal attempts did |
| `grep -rnE` | The audit itself |

## Try this

1. Run `ari-check.sh` against every public name you operate. Put the next `suggestedWindow.start` for each one in a calendar, and check that your client actually renews inside the window.
2. On a staging account after 2026-10-14, issue a certificate with your normal client and confirm with `cert-life.sh` (or `openssl x509 -dates`) that it is 64 days. Then run your monitoring against it.
3. Run `renewal-audit.sh` with `sudo` on one real host. For every hit, write down whether it breaks at 64 days, at 45 days, or never.
4. Add a deploy hook to one host, renew with `certbot renew --force-renewal --cert-name <name>` in a maintenance window, and use `openssl s_client` to prove the served serial changed without a manual restart.
5. Change `cert-due.sh` so it reads `host:port` arguments directly, and wire it into your monitoring with exit codes 1 and 2 as warning and critical.

## Sources

- Let's Encrypt, [64-Day Certificate Lifetimes Coming Feb 2027](https://letsencrypt.org/2026/10/07/64-day-certs) (2026-10-07): production date 2027-02-10, staging date 2026-10-14, renew at about 2/3, grep for 83, 80 or 60, authorization reuse from 30 to 10 days, last 90-day certificate expiring around 2027-05-11
- Let's Encrypt, [Decreasing Certificate Lifetimes to 45 Days](https://letsencrypt.org/2025/12/02/from-90-to-45.html) (2025-12-02): full timeline, `tlsserver` from 2026-05-13, `classic` 45 days from 2028-02-16
- Let's Encrypt, [Profiles](https://letsencrypt.org/docs/profiles/) (updated 2026-10-04): `classic`, `tlsserver`, `shortlived` properties, Baseline Requirements limits
- CA/Browser Forum, [Ballot SC-081v3](https://cabforum.org/2025/04/11/ballot-sc081v3-introduce-schedule-of-reducing-validity-and-data-reuse-periods/): 200 days (2026-03-15), 100 days (2027-03-15), 47 days (2029-03-15), validation reuse 200, 100 and then 10 days
- [RFC 9773](https://www.rfc-editor.org/rfc/rfc9773.html), ACME Renewal Information (ARI): certificate ID construction (§4.1, Appendix A), `suggestedWindow`, `Retry-After` semantics, client algorithm
- [RFC 8555](https://www.rfc-editor.org/rfc/rfc8555.html), ACME
- Certbot, [CHANGELOG](https://github.com/certbot/certbot/blob/main/certbot/CHANGELOG.md) (4.0.0 1/3 rule and profiles, 4.1.0 ARI, 5.0.0 stored `Retry-After`, 5.8.0 current) and [User Guide](https://eff-certbot.readthedocs.io/en/stable/using.html) (renewal threshold, `--deploy-hook`, `renewal-hooks/deploy`)
- Debian package `python-certbot` 4.0.0-2+deb13u1, [`debian/certbot.timer`](https://sources.debian.org/src/python-certbot/4.0.0-2+deb13u1/debian/certbot.timer/) and [`debian/certbot.cron.d`](https://sources.debian.org/src/python-certbot/4.0.0-2+deb13u1/debian/certbot.cron.d/); package versions from [sources.debian.org](https://sources.debian.org/src/python-certbot/) and Launchpad (`python-certbot` in noble and resolute)
- OpenSSL 3.5 [`openssl-x509(1)`](https://docs.openssl.org/3.5/man1/openssl-x509/) and [`openssl-req(1)`](https://docs.openssl.org/3.5/man1/openssl-req/) (`-checkend`, `-not_before`, `-not_after`)
