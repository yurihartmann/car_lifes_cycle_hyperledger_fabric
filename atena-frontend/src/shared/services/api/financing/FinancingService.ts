import { Environment } from '../../../environment';
import { Api } from '../axios-config';


const addFinancingBy = async (chassisId: string): Promise<boolean | Error> => {
    try {
        const { data } = await Api.put(
            '/submit/car-channel/car/AddFinancing',
            [chassisId]
        );

        if (!data.error) {
            return true;
        }

        return new Error(data.error);
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const removeFinancingBy = async (chassisId: string): Promise<boolean | Error> => {
    try {
        const { data } = await Api.put(
            '/submit/car-channel/car/RemoveFinancing',
            [chassisId]
        );

        if (!data.error) {
            return true;
        }

        return new Error(data.error);
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};


export const FinancingService = {
    removeFinancingBy,
    addFinancingBy
};
