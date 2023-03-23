import { Context, Info, Returns, Transaction } from 'fabric-contract-api';
import { AllowedOrgs, BaseContract, BuildReturn } from './baseContract';
import { Car } from './car';


@Info({ title: 'Car', description: 'Smart contract for car' })
export class CarContract extends BaseContract {

    @Transaction()
    @BuildReturn()
    public async InitLedger(ctx: Context): Promise<void> {
        const cars: Car[] = [
            {
                chassisId: '8faf4111-723c-40c1-aa5f-070ad40edfaa',
                brand: 'Ford',
                model: 'Focus',
                ownerCpf: "123.123.123-12",
                color: 'blue',
                year: 2012,
                financingFlag: false,
                maintenance: [],
                restrictions: []
            },
            {
                chassisId: 'c747dc9e-e736-40b2-83bc-6ecd2f6356e9',
                brand: 'Honda',
                model: 'Civic',
                ownerCpf: "123.123.123-12",
                color: 'white',
                year: 2012,
                financingFlag: false,
                maintenance: [],
                restrictions: []
            },
            {
                chassisId: '3039d00b-943e-43e3-8322-bb1d165b6e82',
                brand: 'Toyota',
                model: 'Corola',
                ownerCpf: "123.123.123-12",
                color: 'black',
                year: 2012,
                financingFlag: false,
                maintenance: [],
                restrictions: []
            }
        ];

        for (const car of cars) {
            await this.PutState(ctx, car.chassisId, car)
        }
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['montadoraMSP'])
    public async CreateCar(ctx: Context, id: string, brand: string, model: string, color: string, appraisedValue: number): Promise<object> {
        const car: Car = {
            id: id,
            brand: brand,
            model: model,
            color: color,
            appraisedValue: appraisedValue,
        };

        await this.PutState(ctx, car.id, car)
        return car;
    }

    @Transaction()
    @BuildReturn()
    public async UpdateCar(ctx: Context, id: string, brand: string, model: string, ownerCpf: string, color: string, appraisedValue: number): Promise<object> {
        const car: Car = await this.GetState(ctx, id);

        if (!car) {
            throw new Error(`The car ${id} does not exist`);
        }

        car.brand = brand
        car.model = model
        car.ownerCpf = ownerCpf
        car.color = color
        car.appraisedValue = appraisedValue

        await this.PutState(ctx, car.id, car)
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detranMSP'])
    public async TransferCar(ctx: Context, id: string, newOwnerCpf: string): Promise<object> {
        const car: Car = await this.GetState(ctx, id);
        await this.checkIfExistsPerson(ctx, newOwnerCpf);

        car.ownerCpf = newOwnerCpf;

        await this.PutState(ctx, car.id, car);

        return car;
    }

    private async checkIfExistsPerson(ctx: Context, cpf: string): Promise<void> {
        const result = await ctx.stub.invokeChaincode(
            'person',
            [
                "PersonContract:Read",
                cpf
            ],
            "person-channel"
        )

        if (result.status != 200) {
            throw new Error(result.message);
        }
    }
}
