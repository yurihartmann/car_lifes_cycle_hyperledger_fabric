import { Button } from '@mui/material';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useAppThemeContext } from '../shared/contexts';

export const AppRoutes = () => {

    const { toggleTheme } = useAppThemeContext();

    return (
        <Routes>
            <Route path="/dashboard" element={<Button variant='contained' onClick={toggleTheme}>ALLLLOOO</Button>} />

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
}
