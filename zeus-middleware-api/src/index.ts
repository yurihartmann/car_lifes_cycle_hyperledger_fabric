import { port } from '../env.json';
import { createWallets } from './fabric/wallet';
import { createServer } from './utils/server'

async function main() {
    console.log('Creating REST server');
    const app = await createServer();

    app.locals['wallet'] = await createWallets();
     
    // await configureContracts(app, wallet);

    console.log('Starting REST server');
    app.listen(port, () => {
        console.log(`REST server started on port: ${port}`);
    });
}

main().catch(async (err) => {
    console.log({ err }, 'Unxepected error');
});