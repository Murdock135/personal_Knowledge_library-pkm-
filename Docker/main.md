> **Note**: This folder and the notes within are deprecated in the sense that if you watch this youtube playlist [free docker fundamentals course](https://youtube.com/playlist?list=PLTk5ZYSbd9Mg51szw21_75Hs1xUpGObDm&si=v1swlww6I45_Ot9a), you don't need to learn about docker from this folder.
# What is docker
Docker is software that helps to create packaged [containers](https://cloud.google.com/learn/what-are-containers), which are essentially just file systems that contain everything an application needs to be run.
The 2 main tools that docker makes use of are 
1. A [dockerfile](https://docs.docker.com/reference/dockerfile/)
2. A compose file (basically a YAML file)
In Docker-speak, docker accomplishes this by creating an [[image]], which is essentially a specification that declares everything one needs inside a container, be that for developing applications or just writing random files of code or text, the use case is up for the user to decide. Thus, to learn docker, one needs to learn *how to build a docker image* and then *how to create a container out of that image.* Furthermore, it is possible to make a set of containers talk to each other and essentially serve the same application. For example, 1 container may contain a database and another, a backend for a website. It is possible to write to the database from the backend-containing container.
There are two ways of *accessing* images.
1. *Running* a prebuilt image
2. *Building* an image yourself (from a *base image*, which acts as a primitive) and *then* running it.
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
This is the part where you will learn how to build your own docker images. We do this with a dockerfile. Let's define that first.
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