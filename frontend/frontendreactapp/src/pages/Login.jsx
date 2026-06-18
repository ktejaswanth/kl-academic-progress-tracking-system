import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import './login.css';

export default function Login() {
    const [credentials, setCredentials] = useState({ username: '', password: '' });
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const { login } = useAuth();
    const navigate = useNavigate();

    const handleChange = (e) => {
        setCredentials({ ...credentials, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        try {
            const userData = await login(credentials.username, credentials.password);
            
            if (userData.forcePasswordChange) {
                navigate('/change-password');
                return;
            }

            // Route based on role
            if (userData.role === 'SUPER_ADMIN') {
                navigate('/super_admin/home');
            } else if (userData.role === 'FACULTY') {
                navigate('/faculty/home');
            } else if (userData.role === 'STUDENT') {
                navigate('/student/home');
            } else {
                setError('Unknown user role. Please contact support.');
            }
        } catch (err) {
            setError(err.response?.data || 'Invalid username or password.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-page">
            <div className="login-visual">
                <div className="visual-content">
                    <h1>Academic Audit <span className="highlight">Platform</span></h1>
                    <p>Track progress, manage identities, and audit academic records with precision.</p>
                </div>
                <div className="visual-overlay"></div>
            </div>
            
            <div className="login-form-container animate-fade">
                <div className="login-card">
                    <div className="logo-section">
                        <div className="logo-icon">KL</div>
                        <h2>Welcome Back</h2>
                        <p>Sign in to your account</p>
                    </div>

                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>Student ID / Username</label>
                            <input 
                                type="text" 
                                name="username" 
                                className="input-field"
                                placeholder="Enter your ID"
                                value={credentials.username}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Password</label>
                            <input 
                                type="password" 
                                name="password" 
                                className="input-field"
                                placeholder="••••••••"
                                value={credentials.password}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        
                        {error && <div className="login-error">{error}</div>}

                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? "Authenticating..." : "Sign In"}
                        </button>
                    </form>

                    <div className="login-footer">
                        <p>Forgot password? <a href="/forgot-password">Recover Account</a></p>
                        <p>First time here? <a href="/first-login">Verify your account</a></p>
                    </div>
                </div>
            </div>
        </div>
    );
}
