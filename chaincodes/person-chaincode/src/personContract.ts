import { Context, Info, Transaction } from 'fabric-contract-api';
import { BaseContract, AllowedOrgs, BuildReturn, isCorrectDate } from './baseContract';
import { Person } from './person';

@Info({ title: 'Person', description: 'Smart contract for person' })
export class PersonContract extends BaseContract {

    @Transaction()
    public async InitLedger(ctx: Context): Promise<object> {
        const InitLedgerPersons: Person[] = [
            {
                cpf: '123.123.123-67',
                name: "Yuri",
                birthday: new Date("06/07/2001"),
                motherName: "Marilda",
                alive: true
            },
            {
                cpf: '456.456.456-67',
                name: "Isadora",
                birthday: new Date("05/05/2005"),
                motherName: "Marilda",
                alive: true,
            }
        ];

        for (const person of InitLedgerPersons) {
            await this.PutState(ctx, person.cpf, person)
        }

        return this.GetAll(ctx);
    }

    @Transaction(false)
    @BuildReturn()
    public async ReadPersonAlive(ctx: Context, cpf: string): Promise<object> {
        const person: Person = await this.GetState(ctx, cpf);
        
        if (!person.alive) {
            throw new Error(`The person ${cpf} is not alive`);
        }
        
        return person;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["gov"])
    public async CreatePerson(
        ctx: Context, 
        cpf: string, 
        name: string, 
        birthday: string, 
        motherName: string
    ): Promise<object> {
        if (await this.HasState(ctx, cpf)) {
            throw new Error(`The person ${cpf} already exists`);
        }

        const birthday_date = new Date(birthday)
        
        if (!isCorrectDate(birthday_date)) {
            throw new Error(`The birthday is a invalid date`);
        }

        if (birthday_date > new Date()) {
            throw new Error(`The birthday is bigger than today`);
        }

        const person: Person = {
            cpf: cpf,
            name: name,
            birthday: new Date(birthday),
            motherName: motherName,
            alive: true
        };

        await this.PutState(ctx, person.cpf, person)
        return person;
    }

    // @Transaction()
    // @BuildReturn()
    // @AllowedOrgs(["govMSP"])
    // public async UpdatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string, alive: boolean): Promise<object> {
    //     const person = await this.GetState(ctx, cpf);

    //     person.name = name
    //     person.birthday = new Date(birthday)
    //     person.motherName = motherName
    //     person.alive = alive

    //     await this.PutState(ctx, person.cpf, person);
    //     return person;
    // }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["gov"])
    public async DeclareDeathPerson(ctx: Context, cpf: string): Promise<object> {
        const person = await this.GetState(ctx, cpf);

        person.alive = false;

        await this.PutState(ctx, person.cpf, person);
        return person;
    }
}
