import { Context, Info, Returns, Transaction } from 'fabric-contract-api';
import stringify from 'json-stringify-deterministic';
import sortKeysRecursive from 'sort-keys-recursive';
import { BaseContract } from './baseContract';
import { Person } from './person';

@Info({ title: 'Person', description: 'Smart contract for person' })
export class PersonContract extends BaseContract {

    @Transaction()
    public async InitLedger(ctx: Context): Promise<void> {
        const persons: Person[] = [
            {
                cpf: '123.123.123-67',
                name: "Yuri",
                birthday: new Date("06/07/2001"),
                motherName: "Maria"
            },
            {
                cpf: '456.456.456-67',
                name: "Yasmin",
                birthday: new Date("09/08/2001"),
                motherName: "Maria"
            }
        ];

        for (const person of persons) {
            await ctx.stub.putState(person.cpf, Buffer.from(stringify(sortKeysRecursive(person))));
        }
    }

    @Transaction()
    public async CreatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string): Promise<string> {
        const exists = await this.Exists(ctx, cpf);

        if (exists) {
            throw new Error(`The person ${cpf} already exists`);
        }

        const person: Person = {
            cpf: cpf,
            name: name,
            birthday: new Date(birthday),
            motherName: motherName
        };

        await ctx.stub.putState(person.cpf, Buffer.from(stringify(sortKeysRecursive(person))));
        return JSON.stringify(person);
    }

    @Transaction()
    public async UpdatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string): Promise<string> {
        const exists = await this.Exists(ctx, cpf);
        if (!exists) {
            throw new Error(`The person ${cpf} does not exist`);
        }

        const person: Person = {
            cpf: cpf,
            name: name,
            birthday: new Date(birthday),
            motherName: motherName
        };

        await ctx.stub.putState(cpf, Buffer.from(stringify(sortKeysRecursive(person))));
        return JSON.stringify(person);
    }

}
