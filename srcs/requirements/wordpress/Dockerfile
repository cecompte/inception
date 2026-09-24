FROM debian:bookworm

# Install php-fpm and utilities 9curl, sudo)
RUN apt-get update && \
    apt-get upgrade -y && \
	apt-get install -y \
	php8.2-cli \
	php8.2-fpm \
	php8.2-mysql \
	mariadb-client \
	curl \
	sudo

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Download wordpress
RUN mkdir -p /usr/src/wordpress && \
	wp core download --path=/usr/src/wordpress

# Copy in the initialization script
COPY tools/conf-wp.sh /usr/local/bin/conf-wp.sh
RUN chmod +x /usr/local/bin/conf-wp.sh

CMD ["conf-wp.sh"]
