import { Context, Info, Transaction } from 'fabric-contract-api';
import { BaseContract, AllowedOrgs, BuildReturn } from './baseContract';
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
            await this.PutState(ctx, person.cpf, person)
        }
    }

    @Transaction()
    @AllowedOrgs(['detranMSP'])
    @BuildReturn()
    public async CreatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string): Promise<object> {

        const person: Person = {
            cpf: cpf,
            name: name,
            birthday: new Date(birthday),
            motherName: motherName
        };

        await this.PutState(ctx, person.cpf, person)
        return person;
    }

    @Transaction()
    @BuildReturn()
    public async UpdatePerson(ctx: Context, cpf: string, name: string, birthday: string, motherName: string): Promise<object> {
        const person = await this.GetState(ctx, cpf);

        person.name = name
        person.birthday = new Date(birthday)
        person.motherName = motherName

        await this.PutState(ctx, person.cpf, person);
        return person;
    }

}
