import { Button } from '@mui/material';
import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useDrawerContext } from '../shared/contexts';

export const AppRoutes = () => {

    const { toggleDrawerOpen, setDrawerOptions } = useDrawerContext();

    useEffect(() => {
        setDrawerOptions([
            {
                label: 'Dashboard',
                icon: 'home',
                path: '/dashboard'
            },
            {
                label: 'Cidades',
                icon: 'star',
                path: '/cidades'
            }
        ]);
    }, []);

    return (
        <Routes>
            <Route path="/dashboard" element={<Button variant='contained' onClick={toggleDrawerOpen}>ALLLLOOO</Button>} />
            <Route path="/cidades" />

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
};
