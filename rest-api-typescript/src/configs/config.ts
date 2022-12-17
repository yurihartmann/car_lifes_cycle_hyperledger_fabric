import env from '../../env.json';
import { readFileSync } from 'fs';

export const portServer = env.port;

interface Organizations {
    [key: string]: OrganizationConfigs
}

interface OrganizationConfigs {
    CONNECTION_PROFILE: string,
    CERTIFICATE: string,
    PRIVATE_KEY: string,
}


export const organizations: Organizations = {}

for (var i in env.peers) {
    const peer = env.peers[i]
    const connection = readFileSync(peer.CONNECTION_PROFILE, 'utf-8');
    const certificate = readFileSync(peer.CERTIFICATE, 'utf-8');
    const privateKey = readFileSync(peer.PRIVATE_KEY, 'utf-8');

    organizations[peer.APIKEY] = {
        CONNECTION_PROFILE: JSON.parse(connection),
        CERTIFICATE: certificate,
        PRIVATE_KEY: privateKey
    }
}