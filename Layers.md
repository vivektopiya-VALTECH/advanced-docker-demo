# Docker image layers

- a docker images are composed of layers
- each of these layers, once created, are **immutable** and **Read-only**
- can be thought as git for docker image
- can be **Shared** across multiple images

## Example
Foe example, typical Dockerfile steps by layers for python app

1. add basic commands and a package manager, such as apt.
2. install a Python runtime and pip for dependency management.
3. copy application’s specific requirements.txt file.
4. install application’s specific dependencies.
5. copy in the actual source code of the application.



| Dockerfile Instruction | Layer Created? | Description                                              |
|------------------------|----------------|----------------------------------------------------------|
| `FROM`                 | ✅              | Starts with a base image layer                           |
| `RUN`                  | ✅              | Creates a new layer with the changes made by the command |
| `COPY` / `ADD`         | ✅              | Adds files to a new layer                                |
| `CMD`, `ENTRYPOINT`    | ❌              | Stored as metadata (no filesystem change)                |


```dockerfile
FROM ubuntu:20.04           # Layer 1: base image
RUN apt-get update          # Layer 2: update package list
RUN apt-get install -y curl # Layer 3: install curl
COPY . /app                 # Layer 4: copy app files
```
Each step creates a new layer that builds on top of the previous one.

## Storage
### Linux
- `/var/lib/docker/<storage-driver>/` (storage driver are overlay2, aufs, btrfs)
- Each layer is stored in its own directory with metadata and the layer’s diff.

### Mac
- `/Users/vivek.topiya/Library/Containers/com.docker.docker/Data/vms/0/data`
- inside VM stored as .raw file
- no direct access to docker vm
- can be seen in docker desktop

## Layer Caching and Reuse
- Docker caches layers based on instruction and context.
- If nothing changes in the instruction or its dependencies, Docker reuses the existing layer.
- This is why ordering of Dockerfile instructions matters for performance.

```dockerfile
FROM python:3.10
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
```

## Where layers are used
- shared across multiple builds
- layers are uploaded on docker push command

## Benefits of Layer Sharing
- Storage Savings
- Faster Builds
- Faster Deployments
- Efficient CI/CD
