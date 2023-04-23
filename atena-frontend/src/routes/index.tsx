import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';

import { useDrawerContext } from '../shared/contexts';
import {
    Dashboard,
    DetalheDePessoas,
    ListagemDePessoas,
    DetalheDeCidades,
    ListagemDeCidades,
    ListCar,
    ListRestriction
} from '../pages';
import { AddRestriction } from '../pages/cars/restriction/AddRestriction';
import { ListMaintenance } from '../pages/cars/maintenance/ListMaintenance';
import { AddMaintenance } from '../pages/cars/maintenance/AddMaintenance';

export const AppRoutes = () => {
    const { setDrawerOptions } = useDrawerContext();

    useEffect(() => {
        setDrawerOptions([
            {
                icon: 'home',
                path: '/pagina-inicial',
                label: 'Página inicial',
            },
            {
                icon: 'location_city',
                path: '/cidades',
                label: 'Cidades',
            },
            {
                icon: 'people',
                path: '/pessoas',
                label: 'Pessoas',
            },
            {
                icon: 'directions_car',
                path: '/cars',
                label: 'Carros',
            },
            {
                icon: 'car_rental',
                path: '/get-car-to-sell',
                label: 'Adquirir carro para venda',
            },
            {
                icon: 'sell',
                path: '/sell-car',
                label: 'Vender um carro',
            },
            {
                icon: 'document_scanner',
                path: '/licensing',
                label: 'Licenciar',
            }
        ]);
    }, []);

    return (
        <Routes>
            <Route path="/pagina-inicial" element={<Dashboard />} />

            <Route path="/pessoas" element={<ListagemDePessoas />} />
            <Route path="/pessoas/detalhe/:id" element={<DetalheDePessoas />} />

            <Route path="/cidades" element={<ListagemDeCidades />} />
            <Route path="/cidades/detalhe/:id" element={<DetalheDeCidades />} />

            <Route path="/cars" element={<ListCar />} />

            <Route path="/cars/:chassisId/restrictions" element={<ListRestriction />} />
            <Route path="/cars/:chassisId/restrictions/add" element={<AddRestriction />} />

            <Route path="/cars/:chassisId/maintenances" element={<ListMaintenance />} />
            <Route path="/cars/:chassisId/maintenances/add" element={<AddMaintenance />} />


            <Route path="*" element={<Navigate to="/pagina-inicial" />} />
        </Routes>
    );
};
