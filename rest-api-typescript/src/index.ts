import { portServer } from './configs/config';
import { createServer } from './utils/server'

async function main() {
    console.log('Creating REST server');
    const app = await createServer();


    console.log('Starting REST server');
    app.listen(portServer, () => {
        console.log(`REST server started on port: ${portServer}`);
    });
}

main().catch(async (err) => {
    console.log({ err }, 'Unxepected error');
});