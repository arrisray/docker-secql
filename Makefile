SHELL := /bin/bash

.PHONY: build up down shell status

build: export HOST_IP = $(shell ipconfig getifaddr en0) 
build:
	docker-compose build

up: export HOST_IP = $(shell ipconfig getifaddr en0)
up:
	open -a XQuartz
	xhost + ${HOST_IP}
	docker-compose up -d

down: export HOST_IP = $(shell ipconfig getifaddr en0)
down:
	docker-compose down

shell:
	docker exec -it secql_ide_1 /bin/bash

status:
	docker ps -a
