import { useEffect, useMemo, useState } from 'react';
import { Icon, IconButton, LinearProgress, Pagination, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow } from '@mui/material';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { ToolBarList } from '../../shared/components';
import { useDebounce } from '../../shared/hooks';
import { PageBaseLayout } from '../../shared/layouts';
import { IListagemPessoa, PessoasService } from '../../shared/services/api/pessoas/PessoasService';
import { Environment } from '../../shared/environment';

export const ListPessoas: React.FC = () => {

    const [searchParams, setSearchParams] = useSearchParams();
    const { debounce } = useDebounce();
    const navigate = useNavigate();

    const [rows, setRows] = useState<IListagemPessoa[]>([]);
    const [totalCount, setTotalCount] = useState(0);
    const [isLoading, setIsLoading] = useState(true);

    const search = useMemo(() => {
        return searchParams.get('search') || '';
    }, [searchParams]);

    const page = useMemo(() => {
        return Number(searchParams.get('page') || 1);
    }, [searchParams]);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            PessoasService.getAll(page, search)
                .then((result) => {
                    if (result instanceof Error) {
                        alert(result.message);
                    } else {
                        setRows(result.data);
                        setTotalCount(result.totalCount);
                    }
                    setIsLoading(false);
                });
        });
    }, [search, page]);

    const handleDelete = (id: number) => {
        if (confirm('Realmente deseja apagar?')) {
            PessoasService.deleteById(id).then(result => {
                if (result instanceof Error) {
                    alert(result.message);
                } else {
                    setRows(oldRows => [
                        ...oldRows.filter(oldRow => oldRow.id !== id),
                    ]);
                    alert('Registro apagado com sucesso!');
                }
            });
        }
    };

    return (
        <PageBaseLayout
            title='Pessoas'
            toolBar={(
                <ToolBarList
                    addButtonText='Nova'
                    activeSearch={true}
                    searchText={search}
                    onClickAddButton={() => navigate('/pessoas/add')}
                    onChangeSearchText={text => setSearchParams({
                        search: text, page: '1'
                    }, { replace: true })}
                />
            )}
        >
            <TableContainer component={Paper} variant='outlined' sx={{ margin: 1, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Nome</TableCell>
                            <TableCell>Email</TableCell>
                            <TableCell>Açoes</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.id}>
                                <TableCell>{row.nomeCompleto}</TableCell>
                                <TableCell>{row.email}</TableCell>
                                <TableCell>
                                    <IconButton size='small' onClick={() => handleDelete(row.id)}>
                                        <Icon>delete</Icon>
                                    </IconButton>
                                    <IconButton size='small' onClick={() => navigate(`/pessoas/${row.id}`)}>
                                        <Icon>edit</Icon>
                                    </IconButton>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>

                    {(totalCount === 0 && !isLoading) && (
                        <caption>{Environment.EMPTY_LIST}</caption>
                    )}

                    <TableFooter>
                        {isLoading && (
                            <TableRow>
                                <TableCell colSpan={15}>
                                    <LinearProgress variant='indeterminate' />
                                </TableCell>
                            </TableRow>
                        )}
                        {(totalCount > 0 && totalCount > Environment.LINES_LIMIT) && (
                            <TableRow>
                                <TableCell colSpan={15}>
                                    <Pagination
                                        page={page}
                                        count={Math.ceil(totalCount / Environment.LINES_LIMIT)}
                                        onChange={(e, newPage) => {
                                            setSearchParams({
                                                search, page: newPage.toString()
                                            }, { replace: true });
                                        }}
                                    />
                                </TableCell>
                            </TableRow>
                        )}
                    </TableFooter>
                </Table>
            </TableContainer>
        </PageBaseLayout>
    );
};