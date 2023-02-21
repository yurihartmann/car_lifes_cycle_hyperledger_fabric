
import { Box, Button, Divider, Icon, Paper, Skeleton, Theme, Typography, useMediaQuery, useTheme } from '@mui/material';


interface IToolBarDetailsProps {
    textButtonAdd?: string;

    showButtonAdd?: boolean;
    showButtonBack?: boolean;
    showButtonDelete?: boolean;
    showButtonSave?: boolean;
    showButtonSaveAndBack?: boolean;

    showButtonAddLoading?: boolean;
    showButtonBackLoading?: boolean;
    showButtonDeleteLoading?: boolean;
    showButtonSaveLoading?: boolean;
    showButtonSaveAndBackLoading?: boolean;

    onClickButtonAdd?: () => void;
    onClickButtonBack?: () => void;
    onClickButtonDelete?: () => void;
    onClickButtonSave?: () => void;
    onClickEmSaveAndBack?: () => void;
}

export const ToolBarDetails: React.FC<IToolBarDetailsProps> = ({
    textButtonAdd = 'Novo',

    showButtonAdd = true,
    showButtonBack = true,
    showButtonDelete = true,
    showButtonSave = true,
    showButtonSaveAndBack = false,

    showButtonAddLoading = false,
    showButtonBackLoading = false,
    showButtonDeleteLoading = false,
    showButtonSaveLoading = false,
    showButtonSaveAndBackLoading = false,

    onClickButtonAdd,
    onClickButtonBack,
    onClickButtonDelete,
    onClickButtonSave,
    onClickEmSaveAndBack,
}) => {
    const smDown = useMediaQuery((theme: Theme) => theme.breakpoints.down('sm'));
    const mdDown = useMediaQuery((theme: Theme) => theme.breakpoints.down('md'));
    const theme = useTheme();

    return (
        <Box
            gap={1}
            marginX={1}
            padding={1}
            paddingX={2}
            display="flex"
            alignItems="center"
            height={theme.spacing(5)}
            component={Paper}
        >
            {(showButtonSave && !showButtonSaveLoading) && (
                <Button
                    color='primary'
                    disableElevation
                    variant='contained'
                    onClick={onClickButtonSave}
                    startIcon={<Icon>save</Icon>}
                >
                    <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                        Salvar
                    </Typography>
                </Button>
            )}

            {showButtonSaveLoading && (
                <Skeleton width={110} height={60} />
            )}

            {(showButtonSaveAndBack && !showButtonSaveAndBackLoading && !smDown && !mdDown) && (
                <Button
                    color='primary'
                    disableElevation
                    variant='outlined'
                    onClick={onClickEmSaveAndBack}
                    startIcon={<Icon>save</Icon>}
                >
                    <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                        Salvar e fechar
                    </Typography>
                </Button>
            )}

            {(showButtonSaveAndBackLoading && !smDown && !mdDown) && (
                <Skeleton width={180} height={60} />
            )}

            {(showButtonDelete && !showButtonDeleteLoading) && (
                <Button
                    color='primary'
                    disableElevation
                    variant='outlined'
                    onClick={onClickButtonDelete}
                    startIcon={<Icon>delete</Icon>}
                >
                    <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                        Apagar
                    </Typography>
                </Button>
            )}

            {showButtonDeleteLoading && (
                <Skeleton width={110} height={60} />
            )}

            {(showButtonAdd && !showButtonAddLoading && !smDown) && (
                <Button
                    color='primary'
                    disableElevation
                    variant='outlined'
                    onClick={onClickButtonAdd}
                    startIcon={<Icon>add</Icon>}
                >
                    <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                        {textButtonAdd}
                    </Typography>
                </Button>
            )}

            {(showButtonAddLoading && !smDown) && (
                <Skeleton width={110} height={60} />
            )}

            {
                (
                    showButtonBack &&
                    (showButtonAdd || showButtonDelete || showButtonSave || showButtonSaveAndBack)
                ) && (
                    <Divider variant='middle' orientation='vertical' />
                )
            }

            {(showButtonBack && !showButtonBackLoading) && (
                <Button
                    color='primary'
                    disableElevation
                    variant='outlined'
                    onClick={onClickButtonBack}
                    startIcon={<Icon>arrow_back</Icon>}
                >
                    <Typography variant='button' whiteSpace="nowrap" textOverflow="ellipsis" overflow="hidden">
                        Voltar
                    </Typography>
                </Button>
            )}

            {showButtonBackLoading && (
                <Skeleton width={110} height={60} />
            )}
        </Box >
    );
};