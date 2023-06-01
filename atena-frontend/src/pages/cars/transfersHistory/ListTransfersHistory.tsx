import { useEffect, useState } from 'react';
import { LinearProgress, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow } from '@mui/material';
import { useParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../../shared/components';
import { LayoutBaseDePagina } from '../../../shared/layouts';
import { Environment } from '../../../shared/environment';
import { useDebounce } from '../../../shared/hooks';
import { useAppThemeContext } from '../../../shared/contexts';
import { CarService, ITransfersHistory } from '../../../shared/services/api/cars/CarService';


export const ListTransfersHistory: React.FC = () => {
    const { debounce } = useDebounce();
    const { snackbarNotify } = useAppThemeContext();
    const { chassisId = '' } = useParams<'chassisId'>();

    const [rows, setRows] = useState<ITransfersHistory[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            CarService.getTransfersHistory(chassisId)
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
            titulo='Histórico de tranferências'
            barraDeFerramentas={
                <FerramentasDaListagem />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 4, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Data</TableCell>
                            <TableCell>Concessionária</TableCell>
                            <TableCell>CPF</TableCell>
                            <TableCell>Tipo</TableCell>
                            <TableCell>Valor</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.date}>
                                <TableCell>{new Date(row.date).toLocaleString('pt-BR')}</TableCell>
                                <TableCell>{row.ownerDealershipName}</TableCell>
                                <TableCell>{row.ownerCpf}</TableCell>
                                <TableCell>{row.type}</TableCell>
                                <TableCell>
                                    {(row.amount < 0) && (
                                        <span>Valor oculto</span>
                                    )}
                                    {(row.amount >= 0) && (
                                        <span>R$ {row.amount}</span>
                                    )}
                                </TableCell>
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
