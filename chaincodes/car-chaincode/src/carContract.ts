import { Context, Info, Transaction } from 'fabric-contract-api';
import { AllowedOrgs, BaseContract, BuildReturn, GetOrgName } from './baseContract';
import { Car } from './car';


@Info({ title: 'Car', description: 'Smart contract for car' })
export class CarContract extends BaseContract {


    private async getPerson(ctx: Context, cpf: string): Promise<any> {
        const result = await ctx.stub.invokeChaincode(
            'person',
            [
                "PersonContract:ReadPersonAlive",
                cpf
            ],
            "person-channel"
        )

        if (result.status != 200) {
            throw new Error(result.message);
        }

        return JSON.parse(result.payload.toString());
    }

    public checkRestrictions(car: Car) {
        car.restrictions.forEach(restriction => {
            if (!restriction.deletedAt) {
                throw new Error(`The car has restrictions`);
            }
        });
    }

    public checkFinancing(car: Car) {
        if (car.financingBy !== null) {
            throw new Error(`The car has financing`);
        }
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

        if (year > new Date().getFullYear()) {
            throw new Error(`The year is bigger than actually year`);
        }

        const car: Car = {
            chassisId: chassisId,
            brand: GetOrgName(ctx),
            model: model,
            year: year,
            color: color,
            ownerCpf: null,
            ownerDealershipName: null,
            financingBy: null,
            maintenances: [],
            restrictions: [],
            transfers: []
        };

        await this.PutState(ctx, car.chassisId, car)
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariaF', 'concessionariaG'])
    public async GetCarToSell(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.ownerDealershipName || car.ownerCpf) {
            throw new Error(`The car already have ownerDealershipName or ownerCpf ${car.ownerDealershipName}`);
        }

        car.ownerDealershipName = GetOrgName(ctx);

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

        this.checkRestrictions(car);

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

        if (!car.licensePlate) {
            throw new Error(`The car do not have licensePlate yet`);
        }

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

        car.restrictions.forEach(restriction => {
            if (restriction.code === code) {
                restriction.deletedAt = new Date();
            }
        });

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariaF', 'concessionariaG'])
    public async SellCar(
        ctx: Context,
        chassisId: string,
        cpf: string,
        amount: number,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (car.ownerDealershipName !== GetOrgName(ctx)) {
            throw new Error(`The ownerDealershipName is not owner for this car`);
        }

        if (amount < 0) {
            throw new Error(`The amount is less than 0 (zero)`);
        }

        await this.getPerson(ctx, cpf);

        this.checkRestrictions(car);
        this.checkFinancing(car);

        car.ownerDealershipName = null;
        car.ownerCpf = cpf;

        car.transfers.push({
            ownerDealershipName: GetOrgName(ctx),
            ownerCpf: cpf,
            date: new Date(),
            amount: amount,
            type: "SellCar"
        });

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async ChangeCarWithOtherPerson(
        ctx: Context,
        chassisId: string,
        newOwnercpf: string,
        amount: number
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        await this.getPerson(ctx, newOwnercpf);

        this.checkRestrictions(car);
        this.checkFinancing(car);

        if (amount < 0) {
            throw new Error(`The amount is less than 0 (zero)`);
        }

        if (car.ownerDealershipName !== null) {
            throw new Error(`The car has ownerDealershipName`);
        }

        if (!car.ownerCpf) {
            throw new Error(`The car not have ownerCpf`);
        }

        if (newOwnercpf === car.ownerCpf) {
            throw new Error(`The car is already for this CPF!`);
        }

        car.ownerCpf = newOwnercpf;
        car.licensingDueDate = null;

        car.transfers.push({
            ownerDealershipName: null,
            ownerCpf: newOwnercpf,
            date: new Date(),
            amount: amount,
            type: "ChangeCarWithOtherPerson"
        });

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['concessionariaF', 'concessionariaG'])
    public async ProposeChangeCarWithConcessionaire(
        ctx: Context,
        chassisId: string,
        amount: number
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        this.checkRestrictions(car);
        this.checkFinancing(car);

        if (amount < 0) {
            throw new Error(`The amount is less than 0 (zero)`);
        }

        if (!car.ownerCpf) {
            throw new Error(`The car do not have owner`);
        }

        if (car.ownerDealershipName) {
            throw new Error(`The car already have ownerDealership`);
        }

        car.pendencies = {
            getCarToOwnerCpfFromDealershipName: GetOrgName(ctx),
            getCarToOwnerCpfFromAmount: amount
        }

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async ConfirmChangeCarWithConcessionaire(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (!car.pendencies?.getCarToOwnerCpfFromDealershipName) {
            throw new Error(`Do not have any car pendencies`);
        }
        car.ownerDealershipName = car.pendencies?.getCarToOwnerCpfFromDealershipName;

        car.transfers.push({
            ownerDealershipName: car.ownerDealershipName,
            ownerCpf: car.ownerCpf,
            date: new Date(),
            amount: car.pendencies?.getCarToOwnerCpfFromAmount,
            type: "ChangeCarWithConcessionaire"
        });

        car.ownerCpf = null;
        car.licensingDueDate = null;
        car.pendencies = null;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    @AllowedOrgs(['detran'])
    public async DeniedChangeCarWithConcessionaire(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (!car.pendencies?.getCarToOwnerCpfFromDealershipName) {
            throw new Error(`Do not have any car pendencies`);
        }
        car.pendencies = null;

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

        this.checkRestrictions(car);

        if (car.maintenances[car.maintenances.length - 1]?.carKm > carKm) {
            throw new Error(`The carKm is lower than last maintenance`);
        }

        car.maintenances.push({
            mechanicalName: GetOrgName(ctx),
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

        car.financingBy = GetOrgName(ctx);

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

        if (car.financingBy !== GetOrgName(ctx)) {
            throw new Error(`The car is not financing by this financing org`);
        }

        car.financingBy = null;

        await this.PutState(ctx, car.chassisId, car);
        return car;
    }

    @Transaction()
    @BuildReturn()
    public async GetTransfersHistory(
        ctx: Context,
        chassisId: string,
    ): Promise<object> {
        const car: Car = await this.GetState(ctx, chassisId);

        if (GetOrgName(ctx) === 'detran') {
            return car.transfers;
        }

        const transfersResult = []

        car.transfers.forEach(transfer => {
            if (GetOrgName(ctx) === transfer.ownerDealershipName) {
                transfersResult.push(transfer)
            } else {
                transfer.amount = -1;
                transfersResult.push(transfer)
            }
        });

        return transfersResult;
    }
}
