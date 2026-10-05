# unshare / nsenter

## Overview

Linux **namespaces** give a process its own private view of one kernel resource: hostnames, network stacks, mount tables, PID numbers, user IDs, IPC objects, cgroup roots, or clocks. Containers are mostly namespaces plus cgroups. You do not need a container engine to use them, though. Two util-linux commands drive namespaces directly:

- **`unshare`** runs a program in **new** namespaces.
- **`nsenter`** runs a program inside the **existing** namespaces of another process (a container, a sandboxed service, a test rig).
- **`lsns`** lists the namespaces that exist and which processes hold them.

Typical operator jobs: run a build or test with **no network**; give a script a throwaway **private `/tmp` or mount**; debug a container's sockets with the **host's** `ss`, `ip`, and `tcpdump`; create a **network lab** of namespaces wired with veth pairs; or check what "root inside a container" really means.

```bash
# Debian/Ubuntu: util-linux is installed by default (unshare, nsenter, lsns)
unshare --version
```

```text
unshare from util-linux 2.41.5
```

Every namespace is visible as a symlink under `/proc/<pid>/ns/`. Two processes share a namespace exactly when those links point at the same inode:

```bash
readlink /proc/self/ns/net
unshare -r -n readlink /proc/self/ns/net
```

```text
net:[4026531840]
net:[4026532326]
```

## Syntax

```bash
unshare [options] [program [args...]]          # default program: $SHELL
nsenter [options] [program [args...]]
lsns    [options] [namespace-inode]
```

| Namespace | `unshare` / `nsenter` flag | Isolates |
|-----------|----------------------------|----------|
| mount | `-m` / `--mount` | Mount table (what `mount`, `findmnt` see) |
| UTS | `-u` / `--uts` | Hostname and NIS domain name |
| IPC | `-i` / `--ipc` | System V IPC, POSIX message queues |
| network | `-n` / `--net` | Interfaces, routes, firewall, sockets, ports |
| PID | `-p` / `--pid` | Process ID numbering (new PID 1) |
| user | `-U` / `--user` | UID/GID mappings and capabilities |
| cgroup | `-C` / `--cgroup` | View of the cgroup hierarchy |
| time | `-T` / `--time` | `CLOCK_MONOTONIC` / `CLOCK_BOOTTIME` offsets |

Key `unshare` options:

| Option | Meaning |
|--------|---------|
| `-r`, `--map-root-user` | New user namespace; map your UID/GID to 0 inside (**rootless** sandboxes) |
| `-c`, `--map-current-user` | New user namespace; keep your own UID inside |
| `--map-auto` / `--map-users` / `--map-groups` | Map ranges from `/etc/subuid` / `/etc/subgid` (needs `newuidmap`/`newgidmap`) |
| `-f`, `--fork` | Fork before running the program (required with `--pid`) |
| `--mount-proc[=dir]` | Mount a fresh `/proc` (implies `--mount`); needed for `ps` in a new PID namespace |
| `--kill-child[=signal]` | If `unshare` dies, kill the forked child (implies `--fork`) |
| `--propagation private\|slave\|shared\|unchanged` | Mount propagation in the new mount namespace (default: `private`) |
| `--net=FILE` (any `--TYPE=FILE`) | Make the namespace **persistent** by bind-mounting it onto `FILE` |
| `-R DIR` / `-w DIR` | Set root directory / working directory |
| `--boottime S` / `--monotonic S` | Clock offsets for a new time namespace |

Key `nsenter` options:

| Option | Meaning |
|--------|---------|
| `-t PID`, `--target PID` | Take namespaces from this process |
| `-m -u -i -n -p -U -C -T` | Enter that namespace of the target (or `--net=FILE` for a bind-mounted one) |
| `-a`, `--all` | Enter all of the target's namespaces |
| `--preserve-credentials` | Do not change UID/GID/groups after entering a user namespace |
| `-S UID` / `-G GID` | Set UID/GID inside |
| `-r[DIR]` / `-w[DIR]` | Use the target's root / working directory (or the given one) |
| `-e`, `--env` | Inherit the target's environment variables |
| `-c`, `--join-cgroup` | Also join the target's cgroup |

## Safety

- **"Root" inside a user namespace is not host root.** `unshare -r` gives UID 0 and a full capability set *over resources owned by that namespace* only. Files owned by real root stay protected (see example 1). That is what makes rootless sandboxes possible.
- **`sudo unshare` / `sudo nsenter` are real root.** Entering a container's mount namespace as host root can edit its filesystem; entering its network namespace can change its firewall. Prefer entering only the namespaces you need (`-n` for network debugging), and read before you write.
- **Unprivileged user namespaces can be restricted by policy.** Ubuntu 24.04+ ships `kernel.apparmor_restrict_unprivileged_userns=1`. `unshare -r` then fails with `write failed /proc/self/uid_map: Operation not permitted` unless an AppArmor profile grants `userns`. Some hardened kernels set `user.max_user_namespaces=0`. Prefer a per-program AppArmor profile over disabling the restriction globally.
- **Persistent namespaces outlive their processes.** A namespace bind-mounted with `--net=FILE` or `ip netns add` keeps its interfaces, routes, and firewall rules until you unmount or delete it.
- **Namespaces are isolation, not a security boundary on their own.** Container runtimes add seccomp, dropped capabilities, cgroups, and LSM profiles. A bare `unshare` sandbox has none of those.

## Examples with Explanations

### 1. Rootless "root": a user namespace

```bash
id -u
unshare --user --map-root-user id
unshare -r cat /proc/self/uid_map
```

```text
1000
uid=0(root) gid=0(root) groups=0(root),65534(nogroup)
         0       1000          1
```

`uid_map` reads "inside 0 ↔ outside 1000, range 1". Only that one UID is mapped. Anything else, including real root, appears as the overflow ID `65534` (`nobody`):

```bash
echo "root secret" | sudo tee root-only.txt >/dev/null && sudo chmod 600 root-only.txt
touch mine.txt
unshare -r stat -c '%u:%g %A %n' mine.txt root-only.txt
unshare -r cat root-only.txt
```

```text
0:0 -rw-r--r-- mine.txt
65534:65534 -rw------- root-only.txt
cat: root-only.txt: Permission denied
```

Your own file looks root-owned inside; real root's file stays out of reach. `-r` is the building block for every other rootless example below. Unprivileged users can create the other namespace types only when they also create a user namespace that owns them.

### 2. Run a command with no network

```bash
unshare -r -n curl -sS --max-time 3 https://example.com/
echo "exit=$?"
unshare -r -n ip -br link
```

```text
curl: (6) Could not resolve host: example.com
exit=6
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
```

A new network namespace contains only a **down** loopback interface. This is a cheap way to prove that a test suite, build, or installer is hermetic. The command fails instead of silently downloading. Bring `lo` up if the program talks to itself over `127.0.0.1`:

```bash
unshare -r -n sh -c 'ip link set lo up; ip -br addr'
```

```text
lo               UNKNOWN        127.0.0.1/8 ::1/128 
```

### 3. Private hostname (UTS)

```bash
unshare -r -u sh -c 'hostname lab-ns; hostname'
hostname
```

```text
lab-ns
<your-hostname>
```

The change exists only inside the namespace. This is handy for software that keys configuration or certificates off `hostname`.

### 4. New PID namespace: be PID 1

```bash
unshare -r -p -f --mount-proc sh -c 'sleep 30 & ps -o pid,ppid,user,cmd'
```

```text
    PID    PPID USER     CMD
      1       0 root     sh -c sleep 30 & ps -o pid,ppid,user,cmd
      2       1 root     sleep 30
      3       1 root     ps -o pid,ppid,user,cmd
```

Both flags matter:

- **`-f`**: `unshare()` with `CLONE_NEWPID` affects the caller's **children**, not the caller. Without `--fork`, the program's *first child* becomes PID 1, and when that child exits the namespace is dead:

  ```bash
  unshare -r -p sh -c '/bin/true; /bin/true; echo after'
  ```

  ```text
  sh: 1: Cannot fork
  ```

- **`--mount-proc`**: `ps` reads `/proc`. Without a fresh `/proc` for the new PID namespace, it sees the host's and gets confused:

  ```bash
  unshare -r -p -f sh -c 'ps -o pid,cmd'
  ```

  ```text
  fatal library error, lookup self
  ```

Remember that PID 1 has special duties: it reaps orphans, and it ignores signals it has no handler for. For long-lived sandboxes, run a small init (`tini`, `dumb-init`) as PID 1.

### 5. Private mounts: a throwaway tmpfs

```bash
unshare -r -m sh -c 'mount -t tmpfs scratch /mnt && echo inside > /mnt/note && cat /mnt/note && findmnt -n -o TARGET,SOURCE,FSTYPE /mnt'
findmnt /mnt || echo "host: nothing on /mnt"
```

```text
inside
/mnt scratch tmpfs
host: nothing on /mnt
```

`unshare` sets mount propagation to **private** by default, so mounts made inside never leak back to the host. When the last process exits, the tmpfs and its contents vanish. This pattern gives scripts a private `/tmp` without touching anyone else's.

### 6. Time namespace: fake uptime

```bash
cut -d' ' -f1 /proc/uptime
unshare -r -T --boottime 86400 cut -d' ' -f1 /proc/uptime
```

```text
7268.18
93668.19
```

The process inside sees `CLOCK_BOOTTIME` (and `/proc/uptime`) one day ahead. This is useful for testing uptime-based logic and checkpoint/restore. The wall clock (`CLOCK_REALTIME`) is **not** namespaced.

### 7. Enter a running sandbox with `nsenter`

Start a long-running rootless sandbox, find its PID, compare namespaces, and enter it:

```bash
#!/usr/bin/env bash
# lsns-demo.sh — start a sandbox, inspect it, enter it, stop it
unshare -r -n -u --fork --kill-child sh -c 'hostname sandbox; exec sleep 600' &
UPID=$!
sleep 1
PID=$(pgrep -P "$UPID")
echo "sandbox PID: $PID"
for ns in user net uts mnt; do
  printf '%-5s host=%-18s sandbox=%s\n' "$ns" "$(readlink /proc/$$/ns/$ns)" "$(readlink /proc/$PID/ns/$ns)"
done
lsns -t net -o NS,TYPE,NPROCS,PID,COMMAND | awk 'NR==1 || /sleep 600/'
nsenter -t "$PID" -U -n -u --preserve-credentials sh -c 'echo "inside: $(hostname)"; ip -br link'
kill "$PID"
wait 2>/dev/null
```

```bash
bash lsns-demo.sh
```

```text
sandbox PID: 70874
user  host=user:[4026531837]  sandbox=user:[4026532584]
net   host=net:[4026531840]   sandbox=net:[4026532586]
uts   host=uts:[4026532318]   sandbox=uts:[4026532585]
mnt   host=mnt:[4026532317]   sandbox=mnt:[4026532317]
        NS TYPE NPROCS   PID COMMAND
4026532586 net       2 70872 unshare -r -n -u --fork --kill-child sh -c hostname sandbox; exec sleep 600
inside: sandbox
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
```

Read it like this:

- `user`, `net`, and `uts` differ; `mnt` is shared because we did not ask for `-m`.
- `lsns` reports 2 processes in the new net namespace. `unshare` itself joined the namespaces before forking (PID namespaces are the exception), so the lowest PID shown is the `unshare` process.
- As an unprivileged user you may enter a namespace owned by **your** user namespace. You must enter the user namespace too (`-U`). Use `--preserve-credentials`, because `nsenter` otherwise calls `setgroups()`, which `unshare -r` disables (`/proc/<pid>/setgroups` reads `deny`):

  ```bash
  nsenter -t "$PID" -U -n -u sh -c id
  ```

  ```text
  nsenter: setgroups failed: Operation not permitted
  ```

- `kill "$PID"` targets the child. With `--fork`, the `unshare` parent ignores `SIGINT` and `SIGTERM` while it waits, so `kill $UPID` alone leaves both processes running. `--kill-child` covers the case where the parent dies by `SIGKILL`.

Host root can enter just the namespaces it needs, without the user namespace:

```bash
sudo nsenter -t "$PID" -n -u sh -c 'id -u; hostname; ip -br link'
```

```text
0
sandbox
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
```

### 8. Debug a container or sandboxed service with host tools

Enter only the **network** namespace, so the container's sockets are visible to the host's `ss`, `ip`, `tcpdump`, and `curl`. Those tools need not exist in the image:

```bash
# Podman / Docker container (illustrative)
PID=$(podman inspect -f '{{.State.Pid}}' web)        # or: docker inspect -f '{{.State.Pid}}' web
sudo nsenter -t "$PID" -n ss -ltnp
sudo nsenter -t "$PID" -n tcpdump -ni any port 8080

# systemd service with PrivateNetwork=yes / PrivateTmp=yes (illustrative)
PID=$(systemctl show -p MainPID --value myapp.service)
sudo nsenter -t "$PID" -n ip -br addr
sudo nsenter -t "$PID" -m ls -la /tmp                 # the service's private /tmp
```

These two snippets are illustrative. They were not run on the test machine, which had no systemd or container engine. The `nsenter` mechanics are the same as in examples 7 and 9.

Because the mount namespace was **not** entered with `-n` alone, the binaries come from the host. Adding `-m` switches to the container's filesystem, and therefore to the container's binaries.

### 9. Persistent namespaces and `ip netns`

Bind-mounting a namespace onto a file keeps it alive with no process inside:

```bash
sudo touch /run/lab-net
sudo unshare --net=/run/lab-net true                 # process exits; namespace survives
findmnt -n -o TARGET,SOURCE,FSTYPE /run/lab-net
sudo nsenter --net=/run/lab-net sh -c 'ip link set lo up'
sudo nsenter --net=/run/lab-net ip -br addr          # state persisted between entries
sudo umount /run/lab-net && sudo rm /run/lab-net
```

```text
/run/lab-net nsfs[net:[4026532227]] nsfs
lo               UNKNOWN        127.0.0.1/8 ::1/128 
```

`ip netns` is the same mechanism with a convention: named network namespaces are bind mounts under `/run/netns/`. A two-endpoint lab connected by a veth pair, serving HTTP from inside the namespace:

```bash
sudo ip netns add lab
sudo ip link add veth-host type veth peer name veth-lab
sudo ip link set veth-lab netns lab
sudo ip addr add 10.200.0.1/24 dev veth-host && sudo ip link set veth-host up
sudo ip netns exec lab sh -c 'ip addr add 10.200.0.2/24 dev veth-lab; ip link set veth-lab up; ip link set lo up'

sudo nsenter --net=/run/netns/lab ip -br addr        # nsenter and ip netns are interchangeable

mkdir -p www && echo "hello from netns lab" > www/index.html
sudo ip netns exec lab python3 -m http.server 8080 --bind 10.200.0.2 -d "$PWD/www" >/dev/null 2>&1 &
sleep 1
curl -s http://10.200.0.2:8080/
sudo ss -N lab -ltn

# clean up: stop processes inside, then delete (deleting the netns destroys veth-lab and its peer)
sudo ip netns pids lab | xargs -r sudo kill
sudo ip netns del lab
```

```text
lo               UNKNOWN        127.0.0.1/8 ::1/128 
veth-lab@if5     UP             10.200.0.2/24 fe80::b433:a7ff:fe20:e061/64 
hello from netns lab
State  Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0      5         10.200.0.2:8080      0.0.0.0:*   
```

`ss -N NAME` (`--net=NAME`) is a shortcut for "run `ss` inside `/run/netns/NAME`". The `fe80::` link-local address and the `@ifN` index will differ on your machine.

### 10. List namespaces

```bash
lsns                                     # all namespaces visible to you, one line each
lsns -t net                              # only network namespaces
lsns -p "$PID"                           # every namespace of one process
lsns -T                                  # tree view (by owning user namespace)
sudo lsns -t net -o NS,NPROCS,PID,NETNSID,NSFS,COMMAND   # include ip-netns bind mounts
```

Run `lsns` as root to see every process; unprivileged, it shows only what `/proc` lets you read. The `NSFS` column shows bind-mount paths such as `/run/netns/lab`.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| `--pid` without `--fork` | `Cannot fork` after the first child exits. Always use `-p -f` |
| New PID namespace without `--mount-proc` | `ps`/`top` show host processes or fail (`lookup self`) |
| `nsenter -U` into an `unshare -r` sandbox without `--preserve-credentials` | `setgroups failed: Operation not permitted` |
| `kill <unshare-pid>` does nothing | With `--fork` the parent ignores `SIGINT`/`SIGTERM`. Signal the child, or use `--kill-child` and `SIGKILL` |
| `unshare -r` → `write failed /proc/self/uid_map` | Ubuntu 24.04+ AppArmor userns restriction, or userns disabled by sysctl |
| `--map-auto` → `failed to execute newuidmap` | Install the `uidmap` package; the user needs `/etc/subuid` and `/etc/subgid` entries |
| `-n` alone in a container debug session | Binaries and config come from the host (usually what you want). Add `-m` for the container's view |
| Forgotten `ip netns` / `--net=FILE` mounts | Namespaces and their interfaces linger. Check `ip netns list`, `findmnt -t nsfs` |
| `CLOCK_REALTIME` in a time namespace | Not namespaced. Only monotonic and boottime offsets exist |

## Related Commands

| Command | Role |
|---------|------|
| `lsns` | List namespaces and their processes |
| `ip netns` | Named network namespaces under `/run/netns` (`add`, `exec`, `pids`, `del`) |
| `ss -N NAME` | Sockets inside a named netns |
| `setpriv` | Drop capabilities / set no-new-privs before running a sandboxed program |
| `systemd-run -p PrivateNetwork=yes -p PrivateTmp=yes` | The same namespaces, managed as a transient unit |
| `podman` | Full rootless containers built on user namespaces |
| `chroot` | Change root directory only, with no namespace isolation |

## Try this

1. Prove a build is hermetic: run your project's test command under `unshare -r -n`, and fix every test that tries to reach the network.
2. Give a script a private `/tmp`: `unshare -r -m sh -c 'mount -t tmpfs tmpfs /tmp && ./script.sh'`. Confirm that nothing it writes appears in the host `/tmp`.
3. Start `unshare -r -p -f --mount-proc bash`, run `sleep 1000 &` and `ps`, then find the same `sleep` from the host with `pgrep sleep`. Compare the two PIDs.
4. Build the veth lab from example 9, then add a second namespace and a Linux bridge so that two namespaces can reach each other through the host.
5. On an Ubuntu 24.04+ machine, check `sysctl kernel.apparmor_restrict_unprivileged_userns`, reproduce the `uid_map` error, and write a minimal AppArmor profile that allows `userns` for one script.

## Sources

- [unshare(1)](https://man7.org/linux/man-pages/man1/unshare.1.html), [nsenter(1)](https://man7.org/linux/man-pages/man1/nsenter.1.html), [lsns(8)](https://man7.org/linux/man-pages/man8/lsns.8.html) — util-linux manual pages
- [namespaces(7)](https://man7.org/linux/man-pages/man7/namespaces.7.html), [user_namespaces(7)](https://man7.org/linux/man-pages/man7/user_namespaces.7.html), [pid_namespaces(7)](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html), [time_namespaces(7)](https://man7.org/linux/man-pages/man7/time_namespaces.7.html)
- [ip-netns(8)](https://man7.org/linux/man-pages/man8/ip-netns.8.html) — iproute2
- [AppArmor wiki — unprivileged user namespace restrictions](https://gitlab.com/apparmor/apparmor/-/wikis/unprivileged_userns_restriction) (Ubuntu 23.10/24.04 behaviour)
