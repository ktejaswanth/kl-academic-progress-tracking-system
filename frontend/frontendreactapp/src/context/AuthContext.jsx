import React, { createContext, useState, useContext, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();

    useEffect(() => {
        const storedUser = localStorage.getItem('user');
        if (storedUser) {
            const userData = JSON.parse(storedUser);
            setUser(userData);
            // Configure axios header
            api.defaults.headers.common['Authorization'] = `Bearer ${userData.token}`;
        }
        setLoading(false);
    }, []);

    const login = async (username, password) => {
        try {
            const response = await api.post('/api/auth/login', { username, password });
            const userData = response.data;
            setUser(userData);
            localStorage.setItem('user', JSON.stringify(userData));
            api.defaults.headers.common['Authorization'] = `Bearer ${userData.token}`;
            
            if (userData.forcePasswordChange) {
                navigate('/change-password');
            } else {
                navigate(`/${userData.role.toLowerCase()}/dashboard`);
            }
            return { success: true };
        } catch (error) {
            return { success: false, message: error.response?.data || 'Login failed' };
        }
    };

    const logout = () => {
        setUser(null);
        localStorage.removeItem('user');
        delete api.defaults.headers.common['Authorization'];
        navigate('/login');
    };

    return (
        <AuthContext.Provider value={{ user, login, logout, loading }}>
            {!loading && children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => useContext(AuthContext);
