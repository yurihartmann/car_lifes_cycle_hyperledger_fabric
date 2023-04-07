import axios from 'axios';

import { responseInterceptor, errorInterceptor } from './interceptors';
import { Environment } from '../../../environment';


const Api = axios.create({
    baseURL: Environment.URL_BASE,
    headers: {
        'X-API-Key': localStorage.getItem('ORG_AUTH') || ''
    }
});

Api.interceptors.response.use(
    (response) => responseInterceptor(response),
    (error) => errorInterceptor(error),
);

export { Api };
