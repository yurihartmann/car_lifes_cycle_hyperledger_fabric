import { Context, Contract, Info, Returns, Transaction } from 'fabric-contract-api';
import { Iterators } from 'fabric-shim';
import stringify from 'json-stringify-deterministic';
import sortKeysRecursive from 'sort-keys-recursive';
import { v4 as uuid } from 'uuid';
import { Car } from './car';
import { buildListByIterator } from './utils';

@Info({ title: 'Car', description: 'Smart contract for car' })
export class CarContract extends Contract {

    @Transaction()
    public async InitLedger(ctx: Context): Promise<void> {
        const cars: Car[] = [
            {
                id: '8faf4111-723c-40c1-aa5f-070ad40edfaa',
                brand: 'Ford',
                model: 'Focus',
                owner_cpf: "123.123.123-12",
                color: 'blue',
                appraisedValue: 15000
            },
            {
                id: 'c747dc9e-e736-40b2-83bc-6ecd2f6356e9',
                brand: 'Honda',
                model: 'Civic',
                owner_cpf: "123.123.123-12",
                color: 'white',
                appraisedValue: 25000
            },
            {
                id: '3039d00b-943e-43e3-8322-bb1d165b6e82',
                brand: 'Toyota',
                model: 'Corola',
                owner_cpf: "123.123.123-12",
                color: 'black',
                appraisedValue: 28000
            }
        ];

        for (const car of cars) {
            await ctx.stub.putState(car.id, Buffer.from(stringify(sortKeysRecursive(car))));
        }
    }

    @Transaction()
    public async CreateCar(ctx: Context, brand: string, model: string, owner_cpf: string, color: string, appraisedValue: number): Promise<string> {
        const car: Car = {
            id: uuid(),
            brand: brand,
            model: model,
            owner_cpf: owner_cpf,
            color: color,
            appraisedValue: appraisedValue,
        };

        await ctx.stub.putState(car.id, Buffer.from(stringify(sortKeysRecursive(car))));
        return JSON.stringify(car);
    }

    @Transaction(false)
    public async ReadCar(ctx: Context, id: string): Promise<string> {
        const carJSON = await ctx.stub.getState(id);
        if (!carJSON || carJSON.length === 0) {
            throw new Error(`The car ${id} does not exist`);
        }
        return carJSON.toString();
    }

    @Transaction()
    public async UpdateCar(ctx: Context, id: string, brand: string, model: string, owner_cpf: string, color: string, appraisedValue: number): Promise<string> {
        const exists = await this.CarExists(ctx, id);
        if (!exists) {
            throw new Error(`The car ${id} does not exist`);
        }

        const car: Car = {
            id: id,
            brand: brand,
            model: model,
            owner_cpf: owner_cpf,
            color: color,
            appraisedValue: appraisedValue,
        };

        await ctx.stub.putState(id, Buffer.from(stringify(sortKeysRecursive(car))));
        return JSON.stringify(car);
    }

    @Transaction()
    public async DeleteCar(ctx: Context, id: string): Promise<void> {
        const exists = await this.CarExists(ctx, id);

        if (!exists) {
            throw new Error(`The car ${id} does not exist`);
        }

        return ctx.stub.deleteState(id);
    }

    @Transaction(false)
    @Returns('boolean')
    public async CarExists(ctx: Context, id: string): Promise<boolean> {
        const assetJSON = await ctx.stub.getState(id);
        return assetJSON && assetJSON.length > 0;
    }

    @Transaction()
    public async TransferAsset(ctx: Context, id: string, new_owner_cpf: string): Promise<string> {
        const carString = await this.ReadCar(ctx, id);
        const car: Car = JSON.parse(carString);

        car.owner_cpf = new_owner_cpf;

        await ctx.stub.putState(id, Buffer.from(stringify(sortKeysRecursive(car))));

        return JSON.stringify(car);
    }

    @Transaction(false)
    @Returns('string')
    public async GetAllAssets(ctx: Context): Promise<string> {
        // const allResults = [];
        // const iterator = await ctx.stub.getStateByRange('', '');
        // let result = await iterator.next();

        // while (!result.done) {
        //     const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
        //     let record;
        //     try {
        //         record = JSON.parse(strValue);
        //     } catch (err) {
        //         console.log(err);
        //         record = strValue;
        //     }
        //     allResults.push(record);
        //     result = await iterator.next();
        // }
        // return JSON.stringify(allResults);

        const iterator = await ctx.stub.getStateByRange('', '');
        return JSON.stringify(await buildListByIterator(iterator));
    }

    @Transaction(false)
    @Returns('string')
    public async GetCarsPaginated(ctx: Context, size: number, bookmark: string): Promise<string> {
        // const allResults = [];
        // const pagination = await ctx.stub.getStateByRangeWithPagination('', '', size, bookmark);
        // let result = await pagination.iterator.next();

        // while (!result.done) {
        //     const strValue = Buffer.from(result.value.value.toString()).toString('utf8');
        //     let record;
        //     try {
        //         record = JSON.parse(strValue);
        //     } catch (err) {
        //         console.log(err);
        //         record = strValue;
        //     }
        //     allResults.push(record);
        //     result = await pagination.iterator.next();
        // }
        const pagination = await ctx.stub.getStateByRangeWithPagination('', '', size, bookmark);
        
        return JSON.stringify({
            data: await buildListByIterator(pagination.iterator),
            metadata: {
                bookmark: pagination.metadata.bookmark,
                fetchedRecordsCount: pagination.metadata.fetchedRecordsCount
            }
        });
    }

    @Transaction(false)
    @Returns('string')
    public async HistoryByCar(ctx: Context, id: string): Promise<string> {
        const historyCar = await ctx.stub.getHistoryForKey(id);
        return JSON.stringify(await buildListByIterator(historyCar));
    }
}
