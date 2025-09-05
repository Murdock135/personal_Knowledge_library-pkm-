# Building a docker image
**command:** ``docker buildx build [OPTIONS] PATH | URL | -``
**aliases**: ``docker build`` and [more](https://docs.docker.com/reference/cli/docker/buildx/build/)
## Tagging
Using `docker build <path_to_build_context>` will not give the resulting image a name or a tag. To tag you need to use the following command
```sh
docker build -t [HOST[:PORT_NUMBER]/]PATH[:TAG]
```
### Examples
---
> `docker build -t nginx`

This is equivalent to 
`docker build -t docker.io/library/nginx:latest`
Thus, the defaults are
- `HOST`=`docker.io` (registry)
- `PATH`=`library` (namespace)
- `TAG`=`latest` (tag)
This pulls an image from the `docker.io` registry, the `library` namespace, the `nginx` image repository and the `latest` tag.
---
> `docker/welcome_to_docker` 

This is equivalent to 
`docker.io/docker/welcome_to_docker/docker:latest`
This pulls an image from the `docker.io` registry, the `docker` namespace, the `welcome-to-docker` image repository, and the `latest` tag.

---
> `ghcr.io/dockersamples/example-voting-app-vote:pr-311`

This pulls an image from the github container registry, `dockersamples` namespace, the `example-voting-app-vote` image with the `pr-311` tag.