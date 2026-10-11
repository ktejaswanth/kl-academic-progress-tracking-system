import axios from 'axios';

const api = axios.create({
    baseURL: '/api',
});

// Automatically add JWT token or onboarding token to every request
api.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    } else {
        const firstLoginUser = localStorage.getItem('firstLoginUser');
        if (firstLoginUser) {
            try {
                const parsed = JSON.parse(firstLoginUser);
                if (parsed && parsed.token) {
                    config.headers['X-Onboarding-Token'] = parsed.token;
                }
            } catch (e) {}
        }
    }
    return config;
}, (error) => {
    return Promise.reject(error);
});

// Handle unauthorized responses (expired tokens)
api.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 401) {
            const url = error.config?.url || '';
            const isOnboarding = url.includes('/onboarding') || url.includes('/verify-first-login');
            if (!isOnboarding) {
                localStorage.removeItem('token');
                window.location.href = '/login';
            }
        }
        return Promise.reject(error);
    }
);

export default api;
