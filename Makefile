NAME = inception


DATA_DIR = /home/${USER}/data

all: up

up: build
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/mysql
	@mkdir -p $(DATA_DIR)/wordpress
	@echo "Starting containers..."
	@docker-compose -f srcs/docker-compose.yml up -d
	@echo "✅ Inception is running!"
	@echo "Access your site at: https://$(shell whoami).42.fr"

build:
	@echo "Building Docker images..."
	@docker-compose -f srcs/docker-compose.yml build

down:
	@echo "Stopping containers (data preserved)..."
	@docker-compose -f srcs/docker-compose.yml down

stop:
	@echo "Stopping containers..."
	@docker-compose -f srcs/docker-compose.yml stop

start:
	@echo "Starting containers..."
	@docker-compose -f srcs/docker-compose.yml start


clean: down
	@echo "Cleaning Docker images and cache..."
	@docker system prune -af
	@docker image prune -af


fclean: clean
	@echo "⚠️  DESTROYING ALL DATA - Full clean for evaluation..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf $(DATA_DIR)
	@echo "💥 All data destroyed. Ready for fresh evaluation."


re: fclean all


logs:
	@docker-compose -f srcs/docker-compose.yml logs

ps:
	@docker-compose -f srcs/docker-compose.yml ps


status:
	@echo "=== DOCKER CONTAINERS ==="
	@docker ps
	@echo "\n=== DOCKER VOLUMES ==="
	@docker volume ls
	@echo "\n=== DOCKER NETWORKS ==="
	@docker network ls
	@echo "\n=== DATA DIRECTORIES ==="
	@ls -la $(DATA_DIR) 2>/dev/null || echo "No data directory found"


help:
	@echo "Inception Makefile Commands:"
	@echo "  make / make all  : Build and start all services"
	@echo "  make down        : Stop containers (SAFE - preserves data)"
	@echo "  make clean       : Remove images (SAFE - preserves data)"  
	@echo "  make fclean      : DESTROY EVERYTHING (for evaluation)"
	@echo "  make re          : Full rebuild (fclean + all)"
	@echo "  make logs        : Show container logs"
	@echo "  make status      : Show system status"

.PHONY: all up build down stop start clean fclean re logs ps status help
