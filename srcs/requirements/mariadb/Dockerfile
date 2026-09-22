FROM debian:bookworm

RUN apt-get update && apt-get upgrade
RUN apt-get install -y mariadb-server

#Copy in a config file
COPY conf/my.cnf /etc/mysql/my.cnf

#Copy in the initialization script
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306

# LABEL version="1.0"
# LABEL description="MariaDB Server"

# HEALTHCHECK --start-period=5m \
#   CMD mariadb -e 'SELECT @@datadir;' || exit 1

ENTRYPOINT ["init-db.sh"]