import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { DashBoard } from '../pages';
import { useDrawerContext } from '../shared/contexts';

export const AppRoutes = () => {

    const { setDrawerOptions } = useDrawerContext();

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
            <Route path="/dashboard" element={<DashBoard />} />
            <Route path="/cidades" />

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
};
