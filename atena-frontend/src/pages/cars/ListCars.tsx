import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, IconButton, LinearProgress, Pagination, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow, useTheme } from '@mui/material';
import { useNavigate, useSearchParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../shared/components';
import { LayoutBaseDePagina } from '../../shared/layouts';
import { Environment } from '../../shared/environment';
import { useDebounce } from '../../shared/hooks';
import { CarService, IListCar } from '../../shared/services/api/cars/CarService';


export const ListCar: React.FC = () => {
    const [searchParams, setSearchParams] = useSearchParams();
    const { debounce } = useDebounce();
    const navigate = useNavigate();
    const theme = useTheme();

    const [rows, setRows] = useState<IListCar[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [bookmark, setBookmark] = useState<string>('');
    const [saveBookmark, setSaveBookmark] = useState<string>('');

    const search = useMemo(() => {
        return searchParams.get('search') || '';
    }, [searchParams]);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            CarService.getPaginated(search, bookmark)
                .then((result) => {
                    setIsLoading(false);

                    if (result instanceof Error) {
                        console.log(result.message);
                    } else {
                        console.log(result);
                        setRows([...rows, ...result.data]);
                        setSaveBookmark(result.bookmark);
                    }
                });
        });
    }, [search, bookmark]);

    // const handleDelete = (id: number) => {
    //     if (confirm('Realmente deseja apagar?')) {
    //         CidadesService.deleteById(id)
    //             .then(result => {
    //                 if (result instanceof Error) {
    //                     alert(result.message);
    //                 } else {
    //                     setRows(oldRows => [
    //                         ...oldRows.filter(oldRow => oldRow.id !== id),
    //                     ]);
    //                     alert('Registro apagado com sucesso!');
    //                 }
    //             });
    //     }
    // };


    return (
        <LayoutBaseDePagina
            titulo='Listagem de carros'
            barraDeFerramentas={
                <FerramentasDaListagem
                    mostrarInputBusca
                    textoDaBusca={search}
                    textoBotaoNovo='Novo'
                    // aoClicarEmNovo={() => navigate('/cidades/detalhe/nova')}
                    aoMudarTextoDeBusca={texto => setSearchParams({ search: texto }, { replace: true })}
                />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 1, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell width={100}>Ações</TableCell>
                            <TableCell>ID do chassi</TableCell>
                            <TableCell>Marca</TableCell>
                            <TableCell>Modelo</TableCell>
                            <TableCell>Cor</TableCell>
                            <TableCell>CPF do dono</TableCell>
                            <TableCell>Concessionaria</TableCell>
                            <TableCell>Ano</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.chassisId}>
                                <TableCell>
                                    <IconButton size="small" onClick={() => alert('Restricoes')}>
                                        <Icon>car_repair</Icon>
                                    </IconButton>
                                    <IconButton size="small" onClick={() => alert('Manutencoes')}>
                                        <Icon>car_crash</Icon>
                                    </IconButton>
                                    <IconButton size="small" onClick={() => alert('Seguro')}>
                                        <Icon>shield</Icon>
                                    </IconButton>
                                </TableCell>
                                <TableCell>{row.chassisId}</TableCell>
                                <TableCell>{row.brand}</TableCell>
                                <TableCell>{row.model}</TableCell>
                                <TableCell>{row.color}</TableCell>
                                <TableCell>{row.ownerCpf || '-'}</TableCell>
                                <TableCell>{row.ownerDealershipName || '-'}</TableCell>
                                <TableCell>{row.year}</TableCell>
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
                {saveBookmark && (
                    <Box flex={1} margin={theme.spacing(2)} display="flex" justifyContent="center" alignItems="center" >
                        <Button
                            color='primary'
                            disableElevation
                            variant='text'
                            onClick={() => setBookmark(saveBookmark)}
                        >Carregar Mais...</Button>

                    </Box>
                )}
            </TableContainer>
        </LayoutBaseDePagina>
    );
};
