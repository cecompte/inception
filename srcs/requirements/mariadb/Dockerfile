FROM debian:bookworm

RUN apt-get update
RUN apt-get install -y mariadb-server

# #Copy in a config file
# COPY conf/my.cnf /etc/mysql/my.cnf

#Copy in the initialization script
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

EXPOSE 3306

CMD ["init-db.sh"]