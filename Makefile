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

stop-api-docker:
	@docker stop zeus-middleware-api atena-frontend

stop-frontend-docker:
	@docker rm zeus-middleware-api atena-frontend

stop-dockers:
	@make stop-api-docker
	@make stop-frontend-docker

configure-all:
	@make configure-fablo
	@make configure-car-chaincodes
	@make configure-person-chaincodes
	@make configure-zeus-middleware-api
	@make configure-atena-frontend

configure-fablo:
	@sudo curl -Lf https://github.com/hyperledger-labs/fablo/releases/download/1.1.0/fablo.sh -o /usr/local/bin/fablo && sudo chmod +x /usr/local/bin/fablo

configure-car-chaincodes:
	@cd chaincodes/car-chaincode
	@nvm install 12 && nvm use node 12
	@npm i

configure-person-chaincodes:
	@cd chaincodes/person-chaincode
	@npm i

configure-zeus-middleware-api:
	@cd zeus-middleware-api
	@nvm install 16 && nvm use node 16
	@npm i

configure-atena-frontend:
	@cd atena-frontend
	@nvm install 16 && nvm use node 16
	@yarn
