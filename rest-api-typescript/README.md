## ENV

Conteudo do arquivo

CONNECTION_PROFILE_FILE_ORG1 = /organizations/peerOrganizations/org1.example.com/connection-org1.json
CERTIFICATE_FILE_ORG1 = /organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/signcerts/User1@org1.example.com-cert.pem
PRIVATE_KEY_FILE_ORG1 = /organizations/peerOrganizations/org1.example.com/users/User1@org1.example.com/msp/keystore/priv_sk

#### Example

HLF_CERTIFICATE_ORG1="-----BEGIN CERTIFICATE-----\nMIICKj ..... 8ct8XhN\n-----END CERTIFICATE-----\n"

HLF_PRIVATE_KEY_ORG1="-----BEGIN PRIVATE KEY-----\nMIGHAd ..... es9HR4b\n-----END PRIVATE KEY-----\n"

HLF_CONNECTION_PROFILE_ORG1={"name":"test-network-or ...... ify":false}}}}

## Usage

Install dependencies

```shell
npm install
```

Build the REST server

```shell
npm run build
```
