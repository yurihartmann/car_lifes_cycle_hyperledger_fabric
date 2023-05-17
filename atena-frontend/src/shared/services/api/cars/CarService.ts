import { Environment } from '../../../environment';
import { Api } from '../axios-config';
import { v4 as uuidv4 } from 'uuid';

interface IPendencies {
    getCarToOwnerCpfFromDealershipName?: string;
    getCarToOwnerCpfFromAmount?: string;
}

export interface IListCar {
    brand: string;
    chassisId: string;
    color: string;
    model: string;
    ownerCpf: string;
    ownerDealershipName: string;
    year: string;
    financingBy: string;
    pendencies?: IPendencies;
}

export interface ITransfersHistory {
    amount: number;
    date: string;
    ownerCpf: string;
    ownerDealershipName: string;
    type: string;
}

export interface ICarDetail {
    id: number;
    nome: string;
}

export interface ICarCreate {
    model: string;
    year: number;
    color: string;
}

type TCarPagination = {
    data: IListCar[];
    bookmark: string;
}

const getPaginated = async (chassisId = '', bookmark = ''): Promise<TCarPagination | Error> => {
    try {
        if (!chassisId) {
            const urlRelativa = '/evaluate/car-channel/car/GetPaginated';

            const { data } = await Api.put(urlRelativa, [
                Environment.LIMITE_DE_LINHAS.toString(), bookmark
            ]);

            if (data) {
                return {
                    data: data.data,
                    bookmark: data.metadata.bookmark,
                };
            }
        }
        const urlRelativa = '/evaluate/car-channel/car/Read';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data.error) {
            return {
                data: [],
                bookmark: '',
            };
        }

        return {
            data: [data],
            bookmark: '',
        };

    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao listar os registros.');
    }
};

const getTransfersHistory = async (chassisId: string): Promise<ITransfersHistory[] | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/GetTransfersHistory';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (!data.error) {
            return data;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const create = async (dados: ICarCreate): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/AddCar';

        const { data } = await Api.put(urlRelativa, [
            uuidv4(), dados.model, dados.year.toString(), dados.color
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const getCarToSell = async (chassisId: string): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/GetCarToSell';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const sellCar = async (chassisId: string, cpf: string, amount: number): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/SellCar';

        const { data } = await Api.put(urlRelativa, [
            chassisId, cpf, amount
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const proposeChangeCarWithConcessionaire = async (chassisId: string, amount: number): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/ProposeChangeCarWithConcessionaire';

        const { data } = await Api.put(urlRelativa, [
            chassisId, amount
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const confirmChangeCarWithConcessionaire = async (chassisId: string): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/ConfirmChangeCarWithConcessionaire';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const deniedChangeCarWithConcessionaire = async (chassisId: string): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/DeniedChangeCarWithConcessionaire';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

const changeCarWithOtherPerson = async (chassisId: string, newOwnercpf: string, amount: number): Promise<null | Error> => {
    try {
        const urlRelativa = '/submit/car-channel/car/ChangeCarWithOtherPerson';

        const { data } = await Api.put(urlRelativa, [
            chassisId, newOwnercpf, amount
        ]);

        if (data.chassisId) {
            return data.chassisId;
        }

        return new Error(data.error || 'Erro ao salvar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};


export const CarService = {
    getPaginated,
    create,
    getCarToSell,
    sellCar,
    proposeChangeCarWithConcessionaire,
    confirmChangeCarWithConcessionaire,
    deniedChangeCarWithConcessionaire,
    changeCarWithOtherPerson,
    getTransfersHistory,
};
