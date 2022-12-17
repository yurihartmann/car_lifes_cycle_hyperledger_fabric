import { portServer } from './configs/config';
import { createWallets, configureContracts } from './fabric/wallet';
import { createServer } from './utils/server'

async function main() {
    console.log('Creating REST server');
    const app = await createServer();

    const wallet = await createWallets();

    await configureContracts(app, wallet);

    console.log('Starting REST server');
    app.listen(portServer, () => {
        console.log(`REST server started on port: ${portServer}`);
    });
}

main().catch(async (err) => {
    console.log({ err }, 'Unxepected error');
});