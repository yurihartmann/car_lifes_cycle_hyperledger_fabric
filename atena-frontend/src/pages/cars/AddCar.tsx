import { useEffect, useState } from 'react';
import { Box, Grid, LinearProgress, Paper } from '@mui/material';
import { useNavigate} from 'react-router-dom';
import * as yup from 'yup';
import { IVFormErrors, VForm, VTextField, useVForm } from '../../shared/forms';
import { useAppThemeContext } from '../../shared/contexts';
import { LayoutBaseDePagina } from '../../shared/layouts';
import { FerramentasDeDetalhe } from '../../shared/components';
import { CarService } from '../../shared/services/api/cars/CarService';


interface IFormData {
    model: string;
    year: number;
    color: string;
}
const formValidationSchema: yup.Schema<IFormData> = yup.object().shape({
    year: yup.number().required().lessThan(new Date().getFullYear() + 1),
    model: yup.string().required(),
    color: yup.string().required(),
});

export const AddCar: React.FC = () => {
    const { formRef, save, saveAndClose } = useVForm();
    const [id, _] = useState<string>('nova');
    const navigate = useNavigate();
    const { snackbarNotify } = useAppThemeContext();


    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        formRef.current?.setData({
            year: '',
            model: '',
            color: '',
        });
    }, [id]);


    const handleSave = (dados: IFormData) => {
        formValidationSchema.
            validate(dados, { abortEarly: false })
            .then((dadosValidados) => {
                setIsLoading(true);

                CarService
                    .create(dadosValidados)
                    .then((result) => {
                        setIsLoading(false);

                        if (result instanceof Error) {
                            snackbarNotify(result.message, 'error');
                        } else {
                            snackbarNotify('Carro salvo com sucesso!', 'success');
                            navigate(`/cars?search=${result}`);
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
            titulo='Novo Carro'
            barraDeFerramentas={
                <FerramentasDeDetalhe
                    textoBotaoNovo='Nova'
                    mostrarBotaoNovo={id !== 'nova'}
                    mostrarBotaoApagar={false}
                    aoClicarEmSalvar={save}
                    aoClicarEmSalvarEFechar={saveAndClose}
                    aoClicarEmVoltar={() => navigate('/cars')}
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
                                    name='model'
                                    disabled={isLoading}
                                    label='Nome do modelo'
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='color'
                                    disabled={isLoading}
                                    label='Cor do carro'
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='year'
                                    label='Ano de fabricação'
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
