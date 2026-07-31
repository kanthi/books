# podman

## Overview
`podman` (Pod Manager) is a daemonless container engine for developing, managing, and running OCI (Open Container Initiative) containers on Linux systems. It supports rootless container execution out of the box and shares an interface compatible with Docker CLI.

## Syntax
```bash
podman [command] [options]
```

## Common Subcommands
| Command | Description |
|---------|-------------|
| `run` | Run a command in a new container |
| `ps` | List containers |
| `images` | List local container images |
| `pull` | Pull an image from a registry |
| `build` | Build a container image using a Containerfile or Dockerfile |
| `exec` | Run a command inside an active container |
| `stop` | Stop one or more running containers |
| `rm` | Remove one or more containers |
| `generate systemd` | Create systemd unit file for a container |

## Key Use Cases
1. Running unprivileged (rootless) containers securely.
2. Managing OCI container lifecycles without running a persistent system daemon.
3. Integrating container workloads directly into `systemd` service units.

## Examples with Explanations
### Example 1: Running an Interactive Container
```bash
podman run -it --rm alpine sh
```
Runs an Alpine Linux container interactively and automatically removes it (`--rm`) when exited.

### Example 2: Exposing Container Ports
```bash
podman run -d --name web -p 8080:80 nginx:alpine
```
Launches an NGINX container in detached mode (`-d`), mapping host port 8080 to container port 80.

## Related Commands
- `docker` - Traditional daemon-based container engine
- `nerdctl` - CLI for containerd
- `systemctl` - System service manager
