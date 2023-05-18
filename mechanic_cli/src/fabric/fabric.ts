import {
    Contract,
} from 'fabric-network';

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