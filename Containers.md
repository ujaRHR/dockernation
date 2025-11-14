<div align="center">

## 📑 Working with Containers
Containers are at the heart of Docker, and this section shows you how to work with them properly. You’ll learn how to create, manage, and interact with containers in a simple, clear way.

</div>

#### 🚥 Running Containers

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

##### Problem each option solves:
- `-d`: Runs in the background so your terminal isn't blocked
- `--name`: Makes containers easy to reference instead of using random IDs
- `-p`: Allows you to access containerized applications from your host machine
- `--rm`: Keeps your system clean by auto-removing temporary containers
- `-e`: Configures applications without modifying images
- `-v`: Persists data beyond the container's lifetime

##### Real example:
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


#### 🚥 Listing Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List only container IDs
docker ps -q
```


#### 🚥 Starting and Stopping Containers

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


#### 🚥 Removing Containers

```bash
# Remove a stopped container
docker rm WebServer

# Force remove a running container
docker rm -f WebServer

# Remove multiple containers
docker rm container1 container2 container3
```


#### 🚥 Viewing Container Logs

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


#### 🚥 Executing Commands in Running Containers

```bash
# Execute a command in a running container
docker exec WebServer ls /usr/share/nginx/html

# Open an interactive shell
docker exec -it my-web-server /bin/sh

# Run a command as a specific user
docker exec -u postgres MyDatabase psql -U postgres
```


#### 🚥 Copying Files

```bash
# from host to container
docker cp filename.txt my-container:/app/file.txt

# from container to host
docker cp my-container:/app/logs/app.log ./logs/

# Copy entire directory
docker cp my-container:/app/data ./backup/
```


#### 🚥 Inspecting Containers

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
