---
keywords:
  - volume
  - mounting
---
# Persisting data within a container on the host machine
- [Volumes](https://docs.docker.com/engine/storage/volumes/) provide the ability to connect specific filesystem paths of the container back to the host machine. If you mount a directory in the container, changes in that directory are also seen on the host machine. If you mount that same directory across container restarts, you'd see the same files.
- Create a volume using
```
docker volume create <db_name>
```
- To check where docker persists that volume, use
```
docker volume inspect todo-db
```
To which you'll see something like the following
```
[
    {
        "CreatedAt": "2025-09-09T21:55:55-05:00",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/<db_name>/_data",
        "Name": "<db_name>",
        "Options": null,
        "Scope": "local"
    }
]
```
# Persisting data within a host machine in a container
- A bind mount is another type of mount, which lets you share a directory from the host's filesystem into the container. The container will get live updates to any changes made within the host machine, for example, changing source code from a project within the host machine.
- The container sees the changes you make to the code immediately, as soon as you save a file. This means that you can run processes in the container that watch for filesystem changes and respond to them.
- You can use https://npmjs.com/package/nodemon to watch for file changes, and then restart the application automatically.
# Quick volume type comparisons
The following are examples of a named volume and a bind mount using `--mount`:

- Named volume: `type=volume,src=my-volume,target=/usr/local/data`
- Bind mount: `type=bind,src=/path/to/data,target=/usr/local/data`

The following table outlines the main differences between volume mounts and bind mounts.
![[Pasted image 20250909222736.png]]

# Refs
1. https://docs.docker.com/get-started/workshop/05_persisting_data/#container-volumes
2. https://docs.docker.com/get-started/workshop/06_bind_mounts/