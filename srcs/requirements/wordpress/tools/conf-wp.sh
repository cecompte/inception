#!/bin/sh
set -e

# load credentials file and parse values
if [ -z "${CREDENTIALS_FILE:-}" ] || [ ! -r "$CREDENTIALS_FILE" ]; then
    echo "CREDENTIALS_FILE is missing or unreadable" >&2
    exit 1
fi

get_credential() {
    value=$(awk -F: -v name="$1" \
        '$1 == name { print $2; exit }' \
        "$CREDENTIALS_FILE")
    printf '%s\n' "$value"
}

WORDPRESS_DB_USER=$(get_credential db_user)
WORDPRESS_ADMIN_USER=$(get_credential db_root_user)
WORDPRESS_ADMIN_EMAIL=$(get_credential db_root_email)

# load password files
if [ -z "${WORDPRESS_DB_PASSWORD_FILE:-}" ] || [ ! -r "$WORDPRESS_DB_PASSWORD_FILE" ]; then
    echo "WORDPRESS_DB_PASSWORD_FILE is missing or unreadable" >&2
    exit 1
fi
WORDPRESS_DB_PASSWORD=$(cat "$WORDPRESS_DB_PASSWORD_FILE")

if [ -z "${WORDPRESS_ADMIN_PASSWORD_FILE:-}" ] || [ ! -r "$WORDPRESS_ADMIN_PASSWORD_FILE" ]; then
    echo "WORDPRESS_ADMIN_PASSWORD_FILE is missing or unreadable" >&2
    exit 1
fi
WORDPRESS_ADMIN_PASSWORD=$(cat "$WORDPRESS_ADMIN_PASSWORD_FILE")


#wait until mariadb accepts connections (up to 30s)
until mariadb-admin ping \
    --wait=30 \
    --silent \
    -h "$WORDPRESS_DB_HOST" \
    -u "$WORDPRESS_DB_USER" \
    -p"$WORDPRESS_DB_PASSWORD"
then
    echo "Failed connection to Mariadb" >&2
    exit 1
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