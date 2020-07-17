import rosettaApiJson from '../../../rosetta-specifications/api.json';
import packageJson from '../../../package.json';

export const ROSETTA_VERSION = rosettaApiJson.info.version;
export const MIDDLEWARE_VERSION = packageJson.version;

export const CARDANO = 'cardano';

export enum operationType {
  TRANSFER = 'transfer'
}

enum operationTypeStatus {
  SUCCESS = 'success'
}

export const TRANSFER_OPERATION_TYPE = 'transfer';
export const SUCCESS_STATUS = 'success';

export const SUCCESS_OPERATION_STATE = {
  status: operationTypeStatus.SUCCESS,
  successful: true
};
