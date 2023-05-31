import { Contract, Wallet } from 'fabric-network';
import { createWallets, getContract, submitTransaction } from './fabric';
import { prompt } from 'enquirer';

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

async function getMaintenances(wallet: Wallet, orgName: string) {
    const chassisId: IPromptData = await prompt({
        type: 'input',
        name: 'answer',
        message: 'Qual o chassi do carro?',
    });

    console.log('Chassi do carro informado: ', chassisId.answer)
    try {
        const contract: Contract = await getContract(wallet, orgName, "car-channel", "car");
        const data = await submitTransaction(contract, "Read", [chassisId.answer]);
        const car: ICar = JSON.parse(data.toString());

        car.maintenances.forEach(element => {
            console.log('==========================');
            console.log('Data: ', element.date);
            console.log('KM do carro: ', element.carKm);
            console.log('Descrição: ', element.description);
            console.log('Mecânica: ', element.mechanicalName);
        });
    }
    catch {
        console.log('Erro!')
    }
}


async function createMaintenance(wallet: Wallet, orgName: string) {
    const chassisId: IPromptData = await prompt({
        type: 'input',
        name: 'answer',
        message: 'Qual o chassi do carro?',
    });

    const carKm: IPromptData = await prompt({
        type: 'input',
        name: 'answer',
        message: 'Qual a KM do carro?',
    });

    const description: IPromptData = await prompt({
        type: 'input',
        name: 'answer',
        message: 'Descrição: ',
    });

    try {
        const contract: Contract = await getContract(wallet, orgName, "car-channel", "car");
        const data = await submitTransaction(contract, "AddMaintenance", [
            chassisId.answer, carKm.answer, description.answer
        ]);
        const car: ICar = JSON.parse(data.toString());

        const element = car.maintenances[car.maintenances.length - 1]
        console.log('===========================');
        console.log('== Manutenção Adicionada ==');
        console.log('===========================');
        console.log('Data: ', element.date);
        console.log('KM do carro: ', element.carKm);
        console.log('Descrição: ', element.description);
        console.log('Mecânica: ', element.mechanicalName);

    }
    catch {
        console.log('Erro!')
    }
}


async function main() {
    const wallet = await createWallets()


    const mechanic: IPromptData = await prompt({
        type: 'select',
        name: 'answer',
        message: 'Qual mecânica quer fazer login?',
        choices: ['mecanicaL', 'mecanicaK']
    });


    console.log("Logado como: ", mechanic.answer);
    const mechanicMSP = mechanic.answer;

    while (true) {
        console.log('\n\n==========================\n');
        const answer: IPromptData = await prompt({
            type: 'select',
            name: 'answer',
            message: 'Oque deseja fazer?',
            choices: ['Ver histórico', 'Adicionar manutenção', 'Sair']
        });

        if (answer.answer === 'Sair') {
            break;
        }

        switch (answer.answer) {
            case 'Ver histórico':
                await getMaintenances(wallet, mechanicMSP);
                break
            case 'Adicionar manutenção':
                await createMaintenance(wallet, mechanicMSP);
                break
        }
    }
}

main()