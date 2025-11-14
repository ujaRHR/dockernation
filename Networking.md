<div align="center">

## 📑 Networking

Networking is what lets containers talk to each other and to the outside world. This section shows you the simple concepts you need to set up clean, reliable connections.
</div>

---

### ✳️ The Problem Docker Networking Solves

#### Before Docker networking:
- Containers couldn't easily communicate with each other
- Complex manual network configuration required
- Services needed to know exact IP addresses
- No isolation between different applications

#### After Docker networking:
- Containers can communicate using service names
- Automatic DNS resolution between containers
- Network isolation between applications
- Easy service discovery

### ✳️ Network Types

#### Bridge Network (Default)

```bash
# Create a custom bridge network
docker network create my-network

# Run containers on the network
docker run -d --name app --network my-network myapp
docker run -d --name db --network my-network postgres:18.1
```
Containers on the same bridge network can communicate using container names as hostnames.

#### Host Network

```bash
# Run container with host networking
docker run -d --network host nginx:latest
```

- Container uses the host's network directly. No isolation, but maximum performance.
- Performance-critical applications or when you need to bind to specific host network interfaces.
- Less isolation and portability.

#### None Network

```bash
# Run container with no networking
docker run -d --network none myapp
```
- Complete network isolation. Container has no network access.
- Security-sensitive processing of local data.

### ✳️ Network Commands

```bash
# List networks
docker network ls

# Create network
docker network create my-network

# Create network with custom subnet
docker network create --subnet=172.18.0.0/16 my-network

# Inspect network
docker network inspect my-network

# Connect running container to network
docker network connect my-network my-container

# Disconnect container from network
docker network disconnect my-network my-container

# Remove network
docker network rm my-network

# Remove unused networks
docker network prune
```

### ✳️ Container Communication Examples

#### 🚥 Example 1: Web app connecting to database

```bash
# Create network
docker network create app-network

# Start database
docker run -d \
  --name database \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:18.1

# Start application
docker run -d \
  --name app \
  --network app-network \
  -e DB_HOST=database \
  -e DB_PORT=5432 \
  -p 3000:3000 \
  myapp

# The app connects to database using:
# postgresql://database:5432/mydb
# "database" resolves to the database container's IP
```

#### 🚥 Example 2: Multi-network isolation

```yaml
# docker-compose.yml
version: '3.8'

services:
  frontend:
    image: myapp-frontend
    networks:
      - frontend-net
    ports:
      - "3000:3000"
  
  backend:
    image: myapp-backend
    networks:
      - frontend-net
      - backend-net
  
  database:
    image: postgres:18.1
    networks:
      - backend-net
    environment:
      - POSTGRES_PASSWORD=password

networks:
  frontend-net:
  backend-net:
```

#### Network topology:
- Frontend can talk to Backend (both on frontend-net)
- Backend can talk to Database (both on backend-net)
- Frontend CANNOT talk to Database directly (no shared network)


### ✳️ DNS Resolution

Docker provides automatic DNS resolution for container names:

```bash
# In a container on the same network, you can:
curl http://api:3000/users

ping database
# Works! DNS resolves "database" to the container's IP
```

### ✳️ Port Publishing

```bash
# Publish to specific host port
docker run -p 8080:80 nginx

# Publish to random host port
docker run -P nginx

# Publish to specific interface
docker run -p 127.0.0.1:8080:80 nginx

# Publish multiple ports
docker run -p 8080:80 -p 8443:443 nginx
```

#### Port mapping
- `-p 8080:80` means: Host port 8080 → Container port 80
- Traffic to localhost:8080 is forwarded to port 80 inside the container


### ✳️ Network Aliases

```bash
# Container can be reached by multiple names
docker run -d \
  --network my-network \
  --network-alias api \
  --network-alias api-v2 \
  --name api-container \
  myapi
```

Now other containers can reach this container using:
- `api-container` (container name)
- `api` (alias)
- `api-v2` (alias)

---
<div align="center">

***Maintained with ❤️ by [Reajul Hasan Raju](https://github.com/ujaRHR)***
</div>
