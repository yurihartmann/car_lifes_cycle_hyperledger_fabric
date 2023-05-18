// import { Command } from 'commander';
// import { Contract } from 'fabric-network';
// import { textSync } from 'figlet';
// import { exit } from 'process';
// import { start, get } from 'prompt';
// import { createWallets, getContract } from './fabric/wallet';
// import { evaluateTransaction, submitTransaction } from './fabric/fabric';

// console.log(textSync("Mechanic CLI"));

// start();
// const ORG_NAME = 'mecanicaK';


// async function ExecuteTransaction(type: 'submit' | 'evaluate', transactionName: string, body: string[]): Promise<object> {
//     const wallet = await createWallets();
//     const contract: Contract = await getContract(
//         wallet,
//         ORG_NAME,
//         'car-channel',
//         'car'
//     );

//     var data;
//     if (type === "submit") {
//         data = await submitTransaction(contract, transactionName, body);
//     } else {
//         data = await evaluateTransaction(contract, transactionName, body);
//     }

//     let assets = {};
//     if (data.length > 0) {
//         assets = JSON.parse(data.toString());
//     }

//     return assets;
// }

// function ListCommands() {
//     console.log('');
//     console.log('------------------------------------------------------');
//     console.log('Lista de comandos');
//     console.log('list - Lista as manutenções de um carro');
//     console.log('exit - Sair');
//     console.log('------------------------------------------------------');
//     console.log('');
// }

// async function ListMaintenances() {
//     get(
//         [{
//             name: 'chassi do carro',
//             required: true
//         }],
//         async (err, result) => {
//             const asset = await ExecuteTransaction(
//                 "evaluate",
//                 "GetAll",
//                 ["123"]
//             )
//             console.log(asset);
//         }
//     )
// }

// async function cli() {
//     ListCommands();
//     get(
//         [{
//             name: 'command',
//             required: true
//         }],
//         async (err, result) => {
//             switch (result.command) {
//                 case 'list':
//                     await ListMaintenances();
//                     break;
//                 case 'exit':
//                     exit(0);
//                 default:
//                     console.log('Comando não encontrado!')
//             }
//         }
//     )
// }


// cli().then();
// cli().then();

import * as readline from 'readline';

let rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.question('Is this example useful? [y/n] ', (answer) => {
    switch (answer.toLowerCase()) {
        case 'y':
            console.log('Super!');
            break;
        case 'n':
            console.log('Sorry! :(');
            break;
        default:
            console.log('Invalid answer!');
    }
    rl.close();
});