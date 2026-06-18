import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './login.css';

export default function FirstLogin() {
    const [credentials, setCredentials] = useState({ username: '', dateOfBirth: '' });
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const handleChange = (e) => {
        setCredentials({ ...credentials, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');

        try {
            const response = await api.post('/onboarding/verify-first-login', credentials);
            const body = response.data;
            if (!body.firstLoginCompleted) {
                localStorage.setItem('firstLoginUser', JSON.stringify(body));
                navigate('/create-password');
            } else {
                navigate('/login');
            }
        } catch (err) {
            setError(err.response?.data || 'Invalid Student ID or DOB.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="login-page">
            <div className="login-form-container animate-fade">
                <div className="login-card">
                    <div className="logo-section">
                        <div className="logo-icon">KL</div>
                        <h2>Student First Login</h2>
                        <p>Verify your identity using Student ID and Date of Birth.</p>
                    </div>
                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>Student ID</label>
                            <input
                                type="text"
                                name="username"
                                className="input-field"
                                placeholder="Enter Student ID"
                                value={credentials.username}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Date of Birth</label>
                            <input
                                type="date"
                                name="dateOfBirth"
                                className="input-field"
                                value={credentials.dateOfBirth}
                                onChange={handleChange}
                                required
                            />
                        </div>
                        {error && <div className="login-error">{error}</div>}
                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? 'Verifying...' : 'Verify Credentials'}
                        </button>
                    </form>
                    <div className="login-footer">
                        <p>Already have a password? <a href="/login">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    );
}
