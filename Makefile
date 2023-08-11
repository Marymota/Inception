name = inception

# Create and start containers --detached
all:
	@printf "Create and start ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d

# Build or rebuild services
build:
	@printf "Build ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d --build

# Stop and remove containers, networks
down:
	@printf "Stop ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env down

#re:	down
#	@printf "Rebuild ${name}...\n"
#	@bash srcs/requirements/wordpress/tools/make_dir.sh
#	@docker-compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up -d --build

# Remove unused data --all
clean: 	down
	@printf "Clean configuration ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

fclean:
	@printf "Full clean up ${name}\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data

.PHONY : all build down re clean fclean
