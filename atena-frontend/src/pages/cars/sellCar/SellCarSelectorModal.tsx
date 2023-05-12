import * as React from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import { Button, Icon, IconButton, Tooltip } from '@mui/material';
import { SellCarModal } from './SellCarModal';
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

interface ISellCarSelectorModal {
    chassisId: string;
}

export const SellCarSelectorModal: React.FC<ISellCarSelectorModal> = ({ chassisId }) => {
    const [open, setOpen] = React.useState(false);
    const handleOpen = () => setOpen(true);
    const handleClose = () => setOpen(false);
    const { snackbarNotify } = useAppThemeContext();

    const handleProposeChangeCarWithConcessionaire = (chassisId: string) => {
        if (confirm('Realmente deseja fazer pedido de transferência?')) {
            snackbarNotify('Carregando...', 'info');
            CarService.proposeChangeCarWithConcessionaire(chassisId)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Pedido de transferencia efetuado!', 'success');
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    }
                });
        }
    };

    return (
        <>
            <Tooltip title="Vender carro" arrow placement="right">
                <IconButton size="small" onClick={() => handleOpen()}>
                    <Icon>sell</Icon>
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
                            Vendendendo o carro: {chassisId}
                        </Typography>

                        <Box marginBottom={2}>
                            <SellCarModal chassisId={chassisId} />
                        </Box>

                        <Box marginBottom={2}>
                            <Button size="large" variant='contained' onClick={() => handleProposeChangeCarWithConcessionaire(chassisId)}>
                                Pessoa Física {'->'} Concessionária
                            </Button>
                        </Box>


                    </Box>
                </Box>
            </Modal>
        </>
    );
};