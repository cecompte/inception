FROM debian:bookworm

# Install php-fpm
RUN apt-get update && \
    apt-get upgrade -y && \
	apt-get install -y php8.2-fpm php8.2-mysql mariadb-client

# Install wp-cli
RUN apt-get install -y curl && \
	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

# Install wordpress
RUN apt-get install -y sudo && \
	mkdir -p /var/www/html/example.com/public_html && \
	chown -R www-data:www-data /var/www/html/example.com/public_html && \
	chown www-data:www-data /var/www/html/example.com/public_html && \
	cd /var/www/html/example.com/public_html && \
	sudo -u www-data wp core download 

#Copy in the initialization script
COPY tools/config-wp.sh /usr/local/bin/init-wp.sh
RUN chmod +x /usr/local/bin/init-wp.sh

CMD ["init-wp.sh"]
