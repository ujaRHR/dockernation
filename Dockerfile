# Use specific Node.js version
FROM node:24.11-alpine

# Set metadata
LABEL maintainer="hello@rhraju.com"
LABEL version="0.1"

# Install system dependencies
RUN apk add --no-cache curl

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application code
COPY . .

# Expose application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node healthcheck.js || exit 1

# Start application
CMD ["node", "server.js"]
