import { Object, Property } from 'fabric-contract-api';

@Object()
export class Pendencies {
    @Property()
    public GetCarToOwnerCpfFromDealershipName: string;
}

@Object()
export class Maintenance {
    @Property()
    public mechanicalName: string;

    @Property()
    public date: Date;

    @Property()
    public carKm: number;

    @Property()
    public description?: string;
}

@Object()
export class Restriction {
    @Property()
    public code: number;

    @Property()
    public date: Date;

    @Property()
    public description?: string;

    @Property()
    public deletedAt?: Date;
}

@Object()
export class Car {
    @Property()
    public chassisId: string;

    @Property()
    public licensePlate?: string;

    @Property()
    public licensingDueDate?: Date;

    @Property()
    public brand: string;

    @Property()
    public model: string;

    @Property()
    public year: number;

    @Property()
    public color: string;

    @Property()
    public ownerCpf?: string;

    @Property()
    public ownerDealershipName?: string;

    @Property()
    public financingBy?: string;

    @Property()
    public maintenance: Maintenance[];

    @Property()
    public restrictions: Restriction[];

    @Property()
    public pendencies?: Pendencies;

}
