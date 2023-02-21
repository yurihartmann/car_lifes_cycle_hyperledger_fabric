import { Icon, IconButton, Typography, useMediaQuery, useTheme } from '@mui/material';
import { Box } from '@mui/system';
import { useDrawerContext } from '../contexts';

interface IPageBaseLayoutProps {
    title: string;
    toolBar?: React.ReactNode
    children: React.ReactNode
}

export const PageBaseLayout: React.FC<IPageBaseLayoutProps> = ({ children, title, toolBar }) => {

    const theme = useTheme();
    const smDown = useMediaQuery(theme.breakpoints.down('sm'));
    const mdDown = useMediaQuery(theme.breakpoints.down('md'));

    const { toggleDrawerOpen } = useDrawerContext();

    return (
        <Box height='100%' display='flex' flexDirection='column' gap={1}>
            <Box padding={1} display='flex' alignItems='center' gap={1} height={theme.spacing(smDown ? 6 : mdDown ? 8 : 12)}>

                {smDown && (
                    <IconButton onClick={toggleDrawerOpen}>
                        <Icon>menu</Icon>
                    </IconButton>
                )}

                <Typography
                    variant={smDown ? 'h5' : mdDown ? 'h4' : 'h3'}
                    whiteSpace='nowrap'
                    overflow='hidden'
                    textOverflow='ellipses'
                >
                    {title}
                </Typography>
            </Box>

            {toolBar && (
                <Box>
                    {toolBar}
                </Box>
            )}

            <Box flex={1} overflow='auto'>
                {children}
            </Box>

        </Box>
    );
};