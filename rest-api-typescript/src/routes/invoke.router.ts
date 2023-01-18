import { Router, Request, Response } from 'express';
import { Contract } from 'fabric-network';
import { evaluateTransaction } from '../fabric/fabric';
import { getContract } from '../fabric/wallet';

export const invokeRouter = Router();

invokeRouter.get('/', async (req: Request, res: Response) => {
    const orgName = req.user as string;
    console.log('orgName:', orgName);

    const channelName = req.query.channelName?.toString();
    const chaincodeName = req.query.chaincodeName?.toString();

    if (!channelName || !chaincodeName) {
        return res.send("channelName or chaincodeName");
    }

    const contract: Contract = await getContract(req.app, orgName, channelName, chaincodeName);

    const data = await evaluateTransaction(contract, 'GetAll');
    let assets = [];
    if (data.length > 0) {
        assets = JSON.parse(data.toString());
    }
    console.log(assets);
    return res.json(assets);

});
