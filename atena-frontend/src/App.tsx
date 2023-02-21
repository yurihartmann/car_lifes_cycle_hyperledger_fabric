import { BrowserRouter } from 'react-router-dom';
import { AppRoutes } from './routes';
import { Menu } from './shared/components';
import { AppThemeProvider } from './shared/contexts';

export const App = () => {
    return (
        <AppThemeProvider>
            <BrowserRouter>
                <Menu>
                    <AppRoutes />
                </Menu>
            </BrowserRouter>
        </AppThemeProvider>
    );
};
