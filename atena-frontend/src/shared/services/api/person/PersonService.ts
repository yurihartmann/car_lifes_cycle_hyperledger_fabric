import { Environment } from '../../../environment';
import { Api } from '../axios-config';

type DriverLicense = {
    cnhNumber: number;
    dueDate: string;
}

export interface IPersonCreate {
    cpf: string;
    name: string;
    birthday: string;
    motherName: string;
}

export interface IPersonList {
    name: string;
    motherName: string;
    alive: boolean;
    cpf: string;
    birthday: string;
    driverLicense: DriverLicense;
}


type TPersonPagination = {
    data: IPersonList[];
    bookmark: string;
}

const getPaginated = async (chassisId = '', bookmark = ''): Promise<TPersonPagination | Error> => {
    try {
        if (!chassisId) {
            const urlRelativa = '/evaluate/person-channel/person/GetPaginated';

            const { data } = await Api.put(urlRelativa, [
                Environment.LIMITE_DE_LINHAS.toString(), bookmark
            ]);

            if (data.metadata) {
                return {
                    data: data.data,
                    bookmark: data.metadata.bookmark,
                };
            }
        }
        const urlRelativa = '/evaluate/person-channel/person/Read';

        const { data } = await Api.put(urlRelativa, [
            chassisId
        ]);

        if (data.name) {
            return {
                data: [data],
                bookmark: '',
            };
        }

        return new Error(data.error || 'Erro ao listar os registros.');
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

const create = async (dados: IPersonCreate): Promise<string | Error> => {
    try {
        const urlRelativa = '/submit/person-channel/person/CreatePerson';

        const { data } = await Api.put(urlRelativa, [
            dados.cpf, dados.name, dados.birthday, dados.motherName
        ]);

        if (data.cpf) {
            return data.cpf;
        }

        return new Error(data.error || 'Erro ao criar o registro.');
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

const declareDeathPerson = async (cpf: string): Promise<void | Error> => {
    try {
        const urlRelativa = '/submit/person-channel/person/DeclareDeathPerson';

        const { data } = await Api.put(urlRelativa, [
            cpf
        ]);

        if (data.cpf) {
            return data.cpf;
        }

        return new Error(data.error || 'Erro ao salvar o registro.');
    } catch (error) {
        console.error(error);
        return new Error((error as { message: string }).message || 'Erro ao salvar o registro.');
    }
};


export const PersonService = {
    getPaginated,
    create,
    declareDeathPerson
};
