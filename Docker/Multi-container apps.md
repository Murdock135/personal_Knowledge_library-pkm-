We use networking to connect containers. There are two ways to put a container on a network:
- Assign the network when starting the container.
- Connect an already running container to a network.
To create a network use
```
docker network create todo-app
```

# References
1. https://docs.docker.com/get-started/workshop/07_multi_container/