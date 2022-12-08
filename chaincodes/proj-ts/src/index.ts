import shim = require('fabric-shim');
import { SimpleChaincode } from './simpleChaincode';

shim.start(new SimpleChaincode());
