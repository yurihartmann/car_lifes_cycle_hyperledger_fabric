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
	@npm i
	@sed -i '14d' node_modules/logform/index.d.ts

configure-person-chaincodes:
	@cd chaincodes/person-chaincode
	@npm i
	@sed -i '14d' node_modules/logform/index.d.ts

configure-zeus-middleware-api:
	@cd zeus-middleware-api
	@npm i

configure-zeus-middleware-api:
	@cd zeus-middleware-api
	@npm i

configure-atena-frontend:
	@cd atena-frontend
	@yarn
