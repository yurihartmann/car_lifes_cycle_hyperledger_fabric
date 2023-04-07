import { Environment } from '../../../environment';
import { Api } from '../axios-config';


export interface IListCar {
    brand: string;
    chassisId: string;
    color: string;
    model: string;
    ownerCpf: string;
    ownerDealershipName: string;
    year: string;
}

export interface ICarDetail {
    id: number;
    nome: string;
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

        if (data) {
            return {
                data: [data],
                bookmark: '',
            };
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

// const create = async (dados: Omit<IDetalheCidade, 'id'>): Promise<number | Error> => {
//   try {
//     const { data } = await Api.post<IDetalheCidade>('/cidades', dados);

//     if (data) {
//       return data.id;
//     }

//     return new Error('Erro ao criar o registro.');
//   } catch (error) {
//     console.error(error);
//     return new Error((error as { message: string }).message || 'Erro ao criar o registro.');
//   }
// };

// const updateById = async (id: number, dados: IDetalheCidade): Promise<void | Error> => {
//   try {
//     await Api.put(`/cidades/${id}`, dados);
//   } catch (error) {
//     console.error(error);
//     return new Error((error as { message: string }).message || 'Erro ao atualizar o registro.');
//   }
// };

// const deleteById = async (id: number): Promise<void | Error> => {
//   try {
//     await Api.delete(`/cidades/${id}`);
//   } catch (error) {
//     console.error(error);
//     return new Error((error as { message: string }).message || 'Erro ao apagar o registro.');
//   }
// };


export const CarService = {
    getPaginated
};
