# Docker commands

docker build -t img-name .
docker run -d --name container-name img-name
docker exec -it container-name bash

# mariadb tests

docker build -t mariadb-img .
docker run -d --name mariadb \
-e MYSQL_DATABASE=testdb \
-e MYSQL_USER=testuser \
-e MYSQL_PASSWORD=testpassword \
-e DOMAIN_NAME=localhost \
mariadb-img
docker exec -it mariadb bash
mariadb -u root -e "SHOW DATABASES"
mariadb -u root -e "SELECT User, Host FROM mysql.user;"


# Resources 
## nginx 
- config file with ssl/tls: https://oneuptime.com/blog/post/2026-02-20-nginx-ssl-tls-configuration/view
- nginx config file with php: https://www.servermania.com/kb/articles/setup-php-on-nginx-with-fastcgi

## wordpress
- wordpress installation using wp-cli : https://www.akamai.com/cloud/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/ 


