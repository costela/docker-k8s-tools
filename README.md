[![Docker Hub Version](https://img.shields.io/badge/dynamic/json.svg?label=docker%20hub&url=https%3A%2F%2Findex.docker.io%2Fv1%2Frepositories%2Fcostela%2Fk8s-tools%2Ftags&query=%24[-1:].name&colorB=green)](https://hub.docker.com/r/costela/k8s-tools)

# k8s tools

This is a small docker image containing some common tools for interacting with kubernetes clusters.

Typical usage would be:
```
$ docker-compose run k8s-tools
```
Which would drop you into a shell with the tools