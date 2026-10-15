---
title: "sudo-rs"
author:
  - name: "K19G"
  - name: "grok-bot"
---

## Overview

**Thesis:** on Ubuntu 25.10, 26.04 LTS and 26.10, the `sudo` you type is **sudo-rs**, a memory-safe reimplementation in Rust. C sudo is still installed alongside it, as `sudo.ws`. For daily use nothing changes. The two places where it does change are:

- **The password prompt shows `*` per keystroke.** `pwfeedback` is on by default from sudo-rs 0.2.13, which is the version in 26.04.
- **Your sudoers files may no longer parse.** sudo-rs supports a deliberate subset of the sudoers language: no wildcards inside argument lists, no regexes, no `logfile`, no `INTERCEPT`, no `MAIL` tag, and no IPv4 addresses as hosts, among others. C sudo accepts every one of these.

The second point decides whether an upgrade is boring. If a rule that only C sudo understands sits in `/etc/sudoers.d/`, the deploy user that depends on it is the first to find out. So: check every sudoers file with sudo-rs's own `visudo -c` *before* the upgrade. The `.deb` can do that without being installed (Example 5).

```text
Ubuntu series          /usr/bin/sudo is   rust-sudo-rs published (Launchpad, 2026-10-15)
24.04 LTS noble        C sudo             0.2.2-1 (optional, not the default)
25.10 questing         sudo-rs            0.2.8-1ubuntu5.3 (updates; series now obsolete)
26.04 LTS resolute     sudo-rs            0.2.13-0ubuntu1.2 (updates, security)
26.10 stonking         sudo-rs            0.2.14-1ubuntu4 (release pocket, pre-release)
upstream latest                           0.2.15 (2026-08-31)
```

Package outputs below come from the Ubuntu 26.04 LTS archive (`ubuntu-base-26.04` root filesystem plus the `sudo-rs`, `sudo` and `sudo-common` packages, fetched 2026-10-15). sudo-rs's `visudo` was run on Debian 13 (glibc 2.41, kernel 6.12). C sudo's `visudo.ws` needs glibc 2.42, so it was run inside the unpacked 26.04 root filesystem. Neither package was installed on the lab host. The interactive password prompt was therefore **not** reproduced here; its behaviour is taken from the sudo-rs man page, changelog and Ubuntu release notes cited below.

## Mental model

```text
/usr/bin/sudo ──► /etc/alternatives/sudo ──┬─► /usr/lib/cargo/bin/sudo   sudo-rs  priority 50  (wins in auto mode)
                                           └─► /usr/bin/sudo.ws          C sudo   priority 40
  slaves follow the master link:  visudo, sudoedit, and the sudo(8)/sudoers(5)/visudo(8) man pages

/etc/sudoers, /etc/sudoers.d/*   one shared policy (shipped by sudo-common), read by whichever sudo is active
/etc/pam.d/sudo, sudo-i          sudo-rs always authenticates through PAM
```

| Fact | Consequence |
|------|-------------|
| Both implementations are installed, and `ubuntu-minimal` depends on both | Switching is an `update-alternatives` choice, not a package removal. Removing either package takes the metapackage with it |
| The policy files are shared | A file valid for one implementation can be invalid for the other. Validate with the one that will run |
| `man sudoers` follows the alternative | With sudo-rs active you read `sudoers-rs(5)`, which describes the subset. Read the page that matches the binary |
| sudo-rs rejects unsupported syntax with an error | You get a clear error at check time, not a silently different meaning. Run the check before you depend on it |
| Some options are fixed | `env_reset` always on, `visiblepw` always off, `use_pty` on by default, `sudo -E` unsupported, logging only through syslog |

## Syntax

```bash
sudo --version | head -1                  # which implementation answers to "sudo"
update-alternatives --query sudo          # Value: and the two candidates
sudo update-alternatives --config sudo    # interactive switch between sudo-rs and sudo.ws
sudo visudo -c                            # check /etc/sudoers and its includes with the ACTIVE visudo
visudo -c -f FILE                         # check one file (no root needed for a copy you can read)
```

## Safety

- Keep a root shell (or console access) open while you change sudoers or switch implementations. A file that one implementation cannot parse can lock you out of sudo. The sudo-rs man page says so explicitly.
- Never edit `/etc/sudoers` or `/etc/sudoers.d/*` directly. `visudo` checks with the implementation it belongs to, so `visudo` and `visudo.ws` can disagree on the same file.
- Treat `pwfeedback` as a policy choice for shared screens (screen sharing, pairing, recorded demos). It reveals password length, nothing more.
- Track sudo-rs security fixes per release. The sudoedit symlink race GHSA-f42v-x7gq-phc8 affects upstream 0.2.8 up to 0.2.14 and is fixed in 0.2.15. Ubuntu 26.04 carries the fix as a patch in `0.2.13-0ubuntu1.2` (Example 7).

## Examples with Explanations

### 1. Which sudo answers, and why

The priorities come from the packages' own maintainer scripts. You can read them without installing anything:

```bash
# alternatives.sh — show how each package registers /usr/bin/sudo
apt-get download sudo-rs sudo            # or fetch the .debs from the archive pool
for d in sudo-rs_*.deb sudo_*.deb; do
  mkdir -p ctl-$d && dpkg-deb -e "$d" ctl-$d
  grep -A1 'update-alternatives --install /usr/bin/sudo' ctl-$d/postinst
done
```

```text
        update-alternatives --install /usr/bin/sudo sudo /usr/lib/cargo/bin/sudo 50 \
            --slave /usr/sbin/visudo visudo /usr/lib/cargo/bin/visudo \
        update-alternatives --install /usr/bin/sudo sudo /usr/bin/sudo.ws 40 \
            --slave /usr/sbin/visudo visudo /usr/sbin/visudo.ws \
```

In auto mode the higher priority wins, so sudo-rs is `/usr/bin/sudo` whenever both are installed. On 26.04 both always are:

```bash
apt-cache depends ubuntu-minimal | grep -E '^ubuntu|sudo'
apt-cache policy sudo-rs sudo | grep -E '^[a-z]|Candidate'
```

```text
ubuntu-minimal
  Depends: sudo
  Depends: sudo-rs

sudo-rs:
  Candidate: 0.2.13-0ubuntu1.2
sudo:
  Candidate: 1.9.17p2-1ubuntu3.2
```

The binary identifies itself:

```text
$ sudo --version
sudo-rs 0.2.13-0ubuntu1.2
```

On a real host, `readlink -f "$(command -v sudo)"` resolves to `/usr/lib/cargo/bin/sudo`. `update-alternatives --query sudo` shows `Value:` and both candidates with their priorities.

### 2. Password feedback: what changed and how to turn it off

sudo-rs 0.2.13 (2026-03-10) changed the default to `Defaults pwfeedback`. Ubuntu 26.04's release notes call it out ("Password feedback is now enabled by default in order to improve the user experience of sudo") and give the opt-out. Launchpad bug 2142721, which objected to the change, was closed as Won't Fix. Two controls exist:

- **Per prompt:** press **TAB** while typing. Feedback stops for that prompt (sudo-rs 0.2.13+, with Ubuntu's TAB fix patch).
- **Per host:** add the negation to sudoers through `visudo`.

```bash
sudo visudo -f /etc/sudoers.d/10-no-pwfeedback
```

```text
# /etc/sudoers.d/10-no-pwfeedback
Defaults !pwfeedback
```

```bash
sudo visudo -c
```

Both implementations accept `!pwfeedback`. In the lab, a file containing `Defaults lecture=always`, `Defaults !pwfeedback` and `Defaults timestamp_timeout=5` parsed OK under both checkers (case 06 below).

### 3. The same file, two verdicts

Twelve small sudoers files, each showing one construct, checked with both implementations from the 26.04 archive:

```text
# 01-wildcard-mid.sudoers
deploy ALL=(root) /usr/bin/systemctl restart app-*.service
# 02-wildcard-tail.sudoers
deploy ALL=(root) /usr/bin/journalctl -u app.service *
# 03-noexec-tag.sudoers
deploy ALL=(root) NOEXEC: /usr/bin/less /var/log/syslog
# 04-regex.sudoers
deploy ALL=(root) /usr/bin/systemctl ^(start|stop) app\.service$
# 05-ipv4-host.sudoers
deploy 10.0.0.5=(root) /usr/bin/systemctl restart app.service
# 06-defaults.sudoers
Defaults lecture=always
Defaults !pwfeedback
Defaults timestamp_timeout=5
deploy ALL=(root) /usr/bin/systemctl restart app.service
# 07-mail-tag.sudoers
deploy ALL=(root) MAIL: /usr/bin/systemctl restart app.service
# 08-env-keep.sudoers
Defaults env_keep += "HTTP_PROXY HTTPS_PROXY"
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin"
deploy ALL=(root) SETENV: /usr/bin/apt-get update
# 09-logfile.sudoers
Defaults logfile=/var/log/sudo.log
deploy ALL=(root) /usr/bin/systemctl restart app.service
# 10-intercept.sudoers
deploy ALL=(root) INTERCEPT: /usr/bin/make -C /srv/app deploy
# 11-timestamp-global.sudoers
Defaults timestamp_type=global
# 12-cmd-glob.sudoers
%ops ALL=(root) /usr/sbin/fsck*
```

```bash
for f in cases/*.sudoers; do
  echo "== ${f##*/}"
  printf '  C sudo : '; visudo.ws -c -f "$f" 2>&1 | tr '\n' ' '; echo
  printf '  sudo-rs: '; /usr/lib/cargo/bin/visudo -c -f "$f" 2>&1 | head -1; echo
done
```

| Case | C sudo 1.9.17p2 `visudo.ws` | sudo-rs 0.2.13 `visudo` |
|------|------------------------------|-------------------------|
| 01 wildcard inside arguments | parsed OK | `syntax error: wildcards are not allowed in command arguments` |
| 02 trailing `*` (any further args) | parsed OK | parsed OK |
| 03 `NOEXEC:` tag | parsed OK | parsed OK |
| 04 regex arguments (`^…$`) | parsed OK | `syntax error: illegal escape sequence` |
| 05 IPv4 address as host | parsed OK | `syntax error: hosts cannot be specified using an IPv4 address` |
| 06 `lecture`, `!pwfeedback`, `timestamp_timeout` | parsed OK | parsed OK |
| 07 `MAIL:` tag | parsed OK | `syntax error: this tag is ignored by sudo-rs` |
| 08 `env_keep`, `secure_path`, `SETENV:` | parsed OK | parsed OK |
| 09 `Defaults logfile=` | parsed OK | `syntax error: unknown setting: 'logfile'` |
| 10 `INTERCEPT:` tag | parsed OK | `syntax error: INTERCEPT is not supported by sudo-rs` |
| 11 `timestamp_type=global` | parsed OK | `syntax error: unknown setting: 'timestamp_type'` |
| 12 wildcard in the command name | parsed OK | parsed OK |

Ubuntu's stock `/etc/sudoers` (from `sudo-common`) parses OK under both. It uses `env_reset`, `mail_badpass`, `secure_path`, `use_pty`, group rules and `@includedir`. Breakage comes from local additions.

Two of these deserve a note:

- **Case 01 is the important one.** In C sudo, `restart app-*.service` also matches `restart app-x.service other-unit.service`, because `*` in an argument can match spaces. That is a classic over-grant. sudo-rs refuses the construct instead of reproducing the trap. A standalone `*` as the *last* argument means "zero or more further arguments" (case 02, 0.2.13+). Wildcards in the command path still work (case 12).
- **Case 11 depends on the version.** sudo-rs 0.2.15 adds `timestamp_type` with the values `tty` and `ppid`. `global` is not supported in any version. Check with the sudo-rs version that will actually run on the host.

### 4. Rewrite the rejected rules

Spell out the commands. A `Cmnd_Alias` keeps the rule readable:

```text
# 01-wildcard-mid.fixed.sudoers
Cmnd_Alias APP_RESTART = /usr/bin/systemctl restart app-web.service, \
                         /usr/bin/systemctl restart app-worker.service
deploy ALL=(root) APP_RESTART
```

```text
# 04-regex.fixed.sudoers
deploy ALL=(root) /usr/bin/systemctl start app.service, \
                  /usr/bin/systemctl stop app.service
```

For the others: drop `logfile` (sudo-rs always logs through syslog(3), so on a systemd host the events are in the journal). Replace `INTERCEPT` with a narrower command list or a wrapper script owned by root. Remove `MAIL:`. Use a hostname or `ALL` instead of an IPv4 address.

### 5. Preflight: check files with the target release's visudo, without installing it

sudo-rs's `visudo` is a normal dynamically linked program. The package declares `libc6 (>= 2.39)`, and `-c -f` needs no privileges, so you can run it from an extracted `.deb` on a CI runner or on the host before the upgrade:

```sh
#!/bin/sh
# sudo-rs-preflight.sh FILE... - check sudoers files with the visudo that
# ships in Ubuntu 26.04's sudo-rs package, without installing anything.
# Needs: curl, dpkg-deb, glibc >= 2.39 (the package's own Depends).
set -eu
DEB=sudo-rs_0.2.13-0ubuntu1.2_amd64.deb
URL=http://archive.ubuntu.com/ubuntu/pool/main/r/rust-sudo-rs/$DEB
WORK=${TMPDIR:-/tmp}/sudo-rs-preflight
mkdir -p "$WORK"
[ -f "$WORK/$DEB" ] || curl -sSfo "$WORK/$DEB" "$URL"
dpkg-deb -x "$WORK/$DEB" "$WORK/root"
VISUDO=$WORK/root/usr/lib/cargo/bin/visudo
echo "checker: $("$VISUDO" --version)"
bad=0
for f in "$@"; do
  if out=$("$VISUDO" -c -f "$f" 2>&1); then
    echo "ok    $f"
  else
    bad=$((bad + 1))
    echo "FAIL  $f"
    echo "$out" | sed -n '1,3s/^/      /p'
  fi
done
echo "$bad file(s) need changes before switching to sudo-rs"
[ "$bad" -eq 0 ]
```

```bash
./sudo-rs-preflight.sh *.sudoers; echo "exit=$?"
```

```text
checker: visudo-rs 0.2.13
FAIL  01-wildcard-mid.sudoers
      01-wildcard-mid.sudoers:2:19: syntax error: wildcards are not allowed in command arguments
      deploy ALL=(root) /usr/bin/systemctl restart app-*.service
                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ok    02-wildcard-tail.sudoers
ok    03-noexec-tag.sudoers
FAIL  04-regex.sudoers
      04-regex.sudoers:2:56: syntax error: illegal escape sequence
      deploy ALL=(root) /usr/bin/systemctl ^(start|stop) app\.service$
                                                             ^
FAIL  05-ipv4-host.sudoers
      05-ipv4-host.sudoers:2:8: syntax error: hosts cannot be specified using an IPv4 address
      deploy 10.0.0.5=(root) /usr/bin/systemctl restart app.service
             ^~~~~~~~
ok    06-defaults.sudoers
FAIL  07-mail-tag.sudoers
      07-mail-tag.sudoers:2:19: syntax error: this tag is ignored by sudo-rs
      deploy ALL=(root) MAIL: /usr/bin/systemctl restart app.service
                        ^~~~
ok    08-env-keep.sudoers
FAIL  09-logfile.sudoers
      09-logfile.sudoers:2:10: syntax error: unknown setting: 'logfile'
      Defaults logfile=/var/log/sudo.log
               ^~~~~~~
FAIL  10-intercept.sudoers
      10-intercept.sudoers:2:19: syntax error: INTERCEPT is not supported by sudo-rs
      deploy ALL=(root) INTERCEPT: /usr/bin/make -C /srv/app deploy
                        ^~~~~~~~~
FAIL  11-timestamp-global.sudoers
      11-timestamp-global.sudoers:2:10: syntax error: unknown setting: 'timestamp_type'
      Defaults timestamp_type=global
               ^~~~~~~~~~~~~~
ok    12-cmd-glob.sudoers
7 file(s) need changes before switching to sudo-rs
exit=1
```

After the rewrites in Example 4:

```bash
./sudo-rs-preflight.sh *.fixed.sudoers; echo "exit=$?"
```

```text
checker: visudo-rs 0.2.13
ok    01-wildcard-mid.fixed.sudoers
ok    04-regex.fixed.sudoers
0 file(s) need changes before switching to sudo-rs
exit=0
```

On a host, point it at `/etc/sudoers /etc/sudoers.d/*` (as root, since the files are mode 0440). The exit status works as a CI gate for configuration-management repositories that template sudoers. For 26.10, change `DEB=` to the 0.2.14 package. The checker must match the release you are moving to.

### 6. Switch implementation (and back)

```bash
sudo update-alternatives --config sudo                 # pick interactively
sudo update-alternatives --set sudo /usr/bin/sudo.ws   # C sudo, scripted
sudo update-alternatives --auto sudo                   # back to priority order (sudo-rs)
sudo --version | head -1
```

The `visudo`, `sudoedit` and man-page slaves move with the master link (Example 1), so after `--set sudo /usr/bin/sudo.ws`, plain `visudo` is C sudo's again. Run `sudo visudo -c` straight after any switch, from a second, already-root shell.

### 7. Know which security fixes you have

```bash
apt changelog sudo-rs | head -6
```

```text
rust-sudo-rs (0.2.13-0ubuntu1.2) resolute-security; urgency=medium

  * d/patches/fix-sudoedit.patch: Fix privilege escalation race in sudoedit
    (LP: #2165142)

 -- Simon Johnsson <simon.johnsson@canonical.com>  Thu, 27 Aug 2026 10:15:26 +0200
```

(Lab output from `zcat usr/share/doc/sudo-rs/changelog.Debian.gz` inside the extracted package. `apt changelog` shows the same text on an installed host.) Upstream advisory GHSA-f42v-x7gq-phc8 ("Time-of-check vs time-of-use issue in sudoedit allows local privilege escalation") covers sudo-rs `>= 0.2.8, < 0.2.15`. A Ubuntu version string like `0.2.13` does not tell you whether the fix is in. The package changelog does.

## The trap

1. **Upgrading first, validating second.** The first person to discover that `/etc/sudoers.d/50-deploy` uses a mid-argument wildcard is the deploy pipeline, after the release upgrade. Run the preflight against the target release's checker before you upgrade.
2. **Trusting `visudo -c` from the wrong implementation.** On a 24.04 host, `visudo` is C sudo's and passes everything above. On 26.04, `visudo` is sudo-rs's. `visudo.ws` is still there and still says "parsed OK".
3. **Reading the wrong man page.** `man sudoers` follows the alternative. Docs and blog posts about sudoers usually describe C sudo, which supports regexes, `logfile`, `INTERCEPT`, LDAP and `cvtsudoers`. sudo-rs supports none of these.
4. **Relying on `sudo -E` in scripts.** sudo-rs does not support it. Use `--preserve-env=VAR,...` with matching `env_keep`, or pass `VAR=value` explicitly under `SETENV:`.
5. **Removing the `sudo-rs` package to "go back".** `ubuntu-minimal` depends on it. Use `update-alternatives`, not `apt remove`.

## The boring rule

On Ubuntu 25.10 and later, assume `sudo` is sudo-rs. Keep sudoers inside its subset: explicit command lists, a trailing `*` only where any further arguments are really acceptable, no regexes, hosts by name or `ALL`, logging through the journal. Gate every sudoers change in CI with the checker from the release you run. If you need a C-sudo-only feature, switch with `update-alternatives` on that host deliberately and write down why. Decide `pwfeedback` per host class, once, with a drop-in file, not per user.

## Try this

1. Run `sudo-rs-preflight.sh /etc/sudoers /etc/sudoers.d/*` (as root) on a 24.04 host you plan to upgrade. How many files fail?
2. On a 26.04 VM, type a sudo password, press TAB halfway through, and watch the feedback stop. Then add `Defaults !pwfeedback` with `visudo -f /etc/sudoers.d/10-no-pwfeedback` and confirm the prompt is silent.
3. On a throwaway VM running C sudo, install `deploy ALL=(root) /usr/bin/systemctl restart app-*.service` and run `sudo -l -U deploy /usr/bin/systemctl restart app-x.service ssh.service`. If it prints the command, the rule allows it. That is the over-grant sudo-rs rejects.
4. Swap the `DEB=` line to the 26.10 package (`sudo-rs_0.2.14-1ubuntu4_amd64.deb`) and re-run case 11 with `timestamp_type=tty`. Compare with 0.2.13.

## Sources

- sudo-rs README, "Differences from original sudo": <https://github.com/trifectatechfoundation/sudo-rs#differences-from-original-sudo>
- sudo-rs CHANGELOG (0.2.13 `pwfeedback` default, TAB toggle, final-`*` wildcard; 0.2.14; 0.2.15 `timestamp_type=ppid`): <https://github.com/trifectatechfoundation/sudo-rs/blob/main/CHANGELOG.md>
- `sudoers-rs(5)`, `sudo-rs(8)`, `visudo-rs(8)`: man pages shipped in `sudo-rs 0.2.13-0ubuntu1.2` (also rendered in the repository's `docs/`)
- Advisory GHSA-f42v-x7gq-phc8 (sudoedit TOCTOU, fixed in 0.2.15): <https://github.com/trifectatechfoundation/sudo-rs/security/advisories/GHSA-f42v-x7gq-phc8>
- Ubuntu 26.04 LTS release notes, "sudo-rs" (password feedback default and `Defaults !pwfeedback`): <https://documentation.ubuntu.com/release-notes/26.04/changes-since-previous-interim/>
- Launchpad, `rust-sudo-rs` publishing history (24.04 to 26.10 versions): <https://launchpad.net/ubuntu/+source/rust-sudo-rs>
- Launchpad bug 2142721 (asterisks report, "Won't Fix", the `!pwfeedback` workaround): <https://bugs.launchpad.net/ubuntu/+source/rust-sudo-rs/+bug/2142721>
- Package maintainer scripts and metadata: `sudo-rs_0.2.13-0ubuntu1.2`, `sudo_1.9.17p2-1ubuntu3.2`, `sudo-common_1.2ubuntu`, `ubuntu-minimal 1.570` (Ubuntu 26.04 archive)
- C sudo `sudoers(5)` for the constructs sudo-rs omits: <https://www.sudo.ws/docs/man/sudoers.man/>
