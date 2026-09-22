FROM debian:bookworm

# Install nginx and openssl (for cert generation)
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for the cert/key
RUN mkdir -p /etc/nginx/certs

# Generate a self-signed cert + private key at build time
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx.key \
    -out /etc/nginx/certs/nginx.crt \
    -subj "/CN=localhost"

# Copy your custom config over the default
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Run nginx in the foreground (required for Docker containers)
CMD ["nginx", "-g", "daemon off;"]curl -k https://localhost:8443