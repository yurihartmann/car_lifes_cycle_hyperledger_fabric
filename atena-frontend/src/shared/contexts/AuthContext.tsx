import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';


interface IAuthContextData {
    logout: () => void;
    isAuthenticated: boolean;
    org: string;
    login: (org: string) => Promise<string | void>;
}

const AuthContext = createContext({} as IAuthContextData);

const LOCAL_STORAGE_KEY__ACCESS_TOKEN = 'ORG_AUTH';

interface IAuthProviderProps {
    children: React.ReactNode;
}
export const AuthProvider: React.FC<IAuthProviderProps> = ({ children }) => {
    const [accessToken, setAccessToken] = useState<string>();

    useEffect(() => {
        const accessToken = localStorage.getItem(LOCAL_STORAGE_KEY__ACCESS_TOKEN);

        if (accessToken) {
            setAccessToken(accessToken);
        } else {
            setAccessToken(undefined);
        }
    }, []);


    const handleLogin = useCallback(async (org: string) => {
        localStorage.setItem(LOCAL_STORAGE_KEY__ACCESS_TOKEN, org);
        setAccessToken(org);
    }, []);

    const handleLogout = useCallback(() => {
        localStorage.removeItem(LOCAL_STORAGE_KEY__ACCESS_TOKEN);
        setAccessToken(undefined);
    }, []);

    const isAuthenticated = useMemo(() => !!accessToken, [accessToken]);

    const org = useMemo(() => accessToken || '', [accessToken]);

    return (
        <AuthContext.Provider value={{ isAuthenticated, org, login: handleLogin, logout: handleLogout }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuthContext = () => useContext(AuthContext);
