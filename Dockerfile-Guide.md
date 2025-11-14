<div align="center">

## 📑 Dockerfile Guide
A Dockerfile is a script that contains instructions for building a Docker image. Each instruction creates a layer in the image.
</div>

#### Basic Dockerfile Structure

```dockerfile
FROM node:24.11

WORKDIR /app

COPY package.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
```


#### 🚥 FROM node:24.11

- Specifies the base image to build upon.
- You don't have to set up the operating system and runtime from scratch.

```dockerfile
# Use official Node.js image
FROM node:24.11

# Use specific version with Alpine (smaller)
FROM node:24.11-alpine

# Use Ubuntu base
FROM ubuntu:22.04
```

> Use specific version tags, not "latest", for reproducibility.


#### 🚥 WORKDIR /app

- Sets the working directory for subsequent instructions. It means when you run a container from that image, there will a `/app` folder
- Organizes your files and ensures commands run in the correct directory
- All subsequent commands run inside `/app`
- If /app doesn't exist, it's created automatically



#### 🚥 COPY package.json ./

- Copies files from your host machine into the image.
- Gets your application code and assets into the container.

```dockerfile
# Copy multiple files
COPY package.json package-lock.json ./

# Copy entire directory
COPY src/ ./src/

# Copy everything
COPY . .
```

> **Best Practice:** Copy dependency files first, then install, then copy source code. This optimizes layer caching.


#### 🚥 RUN npm install

- Executes commands during image build.
- Running a command during image build can be used to install software, runs build scripts, and sets up the environment.

```dockerfile
# Install packages
RUN apt update && apt-get install -y curl git nano

# Run build process
RUN npm run build

# Multiple commands in one layer (more efficient)
RUN apt-get update && \
    apt-get install -y python3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

> **Best Practice:** Chain commands with && to reduce layers and clean up in the same layer.


#### 🚥 EXPOSE 3000

- Documents which ports the container listens on.
- EXPOSE doesn't actually publish the port. You still need -p when running

```dockerfile
# Document that the app uses port 3000
EXPOSE 3000

# Multiple ports
EXPOSE 3000 8080
```


#### 🚥 CMD ["node", "server.js"]

- Specifies the default command to run when a container starts.
- Defines what your container does by default. This is the last command before starting your application.

```dockerfile
# Exec form (preferred)
CMD ["node", "server.js"]

# Shell form
CMD node server.js

# multiple parameters (comma-separated)
CMD ["node", "--env-file=.env", "server.js"]
```


#### 🚥 ENV - Environment Variables

- Sets environment variables in the image.
- Configures application behavior without changing code.

```dockerfile
# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Multiple variables
ENV NODE_ENV=production \
    PORT=3000 \
    API_URL=https://api.rhraju.com
```

#### 🚥 ARG - Build Arguments

- Defines build-time variables.
- Customization during build without changing the Dockerfile.

```dockerfile
# Define argument with default value
ARG NODE_VERSION=24.11

# Use argument
FROM node:${NODE_VERSION}

ARG APP_ENV=development
ENV APP_ENV=${APP_ENV}
```

**Build with custom argument:**
```bash
docker build --build-arg NODE_VERSION=20 -t MyApp ./

docker build --build-arg APP_ENV=production -t MyApp:prod ./
```


#### 🚥 VOLUME - Define Mount Points

- Creates a mount point for external storage.
- Marks directories that should persist data.

```dockerfile
# Create volume mount point
VOLUME /app/data

# Multiple volumes
VOLUME ["/app/data", "/app/logs"]
```

**Usage:**
```bash
# Anonymous volume (Docker manages it)
docker run myapp

# Named volume
docker run -v mydata:/app/data MyApp

# Bind mount (use host directory)
docker run -v /host/path:/app/data MyApp
```


#### 🚥 HEALTHCHECK - Container Health

- Tells Docker how to test if the container is healthy.
- Enables Docker to detect if your application is actually working, not just running.

```dockerfile
# Check if the web server responds
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:3000/health || exit 1
```

**Options:**
- `--interval`: How often to check (default: 30s)
- `--timeout`: Time to wait for response (default: 30s)
- `--start-period`: Grace period before checking (default: 0s)
- `--retries`: Failures needed to mark unhealthy (default: 3)



** **Check the [Dockerfile](Dockerfile) for complete example**


#### .dockerignore File

- Just like the .gitignore file
- Specifies files and directories to exclude from the build context.
- Reduces build time and image size by not copying unnecessary files.

**Check the [.dockerignore](.dockerignore) for example**

---
<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***

</div>
