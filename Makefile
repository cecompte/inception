NAME	:= Inception
YML		:= srcs/docker-compose.yml

all: $(NAME)

$(NAME):
	mkdir -p ~/data/wordpress
	mkdir -p ~/data/mariadb
	docker compose -f $(YML) up --build -d

clean:
	- docker container stop $$(docker container ps -aq)
	- docker container rm $$(docker container ps -aq)
	- docker image rm -f $$(docker image ls -aq)
	- docker volume rm $$(docker volume ls -q)
	- docker network rm $(shell docker network ls --filter type=custom -q)

volume:
	rm -rf ~/data/wordpress
	rm -rf ~/data/mariadb
	rm -rf ~/data/

fclean: clean volume

re: fclean all
