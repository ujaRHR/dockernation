<div align="center">

## 📑 Docker Best Practices
As you get more comfortable with Docker, a few best practices can save you time and prevent headaches.
</div>

### ✳️  Security Best Practices

#### 🚥 Run as Non-Root User
- Running as root is a security risk. If an attacker compromises your app, they have root access to the container.

```dockerfile
# Bad - runs as root (default)
FROM node:24
WORKDIR /app
COPY . .
CMD ["node", "server.js"]

# Good - runs as non-root
FROM node:18
RUN groupadd -r appuser && useradd -r -g appuser appuser
WORKDIR /app
COPY --chown=appuser:appuser . .
USER appuser
CMD ["node", "server.js"]
```

#### 🚥 Use Specific Image Versions

- "latest" tag moves over time. Your builds become unpredictable and might break.

```dockerfile
# Bad - version can change
FROM node:latest

# Good - pinned version
FROM node:24-alpine3.18
```

#### 🚥 Scan Images for Vulnerabilities

```bash
# Using Docker Scout
docker scout cves myapp:latest

# Using Trivy
trivy image myapp:latest

# Fail build if critical vulnerabilities found
trivy image --exit-code 1 --severity CRITICAL myapp:latest
```

#### 🚥 Don't Include Secrets in Images

- Anyone with access to the image can extract secrets from layers.

```dockerfile
# Bad - secret in image
FROM node:24
ENV API_KEY=secret123
COPY . .

# Good - secret from environment
FROM node:24-alpine3.18
COPY . .
# API_KEY passed at runtime via: docker run -e API_KEY=secret123
```

#### 🚥 Use .dockerignore

- Prevents sensitive files and unnecessary data from being copied into images.
- Check the example [.dockerignore](.dockerignore) file


### ✳️ Image Optimization

#### 🚥 Use Multi-Stage Builds

```dockerfile
FROM node:24 AS builder
WORKDIR /app
COPY . .
RUN npm run build

FROM node:24-alpine
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

- Benefits: Smaller images, faster downloads, reduced attack surface.

#### 🚥 Minimize Layers

```dockerfile
# Bad - many layers
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get clean

# Good - fewer layers
RUN apt-get update && \
    apt-get install -y curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

- Each RUN creates a layer. Fewer layers mean smaller images and better caching.

#### 🚥 Order Instructions for Better Caching

```dockerfile
# Bad - source changes invalidate dependency cache
COPY . .
RUN npm install

# Good - dependencies cached separately
COPY package*.json ./
RUN npm install
COPY . .
```

- Docker caches each layer. Changing source code shouldn't rebuild dependencies.

#### 🚥 Use Alpine Images

```dockerfile
# Standard image: 350MB
FROM node:24

# Alpine image: 110MB
FROM node:24-alpine
```

- Alpine Linux is minimal, resulting in much smaller images.
- Some packages may not work on Alpine (uses musl instead of glibc).

### ✳️  Development Best Practices

#### 🚥 Use Docker Compose for Local Development

- One command (`docker compose up`) starts your entire development environment.
- Check the example [docker-compose.yml](docker-compose.yml) file

#### 🚥 Use Health Checks

- Docker can detect if your application is actually working, not just running.

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD curl -f http://localhost:3000/health || exit 1
```

#### 🚥 Tag Images Meaningfully

```bash
# Bad
docker build -t myapp .

# Good
docker build -t myapp:1.2.3 .
docker build -t myapp:1.2.3-alpine .
docker build -t myregistry.com/myapp:1.2.3 .
```

---
<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***
</div>
