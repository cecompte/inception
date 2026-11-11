FROM debian:bookworm

# Install nginx and openssl (for cert generation)
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl

# Create a directory for the cert/key
RUN mkdir -p /etc/nginx/certs

# Generate a self-signed cert + private key at build time
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx.key \
    -out /etc/nginx/certs/nginx.crt \
    -subj "/CN=localhost"

# Copy custom config over the default
COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Wait for WordPress to populate the shared document root before serving requests.
CMD ["sh", "-c", "until [ -f /var/www/html/index.php ]; do sleep 1; done; exec nginx -g 'daemon off;'"]