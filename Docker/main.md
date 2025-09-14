# What is docker
Docker is software that helps to create packaged [containers](https://cloud.google.com/learn/what-are-containers). 
The 2 main tools that docker makes use of are 
1. A [dockerfile](https://docs.docker.com/reference/dockerfile/)
2. A compose file (basically a YAML file)
In Docker-speak, docker accomplishes this by creating an [[image]], which is essentially a specification that declares everything one needs inside a container, be that for developing applications or just writing random files of code or text, the use case is up for the user to decide. Thus, to learn docker, one needs to learn *how to build a docker image* and then *how to create a container out of that image.* Furthermore, it is possible to make a set of containers talk to each other and essentially serve the same application. For example, 1 container may contain a database and another, a backend for a website. It is possible to write to the database from the backend containing container.

There are two ways of *accessing* images.
1. *Running* a prebuilt image
2. *Building* an image yourself (from a *base image*, which acts as a primitive) and *then* running it.
Some notes:
- An image can make use of other images. Like, building software on top of other software.
# Building Images
You can build an image by using the `docker build [OPTIONS] BUILD_CONTEXT_DIR | URL | - ` (See [full reference](https://docs.docker.com/reference/cli/docker/buildx/build/), See [[docker build]])
Suppose you have a `Dockerfile` in your machine (we'll talk about writing a dockerfile later), you can build an image with the following command.
```
docker build -t <image_tag> -f <path_to_dockerfile> BUILD_CONTEXT_DIR | URL_TO_REMOTE_REPO | -
```
You can read about making image tags in [[docker build]] and [image tag reference](https://docs.docker.com/reference/cli/docker/image/tag/). The `path_to_dockerfile` can be a relative path (including `.`) or even a URL. If a URL is provided, docker will clone the repo and treat that repo as the build context.
> Note:
> The use of `-` is multi-fold. I'll make notes on that later.
# Running containers
`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]` will run an already built image in a container. This image may have been built by you or imported from, say, a git repository or, docker hub (a hub for finding prebuilt images)
# Removing containers
`docker rm [OPTIONS] CONTAINER` (See [full reference](https://docs.docker.com/reference/cli/docker/container/rm/))
For example,
```
docker rm /redis
```
This will remove the container named '`/redis`' (Docker allows container names to start with a `/` and the aforementioned name is the same as `redis`). If the container is still running, you have to use the `-f` option to force kill.
# Removing images
`docker rmi`  can do 2 things
1. Remove an image
2. Remove image tags.
# Listing Images
`docker image ls` will list all images
# Listing containers
`docker ps -a` will list all images.
# Entering a container
There are 3 ways of entering a container. Each of the ways are used in separate situations. Keep reading to find out how
## If the container is running
```
docker exec -it <container_name_or_id> <shell_name>
```
## If the dockerfile specifies a command 
When the image has a default command (via `CMD` or `ENTRYPOINT` in the dockerfile (you'll see these later)) you can override it at runtime:
```
docker run -it <image_name> <shell_name>
```
This runs the container interactively with your specified command, instead of the default one.
## Running a stopped container and entering directly
```
docker start -ai <container_name_or_id>
```
The `-a` attaches your terminal to the container output, and `-i` makes it interactive.
> ⚠️ Note: You cannot “enter” a container that has exited without restarting it. If you want to explore the same environment, you may instead start a new container from the same image.

