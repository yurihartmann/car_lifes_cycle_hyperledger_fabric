import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { DashBoard, ListPessoas } from '../pages';
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
                label: 'Pessoas',
                icon: 'person',
                path: '/pessoas'
            }
        ]);
    }, []);

    return (
        <Routes>
            <Route path="/dashboard" element={<DashBoard />} />
            <Route path="/pessoas" element={<ListPessoas />} />

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
};
