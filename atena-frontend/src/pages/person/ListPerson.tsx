import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, IconButton, LinearProgress, Pagination, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow, Tooltip, useTheme } from '@mui/material';
import { useNavigate, useSearchParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../shared/components';
import { LayoutBaseDePagina } from '../../shared/layouts';
import { Environment } from '../../shared/environment';
import { useDebounce } from '../../shared/hooks';
import { useAppThemeContext } from '../../shared/contexts';
import { IPersonList, PersonService } from '../../shared/services/api/person/PersonService';


export const ListPerson: React.FC = () => {
    const [searchParams, setSearchParams] = useSearchParams();
    const { debounce } = useDebounce();
    const navigate = useNavigate();
    const theme = useTheme();
    const { snackbarNotify } = useAppThemeContext();

    const [rows, setRows] = useState<IPersonList[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [bookmark, setBookmark] = useState<string>('');
    const [saveBookmark, setSaveBookmark] = useState<string>('');

    const search = useMemo(() => {
        return searchParams.get('search') || '';
    }, [searchParams]);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            PersonService.getPaginated(search, bookmark)
                .then((result) => {
                    setIsLoading(false);

                    if (result instanceof Error) {
                        console.log(result.message);
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Dados carregados com sucesso!', 'success');

                        if (search === '') {
                            setSaveBookmark(result.bookmark);

                            if (saveBookmark !== '') {
                                setRows([...rows, ...result.data]);
                            } else {
                                setRows([...result.data]);
                            }
                        } else {
                            console.log('search');
                            setRows(result.data);
                            setSaveBookmark('');
                        }
                    }
                });
        });
    }, [search, bookmark]);

    const handleDeclareDeathPerson = (cpf: string) => {
        if (confirm('Realmente deseja declarar morte?')) {
            snackbarNotify('Carregando....', 'info');
            PersonService.declareDeathPerson(cpf)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Salvo com sucesso!', 'success');
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    }
                });
        }
    };

    return (
        <LayoutBaseDePagina
            titulo='Listagem de pessoas'
            barraDeFerramentas={
                <FerramentasDaListagem
                    mostrarInputBusca
                    textoDaBusca={search}
                    textoBotaoNovo='Adicionar pessoa'
                    aoClicarEmNovo={() => navigate('/persons/add')}
                    aoMudarTextoDeBusca={texto => setSearchParams({ search: texto }, { replace: true })}
                />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 4, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>CPF</TableCell>
                            <TableCell>Nome</TableCell>
                            <TableCell>Data de nascimento</TableCell>
                            <TableCell>Viva?</TableCell>
                            <TableCell>Nome da mãe</TableCell>
                            {/* <TableCell>CNH</TableCell> */}
                            {/* <TableCell>Vencimento CNH</TableCell>
                            <TableCell>Situação CNH</TableCell>
                            <TableCell></TableCell> */}
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.cpf}>
                                <TableCell>{row.cpf}</TableCell>
                                <TableCell>{row.name}</TableCell>
                                <TableCell>{row.birthday}</TableCell>
                                {row.alive && (
                                    <TableCell>
                                        Viva
                                        <Tooltip title="Declarar morte" arrow placement="right">
                                            <IconButton size="small" onClick={() => handleDeclareDeathPerson(row.cpf)}>
                                                <Icon>person_off</Icon>
                                            </IconButton>
                                        </Tooltip>
                                    </TableCell>
                                )}
                                {!row.alive && (
                                    <TableCell>Morta</TableCell>
                                )}

                                <TableCell>{row.motherName}</TableCell>
                                {/* <TableCell>{row.driverLicense?.cnhNumber || '-'}</TableCell>
                                <TableCell>{row.driverLicense?.dueDate || '-'}</TableCell>
                                <TableCell>{'Normal'}</TableCell>
                                <TableCell>
                                    {
                                        !row.driverLicense?.cnhNumber && (
                                            <IconButton size="small" onClick={() => alert('Adicionar CNH')}>
                                                <Icon>note_add</Icon>
                                            </IconButton>
                                        )
                                    }
                                    {
                                        row.driverLicense?.cnhNumber && (
                                            <IconButton size="small" onClick={() => alert('Remover CNH')}>
                                                <Icon>history</Icon>
                                            </IconButton>
                                        )
                                    }
                                </TableCell> */}
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
