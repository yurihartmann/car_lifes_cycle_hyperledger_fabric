import { useEffect, useState } from 'react';
import { Box, Grid, LinearProgress, Paper, Typography } from '@mui/material';
import { useNavigate, useParams } from 'react-router-dom';
import * as yup from 'yup';
import { IVFormErrors, VForm, VTextField, useVForm } from '../../../shared/forms';
import { RestrictionService } from '../../../shared/services/api/restriction/RestrictionService';
import { LayoutBaseDePagina } from '../../../shared/layouts';
import { FerramentasDeDetalhe } from '../../../shared/components';
import { useAppThemeContext } from '../../../shared/contexts';



interface IFormData {
    code: number;
    description: string;
}
const formValidationSchema: yup.Schema<IFormData> = yup.object().shape({
    code: yup.number().required(),
    description: yup.string().required(),
});

export const AddMaintenance: React.FC = () => {
    const { formRef, save, saveAndClose, isSaveAndClose } = useVForm();
    const [id, _] = useState<string>('nova');
    const { chassisId = '' } = useParams<'chassisId'>();
    const navigate = useNavigate();
    const { snackbarNotify } = useAppThemeContext();


    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        formRef.current?.setData({
            code: '',
            description: ''
        });
    }, [id]);


    const handleSave = (dados: IFormData) => {
        console.log('AQUI');
        formValidationSchema.
            validate(dados, { abortEarly: false })
            .then((dadosValidados) => {
                setIsLoading(true);

                RestrictionService
                    .create(chassisId, dadosValidados)
                    .then((result) => {
                        setIsLoading(false);

                        if (result instanceof Error) {
                            snackbarNotify(result.message, 'error');
                        } else {
                            snackbarNotify('Restrição salva com sucesso!', 'success');
                            navigate(`/cars/${chassisId}/restrictions`);
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

    // const handleDelete = (id: number) => {
    //     if (confirm('Realmente deseja apagar?')) {
    //         PessoasService.deleteById(id)
    //             .then(result => {
    //                 if (result instanceof Error) {
    //                     alert(result.message);
    //                 } else {
    //                     alert('Registro apagado com sucesso!');
    //                     navigate('/pessoas');
    //                 }
    //             });
    //     }
    // };


    return (
        <LayoutBaseDePagina
            titulo='Nova restrição'
            barraDeFerramentas={
                <FerramentasDeDetalhe
                    textoBotaoNovo='Nova'
                    mostrarBotaoNovo={id !== 'nova'}
                    mostrarBotaoApagar={false}
                    aoClicarEmSalvar={save}
                    aoClicarEmSalvarEFechar={saveAndClose}
                    aoClicarEmVoltar={() => navigate(`/cars/${chassisId}/restrictions`)}
                // aoClicarEmApagar={() => handleDelete(Number(id))}
                // aoClicarEmNovo={() => navigate('/pessoas/detalhe/nova')}
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
                                <VTextField
                                    fullWidth
                                    name='code'
                                    disabled={isLoading}
                                    label='Numero inteiro'
                                // onChange={e => setNome(e.target.value)}
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='description'
                                    label='Descrição'
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
