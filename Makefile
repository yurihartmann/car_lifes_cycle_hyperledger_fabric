# Configs
.ONESHELL:
.DEFAULT_GOAL := default

default:
	@echo "Nada para fazer"

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
