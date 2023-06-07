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

async function CreateBulkCar(wallet: Wallet) {
    try {
        let cars: string[] = [];
        for (let index = 0; index < 100; index++) {
            cars.push(`${uuidv4()}`);
        }

        const contract: Contract = await getContract(wallet, "montadoraC", "car-channel", "car");
        const data = await submitTransaction(contract, "AddBulkCar", [
            cars.join(";")
        ]);
        //console.log(JSON.parse(data.toString()));
    }
    catch {
        console.log('Erro createCar!')
    }
}

// async function AddMaintenance(wallet: Wallet, chassisId: string) {
//     try {
//         const contract: Contract = await getContract(wallet, "mecanicaK", "car-channel", "car");
//         const data = await submitTransaction(contract, "AddMaintenance", [
//             `${chassisId}`, "10000", "Teste performance"
//         ]);
//         console.log(JSON.parse(data.toString()));
//     }
//     catch {
//         console.log('Erro AddMaintenance!')
//     }
// }


async function Read(wallet: Wallet, chassisId: string) {
    try {
        const contract: Contract = await getContract(wallet, "montadoraC", "car-channel", "car");
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
        const data = await evaluateTransaction(contract, "Count", []);

        const json_data: ICount = JSON.parse(data.toString());
        // console.log(json_data);
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

        // await CreateBulkCar(wallet);

        let calls = []

        for (let index = 0; index < 10; index++) {
            calls.push(CreateBulkCar(wallet))
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

function average(times: number[]): number {
    const sum = times.reduce((a, b) => a + b, 0);
    const avg = (sum / times.length) || 0;
    return avg;
}

async function ExecutePerformanceByFunc(wallet: Wallet, func: CallableFunction) {
    console.log(`\n\nExecutando função: ${func.name}\n`)

    let times_1: number[] = [];

    for (let index = 0; index < 3; index++) {
        var time = await ExecuteFuncPerformance(wallet, func);
        console.log(`Rodado ${func.name}(1): ${time} milliseconds`)
        times_1.push(time);
    }

    console.log(`\nMédia de 3 rodadas ${func.name}(1): ${average(times_1)} milliseconds average \n`)

    let times_30: number[] = [];

    for (let index = 0; index < 3; index++) {
        let calls = []

        for (let index = 0; index < 30; index++) {
            calls.push(ExecuteFuncPerformance(wallet, func));
        }

        const times = await Promise.all(calls);

        console.log(`Rodado ${func.name}(30): ${average(times)} milliseconds`)

        times_30.push(average(times));
    }

    console.log(`\nMédia de 3 rodadas ${func.name}(30): ${average(times_30)} milliseconds average \n`)
}


async function ExecutePerformance(wallet: Wallet) {
    const count = await GetCount(wallet);
    console.log("Numero de entidades: ", count);

    await ExecutePerformanceByFunc(wallet, Read);
    await ExecutePerformanceByFunc(wallet, CreateCar);

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