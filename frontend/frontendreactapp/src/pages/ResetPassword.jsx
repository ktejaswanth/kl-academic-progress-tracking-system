import React, { useState } from 'react';
import { useSearchParams, useNavigate } from 'react-router-dom';
import api from '../api';
import './login.css';

export default function ResetPassword() {
    const [searchParams] = useSearchParams();
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [message, setMessage] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);
    const navigate = useNavigate();

    const token = searchParams.get('token');

    const handleSubmit = async (e) => {
        e.preventDefault();
        if (newPassword !== confirmPassword) {
            setError("Passwords do not match.");
            return;
        }

        setLoading(true);
        setMessage('');
        setError('');
        try {
            await api.post(`/auth/reset-password?token=${token}&newPassword=${newPassword}`);
            setMessage("Password reset successfully! Redirecting to login...");
            setTimeout(() => navigate('/login'), 3000);
        } catch (err) {
            setError(err.response?.data || "Failed to reset password. The token may be expired (20 min limit).");
        } finally {
            setLoading(false);
        }
    };

    if (!token) return <div className="login-page"><div className="alert error">Invalid reset link. No token found.</div></div>;

    return (
        <div className="login-page">
            <div className="login-form-container animate-fade">
                <div className="login-card">
                    <div className="logo-section">
                        <div className="logo-icon">KL</div>
                        <h2>Set New Password</h2>
                        <p>Token valid for 20 minutes</p>
                    </div>

                    <form onSubmit={handleSubmit}>
                        <div className="form-group">
                            <label>New Password</label>
                            <input 
                                type="password" 
                                className="input-field"
                                placeholder="••••••••"
                                value={newPassword}
                                onChange={(e) => setNewPassword(e.target.value)}
                                required
                                minLength={6}
                            />
                        </div>

                        <div className="form-group">
                            <label>Confirm Password</label>
                            <input 
                                type="password" 
                                className="input-field"
                                placeholder="••••••••"
                                value={confirmPassword}
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                required
                            />
                        </div>

                        {message && <div className="alert success">{message}</div>}
                        {error && <div className="alert error">{error}</div>}

                        <button type="submit" className="btn-primary login-btn" disabled={loading}>
                            {loading ? "Resetting..." : "Update Password"}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
