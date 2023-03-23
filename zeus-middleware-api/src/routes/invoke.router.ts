import { Router, Request, Response } from 'express';
import { Contract } from 'fabric-network';
import { evaluateTransaction, submitTransaction } from '../fabric/fabric';
import { getContract } from '../fabric/wallet';

export const invokeRouter = Router();

invokeRouter.get('/:channelName/:chaincodeName/:transactionName', async (req: Request, res: Response) => {
    const orgName = req.user as string;
    const channelName = req.params.channelName
    const chaincodeName = req.params.chaincodeName
    const transactionName = req.params.transactionName

    if (!channelName || !chaincodeName || !transactionName || !orgName) {
        return res.send({ "error": "Missing parameters" });
    }

    try {
        const contract: Contract = await getContract(req.app.locals['wallet'], orgName, channelName, chaincodeName);

        const data = await evaluateTransaction(contract, transactionName, req.body);

        let assets = [];
        if (data.length > 0) {
            assets = JSON.parse(data.toString());
        }

        return res.json(assets);
    } catch (err: any) {
        return res.json({ "error": err.message });
    }

});

invokeRouter.put('/:channelName/:chaincodeName/:transactionName', async (req: Request, res: Response) => {
    const orgName = req.user as string;
    const channelName = req.params.channelName
    const chaincodeName = req.params.chaincodeName
    const transactionName = req.params.transactionName

    if (!channelName || !chaincodeName || !transactionName || !orgName) {
        return res.send({ "error": "Missing parameters" });
    }

    try {
        const contract: Contract = await getContract(req.app.locals['wallet'], orgName, channelName, chaincodeName);

        const data = await submitTransaction(contract, transactionName, req.body);

        let assets = [];
        if (data.length > 0) {
            assets = JSON.parse(data.toString());
        }

        return res.json(assets);
    } catch (err: any) {
        return res.json({ "error": err.message });
    }

});
