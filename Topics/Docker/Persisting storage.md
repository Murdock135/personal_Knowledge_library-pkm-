---
keywords:
  - volume
  - mounting
---
# Motivation
By default, data written into a container doesn't persist after the container is destroyed. To overcome this, docker provides the following methods.
- [Volume mounts](https://docs.docker.com/engine/storage/#volume-mounts)
- [Bind mounts](https://docs.docker.com/engine/storage/#bind-mounts)
- [tmpfs mounts](https://docs.docker.com/engine/storage/#tmpfs-mounts)
- [Named pipes](https://docs.docker.com/engine/storage/#named-pipes)
No matter which type of mount you choose to use, the data looks the same from within the container. It is exposed as either a directory or an individual file in the container's filesystem.
# Volume mounts
Volume data is stored on the host, but **can only be interacted with from a container** and is managed by the Docker daemon. When you create a volume, a new directory is created within Docker's storage directory on the host machine and Docker manages everything within it. [from bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)Volumes are ideal for performance-critical data processing and long-term storage needs.
Volumes can be created with
```bash
docker volume create <volume name>
```
# Bind mounts
Bind mounts can be accessed by both docker containers and the filesystem. When you use a bind mount, a file or directory on the host machine is mounted from the host into a container.[from bind mounts](https://docs.docker.com/engine/storage/bind-mounts/)Use bind mounts when you need to be able to access files from both the container and the host. **Use bind mounts to share source code between a dev environment on the docker host and a container.** If you don't want the container to write to the mounted data, you can use the `ro`(`readonly`) option. The actual command to bind mount will be discussed later.
```bash
docker run --mount type=bind,src=<host-path>,dst=<container-path>
docker run --volume <host-path>:<container-path>
```
> Note:
> `--mount` is the preferred way because `--volume` will create the `<host-path>` if it doesn't exist!

 
## Bind-mounting over existing data
If stuff already exists where you're trying to mount data into, the pre-existing stuff will be "obscured". [bind mounting over existing data](https://docs.docker.com/engine/storage/bind-mounts/#bind-mounting-over-existing-data). With containers, there's no straightforward way of removing a mount to reveal the obscured files again. Your best option is to recreate the container without the mount.
# tmpfs mounts
While this kind of data is stored in the host's **memory**, the data is lost when the container is stopped or restarted or even when the host is rebooted.
These mounts are suitable for scenarios requiring temporary, in-memory storage, such as caching intermediate data, handling sensitive information like credentials, or reducing disk I/O. Use tmpfs mounts only when the data does not need to persist beyond the current container session.
# Named Pipes
[Named pipes](https://docs.microsoft.com/en-us/windows/desktop/ipc/named-pipes) can be used for communication between the Docker host and a container. Common use case is to run a third-party tool inside of a container and connect to the Docker Engine API using a named pipe.