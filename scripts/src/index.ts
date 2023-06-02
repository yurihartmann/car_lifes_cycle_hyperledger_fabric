import { Contract, Wallet } from 'fabric-network';
import { createWallets, getContract, submitTransaction, evaluateTransaction } from './fabric';
import { prompt } from 'enquirer';
import { v4 as uuidv4 } from 'uuid';

interface IPromptData {
    answer: string
}

interface IMaintenance {
    carKm: number,
    description: string,
    date: string,
    mechanicalName: string
}

interface ICar {
    maintenances: IMaintenance[]
}

interface ICount {
    count: number
}

async function CreateCar(wallet: Wallet) {
    try {
        const contract: Contract = await getContract(wallet, "montadoraC", "car-channel", "car");
        const data = await submitTransaction(contract, "AddCar", [
            `${uuidv4()}`, "model 1", "2023", "blue"
        ]);
        // console.log(JSON.parse(data.toString()));
    }
    catch {
        console.log('Erro createCar!')
    }
}

async function GetCount(wallet: Wallet): Promise<number> {
    try {
        const contract: Contract = await getContract(wallet, "detran", "car-channel", "car");
        const data = await evaluateTransaction(contract, "Count", [""]);

        const json_data: ICount = JSON.parse(data.toString());
        return json_data.count;
    }
    catch {
        console.log('Erro GetCount!')
        return 0;
    }
}

async function PopulateBase(wallet: Wallet) {

    const numberEntities: IPromptData = await prompt({
        type: 'input',
        name: 'answer',
        message: 'Numero de carro que deseja?',
    });

    const N: number = Number(numberEntities.answer)

    while (true) {

        const count = await GetCount(wallet);
        console.log("Numero de entidades: ", count);

        if (N <= count) {
            console.log("Numero de entidades atingido!")
            return;
        }

        let calls = []

        for (let index = 0; index < 30; index++) {
            calls.push(CreateCar(wallet))
        }

        await Promise.all(calls)

    }

}

async function CreateCarPerformance(wallet: Wallet): Promise<number> {
    var startTime = performance.now()

    await CreateCar(wallet);

    var endTime = performance.now()

    return endTime - startTime
}


async function ExecutePerformance(wallet: Wallet) {
    const count = await GetCount(wallet);
    console.log("Numero de entidades: ", count);

    // One requests to create car
    var time = await CreateCarPerformance(wallet);
    console.log(`CreateCar(1): ${time} milliseconds`)

    let calls = []

    for (let index = 0; index < 30; index++) {
        calls.push(CreateCarPerformance(wallet))
    }

    const times = await Promise.all(calls);

    const sum = times.reduce((a, b) => a + b, 0);
    const avg = (sum / times.length) || 0;

    console.log(`CreateCar(30): ${avg} milliseconds average`)
}

async function main() {
    const wallet = await createWallets()


    const answer: IPromptData = await prompt({
        type: 'select',
        name: 'answer',
        message: 'Qual mecânica quer fazer login?',
        choices: ['Numero de entidades', 'Popular base', 'Executar teste de performance']
    });


    switch (answer.answer) {
        case 'Popular base':
            await PopulateBase(wallet);
            break
        case 'Numero de entidades':
            console.log("Numero de entidades: ", await GetCount(wallet));
            break
        case 'Executar teste de performance':
            await ExecutePerformance(wallet);
            break
    }
}

main()