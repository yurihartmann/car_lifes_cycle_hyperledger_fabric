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
                financingBy: null,
                maintenance: [],
                restrictions: []
            },
            {
                chassisId: 'c747dc9e-e736-40b2-83bc-6ecd2f6356e9',
                brand: 'Honda',
                model: 'Civic',
                ownerCpf: "123.123.123-67",
                color: 'white',
                year: 2012,
                financingBy: null,
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
                financingBy: null,
                maintenance: [],
                restrictions: []
            }
        ];

        for (const car of cars) {
            await this.PutState(ctx, car.chassisId, car)
        }
    }

    private async getPerson(ctx: Context, cpf: string): Promise<any> {
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

        return JSON.parse(result.payload.toString());
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['montadoraC', 'montadoraD'])
    public async AddCar(
        ctx: Context,
        chassisId: string,
        model: string,
        year: number,
        color: string,
    ): Promise<object> {
        if (await this.HasState(ctx, chassisId)) {
            throw new Error(`The Car ${chassisId} already exists`);
        }

        const car: Car = {
            chassisId: chassisId,
            brand: ctx.clientIdentity.getMSPID(),
            model: model,
            year: year,
            color: color,
            ownerCpf: null,
            ownerDealershipName: null,
            financingBy: null,
            maintenance: [],
            restrictions: []
        };

        await this.PutState(ctx, car.chassisId, car)
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariF', 'concessionariG'])
    public async GetCarToSell(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.ownerDealershipName || car.ownerCpf) {
            throw new Error(`The car already have ownerDealershipName or ownerCpf ${car.ownerDealershipName}`);
        }

        car.ownerDealershipName = ctx.clientIdentity.getMSPID();

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariF', 'concessionariG'])
    public async SellCar(
        ctx: Context,
        chassisId: string,
        cpf: string
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.ownerDealershipName !== ctx.clientIdentity.getMSPID()) {
            throw new Error(`The ownerDealershipName is not owner for this car`);
        }

        const person = await this.getPerson(ctx, cpf);

        // if ((new Date().getFullYear() - new Date(person?.birthday).getFullYear()) < 18) {
        //     throw new Error(`The person not have 18 years old or more`);
        // }

        if (car.restrictions.length > 0) {
            throw new Error(`The car have restrictions`);
        }

        car.ownerDealershipName = null;
        car.ownerCpf = cpf;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async LicensingCar(
        ctx: Context,
        chassisId: string,
        licensePlate: string
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.restrictions.length > 1) {
            throw new Error(`The car have restrictions`);
        }

        if (licensePlate.length > 0) {
            car.licensePlate = licensePlate
        }

        const actualDate = new Date();
        actualDate.setFullYear(actualDate.getFullYear() + 1);
        car.licensingDueDate = actualDate;

        if (!car.licensePlate) {
            throw new Error(`The car do not have licensePlate, please pass one`);
        }

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async AddRestriction(
        ctx: Context,
        chassisId: string,
        code: number,
        description: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        car.restrictions.push({
            code: code,
            description: description,
            date: new Date()
        });

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async DeleteRestriction(
        ctx: Context,
        chassisId: string,
        code: number,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        car.restrictions = car.restrictions.filter(restriction => {
            return restriction.code != code
        })

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }


    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async ChangeCarWithOtherPerson(
        ctx: Context,
        chassisId: string,
        newOwnercpf: string
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        const person = await this.getPerson(ctx, newOwnercpf);

        if ((new Date().getFullYear() - new Date(person?.birthday).getFullYear()) < 18) {
            throw new Error(`The new owner person not have 18 years old or more`);
        }

        if (car.restrictions.length > 0) {
            throw new Error(`The car have restrictions`);
        }

        if (car.financingBy !== null) {
            throw new Error(`The car have financing`);
        }

        car.ownerCpf = newOwnercpf;
        car.licensingDueDate = null;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariF', 'concessionariG'])
    public async ChangeCarWithConcessionaire(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.restrictions.length > 0) {
            throw new Error(`The car have restrictions`);
        }

        if (car.financingBy !== null) {
            throw new Error(`The car have financing`);
        }

        car.ownerCpf = null;
        car.ownerDealershipName = ctx.clientIdentity.getMSPID();
        car.licensingDueDate = null;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['mecanicaK', 'mecanicaL'])
    public async AddMaintenance(
        ctx: Context,
        chassisId: string,
        carKm: number,
        description: string
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.restrictions.length > 0) {
            throw new Error(`The car have restrictions`);
        }

        if (car.maintenance[car.maintenance.length - 1]?.carKm > carKm) {
            throw new Error(`The carKm is lower than last maintenance`);
        }

        car.maintenance.push({
            mechanicalName: ctx.clientIdentity.getMSPID(),
            date: new Date(),
            carKm: carKm,
            description: description
        });

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['financiadoraR', 'financiadoraS'])
    public async AddFinancing(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.financingBy !== null) {
            throw new Error(`The car is already financing`);
        }

        car.financingBy = ctx.clientIdentity.getMSPID();

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['financiadoraR', 'financiadoraS'])
    public async RemoveFinancing(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.financingBy !== ctx.clientIdentity.getMSPID()) {
            throw new Error(`The car is not financing by this financing org`);
        }

        car.financingBy = null;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

}
