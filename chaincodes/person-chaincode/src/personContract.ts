import { Context, Info, Transaction } from 'fabric-contract-api';
import { BaseContract, AllowedOrgs, BuildReturn } from './baseContract';
import { DriverLicense, Person } from './person';

@Info({ title: 'Person', description: 'Smart contract for person' })
export class PersonContract extends BaseContract {

    @Transaction()
    public async InitLedger(ctx: Context): Promise<object> {
        const InitLedgerPersons: Person[] = [
            {
                cpf: '123.123.123-67',
                name: "Yuri",
                birthday: new Date("06/07/2001"),
                motherName: "Maria",
                driverLicense: {
                    cnhNumber: 98762198,
                    dueDate: new Date("09/08/2018")
                },
                alive: true
            },
            {
                cpf: '456.456.456-67',
                name: "Yasmin",
                birthday: new Date("09/08/2001"),
                motherName: "Maria",
                alive: true,
                driverLicense: null
            }
        ];

        for (const person of InitLedgerPersons) {
            await this.PutState(ctx, person.cpf, person)
        }

        return this.GetAll(ctx);
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["govMSP"])
    public async CreatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string): Promise<object> {
        if (await this.HasState(ctx, cpf)) {
            throw new Error(`The person ${cpf} already exists`);
        }

        const person: Person = {
            cpf: cpf,
            name: name,
            birthday: new Date(birthday),
            motherName: motherName,
            alive: true,
            driverLicense: null
        };

        await this.PutState(ctx, person.cpf, person)
        return person;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["govMSP"])
    public async UpdatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string, alive: boolean): Promise<object> {
        const person = await this.GetState(ctx, cpf);

        person.name = name
        person.birthday = new Date(birthday)
        person.motherName = motherName
        person.alive = alive

        await this.PutState(ctx, person.cpf, person);
        return person;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["detranMSP"])
    public async UpdateDriverLicense(ctx: Context, cpf: string, cnhNumber: number, dueDate: string): Promise<object> {
        const person = await this.GetState(ctx, cpf);

        if (!person.alive) {
            throw new Error(`The person ${cpf} is not alive`);
        }

        const driverLicense: DriverLicense = {
            cnhNumber: cnhNumber,
            dueDate: new Date(dueDate)
        };

        person.driverLicense = driverLicense;

        await this.PutState(ctx, person.cpf, person);
        return person;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(["detranMSP"])
    public async DeleteLicense(ctx: Context, cpf: string): Promise<object> {
        const person = await this.GetState(ctx, cpf);

        if (!person.alive) {
            throw new Error(`The person ${cpf} is not alive`);
        }

        person.driverLicense = null;

        await this.PutState(ctx, person.cpf, person);
        return person;
    }

}
