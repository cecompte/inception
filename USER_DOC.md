# User documentation

## What this stack provides

This project runs a small WordPress website with three services:

- **Nginx** is the public entry point. It serves the site over HTTPS and forwards PHP requests to WordPress.
- **WordPress** generates the website and provides its administration interface.
- **MariaDB** stores the WordPress database. It is internal to the Docker network and is not exposed directly to the host.

Only Nginx is published outside Docker, on HTTPS port `443`.

## Start the project

From the project directory, run:

```sh
make
```

The first start builds the images, creates the persistent data directories, and starts all services in the background. The WordPress installation is created automatically on the first start.

To stop the services without deleting their data:

```sh
make down
```

Start them again with:

```sh
make up
```

## Access the website

Open:

```text
https://cecompte.42.fr
```

The project uses a self-signed development certificate, so the browser may display a certificate warning. This is expected for this local deployment. The hostname must resolve to the machine running Docker; on a local machine, add an appropriate entry for `cecompte.42.fr` to `/etc/hosts` if DNS does not already provide it.

The WordPress administration panel is:

```text
https://cecompte.42.fr/wp-admin
```

## Credentials

Credentials are kept in `secrets/credentials.txt` and mounted into the MariaDB and WordPress containers at runtime. The file contains:

- the MariaDB application username and password;
- the WordPress administrator username, email, and password;
- the regular WordPress user username, email, and password.

Read this file from the project directory when you need the WordPress login details:

```sh
cat secrets/credentials.txt
```

Keep this file private and do not commit real production credentials. The database name and site hostname are non-secret configuration values in `srcs/.env`.

## Check that the services are working

List the container status:

```sh
docker compose -f srcs/docker-compose.yml ps
```

All three containers (`nginx`, `wordpress`, and `mariadb`) should be running. Check recent output if a service is not healthy or the site does not load:

```sh
docker compose -f srcs/docker-compose.yml logs --tail=100 nginx
docker compose -f srcs/docker-compose.yml logs --tail=100 wordpress
docker compose -f srcs/docker-compose.yml logs --tail=100 mariadb
```

Verify that Nginx is listening on HTTPS:

```sh
curl -kI https://cecompte.42.fr
```

A successful response is an HTTP response from Nginx, commonly `200`, `301`, or `302`. The `-k` option is needed because the development certificate is self-signed.

## Data safety

Stopping containers does not remove the WordPress files or MariaDB database. Do not use `make clean`, `make volume`, or `make fclean` unless you intend to remove containers, images, networks, and/or persistent data.