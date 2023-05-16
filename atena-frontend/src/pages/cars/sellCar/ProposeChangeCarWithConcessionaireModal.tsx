import { useState } from 'react';
import * as yup from 'yup';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import { Button, Grid, Icon } from '@mui/material';
import { CarService } from '../../../shared/services/api/cars/CarService';
import { useAppThemeContext } from '../../../shared/contexts';
import { IVFormErrors, VForm, VTextField, useVForm } from '../../../shared/forms';
import { useNavigate } from 'react-router-dom';

const style = {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    width: 800,
    bgcolor: 'background.paper',
    border: '2px solid #000',
    boxShadow: 24,
    p: 4,
};

interface IProposeChangeCarWithConcessionaireModal {
    chassisId: string;
}

interface IFormData {
    amount: number;
}
const formValidationSchema: yup.Schema<IFormData> = yup.object().shape({
    amount: yup.number().required().moreThan(0),
});

export const ProposeChangeCarWithConcessionaireModal: React.FC<IProposeChangeCarWithConcessionaireModal> = ({ chassisId }) => {
    const [open, setOpen] = useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
    const { snackbarNotify } = useAppThemeContext();
    const navigate = useNavigate();

    const [isLoading, setIsLoading] = useState(false);
    const { formRef, save } = useVForm();

    const handleSave = (dados: IFormData) => {
        formValidationSchema.
            validate(dados, { abortEarly: false })
            .then((dadosValidados) => {
                setIsLoading(true);
                snackbarNotify('Carregando...', 'info');
                CarService
                    .proposeChangeCarWithConcessionaire(chassisId, dadosValidados.amount)
                    .then((result) => {
                        setIsLoading(false);

                        if (result instanceof Error) {
                            snackbarNotify(result.message, 'error');
                        } else {
                            snackbarNotify('Pedido de transferencia efetuado!', 'success');
                            navigate(`/cars?search=${chassisId}`);
                            setTimeout(() => {
                                window.location.reload();
                            }, 1000);
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
        <>
            <Button size="large" variant='contained' onClick={() => handleOpen()}>
                Pessoa Física {'->'} Concessionária
            </Button>
            <Modal
                open={open}
                onClose={handleClose}
                aria-labelledby="modal-modal-title"
                aria-describedby="modal-modal-description"
            >
                <Box sx={style}>
                    <Typography id="modal-modal-title" variant="h6" component="h2">
                        Fazendo pedido de tranferência de uma pessoa física para uma concessionária
                    </Typography>
                    <VForm ref={formRef} onSubmit={handleSave}>
                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} marginY={2}>
                                <VTextField
                                    fullWidth
                                    name='amount'
                                    label='Valor da venda'
                                    disabled={isLoading}
                                />
                            </Grid>
                        </Grid>
                    </VForm>
                    <Button
                        color='primary'
                        disableElevation
                        variant='contained'
                        onClick={save}
                        startIcon={<Icon>save</Icon>}
                        disabled={isLoading}
                    >
                        <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                            Efetuar troca!
                        </Typography>
                    </Button>
                </Box>
            </Modal>
        </>
    );
};