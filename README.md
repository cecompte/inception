*This project has been created as part of the 42 curriculum by cecompte.*

# Description
This project is a system administration project, aiming to introduce students to Docker. The goal is to set-up a small infrastructure composed of different services : nginx, mariadb and wordpress. The project is done on a virtual machine.

# Instructions
To build and run images, use command `make`

# Project description
The subject had several design requirements:
1) Three-service architecture : 
	- Nginx handles HTTPS, static files, and forwards PHP requests.
	- WordPress runs PHP-FPM and configures WordPress.
    - MariaDB stores the database.
2) Custom images based on debian:bookworm
3) Nginx as the only public entry point with host port 443:443, MariaDB and Wordpress being accessible only through Docker's internal network
4) Docker bridge networking
5) Persistent data in two volumes (corresponding to database and wordpress files), stored in /home/cecompte/data on the host machine
6) Secrets management for all credentials, environment variables when relevant

◦ Virtual Machines vs Docker
◦ Secrets vs Environment Variables
◦ Docker Network vs Host Network
◦ Docker Volumes vs Bind Mounts


# Resources

## Documentation

### Docker

#### Dockerfiles
- Writing a dockerfile: https://dev.to/prodevopsguytech/writing-a-dockerfile-beginners-to-advanced-31ie 
- PID 1: https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/

#### Docker compose
- Docker compose: https://www.geeksforgeeks.org/devops/docker-compose/ 
- Secrets management: https://docs.docker.com/compose/how-tos/use-secrets/

#### Docker networks
- Docker networking: https://www.sysdig.com/learn-cloud-native/what-is-docker-networking 
- Networking in compose: https://docs.docker.com/compose/how-tos/networking/ 

### Nginx 
- config file with ssl/tls: https://oneuptime.com/blog/post/2026-02-20-nginx-ssl-tls-configuration/view
- TLS handshake: https://www.youtube.com/watch?v=ZkL10eoG1PY 
- nginx config file with php: https://www.servermania.com/kb/articles/setup-php-on-nginx-with-fastcgi

### Mariadb
- mysqld_safe: https://dev.mysql.com/doc/refman/9.7/en/mysqld-safe.html
- mariadb-admin: https://man7.org/linux/man-pages/man1/mariadb-admin.1.html 
- create database: https://www.beekeeperstudio.io/blog/how-to-create-a-user-in-mariadb

### Wordpress
- wordpress installation using wp-cli: https://www.akamai.com/cloud/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/ 

## AI Usage
- TLS handshake
- Basics of wordpress and PHP-FPM
- conf files
