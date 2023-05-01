import { Box, Typography } from '@mui/material';
import { useAuthContext } from '../../shared/contexts';


export const Dashboard = () => {

    const { org } = useAuthContext();


    return (
        <Box>
            <Box width='100%' display="flex" height="100px" alignItems='center' justifyContent='center'>
                <Typography variant="h3">Bem vindo {org} !!!</Typography>
            </Box>
            <Box width='100%' display="flex" height="200px" alignItems='center' justifyContent='center'>
                <img
                    src={'logo512.png'}
                    alt={'logo'}
                    loading="lazy"
                />
            </Box>
        </Box>
    );
};
