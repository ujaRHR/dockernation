<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Docker_Logo.png/960px-Docker_Logo.png" alt="Docker Logo">

# DockerNation: A practical Docker cheatsheet for developers

A beginner-friendly Docker cheatsheet covering the concepts and commands I use most often. It starts with the basics and gradually moves into Dockerfiles, Compose, networking, volumes, and common workflows.

</div>

---

### 📂 Introduction
Docker is a platform that allows you to package applications and their dependencies into containers. These containers can run consistently across different environments, from your local machine to production servers.

#### Why Docker?
> One of the main reasons I use Docker is to keep the development environment consistent. Instead of asking everyone to install the same versions of Node, PostgreSQL, Redis, etc., the project can define those dependencies in code.
> 
> This also makes it easier to reproduce the same environment locally and in production.

### 📂 Docker vs Virtual Machines

Virtual machines include a full operating system, which makes them heavy and slow to start. Docker containers share the host operating system kernel, making them lightweight and fast.

| Types         | Virtual Machine | Docker Container |
| :-------      | :------:        | -------:         |
| Size          | More            | Megabytes        |
| Startup time  | Minutes         | Seconds          |
| Resource usage| High            | Low              |
| Isolation     | Complete        | Process-level    |

### 📂 Installation

#### Windows/macOS:

Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop) from the official website:

- Install the .dmg/.exe file
- Start Docker Desktop from Applications

Verify installation:
```bash
docker --version
# Output: Docker version 29.0.0, build 3d4129b

docker compose version
# Output: Docker Compose version v2.40.3
```

#### Linux:

Follow the [installation instructions](https://docs.docker.com/engine/install) from the official website based on your Linux distribution.

Verify installation

```bash
sudo docker --version
# Output: Docker version 29.0.0, build 3d4129b
```

Add your user to the docker group to run Docker without sudo:
```bash
sudo usermod -aG docker $USER
# Log out and log back in for this to take effect
```

#### First Test

Run this command to verify everything is working:

```bash
docker run hello-world
```

This command downloads a test image and runs it in a container. If you see a "Hello from Docker!" message, your installation is successful.


## 📂 Core Concepts

These are the most essential topics you need to understand before diving into the commands:

#### Images

- A Docker image is a read-only template that contains the application code, runtime, libraries, and dependencies needed to run an application.
- Think of an image as a recipe or a blueprint. It describes what should be in the container, but it isn't running anything yet.
- Images ensure that everyone uses the exact same environment. When you share an image, you're sharing the complete setup, not just instructions that might be interpreted differently.

Example:

```bash
# The nginx:1.29.3 image contains:
# - Nginx web server version 1.29.3
# - All required libraries
# - Default configuration
# - Linux base system
```

#### Containers

- A container is a running instance of an image. It's an isolated process that runs on your host machine.
- If an image is a recipe, a container is the actual dish you've cooked. You can create many containers (dishes) from one image (recipe).
- Containers provide isolation, so multiple applications can run on the same machine without interfering with each other.

Example:

```bash
# You can run multiple containers independently from the same nginx image
docker run -d -p 8080:80 --name web1 nginx:1.29.3
docker run -d -p 8081:80 --name web2 nginx:1.25
```

#### Dockerfile

- A text file containing instructions to build a Docker image.
- Instead of manually configuring a system, you write the steps in a Dockerfile. This makes your setup reproducible and version-controlled.

Example:

```dockerfile
FROM node:24-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD ["node", "server.js"]
```

#### Docker Compose

- A tool for defining and running multi-container applications using a YAML file.
- Real applications often need multiple services (web server, database, cache). Docker Compose lets you start them all with one command and ensures they can communicate.

Example:

```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"
  database:
    image: postgres:15
```

#### Docker Hub

- A cloud-based registry where you can find and share Docker images.
- Instead of building everything from scratch, you can use official images maintained by organizations. For example, you don't need to figure out how to install Node.js in a container - just use the official Node.js image.

#### Volumes

- A mechanism for persisting data generated by and used by Docker containers.
- Containers are temporary. When you delete a container, all data inside it is lost. Volumes store data outside the container so it persists.

---

### 📂 Browse Other Concepts:

[Introduction](README.md) | [Basic Commands](Basic-Commands.md) | [Containers](Containers.md) | [Docker Compose](Docker-Compose.md) | [Dockerfile](Dockerfile-Guide.md) | [Networking](Networking.md) | [Volumes](Volumes-Data.md) | [Best Practice](Best-Practices.md)


#### 📑 Resources

1. Official Documentation
   - [Docker Documentation](https://docs.docker.com/)
   - [Docker Hub](https://hub.docker.com/)
   - [Docker Compose Documentation](https://docs.docker.com/compose/)
   - [Dockerfile Reference](https://docs.docker.com/engine/reference/builder/)

2. Learning Resources
   - [Docker Getting Started Tutorial](https://docs.docker.com/get-started/)
   - [Play with Docker](https://labs.play-with-docker.com/) - Browser-based Docker playground

3. Tools
   - [Docker Desktop](https://www.docker.com/products/docker-desktop)
   - [Portainer](https://www.portainer.io/) - Container management UI
   - [Dive](https://github.com/wagoodman/dive) - Explore image layers
   - [Hadolint](https://github.com/hadolint/hadolint) - Dockerfile linter


#### Contributing

If you find something outdated or incorrect, feel free to open an issue or submit a PR.

Useful contributions include:
- fixing outdated commands
- adding practical examples
- improving explanations
- adding troubleshooting notes

#### License
This cheatsheet is released under the MIT License. Feel free to use, modify, and distribute it.

---

**Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)**