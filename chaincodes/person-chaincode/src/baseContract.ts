import { Contract, Transaction, Context, Returns } from "fabric-contract-api";
import { Iterators } from "fabric-shim";


export function AllowedOrgs(MSPIDs: string[]) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        const childFunction = descriptor.value;
        descriptor.value = function (this: any, ...args: any[]) {
            const MSPID = args[0].clientIdentity.getMSPID();

            if (!MSPIDs.includes(MSPID)) {
                throw new Error(`The MSPID ${MSPID} not allowed for this method`);
            }

            return childFunction.apply(this, args);
        }

        return descriptor;
    };
}


export class BaseContract extends Contract {

    @Transaction()
    public async getDetails(ctx: Context): Promise<string> {
        return JSON.stringify({
            getMSPID: ctx.clientIdentity.getMSPID()
        });
    }

    @Transaction(false)
    public async Read(ctx: Context, key: string): Promise<string> {
        const stateJSON = await ctx.stub.getState(key);
        if (!stateJSON || stateJSON.length === 0) {
            throw new Error(`The object with key=${key} does not exist`);
        }
        return stateJSON.toString();
    }

    @Transaction(false)
    @Returns('boolean')
    public async Exists(ctx: Context, key: string): Promise<boolean> {
        const stateJSON = await ctx.stub.getState(key);
        return stateJSON && stateJSON.length > 0;
    }

    @Transaction(false)
    @Returns('string')
    public async GetAll(ctx: Context): Promise<string> {
        const iterator = await ctx.stub.getStateByRange('', '');
        return JSON.stringify(await this.buildListByIterator(iterator));
    }

    @Transaction(false)
    @Returns('string')
    public async GetPaginated(ctx: Context, size: number, bookmark: string): Promise<string> {
        const pagination = await ctx.stub.getStateByRangeWithPagination('', '', size, bookmark);

        return JSON.stringify({
            data: await this.buildListByIterator(pagination.iterator),
            metadata: {
                bookmark: pagination.metadata.bookmark,
                fetchedRecordsCount: pagination.metadata.fetchedRecordsCount
            }
        });
    }

    @Transaction(false)
    @Returns('string')
    public async History(ctx: Context, key: string): Promise<string> {
        const history = await ctx.stub.getHistoryForKey(key);
        return JSON.stringify(await this.buildListByIterator(history));
    }

    @Transaction()
    public async Delete(ctx: Context, key: string): Promise<void> {
        const exists = await this.Exists(ctx, key);

        if (!exists) {
            throw new Error(`The object with key=${key} does not exist`);
        }

        return ctx.stub.deleteState(key);
    }

    public async buildListByIterator(iterator: Iterators.HistoryQueryIterator | Iterators.StateQueryIterator): Promise<Object[]> {
        const allResults = [];
        let result = await iterator.next();

        while (!result.done) {
            const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
            let record;
            try {
                record = JSON.parse(strValue);
            } catch (err) {
                console.log(err);
                record = strValue;
            }
            allResults.push(record);
            result = await iterator.next();
        }

        return allResults;
    }

}