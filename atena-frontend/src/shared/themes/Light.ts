import { createTheme } from '@mui/material';
import { cyan, blueGrey } from '@mui/material/colors';

export const LightTheme = createTheme({
    palette: {
        primary: {
            main: cyan[700],
            dark: cyan[800],
            light: cyan[500],
            contrastText: '#ffffff',
        },
        secondary: {
            main: blueGrey[500],
            dark: blueGrey[400],
            light: blueGrey[300],
            contrastText: '#ffffff',
        },
        background: {
            paper: '#ffffff',
            default: '#f7f6f3',
        }
    }
});