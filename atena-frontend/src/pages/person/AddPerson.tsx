import { useEffect, useState } from 'react';
import { Box, Grid, LinearProgress, Paper, Typography } from '@mui/material';
import { useNavigate, useParams } from 'react-router-dom';
import * as yup from 'yup';
import InputMask from 'react-input-mask';
import { IVFormErrors, VForm, VTextField, useVForm } from '../../shared/forms';
import { useAppThemeContext } from '../../shared/contexts';
import { LayoutBaseDePagina } from '../../shared/layouts';
import { FerramentasDeDetalhe } from '../../shared/components';
import { PersonService } from '../../shared/services/api/person/PersonService';
import { VCPFField } from '../../shared/forms/VCPFField';
import { VDateField } from '../../shared/forms/VDateField';


interface IFormData {
    cpf: string;
    name: string;
    birthday: string;
    motherName: string;
}
const formValidationSchema: yup.Schema<IFormData> = yup.object().shape({
    cpf: yup.string().required().min(14),
    name: yup.string().required().min(4),
    birthday: yup.string().required(),
    motherName: yup.string().required().min(4),
});

export const AddPerson: React.FC = () => {
    const { formRef, save, saveAndClose } = useVForm();
    const [id, _] = useState<string>('nova');
    const { cpf = '' } = useParams<'cpf'>();
    const navigate = useNavigate();
    const { snackbarNotify } = useAppThemeContext();


    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        formRef.current?.setData({
            cpf: '',
            name: '',
            birthday: '',
            motherName: '',
        });
    }, [id]);


    const handleSave = (dados: IFormData) => {
        formValidationSchema.
            validate(dados, { abortEarly: false })
            .then((dadosValidados) => {
                setIsLoading(true);

                PersonService
                    .create(dadosValidados)
                    .then((result) => {
                        setIsLoading(false);

                        if (result instanceof Error) {
                            snackbarNotify(result.message, 'error');
                        } else {
                            snackbarNotify('Pessoa salva com sucesso!', 'success');
                            navigate(`/persons?search=${result}`);
                        }
                    });
            })
            .catch((errors: yup.ValidationError) => {
                const validationErrors: IVFormErrors = {};

                errors.inner.forEach(error => {
                    if (!error.path) return;

                    validationErrors[error.path] = error.message;
                });

                formRef.current?.setErrors(validationErrors);
            });
    };


    return (
        <LayoutBaseDePagina
            titulo='Nova Pessoa'
            barraDeFerramentas={
                <FerramentasDeDetalhe
                    textoBotaoNovo='Nova'
                    mostrarBotaoNovo={id !== 'nova'}
                    mostrarBotaoApagar={false}
                    aoClicarEmSalvar={save}
                    aoClicarEmSalvarEFechar={saveAndClose}
                    aoClicarEmVoltar={() => navigate('/persons')}
                />
            }
        >
            <VForm ref={formRef} onSubmit={handleSave}>
                <Box margin={1} display="flex" flexDirection="column" component={Paper} variant="outlined" sx={{ m: 4 }}>

                    <Grid container direction="column" padding={2} spacing={2}>

                        {isLoading && (
                            <Grid item>
                                <LinearProgress variant='indeterminate' />
                            </Grid>
                        )}

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VCPFField
                                    fullWidth
                                    name='cpf'
                                    disabled={isLoading}
                                    label='CPF'

                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='name'
                                    disabled={isLoading}
                                    label='Nome'
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VDateField
                                    fullWidth
                                    name='birthday'
                                    label='Data de nascimento'
                                    disabled={isLoading}
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='motherName'
                                    label='Nome da mãe'
                                    disabled={isLoading}
                                />
                            </Grid>
                        </Grid>

                    </Grid>

                </Box>
            </VForm>
        </LayoutBaseDePagina>
    );
};
