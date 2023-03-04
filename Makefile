# Configs
.ONESHELL:
.DEFAULT_GOAL := default

default:
	@echo "Nada para fazer"

configure-all:
	@make configure-nvm
	@make configure-fablo
	@make configure-car-chaincodes
	@make configure-person-chaincodes

configure-nvm:
	@nvm install 12
	@nvm use node 12

configure-fablo:
	@sudo curl -Lf https://github.com/hyperledger-labs/fablo/releases/download/1.1.0/fablo.sh -o /usr/local/bin/fablo && sudo chmod +x /usr/local/bin/fablo

configure-car-chaincodes:
	@cd chaincodes/car-chaincode
	@npm i

configure-person-chaincodes:
	@cd chaincodes/person-chaincode
	@npm i
