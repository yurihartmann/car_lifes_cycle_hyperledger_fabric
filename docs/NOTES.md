Endorsement:
    Type: ImplicitMeta
    Rule: "ANY Writers"

cat ... | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/mecanica-a.car-lifes-cicle.com/users/User1@mecanica-a.car-lifes-cicle.com/msp/keystore/priv-key.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/mecanica-a.car-lifes-cicle.com/users/User1@mecanica-a.car-lifes-cicle.com/msp/signcerts/User1@mecanica-a.car-lifes-cicle.com-cert.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/gov.car-lifes-cicle.com/users/User1@gov.car-lifes-cicle.com/msp/keystore/priv-key.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/gov.car-lifes-cicle.com/users/User1@gov.car-lifes-cicle.com/msp/signcerts/User1@gov.car-lifes-cicle.com-cert.pem | sed -e 's/$/\\n/' | tr -d '\r\n'


nvm --version  0.39.0