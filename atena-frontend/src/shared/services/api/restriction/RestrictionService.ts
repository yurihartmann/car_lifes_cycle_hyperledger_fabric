import { Environment } from '../../../environment';
import { Api } from '../axios-config';


export interface IListRestriction {
    code: number;
    description: string;
    date: string;
}

export interface IRestrictionCreate {
    code: number;
    description: string;
}

const getRestrictions = async (chassisId: string): Promise<IListRestriction[] | Error> => {
    try {
        const urlRelativa = '/evaluate/car-channel/car/Read';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data) {
            return data.restrictions || [];
        }

        return new Error('Erro ao listar os registros.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao listar os registros.');
    }
};

// const getById = async (id: number): Promise<IDetalheCidade | Error> => {
//   try {
//     const { data } = await Api.get(`/cidades/${id}`);

//     if (data) {
//       return data;
//     }

//     return new Error('Erro ao consultar o registro.');
//   } catch (error) {
//     console.error(error);
//     return new Error((error as { message: string }).message || 'Erro ao consultar o registro.');
//   }
// };

const create = async (chassisId: string, dados: Omit<IRestrictionCreate, 'id'>): Promise<boolean | Error> => {
    try {
        const { data } = await Api.put(
            '/submit/car-channel/car/AddRestriction',
            [chassisId, dados.code, dados.description]
        );

        if (data.restrictions) {
            return true;
        }

        return new Error('Erro ao criar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
    }
};

// const updateById = async (id: number, dados: IDetalheCidade): Promise<void | Error> => {
//   try {
//     await Api.put(`/cidades/${id}`, dados);
//   } catch (error) {
//     console.error(error);
//     return new Error((error as { message: string }).message || 'Erro ao atualizar o registro.');
//   }
// };

const deleteByCode = async (chassisId: string, code: number): Promise<void | Error> => {
    try {
        await Api.put('/submit/car-channel/car/DeleteRestriction',
            [chassisId, code]
        );
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao apagar o registro.');
    }
};


export const RestrictionService = {
    getRestrictions,
    create,
    deleteByCode
};
