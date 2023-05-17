import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Icon, IconButton, LinearProgress, Link, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow, Tooltip, useTheme } from '@mui/material';
import { useNavigate, useSearchParams } from 'react-router-dom';

import { FerramentasDaListagem } from '../../shared/components';
import { LayoutBaseDePagina } from '../../shared/layouts';
import { Environment } from '../../shared/environment';
import { useDebounce } from '../../shared/hooks';
import { CarService, IListCar } from '../../shared/services/api/cars/CarService';
import { useAppThemeContext } from '../../shared/contexts';
import { FinancingService } from '../../shared/services/api/financing/FinancingService';
import { SellCarSelectorModal } from './sellCar/SellCarSelectorModal';
import { PendenciesModal } from './pendencies/PendenciesModal';




export const ListCar: React.FC = () => {
    const [searchParams, setSearchParams] = useSearchParams();
    const { debounce } = useDebounce();
    const navigate = useNavigate();
    const theme = useTheme();
    const { snackbarNotify } = useAppThemeContext();

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
                        snackbarNotify(result.message, 'error');
                    } else {
                        // snackbarNotify('Dados carregados com sucesso!', 'success');

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

    const handleRemoveFinancingBy = (chassisId: string) => {
        if (confirm('Realmente deseja remover o financiamento')) {
            snackbarNotify('Carregando....', 'info');
            FinancingService.removeFinancingBy(chassisId)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Financiamento removido com sucesso!', 'success');
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    }
                });
        }
    };

    const handleAddFinancingBy = (chassisId: string) => {
        if (confirm('Realmente deseja adicionar o financiamento')) {
            snackbarNotify('Carregando....', 'info');
            FinancingService.addFinancingBy(chassisId)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Financiamento adicionado com sucesso!', 'success');
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    }
                });
        }
    };

    const handleGetCarToSell = (chassisId: string) => {
        if (confirm('Realmente deseja adquirir o carro?')) {
            snackbarNotify('Carregando....', 'info');
            CarService.getCarToSell(chassisId)
                .then(result => {
                    if (result instanceof Error) {
                        snackbarNotify(result.message, 'error');
                    } else {
                        snackbarNotify('Carro adquirido com sucesso!', 'success');
                        setTimeout(() => {
                            window.location.reload();
                        }, 2000);
                    }
                });
        }
    };

    const copyTextToClipboard = (text: string) => {
        if ('clipboard' in navigator) {
            return navigator.clipboard.writeText(text).then(
                () => {
                    snackbarNotify('Copiado!', 'success');
                }
            );
        } else {
            return document.execCommand('copy', true, text);
        }
    };

    return (
        <LayoutBaseDePagina
            titulo='Listagem de carros'
            barraDeFerramentas={
                <FerramentasDaListagem
                    mostrarInputBusca
                    textoDaBusca={search}
                    textoBotaoNovo='Inserir carro'
                    aoClicarEmNovo={() => navigate('/cars/add')}
                    aoMudarTextoDeBusca={texto => setSearchParams({ search: texto }, { replace: true })}
                />
            }
        >
            <TableContainer component={Paper} variant="outlined" sx={{ m: 4, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Ações</TableCell>
                            <TableCell>ID do chassi</TableCell>
                            <TableCell>Marca</TableCell>
                            <TableCell>Modelo</TableCell>
                            <TableCell>Cor</TableCell>
                            <TableCell>CPF do dono</TableCell>
                            <TableCell>Concessionaria</TableCell>
                            <TableCell>Ano</TableCell>
                            <TableCell>Financiado por</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <>
                                <TableRow key={row.chassisId}>
                                    <TableCell>
                                        <Tooltip title="Restrições" arrow placement="top">
                                            <IconButton size="small" onClick={() => navigate(`/cars/${row.chassisId}/restrictions`)}>
                                                <Icon>car_crash</Icon>
                                            </IconButton>
                                        </Tooltip>
                                        <Tooltip title="Manuteções" arrow placement="top">
                                            <IconButton size="small" onClick={() => navigate(`/cars/${row.chassisId}/maintenances`)}>
                                                <Icon>car_repair</Icon>
                                            </IconButton>
                                        </Tooltip>
                                        <Tooltip title="Histórico de tranferências" arrow placement="top">
                                            <IconButton size="small" onClick={() => navigate(`/cars/${row.chassisId}/transfers-history`)}>
                                                <Icon>notes</Icon>
                                            </IconButton>
                                        </Tooltip>
                                        <SellCarSelectorModal
                                            chassisId={row.chassisId}
                                        />
                                        {row.pendencies?.getCarToOwnerCpfFromDealershipName && (
                                            <PendenciesModal
                                                getCarToOwnerCpfFromDealershipName={row.pendencies?.getCarToOwnerCpfFromDealershipName}
                                                getCarToOwnerCpfFromAmount={row.pendencies?.getCarToOwnerCpfFromAmount}
                                                chassisId={row.chassisId}
                                            />
                                        )}
                                    </TableCell>
                                    <TableCell>
                                        {row.chassisId.slice(0, 12)}...
                                        <Tooltip title="Copiar" arrow placement="right">
                                            <IconButton size="small" onClick={() => copyTextToClipboard(row.chassisId)}>
                                                <Icon>copy_all</Icon>
                                            </IconButton>
                                        </Tooltip>
                                    </TableCell>
                                    <TableCell>{row.brand}</TableCell>
                                    <TableCell>{row.model}</TableCell>
                                    <TableCell>{row.color}</TableCell>
                                    <TableCell>
                                        {row.ownerCpf && (
                                            <Link href={`/persons?search=${row.ownerCpf}`} underline="none">
                                                {row.ownerCpf}
                                            </Link>
                                        )}
                                        {!row.ownerCpf && (
                                            <span>-</span>
                                        )}
                                    </TableCell>
                                    <TableCell>
                                        {row.ownerDealershipName && (
                                            row.ownerDealershipName
                                        )}
                                        {row.ownerCpf && (
                                            <span>Já possue um dono!</span>
                                        )}
                                        {!row.ownerDealershipName && !row.ownerCpf && (
                                            <Tooltip title="Adquirir carro para venda" arrow placement="right">
                                                <IconButton size="small" onClick={() => handleGetCarToSell(row.chassisId)}>
                                                    <Icon>car_rental</Icon>
                                                </IconButton>
                                            </Tooltip>
                                        )}
                                    </TableCell>
                                    <TableCell>{row.year}</TableCell>
                                    <TableCell>
                                        {row.financingBy}
                                        {
                                            !row.financingBy && (
                                                <IconButton size="small" onClick={() => handleAddFinancingBy(row.chassisId)}>
                                                    <Icon>add_cicle</Icon>
                                                </IconButton>
                                            )
                                        }
                                        {
                                            row.financingBy && (
                                                <IconButton size="small" onClick={() => handleRemoveFinancingBy(row.chassisId)}>
                                                    <Icon>delete_icon</Icon>
                                                </IconButton>
                                            )
                                        }
                                        {/* <IconButton size="small" onClick={() => alert('Financiamento')}>
                                        <Icon>add_cicle</Icon>
                                    </IconButton>
                                    <IconButton size="small" onClick={() => alert('Financiamento')}>
                                        <Icon>delete_icon</Icon>
                                    </IconButton> */}
                                    </TableCell>
                                </TableRow>
                            </>
                        ))}
                    </TableBody>

                    {rows.length === 0 && !isLoading && (
                        <caption>{Environment.LISTAGEM_VAZIA}</caption>
                    )}

                    <TableFooter>
                        {isLoading && (
                            <TableRow>
                                <TableCell colSpan={9}>
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
