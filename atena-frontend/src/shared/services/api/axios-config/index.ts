import axios from 'axios';
import { Environment } from '../../../environment';
import { errorInterceptor, responseInterceptor } from './interceptors';

const Api = axios.create({
    baseURL: Environment.API_URL_BASE
});

Api.interceptors.response.use(
    (response) => responseInterceptor(response),
    (error) => errorInterceptor(error),
);

export { Api };