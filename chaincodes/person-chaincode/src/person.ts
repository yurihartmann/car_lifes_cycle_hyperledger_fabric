import { Object, Property } from 'fabric-contract-api';


@Object()
export class Person {
    @Property()
    public cpf: string;

    @Property()
    public name: string;

    @Property()
    public birthday: Date;

    @Property()
    public motherName: string;

    @Property()
    public alive: boolean;
}
