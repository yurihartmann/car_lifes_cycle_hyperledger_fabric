import * as dotenv from 'env-var';

const env = JSON.parse(dotenv.get('JSON_CONFIG').required().asString());

export const portServer = env.port;
export const channelName = env.channelName;
export const chaincodeName = env.chaincodeName;

interface Organizations {
    [key: string]: OrganizationConfigs
}

interface OrganizationConfigs {
    CONNECTION_PROFILE: Record<string, unknown>,
    MSPID: string,
    CERTIFICATE: string,
    PRIVATE_KEY: string,
}


export const organizations: Organizations = {}

for (var i in env.peers) {
    const peer = env.peers[i]

    organizations[peer.APIKEY] = {
        CONNECTION_PROFILE: JSON.parse(peer.CONNECTION_PROFILE),
        MSPID: peer.MSPID,
        CERTIFICATE: peer.CERTIFICATE,
        PRIVATE_KEY: peer.PRIVATE_KEY
    }
}