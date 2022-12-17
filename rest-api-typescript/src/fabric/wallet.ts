import { Application } from "express";
import {
    Contract,
    DefaultEventHandlerStrategies,
    DefaultQueryHandlerStrategies,
    Gateway,
    GatewayOptions,
    Wallets,
    Network,
    Transaction,
    Wallet,
} from 'fabric-network';
import { organizations, channelName, chaincodeName } from '../configs/config';

export const createWallets = async (): Promise<Wallet> => {
    const wallet = await Wallets.newInMemoryWallet();

    for (var org in organizations) {
        const identity = {
            credentials: {
                certificate: organizations[org].CERTIFICATE,
                privateKey: organizations[org].PRIVATE_KEY,
            },
            mspId: organizations[org].MSPID,
            type: 'X.509',
        };
        await wallet.put(organizations[org].MSPID, identity);
    }

    return wallet;
};

const createGateway = async (
    connectionProfile: Record<string, unknown>,
    identity: string,
    wallet: Wallet
): Promise<Gateway> => {
    const gateway = new Gateway();

    const options: GatewayOptions = {
        wallet,
        identity,
        discovery: { enabled: true, asLocalhost: true },
        eventHandlerOptions: {
            commitTimeout: 300,
            endorseTimeout: 30,
            strategy: DefaultEventHandlerStrategies.PREFER_MSPID_SCOPE_ANYFORTX,
        },
        queryHandlerOptions: {
            timeout: 4,
            strategy: DefaultQueryHandlerStrategies.PREFER_MSPID_SCOPE_ROUND_ROBIN,
        },
    };

    await gateway.connect(connectionProfile, options);

    return gateway;
};

const getNetwork = async (gateway: Gateway): Promise<Network> => {
    const network = await gateway.getNetwork(channelName);
    return network;
};

const getContracts = async (
    network: Network
): Promise<{ contract: Contract; qsccContract: Contract }> => {
    const contract = network.getContract(chaincodeName);
    const qsccContract = network.getContract('qscc');
    return { contract, qsccContract };
};

export const configureContracts = async (app: Application, wallet: Wallet): Promise<void> => {

    for (var org in organizations) {
        const gateway = await createGateway(
            organizations[org].CONNECTION_PROFILE,
            organizations[org].MSPID,
            wallet
        );
        const network = await getNetwork(gateway);
        const contracts = await getContracts(network);

        app.locals[organizations[org].MSPID] = contracts;
    }
}