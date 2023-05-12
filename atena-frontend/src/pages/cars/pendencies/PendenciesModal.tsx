import * as React from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import { Button, Icon, IconButton, Tooltip } from '@mui/material';
import { useAppThemeContext } from '../../../shared/contexts';
import { CarService } from '../../../shared/services/api/cars/CarService';

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

interface IPendenciesModal {
    GetCarToOwnerCpfFromDealershipName: string;
    chassisId: string
}

export const PendenciesModal: React.FC<IPendenciesModal> = ({ GetCarToOwnerCpfFromDealershipName, chassisId }) => {
    const [open, setOpen] = React.useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
    const { snackbarNotify } = useAppThemeContext();

    const handleConfirmChangeCarWithConcessionaire = () => {
        snackbarNotify('Carregando...', 'info');
        CarService.confirmChangeCarWithConcessionaire(chassisId)
            .then(result => {
                if (result instanceof Error) {
                    snackbarNotify(result.message, 'error');
                } else {
                    snackbarNotify('Transferência efetuada!', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 3000);
                }
            });
    };

    const handleDeniedChangeCarWithConcessionaire = () => {
        snackbarNotify('Carregando...', 'info');
        CarService.deniedChangeCarWithConcessionaire(chassisId)
            .then(result => {
                if (result instanceof Error) {
                    snackbarNotify(result.message, 'error');
                } else {
                    snackbarNotify('Transferência cancelada!', 'success');
                    setTimeout(() => {
                        window.location.reload();
                    }, 3000);
                }
            });
    };

    return (
        <>
            <Tooltip title="Ver pendências" arrow placement="right">
                <IconButton size="small" onClick={() => handleOpen()}>
                    <Icon>priority_high</Icon>
                </IconButton>
            </Tooltip>
            <Modal
                open={open}
                onClose={handleClose}
                aria-labelledby="modal-modal-title"
                aria-describedby="modal-modal-description"
            >
                <Box sx={style}>
                    <Box display="flex" flexDirection="column" alignItems="center" justifyContent="center">
                        <Typography id="modal-modal-title" variant="h6" component="h2" marginBottom={2}>
                            A Concessionaria {GetCarToOwnerCpfFromDealershipName} fez o pedido para transferir o carro para ela?
                        </Typography>
                        <Box marginBottom={2}>
                            <Button
                                color="success"
                                disableElevation
                                variant='contained'
                                onClick={handleConfirmChangeCarWithConcessionaire}
                                startIcon={<Icon>check</Icon>}
                            >
                                <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                                    Efetuar transferência!
                                </Typography>
                            </Button>
                        </Box>
                        <Button
                            color="error"
                            disableElevation
                            variant='contained'
                            onClick={handleDeniedChangeCarWithConcessionaire}
                            startIcon={<Icon>do_not_disturb</Icon>}
                        >
                            <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                                Cancelar transferência!
                            </Typography>
                        </Button>
                    </Box>
                </Box>
            </Modal>
        </>
    );
};