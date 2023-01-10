import { Object, Property } from 'fabric-contract-api';
import { Person } from './person';

@Object()
export class Car {
    @Property()
    public id: string;

    @Property()
    public brand: string;

    @Property()
    public model: string;

    @Property()
    public owner: string;

    @Property()
    public color: string;

    @Property()
    public appraisedValue: number;
}
