import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import api from '../api';
import './login.css';

export default function CreatePassword() {
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const stored = localStorage.getItem('firstLoginUser');
    const user = stored ? JSON.parse(stored) : null;

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError('');
        if (!user) {
            setError('Login verification required.');
            return;
        }
        if (password.length < 6) {
            setError('Password must be at least 6 characters long.');
            return;
        }
        if (password !== confirmPassword) {
            setError('Passwords do not match.');
            return;
        }

        setLoading(true);
        try {
            await api.post('/onboarding/complete-first-login', {
                userId: user.userId,
                password,
                confirmPassword
            });
            localStorage.setItem('firstLoginUser', JSON.stringify(user));
            navigate('/profile-setup');
        } catch (err) {
            setError(err.response?.data || 'Failed to complete first login.');
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
                        <h2>Create Your Password</h2>
                        <p>Set a secure password to continue to your profile setup.</p>
                    </div>
                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>New Password</label>
                            <input
                                type="password"
                                className="input-field"
                                value={password}
                                onChange={(e) => setPassword(e.target.value)}
                                required
                            />
                        </div>
                        <div className="form-group">
                            <label>Confirm Password</label>
                            <input
                                type="password"
                                className="input-field"
                                value={confirmPassword}
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                required
                            />
                        </div>
                        {error && <div className="login-error">{error}</div>}
                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? 'Saving...' : 'Continue to Profile Setup'}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
