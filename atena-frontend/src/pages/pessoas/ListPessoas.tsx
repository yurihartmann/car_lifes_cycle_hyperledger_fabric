import { useEffect, useMemo, useState } from 'react';
import { LinearProgress, Paper, Table, TableBody, TableCell, TableContainer, TableFooter, TableHead, TableRow } from '@mui/material';
import { useSearchParams } from 'react-router-dom';
import { ToolBarList } from '../../shared/components';
import { useDebounce } from '../../shared/hooks';
import { PageBaseLayout } from '../../shared/layouts';
import { IListagemPessoa, PessoasService } from '../../shared/services/api/pessoas/PessoasService';
import { Environment } from '../../shared/environment'

export const ListPessoas: React.FC = () => {

    const [searchParams, setSearchParams] = useSearchParams();
    const { debounce } = useDebounce();

    const [rows, setRows] = useState<IListagemPessoa[]>([]);
    const [totalCount, setTotalCount] = useState(0);
    const [isLoading, setIsLoading] = useState(true);

    const search = useMemo(() => {
        return searchParams.get('search') || '';
    }, [searchParams]);

    useEffect(() => {
        setIsLoading(true);

        debounce(() => {
            PessoasService.getAll(1, search)
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
    }, [search]);

    return (
        <PageBaseLayout
            title='Pessoas'
            toolBar={(
                <ToolBarList
                    addButtonText='Nova'
                    activeSearch={true}
                    searchText={search}
                    onChangeSearchText={text => setSearchParams({
                        search: text
                    }, { replace: true })}
                />
            )}
        >
            <TableContainer component={Paper} variant='outlined' sx={{ margin: 1, width: 'auto' }}>
                <Table>
                    <TableHead>
                        <TableRow>
                            <TableCell>Açoes</TableCell>
                            <TableCell>Nome</TableCell>
                            <TableCell>Email</TableCell>
                        </TableRow>
                    </TableHead>
                    <TableBody>
                        {rows.map(row => (
                            <TableRow key={row.id}>
                                <TableCell>Açoes</TableCell>
                                <TableCell>{row.nomeCompleto}</TableCell>
                                <TableCell>{row.email}</TableCell>
                            </TableRow>
                        ))}
                    </TableBody>

                    {totalCount === 0 && !isLoading && (
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
                    </TableFooter>
                </Table>
            </TableContainer>
        </PageBaseLayout>
    );
};