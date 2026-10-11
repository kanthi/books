---
title: "Static Linking: Why glibc Binaries Are Big, and When musl Is the Answer"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Static Linking: Why glibc Binaries Are Big, and When musl Is the Answer

## Thesis

Link a one-line `puts("hello")` program statically against glibc and you get roughly **750 KB**. Link the same source against musl and you get about **25 KB**. Neither number is a bug. Both follow from how a static archive (`libc.a`) works: the linker copies in every object file that resolves a symbol that something already copied in needs, and it keeps going until nothing is missing. glibc's stdio is built for locales, wide characters and loadable character-set converters, so pulling in `puts` drags in the converter machinery and, behind that, a small copy of the dynamic loader. musl's stdio does not have that dependency chain.

The size is the visible part. The part that bites is behaviour: a "fully static" glibc binary still reads `/etc/nsswitch.conf` at run time, and for anything beyond the built-in `files` and `dns` sources it tries to load **shared** NSS modules from the host. The linker warns you about this. This chapter measures the size, traces where it comes from, and shows when static glibc, static musl or plain dynamic linking is the right choice.

## Mental model

```text
 your main.o needs: puts
        │
        ▼
 libc.a(ioputs.o)        needs __io_vtables
 libc.a(vtables.o)       needs _IO_new_file_setbuf
 libc.a(fileops.o)       needs __wcsmbs_named_conv   ← wide-char support in every FILE
 libc.a(wcsmbsload.o)    needs __gconv_find_transform
 libc.a(gconv_db.o)      needs __gconv_find_shlib     ← iconv converters live in .so files
 libc.a(gconv_dl.o)      needs __libc_dlopen_mode
 libc.a(dl-libc.o)       needs _dl_open               ← so a static binary carries a loader
 ...                     425 archive members in total (musl: 29)
```

| Fact | Consequence |
|------|-------------|
| The linker pulls **whole object files** from `libc.a`, transitively | One call can bring in hundreds of objects. `-ffunction-sections -Wl,--gc-sections` on *your* code cannot undo libc's internal references |
| glibc's `FILE` supports wide orientation and locale conversion | `puts` reaches iconv (`gconv`) and from there `dlopen` |
| glibc NSS (users, groups, hosts) is plugin based | Static binaries still read `nsswitch.conf` and may `dlopen` `libnss_*.so.2` of the host |
| musl implements NSS-like lookups directly (files and DNS only) | Small and self-contained, but it ignores `nsswitch.conf`, so LDAP/SSSD/systemd users are invisible to it |
| A dynamic binary shares one `libc.so.6` | ~16 KB on disk, but needs a compatible glibc on the target |

## Worked examples

Tested on Debian 13 (x86_64) with GCC 14.2.0, glibc 2.41 and musl 1.2.5 (`musl-tools` provides the `musl-gcc` wrapper). The mechanisms described here have been stable for many glibc and musl releases; exact byte counts vary by version and distribution.

### Case 1: Measure the three builds

```c
/* hello.c — the smallest useful program */
#include <stdio.h>

int main(void)
{
    puts("hello");
    return 0;
}
```

```bash
gcc      -O2         -o hello-dyn   hello.c
gcc      -O2 -static -o hello-glibc hello.c
musl-gcc -O2 -static -o hello-musl  hello.c
for f in hello-dyn hello-glibc hello-musl; do strip -o $f.s $f; done
ls -l hello-dyn hello-glibc hello-musl *.s | awk '{print $5, $9}'
size hello-dyn hello-glibc hello-musl
```

```text
15952 hello-dyn
14472 hello-dyn.s
758448 hello-glibc
676288 hello-glibc.s
24640 hello-musl
17768 hello-musl.s
   text	   data	    bss	    dec	    hex	filename
   1306	    584	      8	   1898	    76a	hello-dyn
 640899	  23688	  22576	 687163	  a7c3b	hello-glibc
   4956	    336	   1688	   6980	   1b44	hello-musl
```

Stripping removes symbol tables, not code: the glibc build is still 676 KB. The `text` column is the honest comparison. Static glibc carries **640 KB** of code for `puts`, static musl about **5 KB**.

```bash
ldd hello-dyn; ldd hello-glibc; ldd hello-musl
```

```text
	linux-vdso.so.1 (0x00007f0fec57d000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f0fec373000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f0fec57f000)
	not a dynamic executable
	not a dynamic executable
```

### Case 2: Ask the linker why

A link map records every archive member that was pulled in and the symbol that caused it:

```bash
gcc -O2 -static -o hello-glibc hello.c -Wl,-Map=glibc.map
awk '/^Archive member included/{f=1;next} /^Discarded|^Allocating|^Memory map/{f=0} f' glibc.map > members.txt
grep -o 'libc\.a([^)]*)' members.txt | sort -u | wc -l
```

```text
425
```

The same count for musl (`musl-gcc ... -Wl,-Map=musl.map`) is **29**. To follow the chain, look up each member and the line after it, which names the object and symbol that required it:

```bash
# why.sh — print which object (and symbol) pulled a libc.a member into the link
w() { grep -A1 "^/[^ ]*libc.a($1)" members.txt | tail -1 | sed 's#.*libc.a(#libc.a(#; s#^ *##'; }
for m in ioputs.o vtables.o fileops.o wcsmbsload.o gconv_db.o gconv_dl.o dl-libc.o dl-open.o dl-support.o; do
  printf '%-14s <- %s\n' "$m" "$(w $m)"
done
```

```text
ioputs.o       <- /tmp/cc4rLaBC.o (puts)
vtables.o      <- libc.a(ioputs.o) (__io_vtables)
fileops.o      <- libc.a(vtables.o) (_IO_new_file_setbuf)
wcsmbsload.o   <- libc.a(fileops.o) (__wcsmbs_named_conv)
gconv_db.o     <- libc.a(wcsmbsload.o) (__gconv_find_transform)
gconv_dl.o     <- libc.a(gconv_db.o) (__gconv_find_shlib)
dl-libc.o      <- libc.a(gconv_dl.o) (__libc_dlopen_mode)
dl-open.o      <- libc.a(dl-libc.o) (_dl_open)
dl-support.o   <- libc.a(libc-start.o) (_dl_aux_init)
```

(The first line names the temporary object GCC made from `hello.c`.) Two independent roots explain most of the size:

1. **stdio → iconv → dlopen.** Any glibc `FILE` may be switched to wide orientation and convert through a character set whose converter lives in a `gconv` shared module, so `fileops.o` references the converter loader, which references `dlopen`.
2. **Startup → loader support.** `__libc_start_main` in a static binary initialises TLS, IRELATIVE relocations (for the CPU-specific `memcpy`/`strlen` variants), tunables and auxv handling through `dl-support.o` and friends.

The largest symbols confirm it:

```bash
nm --size-sort -S -t d hello-glibc | tail -8
```

```text
0000000004537792 0000000000007845 T _dl_relocate_object_no_relro
0000000004379296 0000000000008401 t printf_positional
0000000004565200 0000000000008551 t __printf_fp_buffer_1.isra.0
0000000004387712 0000000000009636 T __printf_buffer
0000000004758976 0000000000013272 r translit_from_tbl
0000000004780416 0000000000013800 R __tens
0000000004876416 0000000000016384 B __pthread_keys
0000000004728768 0000000000023548 r translit_to_tbl
```

A program that only calls `puts` contains the dynamic relocator, the full `printf` engine with floating-point formatting, and transliteration tables.

### Case 3: Users and hosts

```c
/* lookup.c — resolve a user and a host name */
#include <netdb.h>
#include <pwd.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    const char *host = argc > 1 ? argv[1] : "localhost";
    struct passwd *pw = getpwnam("root");
    printf("root's shell: %s\n", pw ? pw->pw_shell : "(not found)");

    struct addrinfo *res;
    int rc = getaddrinfo(host, NULL, NULL, &res);
    printf("getaddrinfo(%s): %s\n", host, rc ? gai_strerror(rc) : "ok");
    if (!rc) freeaddrinfo(res);
    return 0;
}
```

```bash
gcc -O2 -static -o lookup-glibc lookup.c
```

```text
/usr/bin/ld: /tmp/ccONpojX.o: in function `main':
lookup.c:(.text.startup+0x4c): warning: Using 'getaddrinfo' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
/usr/bin/ld: lookup.c:(.text.startup+0x1d): warning: Using 'getpwnam' in statically linked applications requires at runtime the shared libraries from the glibc version used for linking
```

The build succeeds, which is why people miss the warning. Compare what each binary reads at run time:

```bash
musl-gcc -O2 -static -o lookup-musl lookup.c
strace -e trace=open,openat ./lookup-musl localhost
strace -e trace=open,openat ./lookup-glibc localhost 2>&1 | grep -v locale
```

```text
open("/etc/passwd", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 5
root's shell: /bin/bash
open("/etc/hosts", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 5
getaddrinfo(localhost): ok
+++ exited with 0 +++
openat(AT_FDCWD, "/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 5
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 5
openat(AT_FDCWD, "/etc/host.conf", O_RDONLY|O_CLOEXEC) = 5
openat(AT_FDCWD, "/etc/resolv.conf", O_RDONLY|O_CLOEXEC) = 5
openat(AT_FDCWD, "/etc/hosts", O_RDONLY|O_CLOEXEC) = 5
openat(AT_FDCWD, "/etc/gai.conf", O_RDONLY|O_CLOEXEC) = 5
root's shell: /bin/bash
getaddrinfo(localhost): ok
+++ exited with 0 +++
```

musl reads `/etc/passwd` and `/etc/hosts` directly and never looks at `nsswitch.conf`. (It uses `open(2)`, not `openat(2)`, which is why the trace includes both.) Static glibc follows `nsswitch.conf`. On this host it says `passwd: files` and `hosts: files dns`, and since glibc 2.34 those two sources are built into libc, so nothing is loaded. On a host configured with `passwd: files systemd sss` or `hosts: files mdns4_minimal dns`, the static binary tries to `dlopen` `libnss_systemd.so.2`, `libnss_sss.so.2` and so on from the host. Those modules must come from the **same glibc version** the binary was linked with.

## The trap

**"Static" glibc is not self-contained, and the failure is silent.** Ship `lookup-glibc` into a minimal container or onto a host with a different glibc, and one of three things happens when a lookup needs a plugin:

- the module is missing: the lookup quietly returns "not found" (directory users do not exist, mDNS names do not resolve);
- the module is present but from another glibc: the lookup can fail or crash inside the module, because glibc's internal interfaces are not stable between versions;
- the module is present and matching: it works, on that host, by luck.

None of these produces an error at startup, so tests on the build machine pass. musl avoids the problem by not supporting plugins at all, which is its own trap: a musl binary on an LDAP or SSSD host will not see directory users, whatever `nsswitch.conf` says.

Pick on purpose:

| Need | Choose |
|------|--------|
| Runs on any Linux, only local files and DNS | Static **musl** |
| Must honour the host's NSS (LDAP, SSSD, systemd-homed, mDNS) | **Dynamic** glibc, built against the oldest glibc you support |
| Static glibc for other reasons (a rescue tool, an initramfs) | Avoid NSS calls entirely, or ship the exact matching `libnss_*` modules beside it |

## The boring rule

> Treat `-static` with glibc as a portability claim you must prove, not a flag. Read the linker's NSS warnings as errors (`-Wl,--fatal-warnings` makes them fail the build). Use static musl for small, self-contained tools that only need local files and DNS, dynamic glibc for anything that must see the host's users and names, and measure size with `size`, not `ls`.

## Try this

1. Add `-Wl,--fatal-warnings` to the static glibc build of `lookup.c` and confirm that the NSS warnings now fail the link.
2. Replace `puts` with `write(1, "hello\n", 6)` and rebuild statically with glibc. How many archive members remain, and does `gconv_db.o` still appear in the map?
3. Build `lookup.c` statically against musl, run it in a `FROM scratch` container with only `/etc/passwd` and `/etc/hosts` copied in, and then do the same with the static glibc build.
4. Use `-Wl,--trace-symbol=__libc_dlopen_mode` to print every object that defines or references the loader entry point in each build.

## Sources

- GNU C Library manual: [Name Service Switch](https://sourceware.org/glibc/manual/latest/html_node/Name-Service-Switch.html) and [NSS module internals](https://sourceware.org/glibc/manual/latest/html_node/NSS-Module-Internals.html)
- glibc 2.34 release notes ([NEWS](https://sourceware.org/git/?p=glibc.git;a=blob;f=NEWS)): `nss_files` and `nss_dns` built into libc
- glibc FAQ / wiki: [statically linked programs and NSS](https://sourceware.org/glibc/wiki/FAQ#Even_statically_linked_programs_need_some_shared_libraries_which_is_not_acceptable_for_me.__What_can_I_do.3F)
- musl documentation: [Functional differences from glibc](https://wiki.musl-libc.org/functional-differences-from-glibc.html) (name resolution, no NSS)
- GNU ld manual: [`-Map`, `--trace-symbol`, `--fatal-warnings`](https://sourceware.org/binutils/docs/ld/Options.html)
- `nsswitch.conf(5)`, `getaddrinfo(3)`, `getpwnam(3)` man pages
