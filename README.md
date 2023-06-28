
# 🚗 Car lifes cicle network
<p align="center">
<img src="docs/images/logos/car_logo_without_bg.png" height="300">
</p>

<p align="center">
Vehicle Management System using <a href="https://hyperledger-fabric.readthedocs.io/en/latest/">Hyperledger Fabric</a>
</p>

- Blockchain: Hyperledger Fabric
- API: Typescript Express
- Frontend: React with MaterialUI

## 🗂️ Structure of project

**Hyperledger**: `fablo-config.json` and `/fablo-target`that will be generated

**Chaincodes**: `/chaincodes`

**API**: `/zeus-middleware-api`

**Frontend**: `/atena-frontend`

<hr />

## 🥇 How to run:

### 🔖 Requirements

- Docker and docker-compose
- +Python3.7 
- Node 12.x

### 🛠 Run blockchain Hyperledger Fabric

- Configure fablo enviroment `make configure-fablo`

- Generate the fablo-target with `fablo generate`

- Edit file `fablo-target/fabric-config/configtx.yaml` in `Application: &ApplicationDefaults` (use `ctrl+f` to localize) and replace Policies->Endorsement->Rule to `MAJORITY Endorsement` to `ANY Writers`

In this section:
```
    Policies:
    ...
        Endorsement:
            Type: ImplicitMeta
            Rule: "MAJORITY Endorsement"
```
Replace for this:
```
        Endorsement:
            Type: ImplicitMeta
            Rule: "ANY Writers"
```

- Run blockchain `fablo up`, the chaincodes will be installed automatically

- For help: `fablo help`

### 🛠 Generate env file for API

- Run: `python build_env_files.py`

### 🛠 Run API Typescript Express

**🐳 Run in docker**

- Only run `make run-api-docker` and if can stop `make stop-api-docker`

- API will be exposed in port 3000

**💻 Run in machine**

- Entry is foldes `cd zeus-middleware-api/`

- Run: `npm i` to install dependencies

- Run: `npm run dev` to start API in development mode

- API will be exposed in port 3000

### 🛠 Run Frontend React with MaterialUI

**🐳 Run in docker**

- Only run `make run-frontend-docker` and if can stop `make stop-frontend-docker`

- Frontend will be exposed in port 3006

**💻 Run in machine**

- Entry is foldes `cd atena-frontend/`

- Run: `yarn` to install dependencies

- Run: `npm run start` to start frontend

- Frontend will be exposed in port 3006
