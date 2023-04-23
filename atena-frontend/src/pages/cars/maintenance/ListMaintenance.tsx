import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, IconButton, LinearProgress, Pagination, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow, Tooltip, useTheme } from '@mui/material';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../../shared/components';
import { LayoutBaseDePagina } from '../../../shared/layouts';
import { Environment } from '../../../shared/environment';
import { useDebounce } from '../../../shared/hooks';
import { useAppThemeContext } from '../../../shared/contexts';
import { IListMaintenance, MaintenanceService } from '../../../shared/services/api/maintenance/MaintenanceService';


export const ListMaintenance: React.FC = () => {
    const { debounce } = useDebounce();
    const navigate = useNavigate();
    const { snackbarNotify } = useAppThemeContext();
    const { chassisId = '' } = useParams<'chassisId'>();

    const [rows, setRows] = useState<IListMaintenance[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            MaintenanceService.getMaintenances(chassisId)
                .then((result) => {
                    setIsLoading(false);

                    if (result instanceof Error) {
                        console.log(result.message);
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Dados carregados com sucesso!', 'success');
                        setRows(result);
                    }
                });
        });
    }, []);

    return (
        <LayoutBaseDePagina
            titulo='Manutenções do carro'
            barraDeFerramentas={
                <FerramentasDaListagem
                    textoBotaoNovo='Adicionar manutenção'
                    aoClicarEmNovo={() => navigate(`/cars/${chassisId}/maintenances/add`)}
                />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 4, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Mecanica</TableCell>
                            <TableCell>KM do carro</TableCell>
                            <TableCell>Descrição</TableCell>
                            <TableCell>Data</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.date}>
                                <TableCell>{row.mechanicalName}</TableCell>
                                <TableCell>{row.carKm}</TableCell>
                                <TableCell>{row.description}</TableCell>
                                <TableCell>{row.date}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>

                    {rows.length === 0 && !isLoading && (
                        <caption>{Environment.LISTAGEM_VAZIA}</caption>
                    )}

                    <TableFooter>
                        {isLoading && (
                            <TableRow>
                                <TableCell colSpan={8}>
                                    <LinearProgress variant='indeterminate' />
                                </TableCell>
                            </TableRow>
                        )}
                    </TableFooter>
                </Table>
            </TableContainer>
        </LayoutBaseDePagina>
    );
};
