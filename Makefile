SHELL := /bin/bash

.PHONY: build up down shell clean status

build:
	docker-compose build 

up:
	docker-compose up -d

down:
	docker-compose down

clean: export CONTAINER_IDS=$(shell docker ps -qa --no-trunc --filter "status=exited")
clean:
	docker rm $(CONTAINER_IDS)

shell:
	docker exec -it dev /bin/bash

status:
	docker ps -a
