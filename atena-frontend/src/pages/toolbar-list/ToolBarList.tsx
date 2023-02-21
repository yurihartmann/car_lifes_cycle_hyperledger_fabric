import { Box, Button, TextField, Paper, useTheme, Icon } from '@mui/material';

interface IToolBarListProps {
    searchText?: string;
    activeSearch?: boolean;
    onChangeSearchText?: (searchText: string) => void;
    addButtonText?: string;
    activeAddButton?: boolean;
    onClickAddButton?: () => void;
}

export const ToolBarList: React.FC<IToolBarListProps> = ({
    searchText = '',
    activeSearch = false,
    onChangeSearchText,
    addButtonText = 'Novo',
    activeAddButton = true,
    onClickAddButton
}) => {

    const theme = useTheme();

    return (
        <Box
            height={theme.spacing(5)}
            marginX={1}
            padding={1}
            paddingX={2}
            display='flex'
            alignItems='center'
            gap={1}
            component={Paper}
        >
            {activeSearch && (
                <TextField
                    size='small'
                    placeholder='Perquisar...'
                    value={searchText}
                    onChange={(e) => onChangeSearchText?.(e.target.value)}
                />
            )}

            <Box flex={1} display="flex" justifyContent='end'>
                {activeAddButton && (
                    <Button variant='contained' endIcon={<Icon>add</Icon>} onClick={onClickAddButton}>
                        {addButtonText}
                    </Button>
                )}
            </Box>
        </Box>
    );
};