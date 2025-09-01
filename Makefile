DOCKER_COMPOSE_FILE := ./srcs/docker-compose.yml
ENV_FILE := srcs/.env
DATA_DIR := $(HOME)/data
WORDPRESS_DATA_DIR := $(DATA_DIR)/wordpress
MARIADB_DATA_DIR := $(DATA_DIR)/mariadb

name = inception

all: create_dirs up

build: create_dirs
	@printf "Building configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) build

up:
	@printf "Starting configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

down:
	@printf "Stopping configuration ${name}...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down

re: fclean all 

clean: down
	@printf "Cleaning configuration ${name}...\n"
	@docker system prune -af
	@sudo rm -rf $(WORDPRESS_DATA_DIR)/
	@sudo rm -rf $(MARIADB_DATA_DIR)/

fclean: down
	@printf "Total clean of all configurations docker\n"
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf $(DATA_DIR)/  

logs:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

status:  # ✅ AGGIUNTO: comando utile per debugging
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps
	@docker volume ls
	@docker network ls

create_dirs:
	@printf "Creating data directories for ggargani...\n"
	@mkdir -p $(WORDPRESS_DATA_DIR)
	@mkdir -p $(MARIADB_DATA_DIR)
	@sudo chown -R $(USER):$(USER) $(DATA_DIR)  

.PHONY: all build up down re clean fclean logs status create_dirs
