# Configs
.ONESHELL:
.DEFAULT_GOAL := default

default:
	@echo "Nada para fazer"

run-api-docker:
	@cd zeus-middleware-api
	@docker build -t zeus-middleware-api . && docker run --name zeus-middleware-api -it -d --network host zeus-middleware-api
	@cd ..

run-frontend-docker:
	@cd atena-frontend
	@docker build -t atena-frontend . && docker run --name atena-frontend -it -d -p 3006:3006 atena-frontend
	@cd ..

run-dockers:
	@make run-api-docker
	@make run-frontend-docker

stop-api-docker:
	@docker stop zeus-middleware-api
	@docker rm zeus-middleware-api

stop-frontend-docker:
	@docker stop atena-frontend
	@docker rm atena-frontend

stop-dockers:
	@make stop-api-docker
	@make stop-frontend-docker

configure-fablo:
	@sudo chmod +x ./fablo
