SHELL := /bin/bash

.PHONY: build up down shell clean status

define ENV_FILE
X_USER=$(shell id -un)
X_GROUP=$(shell id -gn)
X_UID=$(shell id -u)
X_GID=$(shell id -g)
X_DISPLAY=$(HOST_IP):0
CODE_DIR=/opt/code
HOST_IP=$(shell ipconfig getifaddr en0)
endef
export ENV_FILE
export HOST_IP = $(shell ipconfig getifaddr en0)

build:
	echo "$$ENV_FILE" > .env
	docker-compose build 

up:
	echo "$$ENV_FILE" > .env
	open -a XQuartz
	xhost + ${HOST_IP}
	docker-compose up -d

down:
	docker-compose down

clean: export CONTAINER_IDS=$(shell docker ps -qa --no-trunc --filter "status=exited")
clean:
	docker rm $(CONTAINER_IDS)

shell:
	docker exec -it docker_ide_1 /bin/bash

status:
	docker ps -a
