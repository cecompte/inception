NAME	:= Inception
YML		:= srcs/docker-compose.yml

all: $(NAME)

$(NAME):
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/mariadb
	docker compose -f $(YML) build --no-cache
	docker compose -f $(YML) up -d --force-recreate

clean:
	- docker container stop $$(docker container ps -aq)
	- docker container rm $$(docker container ps -aq)
	- docker image rm -f $$(docker image ls -aq)
	- docker volume rm $$(docker volume ls -q)
	- docker network rm $(shell docker network ls --filter type=custom -q)

volume:
	sudo rm -rf ~/data/wordpress
	sudo rm -rf ~/data/mariadb
	sudo rm -rf ~/data/

fclean: clean volume

re: fclean all
