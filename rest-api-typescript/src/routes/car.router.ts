import { Router, Request, Response } from 'express';
import { body, validationResult } from 'express-validator';
import { getReasonPhrase, StatusCodes } from 'http-status-codes';
import { Contract } from 'fabric-network';
import { evaluateTransaction } from '../fabric/fabric';

export const carRouter = Router();

carRouter.get('/', async (req: Request, res: Response) => {
    const orgAppKey = req.user as string;
    console.log(orgAppKey);
    const contract = req.app.locals[orgAppKey]?.contract as Contract;

    const data = await evaluateTransaction(contract, 'GetAllAssets');
    let assets = [];
    if (data.length > 0) {
        assets = JSON.parse(data.toString());
    }
    console.log(assets);
    return res.json(assets);

});
