<div align="center">

## 📑 Volumes and Data Persistence
Docker containers are temporary by default, so anything stored inside them can disappear. This part explains how volumes solve that problem and keep your data intact.

</div>

---

#### ✳️ The Problem Volumes Solve

#### Without volumes:
```bash
# Start database, insert data
docker run --name db postgres:18.1
# ...add data to database...

# Stop and remove container
docker stop db
docker rm db

# Start new database container
docker run --name db postgres:18.1

# All previous data is GONE! (sad...)
```

#### With volumes:
```bash
# Start database with volume
docker run --name db -v pgdata:/var/lib/postgresql/data postgres:18.1
# ...add data to database...

# Stop and remove container
docker stop db
docker rm db

# Start new database container with same volume
docker run --name db -v pgdata:/var/lib/postgresql/data postgres:18.1

# All previous data is still there...!
```

### ✳️ Volume Types

#### 🚥 Named Volumes

```bash
# Create named volume
docker volume create my-data

# Use named volume
docker run -v my-data:/app/data myapp

# Docker manages where the data is stored
# Usually: /var/lib/docker/volumes/my-data/_data
```

- Persistent storage managed by Docker. That's why it's easy to backup, move, and share between containers.
- When to use: Database storage, uploaded files, application state.

#### 🚥 Bind Mounts

```bash
# Mount host directory into container
docker run -v /host/path:/container/path myapp

# Example: mount current directory
docker run -v $(pwd):/app myapp

# Read-only mount
docker run -v $(pwd):/app:ro myapp
```

- Use specific directories from your host machine. Great for development when you want live code reloading.

#### 🚥 Anonymous Volumes

```bash
# Docker creates and manages automatically
docker run -v /app/data myapp

# Or in Dockerfile
VOLUME /app/data
```

- Simple data persistence when you don't need to reference the volume by name.


### ✳️ Volume Commands

```bash
# List volumes
docker volume ls

# Create volume
docker volume create my-data

# Inspect volume (see where data is stored)
docker volume inspect my-data

# Remove volume
docker volume rm my-data

# Remove all unused volumes
docker volume prune

# Remove all volumes (DANGEROUS!)
docker volume rm $(docker volume ls -q)
```

### ✳️ Real-World Examples

#### 🚥 Example 1: Database with Persistent Storage

```bash
# Create volume for PostgreSQL data
docker volume create postgres-data

# Run PostgreSQL with persistent storage
docker run -d \
  --name mydb \
  -e POSTGRES_PASSWORD=secret \
  -v postgres-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:18.1

# Data persists even if container is deleted
docker rm -f mydb

# Start new container with same data
docker run -d \
  --name mydb-new \
  -e POSTGRES_PASSWORD=secret \
  -v postgres-data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:18.1
  
# All your data is still there!
```

#### 🚥 Example 2: Development with Live Reloading

```bash
# Mount source code for live reloading
docker run -d \
  --name dev-app \
  -v $(pwd)/src:/app/src \
  -v /app/node_modules \
  -p 3000:3000 \
  myapp

# Now when you edit files in ./src on your host,
# changes are immediately reflected in the container
```


### ✳️  Volume Backup and Restore

#### 🚥 Backup a volume:
```bash
# Create backup of volume
docker run --rm \
  -v my-data:/data \
  -v $(pwd):/backup \
  alpine tar czf /backup/my-data-backup.tar.gz -C /data .
```
- This creates my-data-backup.tar.gz in current directory

#### 🚥 Restore a volume:
```bash
# Create new volume
docker volume create my-data-restored

# Restore backup to volume
docker run --rm \
  -v my-data-restored:/data \
  -v $(pwd):/backup \
  alpine tar xzf /backup/my-data-backup.tar.gz -C /data

# Use restored volume
docker run -v my-data-restored:/app/data myapp
```

---
<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***
</div>
