#!/bin/sh
set -e

until mariadb-admin ping \
    -h "$WORDPRESS_DB_HOST" \
    -u "$WORDPRESS_DB_USER" \
    -p"$WORDPRESS_DB_PASSWORD" \
    --silent
do
    sleep 1
done

# make sure wp files exist, if not copy from usr/src/wordpress
if [ ! -f /var/www/html/wp-includes/version.php ]; then
    cp -a /usr/src/wordpress/. /var/www/html/
    chown -R www-data:www-data /var/www/html
fi

# create wp-config.php and install wordpress
if [ ! -f "/var/www/html/wp-config.php" ]; then
	sudo -u www-data wp core config \
        --path=/var/www/html \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --dbprefix="$WORDPRESS_TABLE_PREFIX"
	sudo -u www-data wp core install \
        --path=/var/www/html \
		--url="$DOMAIN_NAME" \
		--title="My WordPress" \
		--admin_user="$WORDPRESS_ADMIN_USER" \
		--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
		--admin_email="$WORDPRESS_ADMIN_EMAIL"
fi

exec php-fpm8.2 -F