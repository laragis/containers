ifneq (,$(wildcard .env))
    ENV_FILE := .env
else ifneq (,$(wildcard .env.example))
    ENV_FILE := .env.example
else
    $(error "Neither .env nor .env.example file exists!")
endif

include $(ENV_FILE)
export $(shell sed 's/=.*//' $(ENV_FILE))

# Set variables to pass
APP_NAME := python

up:
	docker compose up -d $(APP_NAME)

shell:
	docker compose exec --user=1000 $(APP_NAME) bash

shell-root:
	docker compose exec --user=root $(APP_NAME) bash

down:
	docker compose down $(APP_NAME)

down-v:
	docker compose down -v $(APP_NAME)

build:
	docker buildx build \
		--tag ${ORG_NAME}/${APP_SLUG}:${APP_VERSION} \
		--build-arg BASE_IMAGE=${BASE_IMAGE} \
		--build-arg TZ=${TZ} \
		--build-arg POETRY_VERSION=${POETRY_VERSION} \
		.

push:
	docker push ${ORG_NAME}/${APP_SLUG}:${APP_VERSION}

push-latest:
	docker tag ${ORG_NAME}/${APP_SLUG}:${APP_VERSION} ${ORG_NAME}/${APP_SLUG}:latest
	docker push ${ORG_NAME}/${APP_SLUG}:latest

push-all: push push-latest
