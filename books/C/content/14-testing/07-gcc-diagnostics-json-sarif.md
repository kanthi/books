---
title: "GCC Diagnostics: JSON and SARIF for CI"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# GCC Diagnostics: JSON and SARIF for CI

## Thesis

Human-readable compiler warnings are for humans. CI, IDEs, and security dashboards want **structured** diagnostics: machine-stable rule ids, file/line/column, and related notes. GCC can emit that today with `-fdiagnostics-format=`:

| Value | Where it goes | Shape |
|-------|---------------|--------|
| `text` | stderr (default) | Classic caret diagnostics |
| `json` / `json-stderr` | stderr | JSON array of diagnostics |
| `json-file` | `<source>.gcc.json` next to the input | same JSON, in a file |
| `sarif` paths: `sarif-stderr` / `sarif-file` | stderr or `<source>.sarif` | [SARIF 2.1.0](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html) run |

This chapter is verified on **GCC 14.2.0** (Debian 14.2.0-19) — the toolchain on this lab box. GCC 16 release notes advertise further diagnostics work (including HTML-oriented experiments upstream); we do **not** invent GCC 16 output here. Re-run the same commands on your builder's GCC before you pin CI parsers.

## Mental model

```text
  gcc -Wall -c foo.c
           │
           ├─ text          → humans / logs
           ├─ json*         → jq, custom bots, lighter parsers
           └─ sarif*        → GitHub code scanning, IDEs, SARIF viewers
```

SARIF wraps a `runs[]` entry with tool metadata (`driver.name`, `version`, `rules[]`) and `results[]` that point at `physicalLocation.region`. JSON mode is a flatter list of `{kind, message, option, locations, children}` objects — fine for a five-line `jq` gate, less standard across vendors.

## Worked examples

All listings: **GCC 14.2.0**, `x86_64-linux-gnu`, C17.

### Case 0: which formats exist?

```bash
gcc -fdiagnostics-format=help
```

```text
gcc: error: unrecognized argument in option ‘-fdiagnostics-format=help’
gcc: note: valid arguments to ‘-fdiagnostics-format=’ are: json json-file json-stderr sarif-file sarif-stderr text
```

The "error" is GCC rejecting the literal `help` token; the **note** is the catalogue you want. Default remains `text`.

### Case 1: text baseline

```c
/* uninit.c */
#include <stdio.h>
int main(void) {
    int x;
    printf("%d\n", x);
    return 0;
}
```

```bash
gcc -Wall -Wextra -c uninit.c -o uninit.o
```

```text
uninit.c: In function ‘main’:
uninit.c:5:5: warning: ‘x’ is used uninitialized [-Wuninitialized]
    5 |     printf("%d\n", x);
      |     ^~~~~~~~~~~~~~~~~
uninit.c:4:9: note: ‘x’ was declared here
    4 |     int x;
      |         ^
```

### Case 2: SARIF file for dashboards

```bash
rm -f uninit.c.sarif uninit.o
gcc -Wall -Wextra -fdiagnostics-format=sarif-file -c uninit.c -o uninit.o
wc -c uninit.c.sarif
python3 - <<'PY'
import json
d = json.load(open("uninit.c.sarif"))
run = d["runs"][0]
print("tool:", run["tool"]["driver"]["fullName"])
r = run["results"][0]
print("ruleId:", r["ruleId"])
print("level:", r["level"])
print("message:", r["message"]["text"])
print("region:", r["locations"][0]["physicalLocation"]["region"])
PY
```

```text
3205 uninit.c.sarif
tool: GNU C17 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
ruleId: -Wuninitialized
level: warning
message: ‘x’ is used uninitialized
region: {'startLine': 5, 'startColumn': 5, 'endColumn': 22}
```

The document declares `$schema` for SARIF 2.1.0 and embeds the source snippet under `artifacts`. CI can fail the job when `results` is non-empty, or upload the `.sarif` to a code-scanning product that already speaks the format.

`sarif-stderr` writes the same document to stderr — useful when the build tree is read-only and you capture logs instead of files.

### Case 3: JSON for a tiny gate

```bash
gcc -Wall -Wextra -fdiagnostics-format=json-file -c uninit.c -o /dev/null
python3 - <<'PY'
import json, sys
d = json.load(open("uninit.c.gcc.json"))
warns = [x for x in d if x.get("kind") == "warning"]
print("warnings:", len(warns), "option:", warns[0]["option"])
sys.exit(1 if warns else 0)
PY
```

```text
warnings: 1 option: -Wuninitialized
```

(exit status 1) — that is the whole CI policy for a "no new warnings" gate on a single file. Prefer `json-file` / `sarif-file` when parallel `gcc` invocations would interleave stderr JSON.

### Case 4: plain text without carets (log-friendly)

```bash
gcc -Wall -fdiagnostics-plain-output -c uninit.c -o /dev/null
```

```text
uninit.c: In function ‘main’:
uninit.c:5:5: warning: ‘x’ is used uninitialized [-Wuninitialized]
uninit.c:4:9: note: ‘x’ was declared here
```

Same facts, no source underline. Handy when caret columns confuse log scrapers that are not ready for SARIF yet.

### Case 5: analyzer events still flow through text (and into SARIF when enabled)

```c
/* bounds.c */
int sum3(int *a) {
    return a[0] + a[1] + a[2] + a[3]; /* one past */
}
int main(void) {
    int v[3] = {1, 2, 3};
    return sum3(v);
}
```

```bash
gcc -Wall -fanalyzer -c bounds.c -o bounds.o
```

```text
bounds.c: In function ‘sum3’:
bounds.c:3:34: warning: stack-based buffer over-read [CWE-126] [-Wanalyzer-out-of-bounds]
    3 |     return a[0] + a[1] + a[2] + a[3]; /* one past */
      |                                 ~^~~
  ‘main’: events 1-3
    |
    |    5 | int main(void) {
    |      |     ^~~~
    |      |     |
    |      |     (1) entry to ‘main’
    |    6 |     int v[3] = {1,2,3};
    |      |         ~
    |      |         |
    |      |         (2) capacity: 12 bytes
    |    7 |     return sum3(v);
    |      |            ~~~~~~~
    |      |            |
    |      |            (3) calling ‘sum3’ from ‘main’
    |
    +--> ‘sum3’: events 4-5
           |
           |    2 | int sum3(int *a) {
           |      |     ^~~~
           |      |     |
           |      |     (4) entry to ‘sum3’
           |    3 |     return a[0] + a[1] + a[2] + a[3]; /* one past */
           |      |                                 ~~~~
           |      |                                  |
           |      |                                  (5) out-of-bounds read from byte 12 till byte 15 but ‘v’ ends at byte 12
```

Pair `-fanalyzer` with `-fdiagnostics-format=sarif-file` when you want those path events in a tool that understands SARIF graphs. Keep analyzer runs in a separate CI job: they are slower than `-Wall` alone.

## The trap

**Parsing caret text with regex.** Column-adjusted Unicode quotes (`‘x’`), multi-line notes, and analyzer path diagrams will break your scraper on the first GCC upgrade. Prefer JSON or SARIF and key on `option` / `ruleId`.

**Interleaved JSON on stderr from `make -j`.** Two compilers writing JSON arrays to one log produce invalid JSON. Use `*-file` outputs or per-object log files.

**Assuming SARIF means "GCC 16 only".** File and stderr SARIF emitters are already on GCC 14.2. New GCC releases may add sinks (HTML experiments, richer analyzer graphs); treat release notes as a delta, not as permission to skip verifying your installed compiler.

## The boring rule

> Ship CI warnings as **SARIF** (or GCC JSON) from the **same** GCC major you run in production builds. Fail on `results` / `kind=warning` you have not waived. Keep `text` for interactive builds; never scrape carets in automation.

## Try this

1. Add a Make pattern rule: `%.o: %.c` compiles with `-fdiagnostics-format=sarif-file` and a script that `jq`s every `*.sarif` under `build/`.
2. Emit both `-Wuninitialized` and a deliberate `-Wunused-variable`; assert your gate counts two `ruleId`s.
3. Run Case 5 with `-fdiagnostics-format=sarif-file` and inspect whether analyzer path events appear as related locations or separate results on your GCC.
4. On a machine with GCC 15 or 16, re-run Case 0 and diff the valid-argument list against 14.2 — document only what that binary prints.

## Sources

- GCC Optimize / Instrumentation options: [`-fdiagnostics-format=`](https://gcc.gnu.org/onlinedocs/gcc/Diagnostic-Message-Formatting-Options.html) (Diagnostic Message Formatting Options)
- OASIS [SARIF 2.1.0](https://docs.oasis-open.org/sarif/sarif/v2.1.0/sarif-v2.1.0.html)
- GCC 14 changes: [https://gcc.gnu.org/gcc-14/changes.html](https://gcc.gnu.org/gcc-14/changes.html) (baseline for this lab)
- GCC 16 changes (read when you have that toolchain): [https://gcc.gnu.org/gcc-16/changes.html](https://gcc.gnu.org/gcc-16/changes.html) — do not trust secondary blogs over the installed `gcc --version`
