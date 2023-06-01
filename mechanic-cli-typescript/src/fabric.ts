import { orgs } from '../env.json';
import {
    Contract,
    DefaultEventHandlerStrategies,
    DefaultQueryHandlerStrategies,
    Gateway,
    GatewayOptions,
    Wallets,
    Network,
    Wallet,
} from 'fabric-network';

export const createWallets = async (): Promise<Wallet> => {
    const wallet = await Wallets.newInMemoryWallet();

    for (const [k, v] of Object.entries(orgs)) {
        const identity = {
            credentials: {
                certificate: v.certificate,
                privateKey: v.privateKey,
            },
            mspId: v.msp,
            type: 'X.509',
        };
        await wallet.put(v.msp, identity);
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

const getNetwork = async (gateway: Gateway, channelName: string): Promise<Network> => {
    const network = await gateway.getNetwork(channelName);
    return network;
};

const getContracts = async (
    network: Network, chaincodeName: string
): Promise<{ contract: Contract; qsccContract: Contract }> => {
    const contract = network.getContract(chaincodeName);
    const qsccContract = network.getContract('qscc');
    return { contract, qsccContract };
};

export const getContract = async (wallet: Wallet, orgName: string, channelName: string, chaincodeName: string): Promise<Contract> => {
    for (const [k, v] of Object.entries(orgs)) {
        if (k == orgName) {
            let connectionProfile = JSON.parse(v.connectionProfile);
            let MSPID = v.msp
            const gateway = await createGateway(
                connectionProfile,
                MSPID,
                wallet
            );
            const network = await getNetwork(gateway, channelName);
            return await (await getContracts(network, chaincodeName)).contract;
        }
    }

    throw Error('not exists contract');
}

export const evaluateTransaction = async (
    contract: Contract,
    transactionName: string,
    transactionArgs: string[]
): Promise<Buffer> => {
    const transaction = contract.createTransaction(transactionName);
    const transactionId = transaction.getTransactionId();
    // console.log({ transaction }, 'Evaluating transaction');

    const payload = await transaction.evaluate(...transactionArgs);
    // console.log(
    //     { transactionId: transactionId, payload: payload.toString() },
    //     'Evaluate transaction response received'
    // );
    return payload;
};

export const submitTransaction = async (
    contract: Contract,
    transactionName: string,
    transactionArgs: string[]
): Promise<Buffer> => {
    const transaction = contract.createTransaction(transactionName);
    const transactionId = transaction.getTransactionId();
    // console.log({ transaction }, 'Evaluating transaction');

    const payload = await transaction.submit(...transactionArgs);
    // console.log(
    //     { transactionId: transactionId, payload: payload.toString() },
    //     'Evaluate transaction response received'
    // );
    return payload;
};