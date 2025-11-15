<div align="center">

##  Basic Commands
This section covers the core Docker commands you'll use every day. These basics help you manage images, containers, logs, and simple workflows with confidence.

</div>

#### 🚥 Checking Docker Status

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

#### 🚥 Hello World

```bash
docker run hello-world
```

What happens:
1. Docker looks for the hello-world image locally
2. If not found, it downloads it from Docker Hub
3. It creates a container from that image
4. It runs the container, which prints a message
5. The container exits


#### 🚥 Searching for Images

```bash
# Search Docker Hub for images
docker search nginx
docker search postgres
... ... ...
```
> This command finds existing images, so you don't have to build everything from scratch. Official images are maintained by the software creators and are generally trustworthy.


#### 🚥 Pulling Images

```bash
# Download an image from Docker Hub
docker pull nginx:1.29.3

# Pull the latest version
docker pull nginx:latest
```

> **Best Practice:** Always use specific version tags in production instead of "latest".


#### 🚥 Listing Images

```bash
# List all images on your system
docker images

# List images with more details
docker images --all

# Filter images by name
docker images nginx
```


#### 🚥 Building Images

```bash
# Build an image from a Dockerfile in the current directory
docker build -t myapp:1.0 .

# Build with a specific Dockerfile
docker build -t myapp:1.0 -f Dockerfile.prod .

# Build without using cache (fresh build)
docker build --no-cache -t myapp:1.0 .
```
> Create custom images for your applications. The -t flag tags the image with a name and version for easy reference.

Example:

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

#### 🚥 Removing Images

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


#### 🚥 Inspecting Images

```bash
# View detailed information about an image
docker inspect nginx:1.25

# View image layers and size
docker history nginx:1.25
```
> Try to understand what's inside an image, the networks, how it was built, and troubleshoot issues.


#### 🚥 Tagging Images

```bash
# Create a new tag for an existing image
docker tag myapp:1.0 myapp:latest

# Tag for pushing to a registry
docker tag myapp:1.0 username/myapp:1.0
```

> Create multiple references to the same image, making it easier to manage versions and prepare for pushing to registries.

---

### 📂 Browse Other Concepts:

[Introduction](README.md) | [Basic Commands](Basic-Commands.md) | [Containers](Containers.md) | [Docker Compose](Docker-Compose.md) | [Dockerfile](Dockerfile-Guide.md) | [Networking](Networking.md) | [Volumes](Volumes-Data.md) | [Best Practice](Best-Practices.md)

---

<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***
</div>
