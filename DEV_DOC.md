# Developer documentation

## Prerequisites

Install the following on the host:

- Docker Engine;
- the Docker Compose plugin (`docker compose`);
- GNU Make;
- a user allowed to run Docker commands (or use `sudo` for Docker commands).

The project is intended to run on a Linux host. The images are based on `debian:bookworm`.

## Repository configuration

The Compose project is defined in `srcs/docker-compose.yml`. Before starting the stack, review these files:

- `srcs/.env` contains non-secret values:
  - `DOMAIN_NAME`, used as the site URL;
  - `MYSQL_DATABASE`, used as the WordPress database name.
- `secrets/credentials.txt` contains the credentials read by the initialization scripts. Its entries use the `NAME:VALUE` format: `DB_USER`, `DB_PASSWORD`, `WP_ROOT`, `WP_ROOT_EMAIL`, `WP_ROOT_PASSWORD`, `WP_USER`, `WP_USER_EMAIL`, and `WP_USER_PASSWORD`.

Do not put passwords in `srcs/.env` or Dockerfiles. Keep the credentials file out of version control when using real credentials, and restrict its permissions, for example:

```sh
chmod 600 secrets/credentials.txt
```

The Nginx configuration currently uses the hostname `cecompte.42.fr`; keep it consistent with `DOMAIN_NAME` and make the hostname resolve to the Docker host when testing locally.

## Build and launch

From the repository root, the standard build and launch command is:

```sh
make
```

The `all` target creates `~/data/wordpress` and `~/data/mariadb`, rebuilds all images without using the build cache, and starts the services with forced container recreation.

To run the equivalent Compose operation manually:

```sh
mkdir -p ~/data/wordpress ~/data/mariadb
docker compose -f srcs/docker-compose.yml build --no-cache
docker compose -f srcs/docker-compose.yml up -d --force-recreate
```

The three services are:

- `nginx`, which publishes host port `443` and serves HTTPS;
- `wordpress`, which exposes PHP-FPM only to the internal `inception` bridge network;
- `mariadb`, which exposes MariaDB only to the internal network.

## Container management

Show service status:

```sh
docker compose -f srcs/docker-compose.yml ps
```

Follow logs for one service or all services:

```sh
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```

Stop and remove the Compose containers and network while preserving named volume data:

```sh
make down
```

Start the services again without rebuilding images:

```sh
make up
```

The `down` target removes the Compose containers and network but does not remove the named volumes or their host-backed data. The `up` target recreates the services in detached mode using the existing images and persistent data.

Open a shell in a running container when debugging:

```sh
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

The Makefile also provides these maintenance targets:

- `make clean` stops and removes all Docker containers, images, volumes, and custom networks visible to the Docker daemon. This is destructive beyond this Compose project.
- `make volume` removes the host data directories.
- `make fclean` runs both `clean` and `volume`.
- `make re` runs `fclean` and then rebuilds the project.

Use the broad Makefile cleanup targets only when a full reset is intended.

## Data persistence

The Compose file defines two named volumes backed by host directories:

| Volume | Container path | Host path |
| --- | --- | --- |
| `wp-data` | `/var/www/html` | `/home/cecompte/data/wordpress` |
| `db-data` | `/var/lib/mysql` | `/home/cecompte/data/mariadb` |

These directories contain the WordPress files and MariaDB database, respectively. They survive container recreation and `docker compose down`. The Compose file uses the absolute `/home/cecompte/data/...` paths, so the Docker host user/path must match this configuration. If the project is moved to another account or host, update both the host directories created by the Makefile and the `device` paths in `srcs/docker-compose.yml`.

The `credentials` Compose secret is sourced from `secrets/credentials.txt` and mounted at `/run/secrets/credentials` in the MariaDB and WordPress containers. It is not stored in the images.