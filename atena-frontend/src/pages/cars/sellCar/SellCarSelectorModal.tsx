import * as React from 'react';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Modal from '@mui/material/Modal';
import { Button, Icon, IconButton, Tooltip } from '@mui/material';
import { SellCarModal } from './SellCarModal';
import { useAppThemeContext } from '../../../shared/contexts';
import { CarService } from '../../../shared/services/api/cars/CarService';
import { ChangeCarWithOtherPersonModal } from './ChangeCarWithOtherPersonModal';
import { ProposeChangeCarWithConcessionaireModal } from './ProposeChangeCarWithConcessionaireModal';

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
                            Menu de venda do carro: {chassisId}
                        </Typography>

                        <Box marginBottom={2}>
                            <SellCarModal chassisId={chassisId} />
                        </Box>

                        <Box marginBottom={2}>
                            <ProposeChangeCarWithConcessionaireModal chassisId={chassisId} />
                        </Box>

                        <Box marginBottom={2}>
                            <ChangeCarWithOtherPersonModal chassisId={chassisId} />
                        </Box>

                    </Box>
                </Box>
            </Modal>
        </>
    );
};