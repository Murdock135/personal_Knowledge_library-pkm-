> **Note**: This folder and the notes within are deprecated in the sense that if you watch this youtube playlist [free docker fundamentals course](https://youtube.com/playlist?list=PLTk5ZYSbd9Mg51szw21_75Hs1xUpGObDm&si=v1swlww6I45_Ot9a), you don't need to learn about docker from this folder.

# Who should learn Docker?
Docker is not for everyone...
# What is docker
Docker is software that helps to create packaged [containers](https://cloud.google.com/learn/what-are-containers), which are essentially just file systems that contain everything an application needs to be run.
The 2 main tools that docker makes use of are 
1. A [dockerfile](https://docs.docker.com/reference/dockerfile/)
2. A compose file (basically a YAML file)
In Docker-speak, docker accomplishes this by creating an [[image]], which is essentially a specification that declares everything one needs inside a container, be that for developing applications or just writing random files of code or text, the use case is up for the user to decide. Thus, to learn docker, one needs to learn *how to build a docker image* and then *how to create a container out of that image.* Furthermore, it is possible to make a set of containers talk to each other and essentially serve the same application. For example, 1 container may contain a database and another, a backend for a website. It is possible to write to the database from the backend-containing container.
There are two ways of *accessing* images.
3. *Running* a prebuilt image
4. *Building* an image yourself (from a *base image*, which acts as a primitive) and *then* running it.
Some notes:
- An image can make use of other images. Like, building software on top of other software.
# Docker basic usage
By basic usage I mean simply running and stopping containers (and some operations on images). Beyond basic usage, docker is equipped with
- abilities for facilitating file exchanges between the host machine and the container
- networking between multiple containers
- Building multiple images using one dockerfile
- more stuff I probably don't know about
These are discussed under

## Building Images
You can build an image by using the `docker build [OPTIONS] BUILD_CONTEXT_DIR | URL | - ` (See [full reference](https://docs.docker.com/reference/cli/docker/buildx/build/), See [[docker build]])
Suppose you have a `Dockerfile` in your machine (we'll talk about writing a dockerfile later), you can build an image with the following command.
```
docker build -t <image_tag> -f <path_to_dockerfile> BUILD_CONTEXT_DIR | URL_TO_REMOTE_REPO | -
```
You can read about making image tags in [[docker build]] and [image tag reference](https://docs.docker.com/reference/cli/docker/image/tag/). The `path_to_dockerfile` can be a relative path (including `.`) or even a URL. If a URL is provided, docker will clone the repo and treat that repo as the build context.
> Note:
> The use of `-` is multi-fold. I'll make notes on that later.
## Running containers
`docker run [OPTIONS] IMAGE [COMMAND] [ARG...]` will run an already built image in a container. This image may have been built by you or imported from, say, a git repository or, docker hub (a hub for finding prebuilt images)
## Removing containers
`docker rm [OPTIONS] CONTAINER` (See [full reference](https://docs.docker.com/reference/cli/docker/container/rm/))
For example,
```
docker rm /redis
```
This will remove the container named '`/redis`' (Docker allows container names to start with a `/` and the aforementioned name is the same as `redis`). If the container is still running, you have to use the `-f` option to force kill.
## Removing images
`docker rmi`  can do 2 things
1. Remove an image
2. Remove image tags.
## Listing Images
`docker image ls` will list all images
## Listing containers
`docker ps -a` will list all images.
## Entering a container
There are 3 ways of entering a container. Each of the ways are used in separate situations. Keep reading to find out how
### If the container is running
```
docker exec -it <container_name_or_id> <shell_name>
```
### If the dockerfile specifies a command 
When the image has a default command (via `CMD` or `ENTRYPOINT` in the dockerfile (you'll see these later)) you can override it at runtime:
```
docker run -it <image_name> <shell_name>
```
This runs the container interactively with your specified command, instead of the default one.
### Running a stopped container and entering directly
```
docker start -ai <container_name_or_id>
```
The `-a` attaches your terminal to the container output, and `-i` makes it interactive.
> ⚠️ Note: You cannot “enter” a container that has exited without restarting it. If you want to explore the same environment, you may instead start a new container from the same image.

---
# Docker- Beyond the basics
This is the part where you will learn how to build your own docker images and understanding the nature of docker images. We build an image dockerfile. Let's define that first.
## Dockerfile
> **Note**:
> Right off the bat, I will tell you that writing a *good* or *optimized* dockerfile requires knowledge of software development practices (such as where does package dependency lists go, where in the file system is software downloaded, where do certain packages keep cache, etc), networking and last but definitely not least, understanding how docker internals work, which in turn helps understand how docker handles file sharing and networking.

The dockerfile is essentially a specification that declares everything one needs inside a container, be that for developing applications or just writing random files of code or text, the use case is up for the user to decide.
The syntax for the dockerfile is much like a mix of bash and SQL, although, it is possible to create custom syntax. Here is an example:
```dockerfile
FROM python:3.13
WORKDIR /usr/local/app

# Install the application dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy in the source code
COPY src ./src
EXPOSE 5000

# Setup an app user so the container doesn't run as the root user
RUN useradd app
USER app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]
```
The words in block e.g. `FROM` are called **instructions** and the words after an instruction are **arguments**. For a full list of instructions that can be used in the dockerfile see [Dockerfile reference](https://docs.docker.com/reference/dockerfile/) (Reading this at this point won't be beneficial to most readers at this point).
**Explanation of the above dockerfile**:
1. It imports a pre-built image from dockerhub, which is 'python:3.13'. This is an image that the folks at python made.
2. It sets the working directory to `/usr/local/app`. This means that if the instructions `ADD`, `CMD`, `ENTRYPOINT`, `COPY` or `RUN` is used after the workdir has been set, they will be run from that directory.
3. This copies `requirements.txt` into `./` which means the current directory, which was set earlier with the `WORKDIR` instruction.
4. This installs packages from the `requirements.txt` file and additionally tells pip to not keep the information of what package has been installed in the cache

# Advanced Docker: Writing Optimized dockerfiles
When building with docker, a layer is reused from the 'build cache' if the instruction and the files *it depends on* don't change. This is more efficient than rebuilding every layer whenever you use `docker build` or `docker run`. This can be taken advantage of and some of the ways to take advantage of this will seem unintuitive at first, but bear with me. You'll see the difference with experience.
Here are the techniques to optimize builds according to docker's docs:
1. Ordering layers in a smart way aka ordering the instructions in a smart way.
2. Keep the context small
3. Using *bind mounts* 
4. Using *cache mounts*
5. Using an external cache.
Now we discuss the above 5 things a little more extensively
## Ordering Instructions

## Using cache mounts
This ones a bit tricky and I myself found it *very* hard to understand. 
The right place to start to understand this is the `RUN` command. The `RUN` command lets us run any binaries available in the *current layer*. So, if you had Ubuntu installed in a previous layer, you can use any binaries that come with Ubuntu. For example, we can use the following to download the `gcc` program.

```dockerfile
FROM ubuntu

# Allow ubuntu to cache package downloads
RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN apt update && apt-get install -y gcc
```
In the above dockerfile, we did not use a cache mount. So no matter how many times you build a docker image from this dockerfile, it will redownload the `gcc` program, as any sensible person would expect. Now, let's use a cache mount with the `--mount=type=cache` command with `RUN`.
Okay but before we actually use it, let's think about *why* we would use this. Like I said before, no matter how many times you build an image from this dockerfile, it will redownload the `gcc` program's installation file (in the case of debian based distros, these are `.deb` files). But, what if we had knowledge of the fact that we already downloaded the `gcc` program for containers built out of this image? If only we had a way to *persist* this knowledge! And we can do this by *caching* this information into the *builder;* [BuildKit](https://docs.docker.com/build/buildkit/). Specifically, we can move the directory that is *meant to hold* this information into buildkit's storage (the wording 'meant to hold' is important). In the case of the `apt` package manager, this is the `/var/cache/apt/`. 
```
FROM ubuntu
# Allow ubuntu to cache package downloads
RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN \
    --mount=type=cache,target=/var/cache/apt \
    apt update && apt-get --no-install-recommends install -y gcc
```
Now, what did I mean by "we can move the directory that is meant to hold this ..."? where is this so called directory? This is inside the corresponding `RUN` layer's temporary file system (as you know, these temporary file systems are unioned into a "Union File System", which you don't need to understand but if you have OCD, find resources to read about them in [[Union file system]]). 

# Next Steps
You can follow multiple learning routes from here. 
- You can learn about using Docker compose to make multiple *services* and/or containers work together.
- You can learn to use [Docker Bake](https://docs.docker.com/build/bake/)
# References
- https://docs.docker.com/build/cache/optimize/#use-cache-mounts
- [Difference between --cache-to/from and --mount type=cache in docker buildx build](https://stackoverflow.com/questions/76351391/difference-between-cache-to-from-and-mount-type-cache-in-docker-buildx-build/76351422#76351422)
- https://yuki-nakamura.com/2024/02/04/use-a-run-cache-between-builds-in-buildkit/
- https://wordpress.com/post/yuki-nakamura.com/1476
- https://wordpress.com/post/yuki-nakamura.com/1512
- https://depot.dev/blog/how-to-use-buildkit-cache-mounts-in-ci
- https://www.docker.com/blog/understanding-the-docker-user-instruction/