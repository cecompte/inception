*This project has been created as part of the 42 curriculum by cecompte.*

# Description
This project is a system administration project, aiming to introduce students to Docker. The goal is to set-up a small infrastructure composed of different services : nginx, mariadb and wordpress. The project is done on a virtual machine.

# Instructions
To build and run Docker images, use command `make`.

# Project description

## Design requirements
The project has several design requirements, including:
1) Three-service web-hosting architecture : 
	- Nginx handles HTTPS, static files, and forwards PHP requests to Wordpress
	- WordPress generates the pages people see, running on PHP and PHP-FPM processes that PHP code
    - MariaDB stores the database.
	Nginx never talks to the database directly.
2) Custom images based on debian:bookworm
3) Nginx as the only public entry point with host port 443:443, MariaDB and Wordpress being accessible only through Docker's internal network
4) Docker bridge networking
5) Persistent data in two named volumes (corresponding to database and wordpress files), stored in /home/cecompte/data on the host machine
6) Secrets management for all credentials and passwords, environment variables when relevant
7) Automated initialisation through a Makefile and docker-compose. 

## Comparisons

### Virtual Machines vs Docker
Containers and virtual machines (VMs) enable multiple environments on one server. 
- Containers are lightweight and share the host OS kernel, only packaging the application and its dependencies, ideal for microservices architecture and rapid deployment. 
- VMs are more isolated with their own OS kernel, offering stronger isolation but using more resources. They run on top of hypervisors and include their own operating systems, applications, and dependencies. They are ideal for running legacy applications, for running apps on multiple operating systems and for handling security-critical workloads.

**=> In this project**, I chose to install a VM running on debian-13 (trixie) while Docker images are based on debian-12 (bookworm).

### Secrets vs Environment Variables
- **Environment variables** are key-value pairs used to configure applications. Instead of hard-coding values in the docker-compose.yml (such as database names and URLs), they can be stored as variables and accessed from the code, making the configuration clean and reusable. But they embed credentials into image layers where they persist indefinitely, so anyone with image access can extract them.
- **Docker secrets** are encrypted credentials that Docker mounts into containers at runtime without persisting them in image layers. They are restricting access to only the containers that need them, and mounting secrets on a memory-backed filesystem (tmpfs) that disappears when the container stops. They only work in Swarm mode and Compose. 
  
**=> In this project**, I stored two env variables (domain name and database name) in a .env file in /srcs/ and used Docker secrets for all credentials and sensitive information (user names, emails and passwords).

### Bridge Network vs Host Network
- A Docker bridge network is a private internal network that allows containers on the same host to communicate. Each container gets a private internal IP, and Docker handles NAT (network address translation) to route traffic between the container and the outside world. The key point: bridge networking creates an isolated network namespace. The container cannot see the host's network interfaces directly, and the host cannot reach the container without explicit port mappings.
- A host network is not isolated from the Docker host, and the containers share the machine's network stack (IP address, ports). Two containers cannot choose the same port.

**=> In this project**, I configured a custom bridge network called "inception", which allows containers to access each other by name (instead of IP address). Only port 443:443 (nginx) can be accessed from outside (published in docker-compose).

### Docker Volumes vs Bind Mounts
Both are mechanisms for data persistence:
- Docker named volumes are completely managed by Docker and stored in a part of the host filesystem managed by Docker (/var/lib/docker/volumes). They are independent of the host machine's directory structure and can be shared between containers
- Bind mounts allow to mount a file or directory from the host machine into a container. It is referenced by its absolute path on the host machine.

**=> In this project**, I needed to use named volumes (db_data and wp_data), and store the data into /home/cecompte/data on the host machine rather than the default Docker location. Directories are created by the Makefile. 

# Resources

## Documentation

### Docker

#### General
- VMs vs Docker : https://www.datacamp.com/blog/containers-vs-virtual-machines
  
#### Dockerfiles
- Writing a dockerfile: https://dev.to/prodevopsguytech/writing-a-dockerfile-beginners-to-advanced-31ie 
- PID 1: https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/

#### Docker compose
- Docker compose: https://www.geeksforgeeks.org/devops/docker-compose/ 
- Secrets management: https://docs.docker.com/compose/how-tos/use-secrets/
- Volumes: https://www.datacamp.com/tutorial/docker-mount 

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
I used AI to make some concepts more understandable than what I could find in the online docs: some examples include:
- TLS handshake
- Connection to the mariadb server and mysqld_safe
- Ceep-dive into configuration files for mariadb, nginx and wordpress
- Basics of Wordpress and PHP-FPM
- Docker networking