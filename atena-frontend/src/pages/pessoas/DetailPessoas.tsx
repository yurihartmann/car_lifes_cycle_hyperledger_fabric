import { Box, Grid, LinearProgress, Paper, Typography } from '@mui/material';
import { FormHandles } from '@unform/core';
import { Form } from '@unform/web';
import { useEffect, useRef, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { ToolBarDetails } from '../../shared/components';
import { VTextField } from '../../shared/forms';
import { PageBaseLayout } from '../../shared/layouts';
import { PessoasService } from '../../shared/services/api/pessoas/PessoasService';

interface IFormData {
    email: string;
    cidadeId: number;
    nomeCompleto: string;
}

export const DetailPessoas: React.FC = () => {

    const { id = 'add' } = useParams<'id'>();
    const navigate = useNavigate();
    const [isLoading, setIsLoading] = useState(false);
    const [nome, setNome] = useState('');

    const formRef = useRef<FormHandles>(null);

    useEffect(() => {
        if (id === 'add') {
            formRef.current?.setData({
                email: '',
                cidadeId: '',
                nomeCompleto: ''
            });
            return;
        }
        setIsLoading(true);

        PessoasService.getById(Number(id))
            .then(result => {
                setIsLoading(false);
                if (result instanceof Error) {
                    alert(result.message);
                    navigate('/pessoas');
                } else {
                    setNome(result.nomeCompleto);
                    console.log(result);
                    formRef.current?.setData(result);
                }
            });
    }, [id]);

    const handleSave = (data: IFormData) => {
        setIsLoading(true);
        if (id === 'add') {
            PessoasService.create(data)
                .then(result => {
                    setIsLoading(false);
                    if (result instanceof Error) {
                        alert(result.message);
                    } else {
                        navigate(`/pessoas/${result}`);
                    }
                });
        } else {
            PessoasService.updateById(Number(id), { id: Number(id), ...data })
                .then(result => {
                    setIsLoading(false);
                    if (result instanceof Error) {
                        alert(result.message);
                    }
                });
        }
    };

    const handleDelete = () => {
        if (confirm('Realemnte deseja apagar?')) {
            PessoasService.deleteById(Number(id))
                .then(result => {
                    if (result instanceof Error) {
                        alert(result.message);
                    } else {
                        alert('Registro apagado com sucesso!');
                        navigate('/pessoas');
                    }
                });
        }
    };

    return (
        <PageBaseLayout
            title={id === 'add' ? 'Nova Pessoa' : nome}
            toolBar={
                <ToolBarDetails
                    textButtonAdd='Nova'
                    showButtonDelete={id !== 'add'}
                    showButtonAdd={id !== 'add'}
                    showButtonSaveAndBack={true}

                    onClickButtonAdd={() => navigate('/pessoas/add')}
                    onClickButtonBack={() => navigate('/pessoas')}
                    onClickButtonDelete={handleDelete}
                    onClickButtonSave={() => formRef.current?.submitForm()}
                    onClickEmSaveAndBack={() => formRef.current?.submitForm()}

                />
            }
        >

            <Form ref={formRef} onSubmit={handleSave}>
                <Box margin={1} display="flex" flexDirection="column" component={Paper} variant="outlined">

                    <Grid container direction="column" padding={2} spacing={2}>

                        {isLoading && (
                            <Grid item>
                                <LinearProgress variant='indeterminate' />
                            </Grid>
                        )}

                        <Grid item>
                            <Typography variant='h6'>Geral</Typography>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='nomeCompleto'
                                    disabled={isLoading}
                                    label='Nome completo'
                                    onChange={e => setNome(e.target.value)}
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    name='email'
                                    label='Email'
                                    disabled={isLoading}
                                />
                            </Grid>
                        </Grid>

                        <Grid container item direction="row" spacing={2}>
                            <Grid item xs={12} sm={12} md={6} lg={4} xl={2}>
                                <VTextField
                                    fullWidth
                                    label='Cidade'
                                    name='cidadeId'
                                    disabled={isLoading}
                                />
                            </Grid>
                        </Grid>

                    </Grid>

                </Box>
            </Form>

        </PageBaseLayout>
    );
};