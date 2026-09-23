#!/bin/sh

# exits immediately when a command fails
set -e

service mysql start;

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'$DOMAIN_NAME' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'$DOMAIN_NAME';
FLUSH PRIVILEGES;
EOF

# shutdown and restart
mysqladmin -u root shutdown

#starts mysqld_safe
exec "$@"