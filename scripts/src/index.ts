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

async function GetLastCarChassisId(wallet: Wallet) {
    try {
        const contract: Contract = await getContract(wallet, "gov", "car-channel", "car");
        const data = await submitTransaction(contract, "GetPaginated", [
            "1", ""
        ]);
        const jsonData = JSON.parse(data.toString())
        return jsonData['data'][0]['chassisId'];
    }
    catch {
        console.log('Erro createCar!')
    }
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

async function AddMaintenance(wallet: Wallet, chassisId: string) {
    try {
        const contract: Contract = await getContract(wallet, "mecanicaK", "car-channel", "car");
        const data = await submitTransaction(contract, "AddMaintenance", [
            `${chassisId}`, "10000", "Teste performance"
        ]);
        console.log(JSON.parse(data.toString()));
    }
    catch {
        console.log('Erro AddMaintenance!')
    }
}


async function Read(wallet: Wallet, chassisId: string) {
    try {
        const contract: Contract = await getContract(wallet, "gov", "car-channel", "car");
        const data = await submitTransaction(contract, "Read", [
            `${chassisId}`
        ]);
        // console.log(JSON.parse(data.toString()));
    }
    catch {
        console.log('Erro Read!')
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

async function ExecuteFuncPerformance(wallet: Wallet, func: CallableFunction): Promise<number> {
    const chassisId = await GetLastCarChassisId(wallet);
    var startTime = performance.now()

    await func(wallet, chassisId);

    var endTime = performance.now()

    return endTime - startTime
}

async function ExecutePerformanceByFunc(wallet: Wallet, func: CallableFunction) {
    console.log(`Executando função: ${func.name}`)

    var time = await ExecuteFuncPerformance(wallet, func);
    console.log(`${func.name}(1): ${time} milliseconds`)

    let calls = []

    for (let index = 0; index < 30; index++) {
        calls.push(ExecuteFuncPerformance(wallet, func));
    }

    const times = await Promise.all(calls);

    const sum = times.reduce((a, b) => a + b, 0);
    const avg = (sum / times.length) || 0;

    console.log(`${func.name}(30): ${avg} milliseconds average`)
}


async function ExecutePerformance(wallet: Wallet) {
    const count = await GetCount(wallet);
    console.log("Numero de entidades: ", count);

    // await ExecutePerformanceByFunc(wallet, CreateCar);

    // await ExecutePerformanceByFunc(wallet, AddMaintenance);

    await ExecutePerformanceByFunc(wallet, Read);

    console.log(`Finalizou!`)
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