ORG_NAME=nhantt
IMAGE_NAME=geowebcache-prod
IMAGE_TAG=latest

.PHONY: up
up:
	@echo "Starting the GeoWebCache server..."
	docker-compose up --build

.PHONY: up-d
up-d:
	@echo "Starting the GeoWebCache server..."
	docker-compose up -d --build

.PHONY: down
down:
	@echo "Stopping the GeoWebCache server..."
	docker-compose down

.PHONY: down-v
down-v:
	@echo "Stopping the GeoWebCache server..."
	docker-compose down -v

.PHONY: down-all
down-all:
	@echo "Stopping the GeoWebCache server..."
	docker-compose down --rmi all -v

.PHONY: shell
shell:
	@echo "Accessing the GeoWebCache server..."
	docker-compose exec ${IMAGE_NAME} /bin/bash

.PHONY: docker-push
docker-push:
	@echo "Pushing the image to Docker Hub..."
	docker push $(ORG_NAME)/$(IMAGE_NAME):$(IMAGE_TAG)
