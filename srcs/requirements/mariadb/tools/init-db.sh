#!/bin/sh

# exits immediately when a command fails
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

MYSQL_USER=$(get_credential db_user)

# load password file
if [ -z "${MYSQL_PASSWORD_FILE:-}" ] || [ ! -r "$MYSQL_PASSWORD_FILE" ]; then
    echo "MYSQL_PASSWORD_FILE is missing or unreadable" >&2
    exit 1
fi
MYSQL_PASSWORD=$(cat "$MYSQL_PASSWORD_FILE")

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