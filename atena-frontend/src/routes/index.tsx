import { useEffect } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';

import { useDrawerContext } from '../shared/contexts';
import { AddRestriction } from '../pages/cars/restriction/AddRestriction';
import { ListMaintenance } from '../pages/cars/maintenance/ListMaintenance';
import { AddMaintenance } from '../pages/cars/maintenance/AddMaintenance';
import { AddCar } from '../pages/cars/AddCar';
import { ListPerson } from '../pages/person/ListPerson';
import { AddPerson } from '../pages/person/AddPerson';
import { ListCar } from '../pages/cars/ListCars';
import { ListRestriction } from '../pages/cars/restriction/ListRestriction';
import { Dashboard } from '../pages/dashboard/Dashboard';
import { ListTransfersHistory } from '../pages/cars/transfersHistory/ListTransfersHistory';

export const AppRoutes = () => {
    const { setDrawerOptions } = useDrawerContext();

    useEffect(() => {
        setDrawerOptions([
            {
                icon: 'home',
                path: '/dashboard',
                label: 'Página inicial',
            },
            {
                icon: 'people',
                path: '/persons',
                label: 'Pessoas',
            },
            {
                icon: 'directions_car',
                path: '/cars',
                label: 'Carros',
            },
            // {
            //     icon: 'document_scanner',
            //     path: '/licensing',
            //     label: 'Licenciar',
            // }
        ]);
    }, []);

    return (
        <Routes>
            <Route path="/dashboard" element={<Dashboard />} />

            <Route path="/persons" element={<ListPerson />} />
            <Route path="/persons/add" element={<AddPerson />} />

            <Route path="/cars" element={<ListCar />} />
            <Route path="/cars/add" element={<AddCar />} />

            <Route path="/cars/:chassisId/restrictions" element={<ListRestriction />} />
            <Route path="/cars/:chassisId/restrictions/add" element={<AddRestriction />} />

            <Route path="/cars/:chassisId/maintenances" element={<ListMaintenance />} />
            <Route path="/cars/:chassisId/maintenances/add" element={<AddMaintenance />} />

            <Route path="/cars/:chassisId/transfers-history" element={<ListTransfersHistory />} />
            

            <Route path="*" element={<Navigate to="/dashboard" />} />
        </Routes>
    );
};
