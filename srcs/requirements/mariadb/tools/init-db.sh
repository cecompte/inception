#!/bin/sh

# exits immediately when a command fails
set -e

#starts mariadb server in the background (without network connections)
mysqld_safe --skip-networking &
mysql_pid=$!

#waits until mariadb is ready (server accepts connections)
until mysqladmin ping --silent; do
    sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'$DOMAIN_NAME' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$DOMAIN_NAME';
FLUSH PRIVILEGES;
EOF

# shuts down temporary server
mysqladmin -u root shutdown
wait "$mysql_pid"

exec mysqld_safe