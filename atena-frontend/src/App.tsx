import { BrowserRouter } from 'react-router-dom';
import { AppRoutes } from './routes';
import { Menu } from './shared/components';
import { AppThemeProvider, DrawerProvider } from './shared/contexts';

export const App = () => {
    return (
        <AppThemeProvider>
            <DrawerProvider>
                <BrowserRouter>
                    <Menu>
                        <AppRoutes />
                    </Menu>
                </BrowserRouter>
            </DrawerProvider>
        </AppThemeProvider>
    );
};
