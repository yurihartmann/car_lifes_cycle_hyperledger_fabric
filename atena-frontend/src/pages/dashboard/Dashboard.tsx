import { Box, Typography } from '@mui/material';
import { useAuthContext } from '../../shared/contexts';


export const Dashboard = () => {

    const { org } = useAuthContext();


    return (
        <Box width='100%' height="100%" display="flex" flexDirection="column">
            <Box display="flex" height="100px" alignItems='center' justifyContent='center'>
                <Typography variant="h3">
                    Bem vindo {org} !!!
                </Typography>
            </Box>
            <Box display="flex" height="512px" alignItems='center' justifyContent='center'>
                <img
                    src={'car.png'}
                    alt={'logo'}
                    loading="lazy"
                />
            </Box>
        </Box>
    );
};
