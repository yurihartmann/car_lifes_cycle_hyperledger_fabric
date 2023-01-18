Endorsement:
    Type: ImplicitMeta
    Rule: "ANY Writers"

cat ... | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/mecanica-a.car-lifes-cicle.com/users/User1@mecanica-a.car-lifes-cicle.com/msp/keystore/priv-key.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/mecanica-a.car-lifes-cicle.com/users/User1@mecanica-a.car-lifes-cicle.com/msp/signcerts/User1@mecanica-a.car-lifes-cicle.com-cert.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/gov.car-lifes-cicle.com/users/User1@gov.car-lifes-cicle.com/msp/keystore/priv-key.pem | sed -e 's/$/\\n/' | tr -d '\r\n'

cat fablo-target/fabric-config/crypto-config/peerOrganizations/gov.car-lifes-cicle.com/users/User1@gov.car-lifes-cicle.com/msp/signcerts/User1@gov.car-lifes-cicle.com-cert.pem | sed -e 's/$/\\n/' | tr -d '\r\n'


nvm --version  0.39.0


export function AllowedOrgs(MSPIDs: string[]) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        const childFunction = descriptor.value;
        descriptor.value = (...args: any[]) => {
            const MSPID = args[0].clientIdentity.getMSPID();

            const found = MSPIDs.find((i) => {
                return i === MSPID;
            });

            if (!found) {
                throw new Error(`The MSPID ${MSPID} not allowed for this method`);
            }

            return childFunction.apply(this, args);
        }

        return descriptor;
    };
}
