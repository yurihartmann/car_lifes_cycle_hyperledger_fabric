import { Contract, Transaction, Context, Returns } from "fabric-contract-api";
import { Iterators } from "fabric-shim";
import sortKeysRecursive from 'sort-keys-recursive';
import stringify from 'json-stringify-deterministic';

export function isCorrectDate(date: Date) {
    return date instanceof Date && isFinite(+date);
};

export function GetOrgName(ctx: Context) {
    return ctx.clientIdentity.getMSPID().replace('MSP', '');
}

export function AllowedOrgs(MSPIDs: string[]) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        const childFunction = descriptor.value;
        descriptor.value = function (this: any, ...args: any[]) {
            const MSPID = args[0].clientIdentity.getMSPID();
            var allowed: boolean = false;

            MSPIDs.forEach(MspidAllowed => {
                if (MSPID === MspidAllowed + "MSP") {
                    allowed = true;
                }
            });

            if (!allowed) {
                throw new Error(`The organization ${MSPID.replace('MSP', '')} not allowed for this method`);
            }

            return childFunction.apply(this, args);
        }

        return descriptor;
    };
}

function replacer(key, value) {
    if (key == "transfers") {
        return null;
    }

    return value;
}

export function BuildReturn() {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        const childFunction = descriptor.value;
        descriptor.value = async function (this: any, ...args: any[]) {
            const returnValue = await childFunction.apply(this, args);

            if (typeof returnValue === 'object' || Array.isArray(returnValue)) {
                return JSON.stringify(returnValue, replacer);
            }

            return null;
        }

        return descriptor;
    };
}


export class BaseContract extends Contract {

    protected async PutState(ctx: Context, key: string, value: object): Promise<void> {
        await ctx.stub.putState(key, Buffer.from(stringify(sortKeysRecursive(value))));
    }

    protected async HasState(ctx: Context, key: string): Promise<boolean> {
        const stateJSON = await ctx.stub.getState(key)
        if (!stateJSON || stateJSON.length === 0) {
            return false;
        }

        return true;
    }

    protected async GetState(ctx: Context, key: string): Promise<any> {
        const stateJSON = await ctx.stub.getState(key)
        if (!stateJSON || stateJSON.length === 0) {
            throw new Error(`The object with key=${key} does not exist`);
        }

        return JSON.parse(stateJSON.toString());
    }

    protected async buildListByIterator(iterator: Iterators.HistoryQueryIterator | Iterators.StateQueryIterator): Promise<Object[]> {
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

    @Transaction()
    @BuildReturn()
    public async GetDetails(ctx: Context): Promise<object> {
        return {
            getMSPID: ctx.clientIdentity.getMSPID(),
            getID: ctx.clientIdentity.getID()
        };
    }

    @Transaction(false)
    @BuildReturn()
    public async Read(ctx: Context, key: string): Promise<object> {
        return await this.GetState(ctx, key);
    }

    @Transaction(false)
    @Returns('string')
    @BuildReturn()
    public async GetAll(ctx: Context): Promise<object> {
        const iterator = await ctx.stub.getStateByRange('', '');
        return await this.buildListByIterator(iterator);
    }

    @Transaction(false)
    @Returns('string')
    @BuildReturn()
    public async GetPaginated(ctx: Context, size: number, bookmark: string): Promise<object> {
        const pagination = await ctx.stub.getStateByRangeWithPagination('', '', size, bookmark);

        return {
            data: await this.buildListByIterator(pagination.iterator),
            metadata: {
                bookmark: pagination.metadata?.bookmark || '',
                fetchedRecordsCount: pagination.metadata?.fetchedRecordsCount || 0
            }
        };
    }

    @Transaction(false)
    @Returns('string')
    @BuildReturn()
    public async History(ctx: Context, key: string): Promise<object> {
        const history = await ctx.stub.getHistoryForKey(key);
        return await this.buildListByIterator(history);
    }

    @Transaction(false)
    @Returns('string')
    @BuildReturn()
    public async Count(ctx: Context): Promise<object> {
        let count: number = 0;
        let bookmark: string = '';

        while (true) {
            let pagination = await ctx.stub.getStateByRangeWithPagination('', '', 100_000, bookmark);

            let fetchedRecordsCount = pagination.metadata?.fetchedRecordsCount || 0;

            bookmark = pagination.metadata?.bookmark || ''
            count += fetchedRecordsCount;
            
            if (fetchedRecordsCount < 100_000) {
                break;
            }

            if (fetchedRecordsCount === 100_000 && bookmark === '') {
                break
            }

            bookmark = pagination.metadata.bookmark;
        }

        return { count };
    }

    @Transaction()
    @BuildReturn()
    public async Delete(ctx: Context, key: string): Promise<void> {
        await this.GetState(ctx, key);

        return ctx.stub.deleteState(key);
    }

}