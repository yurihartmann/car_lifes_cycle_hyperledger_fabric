import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, IconButton, LinearProgress, Pagination, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow, Tooltip, useTheme } from '@mui/material';
import { useNavigate, useParams, useSearchParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../../shared/components';
import { LayoutBaseDePagina } from '../../../shared/layouts';
import { Environment } from '../../../shared/environment';
import { useDebounce } from '../../../shared/hooks';
import { useAppThemeContext } from '../../../shared/contexts';
import { RestrictionService, IListRestriction } from '../../../shared/services/api/restriction/RestrictionService';


export const ListRestriction: React.FC = () => {
    const { debounce } = useDebounce();
    const navigate = useNavigate();
    const theme = useTheme();
    const { snackbarNotify } = useAppThemeContext();
    const { chassisId = '' } = useParams<'chassisId'>();

    const [rows, setRows] = useState<IListRestriction[]>([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            RestrictionService.getRestrictions(chassisId)
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

    const handleDelete = (code: number) => {
        if (confirm('Realmente deseja apagar?')) {
            RestrictionService.deleteByCode(chassisId, code)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        setRows(oldRows => [
                            ...oldRows.filter(oldRow => oldRow.code !== code),
                        ]);
                        snackbarNotify('Restrição apagada com sucesso!', 'success');
                    }
                });
        }
    };


    return (
        <LayoutBaseDePagina
            titulo='Restrições do carro'
            barraDeFerramentas={
                <FerramentasDaListagem
                    textoBotaoNovo='Nova'
                    aoClicarEmNovo={() => navigate(`/cars/${chassisId}/restrictions/add`)}
                />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 4, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Código</TableCell>
                            <TableCell>Descrição</TableCell>
                            <TableCell>Data</TableCell>
                            <TableCell></TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.code}>
                                <TableCell>{row.code}</TableCell>
                                <TableCell>{row.description}</TableCell>
                                <TableCell>{row.date}</TableCell>
                                <TableCell>
                                    <Tooltip title="Deletar" arrow placement="right">
                                        <IconButton size="small" onClick={() => handleDelete(row.code)}>
                                            <Icon>delete_icon</Icon>
                                        </IconButton>
                                    </Tooltip>
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
