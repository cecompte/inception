#!/bin/sh

# exits immediately when a command fails
set -e

#starts mariadb server in the background (without network connections)
mysqld_safe --skip-networking &
mysql_pid=$!

#waits until mariadb accepts connections (up to 30s)
until mariadb-admin ping \
    --wait=30 \
    --silent
then
    echo "Failed connection to Mariadb" >&2
    exit 1
fi

#creates database and user
mariadb -u root << EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

# shuts down temporary server
mariadb-admin -u root shutdown
wait "$mysql_pid"

# runs mysqld_safe as PID 1
exec mysqld_safe