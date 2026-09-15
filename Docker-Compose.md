<div align="center">

## 📑 Docker Compose
Docker Compose is a tool for defining and running multi-container applications. You define your application's services in a YAML file, then start everything with a single command.

</div>

---

### 📂 The Problem Docker Compose Solves

#### Without Docker Compose:
```bash
# Start database
docker run -d --name db -e POSTGRES_PASSWORD=password postgres:18.1

# Wait for database to be ready
sleep 5

# Start cache
docker run -d --name cache redis:8.2

# Start application with correct network and environment
docker run -d --name app --link db --link cache \
  -e DB_HOST=db -e REDIS_HOST=cache -p 3000:3000 myapp
```

#### With Docker Compose:
```bash
docker compose up
```

Just one command starts everything with proper configuration, networking, and dependencies.

### 📂 Structure: docker-compose.yml

```yaml
version: '3.8'

services:
  # Web application service
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=development
      - DB_HOST=database
    depends_on:
      - database
    volumes:
      - .:/app
      - /app/node_modules
  
  # Database service
  database:
    image: postgres:18.1
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=myapp
    volumes:
      - pgdata:/var/lib/postgresql/data
    ports:
      - "5432:5432"

volumes:
  pgdata:
```

### 📂 Service Configuration

#### 🚥 build - Build from Dockerfile
- Build custom images as part of your compose setup without separate build commands.

```yaml
services:
  app:
    # Build from Dockerfile in current directory
    build: .
    
  app2:
    # Build with context and specific Dockerfile
    build:
      context: ./app
      dockerfile: Dockerfile.dev
      args:
        - NODE_VERSION=22
```


#### 🚥 image - Use Pre-built Image

```yaml
services:
  database:
    image: postgres:18.1
  
  cache:
    image: redis:-alpine
```


#### 🚥 ports - Port Mapping

```yaml
services:
  app:
    ports:
      - "3000:3000"        # host:container
      - "8080:80"          # different ports
      - "127.0.0.1:5000:5000"  # bind to specific interface
```

#### 🚥 environment - Environment Variables

```yaml
services:
  app:
    environment:
      - NODE_ENV=development
      - API_KEY=secret12345
      - DEBUG=true
    
  # Or use environment file
  app2:
    env_file:
      - .env
      - .env.local
```


#### 🚥 volumes - Data Persistence

- Persist data beyond container lifecycle and enable live code reloading during development.

```yaml
services:
  database:
    volumes:
      # Named volume (managed by Docker)
      - pgdata:/var/lib/postgresql/data
  
  app:
    volumes:
      # Bind mount (use host directory)
      - ./src:/app/src
      # Anonymous volume (for node_modules)
      - /app/node_modules

volumes:
  pgdata:
```


#### 🚥 depends_on - Service Dependencies

```yaml
services:
  app:
    depends_on:
      - database
      - cache
  
  # With health checks
  app2:
    depends_on:
      database:
        condition: service_healthy
  
  database:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```


#### 🚥 networks - Custom Networks

- Isolate services and control which services can communicate with each other.

```yaml
services:
  frontend:
    networks:
      - frontend-network
  
  backend:
    networks:
      - frontend-network
      - backend-network
  
  database:
    networks:
      - backend-network

networks:
  frontend-network:
  backend-network:
```


#### 🚥 restart - Restart Policy

- Ensure services automatically recover from crashes or after system reboots.

```yaml
services:
  app:
    restart: always
  
  worker:
    restart: unless-stopped  # Restart unless manually stopped
  
  debug:
    restart: "no"  # default
  
  batch:
    restart: on-failure
```

### 📂 Docker Compose Commands

```bash
# Start all services
docker compose up

# Start in detached mode (background)
docker compose up -d

# Start specific services
docker compose up app database

# Build or rebuild services
docker compose build

# Build without cache
docker compose build --no-cache

# View running services
docker compose ps

# View logs
docker compose logs

# Follow logs
docker compose logs -f

# Logs for specific service
docker compose logs -f app

# Stop services
docker compose stop

# Stop and remove containers
docker compose down

# Stop, remove containers, and remove volumes
docker compose down -v

# Execute command in running service
docker compose exec app /bin/sh

# Run one-off command
docker compose run app npm test

# Scale services
docker compose up -d --scale worker=3

# View resource usage
docker compose top
```

** **Check the complete [docker-compose.yml](docker-compose.yml) example file**

#### 🚥 Start the entire stack:
```bash
docker compose up -d
```

> Access services:
> - Frontend: localhost:3000
> - Backend API: localhost:8000
> - Database: localhost:5432
> - Redis: localhost:6379



### 📂 Development vs Production Compose Files

You can have multiple compose files for different environments (production, development, testing...):

##### 🚥 Usage:

```bash
# Development
docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# Production
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Testing
docker compose -f docker-compose.yml -f docker-compose.test.yml up -d
```

---

### 📂 Browse Other Concepts:

[Introduction](README.md) | [Basic Commands](Basic-Commands.md) | [Containers](Containers.md) | [Docker Compose](Docker-Compose.md) | [Dockerfile](Dockerfile-Guide.md) | [Networking](Networking.md) | [Volumes](Volumes-Data.md) | [Best Practice](Best-Practices.md)

---

**Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)**