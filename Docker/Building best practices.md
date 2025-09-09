- Use multi-stage builds
- Creating reusable stages (if multiple images contain shared components)
- You should also consider using two types of base image: one for building and unit testing, and another (typically slimmer) image for production. In the later stages of development, your image may not require build tools such as compilers, build systems, and debugging tools. A small image with minimal dependencies can considerably lower the attack surface.
- Rebuild images regularly to update package versions. You can use the `--no-cache` option to avoid cache hits.
```
docker build --no-cache -t my-image:my-tag .
```

- Leverage build cache. (See [Docker build cache](https://docs.docker.com/build/cache/).)
- Pin base images to a specific digest. For example
```dockerfile
# syntax=docker/dockerfile:1
FROM alpine:3.21@sha256:a8560b36e8b8210634f77d9f7f9efd7ffa463e380b75e2e74aff4511df3ef88c
```

# Refs
1. https://docs.docker.com/build/building/best-practices/