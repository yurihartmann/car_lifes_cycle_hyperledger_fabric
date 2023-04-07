import { useState } from 'react';
import { Box, Button, Card, CardActions, CardContent, CircularProgress, TextField, Typography } from '@mui/material';
import * as yup from 'yup';

import { useAuthContext } from '../../contexts';
import { Environment } from '../../environment';

const loginSchema = yup.object().shape({
    org: yup.string().required().oneOf(Environment.LIST_OF_ORGS)
});

interface ILoginProps {
    children: React.ReactNode;
}
export const Login: React.FC<ILoginProps> = ({ children }) => {
    const { isAuthenticated, login } = useAuthContext();

    const [isLoading, setIsLoading] = useState(false);
    const [org, setOrg] = useState('');
    const [orgError, setOrgError] = useState('');


    const handleSubmit = () => {
        setIsLoading(true);

        loginSchema
            .validate({ org }, { abortEarly: false })
            .then(dadosValidados => {
                login(dadosValidados.org)
                    .then(() => {
                        setIsLoading(false);
                    });
            })
            .catch((errors: yup.ValidationError) => {
                setIsLoading(false);

                errors.inner.forEach(error => {
                    setOrgError(error.message);
                });
            });
    };


    if (isAuthenticated) return (
        <>{children}</>
    );

    return (
        <Box width='100vw' height='100vh' display='flex' alignItems='center' justifyContent='center'>

            <Card>
                <CardContent>
                    <Box display='flex' flexDirection='column' gap={2} width={250}>
                        <Typography variant='h6' align='center'>Identifique-se</Typography>

                        <TextField
                            fullWidth
                            type='email'
                            label='Email'
                            value={org}
                            disabled={isLoading}
                            error={!!orgError}
                            helperText={orgError}
                            onKeyDown={() => setOrgError('')}
                            onChange={e => setOrg(e.target.value)}
                        />
                    </Box>
                </CardContent>
                <CardActions>
                    <Box width='100%' display='flex' justifyContent='center'>

                        <Button
                            variant='contained'
                            disabled={isLoading}
                            onClick={handleSubmit}
                            endIcon={isLoading ? <CircularProgress variant='indeterminate' color='inherit' size={20} /> : undefined}
                        >
                            Entrar
                        </Button>

                    </Box>
                </CardActions>
            </Card>
        </Box>
    );
};
