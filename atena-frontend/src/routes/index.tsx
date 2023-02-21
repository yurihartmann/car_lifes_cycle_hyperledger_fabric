import { Button } from '@mui/material';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useDrawerContext } from '../shared/contexts';

export const AppRoutes = () => {

    const { toggleDrawerOpen } = useDrawerContext();

    return (
        <Routes>
            <Route path="/dashboard" element={<Button variant='contained' onClick={toggleDrawerOpen}>ALLLLOOO</Button>} />

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
};
