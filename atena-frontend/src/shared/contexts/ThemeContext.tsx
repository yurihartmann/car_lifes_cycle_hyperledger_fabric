import { createContext, useCallback, useContext, useMemo, useState } from 'react';
import { Alert, Snackbar, ThemeProvider, AlertColor } from '@mui/material';
import { Box } from '@mui/system';

import { DarkTheme, LightTheme } from './../themes';

interface IThemeContextData {
    themeName: 'light' | 'dark';
    toggleTheme: () => void;
    snackbarNotify: (message: string, type: 'success' | 'info' | 'warning' | 'error') => void;
}

const ThemeContext = createContext({} as IThemeContextData);

export const useAppThemeContext = () => {
    return useContext(ThemeContext);
};

interface IAppThemeProviderProps {
    children: React.ReactNode
}
export const AppThemeProvider: React.FC<IAppThemeProviderProps> = ({ children }) => {
    const [themeName, setThemeName] = useState<'light' | 'dark'>('dark');
    const [snackbarOpen, setSnackbarOpen] = useState(true);
    const [snackbarMessage, setSnackbarMessage] = useState('');
    const [snackbarType, setSnackbarType] = useState<AlertColor>('info');


    const handleSnackbarClose = (event?: React.SyntheticEvent | Event, reason?: string) => {
        if (reason === 'clickaway') {
            return;
        }

        setSnackbarOpen(false);
    };

    const toggleTheme = useCallback(() => {
        setThemeName(oldThemeName => oldThemeName === 'light' ? 'dark' : 'light');
    }, []);

    const theme = useMemo(() => {
        if (themeName === 'light') return LightTheme;

        return DarkTheme;
    }, [themeName]);

    const snackbarNotify = useCallback((message: string, type: 'success' | 'info' | 'warning' | 'error') => {
        setSnackbarOpen(true);
        setSnackbarMessage(message);
        setSnackbarType(type);
    }, []);

    return (
        <ThemeContext.Provider value={{ themeName, toggleTheme, snackbarNotify }}>
            <ThemeProvider theme={theme}>
                <Box width="100vw" height="100vh" bgcolor={theme.palette.background.default}>

                    {snackbarMessage && (
                        <Snackbar
                            open={snackbarOpen}
                            autoHideDuration={20000}
                            onClose={handleSnackbarClose}
                            anchorOrigin={{ vertical: 'bottom', horizontal: 'right' }}
                        >
                            <Alert onClose={handleSnackbarClose} severity={snackbarType} sx={{ width: '100%' }}>
                                {snackbarMessage}
                            </Alert>
                        </Snackbar>
                    )}

                    {children}
                </Box>
            </ThemeProvider>
        </ThemeContext.Provider >
    );
};
