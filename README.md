<div align="center">
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Docker_Logo.png/960px-Docker_Logo.png" width="300" height="200" alt="Docker Logo">

# DockerNation: Cheatsheet for beginners

A comprehensive guide to Docker that takes you from complete beginner to upper intermediate level, with practical examples and clear explanations of what problems each concept solves.

</div>

---

<div align="center">
  
## 📑 Introduction

</div>

Docker is a platform that allows you to package applications and their dependencies into containers. These containers can run consistently across different environments, from your local machine to production servers.

### 📝 The Problem Docker Solves

**Before Docker:**
- "It works on my machine" - Applications behave differently across environments
- Complex setup processes for new developers joining a project
- Dependency conflicts between different projects on the same machine
- Difficult to replicate production environments locally
- Time-consuming deployment processes

**After Docker:**
- Consistent environments everywhere (development, testing, production)
- New developers can get started in minutes with a single command
- Each project runs in isolation with its own dependencies
- Production environment can be replicated exactly on your laptop
- Simplified and standardized deployment process

### 📝 Docker vs Virtual Machines

Virtual machines include a full operating system, which makes them heavy and slow to start. Docker containers share the host operating system kernel, making them lightweight and fast.

| Types         | Virtual Machine | Docker Container |
| :-------      | :------:        | -------:         |
| Size          | Minutes         | Megabytes        |
| Startup time  | More            | Seconds          |
| Resource usage| High            | Low              |
| Isolation     | Complete        | Process-level    |

---

## 📝 Installation

### Windows/macOS:

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

### Linux: 

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

### First Test

Run this command to verify everything is working:

```bash
docker run hello-world
```

This command downloads a test image and runs it in a container. If you see a "Hello from Docker!" message, your installation is successful.

---

## 📝 Core Concepts

These are the most essential topics you need to understand before diving into the commands:

### Images

- A Docker image is a read-only template that contains the application code, runtime, libraries, and dependencies needed to run an application.
- Think of an image as a recipe or a blueprint. It describes what should be in the container, but it isn't running anything yet.
- Images ensure that everyone uses the exact same environment. When you share an image, you're sharing the complete setup, not just instructions that might be interpreted differently.

**Example:**

```bash
# The nginx:1.29.3 image contains:
# - Nginx web server version 1.29.3
# - All required libraries
# - Default configuration
# - Linux base system
```

### Containers

- A container is a running instance of an image. It's an isolated process that runs on your host machine.
- If an image is a recipe, a container is the actual dish you've cooked. You can create many containers (dishes) from one image (recipe).
- Containers provide isolation, so multiple applications can run on the same machine without interfering with each other.

**Example:**
```bash
# You can run multiple containers independently from the same nginx image
docker run -d -p 8080:80 --name web1 nginx:1.29.3
docker run -d -p 8081:80 --name web2 nginx:1.25
```

### Dockerfile

- A text file containing instructions to build a Docker image.
- Instead of manually configuring a system, you write the steps in a Dockerfile. This makes your setup reproducible and version-controlled.

**Example:**
```dockerfile
FROM node:24-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD ["node", "server.js"]
```

### Docker Compose

- A tool for defining and running multi-container applications using a YAML file.
- Real applications often need multiple services (web server, database, cache). Docker Compose lets you start them all with one command and ensures they can communicate.

**Example:**
```yaml
services:
  web:
    build: .
    ports:
      - "3000:3000"
  database:
    image: postgres:15
```

### Docker Hub

- A cloud-based registry where you can find and share Docker images.
- Instead of building everything from scratch, you can use official images maintained by organizations. For example, you don't need to figure out how to install Node.js in a container - just use the official Node.js image.

### Volumes

- A mechanism for persisting data generated by and used by Docker containers.
- Containers are temporary. When you delete a container, all data inside it is lost. Volumes store data outside the container so it persists.

---
<div align="center">

## 🚥 Basic Commands

</div>

### Checking Docker Status

```bash
# Check Docker version
docker --version

# Display system-wide information
docker info

# Check if Docker daemon is running
docker ps

# Getting Help
docker --help
```

### Hello World

```bash
docker run hello-world
```

**What happens:**
1. Docker looks for the hello-world image locally
2. If not found, it downloads it from Docker Hub
3. It creates a container from that image
4. It runs the container, which prints a message
5. The container exits


### Searching for Images

```bash
# Search Docker Hub for images
docker search nginx
docker search postgres
... ... ...
```
> This command finds existing images, so you don't have to build everything from scratch. Official images are maintained by the software creators and are generally trustworthy.


### Pulling Images

```bash
# Download an image from Docker Hub
docker pull nginx:1.29.3

# Pull the latest version
docker pull nginx:latest
```

> **Best Practice:** Always use specific version tags in production instead of "latest".


### Listing Images

```bash
# List all images on your system
docker images

# List images with more details
docker images --all

# Filter images by name
docker images nginx
```


### Building Images

```bash
# Build an image from a Dockerfile in the current directory
docker build -t myapp:1.0 .

# Build with a specific Dockerfile
docker build -t myapp:1.0 -f Dockerfile.prod .

# Build without using cache (fresh build)
docker build --no-cache -t myapp:1.0 .
```
> Create custom images for your applications. The -t flag tags the image with a name and version for easy reference.

**Example:**
```bash
Assume this is your project structure:

myapp/
├── Dockerfile
├── src/
├── package.json
└── package-lock.json

# From the project directory Build the image
docker build -t myapp:1.0 .

# The . at the end means "use the current directory as the build context"
```

### Removing Images

```bash
# Remove a specific image
docker rmi nginx:1.25

# Remove multiple images
docker rmi nginx:1.25 postgres:15

# Force remove an image (even if containers are using it)
docker rmi -f myapp:1.0

# Remove all unused images
docker image prune

# Remove all images (use carefully!)
docker rmi $(docker images -q)
```


### Inspecting Images

```bash
# View detailed information about an image
docker inspect nginx:1.25

# View image layers and size
docker history nginx:1.25
```
> Try to understand what's inside an image, the networks, how it was built, and troubleshoot issues.


### Tagging Images

```bash
# Create a new tag for an existing image
docker tag myapp:1.0 myapp:latest

# Tag for pushing to a registry
docker tag myapp:1.0 username/myapp:1.0
```

> Create multiple references to the same image, making it easier to manage versions and prepare for pushing to registries.

---
<div align="center">

## 📝 Working with Containers

</div>

### Running Containers

```bash
# Run a container in foreground
docker run nginx:1.29.3

# Run a container in background (detached mode)
docker run -d nginx:1.29.3

# Run with a custom name
docker run -d --name WebServer nginx:1.29.3

# Run and map ports (host:container)
docker run -d -p 8080:80 nginx:1.29.3

# Run and automatically remove container when it stops
docker run --rm nginx:1.29.3

# Run with environment variables
docker run -d -e POSTGRES_PASSWORD=password postgres:18.1

# Run with volume mounting
docker run -d -v my-data:/var/lib/postgresql/data postgres:18.1
```

**Problem each option solves:**
- `-d`: Runs in the background so your terminal isn't blocked
- `--name`: Makes containers easy to reference instead of using random IDs
- `-p`: Allows you to access containerized applications from your host machine
- `--rm`: Keeps your system clean by auto-removing temporary containers
- `-e`: Configures applications without modifying images
- `-v`: Persists data beyond the container's lifetime

**Real example:**
```bash
# Run a PostgreSQL database for development
docker run -d \
  --name MyDatabase \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=myapp \
  -p 5430:5432 \
  -v pgdata:/var/lib/postgresql/data \
  postgres:18.1

# Now your application can connect to localhost:5430
```


### Listing Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List only container IDs
docker ps -q
```


### Starting and Stopping Containers

```bash
# Stop a running container
docker stop WebServer

# Stop with a timeout (seconds)
docker stop -t 30 WebServer

# Force stop a container
docker kill WebServer

# Start a stopped container
docker start WebServer

# Restart a container
docker restart WebServer

# Pause a container (freezes all processes)
docker pause WebServer

# Unpause a container
docker unpause WebServer
```


### Removing Containers

```bash
# Remove a stopped container
docker rm WebServer

# Force remove a running container
docker rm -f WebServer

# Remove multiple containers
docker rm container1 container2 container3
```


### Viewing Container Logs

```bash
# View all logs
docker logs WebServer

# Follow logs in real-time
docker logs -f WebServer

# View last 20 lines
docker logs --tail 20 WebServer

# View logs with timestamps
docker logs -t WebServer

# View logs since a specific time
docker logs --since 2024-01-01T10:00:00 WebServer
```

> You can easily debug issues by seeing what's happening inside your containers. It is essential for troubleshooting production problems.


### Executing Commands in Running Containers

```bash
# Execute a command in a running container
docker exec WebServer ls /usr/share/nginx/html

# Open an interactive shell
docker exec -it my-web-server /bin/sh

# Run a command as a specific user
docker exec -u postgres MyDatabase psql -U postgres
```


### Copying Files

```bash
# from host to container
docker cp filename.txt my-container:/app/file.txt

# from container to host
docker cp my-container:/app/logs/app.log ./logs/

# Copy entire directory
docker cp my-container:/app/data ./backup/
```


### Inspecting Containers

```bash
# View detailed container information
docker inspect my-container

# View container resource usage
docker stats my-container

# View real-time stats for all running containers
docker stats
```

---
<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***

</div>
