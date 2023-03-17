import { Router, Request, Response } from 'express';
import { Contract } from 'fabric-network';
import { evaluateTransaction } from '../fabric/fabric';
import { getContract } from '../fabric/wallet';

export const invokeRouter = Router();

invokeRouter.put('/:channelName/:chaincodeName/:transactionName', async (req: Request, res: Response) => {
    const orgName = req.user as string;
    const channelName = req.params.channelName
    const chaincodeName = req.params.chaincodeName
    const transactionName = req.params.transactionName

    console.log('orgName:', orgName);
    console.log('channelName:', channelName);
    console.log('chaincodeName:', chaincodeName);
    console.log('transactionName:', transactionName);
    console.log('body', req.body);

    if (!channelName || !chaincodeName || !transactionName || !orgName) {
        return res.send({ "error": "Missing parameters" });
    }
    try {
        const contract: Contract = await getContract(req.app, orgName, channelName, chaincodeName);

        const data = await evaluateTransaction(contract, transactionName, req.body);
        let assets = [];
        if (data.length > 0) {
            assets = JSON.parse(data.toString());
        }
        console.log(assets);
        return res.json(assets);
    } catch (err) {
        return res.json({ "error": err.message });
    }

});
