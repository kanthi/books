# podman

## Overview

`podman` is a **daemonless** OCI container engine with a CLI largely compatible with Docker. It excels at **rootless** containers and integrates cleanly with systemd via `podman generate systemd` / Quadlet. Prefer it when you want containers without a long-lived root daemon.

```bash
sudo apt install podman    # or distro equivalent
sudo dnf install podman
```

## Syntax

```bash
podman [global options] command [options]
```

## Common Commands

| Command | Description |
|---------|-------------|
| `run` | Create + start container |
| `ps` / `ps -a` | List containers |
| `images` | List images |
| `pull` / `push` | Registry ops |
| `build` | Build from Containerfile/Dockerfile |
| `exec` | Exec into running container |
| `stop` / `start` / `rm` / `rmi` | Lifecycle |
| `logs` / `inspect` | Debug |
| `pod` | Pod grouping (K8s-like) |
| `generate systemd` | Unit files |
| `compose` | Compose support (podman compose / podman-compose—check install) |
| `login` | Registry auth |

## Key Use Cases

1. Rootless development containers
2. Drop-in `docker` CLI workflows (`alias docker=podman` with caveats)
3. systemd-managed long-running containers
4. Building images without dockerd

## Examples with Explanations

### Run

```bash
podman run -it --rm alpine:3.20 sh
podman run -d --name web -p 8080:80 docker.io/library/nginx:alpine
podman ps
podman logs -f web
```

### Build

```bash
podman build -t myapp:dev .
podman images
```

### Rootless tips

```bash
id
podman info
# subuid/subgid must be configured for the user on many distros
grep ^$USER: /etc/subuid /etc/subgid
```

### systemd

```bash
podman create --name web -p 8080:80 nginx:alpine
podman generate systemd --new --name web > ~/.config/systemd/user/container-web.service
systemctl --user daemon-reload
systemctl --user enable --now container-web.service
```

Quadlet units (`.container` files) are the newer preferred approach on current Fedora/RHEL—check current Podman docs.

### One-liner recipes

```bash
# Cleanup
podman container prune
podman image prune -a   # careful

# Docker socket compatibility is optional; prefer native podman
podman run --rm quay.io/podman/hello
```

## Notes & Pitfalls

- **Docker Compose v2** (`docker compose`) is Docker’s plugin; Podman users often use `podman compose` or `podman-compose`—behavior is not 100% identical. Verify with current docs.
- Rootless port binding under 1024 needs config/workarounds.
- Volume SELinux labels (`:Z`, `:z`) matter on enforcing systems.
- `alias docker=podman` breaks tools that expect Docker API quirks—test.

## 2026-relevant notes

- Podman 4/5.x generations emphasize Quadlet and improved compose compatibility—**check your distro’s version** rather than assuming flags.
- Kubernetes remains the multi-node orchestrator; Podman is local/engine level.
- Prefer short image names only if registries.conf short-name mode is understood—fully qualify `docker.io/library/...` when debugging pulls.

## Related Commands

- `docker` — daemon-based engine
- `nerdctl` — containerd CLI
- `buildah` — image build focus
- `skopeo` — copy/inspect images
- `systemctl` — service management

## Additional Resources

- `man podman`
- docs.podman.io (verify current)
