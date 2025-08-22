# Variables
DATA_DIR = /home/inception/data

# Default target
all: up

# Create data directories
setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb

# Build and start containers
up: setup
	@echo "Starting Inception..."
	@docker-compose -f srcs/docker-compose.yml up -d --build

# Stop containers
down:
	@echo "Stopping Inception..."
	@docker-compose -f srcs/docker-compose.yml down

# Stop and remove everything
clean: down
	@echo "Cleaning up..."
	@docker system prune -af
	@docker volume prune -f

# Remove data directories (careful!)
fclean: clean
	@echo "Removing data directories..."
	@rm -rf $(DATA_DIR)
	@docker system prune -af --volumes

# Rebuild everything
re: fclean all

# Show status
status:
	@docker ps
	@docker images

# Show logs
logs:
	@docker-compose -f srcs/docker-compose.yml logs

# Restart services
restart: down up

.PHONY: all setup up down clean fclean re status logs restart