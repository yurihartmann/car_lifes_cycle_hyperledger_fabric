import { Chaincode, Helpers, NotFoundError, StubHelper } from '@theledger/fabric-chaincode-utils';
import * as Yup from 'yup';

export class SimpleChaincode extends Chaincode {
  async initLedger(stubHelper: StubHelper, args: string[]) {
    await stubHelper.putState('a', 100);
    await stubHelper.putState('b', 200);

    this.logger.info('successfully init chaincode');
  }

  async getAsset(stubHelper: StubHelper, args: string[]): Promise<any> {
    const verifiedArgs = await Helpers.checkArgs<{ key: string }>(args[0], Yup.object()
      .shape({
        key: Yup.string().required(),
      }));

    const value = await stubHelper.getStateAsString(verifiedArgs.key);

    if (!value) {
      throw new NotFoundError('asset is not existed');
    }

    return value;
  }

  async setAsset(stubHelper: StubHelper, args: string[]) {
    const verifiedArgs = await Helpers.checkArgs<{ key: string, value: number }>(args[0], Yup.object()
      .shape({
        key: Yup.string().required(),
        value: Yup.number().required(),
      }));

    await stubHelper.putState(verifiedArgs.key, verifiedArgs.value);

    this.logger.info(`successfully set asset ${verifiedArgs.key} = ${verifiedArgs.value}`);
  }
}
