import { useEffect, useState } from 'react';
import { Box, Grid, LinearProgress, Paper } from '@mui/material';
import { useNavigate, useParams } from 'react-router-dom';
import * as yup from 'yup';
import { IVFormErrors, VForm, VTextField, useVForm } from '../../../shared/forms';
import { LayoutBaseDePagina } from '../../../shared/layouts';
import { FerramentasDeDetalhe } from '../../../shared/components';
import { useAppThemeContext } from '../../../shared/contexts';
import { MaintenanceService } from '../../../shared/services/api/maintenance/MaintenanceService';



interface IFormData {
    carKm: number;
    description: string;
}
const formValidationSchema: yup.Schema<IFormData> = yup.object().shape({
    carKm: yup.number().required(),
    description: yup.string().required(),
});

export const AddMaintenance: React.FC = () => {
    const { formRef, save } = useVForm();
    const [id, _] = useState<string>('nova');
    const { chassisId = '' } = useParams<'chassisId'>();
    const navigate = useNavigate();
    const { snackbarNotify } = useAppThemeContext();


    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        formRef.current?.setData({
            carKm: '',
            description: ''
        });
    }, [id]);


    const handleSave = (dados: IFormData) => {
        formValidationSchema.
            validate(dados, { abortEarly: false })
            .then((dadosValidados) => {
                setIsLoading(true);

                MaintenanceService
                    .create(chassisId, dadosValidados)
                    .then((result) => {
                        setIsLoading(false);

                        if (result instanceof Error) {
                            snackbarNotify(result.message, 'error');
                        } else {
                            snackbarNotify('Manutenção salva com sucesso!', 'success');
                            navigate(`/cars/${chassisId}/maintenances`);
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
            titulo='Nova Manutenção'
            barraDeFerramentas={
                <FerramentasDeDetalhe
                    textoBotaoNovo='Nova'
                    mostrarBotaoNovo={false}
                    mostrarBotaoApagar={false}
                    aoClicarEmSalvar={save}
                    aoClicarEmVoltar={() => navigate(`/cars/${chassisId}/maintenances`)}
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
                                    name='carKm'
                                    disabled={isLoading}
                                    label='Kilometragem do carro'
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
