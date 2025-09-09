- Use multi-stage builds
- Creating reusable stages (if multiple images contain shared components)
- You should also consider using two types of base image: one for building and unit testing, and another (typically slimmer) image for production. In the later stages of development, your image may not require build tools such as compilers, build systems, and debugging tools. A small image with minimal dependencies can considerably lower the attack surface.
- Rebuild images regularly to update package versions. You can use the `--no-cache` option to avoid cache hits.
```
docker build --no-cache -t my-image:my-tag .
```


# Refs
1. https://docs.docker.com/build/building/best-practices/